import { exec } from "@actions/exec";

exec(process.env['TEST_DATA']); // NOT OK
exec(process.env['GITHUB_ACTION']); // OK

function test(e) {
    exec(e['TEST_DATA']); // NOT OK
    exec(e['GITHUB_ACTION']); // OK
}

test(process.env);
