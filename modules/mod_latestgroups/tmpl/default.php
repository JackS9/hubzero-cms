<?php
/**
 * @package     hubzero-cms
 * @author      HUBzero
 * @copyright   Copyright 2005-2013 Purdue University. All rights reserved.
 * @license     http://www.gnu.org/licenses/lgpl-3.0.html LGPLv3
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
 */

// Check to ensure this file is included in Joomla!
defined('_JEXEC') or die('Restricted access');

// Display groups

$html = '';

$groups = $this->groups;
if(!empty($groups)) 
{
	foreach ($this->groups as $g)
	{
		$html .= '<div class="latestGroup">';
		$html .= '<h4><a href="' . JRoute::_('index.php?option=com_groups&gid=' . $g->gidNumber) . '">' . stripslashes($g->description) . '</a></h4>';
		$html .= '<p class="groupDescription">';
		$html .= stripslashes($g->public_desc);
		$html .= '</p>';
		$html .= '</div>';	
	}
}
else 
{
	$html .= '<p>No popular groups found</p>';
}

$html .= '<p class="more"><a href="' . JRoute::_('index.php?option=com_groups') . '">' . 'All groups</a></p>';

echo $html;

?>