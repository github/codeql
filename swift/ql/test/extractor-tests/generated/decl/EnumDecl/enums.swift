enum EnumValues {
    case value1, value2
    case value3, value4, value5
}


enum EnumValuesWithBase : Double {
    case value1, value2
    case value3, value4, value5
}

enum EnumWithParams {
    case nodata1(Void)
    case intdata(Int)
    case tuple(Int, String, Double)
}

enum GenericEnum<T> {
    case none
    case some(T)
}

enum EnumWithNamedParams {
    case nodata1(v: Void)
    case intdata(i: Int)
    case tuple(i: Int, s: String, d: Double)
}
