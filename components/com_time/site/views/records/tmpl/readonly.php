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
 * @author    Sam Wilson <samwilson@purdue.edu>
 * @copyright Copyright 2005-2011 Purdue University. All rights reserved.
 * @license   http://www.gnu.org/licenses/lgpl-3.0.html LGPLv3
 */

// Check to ensure this file is included in Joomla!
defined('_JEXEC') or die('Restricted access');

\Hubzero\Document\Assets::addSystemStylesheet('jquery.ui.css');

$this->css()
     ->css('records')
     ->js('records')
     ->js();
?>

<div id="dialog-confirm"></div>

<header id="content-header">
	<h2><?php echo $this->title; ?></h2>
</header>

<div class="com_time_container">
	<?php $this->view('menu', 'shared')->display(); ?>
	<section class="com_time_content com_time_records">
		<div id="content-header-extra">
			<ul id="useroptions">
				<?php if ($this->row->isMine() || $this->row->iCanProxy()) : ?>
					<li>
						<a class="icon-reply btn" href="<?php echo Route::url($this->base . $this->start); ?>">
							<?php echo Lang::txt('COM_TIME_RECORDS_ALL_RECORDS'); ?>
						</a>
					</li>
					<li>
						<a class="edit icon-edit btn" href="<?php echo Route::url($this->base . '&task=edit&id=' . $this->row->id); ?>">
							<?php echo Lang::txt('COM_TIME_RECORDS_EDIT'); ?>
						</a>
					</li>
					<?php if ($this->row->isMine()) : ?>
						<li class="last">
							<a class="delete icon-delete btn" href="<?php echo Route::url($this->base . '&task=delete&id=' . $this->row->id); ?>">
								<?php echo Lang::txt('COM_TIME_RECORDS_DELETE'); ?>
							</a>
						</li>
					<?php endif; ?>
				<?php else : ?>
					<li class="last">
						<a class="icon-reply btn" href="<?php echo Route::url($this->base . $this->start); ?>">
							<?php echo Lang::txt('COM_TIME_RECORDS_ALL_RECORDS'); ?>
						</a>
					</li>
				<?php endif; ?>
			</ul>
		</div>
		<div class="container readonly">
			<?php if (count($this->getErrors()) > 0) : ?>
				<?php foreach ($this->getErrors() as $error) : ?>
					<p class="error"><?php echo $this->escape($error); ?></p>
				<?php endforeach; ?>
			<?php endif; ?>
			<div class="grid">
				<div class="readonly col span-half">
					<h3 class="headings"><?php echo Lang::txt('COM_TIME_RECORDS_DETAILS'); ?></h3>
					<div class="grouping uname-group">
						<label for="uname"><?php echo Lang::txt('COM_TIME_RECORDS_USER'); ?>:</label>
						<?php echo $this->escape($this->row->user->name); ?>
					</div>

					<div class="grouping hub-group">
						<label for="hub"><?php echo Lang::txt('COM_TIME_RECORDS_HUB'); ?>:</label>
						<?php echo $this->escape($this->row->task->hub->name); ?>
					</div>

					<div class="grouping task-group">
						<label for="task"><?php echo Lang::txt('COM_TIME_RECORDS_TASK'); ?>:</label>
						<?php echo $this->escape($this->row->task->name); ?>
					</div>

					<div class="grouping time-group">
						<label for="time"><?php echo Lang::txt('COM_TIME_RECORDS_TIME'); ?>:</label>
						<?php echo $this->escape($this->row->time); ?> hour(s)
					</div>

					<div class="grouping date-group">
						<label for="date"><?php echo Lang::txt('COM_TIME_RECORDS_DATE'); ?>:</label>
						<?php echo ($this->row->date != '0000-00-00 00:00:00') ? JHTML::_('date', $this->row->date, 'm/d/y') : ''; ?>
					</div>
				</div>

				<div class="readonly col span-half omega">
					<h3 class="headings"><?php echo Lang::txt('COM_TIME_RECORDS_DESCRIPTION'); ?></h3>
					<?php if ($this->row->description) : ?>
						<div class="hub-notes">
							<div class="inner">
								<p>
									<?php echo $this->row->description; ?>
								</p>
							</div>
						</div>
					<?php else : ?>
						<p>
							<?php echo Lang::txt('COM_TIME_RECORDS_NO_DESCRIPTION'); ?>
						</p>
					<?php endif; ?>
				</div>
			</div>
		</div>
	</section>
</div>