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
defined('_JEXEC') or die( 'Restricted access' );
?>
<div id="content-header" class="full">
	<h2><?php echo $this->title; ?></h2>
</div><!-- / #content-header -->

<div class="main section">
	<div class="grid">
		<div class="col span-half">
			<div id="ticket-number">
				<h2>
					<span><?php echo JText::_('Report #'); ?></span><strong><?php echo $this->report->id; ?></strong>
				</h2>
			</div>
		</div><!-- / .col span-half -->
		<div class="col span-half omega">
			<div id="messagebox">
				<div class="wrap">
					<h3><?php echo JText::_('REPORT_ABUSE_THANKS'); ?></h3>
<?php if ($this->report) { ?>
					<p><?php echo JText::sprintf('For future reference, your problem has been registered as Abuse Report #%s.', $this->report->id); ?></p>
<?php } ?>
<?php if ($this->returnlink) { ?>
 					<p><a class="btn" href="<?php echo $this->returnlink; ?>"><?php echo JText::_('REPORT_ABUSE_CONTINUE'); ?></a></p>
<?php } ?>
				</div>
			</div>
		</div><!-- / .col span-half omega -->
	</div><!-- / .grid -->
</div><!-- / .main section -->
