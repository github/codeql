var mod = require('mod');

mod.moduleMethod();

var f = mod.moduleFunction;
f();

var K = mod.constructorFunction;
new K();

mod.moduleField;

mod();

new mod();
