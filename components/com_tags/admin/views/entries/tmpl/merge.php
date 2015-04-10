<?php
/**
 * HUBzero CMS
 *
 * Copyright 2005-2015 Purdue University. All rights reserved.
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
 * @copyright Copyright 2005-2015 Purdue University. All rights reserved.
 * @license   http://www.gnu.org/licenses/lgpl-3.0.html LGPLv3
 */

// Check to ensure this file is included in Joomla!
defined('_JEXEC') or die('Restricted access');

$canDo = \Components\Tags\Helpers\Permissions::getActions();

Toolbar::title(Lang::txt('COM_TAGS') . ': ' . Lang::txt('COM_TAGS_MERGE'), 'tags.png');
if ($canDo->get('core.edit'))
{
	Toolbar::save('merge');
}
Toolbar::cancel();
Toolbar::spacer();
Toolbar::help('merge');
?>
<script type="text/javascript">
function submitbutton(pressbutton)
{
	var form = document.adminForm;

	if (pressbutton == 'cancel') {
		submitform(pressbutton);
		return;
	}

	submitform(pressbutton);
}
</script>

<form action="<?php echo Route::url('index.php?option=' . $this->option . '&controller=' . $this->controller); ?>" method="post" name="adminForm" class="editform" id="item-form">
	<p class="warning"><?php echo Lang::txt('COM_TAGS_MERGED_EXPLANATION'); ?></p>

	<div class="col width-50 fltlft">
		<fieldset class="adminform">
			<legend><span><?php echo Lang::txt('COM_TAGS_MERGING'); ?></span></legend>

			<div class="input-wrap">
				<ul>
					<?php
					foreach ($this->tags as $tag)
					{
						echo '<li>' . $this->escape(stripslashes($tag->get('raw_tag'))) . ' (' . $this->escape($tag->get('tag')) . ' - ' . $tag->objects('count') . ')</li>' . "\n";
					}
					?>
				</ul>
			</div>
		</fieldset>
	</div>
	<div class="col width-50 fltrt">
		<fieldset class="adminform">
			<legend><span><?php echo Lang::txt('COM_TAGS_MERGE_TO'); ?></span></legend>

			<div class="input-wrap">
				<label for="newtag"><?php echo Lang::txt('COM_TAGS_TAG'); ?>:</label><br />
				<?php
				$tf = Event::trigger(
					'hubzero.onGetMultiEntry',
					array(
						array('tags', 'newtag', 'newtag')
					)
				);
				echo (count($tf) ? implode("\n", $tf) : '<input type="text" name="newtag" id="newtag" size="25" value="" />');
				?>
			</div>
			<p><?php echo Lang::txt('COM_TAGS_SELECT_TAG'); ?></p>
		</fieldset>
	</div>
	<div class="clr"></div>

	<input type="hidden" name="ids" value="<?php echo $this->idstr; ?>" />
	<input type="hidden" name="option" value="<?php echo $this->option; ?>" />
	<input type="hidden" name="controller" value="<?php echo $this->controller; ?>" />
	<input type="hidden" name="step" value="<?php echo $this->step; ?>" />
	<input type="hidden" name="task" value="merge" />

	<?php echo JHTML::_('form.token'); ?>
</form>