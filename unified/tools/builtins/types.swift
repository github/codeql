// Provides built-in Swift types

struct Bool {
    public init() {}
}

struct Int {
    public init() {}
}

struct String {
    public init() {}
    public init<T>(_ value: T) where T: LosslessStringConvertible {
        fatalError("Dummy implementation.")
    }
}

struct Character {}

struct Substring {
    public init() {}
}

struct Int8 {
    public init() {}
}

struct Int16 {
    public init() {}
}

struct Int32 {
    public init() {}
}

struct Int64 {
    public init() {}
}

struct UInt {
    public init() {}
}

struct UInt8 {
    public init() {}
}

struct UInt16 {
    public init() {}
}

struct UInt32 {
    public init() {}
}

struct UInt64 {
    public init() {}
}

struct Float16 {
    public init() {}
}

struct Float {
    public init() {}
}

struct Double {
    public init() {}
}

struct Float80 {
    public init() {}
}

struct Array<Element> {
    public init() {}
    public init<S>(_ elements: S) where S: Sequence, Element == S.Element {}
    public init(
        repeating repeatedValue: Element,
        count: Int
    ) {}
    public init<E>(
        unsafeUninitializedCapacity: Int,
        initializingWith initializer: (inout UnsafeMutableBufferPointer<Element>, inout Int)
            throws(E) -> Void
    ) throws(E) where E: Error {}
    public func map<T, E>(_ transform: (Element) throws(E) -> T) throws(E) -> [T]
    where E: Error {
        fatalError("Dummy implementation.")
    }
}

struct Dictionary<Key, Value> {
    public init() {}
    public init(minimumCapacity: Int) {}
    public init<S>(uniqueKeysWithValues keysAndValues: S)
    where S: Sequence, S.Element == (Key, Value) {}
    public init<S, E>(
        _ keysAndValues: S,
        uniquingKeysWith combine: (Value, Value) throws(E) -> Value
    ) throws(E) where S: Sequence, E: Error, S.Element == (Key, Value) {}
    public init<S, E>(
        grouping values: S,
        by keyForValue: (S.Element) throws(E) -> Key
    ) throws(E) where Value == [S.Element], S: Sequence, E: Error {}
}

struct Set<Element> {
    public init() {}
    public init(minimumCapacity: Int) {}
    public init<Source>(_ sequence: Source) where Element == Source.Element, Source: Sequence {}
}

enum Optional<Wrapped> {
    case none
    case some(Wrapped)
}

enum Result<Success, Failure> {
    case success(Success)
    case failure(Failure)
}

struct Range<Bound> {}

struct ClosedRange<Bound> {}

struct PartialRangeFrom<Bound> {}

struct PartialRangeThrough<Bound> {}

struct PartialRangeUpTo<Bound> {}

enum Never {}

struct UnsafePointer<Pointee> {}

struct UnsafeMutablePointer<Pointee> {}

struct UnsafeRawPointer {}

struct UnsafeMutableRawPointer {}

struct UnsafeBufferPointer<Element> {}

struct UnsafeMutableBufferPointer<Element> {}

struct UnsafeRawBufferPointer {}

struct UnsafeMutableRawBufferPointer {}

struct AutoreleasingUnsafeMutablePointer<Pointee> {}

struct OpaquePointer {}

struct Unmanaged<Instance> {}

struct Function<Args, Return> {  // `Args` is always instantiated as a tuple type
    public func callAsFunction(args: Args) -> Return {
        fatalError("Dummy implementation.")
    }
}

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
