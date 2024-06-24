func bad() {
    let ints = [1,2,3]
    let bytes = ints.withUnsafeBytes{
        return $0
    }
    print(bytes)
}

func good() {
    let ints = [1,2,3]
    let bytes = ints.withUnsafeBytes{
        print($0)
    }
}
