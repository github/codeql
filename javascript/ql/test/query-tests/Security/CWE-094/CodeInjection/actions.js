const github = require('@actions/github');

function test() {
    eval(github.context.payload.commits[1].message); // NOT OK
}
