async function getData(
    x, // $ threatModelSource=remote
    y) { // $ threatModelSource=remote
  "use server";
}

async function getData2(
    x, // should not be remote flow sources (because the function does not have "use server")
    y) {
}
