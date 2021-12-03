export async function foo(x) {
  try {
    await x;
  } catch (e) {
    return null;
  }
};
