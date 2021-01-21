var http = require("http");

new Promise(function(resolvePromise, rejectPromise) {
  function rejectIndirect(value) {
    rejectPromise(value);
  }

  http.request({}, function(stream) {
    stream.on("data", d => resolvePromise("silly")); // NOT OK

    stream.on("data", d => rejectPromise("silly")); // NOT OK

    stream.on("data", d => rejectIndirect("silly")); // NOT OK

    stream.on(
      "error",
      e => rejectIndirect(e) // OK
    );

    stream.on(
      "end",
      e => resolvePromise(e) // OK
    );
  });

  http.request({}, function(stream) {
    stream.on("data", d => {
      // OK
      stream.destroy();
      resolvePromise("silly");
    });
  });

  http.request({}, function(stream) {
    stream.on("data", d => resolvePromise("silly")); // OK [INCONSISTENCY]: the other data handler closes the stream
    stream.on("data", d => {
      // OK
      stream.destroy();
      resolvePromise("silly");
    });
  });
  http.request({}, function(stream) {
    stream.on("data", d => resolvePromise("silly")); // OK [INCONSISTENCY]: the stream is closed automatically
    setTimeout(100, () => stream.destroy());
  });
});
