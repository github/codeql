export namespace A {
  export let x = 42;
  setX();
  let x2 = x;
  console.log(x2);
}

function setX() {
  A.x = "hi";
}

let a = A;
