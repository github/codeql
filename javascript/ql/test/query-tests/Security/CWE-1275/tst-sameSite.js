import * as Cookies from "es-cookie";

function esCookies() {
  Cookies.set("authkey", "value", {
    secure: true,
    httpOnly: true,
    sameSite: "None",
  }); // $ Alert

  Cookies.set("authkey", "value", {
    secure: true,
    httpOnly: true,
    sameSite: "Strict",
  });
}

function browserCookies() {
  var cookies = require("browser-cookies");

  cookies.set("authkey", "value", {
    expires: 365,
    secure: true,
    httponly: true,
    samesite: "None",
  }); // $ Alert

  cookies.set("authkey", "value", {
    expires: 365,
    secure: true,
    httponly: true,
    samesite: "Strict",
  });
}

function cookie() {
  var cookie = require("cookie");

  var setCookie = cookie.serialize("authkey", "value", {
    maxAge: 9000000000,
    httpOnly: true,
    secure: true,
    sameSite: "None",
  }); // $ Alert

  var setCookie = cookie.serialize("authkey", "value", {
    maxAge: 9000000000,
    httpOnly: true,
    secure: true,
    sameSite: true,
  });
}

const express = require("express");
const app = express();
const session = require("cookie-session");

app.get("/a", function (req, res, next) {
  res.cookie("authkey", "value", {
    maxAge: 9000000000,
    httpOnly: true,
    secure: true,
    sameSite: "None",
  }); // $ Alert

  res.cookie("session", "value", {
    maxAge: 9000000000,
    httpOnly: true,
    secure: true,
    sameSite: "Strict",
  });

  res.end("ok");
});

app.use(
  session({
    name: "session",
    keys: ["key1", "key2"],
    httpOnly: true,
    secure: true,
    sameSite: "None",
  }) // $ Alert
);

app.use(
  session({
    name: "session",
    keys: ["key1", "key2"],
    httpOnly: true,
    secure: true,
    sameSite: "Strict",
  })
);

const expressSession = require("express-session");

app.use(
  expressSession({
    name: "session",
    keys: ["key1", "key2"],
    cookie: {
      httpOnly: true,
      secure: true,
      sameSite: "None",
    },
  }) // $ Alert
);

app.use(
  expressSession({
    name: "session",
    keys: ["key1", "key2"],
    cookie: {
      httpOnly: true,
      secure: true,
      sameSite: "Strict",
    },
  })
);

const http = require("http");

function test1() {
  const server = http.createServer((req, res) => {
    res.setHeader("Content-Type", "text/html");
    res.setHeader("Set-Cookie", "authKey=ninja; SameSite=None; Secure"); // $ Alert
    res.setHeader("Set-Cookie", "authKey=ninja; SameSite=Strict; Secure");
    res.writeHead(200, { "Content-Type": "text/plain" });
    res.end("ok");
  });
}

function documentCookie() {
  document.cookie = "authKey=ninja; SameSite=None; Secure"; // $ Alert
  document.cookie = "authKey=ninja; SameSite=Strict; Secure";
}

