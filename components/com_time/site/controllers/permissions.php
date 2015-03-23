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
 * @author    Sam Wilson <samwilson@purdue.edu
 * @copyright Copyright 2005-2011 Purdue University. All rights reserved.
 * @license   http://www.gnu.org/licenses/lgpl-3.0.html LGPLv3
 */

namespace Components\Time\Site\Controllers;

/**
 * Permissions controller for time component
 */
class Permissions extends Base
{
	/**
	 * Default view function
	 *
	 * @return void
	 */
	public function displayTask()
	{
		// Get scope
		$this->view->scope    = \JRequest::getWord('scope', 'Hub');
		$this->view->scope_id = \JRequest::getInt('scope_id', 0);

		// Get permissions
		$access = new \JForm('permissions');
		$access->loadFile(dirname(dirname(__DIR__)) . DS . 'models' . DS . 'forms' . DS . 'permissions.xml');

		// Bind existing rules if applicable
		$asset = new \JTableAsset($this->database);
		$name  = 'com_time.' . strtolower($this->view->scope) . '.' . $this->view->scope_id;
		$asset->loadByName($name);

		if ($asset->get('id'))
		{
			$access->setValue('asset_id', null, $asset->get('id'));
		}

		$this->view->permissions = $access->getField(strtolower($this->view->scope));

		// Display
		$this->view->display();
	}

	/**
	 * Save permissions to asset
	 *
	 * @return void
	 */
	public function saveTask()
	{
		$scope    = \JRequest::getWord('scope', false);
		$scope_id = \JRequest::getInt('scope_id', false);

		if (!$scope || !$scope_id)
		{
			echo json_encode(array('success'=>false));
			exit();
		}

		// Process Rules
		$data  = \JRequest::getVar(strtolower($scope));
		$rules = array();

		if ($data && count($data) > 0)
		{
			foreach ($data as $rule => $parts)
			{
				if ($parts && count($parts) > 0)
				{
					foreach ($parts as $group => $perms)
					{
						if ($perms == '')
						{
							continue;
						}

						$rules[$rule][$group] = $perms;
					}
				}
			}
		}

		$class = 'Components\Time\Models\\' . $scope;
		$model = $class::oneOrFail($scope_id);
		$model->assetRules = new \JAccessRules($rules);
		$model->save();

		echo json_encode(array('success'=>true));
		exit();
	}
}