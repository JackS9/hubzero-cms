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
Document::setTitle(Lang::txt('COM_WQP') . ': ' . Lang::txt('COM_WQP_RESULTS'));

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
	<h2><?php echo Lang::txt('COM_WQP'); ?>: <?php echo Lang::txt('COM_WQP_RESULTS'); ?></h2>

	<div id="content-header-extra">
		<p>
			<a class="icon-prev btn" href="<?php echo Route::url('index.php?option=' . $this->option); ?>"><?php echo Lang::txt('COM_WQP_MAIN'); ?></a>
		</p>
	</div>
</header>

<section class="main section">
	<form class="section-inner" action="<?php echo Route::url('index.php?option=' . $this->option . '&controller=' . $this->controller); ?>" method="get">
		<div class="subject">
			<table class="entries">
				<caption><?php echo Lang::txt('COM_WQP_RESULTS'); ?></caption>
				<thead>
					<tr>
						<th><?php echo Lang::txt('COM_WQP_COL_ID'); ?></th>
						<th><?php echo Lang::txt('COM_WQP_COL_CHARACTERISTIC_NAME'); ?></th>
						<th><?php echo Lang::txt('COM_WQP_COL_RESULT_MEASURE_VALUE'); ?></th>
						<th><?php echo Lang::txt('COM_WQP_COL_RESULT_MEASURE_UNIT_CODE'); ?></th>
						<?php if ($this->model->access('edit')) { ?>
							<th></th>
						<?php } ?>
					</tr>
				</thead>
				<?php if ($this->model->access('create')) { ?>
					<tfoot>
						<tr>
							<td colspan="<?php echo ($this->model->access('edit') ? '6' : '5'); ?>">
								<a class="icon-add btn" href="<?php echo Route::url('index.php?option=' . $this->option . '&controller=' . $this->controller . '&task=add'); ?>">
									<?php echo Lang::txt('COM_WQP_NEW'); ?>
								</a>
							</td>
						</tr>
					</tfoot>
				<?php } ?>
				<tbody>
					<?php foreach ($this->records as $record) { ?>
						<tr>
							<th>
								<?php echo $this->escape($record->get('id')); ?>
							</th>
							<td>
								<a href="<?php echo Route::url($record->link()); ?>">
									<?php echo $this->escape($record->get('CharacteristicName')); ?>
								</a>
							</td>
							<td>
								<?php echo $this->escape($record->get('ResultMeasureValue')); ?>
							</td>
							<td>
								<?php echo $this->escape($record->get('ResultMeasure/MeasureUnitCode')); ?>
							</td>
							<?php if ($this->model->access('edit')) { ?>
								<td>
									<a class="icon-edit btn" href="<?php echo Route::url($record->link('edit')); ?>">
										<?php echo Lang::txt('JACTION_EDIT'); ?>
									</a>
									<a class="icon-delete btn" href="<?php echo Route::url($record->link('delete')); ?>">
										<?php echo Lang::txt('JACTION_DELETE'); ?>
									</a>
								</td>
							<?php } ?>
						</tr>
					<?php } ?>
				</tbody>
			</table>

			<?php 
			echo $this
				->records
				->pagination
				->setAdditionalUrlParam('station', $this->filters['station']);

			$results = Event::trigger('wqp.onAfterDisplay');
			echo implode("\n", $results);
			?>
		</div>
		<aside class="aside">
			<fieldset>
				<select name="station">
					<option value=""><?php echo Lang::txt('COM_WQP_STATIONS_ALL'); ?></option>
					<?php foreach (\Components\Wqp\Models\Station::all() as $station) { ?>
						<?php
						/*$current = null;
						if ($this->filters['station'] == $station->get('MonitoringLocationIdentifier'))
						{
							$current = $station;
						}*/
						// TODO:  Make Monitoring Location Identifier a valid URL-compatible string
						?>
						<option<?php if ($this->filters['station'] == $station->get('MonitoringLocationIdentifier')) { echo ' selected="selected"'; } ?> value="<?php echo $this->escape($station->get('MonitoringLocationIdentifier')); ?>"><?php echo $this->escape($station->get('MonitoringLocationIdentifier')); ?></option>
					<?php } ?>
				</select>
				<input type="submit" value="<?php echo Lang::txt('COM_WQP_GO'); ?>" />
			</fieldset>

			<p><a class="btn" href="<?php echo Route::url('index.php?option=' . $this->option . '&controller=stations'); ?>"><?php echo Lang::txt('COM_WQP_STATIONS'); ?></a></p>
		</aside>
	</form>
</section>
