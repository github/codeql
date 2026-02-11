// BAD: Using 'new' in a class creates a method, not a constructor
class Point {
   x: number;
   y: number;
   new(x: number, y: number) {}; // This is just a method named "new"
}
