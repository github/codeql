var o = {
  x: 42,

  getX: function() {
    return this.x;
  },

  setX: function(x) {
    this.x = x;
  }, // $ Alert

  getX: function() {
    return this.x;
  },

  setX: function(x) {
    this.x = x;
  }
};

function f(type) {
  return {
    type,
    [type]: "hi"
  };
}
