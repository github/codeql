const github = require('@actions/github');
const aexec = require('@actions/exec');
const { exec } = require('child_process');

// function to echo title
function echo_title() {
  // get the title from the event pull request
  const title = github.context.payload.pull_request.title; // $ Source
  exec(`echo ${title}`, (err, stdout, stderr) => { // $ Alert
    if (err) {
      return;
    }
  });
}

// function which passes the issue title into an exec
function exec_head_ref() {
  const head_ref = github.context.payload.pull_request.head.ref; // $ Source
  aexec.exec(`echo ${head_ref}`).then((res) => { // $ Alert
    console.log(res);
  });
}
