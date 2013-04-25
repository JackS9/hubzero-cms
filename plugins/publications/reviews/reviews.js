/**
 * @package     hubzero-cms
 * @file        plugins/resources/reviews/reviews.js
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
// Publication reviews
//----------------------------------------------------------
HUB.Plugins.PublicationReviews = {
	initialize: function() {
		// Reply to review or comment
		var show = $$('.reply');
		if (show) {
			show.each(function(item) {
				item.addEvent('click', function(e) {
					new Event(e).stop();
					
					var f = $(this.parentNode.parentNode).getElement('.addcomment');
					if (f.hasClass('hide')) {
						f.removeClass('hide');
					} else {
						f.addClass('hide');
					}
				});
			});
			if ($$('.commentarea')) {
				$$('.commentarea').each(function(item) {
					// Clear the default text
					item.addEvent('focus', function() {
						if (item.value == 'Enter your comments...') {
							item.value = '';
						}
					});
				});
			}
			if ($$('.cancelreply')) {
				$$('.cancelreply').each(function(item) {
					item.addEvent('click', function(e) {
						new Event(e).stop();
						$(item.parentNode.parentNode.parentNode.parentNode).addClass('hide');
					});
				});
			}
		}
		
		// review ratings
		$$('.thumbsvote').each(function(v) {
			v.addEvent('mouseover', function() {
				var el = this.getLast();
				var el = el.getLast();
				el.style.display = "inline";
			});
			v.addEvent('mouseout', function() {
				var el = this.getLast();
				var el = el.getLast();
				el.style.display = "none";
			});
		});
		
		var vote = $$('.revvote');
		if (vote) {
			for (i = 0; i < vote.length; i++) 
			{
				vote[i].onclick=function() {
					pn = $(this.parentNode.parentNode.parentNode);
					if ($(this.parentNode).hasClass('gooditem')) {
						var s = 'yes';
					} else {
						var s = 'no';
					}
				
					var id = $(this.parentNode.parentNode.parentNode).getProperty('id').replace('reviews_','');
	
					var rid = $(this.parentNode.parentNode).getProperty('id').replace('rev'+id+'_','');	

					new Ajax('/index.php?option=com_publications&task=plugin&trigger=onPublicationRateItem&action=rateitem&no_html=1&rid='+id+'&refid='+id+'&ajax=1&vote='+s,{
						'method' : 'get',
						'update' : $(pn)
					}).request();				
				}
			}
		}
	} // end initialize
}

window.addEvent('domready', HUB.Plugins.PublicationReviews.initialize);
