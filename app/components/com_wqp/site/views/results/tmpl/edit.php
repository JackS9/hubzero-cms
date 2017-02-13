<?php
// Push CSS to the document
//
// The css() method provides a quick and convenient way to attach stylesheets. 
// 
// 1. The name of the stylesheet to be pushed to the document (file extension is optional). 
//    If no name is provided, the name of the component or plugin will be used. For instance, 
//    if called within a view of the component com_tags, the system will look for a stylesheet named tags.css.
// 
// 2. The name of the extension to look for the stylesheet. For components, this will be 
//    the component name (e.g., com_tags). For plugins, this is the name of the plugin folder 
//    and requires the third argument be passed to the method.
//
// Method chaining is also allowed.
// $this->css()  
//      ->css('another');

$this->css();

// Similarly, a js() method is available for pushing javascript assets to the document.
// The arguments accepted are the same as the css() method described above.
//
// $this->js();

// Set the document title
//
// This sets the <title> tag of the document and will overwrite any previous
// title set. To append or modify an existing title, it must be retrieved first
// with $title = Document::getTitle();
Document::setTitle(Lang::txt('COM_WQP') . ': ' . Lang::txt('COM_WQP_RESULTS') . ': ' . ($this->entry->get('id') ? Lang::txt('JACTION_EDIT') : Lang::txt('JACTION_NEW')));

// Set the pathway (breadcrumbs)
//
// Breadcrumbs are displayed via a breadcrumbs module and may or may not be enabled for
// all hubs and/or templates. In general, it's good practice to set the pathway
// even if it's unknown if hey will be displayed or not.
Pathway::append(
	Lang::txt('COM_WQP'),  // Text to display
	'index.php?option=' . $this->option  // Link. Route::url() not needed.
);
Pathway::append(
	Lang::txt('COM_WQP_RESULTS'),
	'index.php?option=' . $this->option . '&controller=' . $this->controller
);
?>
<header id="content-header">
	<h2><?php echo Lang::txt('COM_WQP'); ?></h2>
</header>
<section class="main section">
	<?php if ($this->getError()) { ?>
		<p class="error"><?php echo $this->getError(); ?></p>
	<?php } ?>

	<form action="<?php echo Route::url('index.php?option=' . $this->option . '&controller=' . $this->controller . '&task=save'); ?>" method="post" id="hubForm">
		<div class="explaination">
			<p><?php echo Lang::txt('COM_WQP_HELP'); ?></p>
		</div>
		<fieldset>
			<legend><?php echo Lang::txt('COM_WQP_DETAILS'); ?></legend>

			<label for="field-characteristic_name">
				<?php echo Lang::txt('COM_WQP_CHARACTERISTIC_NAME'); ?> <span class="required"><?php echo Lang::txt('JREQUIRED'); ?></span>
				<input type="text" name="entry[CharacteristicName]" id="field-characteristic_name" size="35" value="<?php echo $this->escape($this->entry->get('CharacteristicName')); ?>" />
			</label>

			<div class="grid">
				<div class="col span4">
					<label for="field-result_measure_value">
						<input type="text" name="entry[ResultMeasureValue]" id="field-result_measure_value" size="10" value="<?php echo $this->escape($this->entry->get('ResultMeasureValue')); ?>" />
						<?php echo Lang::txt('COM_WQP_RESULT_MEASURE_VALUE'); ?>
					</label>
				</div>

				<div class="col span4">
					<label for="field-result_measure_unit_code">
						<input type="text" name="entry[ResultMeasure/MeasureUnitCode]" id="field-result_measure_unit_code" size="15" value="<?php echo $this->escape($this->entry->get('ResultMeasure/MeasureUnitCode')); ?>" />
						<?php echo Lang::txt('COM_WQP_RESULT_MEASURE_UNIT_CODE'); ?>
					</label>
				</div>

			</div>

			<fieldset>
				<legend><?php echo Lang::txt('COM_WQP_STATIONS'); ?></legend>
				<?php foreach ($this->stations as $station) { ?>
					<?php
					$check = false;
					if ($this->entry->get('id'))
					{
						foreach ($this->entry->stations as $s)
						{
							if ($s->get('id') == $station->get('id'))
							{
								$check = true;
							}
						}
					}
					?>
					<label for="station<?php echo $station->get('id'); ?>">
						<input class="option" type="checkbox" name="stations[]" id="station<?php echo $station->get('id'); ?>" <?php if ($check) { echo ' checked="checked'; } ?> value="<?php echo $station->get('id'); ?>" />
						<?php echo $this->escape($station->get('MonitoringLocationIdentifier')); ?>
					</label>
				<?php } ?>
			</fieldset>
		</fieldset>
		<div class="clear"></div>

		<input type="hidden" name="id" value="<?php echo $this->escape($this->entry->get('created_by')); ?>" />
		<input type="hidden" name="entry[id]" value="<?php echo $this->escape($this->entry->get('id')); ?>" />
		<input type="hidden" name="entry[state]" value="<?php echo $this->escape($this->entry->get('state', 1)); ?>" />
		<input type="hidden" name="option" value="<?php echo $this->option; ?>" />
		<input type="hidden" name="controller" value="<?php echo $this->controller; ?>" />
		<input type="hidden" name="task" value="save" />

		<?php echo Html::input('token'); ?>

		<p class="submit">
			<input class="btn btn-success" type="submit" value="<?php echo Lang::txt('COM_WQP_SAVE'); ?>" />

			<a class="btn btn-secondary" href="<?php echo Route::url('index.php?option=' . $this->option . '&controller=' . $this->controller); ?>">
				<?php echo Lang::txt('COM_WQP_CANCEL'); ?>
			</a>
		</p>
	</form>
</section>
