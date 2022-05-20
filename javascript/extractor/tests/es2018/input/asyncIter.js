async function* asyncFn() {}

class C {
  async *asyncMeth() {}
  async *[Symbol.asyncIterator]() {}
}

var o = {
  async *asyncMeth() {},
  async *[Symbol.asyncIterator]() {}
}
