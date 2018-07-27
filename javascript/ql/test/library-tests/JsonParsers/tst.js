let fs = require('fs'); // mark as node.js module

function checkJSON(value) {
	if (value !== 'JSON string') {
		throw new Error('Not the JSON output: ' + value);
	}
}

let input = '"JSON string"';

checkJSON(JSON.parse(input));
checkJSON(require('parse-json')(input));
checkJSON(require('json-parse-better-errors')(input));
checkJSON(require('json-safe-parse')(input));

checkJSON(require('safe-json-parse/tuple')(input)[1]);
checkJSON(require('safe-json-parse/result')(input).v);
checkJSON(require('fast-json-parse')(input).value);
checkJSON(require('json-parse-safe')(input).value);

require('safe-json-parse/callback')(input, (err, result) => checkJSON(result));
