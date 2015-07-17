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

// No direct access
defined('_HZEXEC_') or die();

Lang::load('tpl_' . $this->template) ||
Lang::load('tpl_' . $this->template, __DIR__);

$browser = new \Hubzero\Browser\Detector();
?>
<!DOCTYPE html>
<!--[if lt IE 7 ]> <html dir="<?php echo $this->direction; ?>" lang="<?php echo $this->language; ?>" class="<?php echo $this->direction; ?> ie ie6"> <![endif]-->
<!--[if IE 7 ]>    <html dir="<?php echo $this->direction; ?>" lang="<?php echo $this->language; ?>" class="<?php echo $this->direction; ?> ie ie7"> <![endif]-->
<!--[if IE 8 ]>    <html dir="<?php echo $this->direction; ?>" lang="<?php echo $this->language; ?>" class="<?php echo $this->direction; ?> ie ie8"> <![endif]-->
<!--[if IE 9 ]>    <html dir="<?php echo $this->direction; ?>" lang="<?php echo $this->language; ?>" class="<?php echo $this->direction; ?> ie ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html dir="<?php echo $this->direction; ?>" lang="<?php echo $this->language; ?>" class="<?php echo $this->direction . ' ' . $browser->name() . ' ' . $browser->name() . $browser->major(); ?>"> <!--<![endif]-->
	<head>
		<link type="text/css" rel="stylesheet" href="<?php echo $this->baseurl; ?>/core/templates/<?php echo $this->template; ?>/css/error.css?v=<?php echo filemtime(__DIR__ . DS . 'css' . DS . 'error.css'); ?>" />

		<!--[if lt IE 9]>
			<script type="text/javascript" src="<?php echo $this->baseurl; ?>/core/templates/<?php echo $this->template; ?>/js/html5.js"></script>
		<![endif]-->

		<!--[if IE 9]>
			<link type="text/css" rel="stylesheet" href="<?php echo $this->baseurl; ?>/core/templates/<?php echo $this->template; ?>/css/browser/ie9.css" />
		<![endif]-->
		<!--[if IE 8]>
			<link type="text/css" rel="stylesheet" href="<?php echo $this->baseurl; ?>/core/templates/<?php echo $this->template; ?>/css/browser/ie8.css" />
		<![endif]-->
	</head>
	<body id="error-body">
		<header id="header" role="banner">
			<h1><a href="<?php echo Request::root(); ?>"><?php echo Config::get('sitename'); ?></a></h1>

			<ul class="user-options">
				<li data-title="<?php echo Lang::txt('TPL_KAMELEON_LOG_OUT'); ?>">
					<?php
					//Display an harcoded logout
					$task = Request::getCmd('task');

					$logoutLink = Route::url('index.php?option=com_login&task=logout&' . Session::getFormToken() . '=1');
					if ($task == 'edit' || $task == 'editA' || Request::getInt('hidemainmenu')) :
						$logoutLink = '';
					endif;

					$output = array();
					$output[] = '<a class="logout" href="' . $logoutLink . '">' . Lang::txt('TPL_KAMELEON_LOG_OUT') . '</a>';

					// Reverse rendering order for rtl display.
					if ($this->direction == 'rtl') :
						$output = array_reverse($output);
					endif;

					// Output the items.
					foreach ($output as $item) :
						echo $item;
					endforeach;
					?>
				</li>
			</ul>
		</header><!-- / #header -->

		<div id="wrap">
			<nav role="navigation" class="main-navigation">
				<div class="inner-wrap">
					<ul id="menu">
						<li><a href="<?php echo Route::url('index.php'); ?>"><?php echo Lang::txt('TPL_KAMELEON_CONTROL_PANEL') ?></a></li>
						<li><a href="<?php echo Route::url('index.php?option=com_help'); ?>"><?php echo Lang::txt('TPL_KAMELEON_HELP'); ?></a></li>
					</ul>
				</div>
			</nav><!-- / .main-navigation -->

			<section id="component-content">
				<div id="toolbar-box" class="toolbar-box">
					<div class="pagetitle icon-48-alert">
						<h2><?php echo Lang::txt('TPL_KAMELEON_ERROR_OCCURRED'); ?></h2>
					</div>
				</div><!-- / #toolbar-box -->

				<div id="errorbox">
					<div class="col width-50 fltlft">
						<h3 class="error-code"><?php echo $this->error->getCode() ?></h3>
					</div>
					<div class="col width-50 fltrt">
						<p class="error"><?php echo $this->error->getMessage(); ?></p>
					</div>
					<div class="clr"></div>
				</div>

				<?php if ($this->debug) { ?>
					<div class="backtrace-wrap">
						<?php echo $this->renderBacktrace(); ?>
					</div>
				<?php } ?>

				<noscript>
					<?php echo Lang::txt('JGLOBAL_WARNJAVASCRIPT') ?>
				</noscript>
			</section><!-- / #component-content -->
		</div><!-- / #wrap -->

		<footer id="footer">
			<section class="basement">
				<p class="copyright">
					<?php echo Lang::txt('TPL_KAMELEON_COPYRIGHT', Request::root(), Config::get('sitename'), date("Y")); ?>
				</p>
				<p class="promotion">
					<?php echo Lang::txt('TPL_KAMELEON_POWERED_BY', App::version()); ?>
				</p>
			</section><!-- / .basement -->
		</footer><!-- / #footer -->
	</body>
</html>