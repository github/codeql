function should(v) {
  this.value = v;
}
should.prototype = {
  get be() { return this; },
  get ok() {
    if (!this.value)
      throw new Error("assertion failed");
  }
};

Object.defineProperty(Object.prototype, 'should', {
  get: function() { return new should(this.valueOf()); }
});

var myComplicatedPropertyDescriptor = (function(k) {
  return {
    [k]: function() { throw new Error("too complicated!"); }
  }
})("get");
Object.defineProperty(Object.prototype, 'foo', myComplicatedPropertyDescriptor);

// OK: getters
(false).should.be.ok;
(false).should;
should.prototype.be;
({}).foo;