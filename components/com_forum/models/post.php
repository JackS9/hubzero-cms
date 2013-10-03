<?php
/**
 * HUBzero CMS
 *
 * Copyright 2005-2013 Purdue University. All rights reserved.
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
 * @author    Shawn Rice <zooley@purdue.edu>
 * @copyright Copyright 2005-2013 Purdue University. All rights reserved.
 * @license   http://www.gnu.org/licenses/lgpl-3.0.html LGPLv3
 */

// Check to ensure this file is included in Joomla!
defined('_JEXEC') or die('Restricted access');

require_once(JPATH_ROOT . DS . 'components' . DS . 'com_forum' . DS . 'tables' . DS . 'post.php');
require_once(JPATH_ROOT . DS . 'components' . DS . 'com_forum' . DS . 'models' . DS . 'abstract.php');
require_once(JPATH_ROOT . DS . 'components' . DS . 'com_forum' . DS . 'models' . DS . 'attachment.php');

/**
 * Courses model class for a forum
 */
class ForumModelPost extends ForumModelAbstract
{
	/**
	 * Table class name
	 * 
	 * @var object
	 */
	protected $_tbl_name = 'ForumPost';

	/**
	 * ForumTablePost
	 * 
	 * @var object
	 */
	protected $_base = null;

	/**
	 * Constructor
	 * 
	 * @param      integer $id Post ID, array, or object
	 * @return     void
	 */
	public function __construct($oid)
	{
		parent::__construct($oid);

		switch (strtolower($this->get('scope')))
		{
			case 'group':
				$group = Hubzero_Group::getInstance($this->get('scope_id'));
				$this->_base = 'index.php?option=com_groups&cn=' . $group->get('cn') . '&active=forum';
			break;

			case 'course':
				$offering = CoursesModelOffering::getInstance($this->get('scope_id'));
				$course = CoursesModelCourse::getInstance($offering->get('course_id'));
				$this->_base = 'index.php?option=com_courses&gid=' . $course->get('alias') . '&offering=' . $offering->get('alias') . ($offering->section()->get('alias') != '__default' ? ':' . $offering->section()->get('alias') : '') . '&active=discussions';
			break;

			case 'site':
			default:
				$this->_base = 'index.php?option=com_forum';
			break;
		}
	}

	/**
	 * Returns a reference to a forum post model
	 *
	 * @param      mixed $oid ID (int) or array or object
	 * @return     object ForumModelPost
	 */
	static function &getInstance($oid=0)
	{
		static $instances;

		if (!isset($instances)) 
		{
			$instances = array();
		}

		if (is_numeric($oid) || is_string($oid))
		{
			$key = $oid;
		}
		else if (is_object($oid))
		{
			$key = $oid->id;
		}
		else if (is_array($oid))
		{
			$key = $oid['id'];
		}

		if (!isset($instances[$oid])) 
		{
			$instances[$oid] = new ForumModelPost($oid);
		}

		return $instances[$oid];
	}

	/**
	 * Set and get a specific offering
	 * 
	 * @return     void
	 */
	public function attachment()
	{
		if (!isset($this->_attachment))
		{
			$this->_attachment = ForumModelAttachment::getInstance(0, $this->get('id'));
		}
		return $this->_attachment;
	}

	/**
	 * Return a formatted timestamp
	 * 
	 * @param      string $as What data to return
	 * @return     boolean
	 */
	public function modified($rtrn='')
	{
		switch (strtolower($rtrn))
		{
			case 'date':
				return JHTML::_('date', $this->get('modified'), JText::_('DATE_FORMAT_HZ1'));
			break;

			case 'time':
				return JHTML::_('date', $this->get('modified'), JText::_('TIME_FORMAT_HZ1'));
			break;

			default:
				return $this->get('modified');
			break;
		}
	}

	/**
	 * Determine if record was modified
	 * 
	 * @return     boolean True if modified, false if not
	 */
	public function wasModified()
	{
		if ($this->get('modified') && $this->get('modified') != '0000-00-00 00:00:00')
		{
			return true;
		}
		return false;
	}

	/**
	 * Store changes to this offering
	 *
	 * @param     boolean $check Perform data validation check?
	 * @return    boolean False if error, True on success
	 */
	public function store($check=true)
	{
		$new = true;
		if ($this->get('id'))
		{
			$old = new ForumModelPost($this->get('id'));
			$new = false;
		}

		if (!$this->get('anonymous'))
		{
			$this->set('anonymous', 0);
		}

		if (!parent::store($check))
		{
			return false;
		}

		if (!$new)
		{
			if ($old->get('category_id') != $this->get('category_id'))
			{
				$this->_tbl->updateReplies(array(
					'category_id' => $this->get('category_id'), 
					$this->get('id')
				));
			}
		}

		return true;
	}

	/**
	 * Tag the entry
	 * 
	 * @return     boolean
	 */
	public function tag($tags=null, $user_id=0, $admin=0)
	{
		$cloud = new ForumModelTags($this->get('thread'));

		return $cloud->setTags($tags, $user_id, $admin);
	}

	/**
	 * Generate and return various links to the entry
	 * Link will vary depending upon action desired, such as edit, delete, etc.
	 * 
	 * @param      string $type The type of link to return
	 * @param      mixed  $params Optional string or associative array of params to append
	 * @return     string
	 */
	public function link($type='', $params=null)
	{
		$link  = $this->_base;

		switch (strtolower($this->get('scope')))
		{
			case 'group':
				$link .= '&scope=' . $this->get('section');
				$link .= '/' . $this->get('category');
				$link .= '/' . $this->get('thread');
			break;

			case 'course':
				$link .= '&unit=' . $this->get('section');
				$link .= '&b=' . $this->get('category');
				$link .= '&c=' . $this->get('thread');
			break;

			case 'site':
			default:
				$link .= '&section=' . $this->get('section');
				$link .= '&category=' . $this->get('category');
				$link .= '&thread=' . $this->get('thread');
			break;
		}

		// If it doesn't exist or isn't published
		switch (strtolower($type))
		{
			case 'base':
				return $this->_base;
			break;

			case 'new':
				switch (strtolower($this->get('scope')))
				{
					case 'group':
						$link  = $this->_base;
						$link .= '&scope=' . $this->get('section');
						$link .= '/' . $this->get('category');
						$link .= '/new';
					break;

					case 'course':
						$link  = $this->_base;
						$link .= '&unit=' . $this->get('section');
						$link .= '&b=' . $this->get('category');
						$link .= '&c=new';
					break;

					case 'site':
					default:
						$link  = $this->_base;
						$link .= '&section=' . $this->get('section');
						$link .= '&category=' . $this->get('category');
						$link .= '&task=new';
					break;
				}
			break;

			case 'edit':
				switch (strtolower($this->get('scope')))
				{
					case 'group':
						$link .= '/edit';
					break;

					case 'course':
						$link .= '&c=edit';
					break;

					case 'site':
					default:
						$link  = $this->_base;
						$link .= '&section=' . $this->get('section');
						$link .= '&category=' . $this->get('category');
						$link .= '&thread=' . $this->get('id');
						$link .= '&task=edit';
					break;
				}
			break;

			case 'delete':
				switch (strtolower($this->get('scope')))
				{
					case 'group':
						$link .= '/delete';
					break;

					case 'course':
						$link .= '&c=delete';
					break;

					case 'site':
					default:
						$link  = $this->_base;
						$link .= '&section=' . $this->get('section');
						$link .= '&category=' . $this->get('category');
						$link .= '&thread=' . $this->get('id');
						$link .= '&task=delete';
					break;
				}
			break;

			case 'download':
				switch (strtolower($this->get('scope')))
				{
					case 'group':
						$link .= '/' . $this->get('id') . '/';
					break;

					case 'course':
						$link .= '&post=' . $this->get('id') . '&file=';
					break;

					case 'site':
					default:
						$link .= '&post=' . $this->get('id') . '&file=';
					break;
				}
			break;

			case 'reply':
				switch (strtolower($this->get('scope')))
				{
					case 'group':
						$link .= '?reply=' . $this->get('id');
					break;

					case 'course':
						$link .= '&reply=' . $this->get('id');
					break;

					case 'site':
					default:
						$link .= '&reply=' . $this->get('id');
					break;
				}
			break;

			case 'anchor':
				$link .= '#c' . $this->get('id');
			break;

			case 'abuse':
				return 'index.php?option=com_support&task=reportabuse&category=forum&id=' . $this->get('id') . '&parent=' . $this->get('parent');
			break;

			case 'permalink':
			default:

			break;
		}

		if (is_array($params))
		{
			$bits = array();
			foreach ($params as $key => $param)
			{
				$bits[] = $key . '=' . $param;
			}
			$params = implode('&', $bits);
		}

		if ($params)
		{
			if (strtolower($this->get('scope')) == 'group')
			{
				if (substr($params, 0, 1) == '&')
				{
					$params = substr($params, 1);
				}
				if (substr($params, 0, 1) != '?' && substr($params, 0, 1) != '#')
				{
					$params = '?' . $params;
				}
			}
			else
			{
				if (substr($params, 0, 1) == '?')
				{
					$params = substr($params, 1);
				}
				if (substr($params, 0, 1) != '&' && substr($params, 0, 1) != '#')
				{
					$params = '&' . $params;
				}
			}
		}

		return $link . (string) $params;
	}

	/**
	 * Get the state of the entry as either text or numerical value
	 * 
	 * @param      string  $as      Format to return state in [text, number]
	 * @param      integer $shorten Number of characters to shorten text to
	 * @return     mixed String or Integer
	 */
	public function content($as='parsed', $shorten=0)
	{
		$as = strtolower($as);

		switch ($as)
		{
			case 'parsed':
				if ($this->get('content_parsed'))
				{
					return $this->get('content_parsed');
				}

				$p =& Hubzero_Wiki_Parser::getInstance();

				$wikiconfig = array(
					'option'   => 'com_forum',
					'scope'    => 'forum',
					'pagename' => 'forum',
					'pageid'   => $this->get('thread'),
					'filepath' => '',
					'domain'   => $this->get('thread')
				);

				$attach = new ForumAttachment($this->_db);

				$this->set('content_parsed', $p->parse(stripslashes($this->get('comment')), $wikiconfig, true, true));
				$this->set('content_parsed', $this->get('content_parsed') . $attach->getAttachment(
					$this->get('id'), 
					$this->link('download'), 
					$this->_config
				));

				if ($shorten)
				{
					$content = Hubzero_View_Helper_Html::shortenText($this->get('content_parsed'), $shorten, 0, 0);
					if (substr($content, -7) == '&#8230;') 
					{
						$content .= '</p>';
					}
					return $content;
				}

				return $this->get('content_parsed');
			break;

			case 'clean':
				$content = strip_tags($this->content('parsed'));
				if ($shorten)
				{
					$content = Hubzero_View_Helper_Html::shortenText($content, $shorten, 0, 1);
				}
				return $content;
			break;

			case 'raw':
			default:
				$content = $this->get('comment');
				if ($shorten)
				{
					$content = Hubzero_View_Helper_Html::shortenText($content, $shorten, 0, 1);
				}
				return $content;
			break;
		}
	}
}

