var o = {
  x: 42,

  getX: function() {
    return this.x;
  }, // $ TODO-SPURIOUS: Alert

  setX: function(x) {
    this.x = x;
  },

  getX: function() {
    return this.x;
  },

  setX: function(x) {
    this.x = x;
  }
};