import A
import B

public struct partial_modules {
    public init() {
        let a = A()
        let b = B()
        print(a.text)
        print(b.text)
    }
}
