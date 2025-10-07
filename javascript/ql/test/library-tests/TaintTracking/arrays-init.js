(function () {
  let source = source();

  var str = "FALSE";

  console.log("=== access by index (init by ctor) ===");
  var arr = new Array(2);
  arr[0] = str;
  arr[1] = source;
  arr[2] = 'b';
  arr[3] = 'c';
  arr[4] = 'd';
  arr[5] = 'e';
  arr[6] = source;

  sink(arr[0]);       // OK
  sink(arr[1]);       // NOT OK
  sink(arr[2]);       // OK
  sink(arr[3]);       // OK
  sink(arr[4]);       // OK
  sink(arr[5]);       // OK
  sink(arr[6]);       // NOT OK
  sink(str);          // OK

  console.log("=== access by index (init by [...]) ===");
  var arr = [str, source];
  sink(arr[0]);       // OK
  sink(arr[1]);       // NOT OK
  sink(str);          // OK

  console.log("=== access by index (init by [...], array.lenght > 5) ===");
  var arr = [str, source, 'b', 'c', 'd', source];
  sink(arr[0]);      // OK
  sink(arr[1]);      // NOT OK
  sink(arr[2]);      // OK
  sink(arr[3]);      // OK
  sink(arr[4]);      // OK
  sink(arr[5]);      // NOT OK

  console.log("=== access in for (init by [...]) ===");
  var arr = [str, source];
  for (let i = 0; i < arr.length; i++) {
    sink(arr[i]);    // NOT OK
  }

  console.log("=== access in for (init by [...]) w/o source ===");
  var arr = [str, 'a'];
  for (let i = 0; i < arr.length; i++) {
    sink(arr[i]);    // OK
  }

  console.log("=== access in for (init by [...], array.lenght > 5) ===");
  var arr = [str, 'a', 'b', 'c', 'd', source];
  for (let i = 0; i < arr.length; i++) {
    sink(arr[i]);    // NOT OK
  }

  console.log("=== access in forof (init by [...]) ===");
  var arr = [str, source];
  for (const item of arr) {
    sink(item);       // NOT OK
  }
}());
