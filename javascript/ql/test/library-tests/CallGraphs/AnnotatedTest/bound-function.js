var url = require('url')
var http = require('http')

function Mount () {}

/** name:mount.serve */
Mount.prototype.serve = function (x) {
}

function makeMount() {
  var m = new Mount()
  return m.serve.bind(m);
}

function makeMount2(x) {
  var m = new Mount()
  return m.serve.bind(m, x);
}

var mount = makeMount()
var mount2 = makeMount2(null);

http.createServer(function (req, res) {
  /** calls:mount.serve */
  /** boundArgs:0 */
  mount(req, res)

  /** calls:mount.serve */
  /** boundArgs:1 */
  mount2(res)
});
