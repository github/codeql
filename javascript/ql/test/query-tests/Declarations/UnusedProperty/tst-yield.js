async function* f() {
  yield* {
    get p() { }
  };
}
