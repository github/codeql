enum Foo {
    Bar,
    Baz,
    Qux,
}

enum Fieldless {
    Tuple(),
    Struct{},
    Unit,
}

enum Direction {
    North = 0,
    East = 90,
    South = 180,
    West = 270,
}

enum Color {
    Red(u8),
    Green(u8),
    Blue(u8),
}
