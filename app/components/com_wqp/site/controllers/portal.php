<?php
// Declare the namespace.
namespace Components\Wqp\Site\Controllers;

use Hubzero\Component\SiteController;
use Components\Wqp\Models;

/**
 * Wqp controller for the portal
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
class Portal extends SiteController
{
	/**
	 * Default task.
	 *
	 * @return  void
	 */
	public function displayTask()
	{
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

		// Get the portal model and assign it to the view
		$this->view->model = new Models\Portal();

		// Output the view
		$this->view->display();
	}
}
