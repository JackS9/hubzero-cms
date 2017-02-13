<?php
/**
 * HUBzero CMS
 *
 * Copyright 2005-2015 HUBzero Foundation, LLC.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * HUBzero is a registered trademark of Purdue University.
 *
 * @package   hubzero-cms
 * @author    Shaun Einolf <einolfs@mail.nih.gov>
 * @copyright Copyright 2005-2015 HUBzero Foundation, LLC.
 * @license   http://opensource.org/licenses/MIT MIT
 */

// no direct access
defined('_HZEXEC_') or die();

?>
<div<?php echo ($this->params->get('moduleclass')) ? ' class="' . $this->params->get('moduleclass') . '"' : ''; ?>>
	<h4>
		<a href="<?php echo Route::url('index.php?option=com_projects'); ?>">
			<?php echo Lang::txt('MOD_MYASSIGNMENTS_ASSIGNED'); ?>
		</a>
	</h4>
	<?php $this->total = count($this->rows); ?>
	<?php if ($this->total <= 0) { ?>
		<p><em><?php echo Lang::txt('MOD_MYASSIGNMENTS_NO_ASSIGNMENTS'); ?></em></p>
	<?php } else { ?>
		<ul class="expandedlist">
			<?php
			$i = 0;
			foreach ($this->rows as $row)
			{
				if ($i >= $this->limit)
				{
					break;
				}
				?>
				<li class="assignments">
					<a href="<?php echo Route::url('index.php?option=com_projects&alias=' . $row->alias . '&active=todo/view/?todoid=' . $row->id); ?>"><?php echo $this->escape(stripslashes($row->content)); ?></a><br />
					<?php echo Lang::txt('MOD_MYASSIGNMENTS_PROJECT'); ?>: <a href="<?php echo Route::url('index.php?option=com_projects&alias=' . $row->alias . '&active=todo'); ?>"><?php echo $this->escape(stripslashes($row->title)); ?></a>
					<span></span>
				</li>
				<?php
				$i++;
			}
			?>
		</ul>

		<?php if ($this->total > $this->limit) { ?>
			<p class="note">
				<?php echo Lang::txt('MOD_MYASSIGNMENTS_YOU_HAVE_MORE', $this->limit, $this->total, Route::url('index.php?option=com_members&id=' . User::get('id') . '&active=todo')); ?>
			</p>
		<?php } ?>

		<?php if (intval($this->params->get('summary_level',0)) == 0) { ?>
		<h4><a target="_blank" href="/activity_report.php?userid=<?php echo User::get('id'); ?>&milestone_level=<?php echo intval($this->params->get('milestone_level',1)); ?>&days=<?php echo intval($this->params->get('summary_days',120)); ?>"><?php echo Lang::txt('MOD_MYASSIGNMENTS_SUMMARY'); ?>...</a></h4>
		<?php } else { ?>
			<h4><a target="_blank" href="/activity_report.php?milestone_level=<?php echo intval($this->params->get('milestone_level',1)); ?>&days=<?php echo intval($this->params->get('summary_days',120)); ?>"><?php echo Lang::txt('MOD_MYASSIGNMENTS_SUMMARY'); ?>...</a></h4>
		<?php } ?>
		<br/>
	<?php } ?>
</div>
