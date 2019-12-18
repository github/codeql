export namespace A {
  export let x = 42;
  setX();
  x;                                     // global namespace exports are incompletely analysed
}

function setX() {
  A.x = 23;
}

var nd2 = A.x as number;                 // flow through type assertions

class StringList extends List<string> {} // flow through expressions with type arguments
