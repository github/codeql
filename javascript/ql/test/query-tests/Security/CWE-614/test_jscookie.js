const js_cookie = require('js-cookie')
js_cookie.set('key', 'value', { secure: false }); // NOT OK
js_cookie.set('key', 'value', { secure: true }); // OK
