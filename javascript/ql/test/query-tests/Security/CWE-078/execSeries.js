var exec = require('child_process').exec;

function asyncEach(arr, iterator) {
  var i = 0;
  (function iterate() {
    iterator(arr[i++], function () {
      if (i < arr.length)
        process.nextTick(iterate);
    });
  })();
}

function execEach(commands) {
  asyncEach(commands, (command) => exec(command)); // NOT OK 
};

require('http').createServer(function(req, res) {
  let cmd = require('url').parse(req.url, true).query.path;
  execEach([cmd]);
});
