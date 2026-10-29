function f(x,) {
  f(0,);
}

async function g(y, xs) {
  let v = null;
  try {
    for(const x of xs) {
      v = await h(x, y);
    }
  } catch(e) { }
  return v;
}
