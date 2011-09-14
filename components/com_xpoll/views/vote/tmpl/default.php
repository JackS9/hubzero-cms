<?php 
/**
 * @package     hubzero-cms
 * @author      Shawn Rice <zooley@purdue.edu>
 * @copyright   Copyright 2005-2011 Purdue University. All rights reserved.
 * @license     http://www.gnu.org/licenses/lgpl-3.0.html LGPLv3
 *
 * Copyright 2005-2011 Purdue University. All rights reserved.
 * All rights reserved.
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

// no direct access
defined('_JEXEC') or die('Restricted access');
?>
<div id="content-header" class="full">
<?php if ($this->getError()) { ?>
	<h2><?php echo JText::_('COM_XPOLL'); ?></h2>
<?php } else { ?>
	<h2><?php echo JText::_('COM_XPOLL_THANKS'); ?></h2>
<?php } ?>
</div><!-- / #content-header -->

<div class="main section">
<?php if ($this->getError()) { ?>
	<p class="error"><?php echo $this->getError(); ?></p>
<?php } else { ?>
	<p><a href="<?php echo JRoute::_( 'index.php?option='.$this->option.'&task=view&id='.$this->pollid ); ?>"><?php echo JText::_('COM_XPOLL_BUTTON_RESULTS'); ?></a></p>
<?php } ?>
<div class="clear"></div>
</div><!-- / .main section -->
