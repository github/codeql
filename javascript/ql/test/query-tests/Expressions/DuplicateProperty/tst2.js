var o = {
  x: 42,

  getX: function() {
    return this.x;
  }, // $ Alert

  setX: function(x) {
    this.x = x;
  }, // $ MISSING: Alert // The structural comparison fails to treat the two 'x' variables as the same

  getX: function() {
    return this.x;
  },

  setX: function(x) {
    this.x = x;
  }
};