let walkSync = require('walkSync'),
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
