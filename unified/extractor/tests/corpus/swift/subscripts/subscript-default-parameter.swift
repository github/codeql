struct S {
    subscript(i: Int, j: Int = 0) -> Int {
        get { i + j }
        set { print(newValue) }
    }
}
