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
 * @copyright Copyright 2005-2011 Purdue University. All rights reserved.
 * @license   http://www.gnu.org/licenses/lgpl-3.0.html LGPLv3
 */

namespace Components\Publications\Tables;

/**
 * Table class for available publication handlers
 */
class Handler extends \JTable
{
	/**
	 * Constructor
	 *
	 * @param      object &$db JDatabase
	 * @return     void
	 */
	public function __construct( &$db )
	{
		parent::__construct( '#__publication_handlers', 'id', $db );
	}

	/**
	 * Load handler
	 *
	 * @param      string 	$name 	Alias name of handler
	 *
	 * @return     mixed False if error, Object on success
	 */
	public function loadRecord( $name = NULL )
	{
		if ($name === NULL)
		{
			return false;
		}

		$query = "SELECT * FROM $this->_tbl WHERE name=" . $this->_db->Quote($name);
		$query.= " LIMIT 1";
		$this->_db->setQuery( $query );

		if ($result = $this->_db->loadAssoc())
		{
			return $this->bind( $result );
		}
		else
		{
			$this->setError( $this->_db->getErrorMsg() );
			return false;
		}
	}

	/**
	 * Get connections
	 *
	 * @param      integer 	$vid		pub version id
	 * @param      array 	$find
	 * @return     object
	 */
	public function getHandlers ( $vid = NULL, $elementid = 0 )
	{
		if (!$vid)
		{
			$vid = $this->publication_version_id;
		}

		$query  = "SELECT H.*, IFNULL(A.id, 0) as assigned, IFNULL(A.ordering, 0) as ordering,
				A.params as assigned_params, A.status as active  FROM $this->_tbl as H ";
		$query .= "LEFT JOIN #__publication_handler_assoc as A ON H.id=A.handler_id ";
		$query .= " AND A.publication_version_id=" . $this->_db->Quote($vid)
				. " AND A.element_id=" . $this->_db->Quote($elementid);
		$query .= " WHERE H.status = 1";
		$query .= " ORDER BY assigned DESC, A.ordering ASC";

		$this->_db->setQuery( $query );
		return $this->_db->loadObjectList();
	}

	/**
	 * Load handler config
	 *
	 * @param      string 	$name 	Alias name of handler
	 *
	 * @return     mixed False if error, Object on success
	 */
	public function getConfig( $name = NULL, $entry = NULL )
	{
		if ($name == NULL)
		{
			return false;
		}

		if (!$entry || !is_object($entry))
		{
			$query = "SELECT * FROM $this->_tbl WHERE name=" . $this->_db->Quote($name);
			$query.= " LIMIT 1";

			$this->_db->setQuery( $query );
			$result = $this->_db->loadObjectList();
			$entry = $result ? $result[0] : NULL;
		}

		// Parse configs
		if ($entry)
		{
			$output = array();
			$output['params'] = array();
			foreach ($entry as $field => $value)
			{
				if ($field == 'params')
				{
					$params = json_decode($value, TRUE);
					if (is_array ($params))
					{
						foreach ($params as $paramName => $paramValue)
						{
							$output['params'][$paramName] = $paramValue;
						}
					}
				}
				else
				{
					$output[$field] = $value;
				}
			}

			return $output;
		}

		return false;
	}
}
