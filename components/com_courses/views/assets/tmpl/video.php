<?php
/**
 * HUBzero CMS
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
 *
 * @package   hubzero-cms
 * @author    Shawn Rice <zooley@purdue.edu>
 * @copyright Copyright 2005-2011 Purdue University. All rights reserved.
 * @license   http://www.gnu.org/licenses/lgpl-3.0.html LGPLv3
 */

// Check to ensure this file is included in Joomla!
defined('_JEXEC') or die( 'Restricted access' );

// Set a few defaults
$type               = 'html5';
$manifest_path_json = null;
$manifest_path_xml  = null;

// Set the path
$path = rtrim($this->model->path($this->course->get('id'), false), DS);

// Check to make sure we have a presentation document defining cuepoints, slides, and media
if (is_dir(JPATH_ROOT . $path))
{
	$manifest_path_json = JFolder::files(JPATH_ROOT . $path, 'presentation.json', true, true);
	$manifest_path_xml  = JFolder::files(JPATH_ROOT . $path, 'presentation.xml', true, true);
}

// Check if the formatted json exists (for hubpresenter)
if (empty($manifest_path_json))
{
	// We don't have the JSON manifest, but check to see if we just havent converted it yet
	if (empty($manifest_path_xml))
	{
		// This is redundant, but reinforcing that we're not trying to display a hubpresenter video
		$type = 'html5';
	} 
	else 
	{
		// We do have an XML file, try to convert
		// Inlude the HUBpresenter library
		require_once(JPATH_ROOT . DS . 'components' . DS . 'com_resources' . DS . 'helpers' . DS . 'hubpresenter.php');

		// Try to create json manifest
		$job = HUBpresenterHelper::createJsonManifest(rtrim($manifest_path_xml[0], 'presentation.xml'), $manifest_path_xml[0]);
		if ($job != '') 
		{
			$this->setError($job);
		}
		else
		{
			$type = 'hubpresenter';
		}
	}
}
else
{
	// We have a formatted JSON manifest, therefore we must be doing a hubpresenter video
	$type = 'hubpresenter';
}

// Add Jquery to the page if the system plugin isn't enabled
if (!JPluginHelper::isEnabled('system', 'jquery'))
{
	// Create the document object
	$doc =& JFactory::getDocument();

	$doc->addScript("https://ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js");
	$doc->addScript("https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.13/jquery-ui.min.js");
}

// If the video type is 'hubpresenter', perform next steps
if ($type == 'hubpresenter')
{
	// Set media path
	$media_path = rtrim($manifest_path_json[0], 'presentation.json');

	// Check if path exists
	if (is_dir($media_path))
	{
		// Get all files matching  /.mp4|.webs|.ogv|.m4v|.mp3/
		$media = JFolder::files($media_path, '.mp4|.webm|.ogv|.m4v|.mp3', false, false);
		foreach ($media as $m) 
		{
			$ext[] = array_pop(explode('.', $m));
		}

		// If we dont have all the necessary media formats
		if ((in_array('mp4', $ext) && count($ext) < 3) || (in_array('mp3', $ext) && count($ext) < 2))
		{
			$this->setError(JText::_('Missing necessary media formats for video or audio.'));
		}

		// Make sure if any slides are video we have three formats of video and backup image for mobile
		$slide_path = $media_path . 'slides';
		$slides = JFolder::files($slide_path, '', false, false);

		// Array to hold slides with video clips
		$slide_video = array();

		// Build array for checking slide video formats
		foreach ($slides as $s) 
		{
			$parts = explode('.', $s);
			$ext = array_pop($parts);
			$name = implode('.', $parts);

			if (in_array($ext, array('mp4', 'm4v', 'webm', 'ogv'))) 
			{
				$slide_video[$name][$ext] = $name . '.' . $ext;
			}
		}

		// Make sure for each of the slide videos we have all three formats and has a backup image for the slide
		foreach ($slide_video as $k => $v) 
		{
			if (count($v) < 3) 
			{
				$this->setError(JText::_('Video Slides must be Uploaded in the Three Standard Formats. You currently only have ' . count($v) . " ({$k}." . implode(", {$k}.", array_keys($v)) . ').'));
			}

			if (!file_exists($slide_path . DS . $k . '.png')) 
			{
				$this->setError(JText::_('Slides containing video must have a still image of the slide for mobile suport. Please upload an image with the filename "' . $k . '.png".'));
			}
		}
	}

	// Get the manifest for the presentation
	$contents = file_get_contents($manifest_path_json[0]);

	// Content folder
	$content_folder = ltrim(rtrim($media_path, DS), JPATH_ROOT);

	if (is_dir($content_folder))
	{
		$subs = JFolder::files(JPATH_ROOT . DS . $content_folder, '.srt|.SRT', true, true);
	}

	// Decode the json formatted manifest so we can use the information
	$presentation = json_decode($contents);
	$presentation = $presentation->presentation;

	// Add the HUBpresenter stylesheet and scripts
	Hubzero_Document::addComponentStylesheet('com_resources', "/assets/css/hubpresenter.css");
	Hubzero_Document::addComponentStylesheet('com_courses', "/assets/css/hubpresenter.css");

	Hubzero_Document::addComponentScript('com_resources', "assets/js/hubpresenter");
	Hubzero_Document::addComponentScript('com_resources', "assets/js/hubpresenter.plugins");
}
elseif ($type == 'html5') // Not hubpresenter, now try standard HTML5 video
{
	// Instanticate our variables
	$videos    = array();
	$video_mp4 = array();
	$subs      = array();

	if (is_dir(JPATH_ROOT . $path))
	{
		// Look for video files and subtitle files in our path
		$videos    = JFolder::files(JPATH_ROOT . $path, '.m4v|.M4V|.mpeg|.MPEG|.mp4|.MP4|.ogv|.OGV|.webm|.WEBM');
		$video_mp4 = JFolder::files(JPATH_ROOT . $path, '.mp4|.MP4|.m4v|.M4V');
		$subs      = JFolder::files(JPATH_ROOT . $path, '.srt|.SRT');
	}

	// If there was a video, let's put it in the page
	if (isset($videos) && !empty($videos))
	{
		// Add HTML5 video-specific scripts and css
		Hubzero_Document::addComponentStylesheet('com_resources', "/assets/css/video.css");

		Hubzero_Document::addComponentScript('com_resources', "assets/js/hubpresenter");
		Hubzero_Document::addComponentScript('com_resources', "assets/js/hubpresenter.plugins");

		// @TODO: it might be nice to detect the native resolution of the video?
		$width = 854;
		$height = 480;
	}
}

// Include media tracking for html5 and hubpresenter videos
// Media tracking object
require_once(JPATH_ROOT . DS . 'administrator' . DS . 'components' . DS . 'com_resources' . DS . 'tables' . DS . 'media.tracking.php');
$mediaTracking = new ResourceMediaTracking(JFactory::getDBO());

// Get tracking for this user for this resource
$tracking = $mediaTracking->getTrackingInformationForUserAndResource(JFactory::getUser()->get('id'), $this->asset->id, 'course');

// Check to see if we already have a time query param
$hasTime = (JRequest::getVar('time', '') != '') ? true : false;

// Do we want to redirect user with time added to url
if (is_object($tracking) && !$hasTime && $tracking->current_position > 0 && $tracking->current_position != $tracking->object_duration)
{
	$redirect = JURI::current();

	$delimeter = (strpos($redirect, '?') === false) ? '?' : '&';

	// Append current position to redirect
	$redirect .= $delimeter . "time=" . gmdate("H:i:s", $tracking->current_position);

	// Redirect
	JFactory::getApplication()->redirect(JRoute::_($redirect, false), '','',false);
}

?>

<?php if ($type == 'html5') : ?>
	<div id="video-container">
		<?php if (isset($videos) && is_array($videos) && count($videos) > 0) : ?>
			<video controls="controls" id="video-player" data-mediaid="<?php echo $this->asset->get('id'); ?>">
				<?php foreach ($videos as $v) : ?>
					<?php
						$info = pathinfo($v);
						$type = '';
						switch (strtolower($info['extension']))
						{
							case 'm4v':
							case 'mp4':  $type = "video/mp4;";  break;
							case 'ogv':  $type = "video/ogg;";  break;
							case 'webm': $type = "video/webm;"; break;
						}
					?>
					<source src="<?php echo $path . DS . $v; ?>" type="<?php echo $type; ?>" />
				<?php endforeach; ?>

				<a href="<?php echo $path . DS . $video_mp4[0]; ?>" id="video-flowplayer" style="<?php echo "width:{$width}px;height:{$height}px;"; ?>"></a>

				<?php if (isset($subs) && count($subs) > 0) : ?>
					<?php foreach ($subs as $s) : ?>
						<?php $info2 = pathinfo($s); ?>
						<div data-type="subtitle" data-lang="<?php echo $info2['filename']; ?>" data-src="<?php echo $path . DS . $s; ?>?v=<?php echo filemtime( JPATH_ROOT . $path . DS . $s ); ?>"></div>
					<?php endforeach; ?>
				<?php endif; ?>
			</video>
		<?php else : ?>
			<p class="warning">There are no playable videos associated with this lecture</p>
		<?php endif; ?>
	</div><!-- /#video-container -->
<?php elseif($type == 'hubpresenter') : ?>
	<div id="presenter-shortcuts-box"> 
		<h2>Keyboard Shortcuts</h2>
		<a href="#" id="shortcuts-close">Close</a>
		<ul id="shortcuts-content">
			<li><kbd>Space</kbd> or <kbd>P</kbd><span>Pauses/Plays Presentation</li>
			<li><kbd>&darr;</kbd> or <kbd>&rarr;</kbd><span>Next Slide</span></li>
			<li><kbd>&uarr;</kbd> or <kbd>&larr;</kbd><span>Previous Slide</span></li>
			<li><kbd>+</kbd><span>Increase Volume</span></li>
			<li><kbd>-</kbd><span>Decrease Volume</span></li>
			<li><kbd>M</kbd><span>Mute Presentation</span></li>
		</dl>
	</div>

	<div id="presenter-container">
		<div id="presenter-header">
			<div id="title"><?php echo $this->asset->get('title'); ?></div>
		</div><!-- /#header -->

		<div id="presenter-content">
			<div id="presenter-left">
				<div id="slides">
					<ul class="no-js">
						<?php $counter = 0; ?>
						<?php foreach ($presentation->slides as $slide) : ?>
							<li id="slide_<?php echo $counter; ?>" title="<?php echo $slide->title; ?>" time="<?php echo $slide->time; ?>">
								<?php if ($slide->type == 'Image') : ?>
									<img src="<?php echo $content_folder . DS . $slide->media; ?>" alt="<?php echo $slide->title; ?>" />
								<?php else : ?>
									<video class="slidevideo">  
										<?php foreach ($slide->media as $source): ?>
											<source src="<?php echo $content_folder . DS . $source->source; ?>" /> 
										<?php endforeach; ?>
										<a href="<?php echo $content_folder . DS . $slide->media[0]->source; ?>" class="flowplayer_slide" id="flowplayer_slide_<?php echo $counter; ?>"></a> 
									</video>
									<img src="<?php echo $content_folder . DS . $slide->media[3]->source; ?>" alt="<?php echo $slide->title; ?>" class="imagereplacement">
								<?php endif; ?>
							</li>
							<?php $counter++; ?>
						<?php endforeach; ?>
					</ul>
				</div><!-- /#slides -->
				<div id="control-box" class="no-controls">
					<div id="control-buttons">
						<div id="volume-icon"></div>
						<div id="volume-bar"></div>
						<a id="previous" href="#" title="Previous Slide">Previous</a>
						<a id="play-pause" href="#" title="Play Presentation">Pause</a>
						<a id="next" href="#" title="Next Slide">Next</a>
						<a id="shortcuts" href="#" title="Keyboard Shortcuts">Shortcuts</a>
						<a id="link" href="#" title="Link to this Spot in Presentation">Link</a>
						<a id="switch" href="#" title="Switch Placement of Video and Slides">Switch</a>
					</div>
					<div id="control-progress">
						<div id="progress-bar"></div>
						<div id="slide-markers"></div>
						<div id="media-progress"></div>
					</div>
				</div><!-- /#control-box -->
			</div><!-- /#left -->
			<?php $cls = (isset($presentation->videoPosition)
							&& $presentation->videoPosition == "left"
							&& strtolower($presentation->type) == 'video') ? "move-left": ""; ?>
			<div id="presenter-right">
				<div id="media" class="<?php echo $cls; ?>">
					<?php if (strtolower($presentation->type) == 'video') : ?>
						<video id="player" preload="auto" controls="controls" data-mediaid="<?php echo $this->asset->get('id'); ?>">
							<?php foreach ($presentation->media as $source): ?>
								<?php
									switch (strtolower($source->type))
									{
										case 'm4v':
										case 'mp4':  $type = "video/mp4;";  break;
										case 'ogv':  $type = "video/ogg;";  break;
										case 'webm': $type = "video/webm;"; break;
									}
								?>
								<source src="<?php echo $content_folder . DS . $source->source; ?>" type='<?php echo $type; ?>'>
							<?php endforeach; ?>
							<a href="<?php echo $content_folder . DS . $presentation->media[0]->source; ?>" id="flowplayer"></a>

							<?php if (isset($subs) && count($subs) > 0) : ?>
								<?php foreach($subs as $sub) : ?>
									<?php $info2 = pathinfo($sub); ?>
									<div data-type="subtitle" data-lang="<?php echo $info2['filename']; ?>" data-src="<?php echo $content_folder . DS . $sub; ?>?v=<?php echo filemtime( JPATH_ROOT . $content_folder . DS . $sub ); ?>"></div>
								<?php endforeach; ?>
							<?php endif; ?>

						</video>
					<?php else : ?>
						<audio id="player" preload="auto" controls="controls">
							<?php foreach ($presentation->media as $source): ?>
								<source src="<?php echo $content_folder . DS . $source->source; ?>" />
							<?php endforeach; ?>
							<a href="<?php echo $content_folder . DS . $presentation->media[0]->source; ?>" id="flowplayer" duration="<?php if ($presentation->duration) { echo $presentation->duration; } ?>"></a>
						</audio>
					<?php endif; ?>
				</div>
				<div id="list">
					<ul id="list_items">
						<?php $num = 0; $counter = 0; $last_slide_id = 0; ?>
						<?php foreach ($presentation->slides as $slide) : ?>
							<?php if ((int)$slide->slide != $last_slide_id) : ?>
								<li id="list_<?php echo $counter; ?>">
									<img src="<?php echo $content_folder . DS . $slide->media; ?>" alt="<?php echo $slide->title; ?>" />
									<span>
										<?php 
											$num++;
											$max = 30;
											$elipsis = "&hellip;";
											echo ($num) . ". ";
											echo substr($slide->title, 0, $max);

											if (strlen($slide->title) > $max)
												echo $elipsis;
										?>
									</span>
									<span class="time"><?php echo $slide->time; ?></span>
									<div id="list-slider-<?php echo $counter; ?>" class="list-slider"></div>
									<div class="list-progress">00:00/00:00</div>
								</li>
							<?php endif; ?>
							<?php 
								$last_slide_id = $slide->slide;
								$counter++;
							?>
						<?php endforeach; ?>
					</ul>
				</div>
			</div><!-- /#right -->
		</div><!-- /#content -->
	</div>
	<div id="twofinger">Use two Fingers to Scroll</div>
<?php endif; ?>