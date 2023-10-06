import { execa, $ } from 'execa';
import http from 'node:http'
import url from 'url'

http.createServer(async function (req, res) {
    let filePath = url.parse(req.url, true).query["filePath"][0];

    // Piping to stdin from a file
    await $({ inputFile: filePath })`cat`  // NOT OK

    // Piping to stdin from a file
    await execa('cat', { inputFile: filePath }); // NOT OK

    // Piping Stdout to file
    await execa('echo', ['example3']).pipeStdout(filePath); // NOT OK

    // Piping all of command output to file
    await execa('echo', ['example4'], { all: true }).pipeAll(filePath); // NOT OK
});