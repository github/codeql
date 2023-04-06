const core = require('@actions/core');
const github = require('@actions/github');
const aexec = require('@actions/exec');
// import exec from child_process
const { exec } = require('child_process');

// function to echo title
function echo_title() {
  // get the title from the event pull request
  const title = github.context.payload.pull_request.title;
  // echo the title
  exec(`echo ${title}`, (err, stdout, stderr) => {
    if (err) {
      // node couldn't execute the command
      return;
    }
    // the *entire* stdout and stderr (buffered)
    console.log(`stdout: ${stdout}`);
  });
}

// function which passes the commit message into an eval
function eval_commit_message() {
  // get the commit message from the event pull request
  const commit = github.context.payload.commits[1]

  // if commit author is x
  if (commit.author.name === 'Test') {
    // eval the commit message
    const evalres = eval(commit.message);
    // echo the result
    console.log(evalres);
  }
}

// function which passes the issue title into an exec
function exec_head_ref() {
  const head_ref = github.context.payload.pull_request.head.ref;

  aexec.exec(`echo ${head_ref}`).then((res) => {
    console.log(res);
  });
}

function input_to_eval() {
  const numbers = core.getInput('numbers');
  const fin = eval(numbers);
  console.log(fin);
}

function env_to_eval() {
  const fin = eval(process.env.EVAL_VALUES);
  console.log(fin);
}

function github_env_to_exec() {
  const workspace = process.env.GITHUB_WORKSPACE;
  // echo the workspace
  exec(`echo ${workspace}`, (err, stdout, stderr) => {
    if (err) {
      // node couldn't execute the command
      return;
    }
    // the *entire* stdout and stderr (buffered)
    console.log(`stdout: ${stdout}`);
  });
}

async function run() {
  // Try one source to sink flow for each type
  // of function
  echo_title();
  eval_commit_message();
  exec_head_ref();
  input_to_eval();
  env_to_eval();
  github_env_to_exec();
}

run();
