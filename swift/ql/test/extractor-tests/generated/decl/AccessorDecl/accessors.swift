struct Foo {
    var x = 11
    var next : Int {
        get { return x + 1 }
        set(newValue) { x = newValue - 1 }
    }
    var hasWillSet1 : Int {
        willSet(newValue) { }
    }

    var hasWillSet2 : Int {
        willSet { }
    }

    var hasDidSet1 : Int {
        didSet(oldValue) { }
    }

    var hasDidSet2 : Int {
        didSet { }
    }

    var hasBoth : Int {
        willSet { }

        didSet { }
    }
}
