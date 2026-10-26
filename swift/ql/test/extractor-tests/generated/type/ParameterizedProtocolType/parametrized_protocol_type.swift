protocol P<One, Two> {
    associatedtype One;
    associatedtype Two;
}

func foo<T: P<Int, String>>(_: T) {}
