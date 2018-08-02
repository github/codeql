f();

function f() {
  console.log("first declaration");
}

f();

function f() { // NOT OK
  console.log("first declaration");
}

f();
