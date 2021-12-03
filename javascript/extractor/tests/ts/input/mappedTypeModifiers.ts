namespace MappedTypeModifiers {
  type MutableRequired<T> = { -readonly [P in keyof T]-?: T[P] };  // Remove readonly and ?
  type ReadonlyPartial<T> = { +readonly [P in keyof T]+?: T[P] };  // Add readonly and ?

  type ReadonlyPartial2<T> = { readonly [P in keyof T]?: T[P] };  // Add readonly and ?

  type Required<T> = { [P in keyof T]-?: T[P] };

  type Foo = { a?: string };  // Same as { a?: string | undefined }
  type Bar = Required<Foo>;  // Same as { a: string }
}
