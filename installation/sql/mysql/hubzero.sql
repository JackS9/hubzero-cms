#
# @package      hubzero-cms
# @file         installation/sql/mysql/hubzero.sql
# @author       Nicholas J. Kisseberth <nkissebe@purdue.edu>
# @copyright    Copyright (c) 2010-2012 Purdue University. All rights reserved.
# @license      http://www.gnu.org/licenses/gpl2.html GPLv2
#
# Copyright (c) 2010-2012 Purdue University
# All rights reserved.
#
# This file is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation, either version 2 of the License, or (at your
# option) any later version.
#
# This file is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# HUBzero is a registered trademark of Purdue University.
#

#
# Last Migration Applied: Migration20130816143341ComCitations.php
#

CREATE TABLE `app` (
  `appname` varchar(80) NOT NULL DEFAULT '',
  `geometry` varchar(9) NOT NULL DEFAULT '',
  `depth` smallint(5) unsigned NOT NULL DEFAULT '16',
  `hostreq` bigint(20) unsigned NOT NULL DEFAULT '0',
  `userreq` bigint(20) unsigned NOT NULL DEFAULT '0',
  `timeout` int(10) unsigned NOT NULL DEFAULT '0',
  `command` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `display` (
  `hostname` varchar(40) NOT NULL DEFAULT '',
  `dispnum` int(10) unsigned DEFAULT '0',
  `geometry` varchar(9) NOT NULL DEFAULT '',
  `depth` smallint(5) unsigned NOT NULL DEFAULT '16',
  `sessnum` bigint(20) unsigned DEFAULT '0',
  `vncpass` varchar(16) NOT NULL DEFAULT '',
  `status` varchar(20) NOT NULL DEFAULT '',
  KEY `idx_hostname` (`hostname`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `domainclass` (
  `class` tinyint(4) NOT NULL DEFAULT '0',
  `country` varchar(4) NOT NULL,
  `domain` varchar(64) NOT NULL,
  `name` tinytext NOT NULL,
  `state` varchar(4) NOT NULL,
  PRIMARY KEY (`domain`),
  KEY `idx_class` (`class`) USING BTREE,
  KEY `idx_domain_class` (`domain`,`class`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `domainclasses` (
  `class` tinyint(4) NOT NULL DEFAULT '0',
  `name` varchar(64) NOT NULL,
  PRIMARY KEY (`class`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `fileperm` (
  `sessnum` bigint(20) unsigned NOT NULL DEFAULT '0',
  `fileuser` varchar(32) NOT NULL DEFAULT '',
  `fwhost` varchar(40) NOT NULL DEFAULT '',
  `fwport` smallint(5) unsigned NOT NULL DEFAULT '0',
  `cookie` varchar(16) NOT NULL DEFAULT '',
  PRIMARY KEY (`sessnum`,`fileuser`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `host` (
  `hostname` varchar(40) NOT NULL DEFAULT '',
  `provisions` bigint(20) unsigned NOT NULL DEFAULT '0',
  `status` varchar(20) NOT NULL DEFAULT '',
  `uses` smallint(5) unsigned NOT NULL DEFAULT '0',
  `portbase` int(11) NOT NULL DEFAULT '0',
  `venue_id` int(11),
  PRIMARY KEY (`hostname`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `hosttype` (
  `name` varchar(40) NOT NULL DEFAULT '',
  `value` bigint(20) unsigned NOT NULL DEFAULT '0',
  `description` varchar(255) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `job` (
  `sessnum` bigint(20) unsigned NOT NULL DEFAULT '0',
  `jobid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `superjob` bigint(20) unsigned NOT NULL DEFAULT '0',
  `username` varchar(32) NOT NULL DEFAULT '',
  `event` varchar(40) NOT NULL DEFAULT '',
  `ncpus` smallint(5) unsigned NOT NULL DEFAULT '0',
  `venue` varchar(80) NOT NULL DEFAULT '',
  `start` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `heartbeat` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `active` smallint(2) NOT NULL DEFAULT '1',
  UNIQUE KEY `uidx_jobid` (`jobid`),
  KEY `idx_start` (`start`),
  KEY `idx_heartbeat` (`heartbeat`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `joblog` (
  `sessnum` bigint(20) unsigned NOT NULL DEFAULT '0',
  `job` int(10) unsigned NOT NULL DEFAULT '0',
  `superjob` bigint(20) unsigned NOT NULL DEFAULT '0',
  `event` varchar(40) NOT NULL DEFAULT '',
  `start` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `walltime` double unsigned DEFAULT '0',
  `cputime` double unsigned DEFAULT '0',
  `ncpus` smallint(5) unsigned NOT NULL DEFAULT '0',
  `status` smallint(5) unsigned DEFAULT '0',
  `venue` varchar(80) NOT NULL DEFAULT '',
  PRIMARY KEY (`sessnum`,`job`,`event`,`venue`),
  KEY `idx_sessnum` (`sessnum`),
  KEY `idx_event` (`event`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__abuse_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(50) DEFAULT NULL,
  `referenceid` int(11) DEFAULT '0',
  `report` text NOT NULL,
  `created_by` int(11) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `state` int(3) DEFAULT '0',
  `subject` varchar(150) DEFAULT NULL,
  `reviewed` DATETIME  NOT NULL  DEFAULT '0000-00-00 00:00:00',
  `reviewed_by` INT(11)  NOT NULL  DEFAULT '0',
  `note` TEXT  NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__announcements` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `scope` varchar(100) DEFAULT NULL,
  `scope_id` int(11) DEFAULT NULL,
  `content` text,
  `priority` tinyint(2) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) NOT NULL DEFAULT '0',
  `state` tinyint(2) NOT NULL DEFAULT '0',
  `publish_up` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `publish_down` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `sticky` tinyint(2) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__answers_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rid` int(11) NOT NULL DEFAULT '0',
  `ip` varchar(15) DEFAULT NULL,
  `helpful` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__answers_questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subject` varchar(250) DEFAULT NULL,
  `question` text,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) DEFAULT NULL,
  `state` tinyint(3) NOT NULL DEFAULT '0',
  `anonymous` tinyint(2) NOT NULL DEFAULT '0',
  `email` tinyint(2) DEFAULT '0',
  `helpful` int(11) DEFAULT '0',
  `reward` tinyint(2) DEFAULT '0',
  PRIMARY KEY (`id`),
  FULLTEXT KEY `ftidx_question` (`question`),
  FULLTEXT KEY `ftidx_subject` (`subject`),
  FULLTEXT KEY `ftidx_question_subject` (`question`,`subject`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__answers_questions_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `qid` int(11) NOT NULL DEFAULT '0',
  `expires` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `voter` int(11) DEFAULT NULL,
  `ip` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__answers_responses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `qid` int(11) NOT NULL DEFAULT '0',
  `answer` text,
  `created_by` varchar(50) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `helpful` int(11) NOT NULL DEFAULT '0',
  `nothelpful` int(11) NOT NULL DEFAULT '0',
  `state` tinyint(3) NOT NULL DEFAULT '0',
  `anonymous` tinyint(2) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  FULLTEXT KEY `ftidx_answer` (`answer`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__auth_domain` (
  `authenticator` varchar(255) DEFAULT NULL,
  `domain` varchar(255) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `params` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__auth_link` (
  `auth_domain_id` int(11) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `params` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `linked_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__author_assoc` (
  `subtable` varchar(50) NOT NULL DEFAULT '',
  `subid` int(11) NOT NULL DEFAULT '0',
  `authorid` int(11) NOT NULL DEFAULT '0',
  `ordering` int(11) DEFAULT NULL,
  `role` varchar(50) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `organization` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`subtable`,`subid`,`authorid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__author_role_types` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL DEFAULT '0',
  `type_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__author_roles` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `alias` varchar(255) DEFAULT NULL,
  `state` tinyint(3) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) NOT NULL DEFAULT '0',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__author_stats` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `authorid` int(11) NOT NULL,
  `tool_users` bigint(20) DEFAULT NULL,
  `andmore_users` bigint(20) DEFAULT NULL,
  `total_users` bigint(20) DEFAULT NULL,
  `datetime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `period` tinyint(4) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__billboard_collection` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__billboards` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `collection_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `header` varchar(255) DEFAULT NULL,
  `text` text,
  `learn_more_text` varchar(255) DEFAULT NULL,
  `learn_more_target` varchar(255) DEFAULT NULL,
  `learn_more_class` varchar(255) DEFAULT NULL,
  `learn_more_location` varchar(255) DEFAULT NULL,
  `background_img` varchar(255) DEFAULT NULL,
  `padding` varchar(255) DEFAULT NULL,
  `alias` varchar(255) DEFAULT NULL,
  `css` text,
  `published` tinyint(1) DEFAULT '0',
  `ordering` int(11) DEFAULT NULL,
  `checked_out` int(11) DEFAULT '0',
  `checked_out_time` datetime DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__blog_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entry_id` int(11) DEFAULT '0',
  `content` text,
  `created` datetime DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) DEFAULT '0',
  `anonymous` tinyint(2) DEFAULT '0',
  `parent` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_entry_id` (`entry_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__blog_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `alias` varchar(255) DEFAULT NULL,
  `content` text,
  `created` datetime DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) DEFAULT '0',
  `state` tinyint(2) DEFAULT '0',
  `publish_up` datetime DEFAULT '0000-00-00 00:00:00',
  `publish_down` datetime DEFAULT '0000-00-00 00:00:00',
  `params` tinytext,
  `group_id` int(11) DEFAULT '0',
  `hits` int(11) DEFAULT '0',
  `allow_comments` tinyint(2) DEFAULT '0',
  `scope` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  FULLTEXT KEY `ftidx_title` (`title`),
  FULLTEXT KEY `ftidx_content` (`content`),
  FULLTEXT KEY `ftidx_title_content` (`title`,`content`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__cart` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL DEFAULT '0',
  `itemid` int(11) NOT NULL DEFAULT '0',
  `type` varchar(20) DEFAULT NULL,
  `quantity` int(11) NOT NULL DEFAULT '0',
  `added` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `selections` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__cart_cart_items` (
  `crtId` int(16) NOT NULL,
  `sId` int(16) NOT NULL,
  `crtiQty` int(5) DEFAULT NULL,
  `crtiOldQty` int(5) DEFAULT NULL,
  `crtiPrice` decimal(10,2) DEFAULT NULL,
  `crtiOldPrice` decimal(10,2) DEFAULT NULL,
  `crtiName` varchar(255) DEFAULT NULL,
  `crtiAvailable` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`crtId`,`sId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
		
CREATE TABLE `#__cart_carts` (
  `crtId` int(16) NOT NULL AUTO_INCREMENT,
  `crtCreated` datetime DEFAULT NULL,
  `crtLastUpdated` datetime DEFAULT NULL,
  `uidNumber` int(16) DEFAULT NULL,
  PRIMARY KEY (`crtId`),
  UNIQUE KEY `uidx_uidNumber` (`uidNumber`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__cart_coupons` (
  `crtId` int(16) NOT NULL,
  `cnId` int(16) NOT NULL,
  `crtCnAdded` datetime DEFAULT NULL,
  `crtCnStatus` char(15) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
		
CREATE TABLE `#__cart_memberships` (
  `crtmId` int(16) NOT NULL AUTO_INCREMENT,
  `pId` int(16) DEFAULT NULL,
  `crtId` int(16) DEFAULT NULL,
  `crtmExpires` datetime DEFAULT NULL,
  PRIMARY KEY (`crtmId`),
  UNIQUE KEY `uidx_pId_crtId` (`pId`,`crtId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__cart_saved_addresses` (
  `saId` int(16) NOT NULL AUTO_INCREMENT,
  `uidNumber` int(16) NOT NULL,
  `saToFirst` char(100) NOT NULL,
  `saToLast` char(100) NOT NULL,
  `saAddress` char(255) NOT NULL,
  `saCity` char(25) NOT NULL,
  `saState` char(2) NOT NULL,
  `saZip` char(10) NOT NULL,
  PRIMARY KEY (`saId`),
  UNIQUE KEY `uidx_uidNumber_saToFirst_saToLast_saAddress_saZip` (`uidNumber`,`saToFirst`,`saToLast`,`saAddress`(100),`saZip`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__cart_transaction_info` (
  `tId` int(16) NOT NULL,
  `tiShippingToFirst` char(100) DEFAULT NULL,
  `tiShippingToLast` char(100) DEFAULT NULL,
  `tiShippingAddress` char(255) DEFAULT NULL,
  `tiShippingCity` char(25) DEFAULT NULL,
  `tiShippingState` char(2) DEFAULT NULL,
  `tiShippingZip` char(10) DEFAULT NULL,
  `tiTotal` decimal(10,2) DEFAULT NULL,
  `tiSubtotal` decimal(10,2) DEFAULT NULL,
  `tiTax` decimal(10,2) DEFAULT NULL,
  `tiShipping` decimal(10,2) DEFAULT NULL,
  `tiShippingDiscount` decimal(10,2) DEFAULT NULL,
  `tiDiscounts` decimal(10,2) DEFAULT NULL,
  `tiItems` text,
  `tiPerks` text,
  `tiMeta` text,
  `tiCustomerStatus` char(15) DEFAULT 'unconfirmed',
  PRIMARY KEY (`tId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
		
CREATE TABLE `#__cart_transaction_items` (
  `tId` int(16) NOT NULL,
  `sId` int(16) NOT NULL,
  `tiQty` int(5) DEFAULT NULL,
  `tiPrice` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`tId`,`sId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
		
CREATE TABLE `#__cart_transaction_steps` (
  `tsId` int(16) NOT NULL AUTO_INCREMENT,
  `tId` int(16) NOT NULL,
  `tsStep` char(16) NOT NULL,
  `tsStatus` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`tsId`),
  UNIQUE KEY `uidx_tId_tsStep` (`tId`,`tsStep`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
		
CREATE TABLE `#__cart_transactions` (
  `tId` int(16) NOT NULL AUTO_INCREMENT,
  `crtId` int(16) DEFAULT NULL,
  `tCreated` datetime DEFAULT NULL,
  `tLastUpdated` datetime DEFAULT NULL,
  `tStatus` char(32) DEFAULT NULL,
  PRIMARY KEY (`tId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__citations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(200) DEFAULT NULL,
  `type` varchar(30) DEFAULT NULL,
  `published` int(3) NOT NULL DEFAULT '1',
  `affiliated` int(3) DEFAULT NULL,
  `fundedby` int(3) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `address` varchar(250) DEFAULT NULL,
  `author` text,
  `booktitle` varchar(250) DEFAULT NULL,
  `chapter` varchar(250) DEFAULT NULL,
  `cite` varchar(250) DEFAULT NULL,
  `edition` varchar(250) DEFAULT NULL,
  `editor` varchar(250) DEFAULT NULL,
  `eprint` varchar(250) DEFAULT NULL,
  `howpublished` varchar(250) DEFAULT NULL,
  `institution` varchar(250) DEFAULT NULL,
  `isbn` varchar(50) DEFAULT NULL,
  `journal` varchar(250) DEFAULT NULL,
  `key` varchar(250) DEFAULT NULL,
  `location` varchar(250) DEFAULT NULL,
  `month` varchar(50) DEFAULT NULL,
  `note` text,
  `number` varchar(50) DEFAULT NULL,
  `organization` varchar(250) DEFAULT NULL,
  `pages` varchar(250) DEFAULT NULL,
  `publisher` varchar(250) DEFAULT NULL,
  `series` varchar(250) DEFAULT NULL,
  `school` varchar(250) DEFAULT NULL,
  `title` varchar(250) DEFAULT NULL,
  `url` varchar(250) DEFAULT NULL,
  `volume` int(11) DEFAULT NULL,
  `year` int(4) DEFAULT NULL,
  `doi` varchar(250) DEFAULT NULL,
  `ref_type` varchar(50) DEFAULT NULL,
  `date_submit` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_accept` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `date_publish` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `software_use` int(3) DEFAULT NULL,
  `res_edu` int(3) DEFAULT NULL,
  `exp_list_exp_data` int(3) DEFAULT NULL,
  `exp_data` int(3) DEFAULT NULL,
  `notes` text,
  `language` varchar(100) DEFAULT NULL,
  `accession_number` varchar(100) DEFAULT NULL,
  `short_title` varchar(250) DEFAULT NULL,
  `author_address` text,
  `keywords` text,
  `abstract` text,
  `call_number` varchar(100) DEFAULT NULL,
  `label` varchar(100) DEFAULT NULL,
  `research_notes` text,
  `params` text,
  PRIMARY KEY (`id`),
  FULLTEXT KEY `ftidx_title_isbn_doi_abstract` (`title`,`isbn`,`doi`,`abstract`),
  FULLTEXT KEY `ftidx_title_isbn_doi_abstract_author_publisher` (`title`,`isbn`,`doi`,`abstract`, `author`, `publisher`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__citations_assoc` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cid` int(11) DEFAULT '0',
  `oid` int(11) DEFAULT '0',
  `type` varchar(50) DEFAULT NULL,
  `tbl` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__citations_authors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cid` int(11) DEFAULT '0',
  `author` varchar(64) DEFAULT NULL,
  `authorid` int(11) DEFAULT '0',
  `uidNumber` int(11) DEFAULT '0',
  `ordering` int(11) NOT NULL DEFAULT '0',
  `givenName` varchar(255) NOT NULL DEFAULT '',
  `middleName` varchar(255) NOT NULL DEFAULT '',
  `surname` varchar(255) NOT NULL DEFAULT '',
  `organization` varchar(255) NOT NULL DEFAULT '',
  `org_dept` varchar(255) NOT NULL DEFAULT '',
  `orgtype` varchar(255) NOT NULL DEFAULT '',
  `countryresident` char(2) NOT NULL DEFAULT '',
  `email` varchar(100) NOT NULL DEFAULT '',
  `ip` varchar(40) NOT NULL DEFAULT '',
  `host` varchar(64) NOT NULL DEFAULT '',
  `countrySHORT` char(2) NOT NULL DEFAULT '',
  `countryLONG` varchar(64) NOT NULL DEFAULT '',
  `ipREGION` varchar(128) NOT NULL DEFAULT '',
  `ipCITY` varchar(128) NOT NULL DEFAULT '',
  `ipLATITUDE` double DEFAULT NULL,
  `ipLONGITUDE` double DEFAULT NULL,
  `in_network` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uidx_cid_author_authorid_uidNumber` (`cid`,`author`,`authorid`,`uidNumber`),
  KEY `idx_authorid` (`authorid`),
  KEY `idx_uidNumber` (`uidNumber`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__citations_format` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `typeid` int(11) DEFAULT NULL,
  `style` varchar(50) DEFAULT NULL,
  `format` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__citations_secondary` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cid` int(11) NOT NULL,
  `sec_cits_cnt` int(11) DEFAULT NULL,
  `search_string` tinytext,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__citations_sponsors` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `sponsor` varchar(150) DEFAULT NULL,
  `link` varchar(200) DEFAULT NULL,
  `image` varchar(200),
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__citations_sponsors_assoc` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `cid` int(11) DEFAULT NULL,
  `sid` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__citations_types` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(255) DEFAULT NULL,
  `type_title` varchar(255) DEFAULT NULL,
  `type_desc` text,
  `type_export` varchar(255) DEFAULT NULL,
  `fields` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__collections` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL DEFAULT '',
  `alias` varchar(255) NOT NULL,
  `object_id` int(11) NOT NULL DEFAULT '0',
  `object_type` varchar(150) NOT NULL DEFAULT '',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) NOT NULL DEFAULT '0',
  `state` tinyint(3) NOT NULL DEFAULT '1',
  `access` tinyint(3) NOT NULL DEFAULT '0',
  `is_default` tinyint(2) NOT NULL DEFAULT '0',
  `description` mediumtext NOT NULL,
  `positive` int(11) NOT NULL DEFAULT '0',
  `negative` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_object_type_object_id` (`object_type`,`object_id`),
  KEY `idx_state` (`state`),
  KEY `idx_access` (`access`),
  KEY `idx_created_by` (`created_by`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__collections_assets` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int(11) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) NOT NULL DEFAULT '0',
  `filename` varchar(255) NOT NULL DEFAULT '',
  `description` mediumtext NOT NULL,
  `state` tinyint(2) NOT NULL DEFAULT '0',
  `type` varchar(50) NOT NULL DEFAULT 'file',
  `ordering` tinyint(3) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_item_id` (`item_id`),
  KEY `idx_created_by` (`created_by`),
  KEY `idx_state` (`state`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__collections_following` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `follower_type` varchar(150) NOT NULL,
  `follower_id` int(11) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `following_type` varchar(150) NOT NULL DEFAULT '',
  `following_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__collections_items` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL DEFAULT '',
  `description` mediumtext NOT NULL,
  `url` varchar(255) NOT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) NOT NULL DEFAULT '0',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(11) NOT NULL DEFAULT '0',
  `state` tinyint(3) NOT NULL DEFAULT '1',
  `access` tinyint(2) NOT NULL DEFAULT '0',
  `positive` int(11) NOT NULL DEFAULT '0',
  `negative` int(11) NOT NULL DEFAULT '0',
  `type` varchar(150) NOT NULL DEFAULT '',
  `object_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_state` (`state`),
  KEY `idx_created_by` (`created_by`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__collections_posts` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) NOT NULL DEFAULT '0',
  `collection_id` int(11) NOT NULL DEFAULT '0',
  `item_id` int(11) NOT NULL DEFAULT '0',
  `description` mediumtext NOT NULL,
  `original` tinyint(2) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_collection_id` (`collection_id`),
  KEY `idx_item_id` (`item_id`),
  KEY `idx_original` (`original`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__collections_votes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `item_id` int(11) NOT NULL DEFAULT '0',
  `voted` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `idx_item_id_user_id` (`item_id`,`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `referenceid` varchar(11) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `comment` text,
  `added` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `added_by` int(11) DEFAULT NULL,
  `state` tinyint(3) NOT NULL DEFAULT '0',
  `anonymous` tinyint(2) NOT NULL DEFAULT '0',
  `email` tinyint(2) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  FULLTEXT KEY `ftidx_comment` (`comment`),
  FULLTEXT KEY `ftidx_referenceid` (`referenceid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
CREATE TABLE `#__courses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `alias` varchar(255) NOT NULL DEFAULT '',
  `group_id` int(11) NOT NULL DEFAULT '0',
  `title` varchar(255) NOT NULL DEFAULT '',
  `state` tinyint(3) NOT NULL DEFAULT '0',
  `type` tinyint(3) NOT NULL DEFAULT '0',
  `access` tinyint(3) NOT NULL DEFAULT '0',
  `blurb` text NOT NULL,
  `description` text NOT NULL,
  `logo` varchar(255) NOT NULL DEFAULT '',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) NOT NULL DEFAULT '0',
  `params` text NOT NULL,
  PRIMARY KEY (`id`),
  FULLTEXT KEY `ftidx_alias_title_blurb` (`alias`,`title`,`blurb`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__courses_announcements` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `offering_id` int(11) NOT NULL DEFAULT '0',
  `content` text,
  `priority` tinyint(2) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) NOT NULL DEFAULT '0',
  `section_id` int(11) NOT NULL DEFAULT '0',
  `state` tinyint(2) NOT NULL DEFAULT '0',
  `publish_up` DATETIME  NOT NULL  DEFAULT '0000-00-00 00:00:00',
  `publish_down` DATETIME  NOT NULL  DEFAULT '0000-00-00 00:00:00',
  `sticky` TINYINT(2)  NOT NULL  DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_offering_id` (`offering_id`),
  KEY `idx_section_id` (`section_id`),
  KEY `idx_created_by` (`created_by`),
  KEY `idx_state` (`state`),
  KEY `idx_priority` (`priority`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__courses_asset_associations` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `asset_id` int(11) NOT NULL DEFAULT '0',
  `scope_id` int(11) NOT NULL DEFAULT '0',
  `scope` varchar(255) NOT NULL DEFAULT 'asset_group',
  `ordering` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_asset_id` (`asset_id`),
  KEY `idx_scope_id` (`scope_id`),
  KEY `idx_scope` (`scope`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__courses_asset_group_types` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `alias` varchar(200) NOT NULL DEFAULT '',
  `type` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__courses_asset_groups` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `unit_id` int(11) NOT NULL DEFAULT '0',
  `alias` varchar(250) NOT NULL,
  `title` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `ordering` int(11) NOT NULL DEFAULT '0',
  `parent` int(11) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) NOT NULL DEFAULT '0',
  `state` tinyint(2) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_unit_id` (`unit_id`),
  KEY `idx_created_by` (`created_by`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__courses_asset_views` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `asset_id` int(11) NOT NULL,
  `course_id` INT(11)  NULL  DEFAULT NULL,
  `viewed` datetime NOT NULL,
  `viewed_by` int(11) NOT NULL,
  `ip` VARCHAR(15) NULL  DEFAULT NULL,
  `url` VARCHAR(255) NULL  DEFAULT NULL,
  `referrer` VARCHAR(255) NULL  DEFAULT NULL,
  `user_agent_string` VARCHAR(255) NULL  DEFAULT NULL,
  `session_id` VARCHAR(200) NULL  DEFAULT NULL, 
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__courses_assets` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL DEFAULT '',
  `content` mediumtext,
  `type` varchar(255) NOT NULL DEFAULT '',
  `subtype` VARCHAR(255)  NOT NULL  DEFAULT 'file',
  `url` varchar(255) NOT NULL DEFAULT '',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) NOT NULL DEFAULT '0',
  `state` tinyint(2) NOT NULL DEFAULT '1',
  `course_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_course_id` (`course_id`),
  KEY `idx_created_by` (`created_by`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__courses_form_answers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `correct` tinyint(4) NOT NULL,
  `left_dist` int(11) NOT NULL,
  `top_dist` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `#__courses_form_deployments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `form_id` int(11) NOT NULL,
  `start_time` timestamp NULL DEFAULT NULL,
  `end_time` timestamp NULL DEFAULT NULL,
  `results_open` varchar(50) DEFAULT NULL,
  `time_limit` int(11) DEFAULT NULL,
  `crumb` varchar(20) NOT NULL,
  `results_closed` varchar(50) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `#__courses_form_questions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `page` int(11) NOT NULL,
  `version` int(11) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `left_dist` int(11) NOT NULL,
  `top_dist` int(11) NOT NULL,
  `height` int(11) NOT NULL,
  `width` int(11) NOT NULL,
  `form_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `#__courses_form_respondent_progress` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `respondent_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `answer_id` int(11) NOT NULL,
  `submitted` DATETIME NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uidx_respondent_id_question_id` (`respondent_id`,`question_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `#__courses_form_respondents` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `deployment_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `started` timestamp NULL DEFAULT NULL,
  `finished` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `#__courses_form_responses` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `respondent_id` int(11) NOT NULL,
  `question_id` int(11) NOT NULL,
  `answer_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_respondent_id` (`respondent_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `#__courses_forms` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` text,
  `active` tinyint(4) NOT NULL DEFAULT '1',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `asset_id` INT(11)  NULL  DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `#__courses_grade_book` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `score` DECIMAL(5,2)  NULL,
  `scope` varchar(255) NOT NULL DEFAULT 'asset',
  `scope_id` int(11) NOT NULL DEFAULT '0',
  `override` DECIMAL(5,2)  NULL  DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uidx_user_id_scope_scope_id` (`user_id`, `scope`, `scope_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__courses_grade_policies` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `description` mediumtext,
  `threshold` decimal(3,2) DEFAULT NULL,
  `exam_weight` decimal(3,2) DEFAULT NULL,
  `quiz_weight` decimal(3,2) DEFAULT NULL,
  `homework_weight` decimal(3,2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__courses_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `scope_id` int(11) NOT NULL DEFAULT '0',
  `scope` varchar(100) NOT NULL DEFAULT '',
  `timestamp` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `user_id` int(11) NOT NULL DEFAULT '0',
  `action` varchar(50) NOT NULL DEFAULT '',
  `comments` text NOT NULL,
  `actor_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__courses_members` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `course_id` int(11) NOT NULL DEFAULT '0',
  `offering_id` int(11) NOT NULL DEFAULT '0',
  `section_id` int(11) NOT NULL DEFAULT '0',
  `role_id` int(11) NOT NULL DEFAULT '0',
  `permissions` mediumtext NOT NULL,
  `enrolled` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `student` tinyint(2) NOT NULL DEFAULT '0',
  `first_visit` DATETIME  NOT NULL  DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `idx_offering_id` (`offering_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_role_id` (`role_id`),
  KEY `idx_section_id` (`section_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__courses_member_badges` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `member_id` int(11) NOT NULL,
  `earned` int(1) DEFAULT NULL,
  `earned_on` datetime DEFAULT NULL,
  `claim_url` varchar(255) DEFAULT NULL,
  `action` VARCHAR(255) NULL DEFAULT NULL,
  `action_on` DATETIME NULL  DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uidx_member_id` (`member_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__courses_member_notes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `scope` varchar(255) NOT NULL DEFAULT '',
  `scope_id` int(11) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) NOT NULL DEFAULT '0',
  `content` mediumtext NOT NULL,
  `pos_x` int(11) NOT NULL DEFAULT '0',
  `pos_y` int(11) NOT NULL DEFAULT '0',
  `width` int(11) NOT NULL DEFAULT '0',
  `height` int(11) NOT NULL DEFAULT '0',
  `state` tinyint(2) NOT NULL DEFAULT '0',
  `timestamp` time NOT NULL DEFAULT '00:00:00',
  `section_id` INT(11)  NOT NULL  DEFAULT '0',
  `access` TINYINT(2)  NOT NULL  DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_scoped` (`scope`, `scope_id`),
  KEY `idx_createdby` (`created_by`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__courses_offering_badges` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `offering_id` int(11) NOT NULL,
  `badge_id` int(11) NOT NULL,
  `img_url` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__courses_offering_section_dates` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `section_id` int(11) NOT NULL DEFAULT '0',
  `scope` varchar(150) NOT NULL DEFAULT '',
  `scope_id` int(11) NOT NULL DEFAULT '0',
  `publish_up` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `publish_down` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__courses_offering_sections` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `offering_id` int(11) NOT NULL DEFAULT '0',
  `alias` varchar(255) NOT NULL DEFAULT '',
  `title` varchar(255) NOT NULL DEFAULT '',
  `state` tinyint(2) NOT NULL DEFAULT '1',
  `start_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `end_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `publish_up` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `publish_down` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) NOT NULL DEFAULT '0',
  `enrollment` TINYINT(2)  NOT NULL  DEFAULT '0',
  `grade_policy_id` INT(11)  NOT NULL  DEFAULT '1',
  `params` TEXT  NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_offering_id` (`offering_id`),
  KEY `idx_created_by` (`created_by`),
  KEY `idx_state` (`state`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__courses_offerings` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `course_id` int(11) NOT NULL DEFAULT '0',
  `alias` varchar(255) NOT NULL DEFAULT '',
  `title` varchar(255) NOT NULL DEFAULT '',
  `term` varchar(255) NOT NULL DEFAULT '',
  `state` tinyint(2) NOT NULL DEFAULT '1',
  `badge_id` INT(11)  NULL  DEFAULT NULL,
  `publish_up` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `publish_down` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) NOT NULL DEFAULT '0',
  `params` TEXT  NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_course_id` (`course_id`),
  KEY `idx_state` (`state`),
  KEY `idx_created_by` (`created_by`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__courses_page_hits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `offering_id` int(11) NOT NULL DEFAULT '0',
  `page_id` int(11) NOT NULL DEFAULT '0',
  `user_id` int(11) NOT NULL DEFAULT '0',
  `datetime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `ip` varchar(15) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `idx_offering_id` (`offering_id`),
  KEY `idx_page_id` (`page_id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__courses_pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` INT(11)  NOT NULL  DEFAULT '0',
  `offering_id` varchar(100) NOT NULL DEFAULT '0',
  `section_id` INT(11)  NOT NULL  DEFAULT '0',
  `url` varchar(100) NOT NULL DEFAULT '',
  `title` varchar(100) NOT NULL DEFAULT '',
  `content` text NOT NULL,
  `ordering` INT(11)  NOT NULL  DEFAULT '0',
  `active` int(11) NOT NULL DEFAULT '0',
  `privacy` varchar(10) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `idx_offering_id` (`offering_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__courses_reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `course_id` int(11) NOT NULL DEFAULT '0',
  `offering_id` int(11) NOT NULL DEFAULT '0',
  `rating` decimal(2,1) NOT NULL DEFAULT '0.0',
  `content` text NOT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) NOT NULL DEFAULT '0',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(11) NOT NULL DEFAULT '0',
  `anonymous` tinyint(2) NOT NULL DEFAULT '0',
  `parent` int(11) NOT NULL DEFAULT '0',
  `access` tinyint(2) NOT NULL DEFAULT '0',
  `state` tinyint(2) NOT NULL DEFAULT '0',
  `positive` int(11) NOT NULL DEFAULT '0',
  `negative` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__courses_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `offering_id` int(11) NOT NULL DEFAULT '0',
  `alias` varchar(150) NOT NULL,
  `title` varchar(150) NOT NULL DEFAULT '',
  `permissions` mediumtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_offering_id` (`offering_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__courses_units` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `offering_id` int(11) NOT NULL DEFAULT '0',
  `alias` varchar(250) NOT NULL,
  `title` varchar(255) NOT NULL DEFAULT '',
  `description` longtext NOT NULL,
  `ordering` int(11) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) NOT NULL DEFAULT '0',
  `state` tinyint(2) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_offering_id` (`offering_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__courses_offering_section_codes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `section_id` int(11) NOT NULL DEFAULT '0',
  `code` varchar(10) NOT NULL DEFAULT '',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) NOT NULL DEFAULT '0',
  `expires` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `redeemed` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `redeemed_by` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__cron_jobs` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL DEFAULT '',
  `state` tinyint(3) NOT NULL DEFAULT '0',
  `plugin` varchar(255) NOT NULL DEFAULT '',
  `event` varchar(255) NOT NULL DEFAULT '',
  `last_run` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `next_run` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `recurrence` varchar(50) NOT NULL DEFAULT '',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) NOT NULL DEFAULT '0',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(11) NOT NULL DEFAULT '0',
  `active` tinyint(3) NOT NULL DEFAULT '0',
  `ordering` int(11) NOT NULL DEFAULT '0',
  `params` TEXT  NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__document_resource_rel` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `document_id` int(11) NOT NULL,
  `resource_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uidx_id` (`id`),
  UNIQUE KEY `uidx_document_id_resource_id` (`document_id`,`resource_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__document_text_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `body` text,
  `hash` char(40) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uidx_hash` (`hash`),
  FULLTEXT KEY `ftidx_body` (`body`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__doi_mapping` (
  `local_revision` int(11) NOT NULL,
  `doi_label` int(11) NOT NULL,
  `rid` int(11) NOT NULL,
  `alias` varchar(30) DEFAULT NULL,
  `versionid` int(11) DEFAULT '0',
  `doi` varchar(50) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__email_bounces` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(150) DEFAULT NULL,
  `component` varchar(100) DEFAULT NULL,
  `object` varchar(100) DEFAULT NULL,
  `object_id` int(11) DEFAULT NULL,
  `reason` text,
  `date` datetime DEFAULT NULL,
  `resolved` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__event_registration` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event` varchar(100) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(100) DEFAULT NULL,
  `institution` varchar(100) DEFAULT NULL,
  `address` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(10) DEFAULT NULL,
  `zip` varchar(10) DEFAULT NULL,
  `submitted` datetime DEFAULT NULL,
  `active` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__events` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `sid` int(11) NOT NULL DEFAULT '0',
  `catid` int(11) NOT NULL DEFAULT '1',
  `calendar_id` int(11),
  `ical_uid` VARCHAR(255),
  `scope` VARCHAR(100),
  `scope_id` INT(11),
  `title` varchar(255) NOT NULL DEFAULT '',
  `content` longtext NOT NULL,
  `adresse_info` varchar(120) NOT NULL DEFAULT '',
  `contact_info` varchar(120) NOT NULL DEFAULT '',
  `extra_info` varchar(240) NOT NULL DEFAULT '',
  `color_bar` varchar(8) NOT NULL DEFAULT '',
  `useCatColor` tinyint(1) NOT NULL DEFAULT '0',
  `state` tinyint(3) NOT NULL DEFAULT '0',
  `mask` int(11) unsigned NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) unsigned NOT NULL DEFAULT '0',
  `created_by_alias` varchar(100) NOT NULL DEFAULT '',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(11) unsigned NOT NULL DEFAULT '0',
  `checked_out` int(11) unsigned NOT NULL DEFAULT '0',
  `checked_out_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `publish_up` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `publish_down` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `time_zone` varchar(5) DEFAULT NULL,
  `images` text NOT NULL,
  `reccurtype` tinyint(1) NOT NULL DEFAULT '0',
  `reccurday` varchar(4) NOT NULL DEFAULT '',
  `reccurweekdays` varchar(20) NOT NULL DEFAULT '',
  `reccurweeks` varchar(10) NOT NULL DEFAULT '',
  `approved` tinyint(1) NOT NULL DEFAULT '1',
  `announcement` tinyint(1) NOT NULL DEFAULT '0',
  `ordering` int(11) NOT NULL DEFAULT '0',
  `archived` tinyint(1) NOT NULL DEFAULT '0',
  `access` int(11) unsigned NOT NULL DEFAULT '0',
  `hits` int(11) NOT NULL DEFAULT '0',
  `registerby` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `params` text,
  `restricted` varchar(100) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  FULLTEXT KEY `ftidx_title` (`title`),
  FULLTEXT KEY `ftidx_content` (`content`),
  FULLTEXT KEY `ftidx_title_content` (`title`,`content`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__events_calendars` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `scope` varchar(100) DEFAULT NULL,
  `scope_id` int(11) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `color` varchar(100) DEFAULT NULL,
  `published` int(11) DEFAULT 1,
  `url` VARCHAR(255),
  `readonly` TINYINT(4) DEFAULT 0,
  `last_fetched` DATETIME,
  `last_fetched_attempt` DATETIME,
  `failed_attempts` INT(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__events_categories` (
  `id` int(12) NOT NULL DEFAULT '0',
  `color` varchar(8) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__events_config` (
  `param` varchar(100) DEFAULT NULL,
  `value` tinytext
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__events_pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) DEFAULT '0',
  `alias` varchar(100) NOT NULL,
  `title` varchar(250) NOT NULL,
  `pagetext` text,
  `created` datetime DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) DEFAULT '0',
  `modified` datetime DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(11) DEFAULT '0',
  `ordering` int(2) DEFAULT '0',
  `params` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__events_respondent_race_rel` (
  `respondent_id` int(11) DEFAULT NULL,
  `race` varchar(255) DEFAULT NULL,
  `tribal_affiliation` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__events_respondents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) NOT NULL DEFAULT '0',
  `registered` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `affiliation` varchar(50) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `state` varchar(20) DEFAULT NULL,
  `zip` varchar(10) DEFAULT NULL,
  `country` varchar(20) DEFAULT NULL,
  `telephone` varchar(20) DEFAULT NULL,
  `fax` varchar(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `position_description` varchar(50) DEFAULT NULL,
  `highest_degree` varchar(10) DEFAULT NULL,
  `gender` char(1) DEFAULT NULL,
  `disability_needs` tinyint(4) DEFAULT NULL,
  `dietary_needs` varchar(500) DEFAULT NULL,
  `attending_dinner` tinyint(4) DEFAULT NULL,
  `abstract` text,
  `comment` text,
  `arrival` varchar(50) DEFAULT NULL,
  `departure` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__faq` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(250) DEFAULT NULL,
  `alias` varchar(200) DEFAULT NULL,
  `params` text,
  `fulltxt` text,
  `created` datetime DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) DEFAULT '0',
  `modified` datetime DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(11) DEFAULT '0',
  `checked_out` int(11) DEFAULT '0',
  `checked_out_time` datetime DEFAULT '0000-00-00 00:00:00',
  `state` int(3) DEFAULT '0',
  `access` tinyint(3) DEFAULT '0',
  `hits` int(11) DEFAULT '0',
  `version` int(11) DEFAULT '0',
  `section` int(11) NOT NULL DEFAULT '0',
  `category` int(11) DEFAULT '0',
  `helpful` int(11) NOT NULL DEFAULT '0',
  `nothelpful` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  FULLTEXT KEY `ftidx_title` (`title`),
  FULLTEXT KEY `ftidx_title_params_fulltxt` (`title`,`params`,`fulltxt`),
  FULLTEXT KEY `ftidx_params` (`params`),
  FULLTEXT KEY `ftidx_fulltxt` (`fulltxt`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__faq_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) DEFAULT NULL,
  `alias` varchar(200) DEFAULT NULL,
  `description` varchar(255) DEFAULT '',
  `section` int(11) NOT NULL DEFAULT '0',
  `state` tinyint(3) NOT NULL DEFAULT '0',
  `access` tinyint(3) NOT NULL DEFAULT '0',
  `asset_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__faq_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entry_id` int(11) NOT NULL DEFAULT '0',
  `content` text,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) NOT NULL DEFAULT '0',
  `anonymous` tinyint(2) NOT NULL DEFAULT '0',
  `parent` int(11) NOT NULL DEFAULT '0',
  `asset_id` int(11) NOT NULL DEFAULT '0',
  `helpful` int(11) NOT NULL DEFAULT '0',
  `nothelpful` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__faq_helpful_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `object_id` int(11) DEFAULT '0',
  `ip` varchar(15) DEFAULT NULL,
  `vote` varchar(10) DEFAULT NULL,
  `user_id` int(11) DEFAULT '0',
  `type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__feature_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `objectid` int(11) DEFAULT NULL,
  `featured` datetime DEFAULT '0000-00-00 00:00:00',
  `tbl` varchar(255) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__feedback` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) DEFAULT NULL,
  `fullname` varchar(100) DEFAULT '',
  `org` varchar(100) DEFAULT '',
  `quote` text,
  `picture` varchar(250) DEFAULT '',
  `date` datetime DEFAULT '0000-00-00 00:00:00',
  `publish_ok` tinyint(1) DEFAULT '0',
  `contact_ok` tinyint(1) DEFAULT '0',
  `notes` text,
  `short_quote` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__focus_area_resource_type_rel` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `focus_area_id` int(11) NOT NULL,
  `resource_type_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__focus_areas` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tag_id` int(11) NOT NULL,
  `mandatory_depth` int(11) DEFAULT NULL,
  `multiple_depth` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__forum_attachments` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `parent` int(11) NOT NULL DEFAULT '0',
  `post_id` int(11) NOT NULL DEFAULT '0',
  `filename` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_filename_post_id` (`filename`, `post_id`),
  KEY `idx_parent` (`parent`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__forum_categories` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `alias` varchar(255) DEFAULT NULL,
  `description` text,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) NOT NULL DEFAULT '0',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(11) NOT NULL DEFAULT '0',
  `access` tinyint(2) NOT NULL DEFAULT '0',
  `state` tinyint(3) NOT NULL DEFAULT '0',
  `scope` varchar(100)  NOT NULL  DEFAULT 'site',
  `scope_id` int(11) NOT NULL DEFAULT '0',
  `section_id` int(11) NOT NULL DEFAULT '0',
  `closed` tinyint(2) NOT NULL DEFAULT '0',
  `asset_id` int(11) NOT NULL DEFAULT '0',
  `object_id` INT(11)  NOT NULL  DEFAULT '0',
  `ordering` INT(11)  NOT NULL  DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_scope_scope_id` (`scope`, `scope_id`),
  KEY `idx_asset_id` (`asset_id`),
  KEY `idx_object_id` (`object_id`),
  KEY `idx_state` (`state`),
  KEY `idx_access` (`access`),
  KEY `idx_section_id` (`section_id`),
  KEY `idx_closed` (`closed`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__forum_posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_id` int(11) NOT NULL DEFAULT '0',
  `title` varchar(255) DEFAULT NULL,
  `comment` text,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) NOT NULL DEFAULT '0',
  `state` tinyint(3) NOT NULL DEFAULT '0',
  `sticky` tinyint(2) NOT NULL DEFAULT '0',
  `parent` int(11) NOT NULL DEFAULT '0',
  `hits` int(11) NOT NULL DEFAULT '0',
  `scope` varchar(100)  NOT NULL  DEFAULT 'site',
  `scope_id` int(11) NOT NULL DEFAULT '0',
  `scope_sub_id` INT(11)  NOT NULL  DEFAULT '0',
  `access` tinyint(2) NOT NULL DEFAULT '0',
  `anonymous` tinyint(2) NOT NULL DEFAULT '0',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(11) NOT NULL DEFAULT '0',
  `last_activity` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `asset_id` int(11) NOT NULL DEFAULT '0',
  `object_id` INT(11)  NOT NULL  DEFAULT '0',
  `lft` int(11) NOT NULL DEFAULT '0',
  `rgt` int(11) NOT NULL DEFAULT '0',
  `thread` int(11) NOT NULL DEFAULT '0',
  `closed` TINYINT(2)  NOT NULL  DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_scope_scope_id` (`scope`, `scope_id`),
  KEY `idx_category_id` (`category_id`),
  KEY `idx_access` (`access`),
  KEY `idx_asset_id` (`asset_id`),
  KEY `idx_object_id` (`object_id`),
  KEY `idx_state` (`state`),
  KEY `idx_sticky` (`sticky`),
  KEY `idx_parent` (`parent`),
  FULLTEXT KEY `ftidx_comment` (`comment`),
  FULLTEXT KEY `ftidx_comment_title` (`comment`, `title`) 
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__forum_sections` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `alias` varchar(255) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) NOT NULL DEFAULT '0',
  `access` tinyint(2) NOT NULL DEFAULT '0',
  `state` tinyint(3) NOT NULL DEFAULT '0',
  `scope` varchar(100)  NOT NULL  DEFAULT 'site',
  `scope_id` int(11) NOT NULL DEFAULT '0',
  `asset_id` int(11) NOT NULL DEFAULT '0',
  `object_id` INT(11)  NOT NULL  DEFAULT '0',
  `ordering` INT(11)  NOT NULL  DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_scoped` (`scope`, `scope_id`),
  KEY `idx_asset_id` (`asset_id`),
  KEY `idx_object_id` (`object_id`),
  KEY `idx_access` (`access`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__incremental_registration_group_label_rel` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `label_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__incremental_registration_groups` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `hours` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__incremental_registration_labels` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `field` varchar(50) NOT NULL,
  `label` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__incremental_registration_options` (
  `added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `popover_text` text NOT NULL,
  `award_per` int(11) NOT NULL,
  `test_group` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__incremental_registration_popover_recurrence` (
  `idx` int(11) NOT NULL,
  `hours` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__item_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_id` int(11) NOT NULL DEFAULT '0',
  `item_type` varchar(150) NOT NULL,
  `content` text NOT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) NOT NULL DEFAULT '0',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(11) NOT NULL DEFAULT '0',
  `anonymous` tinyint(2) NOT NULL DEFAULT '0',
  `parent` int(11) NOT NULL DEFAULT '0',
  `notify` tinyint(2) NOT NULL DEFAULT '0',
  `access` tinyint(2) NOT NULL DEFAULT '0',
  `state` tinyint(2) NOT NULL DEFAULT '0',
  `positive` int(11) NOT NULL DEFAULT '0',
  `negative` int(11) NOT NULL DEFAULT '0',
  `rating` int(2) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__item_comment_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `comment_id` int(11) NOT NULL DEFAULT '0',
  `filename` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__item_votes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int(11) NOT NULL DEFAULT '0',
  `item_type` varchar(255) DEFAULT NULL,
  `ip` varchar(15) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) NOT NULL DEFAULT '0',
  `vote` tinyint(3) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__jobs_admins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `jid` int(11) NOT NULL DEFAULT '0',
  `uid` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__jobs_applications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `jid` int(11) NOT NULL DEFAULT '0',
  `uid` int(11) NOT NULL DEFAULT '0',
  `applied` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `withdrawn` datetime DEFAULT '0000-00-00 00:00:00',
  `cover` text,
  `resumeid` int(11) DEFAULT '0',
  `status` int(11) DEFAULT '1',
  `reason` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__jobs_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(150) NOT NULL DEFAULT '',
  `ordernum` int(11) NOT NULL DEFAULT '0',
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__jobs_employers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL DEFAULT '0',
  `added` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `subscriptionid` int(11) NOT NULL DEFAULT '0',
  `companyName` varchar(250) DEFAULT '',
  `companyLocation` varchar(250) DEFAULT '',
  `companyWebsite` varchar(250) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__jobs_openings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cid` int(11) DEFAULT '0',
  `employerid` int(11) NOT NULL DEFAULT '0',
  `code` int(11) NOT NULL DEFAULT '0',
  `title` varchar(200) NOT NULL DEFAULT '',
  `companyName` varchar(200) NOT NULL DEFAULT '',
  `companyLocation` varchar(200) DEFAULT '',
  `companyLocationCountry` varchar(100) DEFAULT '',
  `companyWebsite` varchar(200) DEFAULT '',
  `description` text,
  `addedBy` int(11) NOT NULL DEFAULT '0',
  `editedBy` int(11) DEFAULT '0',
  `added` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `edited` datetime DEFAULT '0000-00-00 00:00:00',
  `status` int(3) NOT NULL DEFAULT '0',
  `type` int(3) NOT NULL DEFAULT '0',
  `closedate` datetime DEFAULT '0000-00-00 00:00:00',
  `opendate` datetime DEFAULT '0000-00-00 00:00:00',
  `startdate` datetime DEFAULT '0000-00-00 00:00:00',
  `applyExternalUrl` varchar(250) DEFAULT '',
  `applyInternal` int(3) DEFAULT '0',
  `contactName` varchar(100) DEFAULT '',
  `contactEmail` varchar(100) DEFAULT '',
  `contactPhone` varchar(100) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__jobs_prefs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(10) NOT NULL DEFAULT '0',
  `category` varchar(20) NOT NULL DEFAULT 'resume',
  `filters` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__jobs_resumes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `title` varchar(100) DEFAULT NULL,
  `filename` varchar(100) DEFAULT NULL,
  `main` tinyint(2) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__jobs_seekers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL DEFAULT '0',
  `active` int(11) NOT NULL DEFAULT '0',
  `lookingfor` varchar(255) DEFAULT '',
  `tagline` varchar(255) DEFAULT '',
  `linkedin` varchar(255) DEFAULT '',
  `url` varchar(255) DEFAULT '',
  `updated` datetime DEFAULT '0000-00-00 00:00:00',
  `sought_cid` int(11) DEFAULT '0',
  `sought_type` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__jobs_shortlist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `emp` int(11) NOT NULL DEFAULT '0',
  `seeker` int(11) NOT NULL DEFAULT '0',
  `category` varchar(11) NOT NULL DEFAULT 'resume',
  `jobid` int(11) DEFAULT '0',
  `added` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__jobs_stats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `itemid` int(11) NOT NULL,
  `category` varchar(11) NOT NULL DEFAULT '',
  `total_viewed` int(11) DEFAULT '0',
  `total_shared` int(11) DEFAULT '0',
  `viewed_today` int(11) DEFAULT '0',
  `lastviewed` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__jobs_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(150) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__licenses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `alias` varchar(255) DEFAULT NULL,
  `description` text,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__licenses_tools` (
  `license_id` int(11) DEFAULT '0',
  `tool_id` int(11) DEFAULT '0',
  `created` datetime NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__licenses_users` (
  `license_id` int(11) NOT NULL DEFAULT '0',
  `user_id` int(11) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL,
  PRIMARY KEY (`license_id`,`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__market_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `itemid` int(11) NOT NULL DEFAULT '0',
  `category` varchar(50) DEFAULT NULL,
  `date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `action` varchar(50) DEFAULT NULL,
  `log` text,
  `market_value` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__media_tracking` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `session_id` varchar(200) DEFAULT NULL,
  `ip_address` varchar(100) DEFAULT NULL,
  `object_id` int(11) DEFAULT NULL,
  `object_type` varchar(100) DEFAULT NULL,
  `object_duration` int(11) DEFAULT NULL,
  `current_position` int(11) DEFAULT NULL,
  `farthest_position` int(11) DEFAULT NULL,
  `current_position_timestamp` datetime DEFAULT NULL,
  `farthest_position_timestamp` datetime DEFAULT NULL,
  `completed` int(11) DEFAULT NULL,
  `total_views` int(11) DEFAULT NULL,
  `total_viewing_time` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__metrics_ipgeo_cache` (
  `ip` int(10) NOT NULL DEFAULT '0000000000',
  `countrySHORT` char(2) NOT NULL DEFAULT '',
  `countryLONG` varchar(64) NOT NULL DEFAULT '',
  `ipREGION` varchar(128) NOT NULL DEFAULT '',
  `ipCITY` varchar(128) NOT NULL DEFAULT '',
  `ipLATITUDE` double DEFAULT NULL,
  `ipLONGITUDE` double DEFAULT NULL,
  `lookup_datetime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ip`),
  KEY `idx_lookup_datetime` (`lookup_datetime`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__myhub` (
  `uid` int(11) NOT NULL,
  `prefs` varchar(200) DEFAULT NULL,
  `modified` datetime DEFAULT '0000-00-00 00:00:00'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__myhub_params` (
  `uid` int(11) NOT NULL,
  `mid` int(11) NOT NULL,
  `params` text
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__newsletters` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `alias` varchar(150) DEFAULT NULL,
  `name` varchar(150) DEFAULT NULL,
  `issue` int(11) DEFAULT NULL,
  `type` varchar(50) DEFAULT 'html',
  `template` int(11) DEFAULT NULL,
  `published` int(11) DEFAULT '1',
  `sent` int(11) DEFAULT '0',
  `content` text,
  `tracking` int(11) DEFAULT '1',
  `created` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `modified` datetime DEFAULT NULL,
  `modified_by` int(11) DEFAULT NULL,
  `deleted` int(11) DEFAULT '0',
  `params` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
					
CREATE TABLE `#__newsletter_templates` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `editable` int(11) DEFAULT '1',
  `name` varchar(100) DEFAULT NULL,
  `template` text,
  `primary_title_color` varchar(100) DEFAULT NULL,
  `primary_text_color` varchar(100) DEFAULT NULL,
  `secondary_title_color` varchar(100) DEFAULT NULL,
  `secondary_text_color` varchar(100) DEFAULT NULL,
  `deleted` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
					
CREATE TABLE `#__newsletter_primary_story` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `nid` int(11) NOT NULL,
  `title` varchar(150) DEFAULT NULL,
  `story` text,
  `readmore_title` varchar(100) DEFAULT NULL,
  `readmore_link` varchar(200) DEFAULT NULL,
  `order` int(11) DEFAULT NULL,
  `deleted` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
					
CREATE TABLE `#__newsletter_secondary_story` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `nid` int(11) NOT NULL,
  `title` varchar(150) DEFAULT NULL,
  `story` text,
  `readmore_title` varchar(100) DEFAULT NULL,
  `readmore_link` varchar(200) DEFAULT NULL,
  `order` int(11) DEFAULT NULL,
  `deleted` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
					
CREATE TABLE `#__newsletter_mailings` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `nid` int(11) DEFAULT NULL,
  `lid` int(11) DEFAULT NULL,
  `subject` varchar(250) DEFAULT NULL,
  `body` longtext,
  `headers` text,
  `args` text,
  `tracking` int(11) DEFAULT '1',
  `date` datetime DEFAULT NULL,
  `deleted` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
					
CREATE TABLE `#__newsletter_mailinglists` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(150) DEFAULT NULL,
  `description` text,
  `private` int(11) DEFAULT NULL,
  `deleted` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
					
CREATE TABLE `#__newsletter_mailinglist_unsubscribes` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `mid` int(11) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `reason` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
					
CREATE TABLE `#__newsletter_mailinglist_emails` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `mid` int(11) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `status` varchar(100) DEFAULT NULL,
  `confirmed` int(11) DEFAULT '0',
  `date_added` datetime DEFAULT NULL,
  `date_confirmed` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
					
CREATE TABLE `#__newsletter_mailing_recipients` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `mid` int(11) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `status` varchar(100) DEFAULT NULL,
  `date_added` datetime DEFAULT NULL,
  `date_sent` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
					
CREATE TABLE `#__newsletter_mailing_recipient_actions` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `mailingid` int(11) DEFAULT NULL,
  `action` varchar(100) DEFAULT NULL,
  `action_vars` text,
  `email` varchar(255) DEFAULT NULL,
  `ip` varchar(100) DEFAULT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `countrySHORT` char(2) DEFAULT NULL,
  `countryLONG` varchar(64) DEFAULT NULL,
  `ipREGION` varchar(128) DEFAULT NULL,
  `ipCITY` varchar(128) DEFAULT NULL,
  `ipLATITUDE` double DEFAULT NULL,
  `ipLONGITUDE` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__oaipmh_dcspecs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `query` text NOT NULL,
  `display` int(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__oauthp_consumers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `state` tinyint(4) NOT NULL,
  `token` varchar(250) NOT NULL,
  `secret` varchar(250) NOT NULL,
  `callback_url` varchar(250) NOT NULL,
  `xauth` tinyint(4) NOT NULL,
  `xauth_grant` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__oauthp_nonces` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nonce` varchar(250) NOT NULL,
  `stamp` int(11) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uidx_nonce_stamp` (`nonce`,`stamp`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__oauthp_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `consumer_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `state` tinyint(4) NOT NULL,
  `token` varchar(250) NOT NULL,
  `token_secret` varchar(250) NOT NULL,
  `callback_url` varchar(250) NOT NULL,
  `verifier` varchar(250) NOT NULL,
  `created` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__order_items` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `oid` int(11) NOT NULL DEFAULT '0',
  `uid` int(11) NOT NULL DEFAULT '0',
  `itemid` int(11) NOT NULL DEFAULT '0',
  `price` int(11) NOT NULL DEFAULT '0',
  `quantity` int(11) NOT NULL DEFAULT '0',
  `selections` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__orders` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL DEFAULT '0',
  `type` varchar(20) DEFAULT NULL,
  `total` int(11) DEFAULT '0',
  `status` int(11) NOT NULL DEFAULT '0',
  `details` text,
  `email` varchar(150) DEFAULT NULL,
  `ordered` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `status_changed` datetime DEFAULT '0000-00-00 00:00:00',
  `notes` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__password_blacklist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `word` char(32) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__password_character_class` (
  `flag` int(11) NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` char(32) NOT NULL,
  `regex` char(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__password_rule` (
  `class` char(255) DEFAULT NULL,
  `description` char(255) DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '0',
  `failuremsg` char(255) DEFAULT NULL,
  `grp` char(32) NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ordering` int(11) NOT NULL DEFAULT '0',
  `rule` char(255) DEFAULT NULL,
  `value` char(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__plugin_params` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `object_id` int(11) DEFAULT '0',
  `folder` varchar(100) DEFAULT NULL,
  `element` varchar(100) DEFAULT NULL,
  `params` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__poll_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pollid` int(4) NOT NULL DEFAULT '0',
  `text` text NOT NULL,
  `hits` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_pollid_text` (`pollid`,`text`(1))
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__poll_date` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `vote_id` int(11) NOT NULL DEFAULT '0',
  `poll_id` int(11) NOT NULL DEFAULT '0',
  `voter_ip` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_poll_id` (`poll_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__poll_menu` (
  `pollid` int(11) NOT NULL DEFAULT '0',
  `menuid` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pollid`,`menuid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__polls` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(150) NOT NULL DEFAULT '',
  `alias` VARCHAR(255)  NOT NULL  DEFAULT '',
  `voters` int(9) NOT NULL DEFAULT '0',
  `checked_out` int(11) NOT NULL DEFAULT '0',
  `checked_out_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `published` tinyint(1) NOT NULL DEFAULT '0',
  `access` int(11) NOT NULL DEFAULT '0',
  `lag` int(11) NOT NULL DEFAULT '0',
  `open` tinyint(1) NOT NULL DEFAULT '0',
  `opened` date DEFAULT NULL,
  `closed` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__profile_completion_awards` (
  `user_id` int(11) NOT NULL,
  `name` tinyint(4) NOT NULL DEFAULT '0',
  `orgtype` tinyint(4) NOT NULL DEFAULT '0',
  `organization` tinyint(4) NOT NULL DEFAULT '0',
  `countryresident` tinyint(4) NOT NULL DEFAULT '0',
  `countryorigin` tinyint(4) NOT NULL DEFAULT '0',
  `gender` tinyint(4) NOT NULL DEFAULT '0',
  `url` tinyint(4) NOT NULL DEFAULT '0',
  `reason` tinyint(4) NOT NULL DEFAULT '0',
  `race` tinyint(4) NOT NULL DEFAULT '0',
  `phone` tinyint(4) NOT NULL DEFAULT '0',
  `picture` tinyint(4) NOT NULL DEFAULT '0',
  `opted_out` tinyint(4) NOT NULL DEFAULT '0',
  `logins` int(11) NOT NULL DEFAULT '1',
  `invocations` int(11) NOT NULL DEFAULT '0',
  `last_bothered` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `bothered_times` int(11) NOT NULL DEFAULT '0',
  `edited_profile` tinyint(4) NOT NULL DEFAULT '0',
  mailPreferenceOption int not null default 0,
  PRIMARY KEY (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__project_activity` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `projectid` int(11) NOT NULL DEFAULT '0',
  `userid` int(11) NOT NULL DEFAULT '0',
  `referenceid` varchar(255) NOT NULL DEFAULT '0',
  `managers_only` tinyint(2) DEFAULT '0',
  `admin` tinyint(2) DEFAULT '0',
  `commentable` tinyint(2) NOT NULL DEFAULT '0',
  `state` tinyint(2) NOT NULL DEFAULT '0',
  `recorded` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `activity` varchar(255) NOT NULL DEFAULT '',
  `highlighted` varchar(100) NOT NULL DEFAULT '',
  `url` varchar(255) DEFAULT NULL,
  `class` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__project_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `itemid` int(11) NOT NULL DEFAULT '0',
  `comment` text NOT NULL,
  `created` datetime DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) NOT NULL DEFAULT '0',
  `activityid` int(11) NOT NULL DEFAULT '0',
  `state` tinyint(2) NOT NULL DEFAULT '0',
  `parent_activity` int(11) DEFAULT '0',
  `anonymous` tinyint(2) DEFAULT '0',
  `admin` tinyint(2) DEFAULT '0',
  `tbl` varchar(50) NOT NULL DEFAULT 'blog',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__project_databases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `project` int(11) NOT NULL,
  `database_name` varchar(64) NOT NULL,
  `title` varchar(127) NOT NULL DEFAULT '',
  `source_file` varchar(127) NOT NULL,
  `source_dir` varchar(127) NOT NULL,
  `source_revision` varchar(56) NOT NULL,
  `description` text,
  `data_definition` text,
  `revision` int(11) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__project_database_versions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `database_name` varchar(64) NOT NULL,
  `version` int(11) NOT NULL DEFAULT '1',
  `data_definition` text,
  PRIMARY KEY (`id`,`database_name`,`version`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__project_microblog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `blogentry` varchar(255) DEFAULT NULL,
  `posted` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `posted_by` int(11) NOT NULL DEFAULT '0',
  `state` tinyint(2) DEFAULT '0',
  `params` tinytext,
  `projectid` int(11) NOT NULL DEFAULT '0',
  `activityid` int(11) NOT NULL DEFAULT '0',
  `managers_only` tinyint(2) DEFAULT '0',
  PRIMARY KEY (`id`),
  FULLTEXT KEY `ftidx_blogentry` (`blogentry`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__project_owners` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `projectid` int(11) NOT NULL DEFAULT '0',
  `userid` int(11) NOT NULL DEFAULT '0',
  `groupid` int(11) DEFAULT '0',
  `invited_name` varchar(100)  DEFAULT NULL,
  `invited_email` varchar(100) DEFAULT NULL,
  `invited_code` varchar(10) DEFAULT NULL,
  `added` datetime NOT NULL,
  `lastvisit` datetime DEFAULT NULL,
  `prev_visit` datetime DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT '0',
  `num_visits` int(11) NOT NULL DEFAULT '0',
  `role` int(11) NOT NULL DEFAULT '0',
  `native` int(11) NOT NULL DEFAULT '0',
  `params` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__project_todo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `projectid` int(11) NOT NULL DEFAULT '0',
  `todolist` varchar(255) DEFAULT NULL,
  `created` datetime NOT NULL,
  `duedate` datetime DEFAULT NULL,
  `closed` datetime DEFAULT NULL,
  `created_by` int(11) NOT NULL DEFAULT '0',
  `assigned_to` int(11) DEFAULT '0',
  `closed_by` int(11) DEFAULT '0',
  `priority` int(11) DEFAULT '0',
  `activityid` int(11) NOT NULL DEFAULT '0',
  `state` tinyint(1) NOT NULL DEFAULT '0',
  `milestone` tinyint(1) NOT NULL DEFAULT '0',
  `private` tinyint(1) NOT NULL DEFAULT '0',
  `details` text,
  `content` varchar(255) NOT NULL,
  `color` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__project_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(150) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `params` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__projects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `alias` varchar(30) NOT NULL DEFAULT '',
  `title` varchar(255) NOT NULL DEFAULT '',
  `picture` varchar(255) DEFAULT '',
  `about` text,
  `state` int(11) NOT NULL DEFAULT '0',
  `type` int(11) NOT NULL DEFAULT '1',
  `provisioned` int(11) NOT NULL DEFAULT '0',
  `private` int(11) NOT NULL DEFAULT '1',
  `created` datetime NOT NULL,
  `modified` datetime DEFAULT NULL,
  `owned_by_user` int(11) NOT NULL DEFAULT '0',
  `created_by_user` int(11) NOT NULL,
  `owned_by_group` int(11) DEFAULT '0',
  `modified_by` int(11) DEFAULT '0',
  `setup_stage` int(11) NOT NULL DEFAULT '0',
  `params` text,
  `admin_notes` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uidx_alias` (`alias`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__recent_tools` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL DEFAULT '0',
  `tool` varchar(200) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__recommendation` (
  `fromID` int(11) NOT NULL,
  `toID` int(11) NOT NULL,
  `contentScore` float unsigned zerofill DEFAULT NULL,
  `tagScore` float unsigned zerofill DEFAULT NULL,
  `titleScore` float unsigned zerofill DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`fromID`,`toID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__redirection` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cpt` int(11) NOT NULL DEFAULT '0',
  `oldurl` varchar(100) NOT NULL DEFAULT '',
  `newurl` varchar(150) NOT NULL DEFAULT '',
  `dateadd` date NOT NULL DEFAULT '0000-00-00',
  PRIMARY KEY (`id`),
  KEY `idx_newurl` (`newurl`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__resource_assoc` (
  `parent_id` int(11) NOT NULL DEFAULT '0',
  `child_id` int(11) NOT NULL DEFAULT '0',
  `ordering` int(11) NOT NULL DEFAULT '0',
  `grouping` int(11) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__resource_licenses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `text` text,
  `title` varchar(100) DEFAULT NULL,
  `ordering` int(11) NOT NULL DEFAULT '0',
  `apps_only` tinyint(3) NOT NULL DEFAULT '0',
  `main` varchar(255) DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `agreement` tinyint(2) NOT NULL DEFAULT '0',
  `info` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__resource_ratings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_id` int(11) NOT NULL DEFAULT '0',
  `user_id` int(11) NOT NULL DEFAULT '0',
  `rating` decimal(2,1) NOT NULL DEFAULT '0.0',
  `comment` text NOT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `anonymous` tinyint(3) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__resource_sponsors` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `alias` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `state` tinyint(3) NOT NULL DEFAULT '1',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) NOT NULL DEFAULT '0',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(11) NOT NULL DEFAULT '0',
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__resource_stats` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `resid` bigint(20) NOT NULL,
  `restype` int(11) DEFAULT NULL,
  `users` bigint(20) DEFAULT NULL,
  `jobs` bigint(20) DEFAULT NULL,
  `avg_wall` int(20) DEFAULT NULL,
  `tot_wall` int(20) DEFAULT NULL,
  `avg_cpu` int(20) DEFAULT NULL,
  `tot_cpu` int(20) DEFAULT NULL,
  `datetime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `period` tinyint(4) NOT NULL DEFAULT '-1',
  `processed_on` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uidx_resid_restype_datetime_period` (`resid`,`restype`,`datetime`,`period`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__resource_stats_clusters` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `cluster` varchar(255) NOT NULL DEFAULT '',
  `username` varchar(32) NOT NULL DEFAULT '',
  `uidNumber` int(11) NOT NULL DEFAULT '0',
  `toolname` varchar(80) NOT NULL DEFAULT '',
  `resid` int(11) NOT NULL DEFAULT '0',
  `clustersize` varchar(255) NOT NULL DEFAULT '',
  `cluster_start` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `cluster_end` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `institution` varchar(255) NOT NULL DEFAULT '',
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_cluster` (`cluster`),
  KEY `idx_username` (`username`),
  KEY `idx_uidNumber` (`uidNumber`),
  KEY `idx_toolname` (`toolname`),
  KEY `idx_resid` (`resid`),
  KEY `idx_clustersize` (`clustersize`),
  KEY `idx_cluster_start` (`cluster_start`),
  KEY `idx_cluster_end` (`cluster_end`),
  KEY `idx_institution` (`institution`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__resource_stats_tools` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `resid` bigint(20) NOT NULL,
  `restype` int(11) NOT NULL,
  `users` bigint(20) DEFAULT NULL,
  `sessions` bigint(20) DEFAULT NULL,
  `simulations` bigint(20) DEFAULT NULL,
  `jobs` bigint(20) DEFAULT NULL,
  `avg_wall` double unsigned DEFAULT '0',
  `tot_wall` double unsigned DEFAULT '0',
  `avg_cpu` double unsigned DEFAULT '0',
  `tot_cpu` double unsigned DEFAULT '0',
  `avg_view` double unsigned DEFAULT '0',
  `tot_view` double unsigned DEFAULT '0',
  `avg_wait` double unsigned DEFAULT '0',
  `tot_wait` double unsigned DEFAULT '0',
  `avg_cpus` int(20) DEFAULT NULL,
  `tot_cpus` int(20) DEFAULT NULL,
  `datetime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `period` tinyint(4) NOT NULL DEFAULT '-1',
  `processed_on` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__resource_stats_tools_tops` (
  `top` tinyint(4) NOT NULL DEFAULT '0',
  `name` varchar(128) NOT NULL DEFAULT '',
  `valfmt` tinyint(4) NOT NULL DEFAULT '0',
  `size` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`top`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__resource_stats_tools_topvals` (
  `id` bigint(20) NOT NULL,
  `top` tinyint(4) NOT NULL DEFAULT '0',
  `rank` tinyint(4) NOT NULL DEFAULT '0',
  `name` varchar(255) DEFAULT NULL,
  `value` bigint(20) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__resource_stats_tools_users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `resid` bigint(20) NOT NULL,
  `restype` int(11) NOT NULL,
  `user` varchar(32) NOT NULL DEFAULT '',
  `sessions` bigint(20) DEFAULT NULL,
  `simulations` bigint(20) DEFAULT NULL,
  `jobs` bigint(20) DEFAULT NULL,
  `tot_wall` double unsigned DEFAULT '0',
  `tot_cpu` double unsigned DEFAULT '0',
  `tot_view` double unsigned DEFAULT '0',
  `datetime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `period` tinyint(4) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__resource_taxonomy_audience` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rid` int(11) NOT NULL DEFAULT '0',
  `versionid` int(11) DEFAULT '0',
  `level0` tinyint(2) NOT NULL DEFAULT '0',
  `level1` tinyint(2) NOT NULL DEFAULT '0',
  `level2` tinyint(2) NOT NULL DEFAULT '0',
  `level3` tinyint(2) NOT NULL DEFAULT '0',
  `level4` tinyint(2) NOT NULL DEFAULT '0',
  `level5` tinyint(2) NOT NULL DEFAULT '0',
  `comments` varchar(255) DEFAULT '',
  `added` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `addedBy` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__resource_taxonomy_audience_levels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(11) NOT NULL DEFAULT '0',
  `title` varchar(100) DEFAULT '',
  `description` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__resource_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `alias` varchar(100) DEFAULT NULL,
  `type` varchar(200) NOT NULL DEFAULT '',
  `category` int(11) NOT NULL DEFAULT '0',
  `description` tinytext,
  `contributable` int(2) DEFAULT '1',
  `customFields` text,
  `params` text,
  PRIMARY KEY (`id`),
  KEY `idx_category` (`category`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__resources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(250) NOT NULL DEFAULT '',
  `type` int(11) NOT NULL DEFAULT '0',
  `logical_type` int(11) NOT NULL DEFAULT '0',
  `introtext` text NOT NULL,
  `fulltxt` text NOT NULL,
  `footertext` text NOT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) NOT NULL DEFAULT '0',
  `modified` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modified_by` int(11) NOT NULL DEFAULT '0',
  `published` int(1) NOT NULL DEFAULT '0',
  `publish_up` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `publish_down` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `access` int(11) NOT NULL DEFAULT '0',
  `hits` int(11) NOT NULL DEFAULT '0',
  `path` varchar(200) NOT NULL DEFAULT '',
  `checked_out` int(11) NOT NULL DEFAULT '0',
  `checked_out_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `standalone` tinyint(1) NOT NULL DEFAULT '0',
  `group_owner` varchar(250) NOT NULL DEFAULT '',
  `group_access` text,
  `rating` decimal(2,1) NOT NULL DEFAULT '0.0',
  `times_rated` int(11) NOT NULL DEFAULT '0',
  `params` text,
  `attribs` text,
  `alias` varchar(100) NOT NULL DEFAULT '',
  `ranking` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  FULLTEXT KEY `ftidx_title` (`title`),
  FULLTEXT KEY `ftidx_introtext_fulltxt` (`introtext`,`fulltxt`),
  FULLTEXT KEY `ftidx_title_introtext_fulltxt` (`title`,`introtext`,`fulltxt`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__screenshots` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `versionid` int(11) DEFAULT '0',
  `title` varchar(127) DEFAULT '',
  `ordering` int(11) DEFAULT '0',
  `filename` varchar(100) NOT NULL,
  `resourceid` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__selected_quotes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) DEFAULT '0',
  `fullname` varchar(100) DEFAULT '',
  `org` varchar(200) DEFAULT '',
  `miniquote` varchar(200) DEFAULT '',
  `short_quote` text,
  `quote` text,
  `picture` varchar(250) DEFAULT '',
  `date` datetime DEFAULT '0000-00-00 00:00:00',
  `flash_rotation` tinyint(1) DEFAULT '0',
  `notable_quotes` tinyint(1) DEFAULT '1',
  `notes` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__session_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `clientid` tinyint(4) DEFAULT NULL,
  `session_id` char(64) DEFAULT NULL,
  `psid` char(64) DEFAULT NULL,
  `rsid` char(64) DEFAULT NULL,
  `ssid` char(64) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `authenticator` char(64) DEFAULT NULL,
  `source` char(64) DEFAULT NULL,
  `ip` char(64) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__session_geo` (
  `session_id` varchar(200) NOT NULL default '0',
  `username` varchar(150) default '',
  `time` varchar(14) default '',
  `guest` tinyint(4) default '1',
  `userid` int(11) default '0',
  `ip` varchar(15) default NULL,
  `host` varchar(128) default NULL,
  `domain` varchar(128) default NULL,
  `signed` tinyint(3) default '0',
  `countrySHORT` char(2) default NULL,
  `countryLONG` varchar(64) default NULL,
  `ipREGION` varchar(128) default NULL,
  `ipCITY` varchar(128) default NULL,
  `ipLATITUDE` double default NULL,
  `ipLONGITUDE` double default NULL,
  `bot` tinyint(4) default '0',
  PRIMARY KEY  (`session_id`),
  KEY `idx_userid` (`userid`),
  KEY `idx_time` (`time`),
  KEY `idx_ip` (`ip`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `teaser` varchar(255) DEFAULT NULL,
  `description` text,
  `notes` text,
  `checked_out` int(11) NOT NULL DEFAULT '0',
  `checked_out_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `published` tinyint(1) NOT NULL DEFAULT '0',
  `published_date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `state` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__stats_tops` (
  `id` tinyint(4) NOT NULL DEFAULT '0',
  `name` varchar(128) NOT NULL DEFAULT '',
  `valfmt` tinyint(4) NOT NULL DEFAULT '0',
  `size` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__stats_topvals` (
  `top` tinyint(4) NOT NULL DEFAULT '0',
  `datetime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `period` tinyint(4) NOT NULL DEFAULT '1',
  `rank` smallint(6) NOT NULL DEFAULT '0',
  `name` varchar(255) DEFAULT NULL,
  `value` bigint(20) NOT NULL DEFAULT '0',
  KEY `idx_top` (`top`),
  KEY `idx_top_rank` (`top`,`rank`),
  KEY `idx_top_datetime` (`top`,`datetime`),
  KEY `idx_top_datetime_rank` (`top`,`datetime`,`rank`),
  KEY `idx_top_datetime_period` (`top`,`datetime`,`period`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__store` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `title` varchar(127) NOT NULL DEFAULT '',
  `price` int(11) NOT NULL DEFAULT '0',
  `description` text,
  `published` tinyint(1) NOT NULL DEFAULT '0',
  `featured` tinyint(1) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `available` int(1) NOT NULL DEFAULT '0',
  `params` text,
  `special` int(11) DEFAULT '0',
  `type` int(11) DEFAULT '1',
  `category` varchar(127) DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__storefront_collections` (
  `cId` char(50) NOT NULL,
  `cName` varchar(64) DEFAULT NULL,
  `cParent` int(16) DEFAULT NULL,
  `cActive` tinyint(1) DEFAULT NULL,
  `cType` char(10) DEFAULT NULL,
  PRIMARY KEY (`cId`),
  KEY `idx_cActive` (`cActive`),
  KEY `idx_cParent` (`cParent`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__storefront_coupon_actions` (
  `cnId` int(16) NOT NULL,
  `cnaAction` char(25) DEFAULT NULL,
  `cnaVal` char(255) DEFAULT NULL,
  UNIQUE KEY `uidx_cnId_cnaAction` (`cnId`,`cnaAction`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
		
CREATE TABLE `#__storefront_coupon_conditions` (
  `cnId` int(16) NOT NULL,
  `cncRule` char(100) DEFAULT NULL,
  `cncVal` char(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__storefront_coupon_objects` (
  `cnId` int(16) NOT NULL,
  `cnoObjectId` int(16) DEFAULT NULL,
  `cnoObjectsLimit` int(5) DEFAULT '0' COMMENT 'How many objects can be applied to. 0 - unlimited',
  UNIQUE KEY `uidx_cnId_cnoObjectId` (`cnId`,`cnoObjectId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__storefront_coupons` (
  `cnId` int(16) NOT NULL AUTO_INCREMENT,
  `cnCode` char(25) DEFAULT NULL,
  `cnDescription` char(255) DEFAULT NULL,
  `cnExpires` date DEFAULT NULL,
  `cnUseLimit` int(5) unsigned DEFAULT NULL,
  `cnObject` char(15) NOT NULL,
  `cnActive` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`cnId`),
  UNIQUE KEY `uidx_cnCode` (`cnCode`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__storefront_option_groups` (
  `ogId` int(16) NOT NULL AUTO_INCREMENT,
  `ogName` char(16) DEFAULT NULL,
  PRIMARY KEY (`ogId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
		
CREATE TABLE `#__storefront_options` (
  `oId` int(16) NOT NULL AUTO_INCREMENT,
  `ogId` int(16) DEFAULT NULL COMMENT 'Foreign key to option-groups',
  `oName` char(255) DEFAULT NULL,
  PRIMARY KEY (`oId`),
  UNIQUE KEY `uidx_ogId_oName` (`ogId`,`oName`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__storefront_product_collections` (
  `cllId` int(16) NOT NULL AUTO_INCREMENT,
  `pId` int(16) NOT NULL,
  `cId` char(50) NOT NULL,
  PRIMARY KEY (`cllId`,`pId`,`cId`),
  UNIQUE KEY `uidx_pId_cId` (`pId`,`cId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
		
CREATE TABLE `#__storefront_product_option_groups` (
  `pId` int(16) NOT NULL,
  `ogId` int(16) NOT NULL,
  PRIMARY KEY (`pId`,`ogId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
	
CREATE TABLE `#__storefront_product_types` (
  `ptId` int(16) NOT NULL AUTO_INCREMENT,
  `ptName` char(128) DEFAULT NULL,
  `ptModel` char(25) DEFAULT 'normal',
  PRIMARY KEY (`ptId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__storefront_products` (
  `pId` int(16) NOT NULL AUTO_INCREMENT,
  `ptId` int(16) NOT NULL COMMENT 'Product type ID. Foreign key to product_types table',
  `pName` char(128) DEFAULT NULL,
  `pTagline` tinytext,
  `pDescription` text,
  `pFeatures` text,
  `pActive` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`pId`),
  KEY `idx_pActive` (`pActive`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__storefront_sku_meta` (
  `smId` int(16) NOT NULL AUTO_INCREMENT,
  `sId` int(16) NOT NULL,
  `smKey` varchar(100) DEFAULT NULL,
  `smValue` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`smId`),
  UNIQUE KEY `uidx_sId_smKey` (`sId`,`smKey`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__storefront_sku_options` (
  `sId` int(16) NOT NULL,
  `oId` int(16) NOT NULL,
  PRIMARY KEY (`sId`,`oId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__storefront_skus` (
  `sId` int(16) NOT NULL AUTO_INCREMENT,
  `pId` int(16) DEFAULT NULL COMMENT 'Foreign key to products',
  `sSku` char(16) DEFAULT NULL,
  `sWeight` decimal(10,2) DEFAULT NULL,
  `sPrice` decimal(10,2) DEFAULT NULL,
  `sDescriprtion` text,
  `sFeatures` text,
  `sTrackInventory` tinyint(1) DEFAULT '0',
  `sInventory` int(11) DEFAULT '0',
  `sEnumerable` tinyint(1) DEFAULT '1',
  `sAllowMultiple` tinyint(1) DEFAULT '1',
  `sActive` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`sId`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__support_acl_acos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(100) DEFAULT NULL,
  `foreign_key` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__support_acl_aros` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `model` varchar(100) DEFAULT NULL,
  `foreign_key` int(11) DEFAULT '0',
  `alias` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__support_acl_aros_acos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `aro_id` int(11) DEFAULT '0',
  `aco_id` int(11) DEFAULT '0',
  `action_create` int(3) DEFAULT '0',
  `action_read` int(3) DEFAULT '0',
  `action_update` int(3) DEFAULT '0',
  `action_delete` int(3) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__support_attachments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ticket` int(11) NOT NULL DEFAULT '0',
  `filename` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__support_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `section` int(11) DEFAULT '0',
  `category` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__support_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ticket` int(11) NOT NULL DEFAULT '0',
  `comment` text,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` varchar(50) DEFAULT NULL,
  `changelog` text,
  `access` tinyint(3) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__support_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(250) DEFAULT NULL,
  `message` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__support_queries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(250) DEFAULT NULL,
  `conditions` text,
  `query` text,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `sort` varchar(100) DEFAULT NULL,
  `sort_dir` varchar(100) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `iscore` int(3) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__support_resolutions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) DEFAULT NULL,
  `alias` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__support_sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `section` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__support_tickets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` tinyint(3) DEFAULT '0',
  `created` datetime DEFAULT '0000-00-00 00:00:00',
  `closed` DATETIME  NOT NULL  DEFAULT '0000-00-00 00:00:00',
  `login` varchar(200) DEFAULT NULL,
  `severity` varchar(30) DEFAULT NULL,
  `owner` varchar(50) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `summary` varchar(250) DEFAULT NULL,
  `report` text,
  `resolved` varchar(50) DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `os` varchar(50) DEFAULT NULL,
  `browser` varchar(50) DEFAULT NULL,
  `ip` varchar(200) DEFAULT NULL,
  `hostname` varchar(200) DEFAULT NULL,
  `uas` varchar(250) DEFAULT NULL,
  `referrer` varchar(250) DEFAULT NULL,
  `cookies` tinyint(3) NOT NULL DEFAULT '0',
  `instances` int(11) NOT NULL DEFAULT '1',
  `section` int(11) NOT NULL DEFAULT '1',
  `type` tinyint(3) NOT NULL DEFAULT '0',
  `group` varchar(250) DEFAULT NULL,
  `open` tinyint(3) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__support_watching` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ticket_id` int(11) NOT NULL DEFAULT '0',
  `user_id` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_ticket_id` (`ticket_id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag` varchar(100) DEFAULT NULL,
  `raw_tag` varchar(100) DEFAULT NULL,
  `description` text,
  `admin` tinyint(3) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  FULLTEXT KEY `ftidx_description` (`description`),
  FULLTEXT KEY `ftidx_raw_tag_description` (`raw_tag`,`description`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__tags_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupid` int(11) DEFAULT '0',
  `tagid` int(11) DEFAULT '0',
  `priority` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__tags_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_id` int(11) NOT NULL DEFAULT '0',
  `timestamp` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `user_id` int(11) DEFAULT '0',
  `action` varchar(50) DEFAULT NULL,
  `comments` text,
  `actorid` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__tags_object` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `objectid` int(11) DEFAULT NULL,
  `tagid` int(11) DEFAULT NULL,
  `strength` tinyint(3) DEFAULT '0',
  `taggerid` int(11) DEFAULT '0',
  `taggedon` datetime DEFAULT '0000-00-00 00:00:00',
  `tbl` varchar(255) DEFAULT NULL,
  `label` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_objectid_tbl` (`objectid`,`tbl`),
  KEY `idx_label_tagid` (`label`,`tagid`),
  KEY `idx_tbl_objectid_label_tagid` (`tbl`,`objectid`,`label`,`tagid`),
  KEY `idx_tagid` (`tagid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__tags_substitute` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `tag_id` int(11) NOT NULL DEFAULT '0',
  `tag` varchar(100) DEFAULT NULL,
  `raw_tag` varchar(100) DEFAULT NULL,
  `created_by` int(11) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `idx_tag_id` (`tag_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__tool` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `toolname` varchar(64) NOT NULL DEFAULT '',
  `title` varchar(127) NOT NULL DEFAULT '',
  `version` varchar(15) DEFAULT NULL,
  `description` text,
  `fulltxt` text,
  `license` text,
  `toolaccess` varchar(15) DEFAULT NULL,
  `codeaccess` varchar(15) DEFAULT NULL,
  `wikiaccess` varchar(15) DEFAULT NULL,
  `published` tinyint(1) DEFAULT '0',
  `state` int(15) DEFAULT NULL,
  `priority` int(15) DEFAULT '3',
  `team` text,
  `registered` datetime DEFAULT NULL,
  `registered_by` varchar(31) DEFAULT NULL,
  `mw` varchar(31) DEFAULT NULL,
  `vnc_geometry` varchar(31) DEFAULT NULL,
  `ticketid` int(15) DEFAULT NULL,
  `state_changed` datetime DEFAULT '0000-00-00 00:00:00',
  `revision` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uidx_toolname` (`toolname`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__tool_authors` (
  `toolname` varchar(50) NOT NULL DEFAULT '',
  `revision` int(15) NOT NULL DEFAULT '0',
  `uid` int(11) NOT NULL DEFAULT '0',
  `ordering` int(11) DEFAULT '0',
  `version_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(255) DEFAULT NULL,
  `organization` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`toolname`,`revision`,`uid`,`version_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__tool_groups` (
  `cn` varchar(255) NOT NULL DEFAULT '',
  `toolid` int(11) NOT NULL DEFAULT '0',
  `role` tinyint(2) NOT NULL DEFAULT '0',
  PRIMARY KEY (`cn`,`toolid`,`role`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__tool_licenses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `text` text,
  `title` varchar(100) DEFAULT NULL,
  `ordering` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__tool_statusviews` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `ticketid` varchar(15) NOT NULL DEFAULT '',
  `uid` varchar(31) NOT NULL DEFAULT '',
  `viewed` datetime DEFAULT '0000-00-00 00:00:00',
  `elapsed` int(11) DEFAULT '500000',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__tool_version` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `toolname` varchar(64) NOT NULL DEFAULT '',
  `instance` varchar(31) NOT NULL DEFAULT '',
  `title` varchar(127) NOT NULL DEFAULT '',
  `description` text,
  `fulltxt` text,
  `version` varchar(15) DEFAULT NULL,
  `revision` int(11) DEFAULT NULL,
  `toolaccess` varchar(15) DEFAULT NULL,
  `codeaccess` varchar(15) DEFAULT NULL,
  `wikiaccess` varchar(15) DEFAULT NULL,
  `state` int(15) DEFAULT NULL,
  `released_by` varchar(31) DEFAULT NULL,
  `released` datetime DEFAULT NULL,
  `unpublished` datetime DEFAULT NULL,
  `exportControl` varchar(16) DEFAULT NULL,
  `license` text,
  `vnc_geometry` varchar(31) DEFAULT NULL,
  `vnc_depth` int(11) DEFAULT NULL,
  `vnc_timeout` int(11) DEFAULT NULL,
  `vnc_command` varchar(100) DEFAULT NULL,
  `mw` varchar(31) DEFAULT NULL,
  `toolid` int(11) DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `params` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uidx_toolname_instance` (`toolname`,`instance`),
  KEY `idx_instance` (`instance`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__tool_version_alias` (
  `tool_version_id` int(11) NOT NULL,
  `alias` varchar(255) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__tool_version_hostreq` (
  `tool_version_id` int(11) NOT NULL,
  `hostreq` varchar(255) NOT NULL,
  UNIQUE KEY `idx_tool_version_id_hostreq` (`tool_version_id`,`hostreq`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__tool_version_middleware` (
  `tool_version_id` int(11) NOT NULL,
  `middleware` varchar(255) NOT NULL,
  UNIQUE KEY `uidx_tool_version_id_middleware` (`tool_version_id`,`middleware`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__tool_version_tracperm` (
  `tool_version_id` int(11) NOT NULL,
  `tracperm` varchar(64) NOT NULL,
  UNIQUE KEY `uidx_tool_version_id_tracperm` (`tool_version_id`,`tracperm`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__trac_group_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `action` varchar(255) NOT NULL,
  `trac_project_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uidx_group_id_action_trac_project_id` (`group_id`,`action`,`trac_project_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__trac_project` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__trac_projects` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `type` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__trac_user_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `trac_project_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uidx_user_id_action_trac_project_id` (`user_id`,`action`,`trac_project_id`) USING BTREE
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__user_roles` (
  `user_id` int(11) NOT NULL,
  `role` varchar(20) NOT NULL,
  `group_id` int(11) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uidx_role_user_id_group_id` (`role`,`user_id`,`group_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__users_password` (
  `user_id` int(11) NOT NULL,
  `passhash` char(127) NOT NULL,
  `shadowExpire` int(11) DEFAULT NULL,
  `shadowFlag` int(11) DEFAULT NULL,
  `shadowInactive` int(11) DEFAULT NULL,
  `shadowLastChange` int(11) DEFAULT NULL,
  `shadowMax` int(11) DEFAULT NULL,
  `shadowMin` int(11) DEFAULT NULL,
  `shadowWarning` int(11) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__users_password_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `passhash` char(32) NOT NULL,
  `action` int(11) DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `invalidated` datetime DEFAULT NULL,
  `invalidated_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__users_points` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL DEFAULT '0',
  `balance` int(11) NOT NULL DEFAULT '0',
  `earnings` int(11) NOT NULL DEFAULT '0',
  `credit` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__users_points_config` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `points` int(11) DEFAULT '0',
  `description` varchar(255) DEFAULT NULL,
  `alias` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__users_points_services` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(250) NOT NULL DEFAULT '',
  `category` varchar(50) NOT NULL DEFAULT '',
  `alias` varchar(50) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `unitprice` float(6,2) DEFAULT '0.00',
  `pointsprice` int(11) DEFAULT '0',
  `currency` varchar(50) DEFAULT 'points',
  `maxunits` int(11) DEFAULT '0',
  `minunits` int(11) DEFAULT '0',
  `unitsize` int(11) DEFAULT '0',
  `status` int(11) DEFAULT '0',
  `restricted` int(11) DEFAULT '0',
  `ordering` int(11) DEFAULT '0',
  `params` text,
  `unitmeasure` varchar(200) NOT NULL DEFAULT '',
  `changed` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uidx_alias` (`alias`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__users_points_subscriptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL DEFAULT '0',
  `serviceid` int(11) NOT NULL DEFAULT '0',
  `units` int(11) NOT NULL DEFAULT '1',
  `status` int(11) NOT NULL DEFAULT '0',
  `pendingunits` int(11) DEFAULT '0',
  `pendingpayment` float(6,2) DEFAULT '0.00',
  `totalpaid` float(6,2) DEFAULT '0.00',
  `installment` int(11) DEFAULT '0',
  `contact` varchar(20) DEFAULT '',
  `code` varchar(10) DEFAULT '',
  `usepoints` tinyint(2) DEFAULT '0',
  `notes` text,
  `added` datetime NOT NULL,
  `updated` datetime DEFAULT NULL,
  `expires` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__users_tracperms` (
  `user_id` int(11) NOT NULL,
  `action` varchar(255) NOT NULL,
  `project_id` int(11) NOT NULL,
  PRIMARY KEY (`user_id`,`action`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__users_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL DEFAULT '0',
  `type` varchar(20) DEFAULT NULL,
  `description` varchar(250) DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `category` varchar(50) DEFAULT NULL,
  `referenceid` int(11) DEFAULT '0',
  `amount` int(11) DEFAULT '0',
  `balance` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_referenceid_categroy_type` (`referenceid`,`category`,`type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `venue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `venue` varchar(40) DEFAULT NULL,
  `state` varchar(15) DEFAULT NULL,
  `type` varchar(10) DEFAULT NULL,
  `mw_version` varchar(3) DEFAULT NULL,
  `ssh_key_path` varchar(200) DEFAULT NULL,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `master` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `venue_countries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `venue_id` int(11) NOT NULL,
  `countrySHORT` char(2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__vote_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `referenceid` int(11) NOT NULL DEFAULT '0',
  `voted` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `voter` int(11) DEFAULT NULL,
  `helpful` varchar(11) DEFAULT NULL,
  `ip` varchar(15) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_referenceid` (`referenceid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__wiki_attachments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pageid` int(11) DEFAULT '0',
  `filename` varchar(255) DEFAULT NULL,
  `description` tinytext,
  `created` datetime DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__wiki_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pageid` int(11) NOT NULL DEFAULT '0',
  `version` int(11) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) NOT NULL DEFAULT '0',
  `ctext` text,
  `chtml` text,
  `rating` tinyint(1) NOT NULL DEFAULT '0',
  `anonymous` tinyint(1) NOT NULL DEFAULT '0',
  `parent` int(11) NOT NULL DEFAULT '0',
  `status` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__wiki_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pid` int(11) NOT NULL DEFAULT '0',
  `timestamp` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `uid` int(11) DEFAULT '0',
  `action` varchar(50) DEFAULT NULL,
  `comments` text,
  `actorid` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__wiki_math` (
  `inputhash` varchar(32) NOT NULL DEFAULT '',
  `outputhash` varchar(32) NOT NULL DEFAULT '',
  `conservativeness` tinyint(4) NOT NULL,
  `html` text,
  `mathml` text,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uidx_inputhash` (`inputhash`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__wiki_page` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pagename` varchar(100) DEFAULT NULL,
  `hits` int(11) NOT NULL DEFAULT '0',
  `created_by` int(11) NOT NULL DEFAULT '0',
  `rating` decimal(2,1) NOT NULL DEFAULT '0.0',
  `times_rated` int(11) NOT NULL DEFAULT '0',
  `title` varchar(255) DEFAULT NULL,
  `scope` varchar(255) NOT NULL,
  `params` tinytext,
  `ranking` float DEFAULT '0',
  `authors` varchar(255) DEFAULT NULL,
  `access` tinyint(2) DEFAULT '0',
  `group_cn` varchar(255) DEFAULT NULL,
  `state` tinyint(2) DEFAULT '0',
  `modified` DATETIME  NOT NULL  DEFAULT '0000-00-00 00:00:00',
  `version_id` INT(11)  NOT NULL  DEFAULT '0',
  PRIMARY KEY (`id`),
  FULLTEXT KEY `ftidx_title` (`title`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__wiki_page_author` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT '0',
  `page_id` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__wiki_page_links` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `page_id` int(11) NOT NULL DEFAULT '0',
  `timestamp` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `scope` varchar(50) NOT NULL DEFAULT '',
  `scope_id` int(11) NOT NULL DEFAULT '0',
  `link` varchar(255) NOT NULL DEFAULT '',
  `url` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `idx_page_id` (`page_id`),
  KEY `idx_scope_scope_id` (`scope`,`scope_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__wiki_page_metrics` (
  `pageid` int(11) NOT NULL DEFAULT '0',
  `pagename` varchar(100) DEFAULT NULL,
  `hits` int(11) NOT NULL DEFAULT '0',
  `visitors` int(11) NOT NULL DEFAULT '0',
  `visits` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pageid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__wiki_version` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pageid` int(11) NOT NULL DEFAULT '0',
  `version` int(11) NOT NULL DEFAULT '0',
  `created` datetime DEFAULT NULL,
  `created_by` int(11) NOT NULL DEFAULT '0',
  `minor_edit` int(1) NOT NULL DEFAULT '0',
  `pagetext` text,
  `pagehtml` text,
  `approved` int(1) NOT NULL DEFAULT '0',
  `summary` varchar(255) DEFAULT NULL,
  `length` INT(11)  NOT NULL  DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_pageid` (`pageid`),
  FULLTEXT KEY `ftidx_pagetext` (`pagetext`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__wish_attachments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `wish` int(11) NOT NULL DEFAULT '0',
  `filename` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__wishlist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(50) NOT NULL,
  `referenceid` int(11) NOT NULL DEFAULT '0',
  `title` varchar(150) NOT NULL,
  `created_by` int(11) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `state` int(3) NOT NULL DEFAULT '0',
  `public` int(3) NOT NULL DEFAULT '1',
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__wishlist_implementation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `wishid` int(11) NOT NULL DEFAULT '0',
  `version` int(11) NOT NULL DEFAULT '0',
  `created` datetime DEFAULT NULL,
  `created_by` int(11) NOT NULL DEFAULT '0',
  `minor_edit` int(1) NOT NULL DEFAULT '0',
  `pagetext` text,
  `pagehtml` text,
  `approved` int(1) NOT NULL DEFAULT '0',
  `summary` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  FULLTEXT KEY `ftidx_pagetext` (`pagetext`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__wishlist_item` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `wishlist` int(11) DEFAULT '0',
  `subject` varchar(200) NOT NULL,
  `about` text,
  `proposed_by` int(11) DEFAULT '0',
  `granted_by` int(11) DEFAULT '0',
  `assigned` int(11) DEFAULT '0',
  `granted_vid` int(11) DEFAULT '0',
  `proposed` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `granted` datetime DEFAULT '0000-00-00 00:00:00',
  `status` int(3) NOT NULL DEFAULT '0',
  `due` datetime DEFAULT '0000-00-00 00:00:00',
  `anonymous` int(3) DEFAULT '0',
  `ranking` int(11) DEFAULT '0',
  `points` int(11) DEFAULT '0',
  `private` int(3) DEFAULT '0',
  `accepted` int(3) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_wishlist` (`wishlist`),
  FULLTEXT KEY `ftidx_subject_about` (`subject`,`about`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__wishlist_ownergroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `wishlist` int(11) DEFAULT '0',
  `groupid` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__wishlist_owners` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `wishlist` int(11) DEFAULT '0',
  `userid` int(11) NOT NULL DEFAULT '0',
  `type` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__wishlist_vote` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `wishid` int(11) DEFAULT '0',
  `userid` int(11) NOT NULL DEFAULT '0',
  `voted` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `importance` int(3) DEFAULT '0',
  `effort` int(3) DEFAULT '0',
  `due` datetime DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY `idx_wishid` (`wishid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xdomain_users` (
  `domain_id` int(11) NOT NULL,
  `domain_username` varchar(150) NOT NULL DEFAULT '',
  `uidNumber` int(11) DEFAULT NULL,
  PRIMARY KEY (`domain_id`,`domain_username`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xdomains` (
  `domain_id` int(11) NOT NULL AUTO_INCREMENT,
  `domain` varchar(150) NOT NULL DEFAULT '',
  PRIMARY KEY (`domain_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xfavorites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) DEFAULT '0',
  `oid` int(11) DEFAULT '0',
  `tbl` varchar(250) DEFAULT NULL,
  `faved` datetime DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xgroups` (
  `gidNumber` int(11) NOT NULL AUTO_INCREMENT,
  `cn` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `published` tinyint(3) DEFAULT '0',
  `approved` tinyint(3) DEFAULT '1',
  `type` tinyint(3) DEFAULT '0',
  `public_desc` text,
  `private_desc` text,
  `restrict_msg` text,
  `join_policy` tinyint(3) DEFAULT '0',
  `discoverability` tinyint(3),
  `discussion_email_autosubscribe` tinyint(3) DEFAULT NULL,
  `logo` varchar(255) DEFAULT NULL,
  `overview_type` int(11) DEFAULT NULL,
  `overview_content` text,
  `plugins` text,
  `created` datetime DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `params` text,
  PRIMARY KEY (`gidNumber`),
  FULLTEXT KEY `ftidx_cn_description_public_desc` (`cn`,`description`,`public_desc`)
) ENGINE=MyISAM AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8;

CREATE TABLE `#__xgroups_applicants` (
  `gidNumber` int(11) NOT NULL,
  `uidNumber` int(11) NOT NULL,
  PRIMARY KEY (`gidNumber`,`uidNumber`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xgroups_inviteemails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(150) NOT NULL,
  `gidNumber` int(11) NOT NULL,
  `token` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xgroups_invitees` (
  `gidNumber` int(11) NOT NULL,
  `uidNumber` int(11) NOT NULL,
  PRIMARY KEY (`gidNumber`,`uidNumber`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xgroups_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gid` int(11) NOT NULL DEFAULT '0',
  `timestamp` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `uid` int(11) DEFAULT '0',
  `action` varchar(50) DEFAULT NULL,
  `comments` text,
  `actorid` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xgroups_managers` (
  `gidNumber` int(11) NOT NULL,
  `uidNumber` int(11) NOT NULL,
  PRIMARY KEY (`gidNumber`,`uidNumber`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xgroups_member_roles` (
  `role` int(11) DEFAULT NULL,
  `uidNumber` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xgroups_memberoption` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gidNumber` int(11) DEFAULT NULL,
  `userid` int(11) DEFAULT NULL,
  `optionname` varchar(100) DEFAULT NULL,
  `optionvalue` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xgroups_members` (
  `gidNumber` int(11) NOT NULL,
  `uidNumber` int(11) NOT NULL,
  PRIMARY KEY (`gidNumber`,`uidNumber`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xgroups_pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gid` varchar(100) DEFAULT NULL,
  `url` varchar(100) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `content` text,
  `porder` int(11) DEFAULT NULL,
  `active` int(11) DEFAULT NULL,
  `privacy` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xgroups_pages_hits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gid` int(11) DEFAULT NULL,
  `pid` int(11) DEFAULT NULL,
  `uid` int(11) DEFAULT NULL,
  `datetime` datetime DEFAULT NULL,
  `ip` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xgroups_reasons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uidNumber` int(11) NOT NULL,
  `gidNumber` int(11) NOT NULL,
  `reason` text,
  `date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xgroups_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gidNumber` int(11) DEFAULT NULL,
  `role` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xgroups_tracperm` (
  `group_id` int(11) NOT NULL,
  `action` varchar(255) NOT NULL,
  `project_id` int(11) NOT NULL,
  PRIMARY KEY (`group_id`,`action`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xmessage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created` datetime DEFAULT '0000-00-00 00:00:00',
  `created_by` int(11) DEFAULT '0',
  `message` mediumtext,
  `subject` varchar(250) DEFAULT NULL,
  `component` varchar(100) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `group_id` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xmessage_action` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `class` varchar(20) NOT NULL DEFAULT '',
  `element` int(11) unsigned NOT NULL DEFAULT '0',
  `description` mediumtext,
  PRIMARY KEY (`id`),
  KEY `idx_class` (`class`),
  KEY `idx_element` (`element`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xmessage_component` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `component` varchar(50) NOT NULL DEFAULT '',
  `action` varchar(100) NOT NULL DEFAULT '',
  `title` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xmessage_notify` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) DEFAULT '0',
  `method` varchar(250) DEFAULT NULL,
  `type` varchar(250) DEFAULT NULL,
  `priority` int(2) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xmessage_recipient` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mid` int(11) DEFAULT '0',
  `uid` int(11) DEFAULT '0',
  `created` datetime DEFAULT '0000-00-00 00:00:00',
  `expires` datetime DEFAULT '0000-00-00 00:00:00',
  `actionid` int(11) DEFAULT '0',
  `state` tinyint(2) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_mid` (`mid`),
  KEY `idx_uid` (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xmessage_seen` (
  `mid` int(11) unsigned NOT NULL DEFAULT '0',
  `uid` int(11) unsigned NOT NULL DEFAULT '0',
  `whenseen` datetime DEFAULT '0000-00-00 00:00:00',
  KEY `idx_mid` (`mid`),
  KEY `idx_uid` (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xorganization_types` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `type` varchar(150) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xorganizations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `organization` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xprofiles` (
  `uidNumber` int(11) NOT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `username` varchar(150) NOT NULL DEFAULT '',
  `email` varchar(100) NOT NULL DEFAULT '',
  `registerDate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `gidNumber` varchar(11) NOT NULL DEFAULT '',
  `homeDirectory` varchar(255) NOT NULL DEFAULT '',
  `loginShell` varchar(255) NOT NULL DEFAULT '',
  `ftpShell` varchar(255) NOT NULL DEFAULT '',
  `userPassword` varchar(255) NOT NULL DEFAULT '',
  `gid` varchar(255) NOT NULL DEFAULT '',
  `orgtype` varchar(255) NOT NULL DEFAULT '',
  `organization` varchar(255) NOT NULL DEFAULT '',
  `countryresident` char(2) NOT NULL DEFAULT '',
  `countryorigin` char(2) NOT NULL DEFAULT '',
  `gender` varchar(255) NOT NULL DEFAULT '',
  `url` varchar(255) NOT NULL DEFAULT '',
  `reason` text NOT NULL,
  `mailPreferenceOption` int(11) NOT NULL DEFAULT '-1',
  `usageAgreement` int(11) NOT NULL DEFAULT '0',
  `jobsAllowed` int(11) NOT NULL DEFAULT '0',
  `modifiedDate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `emailConfirmed` int(11) NOT NULL DEFAULT '0',
  `regIP` varchar(255) NOT NULL DEFAULT '',
  `regHost` varchar(255) NOT NULL DEFAULT '',
  `nativeTribe` varchar(255) NOT NULL DEFAULT '',
  `phone` varchar(255) NOT NULL DEFAULT '',
  `proxyPassword` varchar(255) NOT NULL DEFAULT '',
  `proxyUidNumber` varchar(255) NOT NULL DEFAULT '',
  `givenName` varchar(255) NOT NULL DEFAULT '',
  `middleName` varchar(255) NOT NULL DEFAULT '',
  `surname` varchar(255) NOT NULL DEFAULT '',
  `picture` varchar(255) NOT NULL DEFAULT '',
  `vip` int(11) NOT NULL DEFAULT '0',
  `public` tinyint(2) NOT NULL DEFAULT '0',
  `params` text NOT NULL,
  `note` text NOT NULL,
  `shadowExpire` int(11) DEFAULT NULL,
  `locked` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`uidNumber`),
  KEY `idx_username` (`username`),
  FULLTEXT KEY `ftidx_givenName_surname` (`givenName`,`surname`),
  FULLTEXT KEY `ftidx_name` (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xprofiles_address` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `uidNumber` int(11) DEFAULT NULL,
  `addressTo` varchar(200) DEFAULT NULL,
  `address1` varchar(255) DEFAULT NULL,
  `address2` varchar(255) DEFAULT NULL,
  `addressCity` varchar(200) DEFAULT NULL,
  `addressRegion` varchar(200) DEFAULT NULL,
  `addressPostal` varchar(200) DEFAULT NULL,
  `addressCountry` varchar(200) DEFAULT NULL,
  `addressLatitude` float DEFAULT NULL,
  `addressLongitude` float DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xprofiles_admin` (
  `uidNumber` int(11) NOT NULL,
  `admin` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`uidNumber`,`admin`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xprofiles_bio` (
  `uidNumber` int(11) NOT NULL,
  `bio` text,
  PRIMARY KEY (`uidNumber`),
  FULLTEXT KEY `ftidx_bio` (`bio`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xprofiles_disability` (
  `uidNumber` int(11) NOT NULL,
  `disability` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`uidNumber`,`disability`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xprofiles_edulevel` (
  `uidNumber` int(11) NOT NULL,
  `edulevel` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`uidNumber`,`edulevel`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xprofiles_hispanic` (
  `uidNumber` int(11) NOT NULL,
  `hispanic` varchar(255) NOT NULL,
  PRIMARY KEY (`uidNumber`,`hispanic`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xprofiles_host` (
  `uidNumber` int(11) NOT NULL,
  `host` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`uidNumber`,`host`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xprofiles_manager` (
  `uidNumber` int(11) NOT NULL,
  `manager` varchar(255) NOT NULL,
  PRIMARY KEY (`uidNumber`,`manager`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xprofiles_race` (
  `uidNumber` int(11) NOT NULL,
  `race` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`uidNumber`,`race`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xprofiles_role` (
  `uidNumber` int(11) NOT NULL,
  `role` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`uidNumber`,`role`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xprofiles_tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uidNumber` int(11) DEFAULT NULL,
  `tagid` int(11) DEFAULT NULL,
  `taggerid` int(11) DEFAULT '0',
  `taggedon` datetime DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__xsession` (
  `session_id` varchar(200) NOT NULL DEFAULT '0',
  `ip` varchar(15) DEFAULT NULL,
  `host` varchar(128) DEFAULT NULL,
  `domain` varchar(128) DEFAULT NULL,
  `signed` tinyint(3) DEFAULT '0',
  `countrySHORT` char(2) DEFAULT NULL,
  `countryLONG` varchar(64) DEFAULT NULL,
  `ipREGION` varchar(128) DEFAULT NULL,
  `ipCITY` varchar(128) DEFAULT NULL,
  `ipLATITUDE` double DEFAULT NULL,
  `ipLONGITUDE` double DEFAULT NULL,
  `bot` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`session_id`),
  KEY `idx_ip` (`ip`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__ysearch_plugin_weights` (
  `plugin` varchar(20) NOT NULL,
  `weight` float NOT NULL,
  PRIMARY KEY (`plugin`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `#__ysearch_site_map` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(200) NOT NULL,
  `description` text NOT NULL,
  `link` varchar(200) NOT NULL,
  PRIMARY KEY (`id`),
  FULLTEXT KEY `ftidx_title_description` (`title`,`description`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `session` (
  `sessnum` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(32) NOT NULL DEFAULT '',
  `remoteip` varchar(40) NOT NULL DEFAULT '',
  `exechost` varchar(40) NOT NULL DEFAULT '',
  `dispnum` int(10) unsigned DEFAULT '0',
  `start` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `accesstime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `timeout` int(11) DEFAULT '86400',
  `appname` varchar(80) NOT NULL DEFAULT '',
  `sessname` varchar(100) NOT NULL DEFAULT '',
  `sesstoken` varchar(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`sessnum`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `sessionlog` (
  `sessnum` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(32) NOT NULL DEFAULT '',
  `remoteip` varchar(40) NOT NULL DEFAULT '',
  `remotehost` varchar(40) NOT NULL DEFAULT '',
  `exechost` varchar(40) NOT NULL DEFAULT '',
  `dispnum` int(10) unsigned DEFAULT '0',
  `start` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `appname` varchar(80) NOT NULL DEFAULT '',
  `walltime` double unsigned DEFAULT '0',
  `viewtime` double unsigned DEFAULT '0',
  `cputime` double unsigned DEFAULT '0',
  `status` smallint(5) unsigned DEFAULT '0',
  PRIMARY KEY (`sessnum`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `sessionpriv` (
  `privid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `sessnum` bigint(20) unsigned NOT NULL DEFAULT '0',
  `privilege` varchar(40) NOT NULL DEFAULT '',
  `start` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`privid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `view` (
  `viewid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `sessnum` bigint(20) unsigned NOT NULL DEFAULT '0',
  `username` varchar(32) NOT NULL DEFAULT '',
  `remoteip` varchar(40) NOT NULL DEFAULT '',
  `start` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `heartbeat` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`viewid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `viewlog` (
  `sessnum` bigint(20) unsigned NOT NULL DEFAULT '0',
  `username` varchar(32) NOT NULL DEFAULT '',
  `remoteip` varchar(40) NOT NULL DEFAULT '',
  `remotehost` varchar(40) NOT NULL DEFAULT '',
  `time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `duration` float unsigned DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE TABLE `viewperm` (
  `sessnum` bigint(20) unsigned NOT NULL DEFAULT '0',
  `viewuser` varchar(32) NOT NULL DEFAULT '',
  `viewtoken` varchar(32) NOT NULL DEFAULT '',
  `geometry` varchar(9) NOT NULL DEFAULT '0',
  `fwhost` varchar(40) NOT NULL DEFAULT '',
  `fwport` smallint(5) unsigned NOT NULL DEFAULT '0',
  `vncpass` varchar(16) NOT NULL DEFAULT '',
  `readonly` varchar(4) NOT NULL DEFAULT 'Yes',
  PRIMARY KEY (`sessnum`,`viewuser`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

CREATE ALGORITHM = UNDEFINED DEFINER = CURRENT_USER SQL SECURITY INVOKER VIEW `#__resource_contributors_view` AS
    select `m`.`uidNumber` AS `uidNumber`, count(`AA`.`authorid`) AS `count`
    from ((`#__xprofiles` `m`
        left join `#__author_assoc` `AA` ON (((`AA`.`authorid` = `m`.`uidNumber`)
            and (`AA`.`subtable` = _utf8'resources'))))
        join `#__resources` `R` ON (((`R`.`id` = `AA`.`subid`)
            and (`R`.`published` = 1)
            and (`R`.`standalone` = 1))))
    where (`m`.`public` = 1) group by `m`.`uidNumber`;

CREATE ALGORITHM = UNDEFINED DEFINER = CURRENT_USER SQL SECURITY INVOKER VIEW `#__wiki_contributors_view` AS
    select `m`.`uidNumber` AS `uidNumber`, count(`w`.`id`) AS `count`
    from (`#__xprofiles` `m`
        left join `#__wiki_page` `w` ON (((`w`.`access` <> 1)
            and ((`w`.`created_by` = `m`.`uidNumber`)
            or ((`m`.`username` <> _utf8'')
            and (`w`.`authors` like concat(_utf8'%', `m`.`username`, _utf8'%')))))))
    where ((`m`.`public` = 1) and (`w`.`id` is not null)) group by `m`.`uidNumber`;

CREATE ALGORITHM = UNDEFINED DEFINER = CURRENT_USER SQL SECURITY INVOKER VIEW `#__contributor_ids_view` AS
    select `#__resource_contributors_view`.`uidNumber` AS `uidNumber`
    from `#__resource_contributors_view` 
    union select `#__wiki_contributors_view`.`uidNumber` AS `uidNumber`
    from`#__wiki_contributors_view`;

CREATE ALGORITHM = UNDEFINED DEFINER = CURRENT_USER SQL SECURITY INVOKER VIEW `#__contributors_view` AS
    select `c`.`uidNumber` AS `uidNumber`,
        coalesce(`r`.`count`, 0) AS `resource_count`,
        coalesce(`w`.`count`, 0) AS `wiki_count`,
        (coalesce(`w`.`count`, 0) + coalesce(`r`.`count`, 0)) AS `total_count`
    from ((`#__contributor_ids_view` `c`
        left join `#__resource_contributors_view` `r` ON ((`r`.`uidNumber` = `c`.`uidNumber`)))
        left join `#__wiki_contributors_view` `w` ON ((`w`.`uidNumber` = `c`.`uidNumber`)));

CREATE ALGORITHM = UNDEFINED DEFINER = CURRENT_USER SQL SECURITY INVOKER VIEW `#__courses_form_latest_responses_view` AS 
    SELECT `fre`.`id` AS `id`,
        `fre`.`respondent_id` AS `respondent_id`,
        `fre`.`question_id` AS `question_id`,
        `fre`.`answer_id` AS `answer_id`
    FROM `#__courses_form_responses` `fre` where ((select count(0) from `#__courses_form_responses` `frei` 
    where ((`frei`.`respondent_id` = `fre`.`respondent_id`) and (`frei`.`id` > `fre`.`id`))) < 
    (select count(distinct `frei`.`question_id`) from `#__courses_form_responses` `frei` 
    where (`frei`.`respondent_id` = `fre`.`respondent_id`)));

INSERT INTO `#__extensions` (`extension_id`, `name`, `type`, `element`, `folder`, `client_id`, `enabled`, `access`, `protected`, `manifest_cache`, `params`, `custom_data`, `system_data`, `checked_out`, `checked_out_time`, `ordering`, `state`) VALUES
(1000,'com_answers','component','com_answers','',1,1,1,0,'','{\"infolink\":\"\\/kb\\/points\",\"notify_users\":\"\"}','','',0,'0000-00-00 00:00:00',0,0),
(1001,'com_billboards','component','com_billboards','',1,1,1,0,'','','','',0,'0000-00-00 00:00:00',0,0),
(1002,'com_blog','component','com_blog','',1,1,1,0,'','{\"title\":\"\",\"uploadpath\":\"\\/site\\/blog\",\"show_authors\":\"1\",\"allow_comments\":\"1\",\"feeds_enabled\":\"1\",\"feed_entries\":\"partial\",\"show_date\":\"3\"}','','',0,'0000-00-00 00:00:00',0,0),
(1003,'com_citations','component','com_citations','',1,1,1,0,'','{\"citation_label\":\"number\",\"citation_rollover\":\"no\",\"citation_sponsors\":\"yes\",\"citation_import\":\"2\",\"citation_bulk_import\":\"2\",\"citation_download\":\"1\",\"citation_batch_download\":\"1\",\"citation_download_exclude\":\"\",\"citation_coins\":\"1\",\"citation_openurl\":\"1\",\"citation_url\":\"url\",\"citation_custom_url\":\"\",\"citation_cited\":\"0\",\"citation_cited_single\":\"\",\"citation_cited_multiple\":\"\",\"citation_show_tags\":\"no\",\"citation_allow_tags\":\"no\",\"citation_show_badges\":\"no\",\"citation_allow_badges\":\"no\",\"citation_format\":\"\"}','','',0,'0000-00-00 00:00:00',0,0),
(1004,'com_courses','component','com_courses','',1,1,1,0,'','{\"uploadpath\":\"\\/site\\/courses\",\"tmpl\":\"\",\"default_asset_groups\":\"Lectures, Activities, Exam\",\"auto_approve\":\"1\",\"email_comment_processing\":\"0\",\"email_member_coursesidcussionemail_autosignup\":\"0\",\"intro_mycourses\":\"1\",\"intro_interestingcourses\":\"1\",\"intro_popularcourses\":\"1\"}','','',0,'0000-00-00 00:00:00',0,0),
(1005,'com_cron','component','com_cron','',1,1,1,0,'',' ','','',0,'0000-00-00 00:00:00',0,0),
(1006,'com_events','component','com_events','',1,1,1,0,'','','','',0,'0000-00-00 00:00:00',0,0),
(1007,'com_features','component','com_features','',1,1,1,0,'','','','',0,'0000-00-00 00:00:00',0,0),
(1008,'com_feedback','component','com_feedback','',1,1,1,0,'','{\"defaultpic\":\"\\/components\\/com_feedback\\/assets\\/img\\/contributor.gif\",\"uploadpath\":\"\\/site\\/quotes\",\"maxAllowed\":\"40000000\",\"file_ext\":\"jpg,jpeg,jpe,bmp,tif,tiff,png,gif\",\"blacklist\":\"\",\"badwords\":\"viagra, pharmacy, xanax, phentermine, dating, ringtones, tramadol, hydrocodone, levitra, ambien, vicodin, fioricet, diazepam, cash advance, free online, online gambling, online prescriptions, debt consolidation, baccarat, loan, slots, credit, mortgage, casino, slot, texas holdem, teen nude, orgasm, gay, fuck, crap, shit, asshole, cunt, fucker, fuckers, motherfucker, fucking, milf, cocksucker, porno, videosex, sperm, hentai, internet gambling, kasino, kasinos, poker, lottery, texas hold em, texas holdem, fisting\"}','','',0,'0000-00-00 00:00:00',0,0),
(1009,'com_forum','component','com_forum','',1,1,1,0,'','','','',0,'0000-00-00 00:00:00',0,0),
(1010,'com_groups','component','com_groups','',1,1,1,0,'','{\"ldapGroupMirror\":\"1\",\"ldapGroupLegacy\":\"1\",\"uploadpath\":\"\\/site\\/groups\",\"iconpath\":\"\\/components\\/com_groups\\/assets\\/img\\/icons\",\"join_policy\":\"0\",\"privacy\":\"0\",\"auto_approve\":\"1\",\"display_system_users\":\"no\",\"email_comment_processing\":\"1\",\"email_member_groupsidcussionemail_autosignup\":\"0\"}','','',0,'0000-00-00 00:00:00',0,0),
(1011,'com_help','component','com_help','',1,1,1,0,'','','','',0,'0000-00-00 00:00:00',0,0),
(1012,'com_jobs','component','com_jobs','',1,1,1,0,'','{\"component_enabled\":\"1\",\"industry\":\"\",\"admingroup\":\"\",\"specialgroup\":\"jobsadmin\",\"autoapprove\":\"1\",\"defaultsort\":\"category\",\"jobslimit\":\"25\",\"maxads\":\"3\",\"allowsubscriptions\":\"1\",\"usonly\":\"0\",\"usegoogle\":\"0\",\"banking\":\"0\",\"promoline\":\"For a limited time: FREE Employer Services Basic subscription\",\"infolink\":\"kb\\/jobs\",\"premium_infolink\":\"\"}','','',0,'0000-00-00 00:00:00',0,0),
(1013,'com_kb','component','com_kb','',1,1,1,0,'','','','',0,'0000-00-00 00:00:00',0,0),
(1014,'com_members','component','com_members','',1,1,1,0,'','{\"privacy\":\"1\",\"bankAccounts\":\"0\",\"defaultpic\":\"\\/components\\/com_members\\/assets\\/img\\/profile.gif\",\"webpath\":\"\\/site\\/members\",\"homedir\":\"\\/home\\/myhub\",\"maxAllowed\":\"40000000\",\"file_ext\":\"jpg,jpeg,jpe,bmp,tif,tiff,png,gif\",\"user_messaging\":\"1\",\"employeraccess\":\"0\",\"gidNumber\":\"3000\",\"gid\":\"public\",\"shadowMax\":\"120\",\"shadowMin\":\"0\",\"shadowWarning\":\"7\"}','','',0,'0000-00-00 00:00:00',0,0),
(1015,'com_newsletter','component','com_newsletter','',1,1,1,0,'','','','',0,'0000-00-00 00:00:00',0,0),
(1016,'com_oaipmh','component','com_oaipmh','',1,1,1,1,'{}','{}','','',0,'0000-00-00 00:00:00',0,0),
(1017,'com_poll','component','com_poll','',1,1,1,0,'','','','',0,'0000-00-00 00:00:00',0,0),
(1018,'com_prj_dv','component','com_prj_dv','',1,1,1,1,'{}','{}','','',0,'0000-00-00 00:00:00',0,0),
(1019,'com_projects','component','com_projects','',1,1,1,1,'{}','{}','','',0,'0000-00-00 00:00:00',0,0),
(1020,'com_publications','component','com_publications','',1,1,1,1,'{}','{}','','',0,'0000-00-00 00:00:00',0,0),
(1021,'com_register','component','com_register','',1,1,1,0,'','{\"LoginReturn\":\"\\/members\\/myaccount\",\"ConfirmationReturn\":\"\\/members\\/myaccount\",\"passwordMeter\":\"0\",\"registrationUsername\":\"RRUU\",\"registrationPassword\":\"RRUU\",\"registrationConfirmPassword\":\"RRUU\",\"registrationFullname\":\"RRUU\",\"registrationEmail\":\"RRUU\",\"registrationConfirmEmail\":\"RRUU\",\"registrationURL\":\"HOHO\",\"registrationPhone\":\"HOHO\",\"registrationEmployment\":\"HOHO\",\"registrationOrganization\":\"HOHO\",\"registrationCitizenship\":\"RHHR\",\"registrationResidency\":\"RHHR\",\"registrationSex\":\"HHHH\",\"registrationDisability\":\"HHHH\",\"registrationHispanic\":\"HHHH\",\"registrationRace\":\"RHHR\",\"registrationInterests\":\"HOHO\",\"registrationReason\":\"HOHO\",\"registrationOptIn\":\"HOHO\",\"registrationCAPTCHA\":\"HHHH\",\"registrationTOU\":\"RHRH\"}','','',0,'0000-00-00 00:00:00',0,0),
(1022,'com_resources','component','com_resources','',1,1,1,0,'','{\"autoapprove\":\"0\",\"autoapproved_users\":\"\",\"cc_license\":\"1\",\"email_when_approved\":\"0\",\"defaultpic\":\"\\/components\\/com_resources\\/images\\/resource_thumb.gif\",\"tagstool\":\"screenshots,poweredby,bio,credits,citations,sponsoredby,references,publications\",\"tagsothr\":\"bio,credits,citations,sponsoredby,references,publications\",\"accesses\":\"Public,Registered,Special,Protected,Private\",\"webpath\":\"\\/site\\/resources\",\"toolpath\":\"\\/site\\/resources\\/tools\",\"uploadpath\":\"\\/site\\/resources\",\"maxAllowed\":\"40000000\",\"file_ext\":\"jpg,jpeg,jpe,bmp,tif,tiff,png,gif,pdf,zip,mpg,mpeg,avi,mov,wmv,asf,asx,ra,rm,txt,rtf,doc,xsl,html,js,wav,mp3,eps,ppt,pps,swf,tar,tex,gz\",\"doi\":\"\",\"aboutdoi\":\"\",\"supportedtag\":\"\",\"supportedlink\":\"\",\"browsetags\":\"on\",\"google_id\":\"\",\"show_authors\":\"1\",\"show_assocs\":\"1\",\"show_ranking\":\"0\",\"show_rating\":\"1\",\"show_date\":\"3\",\"show_metadata\":\"1\",\"show_citation\":\"1\",\"show_audience\":\"0\",\"audiencelink\":\"\"}','','',0,'0000-00-00 00:00:00',0,0),
(1023,'com_services','component','com_services','',1,1,1,0,'','{\"autoapprove\":\"1\"}','','',0,'0000-00-00 00:00:00',0,0),
(1024,'com_store','component','com_store','',1,1,1,0,'','{\"store_enabled\":\"1\",\"webpath\":\"\\/site\\/store\",\"hubaddress_ln1\":\"\",\"hubaddress_ln2\":\"\",\"hubaddress_ln3\":\"\",\"hubaddress_ln4\":\"\",\"hubaddress_ln5\":\"\",\"hubemail\":\"\",\"hubphone\":\"\",\"headertext_ln1\":\"\",\"headertext_ln2\":\"\",\"footertext\":\"\",\"receipt_title\":\"Your Order at HUB Store\",\"receipt_note\":\"Thank You for contributing to our HUB!\"}','','',0,'0000-00-00 00:00:00',0,0),
(1025,'com_support','component','com_support','',1,1,1,0,'','{\"feed_summary\":\"0\",\"severities\":\"critical,major,normal,minor,trivial\",\"webpath\":\"\\/site\\/tickets\",\"maxAllowed\":\"40000000\",\"file_ext\":\"jpg,jpeg,jpe,bmp,tif,tiff,png,gif,pdf,zip,mpg,mpeg,avi,mov,wmv,asf,asx,ra,rm,txt,rtf,doc,xsl,html,js,wav,mp3,eps,ppt,pps,swf,tar,tex,gz\",\"group\":\"\",\"emails\":\"{config.mailfrom}\",\"0\":\"\",\"blacklist\":\"\",\"badwords\":\"viagra, pharmacy, xanax, phentermine, dating, ringtones, tramadol, hydrocodone, levitra, ambien, vicodin, fioricet, diazepam, cash advance, free online, online gambling, online prescriptions, debt consolidation, baccarat, loan, slots, credit, mortgage, casino, slot, texas holdem, teen nude, orgasm, gay, fuck, crap, shit, asshole, cunt, fucker, fuckers, motherfucker, fucking, milf, cocksucker, porno, videosex, sperm, hentai, internet gambling, kasino, kasinos, poker, lottery, texas hold em, texas holdem, fisting\",\"email_processing\":\"1\"}','','',0,'0000-00-00 00:00:00',0,0),
(1026,'com_system','component','com_system','',1,1,1,0,'','{\"geodb_geodb_driver\":\"mysql\",\"geodb_geodb_host\":\"hubzero.org\",\"geodb_geodb_port\":\"\",\"geodb_geodb_user\":\"hubzero_network\",\"geodb_geodb_password\":\"\",\"geodb_geodb_database\":\"hubzero_network\",\"geodb_geodb_prefix\":\"\",\"ldap_primary\":\"ldap:\\/\\/127.0.0.1\",\"ldap_secondary\":\"\",\"ldap_basedn\":\"dc\",\"ldap_searchdn\":\"\",\"ldap_searchpw\":\"\",\"ldap_managerdn\":\"cn\",\"ldap_managerpw\":\"hubvmpw\",\"ldap_tls\":\"0\"}','','',0,'0000-00-00 00:00:00',0,0),
(1027,'com_tags','component','com_tags','',1,1,1,0,'','','','',0,'0000-00-00 00:00:00',0,0),
(1028,'com_tools','component','com_tools','',1,1,1,0,'','{\"mw_on\":\"1\",\"mw_redirect\":\"\\/home\",\"stopRedirect\":\"index.php?option\",\"mwDBDriver\":\"mysql\",\"mwDBHost\":\"localhost\",\"mwDBPort\":\"\",\"mwDBUsername\":\"myhub\",\"mwDBPassword\":\"hubvmpw\",\"mwDBDatabase\":\"myhub\",\"mwDBPrefix\":\"\",\"shareable\":\"1\",\"warn_multiples\":\"0\",\"storagehost\":\"tcp:\\/\\/localhost:300\",\"show_storage\":\"1\",\"params_whitelist\":\"\",\"contribtool_on\":\"0\",\"contribtool_redirect\":\"\\/home\",\"launch_ipad\":\"0\",\"admingroup\":\"apps\",\"default_mw\":\"narwhal\",\"default_vnc\":\"780x600\",\"developer_site\":\"nanoFORGE\",\"project_path\":\"\\/projects\\/app-\",\"invokescript_dir\":\"\\/apps\",\"dev_suffix\":\"_dev\",\"group_prefix\":\"app-\",\"sourcecodePath\":\"site\\/protected\\/source\",\"learn_url\":\"http:\\/\\/rappture.org\\/wiki\\/FAQ_UpDownloadSrc\",\"rappture_url\":\"http:\\/\\/rappture.org\",\"demo_url\":\"\",\"new_doi\":\"0\",\"doi_newservice\":\"\",\"doi_shoulder\":\"\",\"doi_newprefix\":\"\",\"doi_publisher\":\"\",\"doi_resolve\":\"http:\\/\\/dx.doi.org\\/\",\"doi_verify\":\"http:\\/\\/n2t.net\\/ezid\\/id\\/\",\"exec_pu\":\"1\",\"screenshot_edit\":\"0\",\"downloadable_on\":\"0\"}','','',0,'0000-00-00 00:00:00',0,0),
(1029,'com_topics','component','com_topics','',1,1,1,0,'','','','',0,'0000-00-00 00:00:00',0,0),
(1030,'com_usage','component','com_usage','',1,1,1,0,'','{\"statsDBDriver\":\"mysql\",\"statsDBHost\":\"localhost\",\"statsDBPort\":\"\",\"statsDBUsername\":\"\",\"statsDBPassword\":\"\",\"statsDBDatabase\":\"\",\"statsDBPrefix\":\"\",\"mapsApiKey\":\"\",\"stats_path\":\"\\/site\\/stats\",\"maps_path\":\"\\/site\\/stats\\/maps\",\"plots_path\":\"\\/site\\/stats\\/plots\",\"charts_path\":\"\\/site\\/stats\\/plots\"}','','',0,'0000-00-00 00:00:00',0,0),
(1031,'com_whatsnew','component','com_whatsnew','',1,1,1,0,'','','','',0,'0000-00-00 00:00:00',0,0),
(1032,'com_wiki','component','com_wiki','',1,1,1,0,'','{\"subpage_separator\":\"\\/\",\"homepage\":\"MainPage\",\"max_pagename_length\":\"100\",\"filepath\":\"\\/site\\/wiki\",\"mathpath\":\"\\/site\\/wiki\\/math\",\"tmppath\":\"\\/site\\/wiki\\/tmp\",\"maxAllowed\":\"40000000\",\"img_ext\":\"jpg,jpeg,jpe,bmp,tif,tiff,png,gif\",\"file_ext\":\"jpg,jpeg,jpe,bmp,tif,tiff,png,gif,pdf,zip,mpg,mpeg,avi,mov,wmv,asf,asx,ra,rm,txt,rtf,doc,xsl,html,js,wav,mp3,eps,ppt,pps,swf,tar,tex,gz\",\"cache\":\"0\",\"cache_time\":\"15\"}','','',0,'0000-00-00 00:00:00',0,0),
(1033,'com_wishlist','component','com_wishlist','',1,1,1,0,'','{\"categories\":\"general, resource, group, user\",\"group\":\"hubdev\",\"banking\":\"0\",\"allow_advisory\":\"0\",\"votesplit\":\"0\",\"webpath\":\"\\/site\\/wishlist\",\"show_percentage_granted\":\"0\"}','','',0,'0000-00-00 00:00:00',0,0),
(1034,'com_ysearch','component','com_ysearch','',1,1,1,0,'','','','',0,'0000-00-00 00:00:00',0,0);

INSERT INTO `#__extensions` (`extension_id`, `name`, `type`, `element`, `folder`, `client_id`, `enabled`, `access`, `protected`, `manifest_cache`, `params`, `custom_data`, `system_data`, `checked_out`, `checked_out_time`, `ordering`, `state`) VALUES
(1400,'Authentication - Facebook','plugin','facebook','authentication',0,0,1,0,'','app_id=\napp_secret=\n','','',0,'0000-00-00 00:00:00',2,0),
(1401,'Authentication - Google','plugin','google','authentication',0,0,1,0,'','app_id=\napp_secret=\n','','',0,'0000-00-00 00:00:00',3,0),
(1402,'Authentication - HUBzero','plugin','hubzero','authentication',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',1,0),
(1403,'Authentication - Linkedin','plugin','linkedin','authentication',0,0,1,0,'','api_key=\napp_secret=\n','','',0,'0000-00-00 00:00:00',4,0),
(1404,'Authentication - PUCAS','plugin','pucas','authentication',0,0,1,0,'','domain=Purdue Career Account (CAS)\ndisplay_name=Purdue Career\n\n','','',0,'0000-00-00 00:00:00',6,0),
(1405,'Authentication - Twitter','plugin','twitter','authentication',0,0,1,0,'','','','',0,'0000-00-00 00:00:00',5,0),
(1406,'Citation - Bibtex','plugin','bibtex','citation',0,1,1,0,'','title_match_percent=90%\n\n','','',0,'0000-00-00 00:00:00',2,0),
(1407,'Citation - Default','plugin','default','citation',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',1,0),
(1408,'Citation - Endnote','plugin','endnote','citation',0,1,1,0,'','custom_tags=badges-%=\ntags-%<\ntitle_match_percent=85%\n\n','','',0,'0000-00-00 00:00:00',3,0),
(1409,'Content - xHubTags','plugin','xhubtags','content',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',7,0),
(1410,'Courses - Announcements','plugin','announcements','courses',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',7,0),
(1411,'Courses - Course FAQ','plugin','faq','courses',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',11,0),
(1412,'Courses - Course Offerings','plugin','offerings','courses',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',10,0),
(1413,'Courses - Course Overview','plugin','overview','courses',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',6,0),
(1414,'Courses - Course Related','plugin','related','courses',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',12,0),
(1415,'Courses - Course Reviews','plugin','reviews','courses',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',9,0),
(1416,'Courses - Dashboard','plugin','dashboard','courses',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',8,0),
(1417,'Courses - Disucssions','plugin','discussions','courses',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',2,0),
(1418,'Courses - Guide','plugin','guide','courses',0,0,1,0,'','','','',0,'0000-00-00 00:00:00',15,0),
(1419,'Courses - My Progress','plugin','progress','courses',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',4,0),
(1420,'Courses - Notes','plugin','notes','courses',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',13,0),
(1421,'Courses - Outline','plugin','outline','courses',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',3,0),
(1422,'Courses - Pages','plugin','pages','courses',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',5,0),
(1423,'Courses - Store','plugin','store','courses',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',14,0),
(1424,'Courses - Syllabus','plugin','syllabus','courses',0,0,1,0,'','','','',0,'0000-00-00 00:00:00',1,0),
(1425,'Cron - Cache','plugin','cache','cron',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',2,0),
(1426,'Cron - Groups','plugin','groups','cron',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',2,0),
(1427,'Cron - Members','plugin','members','cron',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',3,0),
(1428,'Cron - Newsletter','plugin','newsletter','cron',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',4,0),
(1429,'Cron - Support','plugin','support','cron',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',5,0),
(1430,'Groups - Announcements','plugin','announcements','groups',0,1,1,0,'','plugin_access=members\ndisplay_tab=1','','',0,'0000-00-00 00:00:00',12,0),
(1431,'Groups - Blog','plugin','blog','groups',0,1,1,0,'','uploadpath=/site/groups/{{gid}}/blog\nposting=0\nfeeds_enabled=0\nfeed_entries=partial','','',0,'0000-00-00 00:00:00',6,0),
(1432,'Groups - Calendar','plugin','calendar','groups',0,0,1,0,'','','','',0,'0000-00-00 00:00:00',10,0),
(1433,'Groups - Forum','plugin','forum','groups',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',5,0),
(1434,'Groups - Member Options','plugin','memberoptions','groups',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',11,0),
(1435,'Groups - Members','plugin','members','groups',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',1,0),
(1436,'Groups - Messages','plugin','messages','groups',0,1,1,0,'','{\"limit\":50,\"display_tab\":0}','','',0,'0000-00-00 00:00:00',3,0),
(1437,'Groups - Projects','plugin','projects','groups',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',8,0),
(1438,'Groups - Resources','plugin','resources','groups',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',4,0),
(1439,'Groups - Usage','plugin','usage','groups',0,0,1,0,'','uploadpath=/site/groups/{{gid}}/blog\nposting=0\nfeeds_enabled=0\nfeed_entries=partial','','',0,'0000-00-00 00:00:00',9,0),
(1440,'Groups - Wiki','plugin','wiki','groups',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',2,0),
(1441,'Groups - Wishlist','plugin','wishlist','groups',0,1,1,0,'','limit=50','','',0,'0000-00-00 00:00:00',7,0),
(1442,'HUBzero - Autocompleter','plugin','autocompleter','hubzero',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',1,0),
(1443,'HUBzero - Comments','plugin','comments','hubzero',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',7,0),
(1444,'HUBzero - Wiki Parser','plugin','wikiparser','hubzero',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',3,0),
(1445,'HUBzero - Wiki Editor Toolbar','plugin','wikieditortoolbar','hubzero',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',2,0),
(1446,'HUBzero - Wiki Editor WYSIWYG','plugin','wikieditorwykiwyg','hubzero',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',8,0),
(1447,'HUBzero - Image CAPTCHA','plugin','imagecaptcha','hubzero',0,1,1,0,'','bgColor=#2c8007\ntextColor=#ffffff\nimageFunction=Adv\n','','',0,'0000-00-00 00:00:00',4,0),
(1448,'HUBzero - Math CAPTCHA','plugin','mathcaptcha','hubzero',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',5,0),
(1449,'HUBzero - ReCAPTCHA','plugin','recaptcha','hubzero',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',6,0),
(1450,'Members - Account','plugin','account','members',0,1,1,0,'','ssh_key_upload=1\n\n','','',0,'0000-00-00 00:00:00',12,0),
(1451,'Members - Blog','plugin','blog','members',0,1,1,0,'','uploadpath=/site/members/{{uid}}/blog\nfeeds_enabled=0\nfeed_entries=partial','','',0,'0000-00-00 00:00:00',13,0),
(1452,'Members - Contributions','plugin','contributions','members',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',5,0),
(1453,'Members - Contributions - Resources','plugin','resources','members',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',6,0),
(1454,'Members - Contributions - Topics','plugin','wiki','members',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',7,0),
(1455,'Members - Courses','plugin','courses','members',0,0,1,0,'','','','',0,'0000-00-00 00:00:00',15,0),
(1456,'Members - Dashboard','plugin','dashboard','members',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',1,0),
(1457,'Members - Favorites','plugin','favorites','members',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',9,0),
(1458,'Members - Groups','plugin','groups','members',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',3,0),
(1460,'Members - Messages','plugin','messages','members',0,1,1,0,'','default_method=email\n\n','','',0,'0000-00-00 00:00:00',10,0),
(1461,'Members - Points','plugin','points','members',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',4,0),
(1462,'Members - Profile','plugin','profile','members',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',2,0),
(1463,'Members - Projects','plugin','projects','members',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',14,0),
(1464,'Members - Resume','plugin','resume','members',0,1,1,0,'','limit=50','','',0,'0000-00-00 00:00:00',11,0),
(1465,'Members - Usage','plugin','usage','members',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',8,0),
(1466,'Projects - Blog','plugin','blog','projects',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',1,0),
(1467,'Projects - Files','plugin','files','projects',0,1,1,0,'','display_limit=50\nmaxUpload=104857600\nmaxDownload=1048576\ntempPath=/site/projects/temp\n\n','','',0,'0000-00-00 00:00:00',3,0),
(1468,'Projects - Notes','plugin','notes','projects',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',5,0),
(1469,'Projects - Publications','plugin','publications','projects',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',6,0),
(1470,'Projects - Team','plugin','team','projects',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',2,0),
(1471,'Projects - Todo','plugin','todo','projects',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',4,0),
(1472,'Resources - About','plugin','about','resources',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',1,0),
(1473,'Resources - About (tool)','plugin','abouttool','resources',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',9,0),
(1474,'Resources - Citations','plugin','citations','resources',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',10,0),
(1475,'Resources - Favorite','plugin','favorite','resources',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',7,0),
(1476,'Resources - Questions','plugin','questions','resources',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',11,0),
(1477,'Resources - Recommendations','plugin','recommendations','resources',0,0,1,0,'','','','',0,'0000-00-00 00:00:00',2,0),
(1478,'Resources - Related','plugin','related','resources',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',3,0),
(1479,'Resources - Reviews','plugin','reviews','resources',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',4,0),
(1480,'Resources - Share','plugin','share','resources',0,1,1,0,'','icons_limit=3\nshare_facebook=1\nshare_twitter=1\nshare_google=1\nshare_digg=1\nshare_technorati=1\nshare_delicious=1\nshare_reddit=0\nshare_email=0\nshare_print=0\n\n','','',0,'0000-00-00 00:00:00',8,0),
(1481,'Resources - Sponsors','plugin','sponsors','resources',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',12,0),
(1482,'Resources - Supporting Documents','plugin','supportingdocs','resources',0,1,1,0,'','display_limit=50','','',0,'0000-00-00 00:00:00',13,0),
(1483,'Resources - Usage','plugin','usage','resources',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',5,0),
(1484,'Resources - Versions','plugin','versions','resources',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',6,0),
(1485,'Resources - Wishlist','plugin','wishlist','resources',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',14,0),
(1486,'Support - Answers','plugin','answers','support',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',1,0),
(1487,'Support - Blog','plugin','blog','support',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',6,0),
(1488,'Support - CAPTCHA','plugin','captcha','support',0,1,1,0,'','modCaptcha=text\ncomCaptcha=image\nbgColor=#2c8007\ntextColor=#ffffff\nimageFunction=Adv\n','','',0,'0000-00-00 00:00:00',7,0),
(1489,'Support - Comments','plugin','comments','support',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',2,0),
(1490,'Support - Knowledgebase Comments','plugin','kb','support',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',8,0),
(1491,'Support - Resources','plugin','resources','support',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',3,0),
(1492,'Support - Transfer','plugin','transfer','support',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',5,0),
(1493,'Support - Wishlist','plugin','wishlist','support',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',4,0),
(1494,'System - HUBzero','plugin','hubzero','system',0,1,1,0,'','search=ysearch\n\n','','',0,'0000-00-00 00:00:00',9,0),
(1495,'System - xFeed','plugin','xfeed','system',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',10,0),
(1496,'System - Disable Cache','plugin','disablecache','system',0,1,1,0,'','definitions=/about/contact\nreenable_afterdispatch=0\n\n','','',0,'0000-00-00 00:00:00',11,0),
(1497,'System - JQuery','plugin','jquery','system',0,1,1,1,'','jquery=1\njqueryVersion=1.7.2\njquerycdnpath=//ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js\njqueryui=1\njqueryuiVersion=1.8.6\njqueryuicdnpath=//ajax.googleapis.com/ajax/libs/jqueryui/1.8.6/jquery-ui.min.js\njqueryuicss=0\njqueryuicsspath=/plugins/system/jquery/css/jquery-ui-1.8.6.custom.css\njquerytools=1\njquerytoolsVersion=1.2.5\njquerytoolscdnpath=http://cdn.jquerytools.org/1.2.5/all/jquery.tools.min.js\njqueryfb=1\njqueryfbVersion=2.0.4\njqueryfbcdnpath=//fancyapps.com/fancybox/\njqueryfbcss=0\njqueryfbcsspath=/plugins/system/jquery/css/jquery-fancybox-2.0.4.css\nactivateSite=1\nnoconflictSite=0\nactivateAdmin=0\nnoconflictAdmin=0\n\n','','',0,'0000-00-00 00:00:00',12,0),
(1498,'Tags - Answers','plugin','answers','tags',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',7,0),
(1499,'Tags - Blogs','plugin','blogs','tags',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',9,0),
(1500,'Tags - Citations','plugin','citations','tags',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',10,0),
(1501,'Tags - Events','plugin','events','tags',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',5,0),
(1502,'Tags - Forum','plugin','forum','tags',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',8,0),
(1503,'Tags - Groups','plugin','groups','tags',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',6,0),
(1504,'Tags - Knowledgebase','plugin','kb','tags',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',11,0),
(1505,'Tags - Members','plugin','members','tags',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',3,0),
(1506,'Tags - Resources','plugin','resources','tags',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',1,0),
(1507,'Tags - Support','plugin','support','tags',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',4,0),
(1508,'Tags - Topics','plugin','wiki','tags',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',2,0),
(1509,'Usage - Domains','plugin','domains','usage',0,0,1,0,'','','','',0,'0000-00-00 00:00:00',6,0),
(1510,'Usage - Domain Class','plugin','domainclass','usage',0,0,1,0,'','','','',0,'0000-00-00 00:00:00',1,0),
(1511,'Usage - Maps','plugin','maps','usage',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',7,0),
(1512,'Usage - Overview','plugin','overview','usage',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',2,0),
(1513,'Usage - Region','plugin','region','usage',0,0,1,0,'','','','',0,'0000-00-00 00:00:00',8,0),
(1514,'Usage - Partners','plugin','partners','usage',0,0,1,0,'','','','',0,'0000-00-00 00:00:00',3,0),
(1515,'Usage - Tools','plugin','tools','usage',0,0,1,0,'','','','',0,'0000-00-00 00:00:00',4,0),
(1516,'User - xHUB','plugin','xusers','user',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',4,0),
(1517,'User - LDAP','plugin','ldap','user',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',5,0),
(1518,'User - Constant Contact','plugin','constantcontact','user',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',6,0),
(1519,'Whatsnew - Content','plugin','content','whatsnew',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',1,0),
(1520,'Whatsnew - Events','plugin','events','whatsnew',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',2,0),
(1521,'Whatsnew - Knowledge Base','plugin','kb','whatsnew',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',3,0),
(1522,'Whatsnew - Resources','plugin','resources','whatsnew',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',4,0),
(1523,'Whatsnew - Topics','plugin','wiki','whatsnew',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',5,0),
(1524,'XMessage - RSS','plugin','rss','xmessage',0,0,1,0,'','','','',0,'0000-00-00 00:00:00',4,0),
(1525,'XMessage - Internal','plugin','internal','xmessage',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',5,0),
(1526,'XMessage - SMS TXT','plugin','smstxt','xmessage',0,0,1,0,'','','','',0,'0000-00-00 00:00:00',3,0),
(1527,'XMessage - Instant Message','plugin','im','xmessage',0,0,1,0,'','','','',0,'0000-00-00 00:00:00',2,0),
(1528,'XMessage - Handler','plugin','handler','xmessage',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',1,0),
(1529,'XMessage - Email','plugin','email','xmessage',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',0,0),
(1530,'YSearch - Blogs','plugin','blogs','ysearch',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',0,0),
(1531,'YSearch - Citations','plugin','citations','ysearch',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',0,0),
(1532,'YSearch - Content','plugin','content','ysearch',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',0,0),
(1533,'YSearch - Increase weight of items with terms matching in their titles','plugin','weighttitle','ysearch',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',0,0),
(1534,'YSearch - Events','plugin','events','ysearch',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',0,0),
(1535,'YSearch - Forum','plugin','forum','ysearch',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',0,0),
(1536,'YSearch - Groups','plugin','groups','ysearch',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',0,0),
(1537,'YSearch - Knowledge Base','plugin','kb','ysearch',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',0,0),
(1538,'YSearch - Members','plugin','members','ysearch',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',0,0),
(1539,'YSearch - Questions and Answers','plugin','questions','ysearch',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',0,0),
(1540,'YSearch - Resources','plugin','resources','ysearch',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',0,0),
(1541,'YSearch - Site Map','plugin','sitemap','ysearch',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',0,0),
(1542,'YSearch - Sort courses by date','plugin','sortcourses','ysearch',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',0,0),
(1543,'YSearch - Sort events by date','plugin','sortevents','ysearch',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',0,0),
(1544,'YSearch - Terms - Suffix Expansion','plugin','suffixes','ysearch',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',0,0),
(1545,'YSearch - Topics','plugin','wiki','ysearch',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',0,0),
(1546,'YSearch - Increase weight of items with contributors matching terms','plugin','weightcontributor','ysearch',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',0,0),
(1547,'YSearch - Increase relevance for tool results','plugin','weighttools','ysearch',0,0,1,0,'','','','',0,'0000-00-00 00:00:00',0,0),
(1548,'YSearch - Wishlists','plugin','wishlists','ysearch',0,1,1,0,'','','','',0,'0000-00-00 00:00:00',0,0);

INSERT INTO `#__extensions` (`extension_id`, `name`, `type`, `element`, `folder`, `client_id`, `enabled`, `access`, `protected`, `manifest_cache`, `params`, `custom_data`, `system_data`, `checked_out`, `checked_out_time`, `ordering`, `state`) VALUES
(1549, 'hubbasic', 'template', 'hubbasic', '', 0, 1, 1, 0, '{}', '{}', '', '', 0, '0000-00-00 00:00:00', 0, 0),
(1550, 'hubbasic2012', 'template', 'hubbasic2012', '', 0, 1, 1, 0, '{}', '{}', '', '', 0, '0000-00-00 00:00:00', 0, 0),
(1551, 'hubbasic2013', 'template', 'hubbasic2013', '', 0, 1, 1, 0, '{}', '{}', '', '', 0, '0000-00-00 00:00:00', 0, 0),
(1552, 'hubbasicadmin', 'template', 'hubbasicadmin', '', 1, 1, 1, 0, '{}', '{}', '', '', 0, '0000-00-00 00:00:00', 0, 0);

--
-- HUBzero sample data for table `#__template_styles`
--

UPDATE `#__template_styles` SET home=0;
INSERT INTO `#__template_styles` VALUES (7,'hubbasic',0,'0','HUBzero Standard Site Template - 2011','{}');
INSERT INTO `#__template_styles` VALUES (8,'hubbasic2012',0,'0','HUBzero Standard Site Template - 2012','{}');
INSERT INTO `#__template_styles` VALUES (9,'hubbasic2013',0,'1','HUBzero Standard Site Template - 2013','{}');
INSERT INTO `#__template_styles` VALUES (10,'hubbasicadmin',1,'1','HUBzero Standard Admin Template','{}');

INSERT INTO `#__stats_tops` VALUES (1,'Top Tools by Ranking',1,5);
INSERT INTO `#__stats_tops` VALUES (2,'Top Tools by Simulation Users',1,5);
INSERT INTO `#__stats_tops` VALUES (3,'Top Tools by Interactive Sessions',1,5);
INSERT INTO `#__stats_tops` VALUES (4,'Top Tools by Simulation Sessions',1,5);
INSERT INTO `#__stats_tops` VALUES (5,'Top Tools by Simulation Runs',1,5);
INSERT INTO `#__stats_tops` VALUES (6,'Top Tools by Simulation Wall Time',2,5);
INSERT INTO `#__stats_tops` VALUES (7,'Top Tools by Simulation CPU Time',2,5);
INSERT INTO `#__stats_tops` VALUES (8,'Top Tools by Simulation Interaction Time',2,5);
INSERT INTO `#__stats_tops` VALUES (9,'Top Tools by Citations',1,5);

INSERT INTO `#__resource_stats_tools_tops` VALUES (1,'Users By Country Of Residence',1,5);
INSERT INTO `#__resource_stats_tools_tops` VALUES (2,'Top Domains By User Count',1,5);
INSERT INTO `#__resource_stats_tools_tops` VALUES (3,'Users By Organization Type',1,5);

INSERT INTO `#__xmessage_component` VALUES (1,'com_support','support_reply_submitted','Someone replies to a support ticket I submitted.');
INSERT INTO `#__xmessage_component` VALUES (2,'com_support','support_reply_assigned','Someone replies to a support ticket I am assigned to.');
INSERT INTO `#__xmessage_component` VALUES (3,'com_support','support_close_submitted','Someone closes a support ticket I submitted.');
INSERT INTO `#__xmessage_component` VALUES (4,'com_answers','answers_reply_submitted','Someone answers a question I submitted.');
INSERT INTO `#__xmessage_component` VALUES (5,'com_answers','answers_reply_comment','Someone replies to a comment I posted.');
INSERT INTO `#__xmessage_component` VALUES (6,'com_answers','answers_question_deleted','Someone deletes a question I replied to.');
INSERT INTO `#__xmessage_component` VALUES (7,'com_groups','groups_requests_membership','Someone requests membership to a group I manage.');
INSERT INTO `#__xmessage_component` VALUES (8,'com_groups','groups_requests_status','Someone is approved/denied membership to a group I manage.');
INSERT INTO `#__xmessage_component` VALUES (9,'com_groups','groups_cancels_membership','Someone cancels membership to a group I manage.');
INSERT INTO `#__xmessage_component` VALUES (10,'com_groups','groups_promoted_demoted','Someone promotes/demotes a member of a group I manage.');
INSERT INTO `#__xmessage_component` VALUES (11,'com_groups','groups_approved_denied','My membership request to a group is approved or denied.');
INSERT INTO `#__xmessage_component` VALUES (12,'com_groups','groups_status_changed','My membership status changes');
INSERT INTO `#__xmessage_component` VALUES (13,'com_groups','groups_cancelled_me','My membership to a group is cancelled.');
INSERT INTO `#__xmessage_component` VALUES (14,'com_groups','groups_changed','Someone changes the settings of a group I am a member of.');
INSERT INTO `#__xmessage_component` VALUES (15,'com_groups','groups_deleted','Someone deletes a group I am a member of.');
INSERT INTO `#__xmessage_component` VALUES (16,'com_resources','resources_submission_approved','A contribution I submitted is approved.');
INSERT INTO `#__xmessage_component` VALUES (17,'com_resources','resources_new_comment','Someone adds a review/comment to one of my contributions.');
INSERT INTO `#__xmessage_component` VALUES (18,'com_store','store_notifications','Shipping and other notifications about my purchases.');
INSERT INTO `#__xmessage_component` VALUES (19,'com_wishlist','wishlist_new_wish','Someone posted a wish on the Wish List I control.');
INSERT INTO `#__xmessage_component` VALUES (20,'com_wishlist','wishlist_status_changed','A wish I submitted got accepted/rejected/granted.');
INSERT INTO `#__xmessage_component` VALUES (21,'com_support','support_item_transferred','A support ticket/wish/question I submitted got transferred.');
INSERT INTO `#__xmessage_component` VALUES (22,'com_wishlist','wishlist_comment_posted','Someone commented on a wish I posted or am assigned to');
INSERT INTO `#__xmessage_component` VALUES (23,'com_groups','groups_invite','When you are invited to join a group.');
INSERT INTO `#__xmessage_component` VALUES (24,'com_contribtool','contribtool_status_changed','Tool development status has changed');
INSERT INTO `#__xmessage_component` VALUES (25,'com_contribtool','contribtool_new_message','New contribtool message is received');
INSERT INTO `#__xmessage_component` VALUES (26,'com_contribtool','contribtool_info_changed','Information about a tool I develop has changed');
INSERT INTO `#__xmessage_component` VALUES (27,'com_wishlist','wishlist_comment_thread','Someone replied to my comment or followed me in a discussion');
INSERT INTO `#__xmessage_component` VALUES (28,'com_wishlist','wishlist_new_owner','You were added as an administrator of a Wish List');
INSERT INTO `#__xmessage_component` VALUES (29,'com_wishlist','wishlist_wish_assigned','A wish has been assigned to me');
INSERT INTO `#__xmessage_component` VALUES (30,'com_groups','group_message','Messages from fellow group members');
INSERT INTO `#__xmessage_component` VALUES (31,'com_members','member_message','Messages from fellow site members');
INSERT INTO `#__xmessage_component` VALUES (32,'com_projects','projects_member_added','You were added or invited to a project');
INSERT INTO `#__xmessage_component` VALUES (33,'com_projects','projects_new_project_admin','Receive notifications about project(s) you monitor as an admin or reviewer');
INSERT INTO `#__xmessage_component` VALUES (34,'com_projects','projects_admin_message','Receive administrative messages about your project(s)');

INSERT INTO `#__ysearch_plugin_weights` VALUES ('content',0.8);
INSERT INTO `#__ysearch_plugin_weights` VALUES ('events',0.8);
INSERT INTO `#__ysearch_plugin_weights` VALUES ('groups',0.8);
INSERT INTO `#__ysearch_plugin_weights` VALUES ('kb',0.8);
INSERT INTO `#__ysearch_plugin_weights` VALUES ('members',0.8);
INSERT INTO `#__ysearch_plugin_weights` VALUES ('resources',0.8);
INSERT INTO `#__ysearch_plugin_weights` VALUES ('wiki',1);
INSERT INTO `#__ysearch_plugin_weights` VALUES ('weighttitle',1);
INSERT INTO `#__ysearch_plugin_weights` VALUES ('sortrelevance',1);
INSERT INTO `#__ysearch_plugin_weights` VALUES ('sortnewer',0.2);
INSERT INTO `#__ysearch_plugin_weights` VALUES ('tagmod',1.3);
INSERT INTO `#__ysearch_plugin_weights` VALUES ('weightcontributor',0.2);

INSERT INTO `#__courses_roles` (`offering_id`, `alias`, `title`, `permissions`) VALUES	(0, 'instructor', 'Instructor', ''), (0, 'manager', 'Manager', ''),	(0, 'student', 'Student', '');

INSERT INTO `#__courses_grade_policies` (`id`, `description`, `threshold`, `exam_weight`, `quiz_weight`, `homework_weight`)
						VALUES (1, 'An average exam score of 70% or greater is required to pass the class.  Quizzes and homeworks do not count toward the final score.', 0.70, 1.00, 0.00, 0.00);

INSERT INTO `#__newsletter_templates` (`editable`, `name`, `template`, `primary_title_color`, `primary_text_color`, `secondary_title_color`, `secondary_text_color`, `deleted`) VALUES (1, 'Default HTML Email Template', '<html>\n	<head>\n		<title>{{TITLE}}</title>\n	</head>\n	<body>\n		<table width=\"100%\" border=\"0\" cellspacing=\"0\">\n			<tr>\n				<td align=\"center\">\n					\n					<table width=\"700\" border=\"0\" cellpadding=\"20\" cellspacing=\"0\">\n						<tr class=\"display-browser\">\n							<td colspan=\"2\" style=\"font-size:10px;padding:0 0 5px 0;\" align=\"center\">\n								Email not displaying correctly? <a href=\"{{LINK}}\">View in a Web Browser</a>\n							</td>\n						</tr>\n						<tr>\n							<td colspan=\"2\" style=\"background:#000000;\">\n								<h1 style=\"color:#FFFFFF;\">HUB Campaign Template</h1>\n								<h3 style=\"color:#888888;\">{{TITLE}}</h3>\n							</td>\n						<tr>\n							<td width=\"500\" valign=\"top\" style=\"font-size:14px;color:#222222;border-left:1px solid #000000;\">\n								<span style=\"display:block;color:#CCCCCC;margin-bottom:20px;\">Issue {{ISSUE}}</span>\n								{{PRIMARY_STORIES}}\n							</td>\n							<td width=\"200\" valign=\"top\" style=\"font-size:12px;color:#555555;border-left:1px solid #AAAAAA;border-right:1px solid #000000;\">\n								{{SECONDARY_STORIES}}\n							</td>\n						</tr>\n						<tr>\n							<td colspan=\"2\" align=\"center\" style=\"background:#000000;color:#FFFFFF;\">\n								Copyright &copy; {{COPYRIGHT}} HUB. All Rights reserved.\n							</td>\n						</tr>\n					</table>\n				\n				</td>\n			</tr>\n		</table>\n	</body>\n</html>	', '', '', '', '', 0);
INSERT INTO `#__newsletter_templates` (`editable`, `name`, `template`, `primary_title_color`, `primary_text_color`, `secondary_title_color`, `secondary_text_color`, `deleted`) VALUES (2, 'Default Plain Text Email Template', 'View In Browser - {{LINK}}\n=====================================\n{{TITLE}} - {{ISSUE}}\n=====================================\n\n{{PRIMARY_STORIES}}\n\n--------------------------------------------------\n\n{{SECONDARY_STORIES}}\n\n--------------------------------------------------\n\nUnsubscribe - {{UNSUBSCRIBE_LINK}}\nCopyright - {{COPYRIGHT}}', NULL, NULL, NULL, NULL, 0);

INSERT INTO `#__cron_jobs` (`title`, `state`, `plugin`, `event`, `last_run`, `next_run`, `recurrence`, `created`, `created_by`, `modified`, `modified_by`, `active`, `ordering`, `params`) VALUES ('Process Newsletter Mailings', 0, 'newsletter', 'processMailings', '0000-00-00 00:00:00', '0000-00-00 00:00:00', '*/5 * * * *', '2013-06-25 08:23:04', 1001, '2013-07-16 17:15:01', 0, 0, 0, '');
INSERT INTO `#__cron_jobs` (`title`, `state`, `plugin`, `event`, `last_run`, `next_run`, `recurrence`, `created`, `created_by`, `modified`, `modified_by`, `active`, `ordering`, `params`) VALUES ('Process Newsletter Opens & Click IP Addresses', 0, 'newsletter', 'processIps', '0000-00-00 00:00:00', '0000-00-00 00:00:00', '*/5 * * * *', '2013-06-25 08:23:04', 1001, '2013-07-16 17:15:01', 0, 0, 0, '');

INSERT INTO `#__oaipmh_dcspecs` (`id`, `name`, `query`, `display`) VALUES
						(1, 'resource IDs', 'SELECT p.id FROM #__publications p, #__publication_versions pv WHERE p.id = pv.publication_id AND pv.state = 1', 1),
						(2, 'specify sets', '', 1),
						(3, 'title', 'SELECT pv.title FROM #__publication_versions pv, #__publications p WHERE p.id = pv.publication_id AND p.id = \$id LIMIT 1', 1),
						(4, 'creator', 'SELECT pa.name FROM #__publication_authors pa, #__publication_versions pv, #__publications p WHERE pa.publication_version_id = pv.id AND pv.publication_id = p.id AND p.id = \$id LIMIT 1', 1),
						(5, 'subject', 'SELECT t.raw_tag FROM #__tags t, #__tags_object tos WHERE t.id = tos.tagid AND tos.objectid = \$id ORDER BY t.raw_tag', 1),
						(6, 'date', 'SELECT pv.submitted FROM #__publication_versions pv, #__publications p WHERE p.id = pv.publication_id AND p.id = \$id ORDER BY pv.submitted LIMIT 1', 1),
						(7, 'identifier', 'SELECT pv.doi FROM #__publication_versions pv, #__publications p WHERE p.id = pv.publication_id AND pv.state = 1 AND p.id = \$id', 1),
						(8, 'description', 'SELECT pv.description FROM #__publication_versions pv, #__publications p WHERE p.id = pv.publication_id AND p.id = \$id LIMIT 1', 1),
						(9, 'type', 'Dataset', 1),
						(10, 'publisher', 'myhub', 1),
						(11, 'rights', 'SELECT pl.title FROM #__publications p, #__publication_versions pv, #__publication_licenses pl WHERE pl.id = pv.license_type AND pv.publication_id = p.id AND p.id = \$id LIMIT 1', 1),
						(12, 'contributor', 'SELECT pa.name FROM #__publication_authors pa, #__publication_versions pv, #__publications p WHERE pa.publication_version_id = pv.id AND pv.publication_id = p.id AND p.id = \$id AND pv.state = 1', 1),
						(13, 'relation', 'SELECT DISTINCT path FROM #__publication_attachments pa WHERE publication_id = \$id AND role = 1 ORDER BY path', 1),
						(14, 'format', '', 1),
						(15, 'coverage', '', 1),
						(16, 'language', '', 1),
						(17, 'source', '', 1);

