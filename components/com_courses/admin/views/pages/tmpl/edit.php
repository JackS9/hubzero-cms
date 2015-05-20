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
 * @copyright Copyright 2005-2015 Purdue University. All rights reserved.
 * @license   http://www.gnu.org/licenses/lgpl-3.0.html LGPLv3
 */

// Check to ensure this file is included in Joomla!
defined('_JEXEC') or die('Restricted access');

$canDo = \Components\Courses\Helpers\Permissions::getActions();

$text = ($this->task == 'edit' ? Lang::txt('JACTION_EDIT') : Lang::txt('JACTION_CREATE'));

Toolbar::title(Lang::txt('COM_COURSES') . ': ' . Lang::txt('COM_COURSES_PAGES') . ': ' . $text, 'courses.png');
if ($canDo->get('core.edit'))
{
	Toolbar::apply();
	Toolbar::save();
	Toolbar::spacer();
}
Toolbar::cancel();
Toolbar::spacer();
Toolbar::help('page');

JHTML::_('behavior.framework');
?>
<script type="text/javascript">
Joomla.submitbutton = function(pressbutton) {
	var form = document.adminForm;

	if (pressbutton == 'cancel') {
		Joomla.submitform(pressbutton, document.getElementById('item-form'));
		return;
	}

	// do field validation
	if ($('#field-title').val() == ''){
		alert("<?php echo Lang::txt('COM_COURSES_ERROR_MISSING_TITLE'); ?>");
	} else if ($('#field-content').val() == ''){
		alert("<?php echo Lang::txt('COM_COURSES_ERROR_MISSING_CONTENT'); ?>");
	} else {
		<?php echo $this->editor()->save('text'); ?>

		Joomla.submitform(pressbutton, document.getElementById('item-form'));
	}
}
</script>

<?php foreach ($this->notifications as $notification) { ?>
<p class="<?php echo $notification['type']; ?>"><?php echo $notification['message']; ?></p>
<?php } ?>

<form action="<?php echo Route::url('index.php?option=' . $this->option  . '&controller=' . $this->controller); ?>" method="post" name="adminForm" id="item-form">
	<div class="col width-70 fltlft">
		<fieldset class="adminform">
			<legend><span><?php echo Lang::txt('JDETAILS'); ?></span></legend>

			<input type="hidden" name="option" value="<?php echo $this->option; ?>" />
			<input type="hidden" name="controller" value="<?php echo $this->controller; ?>" />
			<input type="hidden" name="course" value="<?php echo $this->course->get('id'); ?>" />
			<input type="hidden" name="offering" value="<?php echo $this->offering->get('id'); ?>" />
			<input type="hidden" name="task" value="save" />
			<input type="hidden" name="fields[id]" value="<?php echo $this->row->get('id'); ?>" />
			<input type="hidden" name="fields[course_id]" value="<?php echo $this->course->get('id'); ?>" />
			<input type="hidden" name="fields[offering_id]" value="<?php echo $this->row->get('offering_id'); ?>" />

			<div class="input-wrap">
				<label for="field-title"><?php echo Lang::txt('COM_COURSES_FIELD_TITLE'); ?>: <span class="required"><?php echo Lang::txt('JOPTION_REQUIRED'); ?></span></label><br />
				<input type="text" name="fields[title]" id="field-title" value="<?php echo $this->escape($this->row->get('title')); ?>" />
			</div>
			<div class="input-wrap" data-hint="<?php echo Lang::txt('COM_COURSES_FIELD_ALIAS_HINT'); ?>">
				<label for="field-url"><?php echo Lang::txt('COM_COURSES_FIELD_ALIAS'); ?>:</label><br />
				<input type="text" name="fields[url]" id="field-url" value="<?php echo $this->escape($this->row->get('url')); ?>" />
				<span class="hint"><?php echo Lang::txt('COM_COURSES_FIELD_ALIAS_HINT'); ?></span>
			</div>
			<div class="input-wrap">
				<label for="field-content"><?php echo Lang::txt('COM_COURSES_FIELD_CONTENT'); ?>:</label><br />
				<?php echo $this->editor('fields[content]', $this->escape($this->row->content('raw')), 50, 30, 'field-content'); ?>
			</div>
		</fieldset>
	</div>
	<div class="col width-30 fltrt">
		<table class="meta">
			<tbody>
				<tr>
					<th><?php echo Lang::txt('COM_COURSES_FIELD_TYPE'); ?></th>
				<?php if ($this->row->get('course_id')) { ?>
					<?php if ($this->row->get('offering_id')) { ?>
						<td><?php echo Lang::txt('COM_COURSES_PAGES_OFFERING'); ?></td>
					<?php } else { ?>
						<td><?php echo Lang::txt('COM_COURSES_PAGES_COURSE'); ?></td>
					<?php } ?>
				<?php } else { ?>
					<td><?php echo Lang::txt('COM_COURSES_PAGES_USER_GUIDE'); ?></td>
				<?php } ?>
				</tr>
			<?php if ($this->row->get('course_id')) { ?>
				<tr>
					<th><?php echo Lang::txt('COM_COURSES_FIELD_COURSE_ID'); ?></th>
					<td><?php echo $this->escape($this->row->get('course_id')); ?></td>
				</tr>
			<?php } ?>
			<?php if ($this->row->get('offering_id')) { ?>
				<tr>
					<th><?php echo Lang::txt('COM_COURSES_FIELD_OFFERING_ID'); ?></th>
					<td><?php echo $this->escape($this->row->get('offering_id')); ?></td>
				</tr>
			<?php } ?>
				<tr>
					<th><?php echo Lang::txt('COM_COURSES_FIELD_ID'); ?></th>
					<td><?php echo $this->escape($this->row->get('id')); ?></td>
				</tr>
			</tbody>
		</table>

		<fieldset class="adminform">
			<legend><span><?php echo Lang::txt('COM_COURSES_FIELDSET_PUBLISHING'); ?></span></legend>

			<div class="input-wrap">
				<label for="field-active"><?php echo Lang::txt('COM_COURSES_FIELD_ACTIVE'); ?>:</label><br />
				<select name="fields[active]" id="field-active">
					<option value="1" <?php if ($this->row->get('active')) { echo 'selected="selected"'; } ?>><?php echo Lang::txt('JYES'); ?></option>
					<option value="0" <?php if (!$this->row->get('active')) { echo 'selected="selected"'; } ?>><?php echo Lang::txt('JNO'); ?></option>
				</select>
			</div>
		</fieldset>

		<fieldset class="adminform">
			<?php if (!$this->row->get('id')) { ?>
				<p><?php echo Lang::txt('COM_COURSES_UPLOAD_ADDED_LATER'); ?></p>
			<?php } else { ?>
				<iframe width="100%" height="300" name="filelist" id="filelist" frameborder="0" src="<?php echo Route::url('index.php?option=' . $this->option  . '&controller=pages&task=files&tmpl=component&listdir=' . $this->row->get('offering_id') . '&course=' . $this->course->get('id')); ?>"></iframe>
			<?php } ?>
		</fieldset>
	</div>
	<div class="clr"></div>

	<?php echo Html::input('token'); ?>
</form>