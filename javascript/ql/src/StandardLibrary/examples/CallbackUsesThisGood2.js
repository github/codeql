var adder = {
  sum: 0,
  add: function(x) {
    this.sum += x;
  },
  addAll: function(xs) {
    var self = this;
    xs.forEach(function(x) {
      self.sum += x;
    });
  }
};