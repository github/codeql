func foo() -> some SignedInteger { return 1 }

protocol P {}

func bar<T: P>(_ x: T) -> some P { return x }

class Base {}

func baz<T: Base>(_ x: T) -> some Base { return x }

class Generic<T: Equatable>: P {}

func bazz<T: Equatable>() -> some P { return Generic<T>() }
