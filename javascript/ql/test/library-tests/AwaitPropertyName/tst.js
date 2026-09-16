const pool = { await() { return 42; } };
const generator = { yield() { return 42; } };

async function issue22499() {
  return await pool.await();
}

function* yieldPropertyName() {
  return generator.yield();
}
