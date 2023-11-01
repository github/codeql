import { exec } from "@actions/exec";
import { getInput } from "@actions/core";

exec(process.env['TEST_DATA']); // NOT OK
exec(process.env['GITHUB_ACTION']); // OK

function test(e) {
    exec(e['TEST_DATA']); // NOT OK
    exec(e['GITHUB_ACTION']); // OK
}

test(process.env);

exec(getInput('data')); // NOT OK
