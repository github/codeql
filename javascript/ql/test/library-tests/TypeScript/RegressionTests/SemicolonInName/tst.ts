namespace Bar {
    
  export interface Foo {
    [";x"]: number;
    w: number;
  }
  
  let x : Foo;

}

let y: Bar.Foo;
let z: typeof Bar[";"];
