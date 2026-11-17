func nestedShadowing() {
    let x = 1
    {
        let x = 2
        {
            let x = 3
            print(x)
        }
        print(x)
    }
    print(x)
}

func initializedBindings() {
    let value: Int = 0
    {
        print(value)
    }
    let inline = 0 { print(0) }
    var observed = 0
    {
        didSet { print(observed) }
    }
    var attributed = 0
    {
        @available(*, deprecated)
        didSet { print(attributed) }
    }
    var computed: Int
    {
        1
    }
    var getSet: Int
    {
        get { 1 }
        set { print(newValue) }
    }
}
