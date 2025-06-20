import { execa, execaSync, execaCommand, execaCommandSync, $ } from 'execa';
import http from 'node:http'
import url from 'url'

http.createServer(async function (req, res) {
    let cmd = url.parse(req.url, true).query["cmd"][0]; // $Source
    let arg1 = url.parse(req.url, true).query["arg1"]; // $Source
    let arg2 = url.parse(req.url, true).query["arg2"]; // $Source
    let arg3 = url.parse(req.url, true).query["arg3"]; // $Source

    await $`${cmd} ${arg1} ${arg2} ${arg3}`; // $Alert
    await $`ssh ${arg1} ${arg2} ${arg3}`; // safely escapes variables, preventing shell injection.
    $({ shell: false }).sync`${cmd} ${arg1} ${arg2} ${arg3}`; // $Alert
    $({ shell: true }).sync`${cmd} ${arg1} ${arg2} ${arg3}`; // $Alert
    $({ shell: false }).sync`ssh ${arg1} ${arg2} ${arg3}`; // safely escapes variables, preventing shell injection.

    $.sync`${cmd} ${arg1} ${arg2} ${arg3}`; // $Alert
    $.sync`ssh ${arg1} ${arg2} ${arg3}`; // safely escapes variables, preventing shell injection.
    await $({ shell: true })`${cmd} ${arg1} ${arg2} ${arg3}` // $Alert
    await $({ shell: false })`${cmd} ${arg1} ${arg2} ${arg3}` // $Alert
    await $({ shell: false })`ssh ${arg1} ${arg2} ${arg3}` // safely escapes variables, preventing shell injection.

    await execa(cmd, [arg1, arg2, arg3]); // $Alert
    await execa(cmd, { shell: true }); // $Alert
    await execa(cmd, { shell: true }); // $Alert
    await execa(cmd, [arg1, arg2, arg3], { shell: true }); // $Alert

    execaSync(cmd, [arg1, arg2, arg3]); // $Alert
    execaSync(cmd, [arg1, arg2, arg3], { shell: true }); // $Alert

    await execaCommand(cmd + arg1 + arg2 + arg3); // $Alert
    await execaCommand(cmd + arg1 + arg2 + arg3, { shell: true }); // $Alert

    execaCommandSync(cmd + arg1 + arg2 + arg3); // $Alert
    execaCommandSync(cmd + arg1 + arg2 + arg3, { shell: true }); // $Alert
});
