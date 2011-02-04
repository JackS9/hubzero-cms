<?php
/**
 * @package		HUBzero CMS
 * @author		Shawn Rice <zooley@purdue.edu>
 * @copyright	Copyright 2005-2009 by Purdue Research Foundation, West Lafayette, IN 47906
 * @license		http://www.gnu.org/licenses/gpl-2.0.html GPLv2
 *
 * Copyright 2005-2009 by Purdue Research Foundation, West Lafayette, IN 47906.
 * All rights reserved.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License,
 * version 2 as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

// Check to ensure this file is included in Joomla!
defined('_JEXEC') or die( 'Restricted access' );

//----------------------------------------------------------

$config = JFactory::getConfig();

if ($config->getValue('config.debug')) {
	error_reporting(E_ALL);
	@ini_set('display_errors','1');
}

// Editor usertype check
$jacl =& JFactory::getACL();
$jacl->addACL( $option, 'manage', 'users', 'super administrator' );
$jacl->addACL( $option, 'manage', 'users', 'administrator' );
$jacl->addACL( $option, 'manage', 'users', 'manager' );

ximport('Hubzero_User_Helper');

include_once(JPATH_ROOT.DS.'components'.DS.'com_wiki'.DS.'tables'.DS.'attachment.php');
include_once(JPATH_ROOT.DS.'components'.DS.'com_wiki'.DS.'tables'.DS.'author.php');
include_once(JPATH_ROOT.DS.'components'.DS.'com_wiki'.DS.'tables'.DS.'comment.php');
include_once(JPATH_ROOT.DS.'components'.DS.'com_wiki'.DS.'tables'.DS.'log.php');
include_once(JPATH_ROOT.DS.'components'.DS.'com_wiki'.DS.'tables'.DS.'page.php');
include_once(JPATH_ROOT.DS.'components'.DS.'com_wiki'.DS.'tables'.DS.'revision.php');

include_once(JPATH_ROOT.DS.'components'.DS.'com_wiki'.DS.'helpers'.DS.'config.php');
include_once(JPATH_ROOT.DS.'components'.DS.'com_wiki'.DS.'helpers'.DS.'differenceengine.php');
include_once(JPATH_ROOT.DS.'components'.DS.'com_wiki'.DS.'helpers'.DS.'html.php');
//include_once(JPATH_ROOT.DS.'components'.DS.'com_wiki'.DS.'helpers'.DS.'macro.php');
//include_once(JPATH_ROOT.DS.'components'.DS.'com_wiki'.DS.'helpers'.DS.'math.php');
//include_once(JPATH_ROOT.DS.'components'.DS.'com_wiki'.DS.'helpers'.DS.'parser.php');
include_once(JPATH_ROOT.DS.'components'.DS.'com_wiki'.DS.'helpers'.DS.'sanitizer.php');
include_once(JPATH_ROOT.DS.'components'.DS.'com_wiki'.DS.'helpers'.DS.'setup.php');
include_once(JPATH_ROOT.DS.'components'.DS.'com_wiki'.DS.'helpers'.DS.'stringutils.php');
include_once(JPATH_ROOT.DS.'components'.DS.'com_wiki'.DS.'helpers'.DS.'tags.php');
include_once(JPATH_ROOT.DS.'components'.DS.'com_wiki'.DS.'helpers'.DS.'utfnormalutil.php');

include_once(JPATH_ROOT.DS.'components'.DS.'com_wiki'.DS.'controller.php');

// Instantiate controller
$controller = new WikiController( array('name'=>'wiki') );
$controller->mainframe = $mainframe;
$controller->execute();
$controller->redirect();
