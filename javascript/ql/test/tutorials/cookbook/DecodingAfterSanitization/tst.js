const he = require('he');

decodeURI(escapeHtml(x));
decodeURIComponent(escapeHtml(x));

JSON.parse(he.encode(x));
