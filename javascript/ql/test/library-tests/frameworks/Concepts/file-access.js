var fstream = require("fstream");

fstream
  .Writer({ path: "path/to/file"})
  .write("hello\n")
  .end()

fstream
  .Reader("path/to/dir")
  .pipe(fstream.Writer("path/to/other/dir"))


var writeFileAtomic= require("write-file-atomic");

writeFileAtomic('atmoic.txt', 'Data', {}, function (err) {});

var writeFileAtomicSync = require('write-file-atomic').sync
writeFileAtomicSync("syncFile.txt", "More data", [options])

var recursive = require("recursive-readdir");
 
recursive("some/path", function (err, files) {});

const jsonfile = require('jsonfile');
jsonfile.readFile('/tmp/data.json', function (err, obj) {});
jsonfile.readFileSync('/tmp/data.json');

jsonfile.writeFile('/tmp/data.json', obj, function (err) {});
jsonfile.writeFileSync('/tmp/data.json', obj);


const pathExists = require('path-exists');
 
if(pathExists('foo.js')) {
	// do something.
}

var rimraf = require("rimraf");
rimraf("/", {}, (err) => {});

var dir = require("node-dir");
dir.readFiles("/some/directory",function() {},function(){});

var vfs = require("vinyl-fs");
 
vfs.src(["some", "path"]);
vfs.dest('./', { sourcemaps: true });


var ncp = require('ncp').ncp;
ncp("from", "to", function (err) {});


const loadJsonFile = require('load-json-file');
(async () => {
    console.log(await loadJsonFile('foo.json'));
	console.log(loadJsonFile.sync('foo.json'));
})();

const writeJsonFile = require('write-json-file');
 (async () => {
    writeJsonFile('bar.json', {bar: true});
	writeJsonFile.sync('bar.json', {bar: false}, {indent: " "})
})();

var readdirp = require("readdirp");
readdirp('.', {fileFilter: '*.js'}).on('data', (entry) => { /* stream and promise api not modelled yet */ })

var recursive = require("recursive-readdir");
recursive("directory/to/read", function (err, files) {
  console.log(files);
});
recursive("directory/to/read").then(files2 => console.log(files2));

jsonfile.readFile('baz.json').then(obj => console.log(obj))

(async function () {
	var walk = require('walkdir');
	walk('../', function(path, stat) {
	  console.log('found: ', path);
	});
	var emitter = walk('../');
	emitter.on('file', function(filename, stat) { });
	walk.sync('../', function(path, stat) {
	  console.log('found sync:', path);
	});
	var paths = walk.sync('../');
	let result = await walk.async('../')
})();

var walker = require("walker");
walker('/etc/').filterDir(() => {}).on('entry', () => {}); // only file access modelled.
