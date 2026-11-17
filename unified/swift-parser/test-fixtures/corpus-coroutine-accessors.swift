protocol Controller {
    var controller: (any IUnknown)? { borrow }
    var state: State { borrow mutate }
}
struct Accessors {
    var value: Int {
        borrow { yield storage }
        mutate { yield &storage }
    }
}
