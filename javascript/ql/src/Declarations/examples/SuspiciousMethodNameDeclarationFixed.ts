// GOOD: Using 'new' for constructor signatures in interfaces
interface Point {
   x: number;
   y: number;
   new(x: number, y: number): Point; // This is a proper constructor signature
}
