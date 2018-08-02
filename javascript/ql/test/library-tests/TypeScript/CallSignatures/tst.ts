abstract class C {
  abstract (x: number): number; // Note: Method named 'abstract'
  abstract new (x: number): C;  // Note: Abstract method named 'new'
}

interface I {
  (x: number): number;
  new (x: number): C;
  [x: number]: string;
}

var x : {
  (x: number): number;
  new (x: number): C;
  [x: number]: string;
}
