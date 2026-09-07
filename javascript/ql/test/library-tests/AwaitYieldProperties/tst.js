const o = { await: 42, yield: 43 };

async function f(pool) {
  console.log(o.await);
  o.await = 1;
  return await pool.await();
}

function* g() {
  yield o.yield;
  yield o?.yield;
}

class C {
  async await() {}
  *yield() {}
}
