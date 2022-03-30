let source1 = "tainted1";
let source2 = "tainted2";

function g(x) {
  let other_source = "also tainted";
  return Math.random() > .5 ? x : other_source;
}

let sink1 = g(source1);
let sink2 = g(source2);

document.location = source1; // should not flow to `global2.js` in spite of assignment
                             // `document = {}` in `fake-document.js`

window.location = source1;
let win = window;
let sink3 = window.location;
let sink4 = win.location;
let sink5 = location;
