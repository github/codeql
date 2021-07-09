function sink(arg) {
  if (arg !== "source")
    return;

  const STACK_LINE_REGEX = /(\d+):(\d+)\)?$/;
  let err;

  try {
    throw new Error();
  } catch (error) {
    err = error;
  }

  try {
    const stacks = err.stack.split('\n');
    const [, line] = STACK_LINE_REGEX.exec(stacks[2]);

    return console.log(`[${line}]`, arg);
  } catch (err) {
    return console.log(arg);
  }  
};

(function () {
  let source = "source";

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

  sink(arr[0]);       // FALSE
  sink(arr[1]);       // TRUE
  sink(arr[2]);       // FALSE
  sink(arr[3]);       // FALSE
  sink(arr[4]);       // FALSE
  sink(arr[5]);       // FALSE
  sink(arr[6]);       // TRUE
  sink(str);          // FALSE

  console.log("=== access by index (init by [...]) ===");
  var arr = [str, source];
  sink(arr[0]);       // FALSE
  sink(arr[1]);       // TRUE
  sink(str);          // FALSE

  console.log("=== access by index (init by [...], array.lenght > 5) ===");
  var arr = [str, source, 'b', 'c', 'd', source];
  sink(arr[0]);      // FALSE
  sink(arr[1]);      // TRUE
  sink(arr[2]);      // FALSE
  sink(arr[3]);      // FALSE
  sink(arr[4]);      // FALSE
  sink(arr[5]);      // TRUE

  console.log("=== access in for (init by [...]) ===");
  var arr = [str, source];
  for (let i = 0; i < arr.length; i++) {
    sink(arr[i]);    // TRUE
  }

  console.log("=== access in for (init by [...]) w/o source ===");
  var arr = [str, 'a'];
  for (let i = 0; i < arr.length; i++) {
    sink(arr[i]);    // FALSE
  }

  console.log("=== access in for (init by [...], array.lenght > 5) ===");
  var arr = [str, 'a', 'b', 'c', 'd', source];
  for (let i = 0; i < arr.length; i++) {
    sink(arr[i]);    // TRUE
  }

  console.log("=== access in forof (init by [...]) ===");
  var arr = [str, source];
  for (const item of arr) {
    sink(item);       // TRUE    
  }
}());