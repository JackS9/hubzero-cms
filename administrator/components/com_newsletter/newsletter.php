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
defined('_JEXEC') or die( 'Restricted access' );

//
$jacl =& JFactory::getacl();
$jacl->addACL($option, 'manage', 'users', 'super administrator');
$jacl->addACL($option, 'manage', 'users', 'administrator');
$jacl->addACL($option, 'manage', 'users', 'manager');

//
require_once( JPATH_ADMINISTRATOR . DS . 'components' . DS . 'com_newsletter' . DS . 'tables' . DS . 'template.php' );
require_once( JPATH_ADMINISTRATOR . DS . 'components' . DS . 'com_newsletter' . DS . 'tables' . DS . 'campaign.php' );
require_once( JPATH_ADMINISTRATOR . DS . 'components' . DS . 'com_newsletter' . DS . 'tables' . DS . 'primary.php' );
require_once( JPATH_ADMINISTRATOR . DS . 'components' . DS . 'com_newsletter' . DS . 'tables' . DS . 'secondary.php' );

//
$controllerName = JRequest::getCmd('controller', 'campaign');
require_once(JPATH_COMPONENT . DS . 'controllers' . DS . $controllerName . '.php');
$controllerName = 'NewsletterController' . ucfirst($controllerName);

//
foreach(array('campaign','template') as $c)
{   
	$active = (JRequest::getCmd('controller', 'campaign') == $c) ? true : false ;
	JSubMenuHelper::addEntry(ucfirst($c).'s', 'index.php?option=com_newsletter&controller='.$c, $active);
}

// initiate controller
$controller = new $controllerName();
$controller->execute();
$controller->redirect();
