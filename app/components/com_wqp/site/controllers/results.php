<?php
// Declare the namespace.
namespace Components\Wqp\Site\Controllers;

use Hubzero\Component\SiteController;
use Components\Wqp\Models\Portal;
use Components\Wqp\Models\Station;
use Components\Wqp\Models\Result;
use Request;
use Notify;
use Event;
use Lang;
use User;
use App;

/**
 * Wqp controller for portal results
 * 
 * Accepts an array of configuration values to the constructor. If no config 
 * passed, it will automatically determine the component and controller names.
 * Internally, sets the $database, $user, $view, and component $config.
 * 
 * Executable tasks are determined by method name. All public methods that end in 
 * "Task" (e.g., displayTask, editTask) are callable by the end user.
 * 
 * View name defaults to controller name with layout defaulting to task name. So,
 * a $controller of "One" and a $task of "two" will map to:
 *
 * /{component name}
 *     /{client name}
 *         /views
 *             /one
 *                 /tmpl
 *                     /two.php
 */
class Results extends SiteController
{
	/**
	 * Determine task to perform and execute it.
	 *
	 * @return  void
	 */
	public function execute()
	{
		// Here we're aliasing the task 'add' to 'edit'. When examing
		// this controller, you should not find any method called 'addTask'.
		// Instead, we're telling the controller to execute the 'edit' task
		// whenever a task of 'add' is called.
		$this->registerTask('add', 'edit');

		// Call the parent execute() method. Important! Otherwise, the
		// controller will never actually execute anything.
		parent::execute();
	}

	/**
	 * Default task. Displays a list of results.
	 *
	 * @return	void
	 */
	public function displayTask()
	{
		// Get our model
		// This is the entry point to the database and the 
		// table of results we'll be retrieving data from
		$this->view->model = new Portal();

		// NOTE:
		// A \Hubzero\Component\View object is auto-created when calling
		// execute() on the controller. By default, the view directory is 
		// set to the controller name and layout is set to task name.
		//
		// controller=foo&task=bar   loads a view from:
		//
		//   view/
		//     foo/
		//       tmpl/
		//         bar.php
		//
		// A new layout or name can be chosen by calling setLayout('newlayout')
		// or setName('newname') respectively.

		// Incoming filters
		$this->view->filters = array(
			'station' => Request::getInt('station', '')
		);

		$records = Result::all();

		// IF a station's MonitoringLocationIdentifier was passed in the URL, we load that station and
		// retrieve the results associated with onlt that station.
		if ($station = $this->view->filters['station'])
		{
			$records = Station::oneOrFail($station)->results();
		}

		// Get a list of records
		$this->view->records = $records->paginated()->ordered();

		// Output the view
		// 
		// Make sure we load the correct view. This is for cases where 
		// we may be redirected from editTask(), which can happen if the
		// user is not logged in.
		$this->view
		     ->setLayout('display')
		     ->display();
	}

	/**
	 * Display a form for editing or creating a result entry.
	 *
	 * @return  void
	 */
	public function viewTask()
	{
		// Grab the incoming ID and load the record for viewing
		$id = Request::getInt('id', 0);

		// Make sure the entry exists. If it doesn't, throw
		// a 404 error. This will display the error layout
		// defined in the active template (if defined at all).
		if (!$id)
		{
			App::abort(404, Lang::txt('COM_WQP_RESULT_NOT_FOUND'));
		}

		$this->view->result = Result::oneOrFail($id);

		// Output the view
		$this->view->display();
	}

	/**
	 * Display a form for editing or creating an entry.
	 *
	 * @param   object  $tbl  Result
	 * @return  void
	 */
	public function editTask($tbl=null)
	{
		// Only logged in users!
		if (User::isGuest())
		{
			App::abort(403, Lang::txt('COM_WQP_ERROR_UNAUTHORIZED'));
		}

		// If we're being passed an object, use it instead
		// Thsi means we came from saveTask() and some error occurred.
		// Most likely a missing or incorrect field.
		//
		// If not object passed, then we're most likely creating a new
		// record or editing one for the first time.
		if (!($tbl instanceof Result))
		{
			// Grab the incoming ID and load the record for editing
			$tbl = Result::oneOrNew(Request::getInt('id', 0));
		}

		$this->view->entry = $tbl;

		// Get a list of stations
		$this->view->stations = Station::all();

		// Pass any received errors to the view
		// These will be coming from the editTask()
		foreach ($this->getErrors() as $error)
		{
			Notify::error($error);
		}

		// Output the view
		// 
		// Make sure we load the edit view.
		// This is for cases where saveTask() might encounter a data
		// validation error and fall through to editTask(). Since layout 
		// is auto-assigned the task name, the layout will be 'save' but
		// saveTask has no layout!
		$this->view
		     ->setLayout('edit')
		     ->display();
	}

	/**
	 * Save a result entry to the database and redirect back to
	 * the main view
	 *
	 * @return  void
	 */
	public function saveTask()
	{
		// Only logged in users!
		if (User::isGuest())
		{
			App::abort(403, Lang::txt('COM_WQP_ERROR_UNAUTHORIZED'));
		}

		// [SECURITY] This is a Cross-Site Request Forgery token check
		//
		// This will check if:
		//    1) a CSRF token was passed in the form and
		//    2) the token was valid and tied to the proper user
		//
		// If it fails, it will throw an exception.
		Request::checkToken();

		// Incoming data, specifically from POST
		$data = Request::getVar('entry', array(), 'post', 2, 'none');

		// Bind the incoming data to our model
		//
		// Here, we're calling "oneOrNew" which accepts an ID.
		// If no ID is set, it will return an object with empty values
		// (a new record) otherwise it will attempt to load a record
		// with the specified ID and bind its data to the model.
		//
		// We then set (overwrite) any data on the model with the data
		// coming from the edit form.
		$model = Result::oneOrNew($data['id'])->set($data);

		// Pass the data to any plugins that be respond to the 
		// onBeforeSave event. This is where extra data manipulation 
		// or validation can be done.
		Event::trigger('wqp.onBeforeSave', array($model));

		// Validate and save the data
		//
		// If save() returns false for any reason, me pass the error
		// message from the model to the controller and fall through
		// to the edit form. We pass the existing model to the edit form
		// so it can repopulate the form with the user-submitted data.
		if (!$model->save())
		{
			$this->setError($model->getError());
			$this->editTask($model);
			return;
		}

		// Get all the stations this result has been assigned to.
		//
		// Here we're grabbing the array of stations (checkboxes) and
		// assigning the model to each station. It will also remove any
		// previous assignments not found in the passed-in list.
		$stations = Request::getVar('stations', array(), 'post');

		if (!$model->stations()->sync($stations))
		{
			$this->setError($model->getError());
			$this->editTask($model);
			return;
		}

		// Redirect back to the main listing with a success message
		App::redirect(
			Route::url('index.php?option=' . $this->_option . '&controller=' . $this->_controller, false),
			Lang::txt('COM_WQP_RECORD_SAVED'),
			'passed'  // Accepts passed, warning, or error
		);
	}

	/**
	 * Remove an entry
	 *
	 * @return  void
	 */
	public function deleteTask()
	{
		// Only logged in users!
		if (User::isGuest())
		{
			App::abort(403, Lang::txt('COM_WQP_ERROR_UNAUTHORIZED'));
		}

		// [SECURITY] This is a Cross-Site Request Forgery token check
		//
		// This will check if:
		//    1) a CSRF token was passed in a query string
		//    2) the token was valid and tied to the proper user
		//
		// If it fails, it will throw an exception.
		Request::checkToken('get');

		// Incoming data, specifically from POST
		$id = Request::getInt('id', 0);

		// Check that the record exists. If it doesn't, then
		// we're all done here.
		if (!$id)
		{
			// Redirect back to the main listing
			App::redirect(
				Route::url('index.php?option=' . $this->_option . '&controller=' . $this->_controller, false)
			);
			return;
		}

		// Bind the incoming data to our mdoel
		$model = Result::oneOrFail(intval($id));

		// Remove the entry and associated data
		//
		// If the model fails to remove the entry, it will pass
		// an error message to the cotnroller. The controller 
		// will then pass the error message along with the redirect
		// to the default task. The CMS detects a message has been
		// set and displays it in the template.
		if (!$model->destroy())
		{
			$this->setError($model->getError());
		}

		// Redirect back to the main listing
		App::redirect(
			Route::url('index.php?option=' . $this->_option . '&controller=' . $this->_controller, false),
			($this->getError() ? $this->getError() : Lang::txt('COM_WQP_RECORD_DELETED')),
			($this->getError() ? 'error' : 'passed')
		);
	}
}
