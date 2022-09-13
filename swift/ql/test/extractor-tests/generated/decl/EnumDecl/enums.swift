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
