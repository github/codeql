import * as Cookies from "es-cookie";

function esCookies() {
  Cookies.set("authkey", "value", {
    secure: true,
    httpOnly: true,
    sameSite: "None", // NOT OK
  });

  Cookies.set("authkey", "value", {
    secure: true,
    httpOnly: true,
    sameSite: "Strict", // OK
  });
}

function browserCookies() {
  var cookies = require("browser-cookies");

  cookies.set("authkey", "value", {
    expires: 365,
    secure: true,
    httponly: true,
    samesite: "None", // NOT OK
  });

  cookies.set("authkey", "value", {
    expires: 365,
    secure: true,
    httponly: true,
    samesite: "Strict", // OK
  });
}

function cookie() {
  var cookie = require("cookie");

  var setCookie = cookie.serialize("authkey", "value", {
    maxAge: 9000000000,
    httpOnly: true,
    secure: true,
    sameSite: "None",
  });

  var setCookie = cookie.serialize("authkey", "value", {
    maxAge: 9000000000,
    httpOnly: true,
    secure: true,
    sameSite: true, // OK
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
    sameSite: "None", // NOT OK
  });

  res.cookie("session", "value", {
    maxAge: 9000000000,
    httpOnly: true,
    secure: true,
    sameSite: "Strict", // OK
  });

  res.end("ok");
});

app.use(
  session({
    name: "session",
    keys: ["key1", "key2"],
    httpOnly: true,
    secure: true,
    sameSite: "None", // NOT OK
  })
);

app.use(
  session({
    name: "session",
    keys: ["key1", "key2"],
    httpOnly: true,
    secure: true,
    sameSite: "Strict", // OK
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
      sameSite: "None", // NOT OK
    },
  })
);

app.use(
  expressSession({
    name: "session",
    keys: ["key1", "key2"],
    cookie: {
      httpOnly: true,
      secure: true,
      sameSite: "Strict", // OK
    },
  })
);

const http = require("http");

function test1() {
  const server = http.createServer((req, res) => {
    res.setHeader("Content-Type", "text/html");
    res.setHeader("Set-Cookie", "authKey=ninja; SameSite=None; Secure"); // NOT OK
    res.setHeader("Set-Cookie", "authKey=ninja; SameSite=Strict; Secure"); // OK
    res.writeHead(200, { "Content-Type": "text/plain" });
    res.end("ok");
  });
}

function documentCookie() {
  document.cookie = "authKey=ninja; SameSite=None; Secure"; // NOT OK
  document.cookie = "authKey=ninja; SameSite=Strict; Secure"; // OK
}

