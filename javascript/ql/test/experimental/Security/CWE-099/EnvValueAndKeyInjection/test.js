const http = require('node:http');


http.createServer((req, res) => {
  const { EnvValue, EnvKey } = req.body;
  process.env[EnvKey] = EnvValue; // NOT OK
  process.env[EnvKey] = EnvValue; // NOT OK

  res.end('env has been injected!');
});

http.createServer((req, res) => {
  const { EnvValue, EnvKey } = req.body;

  process.env[EnvKey] = "constant" // OK
  process.env.constant = EnvValue // OK

  res.end('env has been injected!');
});