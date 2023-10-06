import { execa, execaSync, execaCommand, execaCommandSync, $ } from 'execa';
import http from 'node:http'
import url from 'url'

http.createServer(async function (req, res) {
    let cmd = url.parse(req.url, true).query["cmd"][0];
    let arg = url.parse(req.url, true).query["arg"];

    await $`${cmd} ${arg}`; // NOT OK
    $.sync`${cmd} ${arg}`; // NOT OK
    await $({ shell: true })`${cmd} ${arg}` // NOT OK
    await $({ shell: false })`${cmd} ${arg}` // NOT OK

    await execa(cmd, [arg]); // NOT OK
    await execa(cmd, { shell: true }); // NOT OK
    await execa(cmd, { shell: true }); // NOT OK
    await execa(cmd, [arg], { shell: true }); // NOT OK
    execaSync(cmd, [arg]); // NOT OK
    execaSync(cmd, [arg], { shell: true }); // NOT OK

    await execaCommand(cmd + arg); // NOT OK
    execaCommandSync(cmd + arg); // NOT OK
    await execaCommand(cmd + arg, { shell: true }); // NOT OK
    execaCommandSync(cmd + arg, { shell: true }); // NOT OK
});