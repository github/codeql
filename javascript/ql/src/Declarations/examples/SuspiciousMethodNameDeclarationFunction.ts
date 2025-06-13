// BAD: Using 'function' as a method name is confusing
interface Calculator {
   function(a: number, b: number): number; // This is just a method named "function"
}
