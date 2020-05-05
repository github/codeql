(function () {
  let source = "source";

  var obj = { foo: source };
  sink(obj.foo); // NOT OK

  var arr = [];
  arr.push(source);

  for (var i = 0; i < arr.length; i++) {
    sink(arr[i]); // NOT OK
  }


  arr.forEach((e) => sink(e)); // NOT OK
  arr.map((e) => sink(e)); // NOT OK

  [1, 2, 3].map(i => "source").forEach(e => sink(e)); // NOT OK.

  sink(arr.pop()); // NOT OK

  var arr2 = ["source"];
  sink(arr2.pop()); // NOT OK

  var arr3 = ["source"];
  sink(arr3.pop()); // NOT OK

  var arr4 = [];
  arr4.splice(0, 0, "source");
  sink(arr4.pop()); // NOT OK

  var arr5 = [].concat(arr4);
  sink(arr5.pop()); // NOT OK

  sink(arr5.slice(2).pop()); // NOT OK

  var arr6 = [];
  for (var i = 0; i < arr5.length; i++) {
    arr6[i] = arr5[i];
  }
  sink(arr6.pop()); // NOT OK


  ["source"].forEach((e, i, ary) => {
    sink(ary.pop()); // NOT OK
    sink(ary); // OK - its the array itself, not an element.
  });

  sink(arr[0]); // OK - tuple like usage. 

  for (const x of arr) {
    sink(x); // NOT OK
  }

  for (const x of Array.from(arr)) {
    sink(x); // NOT OK
  }

  for (const x of [...arr]) {
    sink(x); // NOT OK
  }
  
  var arr7 = [];
  arr7.push(...arr);
  for (const x of arr7) {
    sink(x); // NOT OK
  }
});
