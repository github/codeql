import { execa, execaSync, execaCommand, execaCommandSync, $ } from 'execa';
import http from 'node:http'
import url from 'url'

http.createServer(async function (req, res) {
    let cmd = url.parse(req.url, true).query["cmd"][0];
    let arg1 = url.parse(req.url, true).query["arg1"];
    let arg2 = url.parse(req.url, true).query["arg2"];

    await $`${cmd} ${arg1} ${arg2}`; // NOT OK
    await $`ssh ${arg1} ${arg2}`; // NOT OK
    $({ shell: false }).sync`${cmd} ${arg} ${arg} ${arg2}`; // NOT OK
    $({ shell: true }).sync`${cmd} ${arg} ${arg} ${arg2}`; // NOT OK
    $({ shell: false }).sync`ssh ${arg} ${arg} ${arg2}`; // NOT OK

    $.sync`${cmd} ${arg1} ${arg2}`; // NOT OK
    $.sync`ssh ${arg1} ${arg2}`; // NOT OK
    await $({ shell: true })`${cmd} ${arg1} ${arg2}` // NOT OK
    await $({ shell: false })`${cmd} ${arg1} ${arg2}` // NOT OK
    await $({ shell: false })`ssh ${arg1} ${arg2}` // NOT OK

    await execa(cmd, [arg1]); // NOT OK
    await execa(cmd, { shell: true }); // NOT OK
    await execa(cmd, { shell: true }); // NOT OK
    await execa(cmd, [arg1], { shell: true }); // NOT OK

    execaSync(cmd, [arg1]); // NOT OK
    execaSync(cmd, [arg1], { shell: true }); // NOT OK

    await execaCommand(cmd + arg1); // NOT OK
    await execaCommand(cmd + arg1, { shell: true }); // NOT OK

    execaCommandSync(cmd + arg1); // NOT OK
    execaCommandSync(cmd + arg1, { shell: true }); // NOT OK
});