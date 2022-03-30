(function() {
  var source1 = "src1";
  var sink1 = _.max(source1); // NOT OK

  var source2 = "src2";
  var sink2 = _.union([], source2); // NOT OK
  var sink3 = _.zip(source2, []); // NOT OK

  var source3 = "src3";
  _.map(source3, (x) => {
    let sink4 = x; // NOT OK
  });

  var source4 = "src4";
  _.reduce(source4, (acc, e) => {
    let sink5 = e; // NOT OK
  });

  var source5 = "src5";
  var sink6 = _.map([1,2,3], (x) => source5); // NOT OK
})();
