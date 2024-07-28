import { execa, $ } from 'execa';
import http from 'node:http'
import url from 'url'

http.createServer(async function (req, res) {
    let filePath = url.parse(req.url, true).query["filePath"][0];

    // Piping to stdin from a file
    await $({ inputFile: filePath })`cat` // test: PathInjection

    // Piping to stdin from a file
    await execa('cat', { inputFile: filePath }); // test: PathInjection

    // Piping Stdout to file
    await execa('echo', ['example3']).pipeStdout(filePath); // test: PathInjection

    // Piping all of command output to file
    await execa('echo', ['example4'], { all: true }).pipeAll(filePath); // test: PathInjection
});