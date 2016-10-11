commands.addUserCommand(['ClearCache'], 'Clear the cache',
function(){
	// via WebDeveloper.Overlay.Miscellaneous.clearCache
	// <https://github.com/chrispederick/web-developer/blob/2fee3009976512bbe5fbf0660844733cebd3e1bd/source/firefox/javascript/overlay/miscellaneous.js#L47>
	var cacheInterface = Components.interfaces.nsICache;
	var cacheService = Components.classes["@mozilla.org/network/cache-service;1"].getService(Components.interfaces.nsICacheService);
	cacheService.evictEntries(cacheInterface.STORE_ANYWHERE);
});

