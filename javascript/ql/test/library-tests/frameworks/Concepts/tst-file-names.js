let walkSync = require('walk-sync'),
    walk = require('walk'),
    glob = require('glob'),
    globby = require('globby'),
    fastGlob = require('fast-glob');

walkSync();

walk.walk(_).on(_,  (_, stats) => stats.name); // XXX

glob.sync(_);

glob(_, (e, name) => name);

new glob.Glob(_, (e, name) => name);

new glob.Glob(_).found;

globby.sync(_);

globby(_).then(files => files)

fastGlob.sync(_);

fastGlob(_).then(files => files);

fastGlob.async(_).then(files => files);

fastGlob.stream(_).on(_,  file => file); // XXX

async function foo() {
  globby(_).catch(() => {}).then(files => files);

  var files = await globby(_);

  var files2 = await fastGlob.async(_);

  var files2 = await fastGlob.async(_).catch((wat) => {});
}

var globule = require('globule');
var filepaths = globule.find('**/*.js');
var matches = globule.match('**/*.js', ["foo.js"])
var bool = globule.isMatch('**/*.js', ["foo.js"])
var map1 = globule.findMapping("foo/*.js")
var map2 = globule.mapping({src: ["a.js", "b.js"]})
var map3 = globule.mapping(["foo/a.js", "foo/b.js"])

async function bar() {
  var foo = globby(_);
  var files = await foo;
}