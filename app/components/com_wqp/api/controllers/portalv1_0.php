<?php
namespace Components\Wqp\Api\Controllers;

use Components\Wqp\Models\Station;
use Hubzero\Component\ApiController;
use Request;
use Route;
use App;

require_once(dirname(dirname(__DIR__)) . DS . 'models' . DS . 'portal.php');

/**
 * API controller class for the show
 */
class Portalv1_0 extends ApiController
{
	/**
	 * Display documentation for stations API
	 *
	 * @apiMethod GET
	 * @apiUri    /wqp/stations
	 * @return  void
	 */
	public function stationsTask()
	{
		App::redirect(Request::base() . '/wqp/stations');
	}

	/**
	 * Display documentation for results API
	 *
	 * @apiMethod GET
	 * @apiUri    /wqp/results
	 * @return  void
	 */
	public function resultsTask()
	{
		App::redirect(Request::base() . '/wqp/results');
	}
}
