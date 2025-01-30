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

  var arr4_variant = [];
  arr4_variant.splice(0, 0, "safe", "source");
  arr4_variant.pop();
  sink(arr4_variant.pop()); // NOT OK

  var arr4_spread = [];
  arr4_spread.splice(0, 0, ...arr);
  sink(arr4_spread.pop()); // NOT OK

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

  sink(arr[0]); // NOT OK

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

  const arrayFrom = require("array-from");
  for (const x of arrayFrom(arr)) {
    sink(x); // NOT OK
  }

  sink(arr.find(someCallback)); // NOT OK

  const arrayFind = require("array-find");
  sink(arrayFind(arr, someCallback)); // NOT OK

  const uniq = require("uniq");
  for (const x of uniq(arr)) {
    sink(x); // NOT OK
  }

  sink(arr.at(-1)); // NOT OK

  sink(["source"]); // OK - for now, array element do not taint the entire array
  sink(["source"].filter((x) => x).pop()); // NOT OK
  sink(["source"].filter((x) => !!x).pop()); // NOT OK

  var arr8 = [];
  arr8 = arr8.toSpliced(0, 0, "source");
  sink(arr8.pop()); // NOT OK

  var arr8_variant = [];
  arr8_variant = arr8_variant.toSpliced(0, 0, "safe", "source");
  arr8_variant.pop();
  sink(arr8_variant.pop()); // NOT OK

  var arr8_spread = [];
  arr8_spread = arr8_spread.toSpliced(0, 0, ...arr);
  sink(arr8_spread.pop()); // NOT OK

  sink(arr.findLast(someCallback)); // NOT OK

  {  // Test for findLast function
    const list = ["source"];
    const element = list.findLast((item) => sink(item)); // NOT OK
    sink(element); // NOT OK
  }

  {  // Test for find function
    const list = ["source"];
    const element = list.find((item) => sink(item)); // NOT OK
    sink(element); // NOT OK
  }

  {  // Test for findLastIndex function
    const list = ["source"];
    const element = list.findLastIndex((item) => sink(item)); // NOT OK
    sink(element); // OK
  }
  {
    const arr = source();
    const element1 = arr.find((item) => sink(item)); // NOT OK
    sink(element1); // NOT OK
  }

  {
    const arr = source();
    const element1 = arr.findLast((item) => sink(item)); // NOT OK
    sink(element1); // NOT OK
  }
  
  {
    const arr = source();
    const element1 = arr.findLastIndex((item) => sink(item)); // NOT OK
    sink(element1); // OK
  }
});
