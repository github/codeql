func run() {
    thread.withLockedValue { thread in
        thread = replacement
    }
    {
        let value = Object()
        use(value)
    }()
    values.map { $0 }.filter { $0 }
    values.map({ $0 }) { value in use(value) }
}
