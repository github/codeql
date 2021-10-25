goog.module('test.importer');

let globalModule = goog.require('x.y.z.global');
let globalModuleDefault = goog.require('x.y.z.globaldefault');

let es6Module = goog.require('x.y.z.es6');
let es6ModuleDefault = goog.require('x.y.z.es6default');

let googModule = goog.require('x.y.z.goog');
let googModuleDefault = goog.require('x.y.z.googdefault');

globalModule.fun();
globalModuleDefault();

es6Module.fun();
es6ModuleDefault();

googModule.fun();
googModuleDefault();
