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
 * @author    Shawn Rice <zooley@purdue.edu>
 * @copyright Copyright 2005-2011 Purdue University. All rights reserved.
 * @license   http://www.gnu.org/licenses/lgpl-3.0.html LGPLv3
 */

// Check to ensure this file is included in Joomla!
defined('_JEXEC') or die('Restricted access');

jimport('joomla.plugin.plugin');

/**
 * Courses Plugin class for user progress
 */
class plgCoursesProgress extends JPlugin
{
	/**
	 * Constructor
	 * 
	 * @param      object &$subject Event observer
	 * @param      array  $config   Optional config values
	 * @return     void
	 */
	public function __construct(&$subject, $config)
	{
		parent::__construct($subject, $config);

		$this->loadLanguage();
	}

	/**
	 * Return the alias and name for this category of content
	 * 
	 * @return     array
	 */
	public function &onCourseAreas()
	{
		$area = array(
			'name' => $this->_name,
			'title' => JText::_('PLG_COURSES_' . strtoupper($this->_name)),
			'default_access' => $this->params->get('plugin_access', 'members'),
			'display_menu_tab' => true
		);
		return $area;
	}

	/**
	 * Return data on a course view (this will be some form of HTML)
	 * 
	 * @param      object  $course      Current course
	 * @param      string  $option     Name of the component
	 * @param      string  $authorized User's authorization level
	 * @param      integer $limit      Number of records to pull
	 * @param      integer $limitstart Start of records to pull
	 * @param      string  $action     Action to perform
	 * @param      array   $access     What can be accessed
	 * @param      array   $areas      Active area(s)
	 * @return     array
	 */
	public function onCourse($config, $course, $instance, $action='', $areas=null)
	{
		$return = 'html';
		$active = $this->_name;

		// The output array we're returning
		$arr = array(
			'html'     => '',
			'metadata' => ''
		);

		//get this area details
		$this_area = $this->onCourseAreas();

		// Check if our area is in the array of areas we want to return results for
		if (is_array($areas)) 
		{
			if (!in_array($this_area['name'], $areas)) 
			{
				return $arr;
			}
		}
		else if ($areas != $this_area['name'])
		{
			return $arr;
		}

		// Create user object
		$this->juser  = JFactory::getUser();
		$this->course = $course;

		if ($action = JRequest::getWord('action', false))
		{
			$this->$action();
		}

		$layout = ($course->offering()->section()->access('manage')) ? 'instructor' : 'student';

		// If this is an instructor, see if they want the overall view, or an individual student
		if($layout == 'instructor')
		{
			if($student_id = JRequest::getInt('id', false))
			{
				$layout = 'student';
				$this->juser  = JFactory::getUser($student_id);
			}
		}

		// Check to see if user is member and plugin access requires members
		if (!$course->offering()->section()->access('view')) 
		{
			$arr['html'] = '<p class="info">' . JText::sprintf('COURSES_PLUGIN_REQUIRES_MEMBER', ucfirst($active)) . '</p>';
			return $arr;
		}

		// Add some styles to the view
		ximport('Hubzero_Document');
		Hubzero_Document::addPluginStylesheet('courses', 'progress');
		Hubzero_Document::addPluginScript('courses', 'progress', $layout.'progress');

		// Instantiate a vew
		ximport('Hubzero_Plugin_View');
		$view = new Hubzero_Plugin_View(
			array(
				'folder'  => 'courses',
				'element' => $this->_name,
				'name'    => 'report',
				'layout'  => $layout
			)
		);
		$view->course  = $course;
		$view->juser   = $this->juser;
		$view->option  = 'com_courses';

		$arr['html'] = $view->loadTemplate();

		// Return the output
		return $arr;
	}

	/**
	 * Refresh grades
	 *
	 * @return void
	 **/
	private function refresh()
	{
		require_once(JPATH_ROOT . DS . 'components' . DS . 'com_courses' . DS . 'models' . DS . 'gradebook.php');

		// Only allow for instructors
		if (!$this->course->offering()->section()->access('manage'))
		{
			// Redirect with message
			JFactory::getApplication()->redirect(
				JRoute::_('index.php?option=com_courses&gid=' . $this->course->get('alias') . '&offering=' . $this->course->offering()->get('alias'), false),
				'You don\'t have permission to do this!',
				'warning'
			);
			return;
		}

		// Get gradebook instance
		$gradebook = new CoursesModelGradeBook(null);
		if (!$gradebook->refresh($this->course))
		{
			// Redirect with message
			JFactory::getApplication()->redirect(
				JRoute::_('index.php?option=com_courses&gid=' . $this->course->get('alias') . '&offering=' . $this->course->offering()->get('alias') . '&active=progress', false),
				'Something went wrong!',
				'error'
			);
			return;
		}

		// Redirect with message
		JFactory::getApplication()->redirect(
			JRoute::_('index.php?option=com_courses&gid=' . $this->course->get('alias') . '&offering=' . $this->course->offering()->get('alias') . '&active=progress', false),
			'Student progress successfully updated!',
			'passed'
		);
		return;
	}
}
