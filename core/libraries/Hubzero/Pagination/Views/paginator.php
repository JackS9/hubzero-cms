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

// Initialise variables.
$limits = array();

// Make the option list.
if ($this->limits)
{
	foreach ($this->limits as $val)
	{
		$limits[] = \Hubzero\Html\Builder\Select::option($val);
	}
}

/**
 * Method to create an active pagination link to the item
 *
 * @param   Item    $item  The object with which to make an active link.
 * @return  string  HTML link
 */
function paginator_item_active($item, $prefix)
{
	if (App::isAdmin())
	{
		return '<a title="' . $item->text . '" onclick="document.adminForm.' . $prefix . 'limitstart.value=' . ($item->base > 0 ? $item->base : 0) . '; Joomla.submitform();return false;">' . $item->text . '</a>';
	}
	else
	{
		return '<a title="' . $item->text . '" href="' . $item->link . '" ' . ($item->rel ? 'rel="' . $item->rel . '" ' : '') . 'class="pagenav">' . $item->text . '</a>';
	}
}
?>
<nav class="pagination">
	<ul class="list-footer">
		<li class="counter">
			<?php
			$fromResult = $this->start + 1;

			// If the limit is reached before the end of the list.
			if ($this->start + $this->limit < $this->total)
			{
				$toResult = $this->start + $this->limit;
			}
			else
			{
				$toResult = $this->total;
			}

			// If there are results found.
			if ($this->total > 0)
			{
				echo Lang::txt('JLIB_HTML_RESULTS_OF', $fromResult, $toResult, $this->total);
			}
			else
			{
				echo Lang::txt('JLIB_HTML_NO_RECORDS_FOUND');
			}
			?>
		</li>
		<li class="limit">
			<label for="<?php echo $this->prefix; ?>limit"><?php echo Lang::txt('JGLOBAL_DISPLAY_NUM'); ?></label> 
			<?php
			// Build the select list.
			$selected = $this->viewall ? 0 : $this->limit;

			$attr = 'class="inputbox" size="1" onchange="this.form.submit()"';
			if (App::isAdmin())
			{
				$attr = 'class="inputbox" size="1" onchange="Joomla.submitform();"';
			}

			echo \Hubzero\Html\Builder\Select::genericlist($limits, $this->pages->prefix . 'limit', $attr, 'value', 'text', $selected);
			?>
		</li>
		<li class="pagination-start start">
			<?php if ($this->pages->start->base !== null) { ?>
				<?php echo paginator_item_active($this->pages->start, $this->prefix); ?>
			<?php } else { ?>
				<span class="pagenav"><?php echo $this->pages->start->text; ?></span>
			<?php } ?>
		</li>
		<li class="pagination-prev prev">
			<?php if ($this->pages->previous->base !== null) { ?>
				<?php echo paginator_item_active($this->pages->previous, $this->prefix); ?>
			<?php } else { ?>
				<span class="pagenav"><?php echo $this->pages->previous->text; ?></span>
			<?php } ?>
		</li>
		<?php if ($this->pages->ellipsis && $this->pages->i > 1) { ?>
			<li class="page"><span>...</span></li>
		<?php } ?>
		<?php
		for (; $this->pages->i <= $this->pages->stoploop && $this->pages->i <= $this->pages->total; $this->pages->i++)
		{
			if (isset($this->pages->pages[$this->pages->i]))
			{
				$page = $this->pages->pages[$this->pages->i];
				if ($page->base !== null)
				{
					?>
					<li class="page"><?php echo paginator_item_active($page, $this->prefix); ?></li>
					<?php
				}
				else
				{
					?>
					<li class="page"><strong><?php echo $page->text; ?></strong></li>
					<?php
				}
			}
		}
		?>
		<?php if ($this->pages->ellipsis && ($this->pages->i - 1) < $this->pages->total) { ?>
			<li class="page"><span>...</span></li>
		<?php } ?>
		<li class="pagination-next next">
			<?php if ($this->pages->next->base !== null) { ?>
				<?php echo paginator_item_active($this->pages->next, $this->prefix); ?>
			<?php } else { ?>
				<span class="pagenav"><?php echo $this->pages->next->text; ?></span>
			<?php } ?>
		</li>
		<li class="pagination-end end">
			<?php if ($this->pages->end->base !== null) { ?>
				<?php echo paginator_item_active($this->pages->end, $this->prefix); ?>
			<?php } else { ?>
				<span class="pagenav"><?php echo $this->pages->end->text; ?></span>
			<?php } ?>
		</li>
	</ul>
	<input type="hidden" name="<?php echo $this->prefix; ?>limitstart" value="<?php echo $this->start; ?>" />
</nav>