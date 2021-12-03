var cond = Math.random() > 0.5;
var mod1, mod2;

if (cond) {
  mod1 = require('./b');
  mod2 = mod1;
} else {
  mod1 = require('./c');
  mod2 = require('./b');
}

if (cond) {
  mod1.call();  // OK: `mod1` is `./b`, which exports `call`
} else {
  mod1.bar;     // OK: `mod1` is `./c`, which exports `bar`
  mod2.bar;     // NOT OK: `mod2` is `./b`, which does not export `call`
}

module.exports = {};