namespace ConditionalTypes1 {
  type TypeName<T> =
      T extends string ? "string" :
      T extends number ? "number" :
      T extends boolean ? "boolean" :
      T extends undefined ? "undefined" :
      T extends Function ? "function" :
      "object";
  
  type T0 = TypeName<string>;  // "string"
  type T1 = TypeName<"a">;  // "string"
  type T2 = TypeName<true>;  // "boolean"
  type T3 = TypeName<() => void>;  // "function"
  type T4 = TypeName<string[]>;  // "object"
  
  
  type T10 = TypeName<string | (() => void)>;  // "string" | "function"
  type T12 = TypeName<string | string[] | undefined>;  // "string" | "object" | "undefined"
  type T11 = TypeName<string[] | number[]>;  // "object"
  
  type BoxedValue<T> = { value: T };
  type BoxedArray<T> = { array: T[] };
  type Boxed<T> = T extends any[] ? BoxedArray<T[number]> : BoxedValue<T>;
  
  type T20 = Boxed<string>;  // BoxedValue<string>;
  type T21 = Boxed<number[]>;  // BoxedArray<number>;
  type T22 = Boxed<string | number[]>;  // BoxedValue<string> | BoxedArray<number>;
  
  type Diff<T, U> = T extends U ? never : T;  // Remove types from T that are assignable to U
  type Filter<T, U> = T extends U ? T : never;  // Remove types from T that are not assignable to U
  
  type T30 = Diff<"a" | "b" | "c" | "d", "a" | "c" | "f">;  // "b" | "d"
  type T31 = Filter<"a" | "b" | "c" | "d", "a" | "c" | "f">;  // "a" | "c"
  type T32 = Diff<string | number | (() => void), Function>;  // string | number
  type T33 = Filter<string | number | (() => void), Function>;  // () => void
  
  type NonNullable<T> = Diff<T, null | undefined>;  // Remove null and undefined from T
  
  type T34 = NonNullable<string | number | undefined>;  // string | number
  type T35 = NonNullable<string | string[] | null | undefined>;  // string | string[]
  
  function f1<T>(x: T, y: NonNullable<T>) {
      x = y;  // Ok
  }
  
  function f2<T extends string | undefined>(x: T, y: NonNullable<T>) {
      x = y;  // Ok
      let s2: string = y;  // Ok
  }
  
  type FunctionPropertyNames<T> = { [K in keyof T]: T[K] extends Function ? K : never }[keyof T];
  type FunctionProperties<T> = Pick<T, FunctionPropertyNames<T>>;
  
  type NonFunctionPropertyNames<T> = { [K in keyof T]: T[K] extends Function ? never : K }[keyof T];
  type NonFunctionProperties<T> = Pick<T, NonFunctionPropertyNames<T>>;
  
  interface Part {
      id: number;
      name: string;
      subparts: Part[];
      updatePart(newName: string): void;
  }
  
  type T40 = FunctionPropertyNames<Part>;  // "updatePart"
  type T41 = NonFunctionPropertyNames<Part>;  // "id" | "name" | "subparts"
  type T42 = FunctionProperties<Part>;  // { updatePart(newName: string): void }
  type T43 = NonFunctionProperties<Part>;  // { id: number, name: string, subparts: Part[] }
  
  type ReturnType<T> = T extends (...args: any[]) => infer R ? R : any;
}

namespace ConditionalTypes2 {
  type Unpacked<T> =
    T extends (infer U)[] ? U :
    T extends (...args: any[]) => infer U ? U :
    T extends Promise<infer U> ? U :
    T;
  
  type T0 = Unpacked<string>;  // string
  type T1 = Unpacked<string[]>;  // string
  type T2 = Unpacked<() => string>;  // string
  type T3 = Unpacked<Promise<string>>;  // string
  type T4 = Unpacked<Promise<string>[]>;  // Promise<string>
  type T5 = Unpacked<Unpacked<Promise<string>[]>>;  // string
  
  type Foo<T> = T extends { a: infer U, b: infer U } ? U : never;
  type T10 = Foo<{ a: string, b: string }>;  // string
  type T11 = Foo<{ a: string, b: number }>;  // string | number
  
  type Bar<T> = T extends { a: (x: infer U) => void, b: (x: infer U) => void } ? U : never;
  type T20 = Bar<{ a: (x: string) => void, b: (x: string) => void }>;  // string
  type T21 = Bar<{ a: (x: string) => void, b: (x: number) => void }>;  // string & number
  
  declare function foo(x: string): number;
  declare function foo(x: number): string;
  declare function foo(x: string | number): string | number;
  type T30 = ReturnType<typeof foo>;  // string | number
  
  type AnyFunction = (...args: any[]) => any;
  type ReturnType<T extends AnyFunction> = T extends (...args: any[]) => infer R ? R : any;
}

