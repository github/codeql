const app = require("express")(),
  cookieParser = require("cookie-parser"),
  bodyParser = require("body-parser"),
  session = require("express-session"),
  csrf = require('lusca').csrf;

app.use(cookieParser());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(session({ secret: process.env['SECRET'], cookie: { maxAge: 60000 } }));
app.use(csrf());

// ...

app.post("/changeEmail", function(req, res) {
  const userId = req.session.id;
  const email = req.body["email"];
  // ... update email associated with userId
});
