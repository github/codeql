// Provides built-in Swift types

struct Bool { }

struct Int { }

struct String { }

struct Character { }

struct Substring { }

struct Int8 { }

struct Int16 { }

struct Int32 { }

struct Int64 { }

struct UInt { }

struct UInt8 { }

struct UInt16 { }

struct UInt32 { }

struct UInt64 { }

struct Float16 { }

struct Float { }

struct Double { }

struct Float80 { }

struct Array<T> { }

struct Dictionary<Key, Value> { }

struct Set<Element> { }

enum Optional<Wrapped> {
    case none
    case some(Wrapped)
}

enum Result<Success, Failure> {
    case success(Success)
    case failure(Failure)
}

struct Range<Bound> { }

struct ClosedRange<Bound> { }

struct PartialRangeFrom<Bound> { }

struct PartialRangeThrough<Bound> { }

struct PartialRangeUpTo<Bound> { }

enum Never { }

struct UnsafePointer<Pointee> { }

struct UnsafeMutablePointer<Pointee> { }

struct UnsafeRawPointer { }

struct UnsafeMutableRawPointer { }

struct UnsafeBufferPointer<Element> { }

struct UnsafeMutableBufferPointer<Element> { }

struct UnsafeRawBufferPointer { }

struct UnsafeMutableRawBufferPointer { }

struct AutoreleasingUnsafeMutablePointer<Pointee> { }

struct OpaquePointer { }

struct Unmanaged<Instance> { }

struct Function<Args, Return> { } // `Args` is always instantiated as a tuple type

typealias Void = Tuple0

struct Tuple0 {}

struct Tuple1<T0> {
    var _0: T0
}

struct Tuple2<T0, T1> {
    var _0: T0
    var _1: T1
}

struct Tuple3<T0, T1, T2> {
    var _0: T0
    var _1: T1
    var _2: T2
}

struct Tuple4<T0, T1, T2, T3> {
    var _0: T0
    var _1: T1
    var _2: T2
    var _3: T3
}

struct Tuple5<T0, T1, T2, T3, T4> {
    var _0: T0
    var _1: T1
    var _2: T2
    var _3: T3
    var _4: T4
}

struct Tuple6<T0, T1, T2, T3, T4, T5> {
    var _0: T0
    var _1: T1
    var _2: T2
    var _3: T3
    var _4: T4
    var _5: T5
}

struct Tuple7<T0, T1, T2, T3, T4, T5, T6> {
    var _0: T0
    var _1: T1
    var _2: T2
    var _3: T3
    var _4: T4
    var _5: T5
    var _6: T6
}

struct Tuple8<T0, T1, T2, T3, T4, T5, T6, T7> {
    var _0: T0
    var _1: T1
    var _2: T2
    var _3: T3
    var _4: T4
    var _5: T5
    var _6: T6
    var _7: T7
}

struct Tuple9<T0, T1, T2, T3, T4, T5, T6, T7, T8> {
    var _0: T0
    var _1: T1
    var _2: T2
    var _3: T3
    var _4: T4
    var _5: T5
    var _6: T6
    var _7: T7
    var _8: T8
}

struct Tuple10<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9> {
    var _0: T0
    var _1: T1
    var _2: T2
    var _3: T3
    var _4: T4
    var _5: T5
    var _6: T6
    var _7: T7
    var _8: T8
    var _9: T9
}

struct Tuple11<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10> {
    var _0: T0
    var _1: T1
    var _2: T2
    var _3: T3
    var _4: T4
    var _5: T5
    var _6: T6
    var _7: T7
    var _8: T8
    var _9: T9
    var _10: T10
}

struct Tuple12<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11> {
    var _0: T0
    var _1: T1
    var _2: T2
    var _3: T3
    var _4: T4
    var _5: T5
    var _6: T6
    var _7: T7
    var _8: T8
    var _9: T9
    var _10: T10
    var _11: T11
}
