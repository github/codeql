'use strict';

function run(f) {
  f();
}

if (true) {
  run(main);

  function main() {
    console.log("Yay!");
  }
}
