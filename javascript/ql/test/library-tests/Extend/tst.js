// Runnable test to check that packages are modelled correctly.

let util = require('util');

function base() {
  return {x: {y: 1}};
}
function arg() {
  return {x: {z: 1}};
}
function checkShallow(result) {
  if (result.x.y === 1 && result.x.z === 1) {
    throw new Error("Merge was not shallow");
  }
}
function checkDeep(result) {
  if (result.x.y !== 1 || result.x.z !== 1) {
    throw new Error("Merge was not deep");
  }
}

// Deep if flag is given

let extend = require('extend');
let extend2 = require('extend2');
let justExtend = require('just-extend');
let nodeExtend = require('node.extend');

checkShallow(extend(base(), arg()));
checkShallow(extend2(base(), arg()));
checkShallow(justExtend(base(), arg()));
checkShallow(nodeExtend(base(), arg()));

checkDeep(extend(true, base(), arg()));
checkDeep(extend2(true, base(), arg()));
checkDeep(justExtend(true, base(), arg()));
checkDeep(nodeExtend(true, base(), arg()));

// Always deep

checkDeep(require("deep").extend(base(), arg()));
checkDeep(require("deep-assign")(base(), arg()));
checkDeep(require("deep-extend")(base(), arg()));
checkDeep(require("deep-merge")((x,y)=>y)(base(), arg()));
checkDeep(require("deepmerge")(base(), arg()));
checkDeep(require("defaults-deep")(base(), arg()));
checkDeep(require("js-extend").extend(base(), arg()));
checkDeep(require("merge").recursive(base(), arg()));
checkDeep(require("merge-deep")(base(), arg()));
checkDeep(require("merge-options")(base(), arg()));
checkDeep(require("mixin-deep")(base(), arg()));
checkDeep(require("ramda").mergeDeepLeft(base(), arg()));
checkDeep(require("ramda").mergeDeepRight(base(), arg()));
checkDeep(require("smart-extend").deep(base(), arg()));
checkDeep(require("lodash").merge(base(), arg()));
checkDeep(require("lodash").mergeWith(base(), arg()));
checkDeep(require("lodash").defaultsDeep(base(), arg()));
checkDeep(require("lodash.mergewith")(base(), arg()));
checkDeep(require("lodash.defaultsdeep")(base(), arg()));

// Always shallow

checkShallow(Object.assign(base(), arg()));
checkShallow(require("defaults")(base(), arg()));
checkShallow(require("extend-shallow")(base(), arg()));
checkShallow(require("merge")(base(), arg()));
checkShallow(require("mixin-object")(base(), arg()));
checkShallow(require("object-assign")(base(), arg()));
checkShallow(require("object.assign")(base(), arg()));
checkShallow(require("object.defaults")(base(), arg()));
checkShallow(require("smart-extend")(base(), arg()));
checkShallow(require("util-extend")(base(), arg()));
checkShallow(require("utils-merge")(base(), arg()));
checkShallow(require("xtend/mutable")(base(), arg()));
checkShallow(require('lodash').extend(base(), arg()));

// Functional shallow

checkShallow(require("xtend")(base(), arg()));
checkShallow(require("xtend/immutable")(base(), arg()));
checkShallow(require("ramda").merge(base(), arg()));

// webpack-merge. deep. 
const webpackMerge = require('webpack-merge');
checkDeep(webpackMerge.merge(base(), arg()));
checkDeep(webpackMerge.mergeWithCustomize({})(base(), arg()));
