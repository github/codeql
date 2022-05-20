

interface ImportMeta {
  wellKnownProperty: { a: number, b: string, c: boolean };
}

var a = import.meta.wellKnownProperty.a;