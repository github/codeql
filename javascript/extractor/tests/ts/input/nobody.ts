// Ambient functions
declare function f();

abstract class C {
  // Abstract methods
  abstract h();

  // Overload signatures
  g(x: number): number;
  g(x: string): string;
  g(x: any) {}

  // Abstract fields
  abstract x: number;
}

// Same but ambient
declare abstract class D {
  // Abstract methods
  abstract h();

  // Overload signatures
  g(x: number): number;
  g(x: string): string;
  g(x: any) {}

  // Abstract fields
  abstract x: number;
}
