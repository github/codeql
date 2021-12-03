var adder = {
  sum: 0,
  add: function(x) {
    this.sum += x;
  },
  addAll: function(xs) {
    xs.forEach(function(x) {
      this.sum += x;
    }, this);
  }
};