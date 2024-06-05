import { execa, execaSync, execaCommand, execaCommandSync, $ } from 'execa';
import http from 'node:http'
import url from 'url'

http.createServer(async function (req, res) {
    let cmd = url.parse(req.url, true).query["cmd"][0];
    let arg1 = url.parse(req.url, true).query["arg1"];
    let arg2 = url.parse(req.url, true).query["arg2"];
    let arg3 = url.parse(req.url, true).query["arg3"];

    await $`${cmd} ${arg1} ${arg2} ${arg3}`; // test: CommandInjection
    await $`ssh ${arg1} ${arg2} ${arg3}`; // test: CommandInjection
    $({ shell: false }).sync`${cmd} ${arg1} ${arg2} ${arg3}`; // test: CommandInjection
    $({ shell: true }).sync`${cmd} ${arg1} ${arg2} ${arg3}`; // test: CommandInjection
    $({ shell: false }).sync`ssh ${arg1} ${arg2} ${arg3}`; // test: CommandInjection

    $.sync`${cmd} ${arg1} ${arg2} ${arg3}`; // test: CommandInjection
    $.sync`ssh ${arg1} ${arg2} ${arg3}`; // test: CommandInjection
    await $({ shell: true })`${cmd} ${arg1} ${arg2} ${arg3}` // test: CommandInjection
    await $({ shell: false })`${cmd} ${arg1} ${arg2} ${arg3}` // test: CommandInjection
    await $({ shell: false })`ssh ${arg1} ${arg2} ${arg3}` // test: CommandInjection

    await execa(cmd, [arg1, arg2, arg3]); // test: CommandInjection
    await execa(cmd, { shell: true }); // test: CommandInjection
    await execa(cmd, { shell: true }); // test: CommandInjection
    await execa(cmd, [arg1, arg2, arg3], { shell: true }); // test: CommandInjection

    execaSync(cmd, [arg1, arg2, arg3]); // test: CommandInjection
    execaSync(cmd, [arg1, arg2, arg3], { shell: true }); // test: CommandInjection

    await execaCommand(cmd + arg1 + arg2 + arg3); // test: CommandInjection
    await execaCommand(cmd + arg1 + arg2 + arg3, { shell: true }); // test: CommandInjection

    execaCommandSync(cmd + arg1 + arg2 + arg3); // test: CommandInjection
    execaCommandSync(cmd + arg1 + arg2 + arg3, { shell: true }); // test: CommandInjection
});