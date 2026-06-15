function f(o) {
  const { p: v = [] } = o;
  return v;
}

function v() {
    using foo = null as any;

    const bar = undefined;
}

async function b() {
    await using foo = null as any;
}