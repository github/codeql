require('baz'); // OK: declared in ../../package.json (though not in ./package.json)
require('mod'); // OK: found in ../node_modules/mod