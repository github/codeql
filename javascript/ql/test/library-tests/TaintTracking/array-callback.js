async function test() {
  let promisedTaint = source();
  (await promisedTaint).map(x => {
    sink(x); // NOT OK
  });
}
