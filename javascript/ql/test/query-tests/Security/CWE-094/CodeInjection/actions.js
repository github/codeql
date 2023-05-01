const core = require('@actions/core');
const github = require('@actions/github');

function test() {
    eval(github.context.payload.commits[1].message); // NOT OK
    eval(core.getInput('numbers')); // NOT OK
    eval(core.getMultilineInput('numbers').join('\n')); // NOT OK
}
