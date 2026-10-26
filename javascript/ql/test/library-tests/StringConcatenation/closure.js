goog.module('test');

let build = goog.require('goog.string.buildString');

build('one', 'two' + 'three', 'four') + 'five';
