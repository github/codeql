const http = require("http");
const url = require("url");
const ldap = require("ldapjs");
const client = ldap.createClient({
  url: "ldap://127.0.0.1:1389",
});

// https://github.com/vesse/node-ldapauth-fork/commit/3feea43e243698bcaeffa904a7324f4d96df60e4
const sanitizeInput = function (input) {
  return input
    .replace(/\*/g, "\\2a")
    .replace(/\(/g, "\\28")
    .replace(/\)/g, "\\29")
    .replace(/\\/g, "\\5c")
    .replace(/\0/g, "\\00")
    .replace(/\//g, "\\2f");
};

const server = http.createServer((req, res) => {
  let q = url.parse(req.url, true);

  let username = q.query.username;

  var opts1 = {
    filter: `(|(name=${username})(username=${username}))`,
  };

  client.search("o=example", opts1, function (err, res) {}); // NOT OK

  client.search(
    "o=example",
    { filter: `(|(name=${username})(username=${username}))` }, // NOT OK
    function (err, res) {}
  );

  // GOOD
  client.search(
    "o=example",
    { // OK
      filter: `(|(name=${sanitizeInput(username)})(username=${sanitizeInput(
        username
      )}))`,
    },
    function (err, res) {}
  );

  // GOOD (https://github.com/ldapjs/node-ldapjs/issues/181)
  let f = new OrFilter({
    filters: [
      new EqualityFilter({
        attribute: "name",
        value: username,
      }),
      new EqualityFilter({
        attribute: "username",
        value: username,
      }),
    ],
  });

  client.search("o=example", { filter: f }, function (err, res) {});

  const parsedFilter = ldap.parseFilter(
    `(|(name=${username})(username=${username}))`
  );
  client.search("o=example", { filter: parsedFilter }, function (err, res) {}); // NOT OK

  const dn = ldap.parseDN(`cn=${username}`, function (err, dn) {}); // NOT OK
});

server.listen(389, () => {});
