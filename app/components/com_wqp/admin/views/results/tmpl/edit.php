<?php
// No direct access
defined('_HZEXEC_') or die();

// Get the permissions helper
$canDo = \Components\Wqp\Helpers\Permissions::getActions('result');

// Toolbar is a helper class to simplify the creation of Toolbar 
// titles, buttons, spacers and dividers in the Admin Interface.
//
// Here we'll had the title of the component and options
// for saving based on if the user has permission to
// perform such actions. Everyone gets a cancel button.
$text = ($this->task == 'edit' ? Lang::txt('JACTION_EDIT') : Lang::txt('JACTION_CREATE'));

Toolbar::title(Lang::txt('COM_WQP') . ': ' . Lang::txt('COM_WQP_RESULTS') . ': ' . $text);
if ($canDo->get('core.edit'))
{
	Toolbar::apply();
	Toolbar::save();
	Toolbar::spacer();
}
Toolbar::cancel();
Toolbar::spacer();
Toolbar::help('result');

?>
<script type="text/javascript">
function submitbutton(pressbutton)
{
	var form = document.adminForm;

	if (pressbutton == 'cancel') {
		submitform(pressbutton);
		return;
	}

	<?php echo $this->editor()->save('text'); ?>
	submitform(pressbutton);
}
</script>

<form action="<?php echo Route::url('index.php?option=' . $this->option . '&controller=' . $this->controller); ?>" method="post" name="adminForm" class="editform" id="item-form">
	<div class="col width-60 fltlft">
		<fieldset class="adminform">
			<legend><span><?php echo Lang::txt('JDETAILS'); ?></span></legend>

			<div class="input-wrap">
				<label for="field-CHARACTERISTIC_NAME"><?php echo Lang::txt('COM_WQP_FIELD_CHARACTERISTIC_NAME'); ?> <span class="required"><?php echo Lang::txt('JOPTION_REQUIRED'); ?></span></label>
				<input type="text" name="fields[CharacteristicName]" id="field-CHARACTERISTIC_NAME" size="35" value="<?php echo $this->escape($this->row->get('CharacteristicName')); ?>" />
			</div>

			<div class="col width-30 fltlft">
				<div class="input-wrap">
					<input type="text" name="fields[ResultMeasureValue]" id="field-result_measure_value" size="10" value="<?php echo $this->escape($this->row->get('ResultMeasureValue')); ?>" />
					<label for="field-ResultMeasureValue"><?php echo Lang::txt('COM_WQP_FIELD_RESULT_MEASURE_VALUE'); ?></label>
				</div>
			</div>
			<div class="col width-30 fltlft">
				<div class="input-wrap">
					<input type="text" name="fields[ResultMeasure/MeasureUnitCode]" id="field-result_measure_unit_code" size="10" value="<?php echo $this->escape($this->row->get('ResultMeasure/MeasureUnitCode')); ?>" />
					<label for="field-result_measure_unit_code"><?php echo Lang::txt('COM_WQP_FIELD_RESULT_MEASURE_UNIT_CODE'); ?></label>
				</div>
			</div>

			<div class="clr"></div>
		</fieldset>

		<fieldset class="adminform">
			<legend><span><?php echo Lang::txt('COM_WQP_STATIONS'); ?></span></legend>

			<?php
			foreach ($this->stations as $station) { ?>
				<?php
				$check = false;
				if ($this->row->get('id'))
				{
					foreach ($this->row->stations as $s)
					{
						if ($s->get('id') == $station->get('id'))
						{
							$check = true;
						}
					}
				}
				?>
				<div class="input-wrap">
					<input class="option" type="checkbox" name="stations[]" id="station<?php echo $station->get('id'); ?>" <?php if ($check) { echo ' checked="checked'; } ?> value="<?php echo $station->get('id'); ?>" />
					<label for="station<?php echo $station->get('id'); ?>"><?php echo $this->escape($station->get('MonitoringLocationIdentifier')); ?></label>
				</div>
			<?php } ?>
		</fieldset>
	</div>
	<div class="col width-40 fltrt">
		<table class="meta">
			<tbody>
				<tr>
					<th><?php echo Lang::txt('COM_WQP_FIELD_ID'); ?>:</th>
					<td>
						<?php echo $this->row->get('id', 0); ?>
						<input type="hidden" name="fields[id]" id="field-id" value="<?php echo $this->escape($this->row->get('id')); ?>" />
					</td>
				</tr>
				<?php if ($this->row->get('state')) { ?>
					<tr>
						<th><?php echo Lang::txt('COM_WQP_FIELD_CREATOR'); ?>:</th>
						<td>
							<?php
							$editor = User::getInstance($this->row->get('created_by'));
							echo $this->escape($editor->get('name'));
							?>
							<input type="hidden" name="fields[created_by]" id="field-created_by" value="<?php echo $this->escape($this->row->get('created_by')); ?>" />
						</td>
					</tr>
					<tr>
						<th><?php echo Lang::txt('COM_WQP_FIELD_CREATED'); ?>:</th>
						<td>
							<?php echo $this->row->get('created'); ?>
							<input type="hidden" name="fields[created]" id="field-created" value="<?php echo $this->escape($this->row->get('created')); ?>" />
						</td>
					</tr>
				<?php } ?>
			</tbody>
		</table>

		<fieldset class="adminform">
			<legend><span><?php echo Lang::txt('JGLOBAL_FIELDSET_PUBLISHING'); ?></span></legend>

			<div class="input-wrap">
				<label for="field-state"><?php echo Lang::txt('COM_WQP_FIELD_STATE'); ?>:</label><br />
				<select name="fields[state]" id="field-state">
					<option value="0"<?php if ($this->row->get('state') == 0) { echo ' selected="selected"'; } ?>><?php echo Lang::txt('JUNPUBLISHED'); ?></option>
					<option value="1"<?php if ($this->row->get('state') == 1) { echo ' selected="selected"'; } ?>><?php echo Lang::txt('JPUBLISHED'); ?></option>
					<option value="2"<?php if ($this->row->get('state') == 2) { echo ' selected="selected"'; } ?>><?php echo Lang::txt('JTRASHED'); ?></option>
				</select>
			</div>
		</fieldset>
	</div>
	<div class="clr"></div>

	<input type="hidden" name="option" value="<?php echo $this->option; ?>" />
	<input type="hidden" name="controller" value="<?php echo $this->controller; ?>" />
	<input type="hidden" name="task" value="save" />

	<?php echo Html::input('token'); ?>
</form>
