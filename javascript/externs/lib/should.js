/*
 * Copyright 2015 Semmle Ltd.
 */


/**
 * @fileoverview A (highly incomplete) model of the should.js library.
 * @externs
 * @see http://shouldjs.github.io/
 */

/**
 * @param {*} obj
 * @returns {should.Assertion}
 */
function should(obj) {}

/**
 * @constructor
 */
should.Assertion = function() {};
should.Assertion.prototype = {
  assert: function() {},
  fail: function() {},
  get not() {},
  get any() {},
  get an() {},
  get of() {},
  get a() {},
  get and() {},
  get be() {},
  get has() {},
  get have() {},
  get with() {},
  get is() {},
  get which() {},
  get the() {},
  get it() {},
  true: function() {},
  True: function() {},
  false: function() {},
  False: function() {},
  ok: function() {},
  NaN: function() {},
  Infinity: function() {},
  within: function() {},
  approximately: function() {},
  above: function() {},
  below: function() {},
  greaterThan: function() {},
  lessThan: function() {},
  eql: function() {},
  equal: function() {},
  exactly: function() {},
  Number: function() {},
  arguments: function() {},
  Arguments: function() {},
  type: function() {},
  instanceof: function() {},
  instanceOf: function() {},
  Function: function() {},
  Object: function() {},
  String: function() {},
  Array: function() {},
  Boolean: function() {},
  Error: function() {},
  null: function() {},
  Null: function() {},
  class: function() {},
  Class: function() {},
  undefined: function() {},
  Undefined: function() {},
  iterable: function() {},
  iterator: function() {},
  generator: function() {},
  startWith: function() {},
  endWith: function() {},
  propertyWithDescriptor: function() {},
  enumerable: function() {},
  enumerables: function() {},
  property: function() {},
  properties: function() {},
  length: function() {},
  lengthOf: function() {},
  ownProperty: function() {},
  hasOwnProperty: function() {},
  empty: function() {},
  keys: function() {},
  key: function() {},
  propertyByPath: function() {},
  throw: function() {},
  throwError: function() {},
  match: function() {},
  matchEach: function() {},
  matchAny: function() {},
  matchSome: function() {},
  matchEvery: function() {},
  containEql: function() {},
  containDeepOrdered: function() {},
  containDeep: function() {}
};

/**
 * @constructor
 */
should.AssertionError = function() {};

Object.defineProperty(Object.prototype, 'should', {
  get: function() { return should(this.valueOf() || this); },
  enumerable: false,
  configurable: true
});
