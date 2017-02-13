<?php
namespace Components\Wqp\Api\Controllers;

use Components\Wqp\Models\Station;
use Hubzero\Component\ApiController;
use Hubzero\Utility\Date;
use Exception;
use stdClass;
use Request;
use Route;
use Lang;
use App;

require_once(dirname(dirname(__DIR__)) . DS . 'models' . DS . 'portal.php');

/**
 * API controller class for stations
 */
class Stationsv1_0 extends ApiController
{
	/**
	 * Display a list of entries
	 *
	 * @apiMethod GET
	 * @apiUri    /wqp/stations/list
	 * @apiParameter {
	 * 		"name":          "limit",
	 * 		"description":   "Number of result to return.",
	 * 		"type":          "integer",
	 * 		"required":      false,
	 * 		"default":       25
	 * }
	 * @apiParameter {
	 * 		"name":          "start",
	 * 		"description":   "Number of where to start returning results.",
	 * 		"type":          "integer",
	 * 		"required":      false,
	 * 		"default":       0
	 * }
	 * @apiParameter {
	 * 		"name":          "sort",
	 * 		"description":   "Field to sort results by.",
	 * 		"type":          "string",
	 * 		"required":      false,
	 *      "default":       "created",
	 * 		"allowedValues": "created, monitoring_location_identifier, id, publish_up, publish_down, state"
	 * }
	 * @apiParameter {
	 * 		"name":          "sort_Dir",
	 * 		"description":   "Direction to sort results by.",
	 * 		"type":          "string",
	 * 		"required":      false,
	 * 		"default":       "desc",
	 * 		"allowedValues": "asc, desc"
	 * }
	 * @return  void
	 */
	public function listTask()
	{
		$response = new stdClass;
		$response->total = Station::all()->whereEquals('state', 1)->count();

		$record = Station::all()->whereEquals('state', 1);

		if ($limit = Request::getInt('limit', 20))
		{
			$record->limit($limit);
		}
		if ($start = Request::getInt('limitstart', 0))
		{
			$record->start($start);
		}
		if (($orderby  = Request::getWord('sort', 'MonitoringLocationIdentifier'))
		 && ($orderdir = Request::getWord('sortDir', 'ASC')))
		{
			$record->order($orderby, $orderdir);
		}

		$response->records = $record->rows()->toObject();

		if (count($response->records) > 0)
		{
			foreach ($response->records as $i => $entry)
			{
				// TODO: Make Monitoring Location Identifier a valid URL-compatible string
				$response->records[$i]->uri = Route::url('index.php?option=' . $this->_option . '&controller=results&station=' . $entry->MonitoringLocationIdentifier);
			}
		}

		$response->success = true;

		$this->send($response);
	}

	/**
	 * Create an entry
	 *
	 * @apiMethod POST
	 * @apiUri    /wqp/stations
	 * @apiParameter {
	 * 		"name":        "MonitoringLocationIdentifier",
	 * 		"description": "Monitoring Location Identifier",
	 * 		"type":        "string",
	 * 		"required":    true,
	 * 		"default":     null
	 * }
	 * @apiParameter {
	 * 		"name":        "created",
	 * 		"description": "Created timestamp (YYYY-MM-DD HH:mm:ss)",
	 * 		"type":        "string",
	 * 		"required":    false,
	 * 		"default":     "now"
	 * }
	 * @apiParameter {
	 * 		"name":        "crated_by",
	 * 		"description": "User ID of entry creator",
	 * 		"type":        "integer",
	 * 		"required":    false,
	 * 		"default":     0
	 * }
	 * @apiParameter {
	 * 		"name":        "state",
	 * 		"description": "Published state (0 = unpublished, 1 = published)",
	 * 		"type":        "integer",
	 * 		"required":    false,
	 * 		"default":     0
	 * }
	 * @apiParameter {
	 * 		"name":        "LatitudeMeasure",
	 * 		"description": "Latitude Measure",
	 * 		"type":        "string",
	 * 		"required":    false,
	 * 		"default":     null
	 * }
	 * @apiParameter {
	 * 		"name":        "LongitudeMeasure",
	 * 		"description": "Longitude Measure",
	 * 		"type":        "string",
	 * 		"required":    false,
	 * 		"default":     null
	 * }
	 * @return    void
	 */
	public function createTask()
	{
		$this->requiresAuthentication();
		$this->authorizeOrFail();

		$fields = array(
			'MonitoringLocationIdentifier'  => Request::getVar('MonitoringLocationIdentifier', null, 'post', 'none', 2),
			'created'          => Request::getVar('created', with(new Date('now'))->toSql(), 'post'),
			'created_by'       => Request::getInt('created_by', 0, 'post'),
			'state'            => Request::getInt('state', 0, 'post'),
			'LatitudeMeasure'  => Request::getVar('LatitudeMeasure', null, 'post'),
			'LongitudeMeasure' => Request::getVar('LongitudeMeasure', null, 'post')
		);

		// Create object and store content
		$record = Station::oneOrNew(null)->set($fields);

		// Do the actual save
		if (!$record->save())
		{
			App::abort(500, Lang::txt('COM_WQP_ERROR_RECORD_CREATE_FAILED'));
		}

		$this->send($record, 201);
	}

	/**
	 * Retrieve an entry
	 *
	 * @apiMethod GET
	 * @apiUri    /wqp/stations/{id}
	 * @apiParameter {
	 * 		"name":        "id",
	 * 		"description": "Entry identifier",
	 * 		"type":        "integer",
	 * 		"required":    true,
	 * 		"default":     null
	 * }
	 * @return    void
	 */
	public function readTask()
	{
		$id = Request::getInt('id', 0);

		// Error checking
		if (empty($id))
		{
			App::abort(404, Lang::txt('COM_WQP_ERROR_MISSING_ID'));
		}

		try
		{
			$record = Station::oneOrFail($id);
		}
		catch (Hubzero\Error\Exception\RuntimeException $e)
		{
			App::abort(404, Lang::txt('COM_WQP_ERROR_RECORD_NOT_FOUND'));
		}

		$row = $record->toObject();
		$row->uri = Route::url($record->link());

		$this->send($row);
	}

	/**
	 * Update an entry
	 *
	 * @apiMethod PUT
	 * @apiUri    /wqp/stations/{id}
	 * @apiParameter {
	 * 		"name":        "id",
	 * 		"description": "Entry identifier",
	 * 		"type":        "integer",
	 * 		"required":    true,
	 * 		"default":     null
	 * }
	 * @apiParameter {
	 * 		"name":        "MonitoringLocationIdentifier",
	 * 		"description": "Monitoring Location Identifier",
	 * 		"type":        "string",
	 * 		"required":    true,
	 * 		"default":     null
	 * }
	 * @apiParameter {
	 * 		"name":        "created",
	 * 		"description": "Created timestamp (YYYY-MM-DD HH:mm:ss)",
	 * 		"type":        "string",
	 * 		"required":    false,
	 * 		"default":     "now"
	 * }
	 * @apiParameter {
	 * 		"name":        "created_by",
	 * 		"description": "User ID of entry creator",
	 * 		"type":        "integer",
	 * 		"required":    false,
	 * 		"default":     0
	 * }
	 * @apiParameter {
	 * 		"name":        "state",
	 * 		"description": "Published state (0 = unpublished, 1 = published)",
	 * 		"type":        "integer",
	 * 		"required":    false,
	 * 		"default":     0
	 * }
	 * @apiParameter {
	 * 		"name":        "LatitudeMeasure",
	 * 		"description": "Latitude Measure",
	 * 		"type":        "string",
	 * 		"required":    false,
	 * 		"default":     null
	 * }
	 * @apiParameter {
	 * 		"name":        "LongitudeMeasure",
	 * 		"description": "Longitude Measure",
	 * 		"type":        "string",
	 * 		"required":    false,
	 * 		"default":     null
	 * }
	 * @return    void
	 */
	public function updateTask()
	{
		$this->requiresAuthentication();
		$this->authorizeOrFail();

		$id = Request::getInt('id');

		if (!$id)
		{
			App::abort(404, Lang::txt('COM_WQP_ERROR_MISSING_ID'));
		}

		$fields = array(
			'MonitoringLocationIdentifier' => Request::getVar('MonitoringLocationIdentifier', null, 'post', 'none', 2),
			'created'          => Request::getVar('created', with(new Date('now'))->toSql(), 'post'),
			'created_by'       => Request::getInt('created_by', 0, 'post'),
			'state'            => Request::getInt('state', 0, 'post'),
			'LatitudeMeasure'  => Request::getVar('LatitudeMeasure', null, 'post'),
			'LongitudeMeasure' => Request::getVar('LongitudeMeasure', null, 'post')
		);

		// Create object and store content
		$record = Station::oneOrFail($id)->set($fields);

		// Do the actual save
		if (!$record->save())
		{
			App::abort(500, Lang::txt('COM_WQP_ERROR_RECORD_UPDATE_FAILED'));
		}

		$this->send($record, 201);
	}

	/**
	 * Delete an entry
	 *
	 * @apiMethod DELETE
	 * @apiUri    /wqp/stations/{id}
	 * @apiParameter {
	 * 		"name":        "id",
	 * 		"description": "Entry identifier",
	 * 		"type":        "integer",
	 * 		"required":    true,
	 * 		"default":     null
	 * }
	 * @return    void
	 */
	public function deleteTask()
	{
		$this->requiresAuthentication();
		$this->authorizeOrFail();

		$id = Request::getInt('id');

		if (!$id)
		{
			App::abort(404, Lang::txt('COM_WQP_ERROR_MISSING_ID'));
		}

		// Create object and store content
		$record = Station::oneOrFail($id);

		// Do the actual save
		if (!$record->destroy())
		{
			App::abort(500, Lang::txt('COM_WQP_ERROR_RECORD_DELETE_FAILED'));
		}

		$this->send(null, 204);
	}

	/**
	 * Checks to ensure appropriate authorization
	 *
	 * @return  bool
	 * @throws  Exception
	 */
	private function authorizeOrFail()
	{
		// Make sure action can be performed
		if (!User::authorise('core.manage', $this->_option))
		{
			App::abort(401, Lang::txt('COM_WQP_ERROR_UNAUTHORIZED'));
		}

		return true;
	}
}
