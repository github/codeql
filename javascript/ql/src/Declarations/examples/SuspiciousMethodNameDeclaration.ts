// BAD: Using 'constructor' in an interface creates a method, not a constructor signature
interface Point {
   x: number;
   y: number;
   constructor(x: number, y: number); // This is just a method named "constructor"
}
