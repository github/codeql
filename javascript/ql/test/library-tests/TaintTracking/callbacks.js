import * as dummy from 'dummy'; // treat as module

function provideTaint(cb) {
  cb(source());
  cb(source());
}

function provideTaint2(cb) {
  provideTaint(cb);
  provideTaint(cb); // suppress precision gains from functions with unique call site
}

function forwardTaint(x, cb) {
  cb(x);
  cb(x);
}

function forwardTaint2(x, cb) {
  forwardTaint(x, cb);
  forwardTaint(x, cb);
}

function middleSource(cb) {
  // The source occurs in-between the callback definition and the callback invocation.
  forwardTaint(source(), cb);
}

function middleCallback(x) {
  // The callback definition occurs in-between the source and the callback invocation.
  forwardTaint(x, y => sink(y)); // NOT OK
}

function test() {
  provideTaint2(x => sink(x)); // NOT OK
  provideTaint2(x => sink(x)); // NOT OK

  forwardTaint2(source(), x => sink(x)); // NOT OK
  forwardTaint2("safe", x => sink(x)); // OK [INCONSISTENCY]

  function helper1(x) {
    sink(x); // NOT OK
    return x;
  }
  forwardTaint2(source(), helper1);
  sink(helper1("safe")); // OK

  middleSource(x => sink(x)); // NOT OK
  middleSource(x => sink(x)); // NOT OK

  middleCallback(source());
  middleCallback(source());

  let capturedTaint = source();
  function helper2(cb) {
    cb(capturedTaint);
  }
  helper2(x => {
    sink(x); // NOT OK
  });
}

function forwardTaint3(x, cb) {
  cb(x); // Same as 'forwardTaint' but copied to avoid interference between tests
  cb(x);
}

function forwardTaint4(x, cb) {
  forwardTaint3(x, cb); // Same as 'forwardTaint2' but copied to avoid interference between tests
  forwardTaint3(x, cb);
}

function test2() {
  forwardTaint4(source(), x => sink(x)); // NOT OK
  forwardTaint4("safe", x => sink(x)); // OK
}
