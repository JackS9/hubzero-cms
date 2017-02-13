<?php
namespace Components\Wqp\Models;

use Hubzero\Database\Relational;
use Session;
use Date;

// Include the models we'll be using
require_once(__DIR__ . '/result.php');

/**
 * Wqp model class for a station
 */
class Station extends Relational
{
	/**
	 * The table namespace
	 *
	 * @var  string
	 **/
	protected $namespace = 'wqp';

	/**
	 * Default order by for model
	 *
	 * @var  string
	 */
	public $orderBy = 'id';

	/**
	 * Fields and their validation criteria
	 *
	 * @var  array
	 */
	protected $rules = array(
		'MonitoringLocationIdentifier' => 'notempty'
	);

	/**
	 * Defines a belongs to one relationship between task and assignee
	 *
	 * @return  object
	 */
	public function creator()
	{
		return $this->belongsToOne('Hubzero\User\User', 'created_by');
	}

	/**
	 * Defines a one to many through relationship with records by way of tasks
	 *
	 * @return  $this
	 */
	public function results()
	{
		return result::all();
	}

	/**
	 * Return a formatted timestamp for the 
	 * created date
	 *
	 * @param   string  $as  What format to return
	 * @return  string
	 */
	public function created($as='')
	{
		return $this->_datetime('created', $as);
	}

	/**
	 * Return a formatted timestamp
	 *
	 * @param   string  $field  Datetime field to use [created]
	 * @param   string  $as     What format to return
	 * @return  string
	 */
	protected function _datetime($field, $as='')
	{
		switch (strtolower($as))
		{
			case 'date':
				return Date::of($this->get($field))->toLocal(Lang::txt('DATE_FORMAT_HZ1'));
			break;

			case 'time':
				return Date::of($this->get($field))->toLocal(Lang::txt('TIME_FORMAT_HZ1'));
			break;

			case 'relative':
				return Date::of($this->get($field))->relative();
			break;

			default:
				if ($as)
				{
					return Date::of($this->get($field))->toLocal($as);
				}
				return $this->get($field);
			break;
		}
	}

	/**
	 * Generate and return various links to the entry
	 * Link will vary depending upon action desired, such as edit, delete, etc.
	 *
	 * @param      string $type   The type of link to return
	 * @param      mixed  $params String or array of extra params to append
	 * @return     string
	 */
	public function link($type='')
	{
		static $base;

		if (!isset($base))
		{
			$base = 'index.php?option=com_wqp';
		}

		$link = $base;

		// If it doesn't exist or isn't published
		switch (strtolower($type))
		{
			case 'edit':
				$link .= '&controller=stations&task=edit&id=' . $this->get('id');
			break;

			case 'delete':
				$link .= '&controller=stations&task=delete&id=' . $this->get('id') . '&' . Session::getFormToken() . '=1';
			break;

			case 'view':
			case 'permalink':
			default:
				$link .= '&controller=results&station=' . $this->get('id');
			break;
		}

		return $link;
	}

	/**
	 * Deletes the existing/current model
	 *
	 * @return  bool
	 */
	public function destroy()
	{
		if (!$this->results()->sync(array()))
		{
			return false;
		}

		return parent::destroy();
	}
}

