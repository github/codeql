async function getData(id) {
  let req = await fetch(`https://example.com/data?id=${id}`);
  if (!req.ok) return null;
  return req.json();
}

async function showData(id) {
  let data = await getData(id);
  if (data == null) {
    console.warn("No data for: " + id);
    return;
  }
  // ...
}
