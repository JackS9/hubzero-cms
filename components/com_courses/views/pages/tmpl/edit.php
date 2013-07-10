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

$base_link = 'index.php?option=com_courses&gid='.$this->course->get('cn').'&task=managepages';

//default some form vars
$form_btn = "Add Page";
$form_title = "Add a New Course Page";
$new = 1;

//default course page vars
$id = '';
$gid = '';
$title = '';
$content = '';
$url = '';
$order = '';
$active = '';
$privacy = '';

//if we are in edit mode
if($this->page) {
	$form_btn = "Update Page";
	$form_title = "Update the Course Page";
	$new = '';

	$id = $this->page['id'];
	$gid = $this->page['gid'];
	$title = $this->page['title'];
	$content = $this->page['content'];
	$url = $this->page['url'];
	$order = $this->page['porder'];
	$active = $this->page['active'];
	$privacy = $this->page['privacy'];
}

//set var for asset browser
$lid = $this->course->get('gidNumber');
?>

<div id="content-header" class="full">
	<h2><?php echo $form_title; ?></h2>
</div>
<div id="content-header-extra">
	<ul id="useroptions">
		<li><a href="<?php echo JRoute::_($base_link); ?>">Back to Manage Pages</a></li>
	</ul>
</div>

<div class="main section">
	<?php
		foreach($this->notifications as $notification) {
			echo "<p class=\"{$notification['type']}\">{$notification['message']}</p>";
		}
	?>

<form action="<?php echo JRoute::_($base_link); ?>" method="POST" id="hubForm">
	<div class="explaination">
		<div id="asset_browser">
			<p><strong><?php echo JText::_('Upload files or images:'); ?></strong></p>
			<iframe width="100%" height="300" name="filer" id="filer" src="index.php?option=com_courses&amp;no_html=1&amp;task=media&amp;listdir=<?php echo $lid; ?>"></iframe>
		</div><!-- / .asset_browser -->
	</div>
	<fieldset>
		<h3><?php echo $form_title; ?></h3>
		<label>Page Title: <span class="required">Required</span>
			<input type="text" name="page[title]" value="<?php echo $title; ?>" />
		</label>
		<label>Page URL: <span class="optional">Optional</span>
			<input type="text" name="page[url]" value="<?php echo $url; ?>" />
			<span class="hint">Page URL's can only contain alphanumeric characters and underscores. Spaces will be removed.</span>
		</label>
		<label for="page[content]">Page Content: <span class="optional">Optional</span>
			<?php
				ximport('Hubzero_Wiki_Editor');
				$editor =& Hubzero_Wiki_Editor::getInstance();
				echo $editor->display('page[content]', 'page[content]', stripslashes($content), '', '50', '15');
			?>
			<span class="hint"><a class="popup" href="<?php echo JRoute::_('index.php?option=com_wiki&scope=&pagename=Help:WikiFormatting'); ?>">Wiki formatting</a> &amp; <a class="popup" href="<?php echo JRoute::_('index.php?option=com_wiki&scope=&pagename=Help:WikiMacros'); ?>">Wiki Macros</a> is allowed.</span>
		</label>
		<label>Page Privacy: <span class="required">Required</span>
			<?php
				ximport("Hubzero_Course_Helper");
				$access = Hubzero_Course_Helper::getPluginAccess($this->course, 'overview');
				switch($access)
				{
					case 'anyone':		$name = "Any HUB Visitor";		break;
					case 'registered':	$name = "Registered HUB Users";	break;
					case 'members':		$name = "Course Members Only";	break;
				}
			?>
			<select name="page[privacy]">
				<option value="default" <?php if($privacy == "default") { echo "selected"; } ?>>Inherits overview tab's privacy setting (Currently set to: <?php echo $name; ?>)</option>
				<option value="members" <?php if($privacy == "members") { echo "selected"; } ?>>Private Page (Accessible to members only)</option>
			</select>
		</label>
		<input type="hidden" name="page[id]" value="<?php echo $id; ?>" />
		<input type="hidden" name="page[gid]" value="<?php echo $gid; ?>" />
		<input type="hidden" name="page[porder]" value="<?php echo $order; ?>" />
		<input type="hidden" name="page[active]" value="<?php echo $active; ?>" />
		<input type="hidden" name="page[new]" value="<?php echo $new; ?>" />
		<input type="hidden" name="sub_task" value="save_page" />
	</fieldset>
	<div class="clear"></div>
	<p class="submit"><input type="submit" name="page_submit" value="<?php echo $form_btn; ?>" /></p>
</form>
</div>
