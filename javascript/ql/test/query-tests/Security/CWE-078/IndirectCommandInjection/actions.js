import { exec } from "@actions/exec";
import { getInput } from "@actions/core";

exec(process.env['TEST_DATA']); // $ Alert
exec(process.env['GITHUB_ACTION']);

function test(e) {
    exec(e['TEST_DATA']); // $ Alert
    exec(e['GITHUB_ACTION']);
}

test(process.env); // $ Source

exec(getInput('data')); // $ Alert
