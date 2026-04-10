// Test file for validating the TypeScript parser wrapper.
// This file exercises various TypeScript features to ensure the AST
// serialization produces the correct output.

interface Greeter {
  greet(name: string): string;
}

class HelloGreeter implements Greeter {
  private prefix: string;

  constructor(prefix: string = "Hello") {
    this.prefix = prefix;
  }

  greet(name: string): string {
    return `${this.prefix}, ${name}!`;
  }
}

// Generics
function identity<T>(arg: T): T {
  return arg;
}

// Conditional types
type IsString<T> = T extends string ? "yes" : "no";

// Async/await
async function fetchData(url: string): Promise<string> {
  const response = await fetch(url);
  return response.text();
}

// Destructuring
const { a, b, ...rest } = { a: 1, b: 2, c: 3, d: 4 };
const [first, second, ...remaining] = [1, 2, 3, 4, 5];

// Enums
enum Direction {
  Up = "UP",
  Down = "DOWN",
  Left = "LEFT",
  Right = "RIGHT",
}

// Type assertions
const value = "hello" as unknown as number;

// Optional chaining
const len = value?.toString()?.length;

// Nullish coalescing
const result = len ?? 0;

// Decorators
function log(target: any, key: string, descriptor: PropertyDescriptor) {
  return descriptor;
}

// Namespace
namespace Validation {
  export interface StringValidator {
    isAcceptable(s: string): boolean;
  }
}

// Mapped types
type Readonly<T> = {
  readonly [P in keyof T]: T[P];
};

// Template literal types
type EventName = `on${string}`;

// Export
export { HelloGreeter, Direction, fetchData };
