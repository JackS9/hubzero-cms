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
defined('_JEXEC') or die('Restricted access');

ximport('Hubzero_User_Profile');
ximport('Hubzero_User_Profile_Helper');

$item = $this->post->item();

$database = JFactory::getDBO();
//$this->juser = JFactory::getUser();

ximport('Hubzero_Wiki_Parser');

$wikiconfig = array(
	'option'   => $this->option,
	'scope'    => 'collections',
	'pagename' => 'collections',
	'pageid'   => 0,
	'filepath' => '',
	'domain'   => 'collection'
);

$p =& Hubzero_Wiki_Parser::getInstance();

$base = 'index.php?option=' . $this->option . '&controller=' . $this->controller;

if ($item->get('state') == 2)
{
	$item->set('type', 'deleted');
}
$type = $item->get('type');
if (!in_array($type, array('collection', 'deleted', 'image', 'file', 'text', 'link')))
{
	$type = 'link';
}
?>

<div class="post full <?php echo $type; ?>" id="b<?php echo $this->post->get('id'); ?>" data-id="<?php echo $this->post->get('id'); ?>" data-closeup-url="<?php echo JRoute::_($base . '&post=' . $this->post->get('id') . '&task=comment'); ?>" data-width="600" data-height="350">
	<div class="content">
		<div class="creator attribution clearfix">
			<a href="<?php echo JRoute::_('index.php?option=com_members&id=' . $item->get('created_by')); ?>" title="<?php echo $this->escape(stripslashes($item->creator()->get('name'))); ?>" class="img-link">
				<img src="<?php echo Hubzero_User_Profile_Helper::getMemberPhoto($item->creator(), 0); ?>" alt="<?php echo JText::_('COM_COLLECTIONS_PROFILE_PICTURE', $this->escape(stripslashes($item->creator()->get('name')))); ?>" />
			</a>
			<p>
				<?php echo JText::sprintf('COM_COLLECTIONS_USER_CREATEd_POST', '<a href="' . JRoute::_('index.php?option=com_members&id=' . $item->get('created_by')) . '">' . $this->escape(stripslashes($item->creator()->get('name'))) . '</a>'); ?>
				<br />
				<span class="entry-date">
					<span class="entry-date-at"><?php echo JText::_('COM_COLLECTIONS_AT'); ?></span> 
					<span class="time"><?php echo JHTML::_('date', $item->get('created'), JText::_('TIME_FORMAT_HZ1')); ?></span> 
					<span class="entry-date-on"><?php echo JText::_('COM_COLLECTIONS_ON'); ?></span> 
					<span class="date"><?php echo JHTML::_('date', $item->get('created'), JText::_('DATE_FORMAT_HZ1')); ?></span>
				</span>
			</p>
		</div><!-- / .attribution -->

		<?php
		$view = new JView(
			array(
				'name'    => $this->controller,
				'layout'  => 'display_' . $type
			)
		);
		$view->actual     = true;
		$view->option     = $this->option;
		$view->params     = $this->config;
		$view->row        = $this->post;
		$view->parser     = $p;
		$view->wikiconfig = $wikiconfig;
		$view->display();
		?>

	<?php if (count($item->tags()) > 0) { ?>
		<div class="tags-wrap">
			<?php echo $item->tags('render'); ?>
		</div><!-- / .tags-wrap -->
	<?php } ?>

		<div class="meta">
			<p class="stats">
				<span class="likes">
					<?php echo JText::sprintf('COM_COLLECTIONS_NUM_LIKES', $item->get('positive', 0)); ?>
				</span>
				<span class="comments">
					<?php echo JText::sprintf('COM_COLLECTIONS_NUM_COMMENTS', $item->get('comments', 0)); ?>
				</span>
				<span class="reposts">
					<?php echo JText::sprintf('COM_COLLECTIONS_NUM_REPOSTS', $item->get('reposts', 0)); ?>
				</span>
			</p>
		</div><!-- / .meta -->

		<div class="convo attribution clearfix">
			<a href="<?php echo JRoute::_('index.php?option=com_members&id=' . $this->post->get('created_by')); ?>" title="<?php echo $this->escape(stripslashes($this->post->creator()->get('name'))); ?>" class="img-link">
				<img src="<?php echo Hubzero_User_Profile_Helper::getMemberPhoto($this->post->creator(), 0); ?>" alt="<?php echo JText::_('COM_COLLECTIONS_PROFILE_PICTURE', $this->escape(stripslashes($this->post->creator()->get('name')))); ?>" />
			</a>
			<p>
				<a href="<?php echo JRoute::_('index.php?option=com_members&id=' . $this->post->get('created_by')); ?>">
					<?php echo $this->escape(stripslashes($this->post->creator()->get('name'))); ?>
				</a> 
				<?php echo JText::_('COM_COLLECTIONS_ONTO'); ?>
				<a href="<?php echo JRoute::_($base . '&task=' . $this->collection->get('alias')); ?>">
					<?php echo $this->escape(stripslashes($this->collection->get('title'))); ?>
				</a>
				<br />
				<span class="entry-date">
					<span class="entry-date-at"><?php echo JText::_('COM_COLLECTIONS_AT'); ?></span> 
					<span class="time"><?php echo JHTML::_('date', $this->post->get('created'), JText::_('TIME_FORMAT_HZ1')); ?></span> 
					<span class="entry-date-on"><?php echo JText::_('COM_COLLECTIONS_ON'); ?></span> 
					<span class="date"><?php echo JHTML::_('date', $this->post->get('created'), JText::_('DATE_FORMAT_HZ1')); ?></span>
				</span>
			</p>
		</div><!-- / .attribution -->

	<?php if ($item->get('comments')) { ?>
		<div class="commnts">
		<?php
		foreach ($item->comments() as $comment)
		{
			$cuser = Hubzero_User_Profile::getInstance($comment->created_by);
		?>
			<div class="comment convo clearfix" id="c<?php echo $comment->id; ?>">
				<a href="<?php echo JRoute::_('index.php?option=com_members&id=' . $comment->created_by); ?>" class="img-link">
					<img src="<?php echo Hubzero_User_Profile_Helper::getMemberPhoto($cuser, $comment->anonymous); ?>" class="profile user_image" alt="<?php echo JText::_('COM_COLLECTIONS_PROFILE_PICTURE', $this->escape(stripslashes($cuser->get('name')))); ?>" />
				</a>
				<p>
					<a href="<?php echo JRoute::_('index.php?option=com_members&id=' . $comment->created_by); ?>">
						<?php echo $this->escape(stripslashes($cuser->get('name'))); ?>
					</a> 
					<?php echo JText::_('COM_COLLECTIONS_SAID'); ?>
					<br />
					<span class="entry-date">
						<span class="entry-date-at"><?php echo JText::_('COM_COLLECTIONS_AT'); ?></span> 
						<span class="time"><?php echo JHTML::_('date', $comment->created, JText::_('TIME_FORMAT_HZ1')); ?></span> 
						<span class="entry-date-on"><?php echo JText::_('COM_COLLECTIONS_ON'); ?></span> 
						<span class="date"><?php echo JHTML::_('date', $comment->created, JText::_('DATE_FORMAT_HZ1')); ?></span>
					</span>
				</p>
				<blockquote>
					<p><?php echo stripslashes($comment->content); ?></p>
				</blockquote>
			</div>
		<?php } ?>
		</div>
	<?php } ?>

		<div class="commnts">
			<div class="comment convo clearfix">
				<a href="<?php echo JRoute::_('index.php?option=com_members&id=' . $this->juser->get('id')); ?>" class="img-link">
					<img src="<?php echo Hubzero_User_Profile_Helper::getMemberPhoto($this->juser, 0); ?>" class="profile user_image" alt="<?php echo JText::_('COM_COLLECTIONS_PROFILE_PICTURE', $this->escape(stripslashes($this->juser->get('name')))); ?>" />
				</a>
				<p>
					<a href="<?php echo JRoute::_('index.php?option=com_members&id=' . $this->juser->get('id')); ?>">
						<?php echo $this->escape(stripslashes($this->juser->get('name'))); ?>
					</a> 
					<?php echo JText::_('COM_COLLECTIONS_USER_WILL_SAY'); ?>
					<br />
					<span class="entry-date">
						<?php 
						$now = JFactory::getDate(); 
						?>
						<span class="entry-date-at"><?php echo JText::_('COM_COLLECTIONS_AT'); ?></span> 
						<span class="time"><?php echo JHTML::_('date', $now, JText::_('TIME_FORMAT_HZ1')); ?></span> 
						<span class="entry-date-on"><?php echo JText::_('COM_COLLECTIONS_ON'); ?></span> 
						<span class="date"><?php echo JHTML::_('date', $now, JText::_('DATE_FORMAT_HZ1')); ?></span>
					</span>
				</p>
				<form action="<?php echo JRoute::_($base . '&post=' . $this->post->get('id') . '&task=savecomment' . ($this->no_html ? '&no_html=' . $this->no_html  : '')); ?>" id="comment-form" method="post" enctype="multipart/form-data">
					<fieldset>
						<input type="hidden" name="comment[id]" value="0" />
						<input type="hidden" name="comment[item_id]" value="<?php echo $item->get('id'); ?>" />
						<input type="hidden" name="comment[item_type]" value="collection" />
						<input type="hidden" name="comment[state]" value="1" />

						<input type="hidden" name="option" value="<?php echo $this->option; ?>" />
						<input type="hidden" name="controller" value="<?php echo $this->controller; ?>" />
						<input type="hidden" name="post" value="<?php echo $this->post->get('id'); ?>" />
						<input type="hidden" name="task" value="savecomment" />
						<input type="hidden" name="no_html" value="<?php echo $this->no_html; ?>" />

						<textarea name="comment[content]" cols="35" rows="3"></textarea>
						<input type="submit" class="comment-submit" value="<?php echo JText::_('COM_COLLECTIONS_SAVE'); ?>" />
					</fieldset>
				</form>
			</div><!-- / .comment -->
		</div><!-- / .commnts -->
	</div><!-- / .content -->
</div><!-- / .bulletin -->