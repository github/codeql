// Test case taken from babel: https://github.com/babel/babel/blob/main/packages/babel-parser/test/fixtures/typescript/regression/keyword-qualified-type-2/input.ts

// These are valid TypeScript syntax (the parser doesn't produce any error),
// but they are always type-checking errors.
interface A extends this.B {}
type T = typeof var.bar;
