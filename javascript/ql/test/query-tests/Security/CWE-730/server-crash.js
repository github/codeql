const express = require("express");
const app = express();
const fs = require("fs");
const EventEmitter = require("events");
const http = require("http");

const port = 12000;
let server = app.listen(port, () =>
  // for manual testing of the fickle node.js runtime
  console.log(`Example app listening on port ${port}!`)
);

function indirection1() {
  fs.readFile("/foo", (err, x) => {
    throw err; // NOT OK
  });
}
function indirection2() {
  throw 42; // NOT OK
}
function indirection3() {
  try {
    fs.readFile("/foo", (err, x) => {
      throw err; // NOT OK
    });
  } catch (e) {}
}
function indirection4() {
  throw 42; // OK: guarded caller
}
function indirection5() {
  indirection6();
}
function indirection6() {
  fs.readFile("/foo", (err, x) => {
    throw err; // NOT OK
  });
}
app.get("/async-throw", (req, res) => {
  fs.readFile("/foo", (err, x) => {
    throw err; // NOT OK
  });
  fs.readFile("/foo", (err, x) => {
    try {
      throw err; // OK: guarded throw
    } catch (e) {}
  });
  fs.readFile("/foo", (err, x) => {
    res.setHeader("reflected", req.query.header); // NOT OK [INCONSISTENCY]
  });
  fs.readFile("/foo", (err, x) => {
    try {
      res.setHeader("reflected", req.query.header); // OK: guarded call
    } catch (e) {}
  });

  indirection1();
  fs.readFile("/foo", (err, x) => {
    indirection2();
  });

  indirection3();
  try {
    indirection4();
  } catch (e) {}
  indirection5();

  fs.readFile("/foo", (err, x) => {
    req.query.foo; // OK
  });
  fs.readFile("/foo", (err, x) => {
    req.query.foo.toString(); // OK
  });

  fs.readFile("/foo", (err, x) => {
    req.query.foo.bar; // NOT OK [INCONSISTENCY]: need to add property reads as sinks
  });
  fs.readFile("/foo", (err, x) => {
    res.setHeader("reflected", unknown); // OK
  });

  try {
    indirection7();
  } catch (e) {}
});
function indirection7() {
  fs.readFile("/foo", (err, x) => {
    throw err; // NOT OK
  });
}

app.get("/async-throw-again", (req, res) => {
  fs.readFile("foo", () => {
    throw "e"; // NOT OK
  });
  fs.readFileSync("foo", () => {
    throw "e"; // OK (does not take callbacks at all)
  });
  // can nest async calls (and only warns about the inner one)
  fs.readFile("foo", () => {
    fs.readFile("bar", () => {
      throw "e"; // NOT OK
    });
  });
  fs.readFile("foo", () => {
    // can not catch async exceptions
    try {
      fs.readFile("bar", () => {
        throw "e"; // NOT OK
      });
    } catch (e) {}
  });
  // can mix sync/async calls
  fs.readFile("foo", () => {
    (() =>
      fs.readFile("bar", () => {
        throw "e"; // NOT OK
      }))();
  });
});

app.get("/throw-in-promise-1", async (req, res) => {
  async function fun() {
    throw new Error(); // OK, requires `node --unhandled-rejections=strict ...` to terminate the process
  }
  await fun();
});
app.get("/throw-in-promise-2", async (req, res) => {
  async function fun() {
    fs.readFile("/foo", (err, x) => {
      throw err; // NOT OK
    });
  }
  await fun();
});
app.get("/throw-in-promise-3", async (req, res) => {
  fs.readFile("/foo", async (err, x) => {
    throw err; // OK, requires `node --unhandled-rejections=strict ...` to terminate the process
  });
});

app.get("/throw-in-event-emitter", async (req, res) => {
  class MyEmitter extends EventEmitter {}
  const myEmitter = new MyEmitter();
  myEmitter.on("event", () => {
    throw new Error(); // OK, requires `node --unhandled-rejections=strict ...` to terminate the process
  });
  myEmitter.emit("event");
});

app.get("/throw-with-ambiguous-paths", (req, res) => {
  function throwError() {
    throw new Error(); // NOT OK
  }

  function cb() {
    throwError(); // on path
  }
  function withAsync() {
    throwError(); // not on path
    fs.stat(X, cb);
  }

  throwError(); // not on path
  withAsync();
});
