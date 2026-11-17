@objc(renamed:other:)
class Named {
    var value: Int {
        @available(*, deprecated)
        get { return 1 }
        nonmutating set { print(newValue) }
    }
}
let nested: Box<Box<Int>>?? = nil
let key = optional!!.field
