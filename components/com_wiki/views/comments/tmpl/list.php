<?php
/**
 * @package		HUBzero CMS
 * @author		Shawn Rice <zooley@purdue.edu>
 * @copyright	Copyright 2005-2009 by Purdue Research Foundation, West Lafayette, IN 47906
 * @license		http://www.gnu.org/licenses/gpl-2.0.html GPLv2
 *
 * Copyright 2005-2009 by Purdue Research Foundation, West Lafayette, IN 47906.
 * All rights reserved.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License,
 * version 2 as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

// Check to ensure this file is included in Joomla!
defined('_JEXEC') or die( 'Restricted access' );

$this->c = ($this->c) ? $this->c : 'odd';
$i = 1;
$html = '';
if (count($this->comments) > 0) {
	ximport('Hubzero_User_Profile_Helper');
	ximport('Hubzero_User_Profile');
	
	//$parser = new WikiParser( stripslashes($this->page->title), $this->option, 'comment', $this->page->id, 0, '' );
	JPluginHelper::importPlugin( 'hubzero' );
	$dispatcher =& JDispatcher::getInstance();
	$wikiconfig = array(
		'option'   => $this->option,
		'scope'    => $this->page->scope,
		'pagename' => $this->page->pagename,
		'pageid'   => $this->page->id,
		'filepath' => '',
		'domain'   => $this->page->group 
	);
	$result = $dispatcher->trigger( 'onGetWikiParser', array($wikiconfig, true) );
	$parser = (is_array($result) && !empty($result)) ? $result[0] : null;
	
	$html .= '<ol class="comments">'."\n";
	foreach ($this->comments as $comment) 
	{
		$author = JText::_('WIKI_AUTHOR_ANONYMOUS');
		$cuser = new Hubzero_User_Profile();
		$cuser->load( $comment->created_by );
		if ($comment->anonymous != 1) {
			$author = JText::_('WIKI_AUTHOR_UNKNOWN');
			//$cuser =& JUser::getInstance($comment->created_by);
			if (is_object($cuser)) {
				$author = $cuser->get('name');
			}
		}

		$html .= "\t".'<li class="comment '.$this->c.'" id="c'.$comment->id.'">'."\n";
		$html .= "\t\t".'<a name="c'.$comment->id.'"></a>'."\n";
		$html .= "\t\t".'<p class="comment-member-photo">'."\n";
		$html .= "\t\t".'	<img src="'.Hubzero_User_Profile_Helper::getMemberPhoto($cuser, $comment->anonymous).'" alt="" />'."\n";
		$html .= "\t\t".'</p><!-- / .comment-member-photo -->'."\n";
		$html .= "\t\t".'<div class="comment-content">'."\n";
		if ($comment->rating) {
			switch ($comment->rating) 
			{
				case 0:   $cls = ' no-stars';        break;
				case 0.5: $cls = ' half-stars';      break;
				case 1:   $cls = ' one-stars';       break;
				case 1.5: $cls = ' onehalf-stars';   break;
				case 2:   $cls = ' two-stars';       break;
				case 2.5: $cls = ' twohalf-stars';   break;
				case 3:   $cls = ' three-stars';     break;
				case 3.5: $cls = ' threehalf-stars'; break;
				case 4:   $cls = ' four-stars';      break;
				case 4.5: $cls = ' fourhalf-stars';  break;
				case 5:   $cls = ' five-stars';      break;
				default:  $cls = ' no-stars';        break;
			}
			$html .= "\t\t\t".'<p><span class="avgrating'.$cls.'"><span>'.JText::sprintf('WIKI_COMMENT_RATING',$comment->rating).'</span></span></p>'."\n";
		}
		$html .= "\t\t".'	<p class="comment-title">'."\n";
		$html .= "\t\t".'		<strong>'. $author.'</strong> '."\n";
		$html .= "\t\t".'		<a class="permalink" href="'.JRoute::_('index.php?option='.$this->option.'&scope='.$this->page->scope.'&pagename='.$this->page->pagename.'&task=comments#c'.$comment->id).'" title="'. JText::_('Permalink').'">@ <span class="time">'. JHTML::_('date',$comment->created, '%I:%M %p', 0).'</span> on <span class="date">'.JHTML::_('date',$comment->created, '%d %b %Y', 0).'</span>';
		if ($this->level == 1) {
			$html .= ' to revision '.$comment->version;
		}
		$html .= '</a>'."\n";
		$html .= "\t\t".'	</p><!-- / .comment-title -->'."\n";
		//$html .= (trim($chtml)) ? trim($chtml).n : JText::_('(No comment.)').n;
		if ($comment->ctext) {
			//$html .= "\t\t\t".$parser->parse( "\n".trim(stripslashes($comment->ctext)))."\n";
			$html .= (is_object($parser)) ? $parser->parse( "\n".trim(stripslashes($comment->ctext)) ) : nl2br( trim(stripslashes($comment->ctext)) );
		} else {
			$html .= "\t\t\t".'<p class="comment-none">'.JText::_('No comment.').'</p>'."\n";
		}
		if ($this->level < 3) {
			$html .= "\t\t\t".'<p class="comment-options">'."\n";
			$html .= "\t\t\t\t".'<a class="reply" href="'.JRoute::_('index.php?option='.$this->option.'&scope='.$this->page->scope.'&pagename='.$this->page->pagename.'&task=addcomment&parent='.$comment->id).'" title="'.JText::sprintf('WIKI_COMMENT_REPLY_TO',$author).'">'.JText::_('Reply').'</a>'."\n";
			$html .= "\t\t\t".'</p>'."\n";
		}
		//$html .= t.t.t.' | <a class="abuse" href="'.JRoute::_('index.php?option='.$this->option.a.'scope='.$this->page->scope.a.'pagename='.$this->page->pagename.a.'task=reportcomment'.a.'id='.$comment->id).'">'.JText::_('WIKI_COMMENT_REPORT').'</a>';
		//$html .= '</p><p class="actions">&nbsp;</p>'.n;
		$html .= "\t\t".'</div><!-- .comment-content -->'."\n";
		if (isset($comment->children)) {
			//$html .= WikiHtml::commentList($comment->children,$this->page,$this->option,$c,$level++);
			$view = new JView( array('name'=>'comments','layout'=>'list') );
			$view->option = $this->option;
			$view->page = $this->page;
			$view->comments = $comment->children;
			$view->c = $this->c;
			$view->level = ($this->level+1);
			$html .= $view->loadTemplate();
		}
		$html .= "\t".'</li>'."\n";

		$i++;
		$this->c = ($this->c == 'odd') ? 'even' : 'odd';
	}
	$html .= '</ol>'."\n";
}

echo $html;
