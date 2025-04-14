(function(x){

	if ("http://evil.com/?http://good.com".match("https?://good.com")) {} // $ Alert
	if ("http://evil.com/?http://good.com".match(new RegExp("https?://good.com"))) {} // $ Alert
	if ("http://evil.com/?http://good.com".match("^https?://good.com")) {} // $ Alert - missing post-anchor
	if ("http://evil.com/?http://good.com".match(/^https?:\/\/good.com/)) {} // $ Alert - missing post-anchor
	if ("http://evil.com/?http://good.com".match("(^https?://good1.com)|(^https?://good2.com)")) {} // $ Alert - missing post-anchor
	if ("http://evil.com/?http://good.com".match("(https?://good.com)|(^https?://goodie.com)")) {} // $ Alert - missing post-anchor

	/https?:\/\/good.com/.exec("http://evil.com/?http://good.com"); // $ Alert
	new RegExp("https?://good.com").exec("http://evil.com/?http://good.com"); // $ Alert

	if ("http://evil.com/?http://good.com".search("https?://good.com") > -1) {} // $ Alert

	new RegExp("https?://good.com").test("http://evil.com/?http://good.com"); // $ Alert

	if ("something".match("other")) {}
	if ("something".match("x.commissary")) {}
	if ("http://evil.com/?http://good.com".match("https?://good.com")) {} // $ Alert
	if ("http://evil.com/?http://good.com".match("https?://good.com:8080")) {} // $ Alert

	let trustedUrls = [
		"https?://good.com", // $ Alert - referenced below
		/https?:\/\/good.com/, // $ Alert - referenced below
		new RegExp("https?://good.com"), // $ Alert - referenced below
		"^https?://good.com" // $ Alert - missing post-anchor
	];
	function isTrustedUrl(url) {
		for (let trustedUrl of trustedUrls) {
			if (url.match(trustedUrl)) return true;
		}
		return false;
	}

	/https?:\/\/good.com\/([0-9]+)/.exec(url); // $ Alert
	"https://verygood.com/?id=" + /https?:\/\/good.com\/([0-9]+)/.exec(url)[0];
	"http" + (secure? "s": "") + "://" + "verygood.com/?id=" + /https?:\/\/good.com\/([0-9]+)/.exec(url)[0];
	"http" + (secure? "s": "") + "://" + ("verygood.com/?id=" + /https?:\/\/good.com\/([0-9]+)/.exec(url)[0]);

	// g or .replace?
	file = file.replace(
		/https:\/\/cdn\.ampproject\.org\/v0\/amp-story-0\.1\.js/g,
		hostName + '/dist/v0/amp-story-1.0.max.js'
	);

	// missing context of use
	const urlPatterns  = [
		{
			regex: /youtube.com\/embed\/([a-z0-9\?&=\-_]+)/i,
			type: 'iframe', w: 560, h: 314,
			url: '//www.youtube.com/embed/$1',
			allowFullscreen: true
		}];

	// ditto
	F.helpers.media = {
		defaults : {
			youtube : {
				matcher : /(youtube\.com|youtu\.be)\/(watch\?v=|v\/|u\/|embed\/?)?(videoseries\?list=(.*)|[\w-]{11}|\?listType=(.*)&list=(.*)).*/i,
				params  : {
					autoplay    : 1,
					autohide    : 1,
					fs          : 1,
					rel         : 0,
					hd          : 1,
					wmode       : 'opaque',
					enablejsapi : 1
				},
				type : 'iframe',
				url  : '//www.youtube.com/embed/$3'
			}}}

	// ditto
	var urlPatterns = [
		{regex: /youtu\.be\/([\w\-.]+)/, type: 'iframe', w: 425, h: 350, url: '//www.youtube.com/embed/$1'},
		{regex: /youtube\.com(.+)v=([^&]+)/, type: 'iframe', w: 425, h: 350, url: '//www.youtube.com/embed/$2'},
		{regex: /vimeo\.com\/([0-9]+)/, type: 'iframe', w: 425, h: 350, url: '//player.vimeo.com/video/$1?title=0&byline=0&portrait=0&color=8dc7dc'}, // $ Alert
	];

	// check optional successsor to TLD
	new RegExp("(Pingdom.com_bot_version_)(\\d+)\\.(\\d+)")

	// replace and spaces
	error.replace(/See https:\/\/github\.com\/Squirrel\/Squirrel\.Mac\/issues\/182 for more information/, 'See [this link](https://github.com/Microsoft/vscode/issues/7426#issuecomment-425093469) for more information');

	// not a url
	var sharedScript = /<script\s.*src="(app:\/\/.+\.gaiamobile\.org)?\/?(shared\/.+)".*>/;

	// replace
	const repo = repoURL.replace(/http(s)?:\/\/(\d+\.)?github.com\//gi, '')

	// replace and space
	cmp.replace(/<option value="http:\/\/codemirror.net\/">HEAD<\/option>/,
	            "<option value=\"http://codemirror.net/\">HEAD</option>\n        <option value=\"http://marijnhaverbeke.nl/git/codemirror?a=blob_plain;hb=" + number + ";f=\">" + number + "</option>");

	// replace and space
	const helpMsg = /For help see https:\/\/nodejs.org\/en\/docs\/inspector\s*/;
	msg = msg.replace(helpMsg, '');

	// not a url
	pkg.source.match(/<a:skin.*?\s+xmlns:a="http:\/\/ajax.org\/2005\/aml"/m)

	// replace
	path.replace(/engine.io/, "$&-client");

	/\.com|\.org/; // OK - has no domain name
	/example\.com|whatever/; // OK - the other disjunction doesn't match a hostname

	// MatchAll test cases:
	// Vulnerable patterns
	if ("http://evil.com/?http://good.com".matchAll("https?://good.com")) {} // $ Alert
	if ("http://evil.com/?http://good.com".matchAll(new RegExp("https?://good.com"))) {} // $ Alert
	if ("http://evil.com/?http://good.com".matchAll("^https?://good.com")) {} // $ Alert - missing post-anchor
	if ("http://evil.com/?http://good.com".matchAll(/^https?:\/\/good.com/g)) {} // $ Alert - missing post-anchor
	if ("http://evil.com/?http://good.com".matchAll("(^https?://good1.com)|(^https?://good2.com)")) {} // $ Alert - missing post-anchor
	if ("http://evil.com/?http://good.com".matchAll("(https?://good.com)|(^https?://goodie.com)")) {} // $ Alert - missing post-anchor
	if ("http://evil.com/?http://good.com".matchAll("good.com")) {} // $ Alert - missing protocol
	if ("http://evil.com/?http://good.com".matchAll("https?://good.com")) {} // $ Alert
	if ("http://evil.com/?http://good.com".matchAll("https?://good.com:8080")) {} // $ Alert

	// Non-vulnerable patterns
	if ("something".matchAll("other")) {}
	if ("something".matchAll("x.commissary")) {}
	if ("http://evil.com/?http://good.com".matchAll("^https?://good.com$")) {}
	if ("http://evil.com/?http://good.com".matchAll(new RegExp("^https?://good.com$"))) {}
	if ("http://evil.com/?http://good.com".matchAll("^https?://good.com/$")) {}
	if ("http://evil.com/?http://good.com".matchAll(/^https?:\/\/good.com\/$/)) {}
	if ("http://evil.com/?http://good.com".matchAll("(^https?://good1.com$)|(^https?://good2.com$)")) {}
	if ("http://evil.com/?http://good.com".matchAll("(https?://good.com$)|(^https?://goodie.com$)")) {}

});
