/**
 * @package     hubzero-cms
 * @file        plugins/resources/favorite/favorite.js
 * @copyright   Copyright 2005-2011 Purdue University. All rights reserved.
 * @license     http://www.gnu.org/licenses/lgpl-3.0.html LGPLv3
 */

//-----------------------------------------------------------
//  Ensure we have our namespace
//-----------------------------------------------------------
if (!HUB) {
	var HUB = {};
}
if (!HUB.Plugins) {
	HUB.Plugins = {};
}

//----------------------------------------------------------
// Adding a publication as favorite
//----------------------------------------------------------
HUB.Plugins.PublicationFavorite = {
	initialize: function() {
		// Add to favorites
		var fav = $('fav-this');
		if (fav) {
			fav.addEvent('click', function(e) {
				new Event(e).stop();
				
				var rid = $('rid').value;
				new Ajax('index.php?option=com_resources&task=plugin&trigger=onPublicationsFavorite&no_html=1&rid='+rid,{
					method : 'get',
					update : $('fav-this'),
					onSuccess : function() {
						if (fav.hasClass('faved')) {
						fav.removeClass('faved');
							var img = '/components/com_publications/assets/img/broken-heart.gif';
							var txt = 'Favorite removed.';
						} else {
							fav.addClass('faved');
							var img = '/components/com_publications/assets/img/heart.gif';
							var txt = 'Favorite saved.';
						}
						if (typeof(Growl) != "undefined") {
							Growl.Bezel({
								image: img,
								title: txt,
								text: ''
							});
						}
					}
				}).request();
			});
		}
	} // end initialize
}

window.addEvent('domready', HUB.Plugins.PublicationFavorite.initialize);
