<?php
/**
 * @package     hubzero-cms
 * @author      Alissa Nedossekina <alisa@purdue.edu>
 * @copyright   Copyright 2005-2011 Purdue University. All rights reserved.
 * @license     http://www.gnu.org/licenses/lgpl-3.0.html LGPLv3
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
 */

// Check to ensure this file is included in Joomla!
defined('_JEXEC') or die( 'Restricted access' );


class Order extends JTable 
{
	var $id         		= NULL;  // @var int(11) Primary key
	var $uid    			= NULL;  // @var int(11)
	//var $type    			= NULL;  // @var varchar(20)
	var $total      		= NULL;  // @var int(11)
	var $status     		= NULL;  // @var int(11)
	var $details  			= NULL;  // @var text
	var $email    			= NULL;  // @var varchar(150)
	var $ordered  			= NULL;  // @var datetime
	var $status_changed  	= NULL;  // @var datetime
	var $notes  			= NULL;  // @var text
	
	//----------
	// order status:
	// 0 - 'placed (newly received)'
	// 1 - 'processed' (account debited)
	// 2 - 'cancelled'
	
	public function __construct( &$db ) 
	{
		parent::__construct( '#__orders', 'id', $db );
	}
	
	//-----------
	
	public function getOrderID( $uid, $ordered)
	{	
		if ($uid == null) {
			return false;
		}
		if ($ordered == null) {
			return false;
		}
		
		$sql = "SELECT id FROM $this->_tbl WHERE uid='".$uid."' AND ordered='".$ordered."' ";
		$this->_db->setQuery( $sql);
		return $this->_db->loadResult();
	}
	
	//-----------
	
	public function getOrders( $rtrn='count', $filters)
	{
		switch ($filters['filterby'])
		{
			case 'all': 
				$where = "1=1";
				break;
			case 'new': 
				$where = "m.status=0";
				break;
			case 'processed': 
				$where = "m.status=1";
				break;
			case 'cancelled':
			default: 
				$where = "m.status=2";
				break;
		}
		
		// build count query (select only ID)
		$query_count  = "SELECT count(*) FROM $this->_tbl AS m WHERE ".$where;
	
		$query_fetch = "SELECT m.id, m.uid, m.total, m.status, m.ordered, m.status_changed,  
				(SELECT count(*) FROM #__order_items AS r WHERE r.oid=m.id) AS items"
			. "\n FROM $this->_tbl AS m"
			. "\n WHERE ".$where
			. "\n ORDER BY ".$filters['sortby'];
		
		if ($filters['limit'] && $filters['start']) {
			$query_fetch .= " LIMIT " . $start . ", " . $limit;
		}

		// execute query
		$result = NULL;
		if ($rtrn == 'count') {
			$this->_db->setQuery( $query_count );
			$results = $this->_db->loadResult();
		} else {
			$this->_db->setQuery( $query_fetch );
			$result = $this->_db->loadObjectList();
		}

		return $result;
	}
}

