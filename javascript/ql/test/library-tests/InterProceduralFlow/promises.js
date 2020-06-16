(function () {
  var source = "tainted";
  var promise = new Promise(function (resolve, reject) {
    resolve(source);
  });
  promise.then(function (val) {
    var sink = val;
  });

  var promise2 = new Promise((res, rej) => {
    var res_source = "resolved";
    var rej_source = "rejected";
    if (Math.random() > .5)
      res(res_source);
    else
      rej(rej_source);
  });
  promise2.then((v) => {
    var res_sink = v;
  }, (v) => {
    var rej_sink = v;
  });
  promise2.catch((v) => {
    var rej_sink = v;
  });
  promise2.finally((v) => { // no promise implementation sends an argument to the finally handler. So there is no data-flow here. 
    var sink = v;
  });

  sourceThisPromise(promise);

  var another_source = "also tainted";
  sourceThisPromise(Promise.resolve(another_source));
})();

function sourceThisPromise(p) {
  p.then((v) => {
    var interprocedural_sink = v;
  });
}
