import express from 'express';
import { Command } from 'commander';
import { exec } from 'child_process';
import arg from 'arg';
const app = express();
app.use(express.json());

app.post('/Command', async (req, res) => {
  const args = req.body.args || []; // $ Source
  const program = new Command();
  program.option('--cmd <value>', 'Command to execute');
  program.parse(args, { from: 'user' });
  const options = program.opts();
  exec(options.cmd); // $ Alert
  exec(program.cmd); // $ Alert

  const program1 = new Command();
  program1
    .command('run <script>')
    .action((script) => {
      exec(script); // $ Alert
    });
  await program1.parseAsync(args);
});

app.post('/arg', (req, res) => {
    const argsArray = req.body.args || []; // $ Source
    const parsed = arg({ '--cmd': String }, { argv: argsArray });
    exec(parsed['--cmd']); // $ Alert
});

app.post('/commandLineArgs', (req, res) => {
  const commandLineArgs = require('command-line-args');
  const optionDefinitions = [{ name: 'cmd', type: String }];
  const options = commandLineArgs(optionDefinitions, { argv: req.body.args || [] }); // $ Source
  if (!options.cmd) return res.status(400).send({ error: 'Missing --cmd' });
  exec(options.cmd); // $ Alert
});

app.post('/yargs', (req, res) => {
  const yargs = require('yargs/yargs');
  const args = req.body.args || []; // $ Source
  const parsed = yargs(args).option('cmd', {
    type: 'string',
    describe: 'Command to execute',
    demandOption: true
  }).parse();

  exec(parsed.cmd); // $ Alert
});
