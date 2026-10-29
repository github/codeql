struct Outer {
  struct Inner {
    struct Deep {}
  }

  struct Generic<T> {
    struct Deep<U, V> {}
    struct Plain {}
  }
}

let value: Outer.Inner
let nested: Outer.Inner.Deep

func qualifiedTypes<Metadata, ErrorComponentType>(
  _ value: Outer.Generic<Metadata>,
  _ nested: Outer.Generic<Metadata>.Deep<ErrorComponentType, [Metadata]>,
  _ plain: Outer.Generic<Metadata>.Plain
) {}
