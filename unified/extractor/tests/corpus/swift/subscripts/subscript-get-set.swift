struct S {
    var data: [Int]
    subscript(at index: Int, _ other: Int) -> Int {
        get { data[index] }
        nonmutating set(v) { print(v) }
    }
    static subscript<T>(key: T) -> T {
        set { print(newValue) }
        get { key }
    }
}
