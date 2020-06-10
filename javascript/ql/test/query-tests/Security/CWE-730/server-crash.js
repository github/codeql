const express = require("express");
const app = express();
const fs = require("fs");

function indirection1() {
  fs.readFile("/WHATEVER", (err, x) => {
    throw err; // NOT OK
  });
}
function indirection2() {
  throw 42; // NOT OK
}
function indirection3() {
  try {
    fs.readFile("/WHATEVER", (err, x) => {
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
  fs.readFile("/WHATEVER", (err, x) => {
    throw err; // NOT OK
  });
}
app.get("/async-throw", (req, res) => {
  fs.readFile("/WHATEVER", (err, x) => {
    throw err; // NOT OK
  });
  fs.readFile("/WHATEVER", (err, x) => {
    try {
      throw err; // OK: guarded throw
    } catch (e) {}
  });
  fs.readFile("/WHATEVER", (err, x) => {
    res.setHeader("reflected", req.query.header); // NOT OK
  });
  fs.readFile("/WHATEVER", (err, x) => {
    try {
      res.setHeader("reflected", req.query.header); // OK: guarded call
    } catch (e) {}
  });

  indirection1();
  fs.readFile("/WHATEVER", (err, x) => {
    indirection2();
  });

  indirection3();
  try {
    indirection4();
  } catch (e) {}
  indirection5();

  fs.readFile("/WHATEVER", (err, x) => {
    req.query.foo; // OK
  });
  fs.readFile("/WHATEVER", (err, x) => {
    req.query.foo.toString(); // OK
  });

  fs.readFile("/WHATEVER", (err, x) => {
    req.query.foo.bar; // NOT OK
  });
  fs.readFile("/WHATEVER", (err, x) => {
    res.setHeader("reflected", unknown); // OK
  });
});
