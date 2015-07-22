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
 * @author    Alissa Nedossekina <alisa@purdue.edu>
 * @copyright Copyright 2005-2011 Purdue University. All rights reserved.
 * @license   http://www.gnu.org/licenses/lgpl-3.0.html LGPLv3
 */

// Check to ensure this file is included in Joomla!
defined('_JEXEC') or die( 'Restricted access' );

/**
 * Table class for publications
 */
class Publication extends JTable
{
	/**
	 * int(11) Primary key
	 *
	 * @var integer
	 */
	var $id         		= NULL;

	/**
	 * Category ID (former resource type)
	 *
	 * @var integer
	 */
	var $category        	= NULL;

	/**
	 * Publication alias name, varchar(100)
	 *
	 * @var string
	 */
	var $alias       		= NULL;

	/**
	 * Project id
	 *
	 * @var integer
	 */
	var $project_id       	= NULL;

	/**
	 * Access
	 *
	 * @var integer
	 */
	var $access        		= NULL;

	/**
	 * Created by user ID
	 *
	 * @var integer
	 */
	var $created_by        = NULL;

	/**
	 * Created, datetime (0000-00-00 00:00:00)
	 *
	 * @var datetime
	 */
	var $created			= NULL;

	/**
	 * Checked out by user ID
	 *
	 * @var integer
	 */
	var $checked_out        = NULL;

	/**
	 * Checked out time, datetime (0000-00-00 00:00:00)
	 *
	 * @var datetime
	 */
	var $checked_out_time	= NULL;

	/**
	 * Publication rating
	 *
	 * @var decimal
	 */
	var $rating				= NULL;

	/**
	 * Times rated
	 *
	 * @var integer
	 */
	var $times_rated        = NULL;

	/**
	 * Ranking
	 *
	 * @var float
	 */
	var $ranking        	= NULL;

	/**
	 * Group owner
	 *
	 * @var integer
	 */
	var $group_owner       	= NULL;

	/**
	 * Constructor
	 *
	 * @param      object &$db JDatabase
	 * @return     void
	 */
	public function __construct( &$db )
	{
		parent::__construct( '#__publications', 'id', $db );
	}

	/**
	 * Load by alias
	 *
	 * @param      string 	$oid
	 * @return     object or FALSE
	 */
	public function loadAlias( $oid=NULL )
	{
		if ($oid === NULL)
		{
			return false;
		}
		$this->_db->setQuery( "SELECT * FROM $this->_tbl WHERE alias='$oid'" );
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
	 * Check for missing fields
	 *
	 * @return     boolean true or false
	 */
	public function check()
	{
		if (trim( $this->title ) == '')
		{
			$this->setError( 'Your Publication must contain a title.' );
			return false;
		}
		return true;
	}

	/**
	 * Build query
	 *
	 * @param      array 		$filters
	 * @param      array 		$usergroups
	 * @return     query string
	 */
	public function buildQuery( $filters = array(), $usergroups = array(), $admin = false )
	{
		$juser 		= JFactory::getUser();
		$now 		= JFactory::getDate()->toSql();
		$restricted = 0;
		$groupby 	= ' GROUP BY C.id ';

		$project 		= isset($filters['project']) && intval($filters['project']) ? $filters['project'] : "";
		$dev 			= isset($filters['dev']) && $filters['dev'] == 1 ? 1 : 0;
		$projects 		= isset($filters['projects']) && !empty($filters['projects']) ? $filters['projects'] : array();
		$mine 			= isset($filters['mine']) && $filters['mine'] ? $filters['mine'] : 0;
		$coauthor 		= isset($filters['coauthor']) && $filters['coauthor'] == 1 ? 1 : 0;
		$sortby  		= isset($filters['sortby']) ? $filters['sortby'] : 'title';

		$query  = "FROM ";
		if (isset($filters['tag']) && $filters['tag'] != '')
		{
			$query .= "#__tags_object AS RTA ";
			$query .= "INNER JOIN #__tags AS TA ON RTA.tagid = TA.id AND RTA.tbl='publications', ";
		}

		$query .= " #__publication_versions as V, #__projects as PP,
				  #__publication_master_types AS MT";
		if (isset($filters['author']) && intval($filters['author']))
		{
			$query .= ", #__publication_authors as A ";
		}
		$query .= ", $this->_tbl AS C ";

		$query .= "LEFT JOIN #__publication_categories AS t ON t.id=C.category ";
		$query .= " WHERE V.publication_id=C.id AND MT.id=C.master_type AND PP.id = C.project_id ";

		if ($dev)
		{
			$query .= " AND V.main=1 ";
			if (isset($filters['status']) && $filters['status'] != 'all')
			{
				if (is_array($filters['status']))
				{
					$squery = '';
					foreach ($filters['status'] as $s)
					{
						$squery .= "'" . $s . "',";
					}
					$squery = substr($squery, 0, strlen($squery) - 1);
					$query .= " AND (V.state IN (" . $squery . ")) ";
				}
				else
				{
					$query .= " AND V.state=" . intval($filters['status']);
				}
			}
			if ($mine)
			{
				if (count($projects) > 0 )
				{
					$p_query = '';
					foreach ($projects as $p)
					{
						$p_query .= "'".$p."',";
					}
					$p_query = substr($p_query,0,strlen($p_query) - 1);
					$query .= " AND (C.project_id IN (".$p_query.")) ";
					$query .= $coauthor
							? " AND C.created_by != ".intval($filters['mine'])
							: " AND C.created_by=".intval($filters['mine']);
				}
				else
				{
					$query .= $coauthor ? " AND 2=1" : " AND C.created_by=".intval($filters['mine']);
				}
			}
			// Individual assigned curator?
			if (isset($filters['curator']))
			{
				if ($filters['curator'] == 'owner')
				{
					$query .=" AND V.curator = " . $juser->get('id');
				}
				if ($filters['curator'] == 'other')
				{
					$query .=" AND V.curator != " . $juser->get('id');
				}
			}
		}
		else
		{
			$query .= " AND V.version_number = (SELECT MAX(version_number) FROM #__publication_versions
						WHERE publication_id=C.id AND state=1 ) AND (V.state=1";
			if (count($projects) > 0 )
			{
				$p_query = '';
				foreach ($projects as $p)
				{
					$p_query .= "'".$p."',";
				}
				$p_query = substr($p_query,0,strlen($p_query) - 1);
				$query .= " OR (C.project_id IN (".$p_query.") AND V.state != 3 AND V.state != 2) ";
			}
			$query .= ") ";
		}

		$query .= $project ? " AND C.project_id=".$project : "";

		// Category
		if (isset($filters['category']) && $filters['category'] != '')
		{
			if (is_numeric($filters['category']))
			{
				$query .= " AND C.category=".$filters['category']." ";
			}
			else
			{
				$query .= " AND t.url_alias='".$filters['category']."' ";
			}
		}
		if (isset($filters['author']) && intval($filters['author']))
		{
			$query .= " AND A.publication_version_id=V.id AND A.user_id=" . $filters['author'];
			$query .= " AND A.status=1 AND (A.role IS NULL OR A.role!='submitter') ";
		}

		// Master type
		if (isset($filters['master_type']) && $filters['master_type'] != '')
		{
			if (is_array($filters['master_type']) && !empty($filters['master_type']))
			{
				$tquery = '';
				foreach ($filters['master_type'] as $type)
				{
					$tquery .= "'".$type."',";
				}
				$tquery = substr($tquery,0,strlen($tquery) - 1);
				$query .= " AND ((C.master_type IN (" . $tquery . ") ) ";
			}
			elseif (is_numeric($filters['master_type']))
			{
				$query .= " AND (C.master_type=".$filters['master_type']." ";
			}
			elseif (is_string($filters['master_type']))
			{
				$query .= " AND (MT.alias='".$filters['master_type']."' ";
			}
			else
			{
				$query .= " AND (1=1";
			}
			$query .= " OR V.curator = " . $juser->get('id') . ") ";
		}

		if (isset($filters['minranking']) && $filters['minranking'] != '' && $filters['minranking'] > 0)
		{
			$query .= " AND C.ranking > ".$filters['minranking']." ";
		}
		if (!$dev)
		{
			$query .= " AND (V.published_up = '0000-00-00 00:00:00' OR V.published_up <= '".$now."') ";
			$query .= " AND (V.published_down IS NULL OR V.published_down = '0000-00-00 00:00:00' OR V.published_down >= '".$now."') ";
		}
		if (isset($filters['startdate']))
		{
			$query .= "AND V.published_up > " . $this->_db->Quote($filters['startdate']) . " ";
		}
		if (isset($filters['enddate']))
		{
			$query .= "AND V.published_up < " . $this->_db->Quote($filters['enddate']) . " ";
		}
		if (isset($filters['search']) && $filters['search'] != '')
		{
				$words = array();
				$ws = explode(' ', $filters['search']);
				foreach ($ws as $w)
				{
					$w = trim($w);
					if (strlen($w) > 2)
					{
						$words[] = $w;
					}
				}
				$text = implode(' +', $words);
				$text = addslashes($text);
				$text2 = str_replace('+', '', $text);

				$query .= " AND ((MATCH(V.title) AGAINST ('+$text -\"$text2\"') > 0) OR"
						 . " (MATCH(V.abstract,V.description) AGAINST ('+$text -\"$text2\"') > 0)) ";
		}

		// Do not show deleted
		if ($admin == false || (isset($filters['status']) && $filters['status'] != 2))
		{
			$query .= " AND V.state != 2 ";
		}

		if (!isset($filters['ignore_access']) || $filters['ignore_access'] == 0)
		{
			$query .= " AND (V.access != 3)  ";
		}
		if (isset($filters['tag']) && $filters['tag'] != '')
		{
			include_once( JPATH_ROOT . DS . 'components' . DS . 'com_publications' . DS . 'helpers' . DS . 'tags.php' );
			$tagging = new PublicationTags( $this->_db );
			$tags = $tagging->_parse_tags($filters['tag']);

			$query .= "AND RTA.objectid=C.id AND TA.tag IN ('" . implode("','", $tags) . "')";
			$groupby = " GROUP BY C.id HAVING uniques=".count($tags);
		}

		$query .= $groupby;
		if (!isset($filters['count']) or $filters['count'] == 0)
		{
			$query  .= " ORDER BY ";
			$sortdir = isset($filters['sortdir']) ? $filters['sortdir'] : 'ASC';

			switch ($sortby)
			{
				case 'date':
				case 'date_published':
					$query .= 'V.published_up DESC';

					break;

				case 'date_oldest':
					$query .= 'V.published_up ASC';

					break;

				case 'date_accepted':
					$query .= 'V.accepted DESC';
					break;

				case 'date_created':
					$query .= 'C.created DESC';
					break;

				case 'date_version_created':
					$query .= 'V.created DESC';
					break;

				case 'date_modified':
					$query .= 'V.modified DESC';
					break;

				case 'title':
				default:
					$query .= 'V.title '.$sortdir.', V.version_number DESC';
					break;

				case 'id':
					$query .= 'C.id '.$sortdir;
					break;

				case 'mine':
					$query .= 'PP.provisioned DESC, V.title '.$sortdir.', V.version_number DESC';
					break;

				case 'rating':
					$query .= "C.rating DESC, C.times_rated DESC";
					break;

				case 'ranking':
					$query .= "C.ranking DESC";
					break;

				case 'project':
					$query .= "PP.title ".$sortdir;
					break;

				case 'version_ranking':
					$query .= "V.ranking DESC";
					break;

				case 'popularity':
					$query .= "stat DESC, V.published_up ASC";
					break;

				case 'category':
					$query .= "C.category ".$sortdir;
					break;

				case 'type':
					$query .= "C.master_type ".$sortdir;
					break;

				case 'status':
					$query .= "V.state ".$sortdir;
					break;

				case 'random':
					$query .= "RAND()";
					break;

				case 'submitted':
					$query .= "V.submitted ".$sortdir;
					break;
			}
		}

		return $query;
	}

	/**
	 * Get record count
	 *
	 * @param      array 		$filters
	 * @param      array 		$usergroups
	 * @param      boolean		$admin
	 * @return     object
	 */
	public function getCount( $filters = array(), $usergroups = array(), $admin = false )
	{
		$filters['count'] = 1;
		$query = $this->buildQuery( $filters, $usergroups, $admin );

		$sql  = "SELECT C.id";
		$sql .= (isset($filters['tag']) && $filters['tag'] != '') ? ", TA.tag, COUNT(DISTINCT TA.tag) AS uniques ".$query : " ".$query;

		$this->_db->setQuery( $sql );
		return $this->_db->loadObjectList();
	}

	/**
	 * Get records
	 *
	 * @param      array 		$filters
	 * @param      array 		$usergroups
	 * @param      boolean		$admin
	 * @return     object
	 */
	public function getRecords( $filters = array(), $usergroups = array(), $admin = false )
	{
		$sql  = "SELECT V.*, C.id as id, C.category, C.project_id, C.access as master_access,
				C.checked_out, C.checked_out_time, C.rating as master_rating,
				C.group_owner, C.master_type, C.master_doi,
				C.ranking as master_ranking, C.times_rated as master_times_rated,
				C.alias, V.id as version_id, t.name AS cat_name, t.alias as cat_alias,
				t.url_alias as cat_url, PP.alias as project_alias, PP.title as project_title,
				PP.state as project_status, PP.private as project_private,
				PP.provisioned as project_provisioned, MT.alias as base";
		$sql .= ", (SELECT vv.version_label FROM #__publication_versions as vv WHERE vv.publication_id=C.id AND vv.state=3 ) AS dev_version_label ";
		$sql .= ", (SELECT COUNT(*) FROM #__publication_versions WHERE publication_id=C.id AND state!=3 ) AS versions ";

		$sortby  = isset($filters['sortby']) ? $filters['sortby'] : 'title';

		if ($sortby == 'popularity')
		{
			$sql .= ", (SELECT S.users FROM #__publication_stats AS S WHERE S.publication_id=C.id AND S.period=14 ORDER BY S.datetime DESC LIMIT 1) as stat ";
		}

	//	$sql .= ", (SELECT MAX(version_number) FROM #__publication_versions WHERE publication_id=C.id AND state=1 ) AS latest ";
		$sql .= (isset($filters['tag']) && $filters['tag'] != '') ? ", TA.tag, COUNT(DISTINCT TA.tag) AS uniques " : " ";
		$sql .= $this->buildQuery( $filters, $usergroups, $admin );
		$start = isset($filters['start']) ? $filters['start'] : 0;
		$sql .= (isset($filters['limit']) && $filters['limit'] > 0) ? " LIMIT " . $start . ", " . $filters['limit'] : "";

		$this->_db->setQuery( $sql );
		return $this->_db->loadObjectList();
	}

	/**
	 * Get provisioned publication
	 *
	 * @param      integer		$pid
	 * @param      boolean		$getid
	 * @return     object
	 */
	public function getProvPublication($pid = 0, $getid = false)
	{
		if (!$pid)
		{
			return false;
		}

		$query  = "SELECT ";
		$query .= $getid ? " pub.id " : " V.*, pub.* ";
		$query .= " FROM #__publication_versions as V, $this->_tbl AS pub ";
		$query .= " JOIN #__projects AS p ON pub.project_id=p.id ";
		$query .= " WHERE V.publication_id=pub.id AND V.main=1 AND p.id=".$pid." LIMIT 1 ";

		$this->_db->setQuery( $query );
		if ($getid)
		{
			return $this->_db->loadResult();
		}
		else
		{
			$result = $this->_db->loadObjectList();
			return $result ? $result[0] : array();
		}
	}

	/**
	 * Get publication
	 *
	 * @param      integer		$pid
	 * @param      string		$version
	 * @param      integer		$project_id
	 * @param      string		$alias
	 * @return     object
	 */
	public function getPublication ( $pid = NULL, $version = 'default', $project_id = NULL, $alias = NULL )
	{
		if ($pid === NULL)
		{
			$pid = $this->id;
		}
		if (($pid === NULL or $pid == 0) && $alias === NULL )
		{
			return false;
		}

		$now = JFactory::getDate()->toSql();
		$alias = str_replace( ':', '-', $alias );

		$sql  = "SELECT V.*, C.id as id, C.category, C.master_type,
				C.project_id, C.access as master_access, C.master_doi,
				C.checked_out, C.checked_out_time, C.rating as master_rating,
				C.ranking as master_ranking, C.times_rated as master_times_rated,
				C.alias, V.id as version_id, C.group_owner,
				t.name AS cat_name, t.alias as cat_alias, t.url_alias as cat_url,
				MT.alias as base, MT.curatorgroup, PP.alias as project_alias,
				PP.title as project_title, PP.state as project_status,
				PP.provisioned as project_provisioned,
				PP.private as project_private,
				PP.owned_by_group as project_group ";

		$sql .= ",(SELECT vv.version_label FROM #__publication_versions as vv
				WHERE vv.publication_id=C.id AND (vv.state = 3 OR vv.state = 5)) AS dev_version_label ";
		$sql .= ",(SELECT vv.state FROM #__publication_versions as vv WHERE vv.publication_id=C.id AND vv.main=1)
				AS default_version_status ";
		$sql .= ",(SELECT COUNT(*) FROM #__publication_versions WHERE publication_id=C.id AND state!=3 ) AS versions ";
		$sql .= " FROM #__publication_versions as V, #__projects AS PP, #__publication_master_types AS MT, $this->_tbl AS C ";
		$sql .= " JOIN #__publication_categories AS t ON C.category=t.id ";
		$sql .= " WHERE V.publication_id=C.id AND MT.id=C.master_type AND PP.id=C.project_id ";
		if ($version == 'default' or $version == 'current' && $version == 'main')
		{
			$sql.= " AND V.main=1 ";
		}
		elseif ($version == 'dev')
		{
			$sql.= " AND V.state=3 ";
		}
		elseif (intval($version))
		{
			$sql.= " AND V.version_number='".$version."' ";
		}
		else
		{
			// Error in supplied version value
			$sql.= " AND 1=2 ";
		}
		$sql .= $project_id ? " AND C.project_id=".$project_id : "";
		$sql .= $pid ? " AND C.id=".$pid : " AND C.alias='".$alias."'";
		$sql .= " LIMIT 1";

		$this->_db->setQuery( $sql );
		$result = $this->_db->loadObjectList();
		return $result ? $result[0] : false;
	}

	/**
	 * Calculate rating
	 *
	 * @return     integer
	 */
	public function calculateRating()
	{
		$this->_db->setQuery( "SELECT rating FROM #__publication_ratings WHERE publication_id='$this->id'" );
		$ratings = $this->_db->loadObjectList();

		$totalcount = count($ratings);
		$totalvalue = 0;

		// Add the ratings up
		foreach ($ratings as $item)
		{
			$totalvalue = $totalvalue + $item->rating;
		}

		// Find the average of all ratings
		$newrating = ($totalcount > 0) ? $totalvalue / $totalcount : 0;

		// Round to the nearest half
		$newrating = ($newrating > 0) ? round($newrating*2)/2 : 0;

		// Update page with new rating
		$this->rating = $newrating;
		$this->times_rated = $totalcount;
	}

	/**
	 * Update rating
	 *
	 * @return     void
	 */
	public function updateRating()
	{
		$this->_db->setQuery( "UPDATE $this->_tbl SET rating='$this->rating', times_rated='$this->times_rated' WHERE id='$this->id'" );
		if (!$this->_db->query())
		{
			echo $this->_db->getErrorMsg();
			exit;
		}
	}

	/**
	 * Delete publication existence
	 *
	 * @param      integer 		$id
	 * @return     void
	 */
	public function deleteExistence( $id = NULL )
	{
		if (!$id)
		{
			$id = $this->id;
		}

		// Delete child associations
		/*
		$this->_db->setQuery( "DELETE FROM #__publication_assoc WHERE child_version_id=".$id );
		if (!$this->_db->query())
		{
			echo $this->_db->getErrorMsg();
			exit;
		}
		// Delete parent associations
		$this->_db->setQuery( "DELETE FROM #__publication_assoc WHERE publication_version_id=".$id );
		if (!$this->_db->query())
		{
			echo $this->_db->getErrorMsg();
			exit;
		}
		*/

		// Delete tag associations
		$this->_db->setQuery( "DELETE FROM #__tags_object WHERE tbl='publications' AND objectid=".$id );
		if (!$this->_db->query())
		{
			echo $this->_db->getErrorMsg();
			exit;
		}
		// Delete ratings
		$this->_db->setQuery( "DELETE FROM #__publication_ratings WHERE publication_id=".$id );
		if (!$this->_db->query())
		{
			echo $this->_db->getErrorMsg();
			exit;
		}
	}

	/**
	 * Get top-level publication stats
	 *
	 * @param      array 	$validProjects
	 * @param      string 	$get
	 * @return     mixed
	 */
	public function getPubStats ( $validProjects = array(), $get = 'total', $when = NULL)
	{
		if (empty($validProjects))
		{
			return NULL;
		}

		if ($get == 'usage')
		{
			$query  = " SELECT COUNT( DISTINCT p.id) as used ";
			$query .= " FROM #__projects as p ";
			$query .= " JOIN $this->_tbl as pub ON p.id = pub.project_id  ";
			$query .= " WHERE p.state != 2 ";
			if (!empty($validProjects))
			{
				$query .= " AND p.id IN ( ";

				$tquery = '';
				foreach ($validProjects as $v)
				{
					$tquery .= "'".$v."',";
				}
				$tquery = substr($tquery,0,strlen($tquery) - 1);
				$query .= $tquery.") ";
			}
			$query .= " GROUP BY p.id ";
			$this->_db->setQuery( $query );
			$result = $this->_db->loadObjectList();
			return count($result);
		}

		$query  = " SELECT COUNT(P.id) as pubs ";
		$query .= " FROM $this->_tbl as P ";

		if ($get == 'advanced' || $get == 'released')
		{
			$query .= " JOIN #__publication_versions as V ON V.publication_id = P.id  ";
		}

		$query .= " WHERE 1=1 ";

		if (!empty($validProjects))
		{
			$query .= " AND P.project_id IN ( ";

			$tquery = '';
			foreach ($validProjects as $v)
			{
				$tquery .= "'".$v."',";
			}
			$tquery = substr($tquery,0,strlen($tquery) - 1);
			$query .= $tquery.") ";
		}

		if ($get == 'advanced' || $get == 'released')
		{
			$query .= $get == 'advanced' ? " AND (V.state = 4 OR V.state = 6 OR V.state = 5)  " : " AND V.state = 1 AND V.main = 1";

			if ($when)
			{
				$query .= " AND V.published_up LIKE '" . $when . "%' ";
			}
		}

		if ($get == 'average')
		{
			$query .= " GROUP BY P.project_id ";
		}

		$this->_db->setQuery( $query );

		if ($get == 'total' || $get == 'released' || $get == 'draft')
		{
			return $this->_db->loadResult();
		}
		elseif ($get == 'average' || $get == 'advanced' || $get == 'released')
		{
			$result = $this->_db->loadObjectList();

			if ($get == 'draft' || $get == 'released')
			{
				return count($result);
			}

			$c = 0;
			$d = 0;

			foreach ($result as $r)
			{
				$c = $c + $r->pubs;
				$d++;
			}

			return $d ? number_format($c/$d,0) : 0;
		}
	}
}