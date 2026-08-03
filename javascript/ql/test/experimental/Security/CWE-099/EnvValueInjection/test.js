const http = require('node:http');

http.createServer((req, res) => {
  const { EnvValue } = req.body; // $ Source
  process.env["A_Critical_Env"] = EnvValue; // $ Alert // NOT OK
  process.env[AKey] = EnvValue; // $ Alert // NOT OK
  process.env.AKey = EnvValue; // $ Alert // NOT OK

  res.end('env has been injected!');
});
