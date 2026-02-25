import { use } from "react";

async function fetchData() {
  return new Promise((resolve) => {
    resolve(source("fetchedData"));
  });
}

function Component() {
  const data = use(fetchData());
  sink(data); // $ MISSING: hasValueFlow=fetchedData
}
