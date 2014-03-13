<?php
/**
 * HUBzero CMS
 *
 * Copyright 2005-2011 Purdue University. All rights reserved.
 *
 * This file is part of: The HUBzero(R) Platform for Scientific Collaboration
 *
 * The HUBzero(R) Platform for Scientific Collaboration (HUBzero) is free
 * software: you can redistribute it and/or modify it under the terms of
 * the GNU Lesser General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option) any
 * later version.
 *
 * HUBzero is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * HUBzero is a registered trademark of Purdue University.
 *
 * @package   hubzero-cms
 * @author    Christopher Smoak <csmoak@purdue.edu>
 * @copyright Copyright 2005-2011 Purdue University. All rights reserved.
 * @license   http://www.gnu.org/licenses/lgpl-3.0.html LGPLv3
 */

// Check to ensure this file is included in Joomla!
defined('_JEXEC') or die('Restricted access');

// include tables
require_once JPATH_ROOT . DS . 'components' . DS . 'com_events' . DS . 'tables' . DS . 'event.php';

class EventsModelEvent extends \Hubzero\Base\Model
{
	/**
	 * JTable
	 * 
	 * @var string
	 */
	protected $_tbl = null;
	
	/**
	 * Table name
	 * 
	 * @var string
	 */
	protected $_tbl_name = 'EventsEvent';
	
	/**
	 * Constructor
	 * 
	 * @param      mixed     Object Id
	 * @return     void
	 */
	public function __construct( $oid = null )
	{
		// create needed objects
		$this->_db = JFactory::getDBO();
		
		// load page jtable
		$this->_tbl = new $this->_tbl_name($this->_db);
		
		// load object 
		if (is_numeric($oid))
		{
			$this->_tbl->load( $oid );
		}
		else if(is_object($oid) || is_array($oid))
		{
			$this->bind( $oid );
		}
	}
	
	/**
	 * Get Instance this Model
	 *
	 * @param   $key   Instance Key
	 */
	static function &getInstance($key=null)
	{
		static $instances;

		if (!isset($instances)) 
		{
			$instances = array();
		}

		if (!isset($instances[$key])) 
		{
			$instances[$key] = new self($key);
		}
		
		return $instances[$key];
	}

	/**
	 * Return link to event
	 * 
	 * @return string
	 */
	public function link()
	{
		$group = Hubzero\User\Group::getInstance($this->get('scope_id'));
		return JRoute::_('index.php?option=com_groups&cn='.$group->get('cn').'&active=calendar&action=details&event_id='.$this->get('id'));
	}

	/**
	 * Returns calendar for event
	 * 
	 * @return object 
	 */
	public function calendar()
	{
		return EventsModelCalendar::getInstance($this->get('calendar_id'));
	}
}