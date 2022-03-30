(function(_window) {
  if (_window)
    setupNode();

  function parse() {
    return uuid;
  }

  var uuid = parse;
  uuid.v1 = v1;
})();

(function() {
  var x;
  if (x !== undefined)
    x.p;
})();

(function() {
    var v0
    for({ v0 } of o) {
        v0.p;
    }

    var v1;
    for({ v1 = x } of o) {
        v1.p;
    }
});

(function(){
    function a(){return null;} a(1)[0];
});
