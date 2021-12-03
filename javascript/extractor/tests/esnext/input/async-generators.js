async function *foo() {
}

async function bar() {
  for await(var x of foo());
}
