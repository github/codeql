struct Foo2 {
    var x = 11
    var borrowedProp: Int {
        read {
            yield x
        }
        modify {
            yield &x
        }
    }
}

//codeql-extractor-options: -enable-experimental-feature CoroutineAccessors
