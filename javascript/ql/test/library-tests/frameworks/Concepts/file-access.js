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