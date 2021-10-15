const js_cookie = require('js-cookie'),
      browser_cookies = require('browser-cookies'),
      cookie = require('cookie');

(function() {
	js_cookie.set('key', 'value');
	js_cookie.get('key');
});

(function() {
	browser_cookies.set('key', 'value');
	browser_cookies.get('key');
});


(function() {
	cookie.serialize('key', 'value');
	cookie.parse()['key'];
});
