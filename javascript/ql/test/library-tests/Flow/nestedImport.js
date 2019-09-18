import { foo } from './esLib';
let x1 = foo;

if (!foo) {
  import { foo } from './nodeJsLib';
  let x2 = foo;
}

function tst() {
  import { foo } from './esLib';
  let x3 = foo;
}
