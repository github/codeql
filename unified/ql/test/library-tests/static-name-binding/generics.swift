enum GenericEnum<T> {
    case novalue
    case value(T)  // $ access=T
}

func testGenericEnum() {
    let intValue = GenericEnum.value(42)  // $ access=GenericEnum access=GenericEnum.value
    let stringValue = GenericEnum<String>.novalue  // $ access=GenericEnum access=String $ MISSING: access=GenericEnum.novalue
}
