let lazy = require('lazy-cache')(require);

lazy('foo');
let bar = lazy('bar');
lazy('baz-baz', 'BAZ');

lazy.foo();

bar();
lazy.bar();

lazy.BAZ();
