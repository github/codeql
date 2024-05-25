const http = require('node:http');

http.createServer((req, res) => {
  const { EnvValue } = req.body;
  process.env["A_Critical_Env"] = EnvValue; // NOT OK
  process.env[AKey] = EnvValue; // NOT OK
  process.env.AKey = EnvValue; // NOT OK

  res.end('env has been injected!');
});
