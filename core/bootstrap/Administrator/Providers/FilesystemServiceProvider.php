<?php
/**
 * HUBzero CMS
 *
 * Copyright 2005-2015 HUBzero Foundation, LLC.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * HUBzero is a registered trademark of Purdue University.
 *
 * @package   hubzero-cms
 * @copyright Copyright 2005-2015 HUBzero Foundation, LLC.
 * @license   http://opensource.org/licenses/MIT MIT
 */

namespace Bootstrap\Administrator\Providers;

use Hubzero\Filesystem\Filesystem;
use Hubzero\Filesystem\Adapter\Local;
use Hubzero\Filesystem\Adapter\Ftp;
use Hubzero\Filesystem\Macro\EmptyDirectory;
use Hubzero\Filesystem\Macro\Directories;
use Hubzero\Filesystem\Macro\Files;
use Hubzero\Filesystem\Macro\DirectoryTree;
use Hubzero\Base\ServiceProvider;

/**
 * Filesystem service provider
 */
class FilesystemServiceProvider extends ServiceProvider
{
	/**
	 * Register the service provider.
	 *
	 * @return  void
	 */
	public function register()
	{
		$this->app['filesystem'] = function($app)
		{
			if ($app['config']->get('ftp_enable'))
			{
				$adapter = new Ftp(array(
					'host'     => $app['config']->get('ftp_host'),
					'port'     => $app['config']->get('ftp_port'),
					'username' => $app['config']->get('ftp_user'),
					'password' => $app['config']->get('ftp_pass'),
					'root'     => $app['config']->get('ftp_root'),
				));
			}
			else
			{
				$adapter = new Local($app['config']->get('virus_scanner', "clamscan -i --no-summary --block-encrypted"));
			}

			$filesystem = new Filesystem($adapter);
			$filesystem->addMacro(new EmptyDirectory)
			           ->addMacro(new Directories)
			           ->addMacro(new Files)
			           ->addMacro(new DirectoryTree);

			return $filesystem;
		};
	}
}
