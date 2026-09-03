const pool = { await() { return 42; } };

async function issue22499() {
  return await pool.await();
}
