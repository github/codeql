// Generated from the Swift 6.4.2 standard-library symbol graph (x86_64 macOS).
// Includes compiler intrinsics referenced by the standard library interface.

protocol AdditiveArithmetic: Equatable {
    static var zero: Self { get }
    static func + (lhs: Self, rhs: Self) -> Self
    static func += (lhs: inout Self, rhs: Self)
    static func - (lhs: Self, rhs: Self) -> Self
    static func -= (lhs: inout Self, rhs: Self)
    static func + (x: Self) -> Self
}

@frozen struct AnyBidirectionalCollection<Element> {
    func makeIterator() -> AnyBidirectionalCollection<Element>.Iterator { fatalError() }
    func dropLast(_ n: Int = 1) -> AnyBidirectionalCollection<Element> { fatalError() }
    func prefix(while predicate: (Element) throws -> Bool) rethrows -> AnyBidirectionalCollection<
        Element
    > { fatalError() }
    func suffix(_ maxLength: Int) -> AnyBidirectionalCollection<Element> { fatalError() }
    var underestimatedCount: Int { fatalError() }
    func map<T, E>(_ transform: (Element) throws(E) -> T) throws(E) -> [T] where E: Error {
        fatalError()
    }
    func filter(_ isIncluded: (Element) throws -> Bool) rethrows -> [Element] { fatalError() }
    func forEach(_ body: (Element) throws -> Void) rethrows { fatalError() }
    func drop(while predicate: (Element) throws -> Bool) rethrows -> AnyBidirectionalCollection<
        Element
    > { fatalError() }
    func dropFirst(_ n: Int = 1) -> AnyBidirectionalCollection<Element> { fatalError() }
    func prefix(_ maxLength: Int = 1) -> AnyBidirectionalCollection<Element> { fatalError() }
    typealias Indices = DefaultIndices<AnyBidirectionalCollection<Element>>
    typealias Iterator = AnyIterator<Element>
    typealias Index = AnyIndex
    typealias SubSequence = AnyBidirectionalCollection<Element>
    init<C>(_ base: C) where Element == C.Element, C: BidirectionalCollection { fatalError() }
    init(_ other: AnyBidirectionalCollection<Element>) { fatalError() }
    init<C>(_ base: C) where Element == C.Element, C: RandomAccessCollection { fatalError() }
    init(_ other: AnyRandomAccessCollection<Element>) { fatalError() }
    init?(_ other: AnyCollection<Element>) { fatalError() }
    var startIndex: AnyBidirectionalCollection<Element>.Index { fatalError() }
    var endIndex: AnyBidirectionalCollection<Element>.Index { fatalError() }
    subscript(position: AnyBidirectionalCollection<Element>.Index) -> Element { fatalError() }
    subscript(bounds: Range<AnyBidirectionalCollection<Element>.Index>)
        -> AnyBidirectionalCollection<Element>.SubSequence
    { fatalError() }
    func index(after i: AnyBidirectionalCollection<Element>.Index)
        -> AnyBidirectionalCollection<Element>.Index
    { fatalError() }
    func formIndex(after i: inout AnyBidirectionalCollection<Element>.Index) { fatalError() }
    func index(_ i: AnyBidirectionalCollection<Element>.Index, offsetBy n: Int)
        -> AnyBidirectionalCollection<Element>.Index
    { fatalError() }
    func index(
        _ i: AnyBidirectionalCollection<Element>.Index, offsetBy n: Int,
        limitedBy limit: AnyBidirectionalCollection<Element>.Index
    ) -> AnyBidirectionalCollection<Element>.Index? { fatalError() }
    func formIndex(_ i: inout AnyBidirectionalCollection<Element>.Index, offsetBy n: Int) {
        fatalError()
    }
    func formIndex(
        _ i: inout AnyBidirectionalCollection<Element>.Index, offsetBy n: Int,
        limitedBy limit: AnyBidirectionalCollection<Element>.Index
    ) -> Bool { fatalError() }
    func distance(
        from start: AnyBidirectionalCollection<Element>.Index,
        to end: AnyBidirectionalCollection<Element>.Index
    ) -> Int { fatalError() }
    var count: Int { fatalError() }
    func index(before i: AnyBidirectionalCollection<Element>.Index)
        -> AnyBidirectionalCollection<Element>.Index
    { fatalError() }
    func formIndex(before i: inout AnyBidirectionalCollection<Element>.Index) { fatalError() }
}

@frozen struct AnyCollection<Element> {
    func makeIterator() -> AnyCollection<Element>.Iterator { fatalError() }
    func dropLast(_ n: Int = 1) -> AnyCollection<Element> { fatalError() }
    func prefix(while predicate: (Element) throws -> Bool) rethrows -> AnyCollection<Element> {
        fatalError()
    }
    func suffix(_ maxLength: Int) -> AnyCollection<Element> { fatalError() }
    var underestimatedCount: Int { fatalError() }
    func map<T, E>(_ transform: (Element) throws(E) -> T) throws(E) -> [T] where E: Error {
        fatalError()
    }
    func filter(_ isIncluded: (Element) throws -> Bool) rethrows -> [Element] { fatalError() }
    func forEach(_ body: (Element) throws -> Void) rethrows { fatalError() }
    func drop(while predicate: (Element) throws -> Bool) rethrows -> AnyCollection<Element> {
        fatalError()
    }
    func dropFirst(_ n: Int = 1) -> AnyCollection<Element> { fatalError() }
    func prefix(_ maxLength: Int = 1) -> AnyCollection<Element> { fatalError() }
    typealias Indices = DefaultIndices<AnyCollection<Element>>
    typealias Iterator = AnyIterator<Element>
    typealias Index = AnyIndex
    typealias SubSequence = AnyCollection<Element>
    init<C>(_ base: C) where Element == C.Element, C: Collection { fatalError() }
    init(_ other: AnyCollection<Element>) { fatalError() }
    init<C>(_ base: C) where Element == C.Element, C: BidirectionalCollection { fatalError() }
    init(_ other: AnyBidirectionalCollection<Element>) { fatalError() }
    init<C>(_ base: C) where Element == C.Element, C: RandomAccessCollection { fatalError() }
    init(_ other: AnyRandomAccessCollection<Element>) { fatalError() }
    var startIndex: AnyCollection<Element>.Index { fatalError() }
    var endIndex: AnyCollection<Element>.Index { fatalError() }
    subscript(position: AnyCollection<Element>.Index) -> Element { fatalError() }
    subscript(bounds: Range<AnyCollection<Element>.Index>) -> AnyCollection<Element>.SubSequence {
        fatalError()
    }
    func index(after i: AnyCollection<Element>.Index) -> AnyCollection<Element>.Index {
        fatalError()
    }
    func formIndex(after i: inout AnyCollection<Element>.Index) { fatalError() }
    func index(_ i: AnyCollection<Element>.Index, offsetBy n: Int) -> AnyCollection<Element>.Index {
        fatalError()
    }
    func index(
        _ i: AnyCollection<Element>.Index, offsetBy n: Int,
        limitedBy limit: AnyCollection<Element>.Index
    ) -> AnyCollection<Element>.Index? { fatalError() }
    func formIndex(_ i: inout AnyCollection<Element>.Index, offsetBy n: Int) { fatalError() }
    func formIndex(
        _ i: inout AnyCollection<Element>.Index, offsetBy n: Int,
        limitedBy limit: AnyCollection<Element>.Index
    ) -> Bool { fatalError() }
    func distance(from start: AnyCollection<Element>.Index, to end: AnyCollection<Element>.Index)
        -> Int
    { fatalError() }
    var count: Int { fatalError() }
}

@frozen struct AnyHashable {
    init<H>(_ base: H) where H: Hashable { fatalError() }
    var base: Any { fatalError() }
    static func == (lhs: AnyHashable, rhs: AnyHashable) -> Bool { fatalError() }
    var hashValue: Int { fatalError() }
    func hash(into hasher: inout Hasher) { fatalError() }
    var description: String { fatalError() }
    var debugDescription: String { fatalError() }
    var customMirror: Mirror { fatalError() }
}

@frozen struct AnyIndex {
    init<BaseIndex>(_ base: BaseIndex) where BaseIndex: Comparable { fatalError() }
    static func == (lhs: AnyIndex, rhs: AnyIndex) -> Bool { fatalError() }
    static func < (lhs: AnyIndex, rhs: AnyIndex) -> Bool { fatalError() }
}

@frozen struct AnyIterator<Element> {
    init<I>(_ base: I) where Element == I.Element, I: IteratorProtocol { fatalError() }
    init(_ body: @escaping () -> Element?) { fatalError() }
    func next() -> Element? { fatalError() }
    typealias Iterator = AnyIterator<Element>
}

class AnyKeyPath {
    func appending(path: AnyKeyPath) -> AnyKeyPath? { fatalError() }
    static var rootType: any Any.Type { fatalError() }
    static var valueType: any Any.Type { fatalError() }
    final var hashValue: Int { fatalError() }
    final func hash(into hasher: inout Hasher) { fatalError() }
    static func == (a: AnyKeyPath, b: AnyKeyPath) -> Bool { fatalError() }
    var debugDescription: String { fatalError() }
}

@frozen struct AnyRandomAccessCollection<Element> {
    func makeIterator() -> AnyRandomAccessCollection<Element>.Iterator { fatalError() }
    func dropLast(_ n: Int = 1) -> AnyRandomAccessCollection<Element> { fatalError() }
    func prefix(while predicate: (Element) throws -> Bool) rethrows -> AnyRandomAccessCollection<
        Element
    > { fatalError() }
    func suffix(_ maxLength: Int) -> AnyRandomAccessCollection<Element> { fatalError() }
    var underestimatedCount: Int { fatalError() }
    func map<T, E>(_ transform: (Element) throws(E) -> T) throws(E) -> [T] where E: Error {
        fatalError()
    }
    func filter(_ isIncluded: (Element) throws -> Bool) rethrows -> [Element] { fatalError() }
    func forEach(_ body: (Element) throws -> Void) rethrows { fatalError() }
    func drop(while predicate: (Element) throws -> Bool) rethrows -> AnyRandomAccessCollection<
        Element
    > { fatalError() }
    func dropFirst(_ n: Int = 1) -> AnyRandomAccessCollection<Element> { fatalError() }
    func prefix(_ maxLength: Int = 1) -> AnyRandomAccessCollection<Element> { fatalError() }
    typealias Indices = DefaultIndices<AnyRandomAccessCollection<Element>>
    typealias Iterator = AnyIterator<Element>
    typealias Index = AnyIndex
    typealias SubSequence = AnyRandomAccessCollection<Element>
    init<C>(_ base: C) where Element == C.Element, C: RandomAccessCollection { fatalError() }
    init(_ other: AnyRandomAccessCollection<Element>) { fatalError() }
    init?(_ other: AnyCollection<Element>) { fatalError() }
    init?(_ other: AnyBidirectionalCollection<Element>) { fatalError() }
    var startIndex: AnyRandomAccessCollection<Element>.Index { fatalError() }
    var endIndex: AnyRandomAccessCollection<Element>.Index { fatalError() }
    subscript(position: AnyRandomAccessCollection<Element>.Index) -> Element { fatalError() }
    subscript(bounds: Range<AnyRandomAccessCollection<Element>.Index>)
        -> AnyRandomAccessCollection<Element>.SubSequence
    { fatalError() }
    func index(after i: AnyRandomAccessCollection<Element>.Index)
        -> AnyRandomAccessCollection<Element>.Index
    { fatalError() }
    func formIndex(after i: inout AnyRandomAccessCollection<Element>.Index) { fatalError() }
    func index(_ i: AnyRandomAccessCollection<Element>.Index, offsetBy n: Int)
        -> AnyRandomAccessCollection<Element>.Index
    { fatalError() }
    func index(
        _ i: AnyRandomAccessCollection<Element>.Index, offsetBy n: Int,
        limitedBy limit: AnyRandomAccessCollection<Element>.Index
    ) -> AnyRandomAccessCollection<Element>.Index? { fatalError() }
    func formIndex(_ i: inout AnyRandomAccessCollection<Element>.Index, offsetBy n: Int) {
        fatalError()
    }
    func formIndex(
        _ i: inout AnyRandomAccessCollection<Element>.Index, offsetBy n: Int,
        limitedBy limit: AnyRandomAccessCollection<Element>.Index
    ) -> Bool { fatalError() }
    func distance(
        from start: AnyRandomAccessCollection<Element>.Index,
        to end: AnyRandomAccessCollection<Element>.Index
    ) -> Int { fatalError() }
    var count: Int { fatalError() }
    func index(before i: AnyRandomAccessCollection<Element>.Index)
        -> AnyRandomAccessCollection<Element>.Index
    { fatalError() }
    func formIndex(before i: inout AnyRandomAccessCollection<Element>.Index) { fatalError() }
}

@frozen struct AnySequence<Element> {
    init<I>(_ makeUnderlyingIterator: @escaping () -> I)
    where Element == I.Element, I: IteratorProtocol { fatalError() }
    typealias Iterator = AnyIterator<Element>
    init<S>(_ base: S) where Element == S.Element, S: Sequence { fatalError() }
    func makeIterator() -> AnySequence<Element>.Iterator { fatalError() }
    func dropLast(_ n: Int = 1) -> [Element] { fatalError() }
    func prefix(while predicate: (Element) throws -> Bool) rethrows -> [Element] { fatalError() }
    func suffix(_ maxLength: Int) -> [Element] { fatalError() }
    var underestimatedCount: Int { fatalError() }
    func map<T, E>(_ transform: (Element) throws(E) -> T) throws(E) -> [T] where E: Error {
        fatalError()
    }
    func filter(_ isIncluded: (Element) throws -> Bool) rethrows -> [Element] { fatalError() }
    func forEach(_ body: (Element) throws -> Void) rethrows { fatalError() }
    func drop(while predicate: (Element) throws -> Bool) rethrows -> AnySequence<Element> {
        fatalError()
    }
    func dropFirst(_ n: Int = 1) -> AnySequence<Element> { fatalError() }
    func prefix(_ maxLength: Int = 1) -> AnySequence<Element> { fatalError() }
}

@frozen struct Array<Element> {
    var capacity: Int { fatalError() }
    typealias Index = Int
    typealias Indices = Range<Int>
    typealias Iterator = IndexingIterator<[Element]>
    var startIndex: Int { fatalError() }
    var endIndex: Int { fatalError() }
    func index(after i: Int) -> Int { fatalError() }
    func formIndex(after i: inout Int) { fatalError() }
    func index(before i: Int) -> Int { fatalError() }
    func formIndex(before i: inout Int) { fatalError() }
    func index(_ i: Int, offsetBy distance: Int) -> Int { fatalError() }
    func index(_ i: Int, offsetBy distance: Int, limitedBy limit: Int) -> Int? { fatalError() }
    func distance(from start: Int, to end: Int) -> Int { fatalError() }
    subscript(index: Int) -> Element { fatalError() }
    subscript(bounds: Range<Int>) -> ArraySlice<Element> { fatalError() }
    var count: Int { fatalError() }
    typealias SubSequence = ArraySlice<Element>
    init(arrayLiteral elements: Element...) { fatalError() }
    typealias ArrayLiteralElement = Element
    init() { fatalError() }
    init<S>(_ s: S) where Element == S.Element, S: Sequence { fatalError() }
    init(repeating repeatedValue: Element, count: Int) { fatalError() }
    mutating func reserveCapacity(_ minimumCapacity: Int) { fatalError() }
    mutating func append(_ newElement: Element) { fatalError() }
    mutating func append<S>(contentsOf newElements: S) where Element == S.Element, S: Sequence {
        fatalError()
    }
    @discardableResult mutating func remove(at index: Int) -> Element { fatalError() }
    mutating func insert(_ newElement: Element, at i: Int) { fatalError() }
    mutating func removeAll(keepingCapacity keepCapacity: Bool = false) { fatalError() }
    mutating func withContiguousMutableStorageIfAvailable<R>(
        _ body: (inout UnsafeMutableBufferPointer<Element>) throws -> R
    ) rethrows -> R? { fatalError() }
    func withContiguousStorageIfAvailable<R>(_ body: (UnsafeBufferPointer<Element>) throws -> R)
        rethrows -> R?
    { fatalError() }
    static func + (lhs: [Element], rhs: [Element]) -> [Element] { fatalError() }
    static func += (lhs: inout [Element], rhs: [Element]) { fatalError() }
    var customMirror: Mirror { fatalError() }
    var description: String { fatalError() }
    var debugDescription: String { fatalError() }
    init<E>(
        unsafeUninitializedCapacity: Int,
        initializingWith initializer: (inout UnsafeMutableBufferPointer<Element>, inout Int)
            throws(E) -> Void
    ) throws(E) where E: Error { fatalError() }
    init<E>(
        capacity: Int, initializingWith initializer: (inout OutputSpan<Element>) throws(E) -> Void
    ) throws(E) where E: Error { fatalError() }
    mutating func append<E>(
        addingCapacity uninitializedCount: Int,
        initializingWith initializer: (inout OutputSpan<Element>) throws(E) -> Void
    ) throws(E) where E: Error { fatalError() }
    func withUnsafeBufferPointer<R, E>(_ body: (UnsafeBufferPointer<Element>) throws(E) -> R)
        throws(E) -> R where E: Error
    { fatalError() }
    var span: Span<Element> { fatalError() }
    mutating func withUnsafeMutableBufferPointer<R, E>(
        _ body: (inout UnsafeMutableBufferPointer<Element>) throws(E) -> R
    ) throws(E) -> R where E: Error { fatalError() }
    var mutableSpan: MutableSpan<Element> { fatalError() }
    mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C)
    where Element == C.Element, C: Collection { fatalError() }
    static func == (lhs: [Element], rhs: [Element]) -> Bool { fatalError() }
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    mutating func withUnsafeMutableBytes<R>(_ body: (UnsafeMutableRawBufferPointer) throws -> R)
        rethrows -> R
    { fatalError() }
    func withUnsafeBytes<R>(_ body: (UnsafeRawBufferPointer) throws -> R) rethrows -> R {
        fatalError()
    }
    func isTriviallyIdentical(to other: [Element]) -> Bool { fatalError() }
    func encode(to encoder: any Encoder) throws { fatalError() }
    init(from decoder: any Decoder) throws { fatalError() }
}

@frozen struct ArraySlice<Element> {
    var capacity: Int { fatalError() }
    typealias Index = Int
    typealias Indices = Range<Int>
    typealias Iterator = IndexingIterator<ArraySlice<Element>>
    var startIndex: Int { fatalError() }
    var endIndex: Int { fatalError() }
    func index(after i: Int) -> Int { fatalError() }
    func formIndex(after i: inout Int) { fatalError() }
    func index(before i: Int) -> Int { fatalError() }
    func formIndex(before i: inout Int) { fatalError() }
    func index(_ i: Int, offsetBy distance: Int) -> Int { fatalError() }
    func index(_ i: Int, offsetBy distance: Int, limitedBy limit: Int) -> Int? { fatalError() }
    func distance(from start: Int, to end: Int) -> Int { fatalError() }
    subscript(index: Int) -> Element { fatalError() }
    subscript(bounds: Range<Int>) -> ArraySlice<Element> { fatalError() }
    var count: Int { fatalError() }
    typealias SubSequence = ArraySlice<Element>
    init(arrayLiteral elements: Element...) { fatalError() }
    typealias ArrayLiteralElement = Element
    init() { fatalError() }
    init<S>(_ s: S) where Element == S.Element, S: Sequence { fatalError() }
    init(repeating repeatedValue: Element, count: Int) { fatalError() }
    mutating func reserveCapacity(_ minimumCapacity: Int) { fatalError() }
    mutating func append(_ newElement: Element) { fatalError() }
    mutating func append<S>(contentsOf newElements: S) where Element == S.Element, S: Sequence {
        fatalError()
    }
    @discardableResult mutating func remove(at index: Int) -> Element { fatalError() }
    mutating func insert(_ newElement: Element, at i: Int) { fatalError() }
    mutating func removeAll(keepingCapacity keepCapacity: Bool = false) { fatalError() }
    mutating func withContiguousMutableStorageIfAvailable<R>(
        _ body: (inout UnsafeMutableBufferPointer<Element>) throws -> R
    ) rethrows -> R? { fatalError() }
    func withContiguousStorageIfAvailable<R>(_ body: (UnsafeBufferPointer<Element>) throws -> R)
        rethrows -> R?
    { fatalError() }
    var customMirror: Mirror { fatalError() }
    var description: String { fatalError() }
    var debugDescription: String { fatalError() }
    func withUnsafeBufferPointer<R, E>(_ body: (UnsafeBufferPointer<Element>) throws(E) -> R)
        throws(E) -> R where E: Error
    { fatalError() }
    var span: Span<Element> { fatalError() }
    mutating func withUnsafeMutableBufferPointer<R, E>(
        _ body: (inout UnsafeMutableBufferPointer<Element>) throws(E) -> R
    ) throws(E) -> R where E: Error { fatalError() }
    var mutableSpan: MutableSpan<Element> { fatalError() }
    mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C)
    where Element == C.Element, C: Collection { fatalError() }
    static func == (lhs: ArraySlice<Element>, rhs: ArraySlice<Element>) -> Bool { fatalError() }
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    mutating func withUnsafeMutableBytes<R>(_ body: (UnsafeMutableRawBufferPointer) throws -> R)
        rethrows -> R
    { fatalError() }
    func withUnsafeBytes<R>(_ body: (UnsafeRawBufferPointer) throws -> R) rethrows -> R {
        fatalError()
    }
    func isTriviallyIdentical(to other: ArraySlice<Element>) -> Bool { fatalError() }
}

@frozen struct AutoreleasingUnsafeMutablePointer<Pointee> {
    init(_ from: OpaquePointer) { fatalError() }
    init?(_ from: OpaquePointer?) { fatalError() }
    init?(bitPattern: Int) { fatalError() }
    init?(bitPattern: UInt) { fatalError() }
    init(_ other: Self) { fatalError() }
    init?(_ other: Self?) { fatalError() }
    static func == (lhs: Self, rhs: Self) -> Bool { fatalError() }
    static func == <Other>(lhs: Self, rhs: Other) -> Bool where Other: _Pointer { fatalError() }
    static func != <Other>(lhs: Self, rhs: Other) -> Bool where Other: _Pointer { fatalError() }
    static func < (lhs: Self, rhs: Self) -> Bool { fatalError() }
    static func < <Other>(lhs: Self, rhs: Other) -> Bool where Other: _Pointer { fatalError() }
    static func <= <Other>(lhs: Self, rhs: Other) -> Bool where Other: _Pointer { fatalError() }
    static func > <Other>(lhs: Self, rhs: Other) -> Bool where Other: _Pointer { fatalError() }
    static func >= <Other>(lhs: Self, rhs: Other) -> Bool where Other: _Pointer { fatalError() }
    func successor() -> Self { fatalError() }
    func predecessor() -> Self { fatalError() }
    func distance(to end: Self) -> Int { fatalError() }
    func advanced(by n: Int) -> Self { fatalError() }
    var debugDescription: String { fatalError() }
    var pointee: Pointee { fatalError() }
    subscript(i: Int) -> Pointee { fatalError() }
    init<U>(_ from: UnsafeMutablePointer<U>) { fatalError() }
    init?<U>(_ from: UnsafeMutablePointer<U>?) { fatalError() }
    typealias Stride = Int
    var hashValue: Int { fatalError() }
}

protocol BidirectionalCollection<Element>: Collection
where Self.Indices: BidirectionalCollection, Self.SubSequence: BidirectionalCollection {
    associatedtype Element
    associatedtype Index
    associatedtype SubSequence
    associatedtype Indices
    func index(before i: Self.Index) -> Self.Index
    func formIndex(before i: inout Self.Index)
    override func index(after i: Self.Index) -> Self.Index
    override func formIndex(after i: inout Self.Index)
    func index(_ i: Self.Index, offsetBy distance: Int) -> Self.Index
    func index(_ i: Self.Index, offsetBy distance: Int, limitedBy limit: Self.Index) -> Self.Index?
    func distance(from start: Self.Index, to end: Self.Index) -> Int
    override var indices: Self.Indices { get }
    override subscript(bounds: Range<Self.Index>) -> Self.SubSequence { get }
    override subscript(position: Self.Index) -> Self.Element { get }
    override var startIndex: Self.Index { get }
    override var endIndex: Self.Index { get }
    mutating func popLast() -> Self.Element?
    @discardableResult mutating func removeLast() -> Self.Element
    mutating func removeLast(_ k: Int)
    func dropLast(_ k: Int) -> Self.SubSequence
    func suffix(_ maxLength: Int) -> Self.SubSequence
    var last: Self.Element? { get }
    func last(where predicate: (Self.Element) throws -> Bool) rethrows -> Self.Element?
    func lastIndex(where predicate: (Self.Element) throws -> Bool) rethrows -> Self.Index?
    func lastIndex(of element: Self.Element) -> Self.Index?
    func reversed() -> ReversedCollection<Self>
    func joined(separator: String) -> String
    func difference<C>(from other: C, by areEquivalent: (C.Element, Self.Element) -> Bool)
        -> CollectionDifference<Self.Element>
    where C: BidirectionalCollection, Self.Element == C.Element
    func difference<C>(from other: C) -> CollectionDifference<Self.Element>
    where C: BidirectionalCollection, Self.Element == C.Element
}

protocol BinaryFloatingPoint: ExpressibleByFloatLiteral, FloatingPoint {
    associatedtype RawSignificand: UnsignedInteger
    associatedtype RawExponent: UnsignedInteger
    init(
        sign: FloatingPointSign, exponentBitPattern: Self.RawExponent,
        significandBitPattern: Self.RawSignificand)
    init(_ value: Float)
    init(_ value: Double)
    init(_ value: Float80)
    init<Source>(_ value: Source) where Source: BinaryFloatingPoint
    init?<Source>(exactly value: Source) where Source: BinaryFloatingPoint
    static var exponentBitCount: Int { get }
    static var significandBitCount: Int { get }
    var exponentBitPattern: Self.RawExponent { get }
    var significandBitPattern: Self.RawSignificand { get }
    var binade: Self { get }
    var significandWidth: Int { get }
    static var radix: Int { get }
    init(signOf: Self, magnitudeOf: Self)
    func isTotallyOrdered(belowOrEqualTo other: Self) -> Bool
    init<Source>(_ value: Source) where Source: BinaryInteger
    init?<Source>(exactly value: Source) where Source: BinaryInteger
    static func random<T>(in range: Range<Self>, using generator: inout T) -> Self
    where T: RandomNumberGenerator
    static func random(in range: Range<Self>) -> Self
    static func random<T>(in range: ClosedRange<Self>, using generator: inout T) -> Self
    where T: RandomNumberGenerator
    static func random(in range: ClosedRange<Self>) -> Self
}

protocol BinaryInteger: CustomStringConvertible, Hashable, Numeric, Strideable
where Self.Magnitude: BinaryInteger, Self.Magnitude == Self.Magnitude.Magnitude {
    static var isSigned: Bool { get }
    init?<T>(exactly source: T) where T: BinaryFloatingPoint
    init<T>(_ source: T) where T: BinaryFloatingPoint
    init<T>(_ source: T) where T: BinaryInteger
    init<T>(truncatingIfNeeded source: T) where T: BinaryInteger
    init<T>(clamping source: T) where T: BinaryInteger
    associatedtype Words: RandomAccessCollection
    where Self.Words.Element == UInt, Self.Words.Index == Int
    var words: Self.Words { get }
    var bitWidth: Int { get }
    var trailingZeroBitCount: Int { get }
    static func / (lhs: Self, rhs: Self) -> Self
    static func /= (lhs: inout Self, rhs: Self)
    static func % (lhs: Self, rhs: Self) -> Self
    static func %= (lhs: inout Self, rhs: Self)
    override static func + (lhs: Self, rhs: Self) -> Self
    override static func += (lhs: inout Self, rhs: Self)
    override static func - (lhs: Self, rhs: Self) -> Self
    override static func -= (lhs: inout Self, rhs: Self)
    override static func * (lhs: Self, rhs: Self) -> Self
    override static func *= (lhs: inout Self, rhs: Self)
    static func ~ (x: Self) -> Self
    static func & (lhs: Self, rhs: Self) -> Self
    static func &= (lhs: inout Self, rhs: Self)
    static func | (lhs: Self, rhs: Self) -> Self
    static func |= (lhs: inout Self, rhs: Self)
    static func ^ (lhs: Self, rhs: Self) -> Self
    static func ^= (lhs: inout Self, rhs: Self)
    static func >> <RHS>(lhs: Self, rhs: RHS) -> Self where RHS: BinaryInteger
    static func >>= <RHS>(lhs: inout Self, rhs: RHS) where RHS: BinaryInteger
    static func << <RHS>(lhs: Self, rhs: RHS) -> Self where RHS: BinaryInteger
    static func <<= <RHS>(lhs: inout Self, rhs: RHS) where RHS: BinaryInteger
    func quotientAndRemainder(dividingBy rhs: Self) -> (quotient: Self, remainder: Self)
    func isMultiple(of other: Self) -> Bool
    func signum() -> Self
    init()
    var description: String { get }
    func distance(to other: Self) -> Int
    func advanced(by n: Int) -> Self
    static func == <Other>(lhs: Self, rhs: Other) -> Bool where Other: BinaryInteger
    static func != <Other>(lhs: Self, rhs: Other) -> Bool where Other: BinaryInteger
    static func < <Other>(lhs: Self, rhs: Other) -> Bool where Other: BinaryInteger
    static func <= <Other>(lhs: Self, rhs: Other) -> Bool where Other: BinaryInteger
    static func >= <Other>(lhs: Self, rhs: Other) -> Bool where Other: BinaryInteger
    static func > <Other>(lhs: Self, rhs: Other) -> Bool where Other: BinaryInteger
    static func != (lhs: Self, rhs: Self) -> Bool
    static func <= (lhs: Self, rhs: Self) -> Bool
    static func >= (lhs: Self, rhs: Self) -> Bool
    static func > (lhs: Self, rhs: Self) -> Bool
}

protocol BitwiseCopyable: ~Escapable {
}

@frozen struct Bool {
    init() { fatalError() }
    init(_ value: Bool) { fatalError() }
    static func random<T>(using generator: inout T) -> Bool where T: RandomNumberGenerator {
        fatalError()
    }
    static func random() -> Bool { fatalError() }
    init(booleanLiteral value: Bool) { fatalError() }
    typealias BooleanLiteralType = Bool
    var description: String { fatalError() }
    static func == (lhs: Bool, rhs: Bool) -> Bool { fatalError() }
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    init?(_ description: String) { fatalError() }
    static func ! (a: Bool) -> Bool { fatalError() }
    static func && (lhs: Bool, rhs: @autoclosure () throws -> Bool) rethrows -> Bool {
        fatalError()
    }
    static func || (lhs: Bool, rhs: @autoclosure () throws -> Bool) rethrows -> Bool {
        fatalError()
    }
    mutating func toggle() { fatalError() }
    init(from decoder: any Decoder) throws { fatalError() }
    func encode(to encoder: any Encoder) throws { fatalError() }
    var customMirror: Mirror { fatalError() }
    var customPlaygroundQuickLook: _PlaygroundQuickLook { fatalError() }
}

@frozen struct BorrowingIteratorAdapter<Iterator> where Iterator: IteratorProtocol {
    typealias Element = Iterator.Element
    typealias Failure = Never
    init(iterator: Iterator) { fatalError() }
    mutating func nextSpan(maxCount: Int) -> Span<Iterator.Element> { fatalError() }
}

protocol BorrowingIteratorProtocol<Element, Failure>: ~Copyable, ~Escapable {
    associatedtype Element: ~Copyable
    associatedtype Failure: Error = Never
    mutating func nextSpan(maxCount: Int) throws(Self.Failure) -> Span<Self.Element>
    mutating func skip(by maxOffset: Int) throws(Self.Failure) -> Int
    @export(implementation) mutating func nextSpan() throws(Self.Failure) -> Span<Self.Element>
    @export(implementation) mutating func skip(by offset: Int) throws(Self.Failure) -> Int
}

@frozen enum ByteOrder {
    case bigEndian
    case littleEndian
    static var native: ByteOrder { fatalError() }
    static func == (a: ByteOrder, b: ByteOrder) -> Bool { fatalError() }
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
}

@frozen struct CVaListPointer {
    var debugDescription: String { fatalError() }
}

protocol CVarArg {
}

protocol CaseIterable {
    associatedtype AllCases: Collection = [Self] where Self == Self.AllCases.Element
    static var allCases: Self.AllCases { get }
}

@frozen struct Character {
    typealias UTF8View = String.UTF8View
    var utf8: Character.UTF8View { fatalError() }
    typealias UTF16View = String.UTF16View
    var utf16: Character.UTF16View { fatalError() }
    typealias UnicodeScalarView = String.UnicodeScalarView
    var unicodeScalars: Character.UnicodeScalarView { fatalError() }
    init(_ content: Unicode.Scalar) { fatalError() }
    init(extendedGraphemeClusterLiteral value: Character) { fatalError() }
    init(_ s: String) { fatalError() }
    typealias ExtendedGraphemeClusterLiteralType = Character
    typealias UnicodeScalarLiteralType = Character
    var description: String { fatalError() }
    var debugDescription: String { fatalError() }
    static func == (lhs: Character, rhs: Character) -> Bool { fatalError() }
    static func < (lhs: Character, rhs: Character) -> Bool { fatalError() }
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    var customMirror: Mirror { fatalError() }
    var customPlaygroundQuickLook: _PlaygroundQuickLook { fatalError() }
    func write<Target>(to target: inout Target) where Target: TextOutputStream { fatalError() }
    var isASCII: Bool { fatalError() }
    var asciiValue: UInt8? { fatalError() }
    var isWhitespace: Bool { fatalError() }
    var isNewline: Bool { fatalError() }
    var isNumber: Bool { fatalError() }
    var isWholeNumber: Bool { fatalError() }
    var wholeNumberValue: Int? { fatalError() }
    var isHexDigit: Bool { fatalError() }
    var hexDigitValue: Int? { fatalError() }
    var isLetter: Bool { fatalError() }
    func uppercased() -> String { fatalError() }
    func lowercased() -> String { fatalError() }
    var isUppercase: Bool { fatalError() }
    var isLowercase: Bool { fatalError() }
    var isCased: Bool { fatalError() }
    var isSymbol: Bool { fatalError() }
    var isMathSymbol: Bool { fatalError() }
    var isCurrencySymbol: Bool { fatalError() }
    var isPunctuation: Bool { fatalError() }
}

@frozen struct ClosedRange<Bound> where Bound: Comparable {
    var lowerBound: Bound { fatalError() }
    var upperBound: Bound { fatalError() }
    init(uncheckedBounds bounds: (lower: Bound, upper: Bound)) { fatalError() }
    var isEmpty: Bool { fatalError() }
    func relative<C>(to collection: C) -> Range<Bound> where Bound == C.Index, C: Collection {
        fatalError()
    }
    func contains(_ element: Bound) -> Bool { fatalError() }
    typealias Element = Bound
    typealias Iterator = IndexingIterator<ClosedRange<Bound>>
    typealias SubSequence = Slice<ClosedRange<Bound>>
    var startIndex: ClosedRange<Bound>.Index { fatalError() }
    var endIndex: ClosedRange<Bound>.Index { fatalError() }
    func index(after i: ClosedRange<Bound>.Index) -> ClosedRange<Bound>.Index { fatalError() }
    func index(before i: ClosedRange<Bound>.Index) -> ClosedRange<Bound>.Index { fatalError() }
    func index(_ i: ClosedRange<Bound>.Index, offsetBy distance: Int) -> ClosedRange<Bound>.Index {
        fatalError()
    }
    func distance(from start: ClosedRange<Bound>.Index, to end: ClosedRange<Bound>.Index) -> Int {
        fatalError()
    }
    subscript(position: ClosedRange<Bound>.Index) -> Bound { fatalError() }
    subscript(bounds: Range<ClosedRange<Bound>.Index>) -> Slice<ClosedRange<Bound>> { fatalError() }
    func contains(_ other: Range<Bound>) -> Bool { fatalError() }
    typealias Indices = DefaultIndices<ClosedRange<Bound>>
    func contains(_ other: ClosedRange<Bound>) -> Bool { fatalError() }
    static func == (lhs: ClosedRange<Bound>, rhs: ClosedRange<Bound>) -> Bool { fatalError() }
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    var description: String { fatalError() }
    var debugDescription: String { fatalError() }
    var customMirror: Mirror { fatalError() }
    func clamped(to limits: ClosedRange<Bound>) -> ClosedRange<Bound> { fatalError() }
    init(_ other: Range<Bound>) { fatalError() }
    func overlaps(_ other: ClosedRange<Bound>) -> Bool { fatalError() }
    func overlaps(_ other: Range<Bound>) -> Bool { fatalError() }
    init(from decoder: any Decoder) throws { fatalError() }
    func encode(to encoder: any Encoder) throws { fatalError() }
    init(_ other: ClosedRange<Bound>) { fatalError() }
    @frozen enum Index {
        case pastEnd
        case inRange(Bound)
        static func == (lhs: ClosedRange<Bound>.Index, rhs: ClosedRange<Bound>.Index) -> Bool {
            fatalError()
        }
        static func < (lhs: ClosedRange<Bound>.Index, rhs: ClosedRange<Bound>.Index) -> Bool {
            fatalError()
        }
        func hash(into hasher: inout Hasher) { fatalError() }
        var hashValue: Int { fatalError() }
    }
}

protocol CodingKey: CustomDebugStringConvertible, CustomStringConvertible, Sendable {
    var stringValue: String { get }
    init?(stringValue: String)
    var intValue: Int? { get }
    init?(intValue: Int)
    var description: String { get }
    var debugDescription: String { get }
}

protocol CodingKeyRepresentable {
    var codingKey: any CodingKey { get }
    init?<T>(codingKey: T) where T: CodingKey
}

struct CodingUserInfoKey {
    typealias RawValue = String
    var rawValue: String { fatalError() }
    init?(rawValue: String) { fatalError() }
    static func == (lhs: CodingUserInfoKey, rhs: CodingUserInfoKey) -> Bool { fatalError() }
    var hashValue: Int { fatalError() }
    func hash(into hasher: inout Hasher) { fatalError() }
}

protocol Collection<Element>: Sequence {
    @export(implementation) var underestimatedCount: Int { get }
    typealias IndexDistance = Int
    associatedtype Element
    associatedtype Index: Comparable
    where
        Self.Index == Self.Indices.Element, Self.Indices.Element == Self.Indices.Index,
        Self.Indices.Index == Self.SubSequence.Index
    var startIndex: Self.Index { get }
    var endIndex: Self.Index { get }
    associatedtype Iterator = IndexingIterator<Self>
    override func makeIterator() -> Self.Iterator
    associatedtype SubSequence: Collection = Slice<Self>
    where Self.Element == Self.SubSequence.Element, Self.SubSequence == Self.SubSequence.SubSequence
    subscript(position: Self.Index) -> Self.Element { get }
    subscript(bounds: Range<Self.Index>) -> Self.SubSequence { get }
    associatedtype Indices: Collection = DefaultIndices<Self>
    where Self.Indices == Self.Indices.SubSequence
    var indices: Self.Indices { get }
    var isEmpty: Bool { get }
    var count: Int { get }
    func index(_ i: Self.Index, offsetBy distance: Int) -> Self.Index
    func index(_ i: Self.Index, offsetBy distance: Int, limitedBy limit: Self.Index) -> Self.Index?
    func distance(from start: Self.Index, to end: Self.Index) -> Int
    func index(after i: Self.Index) -> Self.Index
    func formIndex(after i: inout Self.Index)
    func formIndex(_ i: inout Self.Index, offsetBy distance: Int)
    func formIndex(_ i: inout Self.Index, offsetBy distance: Int, limitedBy limit: Self.Index)
        -> Bool
    func randomElement<T>(using generator: inout T) -> Self.Element? where T: RandomNumberGenerator
    func randomElement() -> Self.Element?
    func makeIterator() -> IndexingIterator<Self>
    subscript(bounds: Range<Self.Index>) -> Slice<Self> { get }
    mutating func popFirst() -> Self.Element?
    var first: Self.Element? { get }
    var underestimatedCount: Int { get }
    func map<T, E>(_ transform: (Self.Element) throws(E) -> T) throws(E) -> [T] where E: Error
    func dropFirst(_ k: Int) -> Self.SubSequence
    func dropLast(_ k: Int) -> Self.SubSequence
    func drop(while predicate: (Self.Element) throws -> Bool) rethrows -> Self.SubSequence
    func prefix(_ maxLength: Int) -> Self.SubSequence
    func prefix(while predicate: (Self.Element) throws -> Bool) rethrows -> Self.SubSequence
    func suffix(_ maxLength: Int) -> Self.SubSequence
    func prefix(upTo end: Self.Index) -> Self.SubSequence
    func suffix(from start: Self.Index) -> Self.SubSequence
    func prefix(through position: Self.Index) -> Self.SubSequence
    func split(
        maxSplits: Int, omittingEmptySubsequences: Bool,
        whereSeparator isSeparator: (Self.Element) throws -> Bool
    ) rethrows -> [Self.SubSequence]
    func split(separator: Self.Element, maxSplits: Int, omittingEmptySubsequences: Bool) -> [Self
        .SubSequence]
    @discardableResult mutating func removeFirst() -> Self.Element
    mutating func removeFirst(_ k: Int)
    func firstIndex(of element: Self.Element) -> Self.Index?
    func firstIndex(where predicate: (Self.Element) throws -> Bool) rethrows -> Self.Index?
    func indices(where predicate: (Self.Element) throws -> Bool) rethrows -> RangeSet<Self.Index>
    func indices(of element: Self.Element) -> RangeSet<Self.Index>
    subscript(subranges: RangeSet<Self.Index>) -> DiscontiguousSlice<Self> { get }
    func removingSubranges(_ subranges: RangeSet<Self.Index>) -> DiscontiguousSlice<Self>
    var indices: DefaultIndices<Self> { get }
    subscript<R>(r: R) -> Self.SubSequence where R: RangeExpression, Self.Index == R.Bound { get }
    subscript(x: UnboundedRange) -> Self.SubSequence { get }
    func index<T>(_ i: Self.Index, offsetBy n: T) -> Self.Index where T: BinaryInteger
    func formIndex<T>(_ i: inout Self.Index, offsetBy n: T) where T: BinaryInteger
    func index<T>(_ i: Self.Index, offsetBy n: T, limitedBy limit: Self.Index) -> Self.Index?
    where T: BinaryInteger
    func formIndex<T>(_ i: inout Self.Index, offsetBy n: T, limitedBy limit: Self.Index) -> Bool
    where T: BinaryInteger
    func distance<T>(from start: Self.Index, to end: Self.Index) -> T where T: BinaryInteger
    func flatMap(_ transform: (Self.Element) throws -> String?) rethrows -> [String]
    func index(of element: Self.Element) -> Self.Index?
}

struct CollectionDifference<ChangeElement> {
    var insertions: [CollectionDifference<ChangeElement>.Change] { fatalError() }
    var removals: [CollectionDifference<ChangeElement>.Change] { fatalError() }
    init?<Changes>(_ changes: Changes)
    where Changes: Collection, Changes.Element == CollectionDifference<ChangeElement>.Change {
        fatalError()
    }
    func inverse() -> CollectionDifference<ChangeElement> { fatalError() }
    typealias Element = CollectionDifference<ChangeElement>.Change
    var startIndex: CollectionDifference<ChangeElement>.Index { fatalError() }
    var endIndex: CollectionDifference<ChangeElement>.Index { fatalError() }
    func index(after index: CollectionDifference<ChangeElement>.Index)
        -> CollectionDifference<ChangeElement>.Index
    { fatalError() }
    subscript(position: CollectionDifference<ChangeElement>.Index)
        -> CollectionDifference<ChangeElement>.Element
    { fatalError() }
    func index(before index: CollectionDifference<ChangeElement>.Index)
        -> CollectionDifference<ChangeElement>.Index
    { fatalError() }
    func formIndex(_ index: inout CollectionDifference<ChangeElement>.Index, offsetBy distance: Int)
    { fatalError() }
    func distance(
        from start: CollectionDifference<ChangeElement>.Index,
        to end: CollectionDifference<ChangeElement>.Index
    ) -> Int { fatalError() }
    typealias Indices = DefaultIndices<CollectionDifference<ChangeElement>>
    typealias Iterator = IndexingIterator<CollectionDifference<ChangeElement>>
    typealias SubSequence = Slice<CollectionDifference<ChangeElement>>
    static func == (a: CollectionDifference<ChangeElement>, b: CollectionDifference<ChangeElement>)
        -> Bool
    { fatalError() }
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    func inferringMoves() -> CollectionDifference<ChangeElement> { fatalError() }
    init(from decoder: any Decoder) throws { fatalError() }
    func encode(to encoder: any Encoder) throws { fatalError() }
    @frozen enum Change {
        case insert(offset: Int, element: ChangeElement, associatedWith: Int?)
        case remove(offset: Int, element: ChangeElement, associatedWith: Int?)
        static func == (
            a: CollectionDifference<ChangeElement>.Change,
            b: CollectionDifference<ChangeElement>.Change
        ) -> Bool { fatalError() }
        func hash(into hasher: inout Hasher) { fatalError() }
        var hashValue: Int { fatalError() }
        init(from decoder: any Decoder) throws { fatalError() }
        func encode(to encoder: any Encoder) throws { fatalError() }
    }
    @frozen struct Index {
        static func == (
            lhs: CollectionDifference<ChangeElement>.Index,
            rhs: CollectionDifference<ChangeElement>.Index
        ) -> Bool { fatalError() }
        static func < (
            lhs: CollectionDifference<ChangeElement>.Index,
            rhs: CollectionDifference<ChangeElement>.Index
        ) -> Bool { fatalError() }
        func hash(into hasher: inout Hasher) { fatalError() }
        var hashValue: Int { fatalError() }
    }
}

@frozen struct CollectionOfOne<Element> {
    init(_ element: Element) { fatalError() }
    typealias Index = Int
    typealias Indices = Range<Int>
    typealias SubSequence = Slice<CollectionOfOne<Element>>
    var startIndex: CollectionOfOne<Element>.Index { fatalError() }
    var endIndex: CollectionOfOne<Element>.Index { fatalError() }
    func index(after i: CollectionOfOne<Element>.Index) -> CollectionOfOne<Element>.Index {
        fatalError()
    }
    func index(before i: CollectionOfOne<Element>.Index) -> CollectionOfOne<Element>.Index {
        fatalError()
    }
    func makeIterator() -> CollectionOfOne<Element>.Iterator { fatalError() }
    subscript(position: Int) -> Element { fatalError() }
    subscript(bounds: Range<Int>) -> CollectionOfOne<Element>.SubSequence { fatalError() }
    var count: Int { fatalError() }
    func withContiguousStorageIfAvailable<R, E>(
        _ body: (UnsafeBufferPointer<Element>) throws(E) -> R
    ) throws(E) -> R? where E: Error, R: ~Copyable { fatalError() }
    var span: Span<Element> { fatalError() }
    var mutableSpan: MutableSpan<Element> { fatalError() }
    var debugDescription: String { fatalError() }
    var customMirror: Mirror { fatalError() }
    static func == (lhs: CollectionOfOne<Element>, rhs: CollectionOfOne<Element>) -> Bool {
        fatalError()
    }
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    @frozen struct Iterator {
        mutating func next() -> Element? { fatalError() }
    }
}

@frozen enum CommandLine {
    static var argc: Int32 { fatalError() }
    static var unsafeArgv: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?> { fatalError() }
    static var arguments: [String] { fatalError() }
}

protocol Comparable: Equatable, ~Copyable, ~Escapable {
    static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool
    static func <= (lhs: borrowing Self, rhs: borrowing Self) -> Bool
    static func >= (lhs: borrowing Self, rhs: borrowing Self) -> Bool
    static func > (lhs: borrowing Self, rhs: borrowing Self) -> Bool
    static func ... (minimum: Self, maximum: Self) -> ClosedRange<Self>
    static func ..< (minimum: Self, maximum: Self) -> Range<Self>
    static func ..< (maximum: Self) -> PartialRangeUpTo<Self>
    static func ... (maximum: Self) -> PartialRangeThrough<Self>
    static func ... (minimum: Self) -> PartialRangeFrom<Self>
}

@frozen struct ContiguousArray<Element> {
    func encode(to encoder: any Encoder) throws { fatalError() }
    init(from decoder: any Decoder) throws { fatalError() }
    var capacity: Int { fatalError() }
    typealias Index = Int
    typealias Indices = Range<Int>
    typealias Iterator = IndexingIterator<ContiguousArray<Element>>
    var startIndex: Int { fatalError() }
    var endIndex: Int { fatalError() }
    func index(after i: Int) -> Int { fatalError() }
    func formIndex(after i: inout Int) { fatalError() }
    func index(before i: Int) -> Int { fatalError() }
    func formIndex(before i: inout Int) { fatalError() }
    func index(_ i: Int, offsetBy distance: Int) -> Int { fatalError() }
    func index(_ i: Int, offsetBy distance: Int, limitedBy limit: Int) -> Int? { fatalError() }
    func distance(from start: Int, to end: Int) -> Int { fatalError() }
    subscript(index: Int) -> Element { fatalError() }
    subscript(bounds: Range<Int>) -> ArraySlice<Element> { fatalError() }
    var count: Int { fatalError() }
    typealias SubSequence = ArraySlice<Element>
    init(arrayLiteral elements: Element...) { fatalError() }
    typealias ArrayLiteralElement = Element
    init() { fatalError() }
    init<S>(_ s: S) where Element == S.Element, S: Sequence { fatalError() }
    init(repeating repeatedValue: Element, count: Int) { fatalError() }
    mutating func reserveCapacity(_ minimumCapacity: Int) { fatalError() }
    mutating func append(_ newElement: Element) { fatalError() }
    mutating func append<S>(contentsOf newElements: S) where Element == S.Element, S: Sequence {
        fatalError()
    }
    @discardableResult mutating func remove(at index: Int) -> Element { fatalError() }
    mutating func insert(_ newElement: Element, at i: Int) { fatalError() }
    mutating func removeAll(keepingCapacity keepCapacity: Bool = false) { fatalError() }
    mutating func withContiguousMutableStorageIfAvailable<R>(
        _ body: (inout UnsafeMutableBufferPointer<Element>) throws -> R
    ) rethrows -> R? { fatalError() }
    func withContiguousStorageIfAvailable<R>(_ body: (UnsafeBufferPointer<Element>) throws -> R)
        rethrows -> R?
    { fatalError() }
    var customMirror: Mirror { fatalError() }
    var description: String { fatalError() }
    var debugDescription: String { fatalError() }
    init<E>(
        unsafeUninitializedCapacity: Int,
        initializingWith initializer: (inout UnsafeMutableBufferPointer<Element>, inout Int)
            throws(E) -> Void
    ) throws(E) where E: Error { fatalError() }
    init<E>(
        capacity: Int, initializingWith initializer: (inout OutputSpan<Element>) throws(E) -> Void
    ) throws(E) where E: Error { fatalError() }
    mutating func append<E>(
        addingCapacity uninitializedCount: Int,
        initializingWith initializer: (inout OutputSpan<Element>) throws(E) -> Void
    ) throws(E) where E: Error { fatalError() }
    func withUnsafeBufferPointer<R, E>(_ body: (UnsafeBufferPointer<Element>) throws(E) -> R)
        throws(E) -> R where E: Error
    { fatalError() }
    var span: Span<Element> { fatalError() }
    mutating func withUnsafeMutableBufferPointer<R, E>(
        _ body: (inout UnsafeMutableBufferPointer<Element>) throws(E) -> R
    ) throws(E) -> R where E: Error { fatalError() }
    var mutableSpan: MutableSpan<Element> { fatalError() }
    mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C)
    where Element == C.Element, C: Collection { fatalError() }
    static func == (lhs: ContiguousArray<Element>, rhs: ContiguousArray<Element>) -> Bool {
        fatalError()
    }
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    mutating func withUnsafeMutableBytes<R>(_ body: (UnsafeMutableRawBufferPointer) throws -> R)
        rethrows -> R
    { fatalError() }
    func withUnsafeBytes<R>(_ body: (UnsafeRawBufferPointer) throws -> R) rethrows -> R {
        fatalError()
    }
    func isTriviallyIdentical(to other: ContiguousArray<Element>) -> Bool { fatalError() }
}

protocol ConvertibleFromBytes: BitwiseCopyable {
}

protocol ConvertibleToBytes {
}

protocol Copyable {
}

protocol CustomDebugStringConvertible {
    var debugDescription: String { get }
}

protocol CustomLeafReflectable: CustomReflectable {
}

protocol CustomPlaygroundDisplayConvertible {
    var playgroundDescription: Any { get }
}

protocol CustomReflectable {
    var customMirror: Mirror { get }
}

protocol CustomStringConvertible {
    var description: String { get }
}

protocol Decodable {
    init(from decoder: any Decoder) throws
}

protocol Decoder {
    var codingPath: [any CodingKey] { get }
    var userInfo: [CodingUserInfoKey: Any] { get }
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key>
    where Key: CodingKey
    func unkeyedContainer() throws -> any UnkeyedDecodingContainer
    func singleValueContainer() throws -> any SingleValueDecodingContainer
}

enum DecodingError {
    case typeMismatch(any Any.Type, DecodingError.Context)
    case valueNotFound(any Any.Type, DecodingError.Context)
    case keyNotFound(any CodingKey, DecodingError.Context)
    case dataCorrupted(DecodingError.Context)
    var debugDescription: String { fatalError() }
    static func dataCorruptedError<C>(forKey key: C.Key, in container: C, debugDescription: String)
        -> DecodingError where C: KeyedDecodingContainerProtocol
    { fatalError() }
    static func dataCorruptedError(
        in container: any UnkeyedDecodingContainer, debugDescription: String
    ) -> DecodingError { fatalError() }
    static func dataCorruptedError(
        in container: any SingleValueDecodingContainer, debugDescription: String
    ) -> DecodingError { fatalError() }
    struct Context {
        var codingPath: [any CodingKey] { fatalError() }
        var debugDescription: String { fatalError() }
        var underlyingError: (any Error)? { fatalError() }
        init(
            codingPath: [any CodingKey], debugDescription: String,
            underlyingError: (any Error)? = nil
        ) { fatalError() }
    }
}

@frozen struct DefaultIndices<Elements> where Elements: Collection {
    typealias Index = Elements.Index
    typealias Element = Elements.Index
    typealias Indices = DefaultIndices<Elements>
    typealias SubSequence = DefaultIndices<Elements>
    typealias Iterator = IndexingIterator<DefaultIndices<Elements>>
    var startIndex: DefaultIndices<Elements>.Index { fatalError() }
    var endIndex: DefaultIndices<Elements>.Index { fatalError() }
    subscript(i: DefaultIndices<Elements>.Index) -> Elements.Index { fatalError() }
    subscript(bounds: Range<DefaultIndices<Elements>.Index>) -> DefaultIndices<Elements> {
        fatalError()
    }
    func index(after i: DefaultIndices<Elements>.Index) -> DefaultIndices<Elements>.Index {
        fatalError()
    }
    func formIndex(after i: inout DefaultIndices<Elements>.Index) { fatalError() }
    var indices: DefaultIndices<Elements>.Indices { fatalError() }
    func index(_ i: DefaultIndices<Elements>.Index, offsetBy distance: Int)
        -> DefaultIndices<Elements>.Index
    { fatalError() }
    func index(
        _ i: DefaultIndices<Elements>.Index, offsetBy distance: Int,
        limitedBy limit: DefaultIndices<Elements>.Index
    ) -> DefaultIndices<Elements>.Index? { fatalError() }
    func distance(
        from start: DefaultIndices<Elements>.Index, to end: DefaultIndices<Elements>.Index
    ) -> Int { fatalError() }
    func index(before i: DefaultIndices<Elements>.Index) -> DefaultIndices<Elements>.Index {
        fatalError()
    }
    func formIndex(before i: inout DefaultIndices<Elements>.Index) { fatalError() }
}

@frozen struct DefaultStringInterpolation {
    init(literalCapacity: Int, interpolationCount: Int) { fatalError() }
    mutating func appendLiteral(_ literal: String) { fatalError() }
    mutating func appendInterpolation<T>(_ value: T)
    where T: CustomStringConvertible, T: TextOutputStreamable { fatalError() }
    mutating func appendInterpolation<T>(_ value: T) where T: TextOutputStreamable { fatalError() }
    mutating func appendInterpolation<T>(_ value: T) where T: CustomStringConvertible {
        fatalError()
    }
    mutating func appendInterpolation<T>(_ value: T) { fatalError() }
    mutating func appendInterpolation(_ value: any Any.Type) { fatalError() }
    typealias StringLiteralType = String
    mutating func appendInterpolation<T>(
        _ value: T?, default: @autoclosure () -> some StringProtocol
    ) where T: CustomStringConvertible, T: TextOutputStreamable { fatalError() }
    mutating func appendInterpolation<T>(
        _ value: T?, default: @autoclosure () -> some StringProtocol
    ) where T: TextOutputStreamable { fatalError() }
    mutating func appendInterpolation<T>(
        _ value: T?, default: @autoclosure () -> some StringProtocol
    ) where T: CustomStringConvertible { fatalError() }
    mutating func appendInterpolation<T>(
        _ value: T?, default: @autoclosure () -> some StringProtocol
    ) { fatalError() }
    mutating func appendInterpolation<T>(_ value: T?, default: String)
    where T: CustomStringConvertible, T: TextOutputStreamable { fatalError() }
    var description: String { fatalError() }
    mutating func write(_ string: String) { fatalError() }
}

@frozen struct Dictionary<Key, Value> where Key: Hashable {
    func encode(to encoder: any Encoder) throws { fatalError() }
    init(from decoder: any Decoder) throws { fatalError() }
    typealias Element = (key: Key, value: Value)
    init() { fatalError() }
    init(minimumCapacity: Int) { fatalError() }
    init<S>(uniqueKeysWithValues keysAndValues: S) where S: Sequence, S.Element == (Key, Value) {
        fatalError()
    }
    init<S, E>(_ keysAndValues: S, uniquingKeysWith combine: (Value, Value) throws(E) -> Value)
        throws(E) where S: Sequence, E: Error, S.Element == (Key, Value)
    { fatalError() }
    init<S, E>(grouping values: S, by keyForValue: (S.Element) throws(E) -> Key) throws(E)
    where Value == [S.Element], S: Sequence, E: Error { fatalError() }
    func makeIterator() -> Dictionary<Key, Value>.Iterator { fatalError() }
    consuming func filter<E>(_ isIncluded: (Dictionary<Key, Value>.Element) throws(E) -> Bool)
        throws(E) -> [Key: Value] where E: Error
    { fatalError() }
    typealias SubSequence = Slice<[Key: Value]>
    var startIndex: Dictionary<Key, Value>.Index { fatalError() }
    var endIndex: Dictionary<Key, Value>.Index { fatalError() }
    func index(after i: Dictionary<Key, Value>.Index) -> Dictionary<Key, Value>.Index {
        fatalError()
    }
    func formIndex(after i: inout Dictionary<Key, Value>.Index) { fatalError() }
    func index(forKey key: Key) -> Dictionary<Key, Value>.Index? { fatalError() }
    subscript(position: Dictionary<Key, Value>.Index) -> Dictionary<Key, Value>.Element {
        fatalError()
    }
    var count: Int { fatalError() }
    var isEmpty: Bool { fatalError() }
    typealias Indices = DefaultIndices<[Key: Value]>
    subscript(key: Key) -> Value? { fatalError() }
    init(dictionaryLiteral elements: (Key, Value)...) { fatalError() }
    subscript(key: Key, default defaultValue: @autoclosure () -> Value) -> Value { fatalError() }
    func mapValues<T, E>(_ transform: (Value) throws(E) -> T) throws(E) -> [Key: T] where E: Error {
        fatalError()
    }
    func compactMapValues<T>(_ transform: (Value) throws -> T?) rethrows -> [Key: T] {
        fatalError()
    }
    @discardableResult mutating func updateValue(_ value: Value, forKey key: Key) -> Value? {
        fatalError()
    }
    mutating func merge<S, E>(
        _ other: S, uniquingKeysWith combine: (Value, Value) throws(E) -> Value
    ) throws(E) where S: Sequence, E: Error, S.Element == (Key, Value) { fatalError() }
    mutating func merge<E>(
        _ other: [Key: Value], uniquingKeysWith combine: (Value, Value) throws(E) -> Value
    ) throws(E) where E: Error { fatalError() }
    func merging<S, E>(_ other: S, uniquingKeysWith combine: (Value, Value) throws(E) -> Value)
        throws(E) -> [Key: Value] where S: Sequence, E: Error, S.Element == (Key, Value)
    { fatalError() }
    func merging<E>(
        _ other: [Key: Value], uniquingKeysWith combine: (Value, Value) throws(E) -> Value
    ) throws(E) -> [Key: Value] where E: Error { fatalError() }
    @discardableResult mutating func remove(at index: Dictionary<Key, Value>.Index)
        -> Dictionary<Key, Value>.Element
    { fatalError() }
    @discardableResult mutating func removeValue(forKey key: Key) -> Value? { fatalError() }
    mutating func removeAll(keepingCapacity keepCapacity: Bool = false) { fatalError() }
    var keys: Dictionary<Key, Value>.Keys { fatalError() }
    var values: Dictionary<Key, Value>.Values { fatalError() }
    static func == (lhs: [Key: Value], rhs: [Key: Value]) -> Bool { fatalError() }
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    var description: String { fatalError() }
    var debugDescription: String { fatalError() }
    var customMirror: Mirror { fatalError() }
    mutating func popFirst() -> Dictionary<Key, Value>.Element? { fatalError() }
    var capacity: Int { fatalError() }
    mutating func reserveCapacity(_ minimumCapacity: Int) { fatalError() }
    func isTriviallyIdentical(to other: [Key: Value]) -> Bool { fatalError() }
    @frozen struct Index {
        static func == (lhs: Dictionary<Key, Value>.Index, rhs: Dictionary<Key, Value>.Index)
            -> Bool
        { fatalError() }
        static func < (lhs: Dictionary<Key, Value>.Index, rhs: Dictionary<Key, Value>.Index) -> Bool
        { fatalError() }
        func hash(into hasher: inout Hasher) { fatalError() }
        var hashValue: Int { fatalError() }
    }
    @frozen struct Iterator {
        mutating func next() -> (key: Key, value: Value)? { fatalError() }
        typealias Element = (key: Key, value: Value)
        var customMirror: Mirror { fatalError() }
    }
    @frozen struct Keys {
        typealias Element = Key
        typealias SubSequence = Slice<Dictionary<Key, Value>.Keys>
        var startIndex: Dictionary<Key, Value>.Index { fatalError() }
        var endIndex: Dictionary<Key, Value>.Index { fatalError() }
        func index(after i: Dictionary<Key, Value>.Index) -> Dictionary<Key, Value>.Index {
            fatalError()
        }
        func formIndex(after i: inout Dictionary<Key, Value>.Index) { fatalError() }
        subscript(position: Dictionary<Key, Value>.Index) -> Dictionary<Key, Value>.Keys.Element {
            fatalError()
        }
        var count: Int { fatalError() }
        var isEmpty: Bool { fatalError() }
        static func == (lhs: Dictionary<Key, Value>.Keys, rhs: Dictionary<Key, Value>.Keys) -> Bool
        { fatalError() }
        typealias Index = Dictionary<Key, Value>.Index
        typealias Indices = DefaultIndices<Dictionary<Key, Value>.Keys>
        var description: String { fatalError() }
        var debugDescription: String { fatalError() }
        func makeIterator() -> Dictionary<Key, Value>.Keys.Iterator { fatalError() }
        func hash(into hasher: inout Hasher) { fatalError() }
        var hashValue: Int { fatalError() }
        @frozen struct Iterator {
            mutating func next() -> Key? { fatalError() }
            typealias Element = Key
        }
    }
    @frozen struct Values {
        typealias Element = Value
        var startIndex: Dictionary<Key, Value>.Index { fatalError() }
        var endIndex: Dictionary<Key, Value>.Index { fatalError() }
        func index(after i: Dictionary<Key, Value>.Index) -> Dictionary<Key, Value>.Index {
            fatalError()
        }
        func formIndex(after i: inout Dictionary<Key, Value>.Index) { fatalError() }
        subscript(position: Dictionary<Key, Value>.Index) -> Dictionary<Key, Value>.Values.Element {
            fatalError()
        }
        var count: Int { fatalError() }
        var isEmpty: Bool { fatalError() }
        mutating func swapAt(_ i: Dictionary<Key, Value>.Index, _ j: Dictionary<Key, Value>.Index) {
            fatalError()
        }
        typealias Index = Dictionary<Key, Value>.Index
        typealias Indices = DefaultIndices<Dictionary<Key, Value>.Values>
        typealias SubSequence = Slice<Dictionary<Key, Value>.Values>
        var description: String { fatalError() }
        var debugDescription: String { fatalError() }
        func makeIterator() -> Dictionary<Key, Value>.Values.Iterator { fatalError() }
        @frozen struct Iterator {
            mutating func next() -> Value? { fatalError() }
            typealias Element = Value
        }
    }
}

struct DiscontiguousSlice<Base> where Base: Collection {
    var subranges: RangeSet<Base.Index> { fatalError() }
    var base: Base { fatalError() }
    static func == (lhs: DiscontiguousSlice<Base>, rhs: DiscontiguousSlice<Base>) -> Bool {
        fatalError()
    }
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    var description: String { fatalError() }
    typealias Element = Base.Element
    typealias Iterator = IndexingIterator<DiscontiguousSlice<Base>>
    typealias SubSequence = DiscontiguousSlice<Base>
    typealias Indices = DefaultIndices<DiscontiguousSlice<Base>>
    var startIndex: DiscontiguousSlice<Base>.Index { fatalError() }
    var endIndex: DiscontiguousSlice<Base>.Index { fatalError() }
    var count: Int { fatalError() }
    var isEmpty: Bool { fatalError() }
    func distance(
        from start: DiscontiguousSlice<Base>.Index, to end: DiscontiguousSlice<Base>.Index
    ) -> Int { fatalError() }
    func index(after i: DiscontiguousSlice<Base>.Index) -> DiscontiguousSlice<Base>.Index {
        fatalError()
    }
    subscript(i: DiscontiguousSlice<Base>.Index) -> Base.Element { fatalError() }
    subscript(bounds: Range<DiscontiguousSlice<Base>.Index>) -> DiscontiguousSlice<Base> {
        fatalError()
    }
    func index(before i: DiscontiguousSlice<Base>.Index) -> DiscontiguousSlice<Base>.Index {
        fatalError()
    }
    struct Index {
        var base: Base.Index { fatalError() }
        static func == (left: DiscontiguousSlice<Base>.Index, right: DiscontiguousSlice<Base>.Index)
            -> Bool
        { fatalError() }
        func hash(into hasher: inout Hasher) { fatalError() }
        var hashValue: Int { fatalError() }
        static func < (left: DiscontiguousSlice<Base>.Index, right: DiscontiguousSlice<Base>.Index)
            -> Bool
        { fatalError() }
        var description: String { fatalError() }
    }
}

@frozen struct Double {
    init(from decoder: any Decoder) throws { fatalError() }
    func encode(to encoder: any Encoder) throws { fatalError() }
    var customMirror: Mirror { fatalError() }
    var customPlaygroundQuickLook: _PlaygroundQuickLook { fatalError() }
    init?<S>(_ text: S) where S: StringProtocol { fatalError() }
    init?(_ text: Substring) { fatalError() }
    init() { fatalError() }
    var description: String { fatalError() }
    var debugDescription: String { fatalError() }
    func write<Target>(to target: inout Target) where Target: TextOutputStream { fatalError() }
    typealias Magnitude = Double
    typealias Exponent = Int
    typealias RawSignificand = UInt64
    static var exponentBitCount: Int { fatalError() }
    static var significandBitCount: Int { fatalError() }
    var bitPattern: UInt64 { fatalError() }
    init(bitPattern: UInt64) { fatalError() }
    var sign: FloatingPointSign { fatalError() }
    var exponentBitPattern: UInt { fatalError() }
    var significandBitPattern: UInt64 { fatalError() }
    init(sign: FloatingPointSign, exponentBitPattern: UInt, significandBitPattern: UInt64) {
        fatalError()
    }
    var isCanonical: Bool { fatalError() }
    static var infinity: Double { fatalError() }
    static var nan: Double { fatalError() }
    static var signalingNaN: Double { fatalError() }
    static var greatestFiniteMagnitude: Double { fatalError() }
    static var pi: Double { fatalError() }
    var ulp: Double { fatalError() }
    static var leastNormalMagnitude: Double { fatalError() }
    static var leastNonzeroMagnitude: Double { fatalError() }
    static var ulpOfOne: Double { fatalError() }
    var exponent: Int { fatalError() }
    var significand: Double { fatalError() }
    init(sign: FloatingPointSign, exponent: Int, significand: Double) { fatalError() }
    init(nan payload: Double.RawSignificand, signaling: Bool) { fatalError() }
    var nextUp: Double { fatalError() }
    init(signOf sign: Double, magnitudeOf mag: Double) { fatalError() }
    mutating func round(_ rule: FloatingPointRoundingRule) { fatalError() }
    mutating func negate() { fatalError() }
    static func += (lhs: inout Double, rhs: Double) { fatalError() }
    static func -= (lhs: inout Double, rhs: Double) { fatalError() }
    static func *= (lhs: inout Double, rhs: Double) { fatalError() }
    static func /= (lhs: inout Double, rhs: Double) { fatalError() }
    mutating func formRemainder(dividingBy other: Double) { fatalError() }
    mutating func formTruncatingRemainder(dividingBy other: Double) { fatalError() }
    mutating func formSquareRoot() { fatalError() }
    mutating func addProduct(_ lhs: Double, _ rhs: Double) { fatalError() }
    func isEqual(to other: Double) -> Bool { fatalError() }
    func isLess(than other: Double) -> Bool { fatalError() }
    func isLessThanOrEqualTo(_ other: Double) -> Bool { fatalError() }
    var isNormal: Bool { fatalError() }
    var isFinite: Bool { fatalError() }
    var isZero: Bool { fatalError() }
    var isSubnormal: Bool { fatalError() }
    var isInfinite: Bool { fatalError() }
    var isNaN: Bool { fatalError() }
    var isSignalingNaN: Bool { fatalError() }
    var binade: Double { fatalError() }
    var significandWidth: Int { fatalError() }
    init(floatLiteral value: Double) { fatalError() }
    typealias FloatLiteralType = Double
    typealias RawExponent = UInt
    init(integerLiteral value: Int64) { fatalError() }
    typealias IntegerLiteralType = Int64
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    var magnitude: Double { fatalError() }
    static func - (x: Double) -> Double { fatalError() }
    init(_ v: Int) { fatalError() }
    init<Source>(_ value: Source) where Source: BinaryInteger { fatalError() }
    init?<Source>(exactly value: Source) where Source: BinaryInteger { fatalError() }
    init(_ other: Float) { fatalError() }
    init?(exactly other: Float) { fatalError() }
    init(_ other: Double) { fatalError() }
    init?(exactly other: Double) { fatalError() }
    init(_ other: Float80) { fatalError() }
    init?(exactly other: Float80) { fatalError() }
    static func + (lhs: Double, rhs: Double) -> Double { fatalError() }
    static func - (lhs: Double, rhs: Double) -> Double { fatalError() }
    static func * (lhs: Double, rhs: Double) -> Double { fatalError() }
    static func / (lhs: Double, rhs: Double) -> Double { fatalError() }
    func distance(to other: Double) -> Double { fatalError() }
    func advanced(by amount: Double) -> Double { fatalError() }
    typealias Stride = Double
    typealias SIMDMaskScalar = Int64
    @frozen struct SIMD16Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Double { fatalError() }
        typealias Scalar = Double
    }
    @frozen struct SIMD2Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Double { fatalError() }
        typealias Scalar = Double
    }
    @frozen struct SIMD32Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Double { fatalError() }
        typealias Scalar = Double
    }
    @frozen struct SIMD4Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Double { fatalError() }
        typealias Scalar = Double
    }
    @frozen struct SIMD64Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Double { fatalError() }
        typealias Scalar = Double
    }
    @frozen struct SIMD8Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Double { fatalError() }
        typealias Scalar = Double
    }
}

@frozen struct DropFirstSequence<Base> where Base: Sequence {
    init(_ base: Base, dropping limit: Int) { fatalError() }
    typealias Element = Base.Element
    typealias Iterator = Base.Iterator
    typealias SubSequence = AnySequence<DropFirstSequence<Base>.Element>
    func makeIterator() -> DropFirstSequence<Base>.Iterator { fatalError() }
    func dropFirst(_ k: Int) -> DropFirstSequence<Base> { fatalError() }
}

@frozen struct DropWhileSequence<Base> where Base: Sequence {
    typealias Element = Base.Element
    func makeIterator() -> DropWhileSequence<Base>.Iterator { fatalError() }
    func drop(while predicate: (DropWhileSequence<Base>.Element) throws -> Bool) rethrows
        -> DropWhileSequence<Base>
    { fatalError() }
    @frozen struct Iterator {
        typealias Element = Base.Element
        mutating func next() -> DropWhileSequence<Base>.Iterator.Element? { fatalError() }
    }
}

@frozen struct Duration {
    init(secondsComponent: Int64, attosecondsComponent: Int64) { fatalError() }
    var components: (seconds: Int64, attoseconds: Int64) { fatalError() }
    var attoseconds: Int128 { fatalError() }
    init(attoseconds: Int128) { fatalError() }
    static func seconds<T>(_ seconds: T) -> Duration where T: BinaryInteger { fatalError() }
    static func seconds(_ seconds: Double) -> Duration { fatalError() }
    static func milliseconds<T>(_ milliseconds: T) -> Duration where T: BinaryInteger {
        fatalError()
    }
    static func milliseconds(_ milliseconds: Double) -> Duration { fatalError() }
    static func microseconds<T>(_ microseconds: T) -> Duration where T: BinaryInteger {
        fatalError()
    }
    static func microseconds(_ microseconds: Double) -> Duration { fatalError() }
    static func nanoseconds<T>(_ nanoseconds: T) -> Duration where T: BinaryInteger { fatalError() }
    static func nanoseconds(_ nanoseconds: Double) -> Duration { fatalError() }
    init(from decoder: any Decoder) throws { fatalError() }
    func encode(to encoder: any Encoder) throws { fatalError() }
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    static func == (lhs: Duration, rhs: Duration) -> Bool { fatalError() }
    static func < (lhs: Duration, rhs: Duration) -> Bool { fatalError() }
    static var zero: Duration { fatalError() }
    static func + (lhs: Duration, rhs: Duration) -> Duration { fatalError() }
    static func - (lhs: Duration, rhs: Duration) -> Duration { fatalError() }
    static func += (lhs: inout Duration, rhs: Duration) { fatalError() }
    static func -= (lhs: inout Duration, rhs: Duration) { fatalError() }
    static func / (lhs: Duration, rhs: Double) -> Duration { fatalError() }
    static func /= (lhs: inout Duration, rhs: Double) { fatalError() }
    static func / <T>(lhs: Duration, rhs: T) -> Duration where T: BinaryInteger { fatalError() }
    static func /= <T>(lhs: inout Duration, rhs: T) where T: BinaryInteger { fatalError() }
    static func / (lhs: Duration, rhs: Duration) -> Double { fatalError() }
    static func * (lhs: Duration, rhs: Double) -> Duration { fatalError() }
    static func * <T>(lhs: Duration, rhs: T) -> Duration where T: BinaryInteger { fatalError() }
    static func *= <T>(lhs: inout Duration, rhs: T) where T: BinaryInteger { fatalError() }
    var description: String { fatalError() }
}

protocol DurationProtocol: AdditiveArithmetic, Comparable, Sendable {
    static func / (lhs: Self, rhs: Int) -> Self
    static func /= (lhs: inout Self, rhs: Int)
    static func * (lhs: Self, rhs: Int) -> Self
    static func *= (lhs: inout Self, rhs: Int)
    static func / (lhs: Self, rhs: Self) -> Double
}

@frozen struct EmptyCollection<Element> {
    init() { fatalError() }
    func makeIterator() -> EmptyCollection<Element>.Iterator { fatalError() }
    typealias Index = Int
    typealias Indices = Range<Int>
    typealias SubSequence = EmptyCollection<Element>
    var startIndex: EmptyCollection<Element>.Index { fatalError() }
    var endIndex: EmptyCollection<Element>.Index { fatalError() }
    func index(after i: EmptyCollection<Element>.Index) -> EmptyCollection<Element>.Index {
        fatalError()
    }
    func index(before i: EmptyCollection<Element>.Index) -> EmptyCollection<Element>.Index {
        fatalError()
    }
    subscript(position: EmptyCollection<Element>.Index) -> Element { fatalError() }
    subscript(bounds: Range<EmptyCollection<Element>.Index>) -> EmptyCollection<Element>.SubSequence
    { fatalError() }
    var count: Int { fatalError() }
    func index(_ i: EmptyCollection<Element>.Index, offsetBy n: Int)
        -> EmptyCollection<Element>.Index
    { fatalError() }
    func index(
        _ i: EmptyCollection<Element>.Index, offsetBy n: Int,
        limitedBy limit: EmptyCollection<Element>.Index
    ) -> EmptyCollection<Element>.Index? { fatalError() }
    func distance(
        from start: EmptyCollection<Element>.Index, to end: EmptyCollection<Element>.Index
    ) -> Int { fatalError() }
    func withContiguousStorageIfAvailable<R, E>(
        _ body: (UnsafeBufferPointer<Element>) throws(E) -> R
    ) throws(E) -> R? where E: Error, R: ~Copyable { fatalError() }
    static func == (lhs: EmptyCollection<Element>, rhs: EmptyCollection<Element>) -> Bool {
        fatalError()
    }
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    @frozen struct Iterator {
        init() { fatalError() }
        mutating func next() -> Element? { fatalError() }
        typealias Iterator = EmptyCollection<Element>.Iterator
    }
}

protocol Encodable {
    func encode(to encoder: any Encoder) throws
}

protocol Encoder {
    var codingPath: [any CodingKey] { get }
    var userInfo: [CodingUserInfoKey: Any] { get }
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey
    func unkeyedContainer() -> any UnkeyedEncodingContainer
    func singleValueContainer() -> any SingleValueEncodingContainer
}

enum EncodingError {
    case invalidValue(Any, EncodingError.Context)
    var debugDescription: String { fatalError() }
    struct Context {
        var codingPath: [any CodingKey] { fatalError() }
        var debugDescription: String { fatalError() }
        var underlyingError: (any Error)? { fatalError() }
        init(
            codingPath: [any CodingKey], debugDescription: String,
            underlyingError: (any Error)? = nil
        ) { fatalError() }
    }
}

@frozen struct EnumeratedSequence<Base> where Base: Sequence {
    func makeIterator() -> EnumeratedSequence<Base>.Iterator { fatalError() }
    typealias Element = EnumeratedSequence<Base>.Iterator.Element
    var startIndex: EnumeratedSequence<Base>.Index { fatalError() }
    var endIndex: EnumeratedSequence<Base>.Index { fatalError() }
    var count: Int { fatalError() }
    var isEmpty: Bool { fatalError() }
    func distance(
        from start: EnumeratedSequence<Base>.Index, to end: EnumeratedSequence<Base>.Index
    ) -> Int { fatalError() }
    func index(after index: EnumeratedSequence<Base>.Index) -> EnumeratedSequence<Base>.Index {
        fatalError()
    }
    func index(_ i: EnumeratedSequence<Base>.Index, offsetBy distance: Int)
        -> EnumeratedSequence<Base>.Index
    { fatalError() }
    func index(
        _ i: EnumeratedSequence<Base>.Index, offsetBy distance: Int,
        limitedBy limit: EnumeratedSequence<Base>.Index
    ) -> EnumeratedSequence<Base>.Index? { fatalError() }
    subscript(position: EnumeratedSequence<Base>.Index) -> EnumeratedSequence<Base>.Element {
        fatalError()
    }
    typealias Indices = DefaultIndices<EnumeratedSequence<Base>>
    typealias SubSequence = Slice<EnumeratedSequence<Base>>
    func index(before index: EnumeratedSequence<Base>.Index) -> EnumeratedSequence<Base>.Index {
        fatalError()
    }
    @frozen struct Index {
        var base: Base.Index { fatalError() }
        static func == (lhs: EnumeratedSequence<Base>.Index, rhs: EnumeratedSequence<Base>.Index)
            -> Bool
        { fatalError() }
        static func < (lhs: EnumeratedSequence<Base>.Index, rhs: EnumeratedSequence<Base>.Index)
            -> Bool
        { fatalError() }
    }
    @frozen struct Iterator {
        typealias Element = (offset: Int, element: Base.Element)
        mutating func next() -> EnumeratedSequence<Base>.Iterator.Element? { fatalError() }
        typealias Iterator = EnumeratedSequence<Base>.Iterator
    }
}

protocol Equatable: ~Copyable, ~Escapable {
    static func == (lhs: borrowing Self, rhs: borrowing Self) -> Bool
    static func != (lhs: borrowing Self, rhs: borrowing Self) -> Bool
}

protocol Error: Sendable {
}

protocol Escapable {
}

protocol ExpressibleByArrayLiteral {
    associatedtype ArrayLiteralElement
    init(arrayLiteral elements: Self.ArrayLiteralElement...)
}

protocol ExpressibleByBooleanLiteral {
    associatedtype BooleanLiteralType: _ExpressibleByBuiltinBooleanLiteral
    init(booleanLiteral value: Self.BooleanLiteralType)
}

protocol ExpressibleByDictionaryLiteral {
    associatedtype Key
    associatedtype Value
    init(dictionaryLiteral elements: (Self.Key, Self.Value)...)
}

protocol ExpressibleByExtendedGraphemeClusterLiteral: ExpressibleByUnicodeScalarLiteral {
    associatedtype
        ExtendedGraphemeClusterLiteralType: _ExpressibleByBuiltinExtendedGraphemeClusterLiteral
    init(extendedGraphemeClusterLiteral value: Self.ExtendedGraphemeClusterLiteralType)
    init(unicodeScalarLiteral value: Self.ExtendedGraphemeClusterLiteralType)
}

protocol ExpressibleByFloatLiteral {
    associatedtype FloatLiteralType: _ExpressibleByBuiltinFloatLiteral
    init(floatLiteral value: Self.FloatLiteralType)
}

protocol ExpressibleByIntegerLiteral {
    associatedtype IntegerLiteralType: _ExpressibleByBuiltinIntegerLiteral
    init(integerLiteral value: Self.IntegerLiteralType)
    init(integerLiteral value: Self)
}

protocol ExpressibleByNilLiteral: ~Copyable, ~Escapable {
    init(nilLiteral: ())
}

protocol ExpressibleByStringInterpolation: ExpressibleByStringLiteral {
    associatedtype StringInterpolation: StringInterpolationProtocol = DefaultStringInterpolation
    where Self.StringLiteralType == Self.StringInterpolation.StringLiteralType
    init(stringInterpolation: Self.StringInterpolation)
    init(stringInterpolation: DefaultStringInterpolation)
}

protocol ExpressibleByStringLiteral: ExpressibleByExtendedGraphemeClusterLiteral {
    associatedtype StringLiteralType: _ExpressibleByBuiltinStringLiteral
    init(stringLiteral value: Self.StringLiteralType)
    init(extendedGraphemeClusterLiteral value: Self.StringLiteralType)
}

protocol ExpressibleByUnicodeScalarLiteral {
    associatedtype UnicodeScalarLiteralType: _ExpressibleByBuiltinUnicodeScalarLiteral
    init(unicodeScalarLiteral value: Self.UnicodeScalarLiteralType)
}

protocol FixedWidthInteger: BinaryInteger, LosslessStringConvertible
where
    Self.Magnitude: FixedWidthInteger, Self.Magnitude: UnsignedInteger,
    Self.Stride: FixedWidthInteger, Self.Stride: SignedInteger
{
    init?<S>(_ text: S, radix: Int) where S: StringProtocol
    init?(_ description: String)
    static var bitWidth: Int { get }
    static var max: Self { get }
    static var min: Self { get }
    func addingReportingOverflow(_ rhs: Self) -> (partialValue: Self, overflow: Bool)
    func subtractingReportingOverflow(_ rhs: Self) -> (partialValue: Self, overflow: Bool)
    func multipliedReportingOverflow(by rhs: Self) -> (partialValue: Self, overflow: Bool)
    func dividedReportingOverflow(by rhs: Self) -> (partialValue: Self, overflow: Bool)
    func remainderReportingOverflow(dividingBy rhs: Self) -> (partialValue: Self, overflow: Bool)
    func multipliedFullWidth(by other: Self) -> (high: Self, low: Self.Magnitude)
    func dividingFullWidth(_ dividend: (high: Self, low: Self.Magnitude)) -> (
        quotient: Self, remainder: Self
    )
    var nonzeroBitCount: Int { get }
    var leadingZeroBitCount: Int { get }
    init(bigEndian value: Self)
    init(littleEndian value: Self)
    var bigEndian: Self { get }
    var littleEndian: Self { get }
    var byteSwapped: Self { get }
    static func &>> (lhs: Self, rhs: Self) -> Self
    static func &>>= (lhs: inout Self, rhs: Self)
    static func &<< (lhs: Self, rhs: Self) -> Self
    static func &<<= (lhs: inout Self, rhs: Self)
    static func &* (lhs: Self, rhs: Self) -> Self
    var bitWidth: Int { get }
    static func &>> <Other>(lhs: Self, rhs: Other) -> Self where Other: BinaryInteger
    static func &>>= <Other>(lhs: inout Self, rhs: Other) where Other: BinaryInteger
    static func &<< <Other>(lhs: Self, rhs: Other) -> Self where Other: BinaryInteger
    static func &<<= <Other>(lhs: inout Self, rhs: Other) where Other: BinaryInteger
    static func random<T>(in range: Range<Self>, using generator: inout T) -> Self
    where T: RandomNumberGenerator
    static func random(in range: Range<Self>) -> Self
    static func random<T>(in range: ClosedRange<Self>, using generator: inout T) -> Self
    where T: RandomNumberGenerator
    static func random(in range: ClosedRange<Self>) -> Self
    static func ~ (x: Self) -> Self
    static func >> <Other>(lhs: Self, rhs: Other) -> Self where Other: BinaryInteger
    static func >>= <Other>(lhs: inout Self, rhs: Other) where Other: BinaryInteger
    static func << <Other>(lhs: Self, rhs: Other) -> Self where Other: BinaryInteger
    static func <<= <Other>(lhs: inout Self, rhs: Other) where Other: BinaryInteger
    init<T>(_ source: T) where T: BinaryFloatingPoint
    init?<T>(exactly source: T) where T: BinaryFloatingPoint
    init<Other>(clamping source: Other) where Other: BinaryInteger
    init<T>(truncatingIfNeeded source: T) where T: BinaryInteger
    static func &+ (lhs: Self, rhs: Self) -> Self
    static func &+= (lhs: inout Self, rhs: Self)
    static func &- (lhs: Self, rhs: Self) -> Self
    static func &-= (lhs: inout Self, rhs: Self)
    static func &*= (lhs: inout Self, rhs: Self)
}

@frozen struct FlattenSequence<Base> where Base: Sequence, Base.Element: Sequence {
    func makeIterator() -> FlattenSequence<Base>.Iterator { fatalError() }
    typealias Element = FlattenSequence<Base>.Iterator.Element
    var startIndex: FlattenSequence<Base>.Index { fatalError() }
    var endIndex: FlattenSequence<Base>.Index { fatalError() }
    func index(after i: FlattenSequence<Base>.Index) -> FlattenSequence<Base>.Index { fatalError() }
    func formIndex(after i: inout FlattenSequence<Base>.Index) { fatalError() }
    func distance(from start: FlattenSequence<Base>.Index, to end: FlattenSequence<Base>.Index)
        -> Int
    { fatalError() }
    func index(_ i: FlattenSequence<Base>.Index, offsetBy n: Int) -> FlattenSequence<Base>.Index {
        fatalError()
    }
    func formIndex(_ i: inout FlattenSequence<Base>.Index, offsetBy n: Int) { fatalError() }
    func index(
        _ i: FlattenSequence<Base>.Index, offsetBy n: Int,
        limitedBy limit: FlattenSequence<Base>.Index
    ) -> FlattenSequence<Base>.Index? { fatalError() }
    func formIndex(
        _ i: inout FlattenSequence<Base>.Index, offsetBy n: Int,
        limitedBy limit: FlattenSequence<Base>.Index
    ) -> Bool { fatalError() }
    subscript(position: FlattenSequence<Base>.Index) -> Base.Element.Element { fatalError() }
    subscript(bounds: Range<FlattenSequence<Base>.Index>) -> Slice<FlattenCollection<Base>> {
        fatalError()
    }
    typealias Indices = DefaultIndices<FlattenSequence<Base>>
    typealias SubSequence = Slice<FlattenCollection<Base>>
    func index(before i: FlattenSequence<Base>.Index) -> FlattenSequence<Base>.Index {
        fatalError()
    }
    func formIndex(before i: inout FlattenSequence<Base>.Index) { fatalError() }
    @frozen struct Index {
        static func == (lhs: FlattenCollection<Base>.Index, rhs: FlattenCollection<Base>.Index)
            -> Bool
        { fatalError() }
        static func < (lhs: FlattenCollection<Base>.Index, rhs: FlattenCollection<Base>.Index)
            -> Bool
        { fatalError() }
        func hash(into hasher: inout Hasher) { fatalError() }
        var hashValue: Int { fatalError() }
    }
    @frozen struct Iterator {
        typealias Element = Base.Element.Element
        mutating func next() -> FlattenSequence<Base>.Iterator.Element? { fatalError() }
        typealias Iterator = FlattenSequence<Base>.Iterator
    }
}

@frozen struct Float {
    init(from decoder: any Decoder) throws { fatalError() }
    func encode(to encoder: any Encoder) throws { fatalError() }
    var customMirror: Mirror { fatalError() }
    var customPlaygroundQuickLook: _PlaygroundQuickLook { fatalError() }
    init?<S>(_ text: S) where S: StringProtocol { fatalError() }
    init?(_ text: Substring) { fatalError() }
    init() { fatalError() }
    var description: String { fatalError() }
    var debugDescription: String { fatalError() }
    func write<Target>(to target: inout Target) where Target: TextOutputStream { fatalError() }
    typealias Magnitude = Float
    typealias Exponent = Int
    typealias RawSignificand = UInt32
    static var exponentBitCount: Int { fatalError() }
    static var significandBitCount: Int { fatalError() }
    var bitPattern: UInt32 { fatalError() }
    init(bitPattern: UInt32) { fatalError() }
    var sign: FloatingPointSign { fatalError() }
    var exponentBitPattern: UInt { fatalError() }
    var significandBitPattern: UInt32 { fatalError() }
    init(sign: FloatingPointSign, exponentBitPattern: UInt, significandBitPattern: UInt32) {
        fatalError()
    }
    var isCanonical: Bool { fatalError() }
    static var infinity: Float { fatalError() }
    static var nan: Float { fatalError() }
    static var signalingNaN: Float { fatalError() }
    static var greatestFiniteMagnitude: Float { fatalError() }
    static var pi: Float { fatalError() }
    var ulp: Float { fatalError() }
    static var leastNormalMagnitude: Float { fatalError() }
    static var leastNonzeroMagnitude: Float { fatalError() }
    static var ulpOfOne: Float { fatalError() }
    var exponent: Int { fatalError() }
    var significand: Float { fatalError() }
    init(sign: FloatingPointSign, exponent: Int, significand: Float) { fatalError() }
    init(nan payload: Float.RawSignificand, signaling: Bool) { fatalError() }
    var nextUp: Float { fatalError() }
    init(signOf sign: Float, magnitudeOf mag: Float) { fatalError() }
    mutating func round(_ rule: FloatingPointRoundingRule) { fatalError() }
    mutating func negate() { fatalError() }
    static func += (lhs: inout Float, rhs: Float) { fatalError() }
    static func -= (lhs: inout Float, rhs: Float) { fatalError() }
    static func *= (lhs: inout Float, rhs: Float) { fatalError() }
    static func /= (lhs: inout Float, rhs: Float) { fatalError() }
    mutating func formRemainder(dividingBy other: Float) { fatalError() }
    mutating func formTruncatingRemainder(dividingBy other: Float) { fatalError() }
    mutating func formSquareRoot() { fatalError() }
    mutating func addProduct(_ lhs: Float, _ rhs: Float) { fatalError() }
    func isEqual(to other: Float) -> Bool { fatalError() }
    func isLess(than other: Float) -> Bool { fatalError() }
    func isLessThanOrEqualTo(_ other: Float) -> Bool { fatalError() }
    var isNormal: Bool { fatalError() }
    var isFinite: Bool { fatalError() }
    var isZero: Bool { fatalError() }
    var isSubnormal: Bool { fatalError() }
    var isInfinite: Bool { fatalError() }
    var isNaN: Bool { fatalError() }
    var isSignalingNaN: Bool { fatalError() }
    var binade: Float { fatalError() }
    var significandWidth: Int { fatalError() }
    init(floatLiteral value: Float) { fatalError() }
    typealias FloatLiteralType = Float
    typealias RawExponent = UInt
    init(integerLiteral value: Int64) { fatalError() }
    typealias IntegerLiteralType = Int64
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    var magnitude: Float { fatalError() }
    static func - (x: Float) -> Float { fatalError() }
    init(_ v: Int) { fatalError() }
    init<Source>(_ value: Source) where Source: BinaryInteger { fatalError() }
    init?<Source>(exactly value: Source) where Source: BinaryInteger { fatalError() }
    init(_ other: Float) { fatalError() }
    init?(exactly other: Float) { fatalError() }
    init(_ other: Double) { fatalError() }
    init?(exactly other: Double) { fatalError() }
    init(_ other: Float80) { fatalError() }
    init?(exactly other: Float80) { fatalError() }
    static func + (lhs: Float, rhs: Float) -> Float { fatalError() }
    static func - (lhs: Float, rhs: Float) -> Float { fatalError() }
    static func * (lhs: Float, rhs: Float) -> Float { fatalError() }
    static func / (lhs: Float, rhs: Float) -> Float { fatalError() }
    func distance(to other: Float) -> Float { fatalError() }
    func advanced(by amount: Float) -> Float { fatalError() }
    typealias Stride = Float
    typealias SIMDMaskScalar = Int32
    @frozen struct SIMD16Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Float { fatalError() }
        typealias Scalar = Float
    }
    @frozen struct SIMD2Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Float { fatalError() }
        typealias Scalar = Float
    }
    @frozen struct SIMD32Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Float { fatalError() }
        typealias Scalar = Float
    }
    @frozen struct SIMD4Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Float { fatalError() }
        typealias Scalar = Float
    }
    @frozen struct SIMD64Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Float { fatalError() }
        typealias Scalar = Float
    }
    @frozen struct SIMD8Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Float { fatalError() }
        typealias Scalar = Float
    }
}

@frozen struct Float80 {
    var customMirror: Mirror { fatalError() }
    init?<S>(_ text: S) where S: StringProtocol { fatalError() }
    init?(_ text: Substring) { fatalError() }
    init() { fatalError() }
    var description: String { fatalError() }
    var debugDescription: String { fatalError() }
    func write<Target>(to target: inout Target) where Target: TextOutputStream { fatalError() }
    typealias Magnitude = Float80
    typealias Exponent = Int
    typealias RawSignificand = UInt64
    static var exponentBitCount: Int { fatalError() }
    static var significandBitCount: Int { fatalError() }
    var sign: FloatingPointSign { fatalError() }
    var exponentBitPattern: UInt { fatalError() }
    var significandBitPattern: UInt64 { fatalError() }
    init(sign: FloatingPointSign, exponentBitPattern: UInt, significandBitPattern: UInt64) {
        fatalError()
    }
    var isCanonical: Bool { fatalError() }
    static var infinity: Float80 { fatalError() }
    static var nan: Float80 { fatalError() }
    static var signalingNaN: Float80 { fatalError() }
    static var greatestFiniteMagnitude: Float80 { fatalError() }
    static var pi: Float80 { fatalError() }
    var ulp: Float80 { fatalError() }
    static var leastNormalMagnitude: Float80 { fatalError() }
    static var leastNonzeroMagnitude: Float80 { fatalError() }
    static var ulpOfOne: Float80 { fatalError() }
    var exponent: Int { fatalError() }
    var significand: Float80 { fatalError() }
    init(sign: FloatingPointSign, exponent: Int, significand: Float80) { fatalError() }
    init(nan payload: Float80.RawSignificand, signaling: Bool) { fatalError() }
    var nextUp: Float80 { fatalError() }
    init(signOf sign: Float80, magnitudeOf mag: Float80) { fatalError() }
    mutating func round(_ rule: FloatingPointRoundingRule) { fatalError() }
    mutating func negate() { fatalError() }
    static func += (lhs: inout Float80, rhs: Float80) { fatalError() }
    static func -= (lhs: inout Float80, rhs: Float80) { fatalError() }
    static func *= (lhs: inout Float80, rhs: Float80) { fatalError() }
    static func /= (lhs: inout Float80, rhs: Float80) { fatalError() }
    mutating func formRemainder(dividingBy other: Float80) { fatalError() }
    mutating func formTruncatingRemainder(dividingBy other: Float80) { fatalError() }
    mutating func formSquareRoot() { fatalError() }
    mutating func addProduct(_ lhs: Float80, _ rhs: Float80) { fatalError() }
    func isEqual(to other: Float80) -> Bool { fatalError() }
    func isLess(than other: Float80) -> Bool { fatalError() }
    func isLessThanOrEqualTo(_ other: Float80) -> Bool { fatalError() }
    var isNormal: Bool { fatalError() }
    var isFinite: Bool { fatalError() }
    var isZero: Bool { fatalError() }
    var isSubnormal: Bool { fatalError() }
    var isInfinite: Bool { fatalError() }
    var isNaN: Bool { fatalError() }
    var isSignalingNaN: Bool { fatalError() }
    var binade: Float80 { fatalError() }
    var significandWidth: Int { fatalError() }
    init(floatLiteral value: Float80) { fatalError() }
    typealias FloatLiteralType = Float80
    typealias RawExponent = UInt
    init(integerLiteral value: Int64) { fatalError() }
    typealias IntegerLiteralType = Int64
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    var magnitude: Float80 { fatalError() }
    static func - (x: Float80) -> Float80 { fatalError() }
    init(_ v: Int) { fatalError() }
    init<Source>(_ value: Source) where Source: BinaryInteger { fatalError() }
    init?<Source>(exactly value: Source) where Source: BinaryInteger { fatalError() }
    init(_ other: Float) { fatalError() }
    init?(exactly other: Float) { fatalError() }
    init(_ other: Double) { fatalError() }
    init?(exactly other: Double) { fatalError() }
    init(_ other: Float80) { fatalError() }
    init?(exactly other: Float80) { fatalError() }
    static func + (lhs: Float80, rhs: Float80) -> Float80 { fatalError() }
    static func - (lhs: Float80, rhs: Float80) -> Float80 { fatalError() }
    static func * (lhs: Float80, rhs: Float80) -> Float80 { fatalError() }
    static func / (lhs: Float80, rhs: Float80) -> Float80 { fatalError() }
    func distance(to other: Float80) -> Float80 { fatalError() }
    func advanced(by amount: Float80) -> Float80 { fatalError() }
    typealias Stride = Float80
}

protocol FloatingPoint: Hashable, SignedNumeric, Strideable where Self == Self.Magnitude {
    associatedtype Exponent: SignedInteger
    init(sign: FloatingPointSign, exponent: Self.Exponent, significand: Self)
    init(signOf: Self, magnitudeOf: Self)
    init(_ value: Int)
    init<Source>(_ value: Source) where Source: BinaryInteger
    init?<Source>(exactly value: Source) where Source: BinaryInteger
    static var radix: Int { get }
    static var nan: Self { get }
    static var signalingNaN: Self { get }
    static var infinity: Self { get }
    static var greatestFiniteMagnitude: Self { get }
    static var pi: Self { get }
    var ulp: Self { get }
    static var ulpOfOne: Self { get }
    static var leastNormalMagnitude: Self { get }
    static var leastNonzeroMagnitude: Self { get }
    var sign: FloatingPointSign { get }
    var exponent: Self.Exponent { get }
    var significand: Self { get }
    override static func + (lhs: Self, rhs: Self) -> Self
    override static func += (lhs: inout Self, rhs: Self)
    override static func - (operand: Self) -> Self
    override mutating func negate()
    override static func - (lhs: Self, rhs: Self) -> Self
    override static func -= (lhs: inout Self, rhs: Self)
    override static func * (lhs: Self, rhs: Self) -> Self
    override static func *= (lhs: inout Self, rhs: Self)
    static func / (lhs: Self, rhs: Self) -> Self
    static func /= (lhs: inout Self, rhs: Self)
    func remainder(dividingBy other: Self) -> Self
    mutating func formRemainder(dividingBy other: Self)
    func truncatingRemainder(dividingBy other: Self) -> Self
    mutating func formTruncatingRemainder(dividingBy other: Self)
    func squareRoot() -> Self
    mutating func formSquareRoot()
    func addingProduct(_ lhs: Self, _ rhs: Self) -> Self
    mutating func addProduct(_ lhs: Self, _ rhs: Self)
    static func minimum(_ x: Self, _ y: Self) -> Self
    static func maximum(_ x: Self, _ y: Self) -> Self
    static func minimumMagnitude(_ x: Self, _ y: Self) -> Self
    static func maximumMagnitude(_ x: Self, _ y: Self) -> Self
    func rounded(_ rule: FloatingPointRoundingRule) -> Self
    mutating func round(_ rule: FloatingPointRoundingRule)
    var nextUp: Self { get }
    var nextDown: Self { get }
    func isEqual(to other: Self) -> Bool
    func isLess(than other: Self) -> Bool
    func isLessThanOrEqualTo(_ other: Self) -> Bool
    func isTotallyOrdered(belowOrEqualTo other: Self) -> Bool
    var isNormal: Bool { get }
    var isFinite: Bool { get }
    var isZero: Bool { get }
    var isSubnormal: Bool { get }
    var isInfinite: Bool { get }
    var isNaN: Bool { get }
    var isSignalingNaN: Bool { get }
    var floatingPointClass: FloatingPointClassification { get }
    var isCanonical: Bool { get }
    static func == (lhs: Self, rhs: Self) -> Bool
    static func < (lhs: Self, rhs: Self) -> Bool
    static func <= (lhs: Self, rhs: Self) -> Bool
    static func > (lhs: Self, rhs: Self) -> Bool
    static func >= (lhs: Self, rhs: Self) -> Bool
    func rounded() -> Self
    mutating func round()
}

@frozen enum FloatingPointClassification {
    case signalingNaN
    case quietNaN
    case negativeInfinity
    case negativeNormal
    case negativeSubnormal
    case negativeZero
    case positiveZero
    case positiveSubnormal
    case positiveNormal
    case positiveInfinity
    static func == (a: FloatingPointClassification, b: FloatingPointClassification) -> Bool {
        fatalError()
    }
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
}

enum FloatingPointRoundingRule {
    case toNearestOrAwayFromZero
    case toNearestOrEven
    case up
    case down
    case towardZero
    case awayFromZero
    static func == (a: FloatingPointRoundingRule, b: FloatingPointRoundingRule) -> Bool {
        fatalError()
    }
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
}

@frozen enum FloatingPointSign {
    case plus
    case minus
    init?(rawValue: Int) { fatalError() }
    var rawValue: Int { fatalError() }
    static func == (a: FloatingPointSign, b: FloatingPointSign) -> Bool { fatalError() }
    var hashValue: Int { fatalError() }
    func hash(into hasher: inout Hasher) { fatalError() }
    typealias RawValue = Int
}

protocol Hashable: Equatable, ~Copyable, ~Escapable {
    var hashValue: Int { get }
    func hash(into hasher: inout Hasher)
}

@frozen struct Hasher {
    init() { fatalError() }
    mutating func combine<H>(_ value: borrowing H) where H: Hashable, H: ~Copyable, H: ~Escapable {
        fatalError()
    }
    mutating func combine(bytes: UnsafeRawBufferPointer) { fatalError() }
    func finalize() -> Int { fatalError() }
}

protocol Identifiable<ID> {
    associatedtype ID: Hashable
    var id: Self.ID { get }
    var id: ObjectIdentifier { get }
}

@frozen struct IndexingIterator<Elements> where Elements: Collection {
    typealias Element = Elements.Element
    typealias Iterator = IndexingIterator<Elements>
    typealias SubSequence = AnySequence<IndexingIterator<Elements>.Element>
    mutating func next() -> Elements.Element? { fatalError() }
}

@frozen struct InlineArray<let count: Int, Element> where Element: ~Copyable {
    init<E>(_ body: (InlineArray<count, Element>.Index) throws(E) -> Element) throws(E)
    where E: Error { fatalError() }
    init<E>(first: consuming Element, next: (borrowing Element) throws(E) -> Element) throws(E)
    where E: Error { fatalError() }
    init<E>(initializingWith initializer: (inout OutputSpan<Element>) throws(E) -> Void) throws(E)
    where E: Error { fatalError() }
    init(repeating value: Element) { fatalError() }
    typealias Element = Element
    typealias Index = Int
    var count: Int { fatalError() }
    var isEmpty: Bool { fatalError() }
    var startIndex: InlineArray<count, Element>.Index { fatalError() }
    var endIndex: InlineArray<count, Element>.Index { fatalError() }
    var indices: Range<InlineArray<count, Element>.Index> { fatalError() }
    borrowing func index(after i: InlineArray<count, Element>.Index)
        -> InlineArray<count, Element>.Index
    { fatalError() }
    borrowing func index(before i: InlineArray<count, Element>.Index)
        -> InlineArray<count, Element>.Index
    { fatalError() }
    subscript(i: InlineArray<count, Element>.Index) -> Element { fatalError() }
    subscript(unchecked i: InlineArray<count, Element>.Index) -> Element { fatalError() }
    mutating func swapAt(
        _ i: InlineArray<count, Element>.Index, _ j: InlineArray<count, Element>.Index
    ) { fatalError() }
    var span: Span<Element> { fatalError() }
    var mutableSpan: MutableSpan<Element> { fatalError() }
    typealias BorrowingIterator = Span<Element>.BorrowingIterator
    typealias Failure = Never
    @export(implementation) var underestimatedCount: Int { fatalError() }
    @export(implementation) func makeBorrowingIterator()
        -> InlineArray<count, Element>.BorrowingIterator
    { fatalError() }
}

protocol InstantProtocol<Duration>: Comparable, Hashable, Sendable {
    associatedtype Duration: DurationProtocol
    func advanced(by duration: Self.Duration) -> Self
    func duration(to other: Self) -> Self.Duration
}

@frozen struct Int {
    init(from decoder: any Decoder) throws { fatalError() }
    func encode(to encoder: any Encoder) throws { fatalError() }
    var codingKey: any CodingKey { fatalError() }
    init?<T>(codingKey: T) where T: CodingKey { fatalError() }
    init(bitPattern pointer: OpaquePointer?) { fatalError() }
    var customMirror: Mirror { fatalError() }
    var customPlaygroundQuickLook: _PlaygroundQuickLook { fatalError() }
    init(bitPattern objectID: ObjectIdentifier) { fatalError() }
    init<P>(bitPattern pointer: P?) where P: _Pointer { fatalError() }
    typealias IntegerLiteralType = Int
    init(bitPattern x: UInt) { fatalError() }
    init(_ source: Float) { fatalError() }
    init?(exactly source: Float) { fatalError() }
    init(_ source: Double) { fatalError() }
    init?(exactly source: Double) { fatalError() }
    init(_ source: Float80) { fatalError() }
    init?(exactly source: Float80) { fatalError() }
    static func == (lhs: Int, rhs: Int) -> Bool { fatalError() }
    static func < (lhs: Int, rhs: Int) -> Bool { fatalError() }
    static func += (lhs: inout Int, rhs: Int) { fatalError() }
    static func -= (lhs: inout Int, rhs: Int) { fatalError() }
    static func *= (lhs: inout Int, rhs: Int) { fatalError() }
    static func /= (lhs: inout Int, rhs: Int) { fatalError() }
    func addingReportingOverflow(_ other: Int) -> (partialValue: Int, overflow: Bool) {
        fatalError()
    }
    func subtractingReportingOverflow(_ other: Int) -> (partialValue: Int, overflow: Bool) {
        fatalError()
    }
    func multipliedReportingOverflow(by other: Int) -> (partialValue: Int, overflow: Bool) {
        fatalError()
    }
    func dividedReportingOverflow(by other: Int) -> (partialValue: Int, overflow: Bool) {
        fatalError()
    }
    func remainderReportingOverflow(dividingBy other: Int) -> (partialValue: Int, overflow: Bool) {
        fatalError()
    }
    static func %= (lhs: inout Int, rhs: Int) { fatalError() }
    static func &= (lhs: inout Int, rhs: Int) { fatalError() }
    static func |= (lhs: inout Int, rhs: Int) { fatalError() }
    static func ^= (lhs: inout Int, rhs: Int) { fatalError() }
    static func &>>= (lhs: inout Int, rhs: Int) { fatalError() }
    static func &<<= (lhs: inout Int, rhs: Int) { fatalError() }
    static var bitWidth: Int { fatalError() }
    var leadingZeroBitCount: Int { fatalError() }
    var trailingZeroBitCount: Int { fatalError() }
    var nonzeroBitCount: Int { fatalError() }
    var words: Int.Words { fatalError() }
    typealias Magnitude = UInt
    var magnitude: UInt { fatalError() }
    func multipliedFullWidth(by other: Int) -> (high: Int, low: Int.Magnitude) { fatalError() }
    func dividingFullWidth(_ dividend: (high: Int, low: Int.Magnitude)) -> (
        quotient: Int, remainder: Int
    ) { fatalError() }
    var byteSwapped: Int { fatalError() }
    func signum() -> Int { fatalError() }
    typealias Stride = Int
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    static func & (lhs: Int, rhs: Int) -> Int { fatalError() }
    static func | (lhs: Int, rhs: Int) -> Int { fatalError() }
    static func ^ (lhs: Int, rhs: Int) -> Int { fatalError() }
    static func &>> (lhs: Int, rhs: Int) -> Int { fatalError() }
    static func &<< (lhs: Int, rhs: Int) -> Int { fatalError() }
    static func + (lhs: Int, rhs: Int) -> Int { fatalError() }
    static func - (lhs: Int, rhs: Int) -> Int { fatalError() }
    static func * (lhs: Int, rhs: Int) -> Int { fatalError() }
    static func / (lhs: Int, rhs: Int) -> Int { fatalError() }
    static func % (lhs: Int, rhs: Int) -> Int { fatalError() }
    static func != (lhs: Int, rhs: Int) -> Bool { fatalError() }
    static func <= (lhs: Int, rhs: Int) -> Bool { fatalError() }
    static func >= (lhs: Int, rhs: Int) -> Bool { fatalError() }
    static func > (lhs: Int, rhs: Int) -> Bool { fatalError() }
    func distance(to other: Int) -> Int { fatalError() }
    func advanced(by n: Int) -> Int { fatalError() }
    typealias SIMDMaskScalar = Int
    @frozen struct SIMD16Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Int { fatalError() }
        typealias Scalar = Int
    }
    @frozen struct SIMD2Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Int { fatalError() }
        typealias Scalar = Int
    }
    @frozen struct SIMD32Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Int { fatalError() }
        typealias Scalar = Int
    }
    @frozen struct SIMD4Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Int { fatalError() }
        typealias Scalar = Int
    }
    @frozen struct SIMD64Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Int { fatalError() }
        typealias Scalar = Int
    }
    @frozen struct SIMD8Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Int { fatalError() }
        typealias Scalar = Int
    }
    @frozen struct Words {
        typealias Indices = Range<Int>
        typealias SubSequence = Slice<Int.Words>
        init(_ value: Int) { fatalError() }
        var count: Int { fatalError() }
        var startIndex: Int { fatalError() }
        var endIndex: Int { fatalError() }
        var indices: Int.Words.Indices { fatalError() }
        func index(after i: Int) -> Int { fatalError() }
        func index(before i: Int) -> Int { fatalError() }
        subscript(position: Int) -> UInt { fatalError() }
        typealias Element = UInt
        typealias Index = Int
        typealias Iterator = IndexingIterator<Int.Words>
    }
}

@frozen struct Int128 {
    init(from decoder: any Decoder) throws { fatalError() }
    func encode(to encoder: any Encoder) throws { fatalError() }
    var customMirror: Mirror { fatalError() }
    init(bitPattern: UInt128) { fatalError() }
    static var zero: Int128 { fatalError() }
    static var min: Int128 { fatalError() }
    static var max: Int128 { fatalError() }
    typealias IntegerLiteralType = Int128
    init?<T>(exactly source: T) where T: BinaryInteger { fatalError() }
    init<T>(_ source: T) where T: BinaryInteger { fatalError() }
    init<T>(clamping source: T) where T: BinaryInteger { fatalError() }
    init<T>(truncatingIfNeeded source: T) where T: BinaryInteger { fatalError() }
    init?<T>(exactly source: T) where T: BinaryFloatingPoint { fatalError() }
    init<T>(_ source: T) where T: BinaryFloatingPoint { fatalError() }
    static func == (a: Int128, b: Int128) -> Bool { fatalError() }
    static func < (a: Int128, b: Int128) -> Bool { fatalError() }
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    func addingReportingOverflow(_ other: Int128) -> (partialValue: Int128, overflow: Bool) {
        fatalError()
    }
    func subtractingReportingOverflow(_ other: Int128) -> (partialValue: Int128, overflow: Bool) {
        fatalError()
    }
    func multipliedReportingOverflow(by other: Int128) -> (partialValue: Int128, overflow: Bool) {
        fatalError()
    }
    func dividedReportingOverflow(by other: Int128) -> (partialValue: Int128, overflow: Bool) {
        fatalError()
    }
    func remainderReportingOverflow(dividingBy other: Int128) -> (
        partialValue: Int128, overflow: Bool
    ) { fatalError() }
    static func + (a: Int128, b: Int128) -> Int128 { fatalError() }
    static func - (a: Int128, b: Int128) -> Int128 { fatalError() }
    static func * (a: Int128, b: Int128) -> Int128 { fatalError() }
    static func *= (a: inout Int128, b: Int128) { fatalError() }
    static func / (a: Int128, b: Int128) -> Int128 { fatalError() }
    static func /= (a: inout Int128, b: Int128) { fatalError() }
    static func % (a: Int128, b: Int128) -> Int128 { fatalError() }
    static func %= (a: inout Int128, b: Int128) { fatalError() }
    typealias Magnitude = UInt128
    var magnitude: Int128.Magnitude { fatalError() }
    var words: UInt128.Words { fatalError() }
    static func &= (a: inout Int128, b: Int128) { fatalError() }
    static func |= (a: inout Int128, b: Int128) { fatalError() }
    static func ^= (a: inout Int128, b: Int128) { fatalError() }
    static func &>>= (a: inout Int128, b: Int128) { fatalError() }
    static func &<<= (a: inout Int128, b: Int128) { fatalError() }
    var trailingZeroBitCount: Int { fatalError() }
    typealias Stride = Int
    typealias Words = UInt128.Words
    static var bitWidth: Int { fatalError() }
    var nonzeroBitCount: Int { fatalError() }
    var leadingZeroBitCount: Int { fatalError() }
    var byteSwapped: Int128 { fatalError() }
    static func &* (lhs: Int128, rhs: Int128) -> Int128 { fatalError() }
    static func != (lhs: Int128, rhs: Int128) -> Bool { fatalError() }
    static func <= (lhs: Int128, rhs: Int128) -> Bool { fatalError() }
    static func >= (lhs: Int128, rhs: Int128) -> Bool { fatalError() }
    static func > (lhs: Int128, rhs: Int128) -> Bool { fatalError() }
}

@frozen struct Int16 {
    init(from decoder: any Decoder) throws { fatalError() }
    func encode(to encoder: any Encoder) throws { fatalError() }
    var customMirror: Mirror { fatalError() }
    var customPlaygroundQuickLook: _PlaygroundQuickLook { fatalError() }
    typealias IntegerLiteralType = Int16
    init(bitPattern x: UInt16) { fatalError() }
    init(_ source: Float) { fatalError() }
    init?(exactly source: Float) { fatalError() }
    init(_ source: Double) { fatalError() }
    init?(exactly source: Double) { fatalError() }
    init(_ source: Float80) { fatalError() }
    init?(exactly source: Float80) { fatalError() }
    static func == (lhs: Int16, rhs: Int16) -> Bool { fatalError() }
    static func < (lhs: Int16, rhs: Int16) -> Bool { fatalError() }
    static func += (lhs: inout Int16, rhs: Int16) { fatalError() }
    static func -= (lhs: inout Int16, rhs: Int16) { fatalError() }
    static func *= (lhs: inout Int16, rhs: Int16) { fatalError() }
    static func /= (lhs: inout Int16, rhs: Int16) { fatalError() }
    func addingReportingOverflow(_ other: Int16) -> (partialValue: Int16, overflow: Bool) {
        fatalError()
    }
    func subtractingReportingOverflow(_ other: Int16) -> (partialValue: Int16, overflow: Bool) {
        fatalError()
    }
    func multipliedReportingOverflow(by other: Int16) -> (partialValue: Int16, overflow: Bool) {
        fatalError()
    }
    func dividedReportingOverflow(by other: Int16) -> (partialValue: Int16, overflow: Bool) {
        fatalError()
    }
    func remainderReportingOverflow(dividingBy other: Int16) -> (
        partialValue: Int16, overflow: Bool
    ) { fatalError() }
    static func %= (lhs: inout Int16, rhs: Int16) { fatalError() }
    static func &= (lhs: inout Int16, rhs: Int16) { fatalError() }
    static func |= (lhs: inout Int16, rhs: Int16) { fatalError() }
    static func ^= (lhs: inout Int16, rhs: Int16) { fatalError() }
    static func &>>= (lhs: inout Int16, rhs: Int16) { fatalError() }
    static func &<<= (lhs: inout Int16, rhs: Int16) { fatalError() }
    static var bitWidth: Int { fatalError() }
    var leadingZeroBitCount: Int { fatalError() }
    var trailingZeroBitCount: Int { fatalError() }
    var nonzeroBitCount: Int { fatalError() }
    var words: Int16.Words { fatalError() }
    typealias Magnitude = UInt16
    var magnitude: UInt16 { fatalError() }
    func multipliedFullWidth(by other: Int16) -> (high: Int16, low: Int16.Magnitude) {
        fatalError()
    }
    func dividingFullWidth(_ dividend: (high: Int16, low: Int16.Magnitude)) -> (
        quotient: Int16, remainder: Int16
    ) { fatalError() }
    var byteSwapped: Int16 { fatalError() }
    func signum() -> Int16 { fatalError() }
    typealias Stride = Int
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    static func & (lhs: Int16, rhs: Int16) -> Int16 { fatalError() }
    static func | (lhs: Int16, rhs: Int16) -> Int16 { fatalError() }
    static func ^ (lhs: Int16, rhs: Int16) -> Int16 { fatalError() }
    static func &>> (lhs: Int16, rhs: Int16) -> Int16 { fatalError() }
    static func &<< (lhs: Int16, rhs: Int16) -> Int16 { fatalError() }
    static func + (lhs: Int16, rhs: Int16) -> Int16 { fatalError() }
    static func - (lhs: Int16, rhs: Int16) -> Int16 { fatalError() }
    static func * (lhs: Int16, rhs: Int16) -> Int16 { fatalError() }
    static func / (lhs: Int16, rhs: Int16) -> Int16 { fatalError() }
    static func % (lhs: Int16, rhs: Int16) -> Int16 { fatalError() }
    static func != (lhs: Int16, rhs: Int16) -> Bool { fatalError() }
    static func <= (lhs: Int16, rhs: Int16) -> Bool { fatalError() }
    static func >= (lhs: Int16, rhs: Int16) -> Bool { fatalError() }
    static func > (lhs: Int16, rhs: Int16) -> Bool { fatalError() }
    typealias SIMDMaskScalar = Int16
    @frozen struct SIMD16Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Int16 { fatalError() }
        typealias Scalar = Int16
    }
    @frozen struct SIMD2Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Int16 { fatalError() }
        typealias Scalar = Int16
    }
    @frozen struct SIMD32Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Int16 { fatalError() }
        typealias Scalar = Int16
    }
    @frozen struct SIMD4Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Int16 { fatalError() }
        typealias Scalar = Int16
    }
    @frozen struct SIMD64Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Int16 { fatalError() }
        typealias Scalar = Int16
    }
    @frozen struct SIMD8Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Int16 { fatalError() }
        typealias Scalar = Int16
    }
    @frozen struct Words {
        typealias Indices = Range<Int>
        typealias SubSequence = Slice<Int16.Words>
        init(_ value: Int16) { fatalError() }
        var count: Int { fatalError() }
        var startIndex: Int { fatalError() }
        var endIndex: Int { fatalError() }
        var indices: Int16.Words.Indices { fatalError() }
        func index(after i: Int) -> Int { fatalError() }
        func index(before i: Int) -> Int { fatalError() }
        subscript(position: Int) -> UInt { fatalError() }
        typealias Element = UInt
        typealias Index = Int
        typealias Iterator = IndexingIterator<Int16.Words>
    }
}

@frozen struct Int32 {
    init(from decoder: any Decoder) throws { fatalError() }
    func encode(to encoder: any Encoder) throws { fatalError() }
    var customMirror: Mirror { fatalError() }
    var customPlaygroundQuickLook: _PlaygroundQuickLook { fatalError() }
    typealias IntegerLiteralType = Int32
    init(bitPattern x: UInt32) { fatalError() }
    init(_ source: Float) { fatalError() }
    init?(exactly source: Float) { fatalError() }
    init(_ source: Double) { fatalError() }
    init?(exactly source: Double) { fatalError() }
    init(_ source: Float80) { fatalError() }
    init?(exactly source: Float80) { fatalError() }
    static func == (lhs: Int32, rhs: Int32) -> Bool { fatalError() }
    static func < (lhs: Int32, rhs: Int32) -> Bool { fatalError() }
    static func += (lhs: inout Int32, rhs: Int32) { fatalError() }
    static func -= (lhs: inout Int32, rhs: Int32) { fatalError() }
    static func *= (lhs: inout Int32, rhs: Int32) { fatalError() }
    static func /= (lhs: inout Int32, rhs: Int32) { fatalError() }
    func addingReportingOverflow(_ other: Int32) -> (partialValue: Int32, overflow: Bool) {
        fatalError()
    }
    func subtractingReportingOverflow(_ other: Int32) -> (partialValue: Int32, overflow: Bool) {
        fatalError()
    }
    func multipliedReportingOverflow(by other: Int32) -> (partialValue: Int32, overflow: Bool) {
        fatalError()
    }
    func dividedReportingOverflow(by other: Int32) -> (partialValue: Int32, overflow: Bool) {
        fatalError()
    }
    func remainderReportingOverflow(dividingBy other: Int32) -> (
        partialValue: Int32, overflow: Bool
    ) { fatalError() }
    static func %= (lhs: inout Int32, rhs: Int32) { fatalError() }
    static func &= (lhs: inout Int32, rhs: Int32) { fatalError() }
    static func |= (lhs: inout Int32, rhs: Int32) { fatalError() }
    static func ^= (lhs: inout Int32, rhs: Int32) { fatalError() }
    static func &>>= (lhs: inout Int32, rhs: Int32) { fatalError() }
    static func &<<= (lhs: inout Int32, rhs: Int32) { fatalError() }
    static var bitWidth: Int { fatalError() }
    var leadingZeroBitCount: Int { fatalError() }
    var trailingZeroBitCount: Int { fatalError() }
    var nonzeroBitCount: Int { fatalError() }
    var words: Int32.Words { fatalError() }
    typealias Magnitude = UInt32
    var magnitude: UInt32 { fatalError() }
    func multipliedFullWidth(by other: Int32) -> (high: Int32, low: Int32.Magnitude) {
        fatalError()
    }
    func dividingFullWidth(_ dividend: (high: Int32, low: Int32.Magnitude)) -> (
        quotient: Int32, remainder: Int32
    ) { fatalError() }
    var byteSwapped: Int32 { fatalError() }
    func signum() -> Int32 { fatalError() }
    typealias Stride = Int
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    static func & (lhs: Int32, rhs: Int32) -> Int32 { fatalError() }
    static func | (lhs: Int32, rhs: Int32) -> Int32 { fatalError() }
    static func ^ (lhs: Int32, rhs: Int32) -> Int32 { fatalError() }
    static func &>> (lhs: Int32, rhs: Int32) -> Int32 { fatalError() }
    static func &<< (lhs: Int32, rhs: Int32) -> Int32 { fatalError() }
    static func + (lhs: Int32, rhs: Int32) -> Int32 { fatalError() }
    static func - (lhs: Int32, rhs: Int32) -> Int32 { fatalError() }
    static func * (lhs: Int32, rhs: Int32) -> Int32 { fatalError() }
    static func / (lhs: Int32, rhs: Int32) -> Int32 { fatalError() }
    static func % (lhs: Int32, rhs: Int32) -> Int32 { fatalError() }
    static func != (lhs: Int32, rhs: Int32) -> Bool { fatalError() }
    static func <= (lhs: Int32, rhs: Int32) -> Bool { fatalError() }
    static func >= (lhs: Int32, rhs: Int32) -> Bool { fatalError() }
    static func > (lhs: Int32, rhs: Int32) -> Bool { fatalError() }
    typealias SIMDMaskScalar = Int32
    @frozen struct SIMD16Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Int32 { fatalError() }
        typealias Scalar = Int32
    }
    @frozen struct SIMD2Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Int32 { fatalError() }
        typealias Scalar = Int32
    }
    @frozen struct SIMD32Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Int32 { fatalError() }
        typealias Scalar = Int32
    }
    @frozen struct SIMD4Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Int32 { fatalError() }
        typealias Scalar = Int32
    }
    @frozen struct SIMD64Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Int32 { fatalError() }
        typealias Scalar = Int32
    }
    @frozen struct SIMD8Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Int32 { fatalError() }
        typealias Scalar = Int32
    }
    @frozen struct Words {
        typealias Indices = Range<Int>
        typealias SubSequence = Slice<Int32.Words>
        init(_ value: Int32) { fatalError() }
        var count: Int { fatalError() }
        var startIndex: Int { fatalError() }
        var endIndex: Int { fatalError() }
        var indices: Int32.Words.Indices { fatalError() }
        func index(after i: Int) -> Int { fatalError() }
        func index(before i: Int) -> Int { fatalError() }
        subscript(position: Int) -> UInt { fatalError() }
        typealias Element = UInt
        typealias Index = Int
        typealias Iterator = IndexingIterator<Int32.Words>
    }
}

@frozen struct Int64 {
    init(from decoder: any Decoder) throws { fatalError() }
    func encode(to encoder: any Encoder) throws { fatalError() }
    var customMirror: Mirror { fatalError() }
    var customPlaygroundQuickLook: _PlaygroundQuickLook { fatalError() }
    typealias IntegerLiteralType = Int64
    init(bitPattern x: UInt64) { fatalError() }
    init(_ source: Float) { fatalError() }
    init?(exactly source: Float) { fatalError() }
    init(_ source: Double) { fatalError() }
    init?(exactly source: Double) { fatalError() }
    init(_ source: Float80) { fatalError() }
    init?(exactly source: Float80) { fatalError() }
    static func == (lhs: Int64, rhs: Int64) -> Bool { fatalError() }
    static func < (lhs: Int64, rhs: Int64) -> Bool { fatalError() }
    static func += (lhs: inout Int64, rhs: Int64) { fatalError() }
    static func -= (lhs: inout Int64, rhs: Int64) { fatalError() }
    static func *= (lhs: inout Int64, rhs: Int64) { fatalError() }
    static func /= (lhs: inout Int64, rhs: Int64) { fatalError() }
    func addingReportingOverflow(_ other: Int64) -> (partialValue: Int64, overflow: Bool) {
        fatalError()
    }
    func subtractingReportingOverflow(_ other: Int64) -> (partialValue: Int64, overflow: Bool) {
        fatalError()
    }
    func multipliedReportingOverflow(by other: Int64) -> (partialValue: Int64, overflow: Bool) {
        fatalError()
    }
    func dividedReportingOverflow(by other: Int64) -> (partialValue: Int64, overflow: Bool) {
        fatalError()
    }
    func remainderReportingOverflow(dividingBy other: Int64) -> (
        partialValue: Int64, overflow: Bool
    ) { fatalError() }
    static func %= (lhs: inout Int64, rhs: Int64) { fatalError() }
    static func &= (lhs: inout Int64, rhs: Int64) { fatalError() }
    static func |= (lhs: inout Int64, rhs: Int64) { fatalError() }
    static func ^= (lhs: inout Int64, rhs: Int64) { fatalError() }
    static func &>>= (lhs: inout Int64, rhs: Int64) { fatalError() }
    static func &<<= (lhs: inout Int64, rhs: Int64) { fatalError() }
    static var bitWidth: Int { fatalError() }
    var leadingZeroBitCount: Int { fatalError() }
    var trailingZeroBitCount: Int { fatalError() }
    var nonzeroBitCount: Int { fatalError() }
    var words: Int64.Words { fatalError() }
    typealias Magnitude = UInt64
    var magnitude: UInt64 { fatalError() }
    func multipliedFullWidth(by other: Int64) -> (high: Int64, low: Int64.Magnitude) {
        fatalError()
    }
    func dividingFullWidth(_ dividend: (high: Int64, low: Int64.Magnitude)) -> (
        quotient: Int64, remainder: Int64
    ) { fatalError() }
    var byteSwapped: Int64 { fatalError() }
    func signum() -> Int64 { fatalError() }
    typealias Stride = Int
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    static func & (lhs: Int64, rhs: Int64) -> Int64 { fatalError() }
    static func | (lhs: Int64, rhs: Int64) -> Int64 { fatalError() }
    static func ^ (lhs: Int64, rhs: Int64) -> Int64 { fatalError() }
    static func &>> (lhs: Int64, rhs: Int64) -> Int64 { fatalError() }
    static func &<< (lhs: Int64, rhs: Int64) -> Int64 { fatalError() }
    static func + (lhs: Int64, rhs: Int64) -> Int64 { fatalError() }
    static func - (lhs: Int64, rhs: Int64) -> Int64 { fatalError() }
    static func * (lhs: Int64, rhs: Int64) -> Int64 { fatalError() }
    static func / (lhs: Int64, rhs: Int64) -> Int64 { fatalError() }
    static func % (lhs: Int64, rhs: Int64) -> Int64 { fatalError() }
    static func != (lhs: Int64, rhs: Int64) -> Bool { fatalError() }
    static func <= (lhs: Int64, rhs: Int64) -> Bool { fatalError() }
    static func >= (lhs: Int64, rhs: Int64) -> Bool { fatalError() }
    static func > (lhs: Int64, rhs: Int64) -> Bool { fatalError() }
    typealias SIMDMaskScalar = Int64
    @frozen struct SIMD16Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Int64 { fatalError() }
        typealias Scalar = Int64
    }
    @frozen struct SIMD2Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Int64 { fatalError() }
        typealias Scalar = Int64
    }
    @frozen struct SIMD32Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Int64 { fatalError() }
        typealias Scalar = Int64
    }
    @frozen struct SIMD4Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Int64 { fatalError() }
        typealias Scalar = Int64
    }
    @frozen struct SIMD64Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Int64 { fatalError() }
        typealias Scalar = Int64
    }
    @frozen struct SIMD8Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Int64 { fatalError() }
        typealias Scalar = Int64
    }
    @frozen struct Words {
        typealias Indices = Range<Int>
        typealias SubSequence = Slice<Int64.Words>
        init(_ value: Int64) { fatalError() }
        var count: Int { fatalError() }
        var startIndex: Int { fatalError() }
        var endIndex: Int { fatalError() }
        var indices: Int64.Words.Indices { fatalError() }
        func index(after i: Int) -> Int { fatalError() }
        func index(before i: Int) -> Int { fatalError() }
        subscript(position: Int) -> UInt { fatalError() }
        typealias Element = UInt
        typealias Index = Int
        typealias Iterator = IndexingIterator<Int64.Words>
    }
}

@frozen struct Int8 {
    init(from decoder: any Decoder) throws { fatalError() }
    func encode(to encoder: any Encoder) throws { fatalError() }
    var customMirror: Mirror { fatalError() }
    var customPlaygroundQuickLook: _PlaygroundQuickLook { fatalError() }
    typealias IntegerLiteralType = Int8
    init(bitPattern x: UInt8) { fatalError() }
    init(_ source: Float) { fatalError() }
    init?(exactly source: Float) { fatalError() }
    init(_ source: Double) { fatalError() }
    init?(exactly source: Double) { fatalError() }
    init(_ source: Float80) { fatalError() }
    init?(exactly source: Float80) { fatalError() }
    static func == (lhs: Int8, rhs: Int8) -> Bool { fatalError() }
    static func < (lhs: Int8, rhs: Int8) -> Bool { fatalError() }
    static func += (lhs: inout Int8, rhs: Int8) { fatalError() }
    static func -= (lhs: inout Int8, rhs: Int8) { fatalError() }
    static func *= (lhs: inout Int8, rhs: Int8) { fatalError() }
    static func /= (lhs: inout Int8, rhs: Int8) { fatalError() }
    func addingReportingOverflow(_ other: Int8) -> (partialValue: Int8, overflow: Bool) {
        fatalError()
    }
    func subtractingReportingOverflow(_ other: Int8) -> (partialValue: Int8, overflow: Bool) {
        fatalError()
    }
    func multipliedReportingOverflow(by other: Int8) -> (partialValue: Int8, overflow: Bool) {
        fatalError()
    }
    func dividedReportingOverflow(by other: Int8) -> (partialValue: Int8, overflow: Bool) {
        fatalError()
    }
    func remainderReportingOverflow(dividingBy other: Int8) -> (partialValue: Int8, overflow: Bool)
    { fatalError() }
    static func %= (lhs: inout Int8, rhs: Int8) { fatalError() }
    static func &= (lhs: inout Int8, rhs: Int8) { fatalError() }
    static func |= (lhs: inout Int8, rhs: Int8) { fatalError() }
    static func ^= (lhs: inout Int8, rhs: Int8) { fatalError() }
    static func &>>= (lhs: inout Int8, rhs: Int8) { fatalError() }
    static func &<<= (lhs: inout Int8, rhs: Int8) { fatalError() }
    static var bitWidth: Int { fatalError() }
    var leadingZeroBitCount: Int { fatalError() }
    var trailingZeroBitCount: Int { fatalError() }
    var nonzeroBitCount: Int { fatalError() }
    var words: Int8.Words { fatalError() }
    typealias Magnitude = UInt8
    var magnitude: UInt8 { fatalError() }
    func multipliedFullWidth(by other: Int8) -> (high: Int8, low: Int8.Magnitude) { fatalError() }
    func dividingFullWidth(_ dividend: (high: Int8, low: Int8.Magnitude)) -> (
        quotient: Int8, remainder: Int8
    ) { fatalError() }
    var byteSwapped: Int8 { fatalError() }
    func signum() -> Int8 { fatalError() }
    typealias Stride = Int
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    static func & (lhs: Int8, rhs: Int8) -> Int8 { fatalError() }
    static func | (lhs: Int8, rhs: Int8) -> Int8 { fatalError() }
    static func ^ (lhs: Int8, rhs: Int8) -> Int8 { fatalError() }
    static func &>> (lhs: Int8, rhs: Int8) -> Int8 { fatalError() }
    static func &<< (lhs: Int8, rhs: Int8) -> Int8 { fatalError() }
    static func + (lhs: Int8, rhs: Int8) -> Int8 { fatalError() }
    static func - (lhs: Int8, rhs: Int8) -> Int8 { fatalError() }
    static func * (lhs: Int8, rhs: Int8) -> Int8 { fatalError() }
    static func / (lhs: Int8, rhs: Int8) -> Int8 { fatalError() }
    static func % (lhs: Int8, rhs: Int8) -> Int8 { fatalError() }
    static func != (lhs: Int8, rhs: Int8) -> Bool { fatalError() }
    static func <= (lhs: Int8, rhs: Int8) -> Bool { fatalError() }
    static func >= (lhs: Int8, rhs: Int8) -> Bool { fatalError() }
    static func > (lhs: Int8, rhs: Int8) -> Bool { fatalError() }
    typealias SIMDMaskScalar = Int8
    @frozen struct SIMD16Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Int8 { fatalError() }
        typealias Scalar = Int8
    }
    @frozen struct SIMD2Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Int8 { fatalError() }
        typealias Scalar = Int8
    }
    @frozen struct SIMD32Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Int8 { fatalError() }
        typealias Scalar = Int8
    }
    @frozen struct SIMD4Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Int8 { fatalError() }
        typealias Scalar = Int8
    }
    @frozen struct SIMD64Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Int8 { fatalError() }
        typealias Scalar = Int8
    }
    @frozen struct SIMD8Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> Int8 { fatalError() }
        typealias Scalar = Int8
    }
    @frozen struct Words {
        typealias Indices = Range<Int>
        typealias SubSequence = Slice<Int8.Words>
        init(_ value: Int8) { fatalError() }
        var count: Int { fatalError() }
        var startIndex: Int { fatalError() }
        var endIndex: Int { fatalError() }
        var indices: Int8.Words.Indices { fatalError() }
        func index(after i: Int) -> Int { fatalError() }
        func index(before i: Int) -> Int { fatalError() }
        subscript(position: Int) -> UInt { fatalError() }
        typealias Element = UInt
        typealias Index = Int
        typealias Iterator = IndexingIterator<Int8.Words>
    }
}

protocol Iterable<Element, Failure>: ~Copyable, ~Escapable {
    associatedtype Element: ~Copyable where Self.Element == Self.BorrowingIterator.Element
    associatedtype Failure = Never where Self.Failure == Self.BorrowingIterator.Failure
    associatedtype BorrowingIterator: BorrowingIteratorProtocol, ~Copyable, ~Escapable
    func makeBorrowingIterator() -> Self.BorrowingIterator
    var underestimatedCount: Int { get }
    func makeBorrowingIterator() -> Self
}

protocol IteratorProtocol<Element> {
    associatedtype Element
    mutating func next() -> Self.Element?
}

@frozen struct IteratorSequence<Base> where Base: IteratorProtocol {
    init(_ base: Base) { fatalError() }
    typealias Element = Base.Element
    mutating func next() -> Base.Element? { fatalError() }
    typealias Iterator = IteratorSequence<Base>
}

@frozen struct JoinedSequence<Base> where Base: Sequence, Base.Element: Sequence {
    typealias Element = Base.Element.Element
    init<Separator>(base: Base, separator: Separator)
    where Separator: Sequence, Separator.Element == Base.Element.Element { fatalError() }
    func makeIterator() -> JoinedSequence<Base>.Iterator { fatalError() }
    @frozen struct Iterator {
        init<Separator>(base: Base.Iterator, separator: Separator)
        where Separator: Sequence, Separator.Element == Base.Element.Element { fatalError() }
        typealias Element = Base.Element.Element
        mutating func next() -> JoinedSequence<Base>.Iterator.Element? { fatalError() }
    }
}

class KeyPath<Root, Value> {
}

@frozen struct KeyValuePairs<Key, Value> {
    init(dictionaryLiteral elements: (Key, Value)...) { fatalError() }
    typealias Element = (key: Key, value: Value)
    typealias Index = Int
    typealias Indices = Range<Int>
    typealias SubSequence = Slice<KeyValuePairs<Key, Value>>
    var startIndex: KeyValuePairs<Key, Value>.Index { fatalError() }
    var endIndex: KeyValuePairs<Key, Value>.Index { fatalError() }
    subscript(position: KeyValuePairs<Key, Value>.Index) -> KeyValuePairs<Key, Value>.Element {
        fatalError()
    }
    typealias Iterator = IndexingIterator<KeyValuePairs<Key, Value>>
    var span: Span<KeyValuePairs<Key, Value>.Element> { fatalError() }
    var description: String { fatalError() }
    var debugDescription: String { fatalError() }
}

struct KeyedDecodingContainer<K> where K: CodingKey {
    typealias Key = K
    init<Container>(_ container: Container)
    where K == Container.Key, Container: KeyedDecodingContainerProtocol { fatalError() }
    var codingPath: [any CodingKey] { fatalError() }
    var allKeys: [KeyedDecodingContainer<K>.Key] { fatalError() }
    func contains(_ key: KeyedDecodingContainer<K>.Key) -> Bool { fatalError() }
    func decodeNil(forKey key: KeyedDecodingContainer<K>.Key) throws -> Bool { fatalError() }
    func decode(_ type: Bool.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Bool {
        fatalError()
    }
    func decode(_ type: String.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> String {
        fatalError()
    }
    func decode(_ type: Double.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Double {
        fatalError()
    }
    func decode(_ type: Float.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Float {
        fatalError()
    }
    func decode(_ type: Int.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Int {
        fatalError()
    }
    func decode(_ type: Int8.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Int8 {
        fatalError()
    }
    func decode(_ type: Int16.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Int16 {
        fatalError()
    }
    func decode(_ type: Int32.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Int32 {
        fatalError()
    }
    func decode(_ type: Int64.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Int64 {
        fatalError()
    }
    func decode(_ type: Int128.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Int128 {
        fatalError()
    }
    func decode(_ type: UInt.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt {
        fatalError()
    }
    func decode(_ type: UInt8.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt8 {
        fatalError()
    }
    func decode(_ type: UInt16.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt16 {
        fatalError()
    }
    func decode(_ type: UInt32.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt32 {
        fatalError()
    }
    func decode(_ type: UInt64.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt64 {
        fatalError()
    }
    func decode(_ type: UInt128.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> UInt128 {
        fatalError()
    }
    func decode<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T
    where T: Decodable { fatalError() }
    func decodeIfPresent(_ type: Bool.Type, forKey key: KeyedDecodingContainer<K>.Key) throws
        -> Bool?
    { fatalError() }
    func decodeIfPresent(_ type: String.Type, forKey key: KeyedDecodingContainer<K>.Key) throws
        -> String?
    { fatalError() }
    func decodeIfPresent(_ type: Double.Type, forKey key: KeyedDecodingContainer<K>.Key) throws
        -> Double?
    { fatalError() }
    func decodeIfPresent(_ type: Float.Type, forKey key: KeyedDecodingContainer<K>.Key) throws
        -> Float?
    { fatalError() }
    func decodeIfPresent(_ type: Int.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Int?
    { fatalError() }
    func decodeIfPresent(_ type: Int8.Type, forKey key: KeyedDecodingContainer<K>.Key) throws
        -> Int8?
    { fatalError() }
    func decodeIfPresent(_ type: Int16.Type, forKey key: KeyedDecodingContainer<K>.Key) throws
        -> Int16?
    { fatalError() }
    func decodeIfPresent(_ type: Int32.Type, forKey key: KeyedDecodingContainer<K>.Key) throws
        -> Int32?
    { fatalError() }
    func decodeIfPresent(_ type: Int64.Type, forKey key: KeyedDecodingContainer<K>.Key) throws
        -> Int64?
    { fatalError() }
    func decodeIfPresent(_ type: Int128.Type, forKey key: KeyedDecodingContainer<K>.Key) throws
        -> Int128?
    { fatalError() }
    func decodeIfPresent(_ type: UInt.Type, forKey key: KeyedDecodingContainer<K>.Key) throws
        -> UInt?
    { fatalError() }
    func decodeIfPresent(_ type: UInt8.Type, forKey key: KeyedDecodingContainer<K>.Key) throws
        -> UInt8?
    { fatalError() }
    func decodeIfPresent(_ type: UInt16.Type, forKey key: KeyedDecodingContainer<K>.Key) throws
        -> UInt16?
    { fatalError() }
    func decodeIfPresent(_ type: UInt32.Type, forKey key: KeyedDecodingContainer<K>.Key) throws
        -> UInt32?
    { fatalError() }
    func decodeIfPresent(_ type: UInt64.Type, forKey key: KeyedDecodingContainer<K>.Key) throws
        -> UInt64?
    { fatalError() }
    func decodeIfPresent(_ type: UInt128.Type, forKey key: KeyedDecodingContainer<K>.Key) throws
        -> UInt128?
    { fatalError() }
    func decodeIfPresent<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T?
    where T: Decodable { fatalError() }
    func nestedContainer<NestedKey>(
        keyedBy type: NestedKey.Type, forKey key: KeyedDecodingContainer<K>.Key
    ) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey { fatalError() }
    func nestedUnkeyedContainer(forKey key: KeyedDecodingContainer<K>.Key) throws
        -> any UnkeyedDecodingContainer
    { fatalError() }
    func superDecoder() throws -> any Decoder { fatalError() }
    func superDecoder(forKey key: KeyedDecodingContainer<K>.Key) throws -> any Decoder {
        fatalError()
    }
}

protocol KeyedDecodingContainerProtocol {
    associatedtype Key: CodingKey
    var codingPath: [any CodingKey] { get }
    var allKeys: [Self.Key] { get }
    func contains(_ key: Self.Key) -> Bool
    func decodeNil(forKey key: Self.Key) throws -> Bool
    func decode(_ type: Bool.Type, forKey key: Self.Key) throws -> Bool
    func decode(_ type: String.Type, forKey key: Self.Key) throws -> String
    func decode(_ type: Double.Type, forKey key: Self.Key) throws -> Double
    func decode(_ type: Float.Type, forKey key: Self.Key) throws -> Float
    func decode(_ type: Int.Type, forKey key: Self.Key) throws -> Int
    func decode(_ type: Int8.Type, forKey key: Self.Key) throws -> Int8
    func decode(_ type: Int16.Type, forKey key: Self.Key) throws -> Int16
    func decode(_ type: Int32.Type, forKey key: Self.Key) throws -> Int32
    func decode(_ type: Int64.Type, forKey key: Self.Key) throws -> Int64
    func decode(_ type: Int128.Type, forKey key: Self.Key) throws -> Int128
    func decode(_ type: UInt.Type, forKey key: Self.Key) throws -> UInt
    func decode(_ type: UInt8.Type, forKey key: Self.Key) throws -> UInt8
    func decode(_ type: UInt16.Type, forKey key: Self.Key) throws -> UInt16
    func decode(_ type: UInt32.Type, forKey key: Self.Key) throws -> UInt32
    func decode(_ type: UInt64.Type, forKey key: Self.Key) throws -> UInt64
    func decode(_ type: UInt128.Type, forKey key: Self.Key) throws -> UInt128
    func decode<T>(_ type: T.Type, forKey key: Self.Key) throws -> T where T: Decodable
    func decodeIfPresent(_ type: Bool.Type, forKey key: Self.Key) throws -> Bool?
    func decodeIfPresent(_ type: String.Type, forKey key: Self.Key) throws -> String?
    func decodeIfPresent(_ type: Double.Type, forKey key: Self.Key) throws -> Double?
    func decodeIfPresent(_ type: Float.Type, forKey key: Self.Key) throws -> Float?
    func decodeIfPresent(_ type: Int.Type, forKey key: Self.Key) throws -> Int?
    func decodeIfPresent(_ type: Int8.Type, forKey key: Self.Key) throws -> Int8?
    func decodeIfPresent(_ type: Int16.Type, forKey key: Self.Key) throws -> Int16?
    func decodeIfPresent(_ type: Int32.Type, forKey key: Self.Key) throws -> Int32?
    func decodeIfPresent(_ type: Int64.Type, forKey key: Self.Key) throws -> Int64?
    func decodeIfPresent(_ type: Int128.Type, forKey key: Self.Key) throws -> Int128?
    func decodeIfPresent(_ type: UInt.Type, forKey key: Self.Key) throws -> UInt?
    func decodeIfPresent(_ type: UInt8.Type, forKey key: Self.Key) throws -> UInt8?
    func decodeIfPresent(_ type: UInt16.Type, forKey key: Self.Key) throws -> UInt16?
    func decodeIfPresent(_ type: UInt32.Type, forKey key: Self.Key) throws -> UInt32?
    func decodeIfPresent(_ type: UInt64.Type, forKey key: Self.Key) throws -> UInt64?
    func decodeIfPresent(_ type: UInt128.Type, forKey key: Self.Key) throws -> UInt128?
    func decodeIfPresent<T>(_ type: T.Type, forKey key: Self.Key) throws -> T? where T: Decodable
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Self.Key) throws
        -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey
    func nestedUnkeyedContainer(forKey key: Self.Key) throws -> any UnkeyedDecodingContainer
    func superDecoder() throws -> any Decoder
    func superDecoder(forKey key: Self.Key) throws -> any Decoder
}

struct KeyedEncodingContainer<K> where K: CodingKey {
    typealias Key = K
    init<Container>(_ container: Container)
    where K == Container.Key, Container: KeyedEncodingContainerProtocol { fatalError() }
    var codingPath: [any CodingKey] { fatalError() }
    mutating func encodeNil(forKey key: KeyedEncodingContainer<K>.Key) throws { fatalError() }
    mutating func encode(_ value: Bool, forKey key: KeyedEncodingContainer<K>.Key) throws {
        fatalError()
    }
    mutating func encode(_ value: String, forKey key: KeyedEncodingContainer<K>.Key) throws {
        fatalError()
    }
    mutating func encode(_ value: Double, forKey key: KeyedEncodingContainer<K>.Key) throws {
        fatalError()
    }
    mutating func encode(_ value: Float, forKey key: KeyedEncodingContainer<K>.Key) throws {
        fatalError()
    }
    mutating func encode(_ value: Int, forKey key: KeyedEncodingContainer<K>.Key) throws {
        fatalError()
    }
    mutating func encode(_ value: Int8, forKey key: KeyedEncodingContainer<K>.Key) throws {
        fatalError()
    }
    mutating func encode(_ value: Int16, forKey key: KeyedEncodingContainer<K>.Key) throws {
        fatalError()
    }
    mutating func encode(_ value: Int32, forKey key: KeyedEncodingContainer<K>.Key) throws {
        fatalError()
    }
    mutating func encode(_ value: Int64, forKey key: KeyedEncodingContainer<K>.Key) throws {
        fatalError()
    }
    mutating func encode(_ value: Int128, forKey key: KeyedEncodingContainer<K>.Key) throws {
        fatalError()
    }
    mutating func encode(_ value: UInt, forKey key: KeyedEncodingContainer<K>.Key) throws {
        fatalError()
    }
    mutating func encode(_ value: UInt8, forKey key: KeyedEncodingContainer<K>.Key) throws {
        fatalError()
    }
    mutating func encode(_ value: UInt16, forKey key: KeyedEncodingContainer<K>.Key) throws {
        fatalError()
    }
    mutating func encode(_ value: UInt32, forKey key: KeyedEncodingContainer<K>.Key) throws {
        fatalError()
    }
    mutating func encode(_ value: UInt64, forKey key: KeyedEncodingContainer<K>.Key) throws {
        fatalError()
    }
    mutating func encode(_ value: UInt128, forKey key: KeyedEncodingContainer<K>.Key) throws {
        fatalError()
    }
    mutating func encode<T>(_ value: T, forKey key: KeyedEncodingContainer<K>.Key) throws
    where T: Encodable { fatalError() }
    mutating func encodeConditional<T>(_ object: T, forKey key: KeyedEncodingContainer<K>.Key)
        throws where T: AnyObject, T: Encodable
    { fatalError() }
    mutating func encodeIfPresent(_ value: Bool?, forKey key: KeyedEncodingContainer<K>.Key) throws
    { fatalError() }
    mutating func encodeIfPresent(_ value: String?, forKey key: KeyedEncodingContainer<K>.Key)
        throws
    { fatalError() }
    mutating func encodeIfPresent(_ value: Double?, forKey key: KeyedEncodingContainer<K>.Key)
        throws
    { fatalError() }
    mutating func encodeIfPresent(_ value: Float?, forKey key: KeyedEncodingContainer<K>.Key) throws
    { fatalError() }
    mutating func encodeIfPresent(_ value: Int?, forKey key: KeyedEncodingContainer<K>.Key) throws {
        fatalError()
    }
    mutating func encodeIfPresent(_ value: Int8?, forKey key: KeyedEncodingContainer<K>.Key) throws
    { fatalError() }
    mutating func encodeIfPresent(_ value: Int16?, forKey key: KeyedEncodingContainer<K>.Key) throws
    { fatalError() }
    mutating func encodeIfPresent(_ value: Int32?, forKey key: KeyedEncodingContainer<K>.Key) throws
    { fatalError() }
    mutating func encodeIfPresent(_ value: Int64?, forKey key: KeyedEncodingContainer<K>.Key) throws
    { fatalError() }
    mutating func encodeIfPresent(_ value: Int128?, forKey key: KeyedEncodingContainer<K>.Key)
        throws
    { fatalError() }
    mutating func encodeIfPresent(_ value: UInt?, forKey key: KeyedEncodingContainer<K>.Key) throws
    { fatalError() }
    mutating func encodeIfPresent(_ value: UInt8?, forKey key: KeyedEncodingContainer<K>.Key) throws
    { fatalError() }
    mutating func encodeIfPresent(_ value: UInt16?, forKey key: KeyedEncodingContainer<K>.Key)
        throws
    { fatalError() }
    mutating func encodeIfPresent(_ value: UInt32?, forKey key: KeyedEncodingContainer<K>.Key)
        throws
    { fatalError() }
    mutating func encodeIfPresent(_ value: UInt64?, forKey key: KeyedEncodingContainer<K>.Key)
        throws
    { fatalError() }
    mutating func encodeIfPresent(_ value: UInt128?, forKey key: KeyedEncodingContainer<K>.Key)
        throws
    { fatalError() }
    mutating func encodeIfPresent<T>(_ value: T?, forKey key: KeyedEncodingContainer<K>.Key) throws
    where T: Encodable { fatalError() }
    mutating func nestedContainer<NestedKey>(
        keyedBy keyType: NestedKey.Type, forKey key: KeyedEncodingContainer<K>.Key
    ) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey { fatalError() }
    mutating func nestedUnkeyedContainer(forKey key: KeyedEncodingContainer<K>.Key)
        -> any UnkeyedEncodingContainer
    { fatalError() }
    mutating func superEncoder() -> any Encoder { fatalError() }
    mutating func superEncoder(forKey key: KeyedEncodingContainer<K>.Key) -> any Encoder {
        fatalError()
    }
}

protocol KeyedEncodingContainerProtocol {
    associatedtype Key: CodingKey
    var codingPath: [any CodingKey] { get }
    mutating func encodeNil(forKey key: Self.Key) throws
    mutating func encode(_ value: Bool, forKey key: Self.Key) throws
    mutating func encode(_ value: String, forKey key: Self.Key) throws
    mutating func encode(_ value: Double, forKey key: Self.Key) throws
    mutating func encode(_ value: Float, forKey key: Self.Key) throws
    mutating func encode(_ value: Int, forKey key: Self.Key) throws
    mutating func encode(_ value: Int8, forKey key: Self.Key) throws
    mutating func encode(_ value: Int16, forKey key: Self.Key) throws
    mutating func encode(_ value: Int32, forKey key: Self.Key) throws
    mutating func encode(_ value: Int64, forKey key: Self.Key) throws
    mutating func encode(_ value: Int128, forKey key: Self.Key) throws
    mutating func encode(_ value: UInt, forKey key: Self.Key) throws
    mutating func encode(_ value: UInt8, forKey key: Self.Key) throws
    mutating func encode(_ value: UInt16, forKey key: Self.Key) throws
    mutating func encode(_ value: UInt32, forKey key: Self.Key) throws
    mutating func encode(_ value: UInt64, forKey key: Self.Key) throws
    mutating func encode(_ value: UInt128, forKey key: Self.Key) throws
    mutating func encode<T>(_ value: T, forKey key: Self.Key) throws where T: Encodable
    mutating func encodeConditional<T>(_ object: T, forKey key: Self.Key) throws
    where T: AnyObject, T: Encodable
    mutating func encodeIfPresent(_ value: Bool?, forKey key: Self.Key) throws
    mutating func encodeIfPresent(_ value: String?, forKey key: Self.Key) throws
    mutating func encodeIfPresent(_ value: Double?, forKey key: Self.Key) throws
    mutating func encodeIfPresent(_ value: Float?, forKey key: Self.Key) throws
    mutating func encodeIfPresent(_ value: Int?, forKey key: Self.Key) throws
    mutating func encodeIfPresent(_ value: Int8?, forKey key: Self.Key) throws
    mutating func encodeIfPresent(_ value: Int16?, forKey key: Self.Key) throws
    mutating func encodeIfPresent(_ value: Int32?, forKey key: Self.Key) throws
    mutating func encodeIfPresent(_ value: Int64?, forKey key: Self.Key) throws
    mutating func encodeIfPresent(_ value: Int128?, forKey key: Self.Key) throws
    mutating func encodeIfPresent(_ value: UInt?, forKey key: Self.Key) throws
    mutating func encodeIfPresent(_ value: UInt8?, forKey key: Self.Key) throws
    mutating func encodeIfPresent(_ value: UInt16?, forKey key: Self.Key) throws
    mutating func encodeIfPresent(_ value: UInt32?, forKey key: Self.Key) throws
    mutating func encodeIfPresent(_ value: UInt64?, forKey key: Self.Key) throws
    mutating func encodeIfPresent(_ value: UInt128?, forKey key: Self.Key) throws
    mutating func encodeIfPresent<T>(_ value: T?, forKey key: Self.Key) throws where T: Encodable
    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Self.Key)
        -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey
    mutating func nestedUnkeyedContainer(forKey key: Self.Key) -> any UnkeyedEncodingContainer
    mutating func superEncoder() -> any Encoder
    mutating func superEncoder(forKey key: Self.Key) -> any Encoder
}

protocol LazyCollectionProtocol: Collection, LazySequenceProtocol where Self.Elements: Collection {
    var lazy: LazyCollection<Self.Elements> { get }
    var lazy: Self.Elements { get }
}

@frozen struct LazyDropWhileSequence<Base> where Base: Sequence {
    typealias Element = Base.Element
    func makeIterator() -> LazyDropWhileSequence<Base>.Iterator { fatalError() }
    typealias Elements = LazyDropWhileSequence<Base>
    typealias SubSequence = Slice<LazyDropWhileCollection<Base>>
    typealias Index = Base.Index
    var startIndex: LazyDropWhileSequence<Base>.Index { fatalError() }
    var endIndex: LazyDropWhileSequence<Base>.Index { fatalError() }
    func index(after i: LazyDropWhileSequence<Base>.Index) -> LazyDropWhileSequence<Base>.Index {
        fatalError()
    }
    subscript(position: LazyDropWhileSequence<Base>.Index) -> LazyDropWhileSequence<Base>.Element {
        fatalError()
    }
    typealias Indices = DefaultIndices<LazyDropWhileSequence<Base>>
    func index(before i: LazyDropWhileSequence<Base>.Index) -> LazyDropWhileSequence<Base>.Index {
        fatalError()
    }
    @frozen struct Iterator {
        typealias Element = Base.Element
        mutating func next() -> LazyDropWhileSequence<Base>.Iterator.Element? { fatalError() }
    }
}

@frozen struct LazyFilterSequence<Base> where Base: Sequence {
    typealias Element = Base.Element
    func makeIterator() -> LazyFilterSequence<Base>.Iterator { fatalError() }
    typealias Elements = LazyFilterSequence<Base>
    typealias SubSequence = LazyFilterCollection<Base.SubSequence>
    var underestimatedCount: Int { fatalError() }
    typealias Index = Base.Index
    var startIndex: LazyFilterSequence<Base>.Index { fatalError() }
    var endIndex: LazyFilterSequence<Base>.Index { fatalError() }
    func index(after i: LazyFilterSequence<Base>.Index) -> LazyFilterSequence<Base>.Index {
        fatalError()
    }
    func formIndex(after i: inout LazyFilterSequence<Base>.Index) { fatalError() }
    func distance(
        from start: LazyFilterSequence<Base>.Index, to end: LazyFilterSequence<Base>.Index
    ) -> Int { fatalError() }
    func index(_ i: LazyFilterSequence<Base>.Index, offsetBy n: Int)
        -> LazyFilterSequence<Base>.Index
    { fatalError() }
    func formIndex(_ i: inout LazyFilterSequence<Base>.Index, offsetBy n: Int) { fatalError() }
    func index(
        _ i: LazyFilterSequence<Base>.Index, offsetBy n: Int,
        limitedBy limit: LazyFilterSequence<Base>.Index
    ) -> LazyFilterSequence<Base>.Index? { fatalError() }
    func formIndex(
        _ i: inout LazyFilterSequence<Base>.Index, offsetBy n: Int,
        limitedBy limit: LazyFilterSequence<Base>.Index
    ) -> Bool { fatalError() }
    subscript(position: LazyFilterSequence<Base>.Index) -> LazyFilterSequence<Base>.Element {
        fatalError()
    }
    subscript(bounds: Range<LazyFilterSequence<Base>.Index>) -> LazyFilterSequence<Base>.SubSequence
    { fatalError() }
    typealias Indices = DefaultIndices<LazyFilterSequence<Base>>
    func index(before i: LazyFilterSequence<Base>.Index) -> LazyFilterSequence<Base>.Index {
        fatalError()
    }
    func formIndex(before i: inout LazyFilterSequence<Base>.Index) { fatalError() }
    func filter(_ isIncluded: @escaping (LazyFilterSequence<Base>.Element) -> Bool)
        -> LazyFilterSequence<Base>
    { fatalError() }
    @frozen struct Iterator {
        var base: Base.Iterator { fatalError() }
        typealias Element = Base.Element
        mutating func next() -> LazyFilterSequence<Base>.Iterator.Element? { fatalError() }
        typealias Iterator = LazyFilterSequence<Base>.Iterator
    }
}

@frozen struct LazyMapSequence<Base, Element> where Base: Sequence {
    typealias Elements = LazyMapSequence<Base, Element>
    func makeIterator() -> LazyMapSequence<Base, Element>.Iterator { fatalError() }
    var underestimatedCount: Int { fatalError() }
    typealias Index = Base.Index
    typealias Indices = Base.Indices
    typealias SubSequence = LazyMapCollection<Base.SubSequence, Element>
    var startIndex: Base.Index { fatalError() }
    var endIndex: Base.Index { fatalError() }
    func index(after i: LazyMapSequence<Base, Element>.Index)
        -> LazyMapSequence<Base, Element>.Index
    { fatalError() }
    func formIndex(after i: inout LazyMapSequence<Base, Element>.Index) { fatalError() }
    subscript(position: Base.Index) -> Element { fatalError() }
    subscript(bounds: Range<Base.Index>) -> LazyMapSequence<Base, Element>.SubSequence {
        fatalError()
    }
    var indices: LazyMapSequence<Base, Element>.Indices { fatalError() }
    var isEmpty: Bool { fatalError() }
    var count: Int { fatalError() }
    func index(_ i: LazyMapSequence<Base, Element>.Index, offsetBy n: Int)
        -> LazyMapSequence<Base, Element>.Index
    { fatalError() }
    func index(
        _ i: LazyMapSequence<Base, Element>.Index, offsetBy n: Int,
        limitedBy limit: LazyMapSequence<Base, Element>.Index
    ) -> LazyMapSequence<Base, Element>.Index? { fatalError() }
    func distance(
        from start: LazyMapSequence<Base, Element>.Index,
        to end: LazyMapSequence<Base, Element>.Index
    ) -> Int { fatalError() }
    func index(before i: LazyMapSequence<Base, Element>.Index)
        -> LazyMapSequence<Base, Element>.Index
    { fatalError() }
    func formIndex(before i: inout LazyMapSequence<Base, Element>.Index) { fatalError() }
    func map<ElementOfResult>(_ transform: @escaping (Element) -> ElementOfResult)
        -> LazyMapSequence<Base, ElementOfResult>
    { fatalError() }
    func map<ElementOfResult>(_ transform: @escaping (Element) -> ElementOfResult)
        -> LazyMapCollection<Base, ElementOfResult>
    { fatalError() }
    @frozen struct Iterator {
        var base: Base.Iterator { fatalError() }
        mutating func next() -> Element? { fatalError() }
        typealias Iterator = LazyMapSequence<Base, Element>.Iterator
    }
}

@frozen struct LazyPrefixWhileSequence<Base> where Base: Sequence {
    typealias Element = Base.Element
    func makeIterator() -> LazyPrefixWhileSequence<Base>.Iterator { fatalError() }
    typealias Elements = LazyPrefixWhileSequence<Base>
    typealias SubSequence = Slice<LazyPrefixWhileCollection<Base>>
    var startIndex: LazyPrefixWhileSequence<Base>.Index { fatalError() }
    var endIndex: LazyPrefixWhileSequence<Base>.Index { fatalError() }
    func index(after i: LazyPrefixWhileSequence<Base>.Index) -> LazyPrefixWhileSequence<Base>.Index
    { fatalError() }
    subscript(position: LazyPrefixWhileSequence<Base>.Index)
        -> LazyPrefixWhileSequence<Base>.Element
    { fatalError() }
    typealias Indices = DefaultIndices<LazyPrefixWhileSequence<Base>>
    func index(before i: LazyPrefixWhileSequence<Base>.Index) -> LazyPrefixWhileSequence<Base>.Index
    { fatalError() }
    @frozen struct Index {
        static func == (
            lhs: LazyPrefixWhileCollection<Base>.Index, rhs: LazyPrefixWhileCollection<Base>.Index
        ) -> Bool { fatalError() }
        static func < (
            lhs: LazyPrefixWhileCollection<Base>.Index, rhs: LazyPrefixWhileCollection<Base>.Index
        ) -> Bool { fatalError() }
        func hash(into hasher: inout Hasher) { fatalError() }
        var hashValue: Int { fatalError() }
    }
    @frozen struct Iterator {
        typealias Element = Base.Element
        mutating func next() -> LazyPrefixWhileSequence<Base>.Iterator.Element? { fatalError() }
        typealias Iterator = LazyPrefixWhileSequence<Base>.Iterator
    }
}

@frozen struct LazySequence<Base> where Base: Sequence {
    typealias Index = Base.Index
    typealias Indices = Base.Indices
    typealias SubSequence = Slice<LazySequence<Base>>
    var startIndex: LazySequence<Base>.Index { fatalError() }
    var endIndex: LazySequence<Base>.Index { fatalError() }
    var indices: LazySequence<Base>.Indices { fatalError() }
    func index(after i: LazySequence<Base>.Index) -> LazySequence<Base>.Index { fatalError() }
    subscript(position: LazySequence<Base>.Index) -> LazySequence<Base>.Element { fatalError() }
    var isEmpty: Bool { fatalError() }
    var count: Int { fatalError() }
    func index(_ i: LazySequence<Base>.Index, offsetBy n: Int) -> LazySequence<Base>.Index {
        fatalError()
    }
    func index(
        _ i: LazySequence<Base>.Index, offsetBy n: Int, limitedBy limit: LazySequence<Base>.Index
    ) -> LazySequence<Base>.Index? { fatalError() }
    func distance(from start: LazySequence<Base>.Index, to end: LazySequence<Base>.Index) -> Int {
        fatalError()
    }
    func index(before i: LazySequence<Base>.Index) -> LazySequence<Base>.Index { fatalError() }
    typealias Element = Base.Element
    typealias Iterator = Base.Iterator
    func makeIterator() -> LazySequence<Base>.Iterator { fatalError() }
    var underestimatedCount: Int { fatalError() }
    typealias Elements = Base
    var elements: LazySequence<Base>.Elements { fatalError() }
}

protocol LazySequenceProtocol: Sequence {
    func drop(while predicate: @escaping (Self.Elements.Element) -> Bool) -> LazyDropWhileSequence<
        Self.Elements
    >
    func filter(_ isIncluded: @escaping (Self.Elements.Element) -> Bool) -> LazyFilterSequence<
        Self.Elements
    >
    func flatMap<SegmentOfResult>(_ transform: @escaping (Self.Elements.Element) -> SegmentOfResult)
        -> LazySequence<FlattenSequence<LazyMapSequence<Self.Elements, SegmentOfResult>>>
    where SegmentOfResult: Sequence
    func compactMap<ElementOfResult>(
        _ transform: @escaping (Self.Elements.Element) -> ElementOfResult?
    ) -> LazyMapSequence<
        LazyFilterSequence<LazyMapSequence<Self.Elements, ElementOfResult?>>, ElementOfResult
    >
    func joined() -> LazySequence<FlattenSequence<Self.Elements>>
    associatedtype Elements: Sequence = Self where Self.Element == Self.Elements.Element
    var elements: Self.Elements { get }
    var elements: Self { get }
    var lazy: LazySequence<Self.Elements> { get }
    var lazy: Self.Elements { get }
    func map<U>(_ transform: @escaping (Self.Element) -> U) -> LazyMapSequence<Self.Elements, U>
    func prefix(while predicate: @escaping (Self.Elements.Element) -> Bool)
        -> LazyPrefixWhileSequence<Self.Elements>
    func flatMap<ElementOfResult>(
        _ transform: @escaping (Self.Elements.Element) -> ElementOfResult?
    ) -> LazyMapSequence<
        LazyFilterSequence<LazyMapSequence<Self.Elements, ElementOfResult?>>, ElementOfResult
    >
}

protocol LosslessStringConvertible: CustomStringConvertible {
    init?(_ description: String)
}

class ManagedBuffer<Header, Element> where Element: ~Copyable {
    final var header: Header { fatalError() }
    final class func create(
        minimumCapacity: Int,
        makingHeaderWith factory: (ManagedBuffer<Header, Element>) throws -> Header
    ) rethrows -> ManagedBuffer<Header, Element> { fatalError() }
    final var capacity: Int { fatalError() }
    final func withUnsafeMutablePointerToHeader<E, R>(
        _ body: (UnsafeMutablePointer<Header>) throws(E) -> R
    ) throws(E) -> R where E: Error, R: ~Copyable { fatalError() }
    final func withUnsafeMutablePointerToElements<E, R>(
        _ body: (UnsafeMutablePointer<Element>) throws(E) -> R
    ) throws(E) -> R where E: Error, R: ~Copyable { fatalError() }
    final func withUnsafeMutablePointers<E, R>(
        _ body: (UnsafeMutablePointer<Header>, UnsafeMutablePointer<Element>) throws(E) -> R
    ) throws(E) -> R where E: Error, R: ~Copyable { fatalError() }
}

@frozen struct ManagedBufferPointer<Header, Element> where Element: ~Copyable {
    init(
        bufferClass: AnyClass, minimumCapacity: Int,
        makingHeaderWith factory: (AnyObject, (AnyObject) -> Int) throws -> Header
    ) rethrows { fatalError() }
    init(unsafeBufferObject buffer: AnyObject) { fatalError() }
    var header: Header { fatalError() }
    var buffer: AnyObject { fatalError() }
    var capacity: Int { fatalError() }
    func withUnsafeMutablePointerToHeader<E, R>(
        _ body: (UnsafeMutablePointer<Header>) throws(E) -> R
    ) throws(E) -> R where E: Error, R: ~Copyable { fatalError() }
    func withUnsafeMutablePointerToElements<E, R>(
        _ body: (UnsafeMutablePointer<Element>) throws(E) -> R
    ) throws(E) -> R where E: Error, R: ~Copyable { fatalError() }
    func withUnsafeMutablePointers<E, R>(
        _ body: (UnsafeMutablePointer<Header>, UnsafeMutablePointer<Element>) throws(E) -> R
    ) throws(E) -> R where E: Error, R: ~Copyable { fatalError() }
    mutating func isUniqueReference() -> Bool { fatalError() }
    static func == (
        lhs: ManagedBufferPointer<Header, Element>, rhs: ManagedBufferPointer<Header, Element>
    ) -> Bool { fatalError() }
}

@frozen enum MemoryLayout<T> where T: ~Copyable, T: ~Escapable {
    static var size: Int { fatalError() }
    static var stride: Int { fatalError() }
    static var alignment: Int { fatalError() }
    static func size(ofValue value: borrowing T) -> Int { fatalError() }
    static func stride(ofValue value: borrowing T) -> Int { fatalError() }
    static func alignment(ofValue value: borrowing T) -> Int { fatalError() }
    static func offset(of key: PartialKeyPath<T>) -> Int? { fatalError() }
}

struct Mirror {
    var subjectType: any Any.Type { fatalError() }
    var children: Mirror.Children { fatalError() }
    var displayStyle: Mirror.DisplayStyle? { fatalError() }
    init(reflecting subject: Any) { fatalError() }
    init<Subject, C>(
        _ subject: Subject, children: C, displayStyle: Mirror.DisplayStyle? = nil,
        ancestorRepresentation: Mirror.AncestorRepresentation = .generated
    ) where C: Collection, C.Element == (label: String?, value: Any) { fatalError() }
    init<Subject, C>(
        _ subject: Subject, unlabeledChildren: C, displayStyle: Mirror.DisplayStyle? = nil,
        ancestorRepresentation: Mirror.AncestorRepresentation = .generated
    ) where C: Collection { fatalError() }
    init<Subject>(
        _ subject: Subject, children: KeyValuePairs<String, Any>,
        displayStyle: Mirror.DisplayStyle? = nil,
        ancestorRepresentation: Mirror.AncestorRepresentation = .generated
    ) { fatalError() }
    var superclassMirror: Mirror? { fatalError() }
    typealias Child = (label: String?, value: Any)
    typealias Children = AnyCollection<Mirror.Child>
    func descendant(_ first: any MirrorPath, _ rest: any MirrorPath...) -> Any? { fatalError() }
    var description: String { fatalError() }
    var customMirror: Mirror { fatalError() }
    enum AncestorRepresentation {
        case generated
        case customized(() -> Mirror)
        case suppressed
    }
    enum DisplayStyle {
        case `struct`
        case `class`
        case `enum`
        case tuple
        case optional
        case collection
        case dictionary
        case set
        case foreignReference
        static func == (a: Mirror.DisplayStyle, b: Mirror.DisplayStyle) -> Bool { fatalError() }
        func hash(into hasher: inout Hasher) { fatalError() }
        var hashValue: Int { fatalError() }
    }
}

protocol MirrorPath {
}

protocol MutableCollection<Element>: Collection where Self.SubSequence: MutableCollection {
    mutating func partition(by belongsInSecondPartition: (Self.Element) throws -> Bool) rethrows
        -> Self.Index
    mutating func shuffle<T>(using generator: inout T) where T: RandomNumberGenerator
    mutating func shuffle()
    associatedtype Element
    associatedtype Index
    associatedtype SubSequence
    override subscript(position: Self.Index) -> Self.Element { get set }
    override subscript(bounds: Range<Self.Index>) -> Self.SubSequence { get set }
    mutating func swapAt(_ i: Self.Index, _ j: Self.Index)
    mutating func withContiguousMutableStorageIfAvailable<R>(
        _ body: (inout UnsafeMutableBufferPointer<Self.Element>) throws -> R
    ) rethrows -> R?
    subscript(bounds: Range<Self.Index>) -> Slice<Self> { get set }
    @discardableResult mutating func moveSubranges(
        _ subranges: RangeSet<Self.Index>, to insertionPoint: Self.Index
    ) -> Range<Self.Index>
    subscript<R>(r: R) -> Self.SubSequence where R: RangeExpression, Self.Index == R.Bound {
        get set
    }
    subscript(x: UnboundedRange) -> Self.SubSequence { get set }
    mutating func removeSubranges(_ subranges: RangeSet<Self.Index>)
    mutating func reverse()
    mutating func sort()
    mutating func sort(by areInIncreasingOrder: (Self.Element, Self.Element) throws -> Bool)
        rethrows
}

@frozen struct MutableRawSpan {
    init() { fatalError() }
    init<Element>(mutating elements: inout MutableSpan<Element>)
    where Element: ConvertibleFromBytes, Element: ConvertibleToBytes { fatalError() }
    init<Element>(unsafeElements elements: consuming MutableSpan<Element>) { fatalError() }
    init<Element>(elements: consuming MutableSpan<Element>)
    where Element: ConvertibleFromBytes, Element: ConvertibleToBytes { fatalError() }
    var byteCount: Int { fatalError() }
    var isEmpty: Bool { fatalError() }
    var byteOffsets: Range<Int> { fatalError() }
    subscript(byteOffset: Int) -> UInt8 { fatalError() }
    subscript(unchecked byteOffset: Int) -> UInt8 { fatalError() }
    func withUnsafeBytes<E, Result>(_ body: (UnsafeRawBufferPointer) throws(E) -> Result) throws(E)
        -> Result where E: Error, Result: ~Copyable
    { fatalError() }
    mutating func withUnsafeMutableBytes<E, Result>(
        _ body: (UnsafeMutableRawBufferPointer) throws(E) -> Result
    ) throws(E) -> Result where E: Error, Result: ~Copyable { fatalError() }
    var bytes: RawSpan { fatalError() }
    func unsafeLoad<T>(fromByteOffset offset: Int = 0, as type: T.Type) -> T { fatalError() }
    func unsafeLoad<T>(fromUncheckedByteOffset offset: Int, as type: T.Type) -> T { fatalError() }
    func unsafeLoadUnaligned<T>(fromByteOffset offset: Int = 0, as type: T.Type) -> T
    where T: BitwiseCopyable { fatalError() }
    func unsafeLoadUnaligned<T>(fromUncheckedByteOffset offset: Int, as type: T.Type) -> T
    where T: BitwiseCopyable { fatalError() }
    func load<T>(fromByteOffset offset: Int, as type: T.Type) -> T where T: ConvertibleFromBytes {
        fatalError()
    }
    func load<T>(fromByteOffset offset: Int, as type: T.Type, _ byteOrder: ByteOrder) -> T
    where T: ConvertibleFromBytes, T: FixedWidthInteger { fatalError() }
    mutating func storeBytes<T>(of value: T, toByteOffset offset: Int = 0, as type: T.Type)
    where T: BitwiseCopyable { fatalError() }
    mutating func storeBytes<T>(of value: T, toUncheckedByteOffset offset: Int, as type: T.Type)
    where T: BitwiseCopyable { fatalError() }
    mutating func storeBytes<T>(of value: T, toByteOffset offset: Int, as type: T.Type)
    where T: BitwiseCopyable, T: ConvertibleToBytes { fatalError() }
    mutating func storeBytes<T>(
        of value: T, toByteOffset offset: Int, as type: T.Type, _ byteOrder: ByteOrder
    ) where T: BitwiseCopyable, T: ConvertibleToBytes, T: FixedWidthInteger { fatalError() }
    mutating func storeBytes<T>(repeating repeatedValue: T, count: Int, as type: T.Type)
    where T: BitwiseCopyable { fatalError() }
    mutating func storeBytes<T>(repeating repeatedValue: T, count: Int, as type: T.Type)
    where T: BitwiseCopyable, T: ConvertibleToBytes { fatalError() }
    mutating func storeBytes<T>(
        repeating repeatedValue: T, count: Int, as type: T.Type, _ byteOrder: ByteOrder
    ) where T: BitwiseCopyable, T: ConvertibleToBytes, T: FixedWidthInteger { fatalError() }
    mutating func extracting(_ bounds: Range<Int>) -> MutableRawSpan { fatalError() }
    mutating func extracting(unchecked bounds: Range<Int>) -> MutableRawSpan { fatalError() }
    mutating func extracting(_ bounds: some RangeExpression<Int>) -> MutableRawSpan { fatalError() }
    mutating func extracting(unchecked bounds: ClosedRange<Int>) -> MutableRawSpan { fatalError() }
    mutating func extracting(_: UnboundedRange) -> MutableRawSpan { fatalError() }
    mutating func extracting(first maxLength: Int) -> MutableRawSpan { fatalError() }
    mutating func extracting(droppingLast k: Int) -> MutableRawSpan { fatalError() }
    mutating func extracting(last maxLength: Int) -> MutableRawSpan { fatalError() }
    mutating func extracting(droppingFirst k: Int) -> MutableRawSpan { fatalError() }
    typealias Failure = Never
    @export(implementation) var underestimatedCount: Int { fatalError() }
    @export(implementation) func makeBorrowingIterator() -> Span<UInt8>.BorrowingIterator {
        fatalError()
    }
    typealias BorrowingIterator = Span<UInt8>.BorrowingIterator
    typealias Element = UInt8
}

@frozen struct MutableRef<Value> where Value: ~Copyable {
    init(_ value: inout Value) { fatalError() }
    init<Owner>(unsafeAddress pointer: UnsafeMutablePointer<Value>, mutating owner: inout Owner)
    where Owner: ~Copyable, Owner: ~Escapable { fatalError() }
    var value: Value { fatalError() }
}

@frozen struct MutableSpan<Element> where Element: ~Copyable {
    init() { fatalError() }
    init(mutating mutableBytes: inout MutableRawSpan) { fatalError() }
    init(mutableBytes: consuming MutableRawSpan) { fatalError() }
    var span: Span<Element> { fatalError() }
    var count: Int { fatalError() }
    var isEmpty: Bool { fatalError() }
    typealias Index = Int
    var indices: Range<MutableSpan<Element>.Index> { fatalError() }
    var bytes: RawSpan { fatalError() }
    var mutableBytes: MutableRawSpan { fatalError() }
    subscript(position: MutableSpan<Element>.Index) -> Element { fatalError() }
    subscript(unchecked position: MutableSpan<Element>.Index) -> Element { fatalError() }
    mutating func swapAt(_ i: MutableSpan<Element>.Index, _ j: MutableSpan<Element>.Index) {
        fatalError()
    }
    mutating func swapAt(
        unchecked i: MutableSpan<Element>.Index, unchecked j: MutableSpan<Element>.Index
    ) { fatalError() }
    func withUnsafeBufferPointer<E, Result>(
        _ body: (UnsafeBufferPointer<Element>) throws(E) -> Result
    ) throws(E) -> Result where E: Error, Result: ~Copyable { fatalError() }
    mutating func withUnsafeMutableBufferPointer<E, Result>(
        _ body: (UnsafeMutableBufferPointer<Element>) throws(E) -> Result
    ) throws(E) -> Result where E: Error, Result: ~Copyable { fatalError() }
    func withUnsafeBytes<E, Result>(_ body: (UnsafeRawBufferPointer) throws(E) -> Result) throws(E)
        -> Result where E: Error, Result: ~Copyable
    { fatalError() }
    mutating func withUnsafeMutableBytes<E, Result>(
        _ body: (UnsafeMutableRawBufferPointer) throws(E) -> Result
    ) throws(E) -> Result where E: Error, Result: ~Copyable { fatalError() }
    mutating func update(repeating repeatedValue: consuming Element) { fatalError() }
    mutating func extracting(_ bounds: Range<MutableSpan<Element>.Index>) -> MutableSpan<Element> {
        fatalError()
    }
    mutating func extracting(unchecked bounds: Range<MutableSpan<Element>.Index>) -> MutableSpan<
        Element
    > { fatalError() }
    mutating func extracting(_ bounds: some RangeExpression<Int>) -> MutableSpan<Element> {
        fatalError()
    }
    mutating func extracting(unchecked bounds: ClosedRange<MutableSpan<Element>.Index>)
        -> MutableSpan<Element>
    { fatalError() }
    mutating func extracting(_: UnboundedRange) -> MutableSpan<Element> { fatalError() }
    mutating func extracting(first maxLength: Int) -> MutableSpan<Element> { fatalError() }
    mutating func extracting(droppingLast k: Int) -> MutableSpan<Element> { fatalError() }
    mutating func extracting(last maxLength: Int) -> MutableSpan<Element> { fatalError() }
    mutating func extracting(droppingFirst k: Int) -> MutableSpan<Element> { fatalError() }
    typealias Failure = Never
    @export(implementation) var underestimatedCount: Int { fatalError() }
    @export(implementation) func makeBorrowingIterator() -> Span<Element>.BorrowingIterator {
        fatalError()
    }
    typealias BorrowingIterator = Span<Element>.BorrowingIterator
}

@frozen enum Never {
    static func < (a: Never, b: Never) -> Bool { fatalError() }
    static func == (a: Never, b: Never) -> Bool { fatalError() }
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    var id: Never { fatalError() }
    typealias ID = Never
    func encode(to encoder: any Encoder) throws { fatalError() }
    init(from decoder: any Decoder) throws { fatalError() }
}

protocol Numeric: AdditiveArithmetic, ExpressibleByIntegerLiteral {
    init?<T>(exactly source: T) where T: BinaryInteger
    associatedtype Magnitude: Comparable, Numeric
    var magnitude: Self.Magnitude { get }
    static func * (lhs: Self, rhs: Self) -> Self
    static func *= (lhs: inout Self, rhs: Self)
}

@frozen struct ObjectIdentifier {
    init(_ x: AnyObject) { fatalError() }
    init(_ x: any (~Copyable & ~Escapable).Type) { fatalError() }
    init(_ x: any Any.Type) { fatalError() }
    var debugDescription: String { fatalError() }
    static func == (x: ObjectIdentifier, y: ObjectIdentifier) -> Bool { fatalError() }
    static func < (lhs: ObjectIdentifier, rhs: ObjectIdentifier) -> Bool { fatalError() }
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
}

@frozen struct OpaquePointer {
    init?(bitPattern: Int) { fatalError() }
    init?(bitPattern: UInt) { fatalError() }
    init<T>(_ from: UnsafePointer<T>) where T: ~Copyable { fatalError() }
    init?<T>(_ from: UnsafePointer<T>?) where T: ~Copyable { fatalError() }
    init<T>(_ from: UnsafeMutablePointer<T>) where T: ~Copyable { fatalError() }
    init?<T>(_ from: UnsafeMutablePointer<T>?) where T: ~Copyable { fatalError() }
    static func == (lhs: OpaquePointer, rhs: OpaquePointer) -> Bool { fatalError() }
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    var debugDescription: String { fatalError() }
    init(_ from: UnsafeMutableRawPointer) { fatalError() }
    init?(_ from: UnsafeMutableRawPointer?) { fatalError() }
    init(_ from: UnsafeRawPointer) { fatalError() }
    init?(_ from: UnsafeRawPointer?) { fatalError() }
}

protocol OptionSet: RawRepresentable, SetAlgebra {
    associatedtype Element = Self
    init(rawValue: Self.RawValue)
    func union(_ other: Self) -> Self
    func intersection(_ other: Self) -> Self
    func symmetricDifference(_ other: Self) -> Self
    func contains(_ member: Self) -> Bool
    @discardableResult mutating func insert(_ newMember: Self.Element) -> (
        inserted: Bool, memberAfterInsert: Self.Element
    )
    @discardableResult mutating func remove(_ member: Self.Element) -> Self.Element?
    @discardableResult mutating func update(with newMember: Self.Element) -> Self.Element?
    init()
    mutating func formUnion(_ other: Self)
    mutating func formIntersection(_ other: Self)
    mutating func formSymmetricDifference(_ other: Self)
}

@frozen enum Optional<Wrapped> where Wrapped: ~Copyable, Wrapped: ~Escapable {
    func encode(to encoder: any Encoder) throws { fatalError() }
    init(from decoder: any Decoder) throws { fatalError() }
    case none
    case some(Wrapped)
    init(nilLiteral: ()) { fatalError() }
    init(_ value: consuming Wrapped) { fatalError() }
    func map<E, U>(_ transform: (Wrapped) throws(E) -> U) throws(E) -> U?
    where E: Error, U: ~Copyable { fatalError() }
    func flatMap<E, U>(_ transform: (Wrapped) throws(E) -> U?) throws(E) -> U?
    where E: Error, U: ~Copyable { fatalError() }
    var unsafelyUnwrapped: Wrapped { fatalError() }
    mutating func take() -> Wrapped? { fatalError() }
    var debugDescription: String { fatalError() }
    var customMirror: Mirror { fatalError() }
    static func == (lhs: Wrapped?, rhs: Wrapped?) -> Bool { fatalError() }
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    static func ~= (lhs: _OptionalNilComparisonType, rhs: borrowing Wrapped?) -> Bool {
        fatalError()
    }
    static func == (lhs: borrowing Wrapped?, rhs: _OptionalNilComparisonType) -> Bool {
        fatalError()
    }
    static func != (lhs: borrowing Wrapped?, rhs: _OptionalNilComparisonType) -> Bool {
        fatalError()
    }
    static func == (lhs: _OptionalNilComparisonType, rhs: borrowing Wrapped?) -> Bool {
        fatalError()
    }
    static func != (lhs: _OptionalNilComparisonType, rhs: borrowing Wrapped?) -> Bool {
        fatalError()
    }
}

@frozen struct OutputRawSpan {
    var capacity: Int { fatalError() }
    init() { fatalError() }
    var byteCount: Int { fatalError() }
    var freeCapacity: Int { fatalError() }
    var isEmpty: Bool { fatalError() }
    var isFull: Bool { fatalError() }
    var byteOffsets: Range<Int> { fatalError() }
    init(buffer: UnsafeMutableRawBufferPointer, initializedCount: Int) { fatalError() }
    init(buffer: borrowing Slice<UnsafeMutableRawBufferPointer>, initializedCount: Int) {
        fatalError()
    }
    mutating func append(_ value: UInt8) { fatalError() }
    @discardableResult mutating func removeLast() -> UInt8 { fatalError() }
    mutating func removeLast(_ n: Int) { fatalError() }
    mutating func removeAll() { fatalError() }
    subscript(byteOffset: Int) -> UInt8 { fatalError() }
    subscript(unchecked byteOffset: Int) -> UInt8 { fatalError() }
    mutating func append<T>(_ value: T, as type: T.Type) where T: BitwiseCopyable { fatalError() }
    mutating func append<T>(_ value: T, as type: T.Type)
    where T: BitwiseCopyable, T: ConvertibleToBytes { fatalError() }
    mutating func append<T>(_ value: T, as type: T.Type, _ byteOrder: ByteOrder)
    where T: BitwiseCopyable, T: ConvertibleToBytes, T: FixedWidthInteger { fatalError() }
    mutating func append<T>(repeating repeatedValue: T, count: Int, as type: T.Type)
    where T: BitwiseCopyable { fatalError() }
    mutating func append<T>(repeating repeatedValue: T, count: Int, as type: T.Type)
    where T: BitwiseCopyable, T: ConvertibleToBytes { fatalError() }
    mutating func append<T>(
        repeating repeatedValue: T, count: Int, as type: T.Type, _ byteOrder: ByteOrder
    ) where T: BitwiseCopyable, T: ConvertibleToBytes, T: FixedWidthInteger { fatalError() }
    var bytes: RawSpan { fatalError() }
    var mutableBytes: MutableRawSpan { fatalError() }
    mutating func withUnsafeMutableBytes<E, R>(
        _ body: (UnsafeMutableRawBufferPointer, inout Int) throws(E) -> R
    ) throws(E) -> R where E: Error, R: ~Copyable { fatalError() }
    consuming func finalize(for buffer: UnsafeMutableRawBufferPointer) -> Int { fatalError() }
    consuming func finalize(for buffer: Slice<UnsafeMutableRawBufferPointer>) -> Int {
        fatalError()
    }
    typealias Failure = Never
    @export(implementation) var underestimatedCount: Int { fatalError() }
    @export(implementation) func makeBorrowingIterator() -> Span<UInt8>.BorrowingIterator {
        fatalError()
    }
    typealias BorrowingIterator = Span<UInt8>.BorrowingIterator
    typealias Element = UInt8
}

@frozen struct OutputSpan<Element> where Element: ~Copyable {
    var capacity: Int { fatalError() }
    init() { fatalError() }
    var count: Int { fatalError() }
    var freeCapacity: Int { fatalError() }
    var isEmpty: Bool { fatalError() }
    var isFull: Bool { fatalError() }
    init(buffer: UnsafeMutableBufferPointer<Element>, initializedCount: Int) { fatalError() }
    init(buffer: borrowing Slice<UnsafeMutableBufferPointer<Element>>, initializedCount: Int) {
        fatalError()
    }
    typealias Index = Int
    var indices: Range<OutputSpan<Element>.Index> { fatalError() }
    subscript(index: OutputSpan<Element>.Index) -> Element { fatalError() }
    subscript(unchecked index: OutputSpan<Element>.Index) -> Element { fatalError() }
    mutating func swapAt(_ i: OutputSpan<Element>.Index, _ j: OutputSpan<Element>.Index) {
        fatalError()
    }
    mutating func swapAt(
        unchecked i: OutputSpan<Element>.Index, unchecked j: OutputSpan<Element>.Index
    ) { fatalError() }
    mutating func append(_ value: consuming Element) { fatalError() }
    mutating func removeLast() -> Element { fatalError() }
    mutating func removeLast(_ n: Int) { fatalError() }
    mutating func removeAll() { fatalError() }
    mutating func append(repeating repeatedValue: Element, count: Int) { fatalError() }
    var span: Span<Element> { fatalError() }
    var mutableSpan: MutableSpan<Element> { fatalError() }
    mutating func withUnsafeMutableBufferPointer<E, R>(
        _ body: (UnsafeMutableBufferPointer<Element>, inout Int) throws(E) -> R
    ) throws(E) -> R where E: Error, R: ~Copyable { fatalError() }
    consuming func finalize(for buffer: UnsafeMutableBufferPointer<Element>) -> Int { fatalError() }
    consuming func finalize(for buffer: Slice<UnsafeMutableBufferPointer<Element>>) -> Int {
        fatalError()
    }
    typealias Failure = Never
    @export(implementation) var underestimatedCount: Int { fatalError() }
    @export(implementation) func makeBorrowingIterator() -> Span<Element>.BorrowingIterator {
        fatalError()
    }
    typealias BorrowingIterator = Span<Element>.BorrowingIterator
}

class PartialKeyPath<Root> {
}

@frozen struct PartialRangeFrom<Bound> where Bound: Comparable {
    var lowerBound: Bound { fatalError() }
    init(_ lowerBound: Bound) { fatalError() }
    func relative<C>(to collection: C) -> Range<Bound> where Bound == C.Index, C: Collection {
        fatalError()
    }
    func contains(_ element: Bound) -> Bool { fatalError() }
    typealias Element = Bound
    func makeIterator() -> PartialRangeFrom<Bound>.Iterator { fatalError() }
    init(from decoder: any Decoder) throws { fatalError() }
    func encode(to encoder: any Encoder) throws { fatalError() }
    @frozen struct Iterator {
        mutating func next() -> Bound? { fatalError() }
        typealias Element = Bound
    }
}

@frozen struct PartialRangeThrough<Bound> where Bound: Comparable {
    var upperBound: Bound { fatalError() }
    init(_ upperBound: Bound) { fatalError() }
    func relative<C>(to collection: C) -> Range<Bound> where Bound == C.Index, C: Collection {
        fatalError()
    }
    func contains(_ element: Bound) -> Bool { fatalError() }
    init(from decoder: any Decoder) throws { fatalError() }
    func encode(to encoder: any Encoder) throws { fatalError() }
}

@frozen struct PartialRangeUpTo<Bound> where Bound: Comparable {
    var upperBound: Bound { fatalError() }
    init(_ upperBound: Bound) { fatalError() }
    func relative<C>(to collection: C) -> Range<Bound> where Bound == C.Index, C: Collection {
        fatalError()
    }
    func contains(_ element: Bound) -> Bool { fatalError() }
    init(from decoder: any Decoder) throws { fatalError() }
    func encode(to encoder: any Encoder) throws { fatalError() }
}

@frozen struct PrefixSequence<Base> where Base: Sequence {
    init(_ base: Base, maxLength: Int) { fatalError() }
    func makeIterator() -> PrefixSequence<Base>.Iterator { fatalError() }
    func prefix(_ maxLength: Int) -> PrefixSequence<Base> { fatalError() }
    typealias Element = PrefixSequence<Base>.Iterator.Element
    @frozen struct Iterator {
        typealias Element = Base.Element
        mutating func next() -> PrefixSequence<Base>.Iterator.Element? { fatalError() }
    }
}

protocol RandomAccessCollection<Element>: BidirectionalCollection
where Self.Indices: RandomAccessCollection, Self.SubSequence: RandomAccessCollection {
    associatedtype Element
    associatedtype Index
    associatedtype SubSequence
    associatedtype Indices
    override var indices: Self.Indices { get }
    override subscript(bounds: Range<Self.Index>) -> Self.SubSequence { get }
    override subscript(position: Self.Index) -> Self.Element { get }
    override var startIndex: Self.Index { get }
    override var endIndex: Self.Index { get }
    override func index(before i: Self.Index) -> Self.Index
    override func formIndex(before i: inout Self.Index)
    override func index(after i: Self.Index) -> Self.Index
    override func formIndex(after i: inout Self.Index)
    func index(_ i: Self.Index, offsetBy distance: Int) -> Self.Index
    func index(_ i: Self.Index, offsetBy distance: Int, limitedBy limit: Self.Index) -> Self.Index?
    func distance(from start: Self.Index, to end: Self.Index) -> Int
    var indices: Range<Self.Index> { get }
    func index(after i: Self.Index) -> Self.Index
    func index(before i: Self.Index) -> Self.Index
    func index(_ i: Self.Index, offsetBy distance: Self.Index.Stride) -> Self.Index
    func distance(from start: Self.Index, to end: Self.Index) -> Self.Index.Stride
}

protocol RandomNumberGenerator {
    mutating func next() -> UInt64
    mutating func next<T>() -> T where T: FixedWidthInteger, T: UnsignedInteger
    mutating func next<T>(upperBound: T) -> T where T: FixedWidthInteger, T: UnsignedInteger
}

@frozen struct Range<Bound> where Bound: Comparable {
    var lowerBound: Bound { fatalError() }
    var upperBound: Bound { fatalError() }
    init(uncheckedBounds bounds: (lower: Bound, upper: Bound)) { fatalError() }
    func contains(_ element: Bound) -> Bool { fatalError() }
    var isEmpty: Bool { fatalError() }
    typealias Element = Bound
    typealias Iterator = IndexingIterator<Range<Bound>>
    typealias Index = Bound
    typealias Indices = Range<Bound>
    typealias SubSequence = Range<Bound>
    var startIndex: Range<Bound>.Index { fatalError() }
    var endIndex: Range<Bound>.Index { fatalError() }
    func index(after i: Range<Bound>.Index) -> Range<Bound>.Index { fatalError() }
    func index(before i: Range<Bound>.Index) -> Range<Bound>.Index { fatalError() }
    func index(_ i: Range<Bound>.Index, offsetBy n: Int) -> Range<Bound>.Index { fatalError() }
    func distance(from start: Range<Bound>.Index, to end: Range<Bound>.Index) -> Int {
        fatalError()
    }
    subscript(bounds: Range<Range<Bound>.Index>) -> Range<Bound> { fatalError() }
    var indices: Range<Bound>.Indices { fatalError() }
    subscript(position: Range<Bound>.Index) -> Range<Bound>.Element { fatalError() }
    init(_ other: ClosedRange<Bound>) { fatalError() }
    func relative<C>(to collection: C) -> Range<Bound> where Bound == C.Index, C: Collection {
        fatalError()
    }
    func clamped(to limits: Range<Bound>) -> Range<Bound> { fatalError() }
    var description: String { fatalError() }
    var debugDescription: String { fatalError() }
    var customMirror: Mirror { fatalError() }
    static func == (lhs: Range<Bound>, rhs: Range<Bound>) -> Bool { fatalError() }
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    init(from decoder: any Decoder) throws { fatalError() }
    func encode(to encoder: any Encoder) throws { fatalError() }
    func overlaps(_ other: Range<Bound>) -> Bool { fatalError() }
    func overlaps(_ other: ClosedRange<Bound>) -> Bool { fatalError() }
    func contains(_ other: Range<Bound>) -> Bool { fatalError() }
    func contains(_ other: ClosedRange<Bound>) -> Bool { fatalError() }
    init(_ other: Range<Bound>) { fatalError() }
}

protocol RangeExpression<Bound> {
    associatedtype Bound: Comparable
    func relative<C>(to collection: C) -> Range<Self.Bound>
    where C: Collection, Self.Bound == C.Index
    func contains(_ element: Self.Bound) -> Bool
    static func ~= (pattern: Self, value: Self.Bound) -> Bool
}

protocol RangeReplaceableCollection<Element>: Collection
where Self.SubSequence: RangeReplaceableCollection {
    associatedtype SubSequence
    init()
    mutating func replaceSubrange<C>(_ subrange: Range<Self.Index>, with newElements: C)
    where C: Collection, Self.Element == C.Element
    mutating func reserveCapacity(_ n: Int)
    init(repeating repeatedValue: Self.Element, count: Int)
    init<S>(_ elements: S) where S: Sequence, Self.Element == S.Element
    mutating func append(_ newElement: Self.Element)
    mutating func append<S>(contentsOf newElements: S) where S: Sequence, Self.Element == S.Element
    mutating func insert(_ newElement: Self.Element, at i: Self.Index)
    mutating func insert<S>(contentsOf newElements: S, at i: Self.Index)
    where S: Collection, Self.Element == S.Element
    @discardableResult mutating func remove(at i: Self.Index) -> Self.Element
    mutating func removeSubrange(_ bounds: Range<Self.Index>)
    @discardableResult mutating func removeFirst() -> Self.Element
    mutating func removeFirst(_ k: Int)
    mutating func removeAll(keepingCapacity keepCapacity: Bool)
    mutating func removeAll(where shouldBeRemoved: (Self.Element) throws -> Bool) rethrows
    override subscript(position: Self.Index) -> Self.Element { get }
    override subscript(bounds: Range<Self.Index>) -> Self.SubSequence { get }
    mutating func insert<C>(contentsOf newElements: C, at i: Self.Index)
    where C: Collection, Self.Element == C.Element
    @discardableResult mutating func remove(at position: Self.Index) -> Self.Element
    mutating func removeAll(keepingCapacity keepCapacity: Bool)
    mutating func replaceSubrange<C, R>(_ subrange: R, with newElements: C)
    where C: Collection, R: RangeExpression, Self.Element == C.Element, Self.Index == R.Bound
    mutating func removeSubrange<R>(_ bounds: R) where R: RangeExpression, Self.Index == R.Bound
    mutating func popLast() -> Self.Element?
    @discardableResult mutating func removeLast() -> Self.Element
    mutating func removeLast(_ k: Int)
    static func + <Other>(lhs: Self, rhs: Other) -> Self
    where Other: Sequence, Self.Element == Other.Element
    static func + <Other>(lhs: Other, rhs: Self) -> Self
    where Other: Sequence, Self.Element == Other.Element
    static func += <Other>(lhs: inout Self, rhs: Other)
    where Other: Sequence, Self.Element == Other.Element
    static func + <Other>(lhs: Self, rhs: Other) -> Self
    where Other: RangeReplaceableCollection, Self.Element == Other.Element
    consuming func filter<E>(_ isIncluded: (Self.Element) throws(E) -> Bool) throws(E) -> Self
    where E: Error
    mutating func removeSubranges(_ subranges: RangeSet<Self.Index>)
    func applying(_ difference: CollectionDifference<Self.Element>) -> Self?
}

struct RangeSet<Bound> where Bound: Comparable {
    var ranges: RangeSet<Bound>.Ranges { fatalError() }
    init() { fatalError() }
    init(_ range: Range<Bound>) { fatalError() }
    init(_ ranges: some Sequence<Range<Bound>>) { fatalError() }
    var isEmpty: Bool { fatalError() }
    func contains(_ value: Bound) -> Bool { fatalError() }
    mutating func insert(contentsOf range: Range<Bound>) { fatalError() }
    mutating func remove(contentsOf range: Range<Bound>) { fatalError() }
    static func == (left: RangeSet<Bound>, right: RangeSet<Bound>) -> Bool { fatalError() }
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    init<S, C>(_ indices: S, within collection: C)
    where Bound == S.Element, S: Sequence, C: Collection, S.Element == C.Index { fatalError() }
    @discardableResult mutating func insert<C>(_ index: Bound, within collection: C) -> Bool
    where Bound == C.Index, C: Collection { fatalError() }
    mutating func remove<C>(_ index: Bound, within collection: C)
    where Bound == C.Index, C: Collection { fatalError() }
    mutating func formUnion(_ other: RangeSet<Bound>) { fatalError() }
    mutating func formIntersection(_ other: RangeSet<Bound>) { fatalError() }
    mutating func formSymmetricDifference(_ other: RangeSet<Bound>) { fatalError() }
    mutating func subtract(_ other: RangeSet<Bound>) { fatalError() }
    func union(_ other: RangeSet<Bound>) -> RangeSet<Bound> { fatalError() }
    func intersection(_ other: RangeSet<Bound>) -> RangeSet<Bound> { fatalError() }
    func symmetricDifference(_ other: RangeSet<Bound>) -> RangeSet<Bound> { fatalError() }
    func subtracting(_ other: RangeSet<Bound>) -> RangeSet<Bound> { fatalError() }
    func isSubset(of other: RangeSet<Bound>) -> Bool { fatalError() }
    func isSuperset(of other: RangeSet<Bound>) -> Bool { fatalError() }
    func isStrictSubset(of other: RangeSet<Bound>) -> Bool { fatalError() }
    func isStrictSuperset(of other: RangeSet<Bound>) -> Bool { fatalError() }
    func isDisjoint(_ other: RangeSet<Bound>) -> Bool { fatalError() }
    var description: String { fatalError() }
    struct Ranges {
        typealias Element = Range<Bound>
        typealias Iterator = IndexingIterator<RangeSet<Bound>.Ranges>
        typealias Index = Int
        typealias Indices = Range<RangeSet<Bound>.Ranges.Index>
        typealias SubSequence = Slice<RangeSet<Bound>.Ranges>
        var startIndex: RangeSet<Bound>.Ranges.Index { fatalError() }
        var endIndex: RangeSet<Bound>.Ranges.Index { fatalError() }
        var count: Int { fatalError() }
        subscript(i: RangeSet<Bound>.Ranges.Index) -> RangeSet<Bound>.Ranges.Element {
            fatalError()
        }
        static func == (left: RangeSet<Bound>.Ranges, right: RangeSet<Bound>.Ranges) -> Bool {
            fatalError()
        }
        func hash(into hasher: inout Hasher) { fatalError() }
        var hashValue: Int { fatalError() }
        var description: String { fatalError() }
    }
}

protocol RawRepresentable<RawValue> {
    func encode(to encoder: any Encoder) throws
    init(from decoder: any Decoder) throws
    var codingKey: any CodingKey { get }
    init?<T>(codingKey: T) where T: CodingKey
    associatedtype RawValue
    init?(rawValue: Self.RawValue)
    var rawValue: Self.RawValue { get }
    var hashValue: Int { get }
    func hash(into hasher: inout Hasher)
}

@frozen struct RawSpan {
    init() { fatalError() }
    init<Element>(unsafeElements span: Span<Element>) { fatalError() }
    init<Element>(elements span: Span<Element>) where Element: ConvertibleToBytes { fatalError() }
    var byteCount: Int { fatalError() }
    var isEmpty: Bool { fatalError() }
    var byteOffsets: Range<Int> { fatalError() }
    subscript(byteOffset: Int) -> UInt8 { fatalError() }
    subscript(unchecked byteOffset: Int) -> UInt8 { fatalError() }
    func extracting(_ bounds: Range<Int>) -> RawSpan { fatalError() }
    func extracting(unchecked bounds: Range<Int>) -> RawSpan { fatalError() }
    func extracting(_ bounds: some RangeExpression<Int>) -> RawSpan { fatalError() }
    func extracting(unchecked bounds: ClosedRange<Int>) -> RawSpan { fatalError() }
    func extracting(_: UnboundedRange) -> RawSpan { fatalError() }
    func withUnsafeBytes<E, Result>(_ body: (UnsafeRawBufferPointer) throws(E) -> Result) throws(E)
        -> Result where E: Error, Result: ~Copyable
    { fatalError() }
    func unsafeLoad<T>(fromByteOffset offset: Int = 0, as type: T.Type) -> T { fatalError() }
    func unsafeLoad<T>(fromUncheckedByteOffset offset: Int, as type: T.Type) -> T { fatalError() }
    func unsafeLoadUnaligned<T>(fromByteOffset offset: Int = 0, as type: T.Type) -> T
    where T: BitwiseCopyable { fatalError() }
    func unsafeLoadUnaligned<T>(fromUncheckedByteOffset offset: Int, as type: T.Type) -> T
    where T: BitwiseCopyable { fatalError() }
    func load<T>(fromByteOffset offset: Int, as type: T.Type) -> T where T: ConvertibleFromBytes {
        fatalError()
    }
    func load<T>(fromByteOffset offset: Int, as type: T.Type, _ byteOrder: ByteOrder) -> T
    where T: ConvertibleFromBytes, T: FixedWidthInteger { fatalError() }
    func isIdentical(to other: RawSpan) -> Bool { fatalError() }
    func isTriviallyIdentical(to other: RawSpan) -> Bool { fatalError() }
    func byteOffsets(of other: borrowing RawSpan) -> Range<Int>? { fatalError() }
    func extracting(first maxLength: Int) -> RawSpan { fatalError() }
    func extracting(droppingLast k: Int) -> RawSpan { fatalError() }
    func extracting(last maxLength: Int) -> RawSpan { fatalError() }
    func extracting(droppingFirst k: Int) -> RawSpan { fatalError() }
    typealias Failure = Never
    @export(implementation) var underestimatedCount: Int { fatalError() }
    @export(implementation) func makeBorrowingIterator() -> Span<UInt8>.BorrowingIterator {
        fatalError()
    }
    typealias BorrowingIterator = Span<UInt8>.BorrowingIterator
    typealias Element = UInt8
}

@frozen struct Ref<Value> where Value: ~Copyable {
    init(_ value: borrowing Value) { fatalError() }
    init<Owner>(unsafeAddress pointer: UnsafePointer<Value>, borrowing owner: borrowing Owner)
    where Owner: ~Copyable, Owner: ~Escapable { fatalError() }
    var value: Value { fatalError() }
}

class ReferenceWritableKeyPath<Root, Value> {
}

@frozen struct Repeated<Element> {
    var count: Int { fatalError() }
    var repeatedValue: Element { fatalError() }
    typealias Indices = Range<Int>
    typealias Index = Int
    var startIndex: Repeated<Element>.Index { fatalError() }
    var endIndex: Repeated<Element>.Index { fatalError() }
    subscript(position: Int) -> Element { fatalError() }
    typealias Iterator = IndexingIterator<Repeated<Element>>
    typealias SubSequence = Slice<Repeated<Element>>
}

@frozen enum Result<Success, Failure>
where Failure: Error, Success: ~Copyable, Success: ~Escapable {
    case success(Success)
    case failure(Failure)
    static func == (a: Result<Success, Failure>, b: Result<Success, Failure>) -> Bool {
        fatalError()
    }
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    func map<NewSuccess>(_ transform: (Success) -> NewSuccess) -> Result<NewSuccess, Failure>
    where NewSuccess: ~Copyable { fatalError() }
    consuming func mapError<NewFailure>(_ transform: (Failure) -> NewFailure) -> Result<
        Success, NewFailure
    > where NewFailure: Error { fatalError() }
    func flatMap<NewSuccess>(_ transform: (Success) -> Result<NewSuccess, Failure>) -> Result<
        NewSuccess, Failure
    > where NewSuccess: ~Copyable { fatalError() }
    consuming func flatMapError<NewFailure>(_ transform: (Failure) -> Result<Success, NewFailure>)
        -> Result<Success, NewFailure> where NewFailure: Error
    { fatalError() }
    consuming func get() throws(Failure) -> Success { fatalError() }
    init(catching body: () throws(Failure) -> Success) { fatalError() }
}

@frozen struct ReversedCollection<Base> where Base: BidirectionalCollection {
    typealias Elements = ReversedCollection<Base>
    typealias Element = Base.Element
    func makeIterator() -> ReversedCollection<Base>.Iterator { fatalError() }
    var startIndex: ReversedCollection<Base>.Index { fatalError() }
    var endIndex: ReversedCollection<Base>.Index { fatalError() }
    func index(after i: ReversedCollection<Base>.Index) -> ReversedCollection<Base>.Index {
        fatalError()
    }
    func index(before i: ReversedCollection<Base>.Index) -> ReversedCollection<Base>.Index {
        fatalError()
    }
    func index(_ i: ReversedCollection<Base>.Index, offsetBy n: Int)
        -> ReversedCollection<Base>.Index
    { fatalError() }
    func index(
        _ i: ReversedCollection<Base>.Index, offsetBy n: Int,
        limitedBy limit: ReversedCollection<Base>.Index
    ) -> ReversedCollection<Base>.Index? { fatalError() }
    func distance(
        from start: ReversedCollection<Base>.Index, to end: ReversedCollection<Base>.Index
    ) -> Int { fatalError() }
    subscript(position: ReversedCollection<Base>.Index) -> ReversedCollection<Base>.Element {
        fatalError()
    }
    typealias Indices = DefaultIndices<ReversedCollection<Base>>
    typealias SubSequence = Slice<ReversedCollection<Base>>
    func reversed() -> Base { fatalError() }
    @frozen struct Index {
        var base: Base.Index { fatalError() }
        init(_ base: Base.Index) { fatalError() }
        static func == (lhs: ReversedCollection<Base>.Index, rhs: ReversedCollection<Base>.Index)
            -> Bool
        { fatalError() }
        static func < (lhs: ReversedCollection<Base>.Index, rhs: ReversedCollection<Base>.Index)
            -> Bool
        { fatalError() }
        func hash(into hasher: inout Hasher) { fatalError() }
        var hashValue: Int { fatalError() }
    }
    @frozen struct Iterator {
        typealias Element = Base.Element
        mutating func next() -> ReversedCollection<Base>.Iterator.Element? { fatalError() }
        typealias Iterator = ReversedCollection<Base>.Iterator
    }
}

protocol SIMD<Scalar>: CustomStringConvertible, Decodable, Encodable, ExpressibleByArrayLiteral,
    Hashable, SIMDStorage
{
    associatedtype MaskStorage: SIMD
    where Self.MaskStorage.Scalar: FixedWidthInteger, Self.MaskStorage.Scalar: SignedInteger
    var indices: Range<Int> { get }
    init(repeating value: Self.Scalar)
    static func == (a: Self, b: Self) -> Bool
    func hash(into hasher: inout Hasher)
    func encode(to encoder: any Encoder) throws
    init(from decoder: any Decoder) throws
    var description: String { get }
    static func .== (a: Self, b: Self) -> SIMDMask<Self.MaskStorage>
    static func .!= (a: Self, b: Self) -> SIMDMask<Self.MaskStorage>
    mutating func replace(with other: Self, where mask: SIMDMask<Self.MaskStorage>)
    init(arrayLiteral scalars: Self.Scalar...)
    init<S>(_ scalars: S) where S: Sequence, Self.Scalar == S.Element
    subscript<Index>(index: SIMD2<Index>) -> SIMD2<Self.Scalar>
    where Index: FixedWidthInteger, Index: SIMDScalar, Self.Scalar: SIMDScalar { get }
    subscript<Index>(index: SIMD3<Index>) -> SIMD3<Self.Scalar>
    where Index: FixedWidthInteger, Index: SIMDScalar, Self.Scalar: SIMDScalar { get }
    subscript<Index>(index: SIMD4<Index>) -> SIMD4<Self.Scalar>
    where Index: FixedWidthInteger, Index: SIMDScalar, Self.Scalar: SIMDScalar { get }
    subscript<Index>(index: SIMD8<Index>) -> SIMD8<Self.Scalar>
    where Index: FixedWidthInteger, Index: SIMDScalar, Self.Scalar: SIMDScalar { get }
    subscript<Index>(index: SIMD16<Index>) -> SIMD16<Self.Scalar>
    where Index: FixedWidthInteger, Index: SIMDScalar, Self.Scalar: SIMDScalar { get }
    subscript<Index>(index: SIMD32<Index>) -> SIMD32<Self.Scalar>
    where Index: FixedWidthInteger, Index: SIMDScalar, Self.Scalar: SIMDScalar { get }
    subscript<Index>(index: SIMD64<Index>) -> SIMD64<Self.Scalar>
    where Index: FixedWidthInteger, Index: SIMDScalar, Self.Scalar: SIMDScalar { get }
    static func .< (a: Self, b: Self) -> SIMDMask<Self.MaskStorage>
    static func .<= (a: Self, b: Self) -> SIMDMask<Self.MaskStorage>
    func min() -> Self.Scalar
    func max() -> Self.Scalar
    static func .== (a: Self.Scalar, b: Self) -> SIMDMask<Self.MaskStorage>
    static func .!= (a: Self.Scalar, b: Self) -> SIMDMask<Self.MaskStorage>
    static func .== (a: Self, b: Self.Scalar) -> SIMDMask<Self.MaskStorage>
    static func .!= (a: Self, b: Self.Scalar) -> SIMDMask<Self.MaskStorage>
    mutating func replace(with other: Self.Scalar, where mask: SIMDMask<Self.MaskStorage>)
    func replacing(with other: Self, where mask: SIMDMask<Self.MaskStorage>) -> Self
    func replacing(with other: Self.Scalar, where mask: SIMDMask<Self.MaskStorage>) -> Self
    static func .>= (a: Self, b: Self) -> SIMDMask<Self.MaskStorage>
    static func .> (a: Self, b: Self) -> SIMDMask<Self.MaskStorage>
    static func .< (a: Self.Scalar, b: Self) -> SIMDMask<Self.MaskStorage>
    static func .<= (a: Self.Scalar, b: Self) -> SIMDMask<Self.MaskStorage>
    static func .>= (a: Self.Scalar, b: Self) -> SIMDMask<Self.MaskStorage>
    static func .> (a: Self.Scalar, b: Self) -> SIMDMask<Self.MaskStorage>
    static func .< (a: Self, b: Self.Scalar) -> SIMDMask<Self.MaskStorage>
    static func .<= (a: Self, b: Self.Scalar) -> SIMDMask<Self.MaskStorage>
    static func .>= (a: Self, b: Self.Scalar) -> SIMDMask<Self.MaskStorage>
    static func .> (a: Self, b: Self.Scalar) -> SIMDMask<Self.MaskStorage>
    mutating func clamp(lowerBound: Self, upperBound: Self)
    func clamped(lowerBound: Self, upperBound: Self) -> Self
    static var zero: Self { get }
    static var one: Self { get }
    static func random<T>(in range: Range<Self.Scalar>, using generator: inout T) -> Self
    where T: RandomNumberGenerator
    static func random(in range: Range<Self.Scalar>) -> Self
    static func random<T>(in range: ClosedRange<Self.Scalar>, using generator: inout T) -> Self
    where T: RandomNumberGenerator
    static func random(in range: ClosedRange<Self.Scalar>) -> Self
    var leadingZeroBitCount: Self { get }
    var trailingZeroBitCount: Self { get }
    var nonzeroBitCount: Self { get }
    static func ~ (a: Self) -> Self
    static func & (a: Self, b: Self) -> Self
    static func ^ (a: Self, b: Self) -> Self
    static func | (a: Self, b: Self) -> Self
    static func &<< (a: Self, b: Self) -> Self
    static func &>> (a: Self, b: Self) -> Self
    static func &+ (a: Self, b: Self) -> Self
    static func &- (a: Self, b: Self) -> Self
    static func &* (a: Self, b: Self) -> Self
    static func / (a: Self, b: Self) -> Self
    static func % (a: Self, b: Self) -> Self
    func wrappedSum() -> Self.Scalar
    static func + (a: Self, b: Self) -> Self
    static func - (a: Self, b: Self) -> Self
    static func * (a: Self, b: Self) -> Self
    func addingProduct(_ a: Self, _ b: Self) -> Self
    func squareRoot() -> Self
    func rounded(_ rule: FloatingPointRoundingRule) -> Self
    func sum() -> Self.Scalar
    static func & (a: Self.Scalar, b: Self) -> Self
    static func ^ (a: Self.Scalar, b: Self) -> Self
    static func | (a: Self.Scalar, b: Self) -> Self
    static func &<< (a: Self.Scalar, b: Self) -> Self
    static func &>> (a: Self.Scalar, b: Self) -> Self
    static func &+ (a: Self.Scalar, b: Self) -> Self
    static func &- (a: Self.Scalar, b: Self) -> Self
    static func &* (a: Self.Scalar, b: Self) -> Self
    static func / (a: Self.Scalar, b: Self) -> Self
    static func % (a: Self.Scalar, b: Self) -> Self
    static func & (a: Self, b: Self.Scalar) -> Self
    static func ^ (a: Self, b: Self.Scalar) -> Self
    static func | (a: Self, b: Self.Scalar) -> Self
    static func &<< (a: Self, b: Self.Scalar) -> Self
    static func &>> (a: Self, b: Self.Scalar) -> Self
    static func &+ (a: Self, b: Self.Scalar) -> Self
    static func &- (a: Self, b: Self.Scalar) -> Self
    static func &* (a: Self, b: Self.Scalar) -> Self
    static func / (a: Self, b: Self.Scalar) -> Self
    static func % (a: Self, b: Self.Scalar) -> Self
    static func &= (a: inout Self, b: Self)
    static func ^= (a: inout Self, b: Self)
    static func |= (a: inout Self, b: Self)
    static func &<<= (a: inout Self, b: Self)
    static func &>>= (a: inout Self, b: Self)
    static func &+= (a: inout Self, b: Self)
    static func &-= (a: inout Self, b: Self)
    static func &*= (a: inout Self, b: Self)
    static func /= (a: inout Self, b: Self)
    static func %= (a: inout Self, b: Self)
    static func &= (a: inout Self, b: Self.Scalar)
    static func ^= (a: inout Self, b: Self.Scalar)
    static func |= (a: inout Self, b: Self.Scalar)
    static func &<<= (a: inout Self, b: Self.Scalar)
    static func &>>= (a: inout Self, b: Self.Scalar)
    static func &+= (a: inout Self, b: Self.Scalar)
    static func &-= (a: inout Self, b: Self.Scalar)
    static func &*= (a: inout Self, b: Self.Scalar)
    static func /= (a: inout Self, b: Self.Scalar)
    static func %= (a: inout Self, b: Self.Scalar)
    static func - (a: Self) -> Self
    static func + (a: Self.Scalar, b: Self) -> Self
    static func - (a: Self.Scalar, b: Self) -> Self
    static func * (a: Self.Scalar, b: Self) -> Self
    static func + (a: Self, b: Self.Scalar) -> Self
    static func - (a: Self, b: Self.Scalar) -> Self
    static func * (a: Self, b: Self.Scalar) -> Self
    static func += (a: inout Self, b: Self)
    static func -= (a: inout Self, b: Self)
    static func *= (a: inout Self, b: Self)
    static func += (a: inout Self, b: Self.Scalar)
    static func -= (a: inout Self, b: Self.Scalar)
    static func *= (a: inout Self, b: Self.Scalar)
    func addingProduct(_ a: Self.Scalar, _ b: Self) -> Self
    func addingProduct(_ a: Self, _ b: Self.Scalar) -> Self
    mutating func addProduct(_ a: Self, _ b: Self)
    mutating func addProduct(_ a: Self.Scalar, _ b: Self)
    mutating func addProduct(_ a: Self, _ b: Self.Scalar)
    mutating func formSquareRoot()
    mutating func round(_ rule: FloatingPointRoundingRule)
}

@frozen struct SIMD16<Scalar> where Scalar: SIMDScalar {
    init(repeating scalar: Float) { fatalError() }
    init(lowHalf: SIMD8<Float>, highHalf: SIMD8<Float>) { fatalError() }
    static func .== (a: SIMD16<Scalar>, b: SIMD16<Scalar>) -> SIMDMask<SIMD16<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .== (a: SIMD16<Scalar>, b: Scalar) -> SIMDMask<SIMD16<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .== (a: Scalar, b: SIMD16<Scalar>) -> SIMDMask<SIMD16<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .!= (a: SIMD16<Scalar>, b: SIMD16<Scalar>) -> SIMDMask<SIMD16<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .!= (a: SIMD16<Scalar>, b: Scalar) -> SIMDMask<SIMD16<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .!= (a: Scalar, b: SIMD16<Scalar>) -> SIMDMask<SIMD16<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .< (a: SIMD16<Scalar>, b: SIMD16<Scalar>) -> SIMDMask<SIMD16<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .< (a: SIMD16<Scalar>, b: Scalar) -> SIMDMask<SIMD16<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .< (a: Scalar, b: SIMD16<Scalar>) -> SIMDMask<SIMD16<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .<= (a: SIMD16<Scalar>, b: SIMD16<Scalar>) -> SIMDMask<SIMD16<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .<= (a: SIMD16<Scalar>, b: Scalar) -> SIMDMask<SIMD16<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .<= (a: Scalar, b: SIMD16<Scalar>) -> SIMDMask<SIMD16<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .>= (a: SIMD16<Scalar>, b: SIMD16<Scalar>) -> SIMDMask<SIMD16<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .>= (a: SIMD16<Scalar>, b: Scalar) -> SIMDMask<SIMD16<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .>= (a: Scalar, b: SIMD16<Scalar>) -> SIMDMask<SIMD16<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .> (a: SIMD16<Scalar>, b: SIMD16<Scalar>) -> SIMDMask<SIMD16<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .> (a: SIMD16<Scalar>, b: Scalar) -> SIMDMask<SIMD16<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .> (a: Scalar, b: SIMD16<Scalar>) -> SIMDMask<SIMD16<Scalar>.MaskStorage> {
        fatalError()
    }
    init(repeating scalar: Double) { fatalError() }
    init(lowHalf: SIMD8<Double>, highHalf: SIMD8<Double>) { fatalError() }
    init(repeating scalar: UInt8) { fatalError() }
    init(lowHalf: SIMD8<UInt8>, highHalf: SIMD8<UInt8>) { fatalError() }
    static func &+ (a: SIMD16<Scalar>, b: SIMD16<Scalar>) -> SIMD16<Scalar> { fatalError() }
    static func &- (a: SIMD16<Scalar>, b: SIMD16<Scalar>) -> SIMD16<Scalar> { fatalError() }
    static func &* (a: SIMD16<Scalar>, b: SIMD16<Scalar>) -> SIMD16<Scalar> { fatalError() }
    static func &+= (a: inout SIMD16<Scalar>, b: SIMD16<Scalar>) { fatalError() }
    static func &-= (a: inout SIMD16<Scalar>, b: SIMD16<Scalar>) { fatalError() }
    static func &*= (a: inout SIMD16<Scalar>, b: SIMD16<Scalar>) { fatalError() }
    init(repeating scalar: Int8) { fatalError() }
    init(lowHalf: SIMD8<Int8>, highHalf: SIMD8<Int8>) { fatalError() }
    init(repeating scalar: UInt16) { fatalError() }
    init(lowHalf: SIMD8<UInt16>, highHalf: SIMD8<UInt16>) { fatalError() }
    init(repeating scalar: Int16) { fatalError() }
    init(lowHalf: SIMD8<Int16>, highHalf: SIMD8<Int16>) { fatalError() }
    init(repeating scalar: UInt32) { fatalError() }
    init(lowHalf: SIMD8<UInt32>, highHalf: SIMD8<UInt32>) { fatalError() }
    init(repeating scalar: Int32) { fatalError() }
    init(lowHalf: SIMD8<Int32>, highHalf: SIMD8<Int32>) { fatalError() }
    init(repeating scalar: UInt64) { fatalError() }
    init(lowHalf: SIMD8<UInt64>, highHalf: SIMD8<UInt64>) { fatalError() }
    init(repeating scalar: Int64) { fatalError() }
    init(lowHalf: SIMD8<Int64>, highHalf: SIMD8<Int64>) { fatalError() }
    init(repeating scalar: UInt) { fatalError() }
    init(lowHalf: SIMD8<UInt>, highHalf: SIMD8<UInt>) { fatalError() }
    init(repeating scalar: Int) { fatalError() }
    init(lowHalf: SIMD8<Int>, highHalf: SIMD8<Int>) { fatalError() }
    typealias MaskStorage = SIMD16<Scalar.SIMDMaskScalar>
    var scalarCount: Int { fatalError() }
    init() { fatalError() }
    subscript(index: Int) -> Scalar { fatalError() }
    init(
        _ v0: Scalar, _ v1: Scalar, _ v2: Scalar, _ v3: Scalar, _ v4: Scalar, _ v5: Scalar,
        _ v6: Scalar, _ v7: Scalar, _ v8: Scalar, _ v9: Scalar, _ v10: Scalar, _ v11: Scalar,
        _ v12: Scalar, _ v13: Scalar, _ v14: Scalar, _ v15: Scalar
    ) { fatalError() }
    init(lowHalf: SIMD8<Scalar>, highHalf: SIMD8<Scalar>) { fatalError() }
    var lowHalf: SIMD8<Scalar> { fatalError() }
    var highHalf: SIMD8<Scalar> { fatalError() }
    var evenHalf: SIMD8<Scalar> { fatalError() }
    var oddHalf: SIMD8<Scalar> { fatalError() }
    typealias ArrayLiteralElement = Scalar
    var hashValue: Int { fatalError() }
    init<Other>(truncatingIfNeeded other: SIMD16<Other>)
    where Other: FixedWidthInteger, Other: SIMDScalar { fatalError() }
    init<Other>(clamping other: SIMD16<Other>) where Other: FixedWidthInteger, Other: SIMDScalar {
        fatalError()
    }
    init<Other>(_ other: SIMD16<Other>, rounding rule: FloatingPointRoundingRule = .towardZero)
    where Other: BinaryFloatingPoint, Other: SIMDScalar { fatalError() }
    var debugDescription: String { fatalError() }
    init<Other>(_ other: SIMD16<Other>) where Other: FixedWidthInteger, Other: SIMDScalar {
        fatalError()
    }
    init<Other>(_ other: SIMD16<Other>) where Other: BinaryFloatingPoint, Other: SIMDScalar {
        fatalError()
    }
}

@frozen struct SIMD2<Scalar> where Scalar: SIMDScalar {
    init(repeating scalar: Float) { fatalError() }
    static func .== (a: SIMD2<Scalar>, b: SIMD2<Scalar>) -> SIMDMask<SIMD2<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .== (a: SIMD2<Scalar>, b: Scalar) -> SIMDMask<SIMD2<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .== (a: Scalar, b: SIMD2<Scalar>) -> SIMDMask<SIMD2<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .!= (a: SIMD2<Scalar>, b: SIMD2<Scalar>) -> SIMDMask<SIMD2<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .!= (a: SIMD2<Scalar>, b: Scalar) -> SIMDMask<SIMD2<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .!= (a: Scalar, b: SIMD2<Scalar>) -> SIMDMask<SIMD2<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .< (a: SIMD2<Scalar>, b: SIMD2<Scalar>) -> SIMDMask<SIMD2<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .< (a: SIMD2<Scalar>, b: Scalar) -> SIMDMask<SIMD2<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .< (a: Scalar, b: SIMD2<Scalar>) -> SIMDMask<SIMD2<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .<= (a: SIMD2<Scalar>, b: SIMD2<Scalar>) -> SIMDMask<SIMD2<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .<= (a: SIMD2<Scalar>, b: Scalar) -> SIMDMask<SIMD2<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .<= (a: Scalar, b: SIMD2<Scalar>) -> SIMDMask<SIMD2<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .>= (a: SIMD2<Scalar>, b: SIMD2<Scalar>) -> SIMDMask<SIMD2<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .>= (a: SIMD2<Scalar>, b: Scalar) -> SIMDMask<SIMD2<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .>= (a: Scalar, b: SIMD2<Scalar>) -> SIMDMask<SIMD2<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .> (a: SIMD2<Scalar>, b: SIMD2<Scalar>) -> SIMDMask<SIMD2<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .> (a: SIMD2<Scalar>, b: Scalar) -> SIMDMask<SIMD2<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .> (a: Scalar, b: SIMD2<Scalar>) -> SIMDMask<SIMD2<Scalar>.MaskStorage> {
        fatalError()
    }
    init(repeating scalar: Double) { fatalError() }
    init(repeating scalar: UInt8) { fatalError() }
    static func &+ (a: SIMD2<Scalar>, b: SIMD2<Scalar>) -> SIMD2<Scalar> { fatalError() }
    static func &- (a: SIMD2<Scalar>, b: SIMD2<Scalar>) -> SIMD2<Scalar> { fatalError() }
    static func &* (a: SIMD2<Scalar>, b: SIMD2<Scalar>) -> SIMD2<Scalar> { fatalError() }
    static func &+= (a: inout SIMD2<Scalar>, b: SIMD2<Scalar>) { fatalError() }
    static func &-= (a: inout SIMD2<Scalar>, b: SIMD2<Scalar>) { fatalError() }
    static func &*= (a: inout SIMD2<Scalar>, b: SIMD2<Scalar>) { fatalError() }
    init(repeating scalar: Int8) { fatalError() }
    init(repeating scalar: UInt16) { fatalError() }
    init(repeating scalar: Int16) { fatalError() }
    init(repeating scalar: UInt32) { fatalError() }
    init(repeating scalar: Int32) { fatalError() }
    init(repeating scalar: UInt64) { fatalError() }
    init(repeating scalar: Int64) { fatalError() }
    init(repeating scalar: UInt) { fatalError() }
    init(repeating scalar: Int) { fatalError() }
    typealias MaskStorage = SIMD2<Scalar.SIMDMaskScalar>
    var scalarCount: Int { fatalError() }
    init() { fatalError() }
    subscript(index: Int) -> Scalar { fatalError() }
    init(_ v0: Scalar, _ v1: Scalar) { fatalError() }
    init(x: Scalar, y: Scalar) { fatalError() }
    var x: Scalar { fatalError() }
    var y: Scalar { fatalError() }
    typealias ArrayLiteralElement = Scalar
    var hashValue: Int { fatalError() }
    init<Other>(truncatingIfNeeded other: SIMD2<Other>)
    where Other: FixedWidthInteger, Other: SIMDScalar { fatalError() }
    init<Other>(clamping other: SIMD2<Other>) where Other: FixedWidthInteger, Other: SIMDScalar {
        fatalError()
    }
    init<Other>(_ other: SIMD2<Other>, rounding rule: FloatingPointRoundingRule = .towardZero)
    where Other: BinaryFloatingPoint, Other: SIMDScalar { fatalError() }
    var debugDescription: String { fatalError() }
    init<Other>(_ other: SIMD2<Other>) where Other: FixedWidthInteger, Other: SIMDScalar {
        fatalError()
    }
    init<Other>(_ other: SIMD2<Other>) where Other: BinaryFloatingPoint, Other: SIMDScalar {
        fatalError()
    }
}

@frozen struct SIMD3<Scalar> where Scalar: SIMDScalar {
    init(repeating scalar: Float) { fatalError() }
    static func .== (a: SIMD3<Scalar>, b: SIMD3<Scalar>) -> SIMDMask<SIMD3<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .== (a: SIMD3<Scalar>, b: Scalar) -> SIMDMask<SIMD3<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .== (a: Scalar, b: SIMD3<Scalar>) -> SIMDMask<SIMD3<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .!= (a: SIMD3<Scalar>, b: SIMD3<Scalar>) -> SIMDMask<SIMD3<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .!= (a: SIMD3<Scalar>, b: Scalar) -> SIMDMask<SIMD3<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .!= (a: Scalar, b: SIMD3<Scalar>) -> SIMDMask<SIMD3<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .< (a: SIMD3<Scalar>, b: SIMD3<Scalar>) -> SIMDMask<SIMD3<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .< (a: SIMD3<Scalar>, b: Scalar) -> SIMDMask<SIMD3<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .< (a: Scalar, b: SIMD3<Scalar>) -> SIMDMask<SIMD3<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .<= (a: SIMD3<Scalar>, b: SIMD3<Scalar>) -> SIMDMask<SIMD3<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .<= (a: SIMD3<Scalar>, b: Scalar) -> SIMDMask<SIMD3<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .<= (a: Scalar, b: SIMD3<Scalar>) -> SIMDMask<SIMD3<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .>= (a: SIMD3<Scalar>, b: SIMD3<Scalar>) -> SIMDMask<SIMD3<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .>= (a: SIMD3<Scalar>, b: Scalar) -> SIMDMask<SIMD3<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .>= (a: Scalar, b: SIMD3<Scalar>) -> SIMDMask<SIMD3<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .> (a: SIMD3<Scalar>, b: SIMD3<Scalar>) -> SIMDMask<SIMD3<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .> (a: SIMD3<Scalar>, b: Scalar) -> SIMDMask<SIMD3<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .> (a: Scalar, b: SIMD3<Scalar>) -> SIMDMask<SIMD3<Scalar>.MaskStorage> {
        fatalError()
    }
    init(repeating scalar: Double) { fatalError() }
    init(repeating scalar: UInt8) { fatalError() }
    static func &+ (a: SIMD3<Scalar>, b: SIMD3<Scalar>) -> SIMD3<Scalar> { fatalError() }
    static func &- (a: SIMD3<Scalar>, b: SIMD3<Scalar>) -> SIMD3<Scalar> { fatalError() }
    static func &* (a: SIMD3<Scalar>, b: SIMD3<Scalar>) -> SIMD3<Scalar> { fatalError() }
    static func &+= (a: inout SIMD3<Scalar>, b: SIMD3<Scalar>) { fatalError() }
    static func &-= (a: inout SIMD3<Scalar>, b: SIMD3<Scalar>) { fatalError() }
    static func &*= (a: inout SIMD3<Scalar>, b: SIMD3<Scalar>) { fatalError() }
    init(repeating scalar: Int8) { fatalError() }
    init(repeating scalar: UInt16) { fatalError() }
    init(repeating scalar: Int16) { fatalError() }
    init(repeating scalar: UInt32) { fatalError() }
    init(repeating scalar: Int32) { fatalError() }
    init(repeating scalar: UInt64) { fatalError() }
    init(repeating scalar: Int64) { fatalError() }
    init(repeating scalar: UInt) { fatalError() }
    init(repeating scalar: Int) { fatalError() }
    typealias MaskStorage = SIMD3<Scalar.SIMDMaskScalar>
    var scalarCount: Int { fatalError() }
    init() { fatalError() }
    subscript(index: Int) -> Scalar { fatalError() }
    init(_ v0: Scalar, _ v1: Scalar, _ v2: Scalar) { fatalError() }
    init(x: Scalar, y: Scalar, z: Scalar) { fatalError() }
    var x: Scalar { fatalError() }
    var y: Scalar { fatalError() }
    var z: Scalar { fatalError() }
    typealias ArrayLiteralElement = Scalar
    var hashValue: Int { fatalError() }
    init<Other>(truncatingIfNeeded other: SIMD3<Other>)
    where Other: FixedWidthInteger, Other: SIMDScalar { fatalError() }
    init<Other>(clamping other: SIMD3<Other>) where Other: FixedWidthInteger, Other: SIMDScalar {
        fatalError()
    }
    init<Other>(_ other: SIMD3<Other>, rounding rule: FloatingPointRoundingRule = .towardZero)
    where Other: BinaryFloatingPoint, Other: SIMDScalar { fatalError() }
    var debugDescription: String { fatalError() }
    init<Other>(_ other: SIMD3<Other>) where Other: FixedWidthInteger, Other: SIMDScalar {
        fatalError()
    }
    init<Other>(_ other: SIMD3<Other>) where Other: BinaryFloatingPoint, Other: SIMDScalar {
        fatalError()
    }
    init(_ xy: SIMD2<Scalar>, _ z: Scalar) { fatalError() }
}

@frozen struct SIMD32<Scalar> where Scalar: SIMDScalar {
    init(repeating scalar: Float) { fatalError() }
    init(lowHalf: SIMD16<Float>, highHalf: SIMD16<Float>) { fatalError() }
    static func .== (a: SIMD32<Scalar>, b: SIMD32<Scalar>) -> SIMDMask<SIMD32<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .== (a: SIMD32<Scalar>, b: Scalar) -> SIMDMask<SIMD32<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .== (a: Scalar, b: SIMD32<Scalar>) -> SIMDMask<SIMD32<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .!= (a: SIMD32<Scalar>, b: SIMD32<Scalar>) -> SIMDMask<SIMD32<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .!= (a: SIMD32<Scalar>, b: Scalar) -> SIMDMask<SIMD32<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .!= (a: Scalar, b: SIMD32<Scalar>) -> SIMDMask<SIMD32<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .< (a: SIMD32<Scalar>, b: SIMD32<Scalar>) -> SIMDMask<SIMD32<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .< (a: SIMD32<Scalar>, b: Scalar) -> SIMDMask<SIMD32<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .< (a: Scalar, b: SIMD32<Scalar>) -> SIMDMask<SIMD32<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .<= (a: SIMD32<Scalar>, b: SIMD32<Scalar>) -> SIMDMask<SIMD32<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .<= (a: SIMD32<Scalar>, b: Scalar) -> SIMDMask<SIMD32<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .<= (a: Scalar, b: SIMD32<Scalar>) -> SIMDMask<SIMD32<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .>= (a: SIMD32<Scalar>, b: SIMD32<Scalar>) -> SIMDMask<SIMD32<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .>= (a: SIMD32<Scalar>, b: Scalar) -> SIMDMask<SIMD32<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .>= (a: Scalar, b: SIMD32<Scalar>) -> SIMDMask<SIMD32<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .> (a: SIMD32<Scalar>, b: SIMD32<Scalar>) -> SIMDMask<SIMD32<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .> (a: SIMD32<Scalar>, b: Scalar) -> SIMDMask<SIMD32<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .> (a: Scalar, b: SIMD32<Scalar>) -> SIMDMask<SIMD32<Scalar>.MaskStorage> {
        fatalError()
    }
    init(repeating scalar: Double) { fatalError() }
    init(lowHalf: SIMD16<Double>, highHalf: SIMD16<Double>) { fatalError() }
    init(repeating scalar: UInt8) { fatalError() }
    init(lowHalf: SIMD16<UInt8>, highHalf: SIMD16<UInt8>) { fatalError() }
    static func &+ (a: SIMD32<Scalar>, b: SIMD32<Scalar>) -> SIMD32<Scalar> { fatalError() }
    static func &- (a: SIMD32<Scalar>, b: SIMD32<Scalar>) -> SIMD32<Scalar> { fatalError() }
    static func &* (a: SIMD32<Scalar>, b: SIMD32<Scalar>) -> SIMD32<Scalar> { fatalError() }
    static func &+= (a: inout SIMD32<Scalar>, b: SIMD32<Scalar>) { fatalError() }
    static func &-= (a: inout SIMD32<Scalar>, b: SIMD32<Scalar>) { fatalError() }
    static func &*= (a: inout SIMD32<Scalar>, b: SIMD32<Scalar>) { fatalError() }
    init(repeating scalar: Int8) { fatalError() }
    init(lowHalf: SIMD16<Int8>, highHalf: SIMD16<Int8>) { fatalError() }
    init(repeating scalar: UInt16) { fatalError() }
    init(lowHalf: SIMD16<UInt16>, highHalf: SIMD16<UInt16>) { fatalError() }
    init(repeating scalar: Int16) { fatalError() }
    init(lowHalf: SIMD16<Int16>, highHalf: SIMD16<Int16>) { fatalError() }
    init(repeating scalar: UInt32) { fatalError() }
    init(lowHalf: SIMD16<UInt32>, highHalf: SIMD16<UInt32>) { fatalError() }
    init(repeating scalar: Int32) { fatalError() }
    init(lowHalf: SIMD16<Int32>, highHalf: SIMD16<Int32>) { fatalError() }
    init(repeating scalar: UInt64) { fatalError() }
    init(lowHalf: SIMD16<UInt64>, highHalf: SIMD16<UInt64>) { fatalError() }
    init(repeating scalar: Int64) { fatalError() }
    init(lowHalf: SIMD16<Int64>, highHalf: SIMD16<Int64>) { fatalError() }
    init(repeating scalar: UInt) { fatalError() }
    init(lowHalf: SIMD16<UInt>, highHalf: SIMD16<UInt>) { fatalError() }
    init(repeating scalar: Int) { fatalError() }
    init(lowHalf: SIMD16<Int>, highHalf: SIMD16<Int>) { fatalError() }
    typealias MaskStorage = SIMD32<Scalar.SIMDMaskScalar>
    var scalarCount: Int { fatalError() }
    init() { fatalError() }
    subscript(index: Int) -> Scalar { fatalError() }
    init(
        _ v0: Scalar, _ v1: Scalar, _ v2: Scalar, _ v3: Scalar, _ v4: Scalar, _ v5: Scalar,
        _ v6: Scalar, _ v7: Scalar, _ v8: Scalar, _ v9: Scalar, _ v10: Scalar, _ v11: Scalar,
        _ v12: Scalar, _ v13: Scalar, _ v14: Scalar, _ v15: Scalar, _ v16: Scalar, _ v17: Scalar,
        _ v18: Scalar, _ v19: Scalar, _ v20: Scalar, _ v21: Scalar, _ v22: Scalar, _ v23: Scalar,
        _ v24: Scalar, _ v25: Scalar, _ v26: Scalar, _ v27: Scalar, _ v28: Scalar, _ v29: Scalar,
        _ v30: Scalar, _ v31: Scalar
    ) { fatalError() }
    init(lowHalf: SIMD16<Scalar>, highHalf: SIMD16<Scalar>) { fatalError() }
    var lowHalf: SIMD16<Scalar> { fatalError() }
    var highHalf: SIMD16<Scalar> { fatalError() }
    var evenHalf: SIMD16<Scalar> { fatalError() }
    var oddHalf: SIMD16<Scalar> { fatalError() }
    typealias ArrayLiteralElement = Scalar
    var hashValue: Int { fatalError() }
    init<Other>(truncatingIfNeeded other: SIMD32<Other>)
    where Other: FixedWidthInteger, Other: SIMDScalar { fatalError() }
    init<Other>(clamping other: SIMD32<Other>) where Other: FixedWidthInteger, Other: SIMDScalar {
        fatalError()
    }
    init<Other>(_ other: SIMD32<Other>, rounding rule: FloatingPointRoundingRule = .towardZero)
    where Other: BinaryFloatingPoint, Other: SIMDScalar { fatalError() }
    var debugDescription: String { fatalError() }
    init<Other>(_ other: SIMD32<Other>) where Other: FixedWidthInteger, Other: SIMDScalar {
        fatalError()
    }
    init<Other>(_ other: SIMD32<Other>) where Other: BinaryFloatingPoint, Other: SIMDScalar {
        fatalError()
    }
}

@frozen struct SIMD4<Scalar> where Scalar: SIMDScalar {
    init(repeating scalar: Float) { fatalError() }
    init(lowHalf: SIMD2<Float>, highHalf: SIMD2<Float>) { fatalError() }
    static func .== (a: SIMD4<Scalar>, b: SIMD4<Scalar>) -> SIMDMask<SIMD4<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .== (a: SIMD4<Scalar>, b: Scalar) -> SIMDMask<SIMD4<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .== (a: Scalar, b: SIMD4<Scalar>) -> SIMDMask<SIMD4<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .!= (a: SIMD4<Scalar>, b: SIMD4<Scalar>) -> SIMDMask<SIMD4<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .!= (a: SIMD4<Scalar>, b: Scalar) -> SIMDMask<SIMD4<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .!= (a: Scalar, b: SIMD4<Scalar>) -> SIMDMask<SIMD4<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .< (a: SIMD4<Scalar>, b: SIMD4<Scalar>) -> SIMDMask<SIMD4<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .< (a: SIMD4<Scalar>, b: Scalar) -> SIMDMask<SIMD4<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .< (a: Scalar, b: SIMD4<Scalar>) -> SIMDMask<SIMD4<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .<= (a: SIMD4<Scalar>, b: SIMD4<Scalar>) -> SIMDMask<SIMD4<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .<= (a: SIMD4<Scalar>, b: Scalar) -> SIMDMask<SIMD4<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .<= (a: Scalar, b: SIMD4<Scalar>) -> SIMDMask<SIMD4<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .>= (a: SIMD4<Scalar>, b: SIMD4<Scalar>) -> SIMDMask<SIMD4<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .>= (a: SIMD4<Scalar>, b: Scalar) -> SIMDMask<SIMD4<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .>= (a: Scalar, b: SIMD4<Scalar>) -> SIMDMask<SIMD4<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .> (a: SIMD4<Scalar>, b: SIMD4<Scalar>) -> SIMDMask<SIMD4<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .> (a: SIMD4<Scalar>, b: Scalar) -> SIMDMask<SIMD4<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .> (a: Scalar, b: SIMD4<Scalar>) -> SIMDMask<SIMD4<Scalar>.MaskStorage> {
        fatalError()
    }
    init(repeating scalar: Double) { fatalError() }
    init(lowHalf: SIMD2<Double>, highHalf: SIMD2<Double>) { fatalError() }
    init(repeating scalar: UInt8) { fatalError() }
    init(lowHalf: SIMD2<UInt8>, highHalf: SIMD2<UInt8>) { fatalError() }
    static func &+ (a: SIMD4<Scalar>, b: SIMD4<Scalar>) -> SIMD4<Scalar> { fatalError() }
    static func &- (a: SIMD4<Scalar>, b: SIMD4<Scalar>) -> SIMD4<Scalar> { fatalError() }
    static func &* (a: SIMD4<Scalar>, b: SIMD4<Scalar>) -> SIMD4<Scalar> { fatalError() }
    static func &+= (a: inout SIMD4<Scalar>, b: SIMD4<Scalar>) { fatalError() }
    static func &-= (a: inout SIMD4<Scalar>, b: SIMD4<Scalar>) { fatalError() }
    static func &*= (a: inout SIMD4<Scalar>, b: SIMD4<Scalar>) { fatalError() }
    init(repeating scalar: Int8) { fatalError() }
    init(lowHalf: SIMD2<Int8>, highHalf: SIMD2<Int8>) { fatalError() }
    init(repeating scalar: UInt16) { fatalError() }
    init(lowHalf: SIMD2<UInt16>, highHalf: SIMD2<UInt16>) { fatalError() }
    init(repeating scalar: Int16) { fatalError() }
    init(lowHalf: SIMD2<Int16>, highHalf: SIMD2<Int16>) { fatalError() }
    init(repeating scalar: UInt32) { fatalError() }
    init(lowHalf: SIMD2<UInt32>, highHalf: SIMD2<UInt32>) { fatalError() }
    init(repeating scalar: Int32) { fatalError() }
    init(lowHalf: SIMD2<Int32>, highHalf: SIMD2<Int32>) { fatalError() }
    init(repeating scalar: UInt64) { fatalError() }
    init(lowHalf: SIMD2<UInt64>, highHalf: SIMD2<UInt64>) { fatalError() }
    init(repeating scalar: Int64) { fatalError() }
    init(lowHalf: SIMD2<Int64>, highHalf: SIMD2<Int64>) { fatalError() }
    init(repeating scalar: UInt) { fatalError() }
    init(lowHalf: SIMD2<UInt>, highHalf: SIMD2<UInt>) { fatalError() }
    init(repeating scalar: Int) { fatalError() }
    init(lowHalf: SIMD2<Int>, highHalf: SIMD2<Int>) { fatalError() }
    typealias MaskStorage = SIMD4<Scalar.SIMDMaskScalar>
    var scalarCount: Int { fatalError() }
    init() { fatalError() }
    subscript(index: Int) -> Scalar { fatalError() }
    init(_ v0: Scalar, _ v1: Scalar, _ v2: Scalar, _ v3: Scalar) { fatalError() }
    init(x: Scalar, y: Scalar, z: Scalar, w: Scalar) { fatalError() }
    var x: Scalar { fatalError() }
    var y: Scalar { fatalError() }
    var z: Scalar { fatalError() }
    var w: Scalar { fatalError() }
    init(lowHalf: SIMD2<Scalar>, highHalf: SIMD2<Scalar>) { fatalError() }
    var lowHalf: SIMD2<Scalar> { fatalError() }
    var highHalf: SIMD2<Scalar> { fatalError() }
    var evenHalf: SIMD2<Scalar> { fatalError() }
    var oddHalf: SIMD2<Scalar> { fatalError() }
    typealias ArrayLiteralElement = Scalar
    var hashValue: Int { fatalError() }
    init<Other>(truncatingIfNeeded other: SIMD4<Other>)
    where Other: FixedWidthInteger, Other: SIMDScalar { fatalError() }
    init<Other>(clamping other: SIMD4<Other>) where Other: FixedWidthInteger, Other: SIMDScalar {
        fatalError()
    }
    init<Other>(_ other: SIMD4<Other>, rounding rule: FloatingPointRoundingRule = .towardZero)
    where Other: BinaryFloatingPoint, Other: SIMDScalar { fatalError() }
    var debugDescription: String { fatalError() }
    init<Other>(_ other: SIMD4<Other>) where Other: FixedWidthInteger, Other: SIMDScalar {
        fatalError()
    }
    init<Other>(_ other: SIMD4<Other>) where Other: BinaryFloatingPoint, Other: SIMDScalar {
        fatalError()
    }
    init(_ xyz: SIMD3<Scalar>, _ w: Scalar) { fatalError() }
}

@frozen struct SIMD64<Scalar> where Scalar: SIMDScalar {
    init(repeating scalar: Float) { fatalError() }
    init(lowHalf: SIMD32<Float>, highHalf: SIMD32<Float>) { fatalError() }
    static func .== (a: SIMD64<Scalar>, b: SIMD64<Scalar>) -> SIMDMask<SIMD64<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .== (a: SIMD64<Scalar>, b: Scalar) -> SIMDMask<SIMD64<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .== (a: Scalar, b: SIMD64<Scalar>) -> SIMDMask<SIMD64<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .!= (a: SIMD64<Scalar>, b: SIMD64<Scalar>) -> SIMDMask<SIMD64<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .!= (a: SIMD64<Scalar>, b: Scalar) -> SIMDMask<SIMD64<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .!= (a: Scalar, b: SIMD64<Scalar>) -> SIMDMask<SIMD64<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .< (a: SIMD64<Scalar>, b: SIMD64<Scalar>) -> SIMDMask<SIMD64<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .< (a: SIMD64<Scalar>, b: Scalar) -> SIMDMask<SIMD64<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .< (a: Scalar, b: SIMD64<Scalar>) -> SIMDMask<SIMD64<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .<= (a: SIMD64<Scalar>, b: SIMD64<Scalar>) -> SIMDMask<SIMD64<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .<= (a: SIMD64<Scalar>, b: Scalar) -> SIMDMask<SIMD64<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .<= (a: Scalar, b: SIMD64<Scalar>) -> SIMDMask<SIMD64<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .>= (a: SIMD64<Scalar>, b: SIMD64<Scalar>) -> SIMDMask<SIMD64<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .>= (a: SIMD64<Scalar>, b: Scalar) -> SIMDMask<SIMD64<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .>= (a: Scalar, b: SIMD64<Scalar>) -> SIMDMask<SIMD64<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .> (a: SIMD64<Scalar>, b: SIMD64<Scalar>) -> SIMDMask<SIMD64<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .> (a: SIMD64<Scalar>, b: Scalar) -> SIMDMask<SIMD64<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .> (a: Scalar, b: SIMD64<Scalar>) -> SIMDMask<SIMD64<Scalar>.MaskStorage> {
        fatalError()
    }
    init(repeating scalar: Double) { fatalError() }
    init(lowHalf: SIMD32<Double>, highHalf: SIMD32<Double>) { fatalError() }
    init(repeating scalar: UInt8) { fatalError() }
    init(lowHalf: SIMD32<UInt8>, highHalf: SIMD32<UInt8>) { fatalError() }
    static func &+ (a: SIMD64<Scalar>, b: SIMD64<Scalar>) -> SIMD64<Scalar> { fatalError() }
    static func &- (a: SIMD64<Scalar>, b: SIMD64<Scalar>) -> SIMD64<Scalar> { fatalError() }
    static func &* (a: SIMD64<Scalar>, b: SIMD64<Scalar>) -> SIMD64<Scalar> { fatalError() }
    static func &+= (a: inout SIMD64<Scalar>, b: SIMD64<Scalar>) { fatalError() }
    static func &-= (a: inout SIMD64<Scalar>, b: SIMD64<Scalar>) { fatalError() }
    static func &*= (a: inout SIMD64<Scalar>, b: SIMD64<Scalar>) { fatalError() }
    init(repeating scalar: Int8) { fatalError() }
    init(lowHalf: SIMD32<Int8>, highHalf: SIMD32<Int8>) { fatalError() }
    init(repeating scalar: UInt16) { fatalError() }
    init(lowHalf: SIMD32<UInt16>, highHalf: SIMD32<UInt16>) { fatalError() }
    init(repeating scalar: Int16) { fatalError() }
    init(lowHalf: SIMD32<Int16>, highHalf: SIMD32<Int16>) { fatalError() }
    init(repeating scalar: UInt32) { fatalError() }
    init(lowHalf: SIMD32<UInt32>, highHalf: SIMD32<UInt32>) { fatalError() }
    init(repeating scalar: Int32) { fatalError() }
    init(lowHalf: SIMD32<Int32>, highHalf: SIMD32<Int32>) { fatalError() }
    init(repeating scalar: UInt64) { fatalError() }
    init(lowHalf: SIMD32<UInt64>, highHalf: SIMD32<UInt64>) { fatalError() }
    init(repeating scalar: Int64) { fatalError() }
    init(lowHalf: SIMD32<Int64>, highHalf: SIMD32<Int64>) { fatalError() }
    init(repeating scalar: UInt) { fatalError() }
    init(lowHalf: SIMD32<UInt>, highHalf: SIMD32<UInt>) { fatalError() }
    init(repeating scalar: Int) { fatalError() }
    init(lowHalf: SIMD32<Int>, highHalf: SIMD32<Int>) { fatalError() }
    typealias MaskStorage = SIMD64<Scalar.SIMDMaskScalar>
    var scalarCount: Int { fatalError() }
    init() { fatalError() }
    subscript(index: Int) -> Scalar { fatalError() }
    init(
        _ v0: Scalar, _ v1: Scalar, _ v2: Scalar, _ v3: Scalar, _ v4: Scalar, _ v5: Scalar,
        _ v6: Scalar, _ v7: Scalar, _ v8: Scalar, _ v9: Scalar, _ v10: Scalar, _ v11: Scalar,
        _ v12: Scalar, _ v13: Scalar, _ v14: Scalar, _ v15: Scalar, _ v16: Scalar, _ v17: Scalar,
        _ v18: Scalar, _ v19: Scalar, _ v20: Scalar, _ v21: Scalar, _ v22: Scalar, _ v23: Scalar,
        _ v24: Scalar, _ v25: Scalar, _ v26: Scalar, _ v27: Scalar, _ v28: Scalar, _ v29: Scalar,
        _ v30: Scalar, _ v31: Scalar, _ v32: Scalar, _ v33: Scalar, _ v34: Scalar, _ v35: Scalar,
        _ v36: Scalar, _ v37: Scalar, _ v38: Scalar, _ v39: Scalar, _ v40: Scalar, _ v41: Scalar,
        _ v42: Scalar, _ v43: Scalar, _ v44: Scalar, _ v45: Scalar, _ v46: Scalar, _ v47: Scalar,
        _ v48: Scalar, _ v49: Scalar, _ v50: Scalar, _ v51: Scalar, _ v52: Scalar, _ v53: Scalar,
        _ v54: Scalar, _ v55: Scalar, _ v56: Scalar, _ v57: Scalar, _ v58: Scalar, _ v59: Scalar,
        _ v60: Scalar, _ v61: Scalar, _ v62: Scalar, _ v63: Scalar
    ) { fatalError() }
    init(lowHalf: SIMD32<Scalar>, highHalf: SIMD32<Scalar>) { fatalError() }
    var lowHalf: SIMD32<Scalar> { fatalError() }
    var highHalf: SIMD32<Scalar> { fatalError() }
    var evenHalf: SIMD32<Scalar> { fatalError() }
    var oddHalf: SIMD32<Scalar> { fatalError() }
    typealias ArrayLiteralElement = Scalar
    var hashValue: Int { fatalError() }
    init<Other>(truncatingIfNeeded other: SIMD64<Other>)
    where Other: FixedWidthInteger, Other: SIMDScalar { fatalError() }
    init<Other>(clamping other: SIMD64<Other>) where Other: FixedWidthInteger, Other: SIMDScalar {
        fatalError()
    }
    init<Other>(_ other: SIMD64<Other>, rounding rule: FloatingPointRoundingRule = .towardZero)
    where Other: BinaryFloatingPoint, Other: SIMDScalar { fatalError() }
    var debugDescription: String { fatalError() }
    init<Other>(_ other: SIMD64<Other>) where Other: FixedWidthInteger, Other: SIMDScalar {
        fatalError()
    }
    init<Other>(_ other: SIMD64<Other>) where Other: BinaryFloatingPoint, Other: SIMDScalar {
        fatalError()
    }
}

@frozen struct SIMD8<Scalar> where Scalar: SIMDScalar {
    init(repeating scalar: Float) { fatalError() }
    init(lowHalf: SIMD4<Float>, highHalf: SIMD4<Float>) { fatalError() }
    static func .== (a: SIMD8<Scalar>, b: SIMD8<Scalar>) -> SIMDMask<SIMD8<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .== (a: SIMD8<Scalar>, b: Scalar) -> SIMDMask<SIMD8<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .== (a: Scalar, b: SIMD8<Scalar>) -> SIMDMask<SIMD8<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .!= (a: SIMD8<Scalar>, b: SIMD8<Scalar>) -> SIMDMask<SIMD8<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .!= (a: SIMD8<Scalar>, b: Scalar) -> SIMDMask<SIMD8<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .!= (a: Scalar, b: SIMD8<Scalar>) -> SIMDMask<SIMD8<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .< (a: SIMD8<Scalar>, b: SIMD8<Scalar>) -> SIMDMask<SIMD8<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .< (a: SIMD8<Scalar>, b: Scalar) -> SIMDMask<SIMD8<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .< (a: Scalar, b: SIMD8<Scalar>) -> SIMDMask<SIMD8<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .<= (a: SIMD8<Scalar>, b: SIMD8<Scalar>) -> SIMDMask<SIMD8<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .<= (a: SIMD8<Scalar>, b: Scalar) -> SIMDMask<SIMD8<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .<= (a: Scalar, b: SIMD8<Scalar>) -> SIMDMask<SIMD8<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .>= (a: SIMD8<Scalar>, b: SIMD8<Scalar>) -> SIMDMask<SIMD8<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .>= (a: SIMD8<Scalar>, b: Scalar) -> SIMDMask<SIMD8<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .>= (a: Scalar, b: SIMD8<Scalar>) -> SIMDMask<SIMD8<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .> (a: SIMD8<Scalar>, b: SIMD8<Scalar>) -> SIMDMask<SIMD8<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .> (a: SIMD8<Scalar>, b: Scalar) -> SIMDMask<SIMD8<Scalar>.MaskStorage> {
        fatalError()
    }
    static func .> (a: Scalar, b: SIMD8<Scalar>) -> SIMDMask<SIMD8<Scalar>.MaskStorage> {
        fatalError()
    }
    init(repeating scalar: Double) { fatalError() }
    init(lowHalf: SIMD4<Double>, highHalf: SIMD4<Double>) { fatalError() }
    init(repeating scalar: UInt8) { fatalError() }
    init(lowHalf: SIMD4<UInt8>, highHalf: SIMD4<UInt8>) { fatalError() }
    static func &+ (a: SIMD8<Scalar>, b: SIMD8<Scalar>) -> SIMD8<Scalar> { fatalError() }
    static func &- (a: SIMD8<Scalar>, b: SIMD8<Scalar>) -> SIMD8<Scalar> { fatalError() }
    static func &* (a: SIMD8<Scalar>, b: SIMD8<Scalar>) -> SIMD8<Scalar> { fatalError() }
    static func &+= (a: inout SIMD8<Scalar>, b: SIMD8<Scalar>) { fatalError() }
    static func &-= (a: inout SIMD8<Scalar>, b: SIMD8<Scalar>) { fatalError() }
    static func &*= (a: inout SIMD8<Scalar>, b: SIMD8<Scalar>) { fatalError() }
    init(repeating scalar: Int8) { fatalError() }
    init(lowHalf: SIMD4<Int8>, highHalf: SIMD4<Int8>) { fatalError() }
    init(repeating scalar: UInt16) { fatalError() }
    init(lowHalf: SIMD4<UInt16>, highHalf: SIMD4<UInt16>) { fatalError() }
    init(repeating scalar: Int16) { fatalError() }
    init(lowHalf: SIMD4<Int16>, highHalf: SIMD4<Int16>) { fatalError() }
    init(repeating scalar: UInt32) { fatalError() }
    init(lowHalf: SIMD4<UInt32>, highHalf: SIMD4<UInt32>) { fatalError() }
    init(repeating scalar: Int32) { fatalError() }
    init(lowHalf: SIMD4<Int32>, highHalf: SIMD4<Int32>) { fatalError() }
    init(repeating scalar: UInt64) { fatalError() }
    init(lowHalf: SIMD4<UInt64>, highHalf: SIMD4<UInt64>) { fatalError() }
    init(repeating scalar: Int64) { fatalError() }
    init(lowHalf: SIMD4<Int64>, highHalf: SIMD4<Int64>) { fatalError() }
    init(repeating scalar: UInt) { fatalError() }
    init(lowHalf: SIMD4<UInt>, highHalf: SIMD4<UInt>) { fatalError() }
    init(repeating scalar: Int) { fatalError() }
    init(lowHalf: SIMD4<Int>, highHalf: SIMD4<Int>) { fatalError() }
    typealias MaskStorage = SIMD8<Scalar.SIMDMaskScalar>
    var scalarCount: Int { fatalError() }
    init() { fatalError() }
    subscript(index: Int) -> Scalar { fatalError() }
    init(
        _ v0: Scalar, _ v1: Scalar, _ v2: Scalar, _ v3: Scalar, _ v4: Scalar, _ v5: Scalar,
        _ v6: Scalar, _ v7: Scalar
    ) { fatalError() }
    init(lowHalf: SIMD4<Scalar>, highHalf: SIMD4<Scalar>) { fatalError() }
    var lowHalf: SIMD4<Scalar> { fatalError() }
    var highHalf: SIMD4<Scalar> { fatalError() }
    var evenHalf: SIMD4<Scalar> { fatalError() }
    var oddHalf: SIMD4<Scalar> { fatalError() }
    typealias ArrayLiteralElement = Scalar
    var hashValue: Int { fatalError() }
    init<Other>(truncatingIfNeeded other: SIMD8<Other>)
    where Other: FixedWidthInteger, Other: SIMDScalar { fatalError() }
    init<Other>(clamping other: SIMD8<Other>) where Other: FixedWidthInteger, Other: SIMDScalar {
        fatalError()
    }
    init<Other>(_ other: SIMD8<Other>, rounding rule: FloatingPointRoundingRule = .towardZero)
    where Other: BinaryFloatingPoint, Other: SIMDScalar { fatalError() }
    var debugDescription: String { fatalError() }
    init<Other>(_ other: SIMD8<Other>) where Other: FixedWidthInteger, Other: SIMDScalar {
        fatalError()
    }
    init<Other>(_ other: SIMD8<Other>) where Other: BinaryFloatingPoint, Other: SIMDScalar {
        fatalError()
    }
}

@frozen struct SIMDMask<Storage>
where Storage: SIMD, Storage.Scalar: FixedWidthInteger, Storage.Scalar: SignedInteger {
    typealias MaskStorage = Storage
    typealias Scalar = Bool
    init() { fatalError() }
    var scalarCount: Int { fatalError() }
    subscript(index: Int) -> Bool { fatalError() }
    typealias ArrayLiteralElement = SIMDMask<Storage>.Scalar
    var hashValue: Int { fatalError() }
    static func random<T>(using generator: inout T) -> SIMDMask<Storage>
    where T: RandomNumberGenerator { fatalError() }
    static func random() -> SIMDMask<Storage> { fatalError() }
    static func .! (a: SIMDMask<Storage>) -> SIMDMask<Storage> { fatalError() }
    static func .& (a: SIMDMask<Storage>, b: SIMDMask<Storage>) -> SIMDMask<Storage> {
        fatalError()
    }
    static func .^ (a: SIMDMask<Storage>, b: SIMDMask<Storage>) -> SIMDMask<Storage> {
        fatalError()
    }
    static func .| (a: SIMDMask<Storage>, b: SIMDMask<Storage>) -> SIMDMask<Storage> {
        fatalError()
    }
    static func .& (a: Bool, b: SIMDMask<Storage>) -> SIMDMask<Storage> { fatalError() }
    static func .^ (a: Bool, b: SIMDMask<Storage>) -> SIMDMask<Storage> { fatalError() }
    static func .| (a: Bool, b: SIMDMask<Storage>) -> SIMDMask<Storage> { fatalError() }
    static func .& (a: SIMDMask<Storage>, b: Bool) -> SIMDMask<Storage> { fatalError() }
    static func .^ (a: SIMDMask<Storage>, b: Bool) -> SIMDMask<Storage> { fatalError() }
    static func .| (a: SIMDMask<Storage>, b: Bool) -> SIMDMask<Storage> { fatalError() }
    static func .&= (a: inout SIMDMask<Storage>, b: SIMDMask<Storage>) { fatalError() }
    static func .^= (a: inout SIMDMask<Storage>, b: SIMDMask<Storage>) { fatalError() }
    static func .|= (a: inout SIMDMask<Storage>, b: SIMDMask<Storage>) { fatalError() }
    static func .&= (a: inout SIMDMask<Storage>, b: Bool) { fatalError() }
    static func .^= (a: inout SIMDMask<Storage>, b: Bool) { fatalError() }
    static func .|= (a: inout SIMDMask<Storage>, b: Bool) { fatalError() }
    init(repeating scalar: Bool) { fatalError() }
    static func .== (a: SIMDMask<Storage>, b: SIMDMask<Storage>) -> SIMDMask<Storage> {
        fatalError()
    }
    static func .!= (a: SIMDMask<Storage>, b: SIMDMask<Storage>) -> SIMDMask<Storage> {
        fatalError()
    }
    mutating func replace(with other: SIMDMask<Storage>, where mask: SIMDMask<Storage>) {
        fatalError()
    }
    func replacing(with other: SIMDMask<Storage>, where mask: SIMDMask<Storage>) -> SIMDMask<
        Storage
    > { fatalError() }
}

protocol SIMDScalar: BitwiseCopyable {
    associatedtype SIMDMaskScalar: FixedWidthInteger, SIMDScalar, SignedInteger
    where Self.SIMDMaskScalar == Self.SIMDMaskScalar.SIMDMaskScalar
    associatedtype SIMD2Storage: SIMDStorage
    where Self.SIMD2Storage.Scalar == Self.SIMD32Storage.Scalar
    associatedtype SIMD4Storage: SIMDStorage
    where Self.SIMD4Storage.Scalar == Self.SIMD64Storage.Scalar
    associatedtype SIMD8Storage: SIMDStorage
    associatedtype SIMD16Storage: SIMDStorage
    where Self == Self.SIMD16Storage.Scalar, Self.SIMD16Storage.Scalar == Self.SIMD2Storage.Scalar
    associatedtype SIMD32Storage: SIMDStorage
    where Self.SIMD32Storage.Scalar == Self.SIMD4Storage.Scalar
    associatedtype SIMD64Storage: SIMDStorage
    where Self.SIMD64Storage.Scalar == Self.SIMD8Storage.Scalar
}

protocol SIMDStorage {
    associatedtype Scalar: Decodable, Encodable, Hashable
    var scalarCount: Int { get }
    init()
    subscript(index: Int) -> Self.Scalar { get set }
    static var scalarCount: Int { get }
}

protocol Sendable: SendableMetatype {
}

protocol SendableMetatype: ~Copyable, ~Escapable {
}

protocol Sequence<Element> {
    @export(implementation) var underestimatedCount: Int { get }
    func makeBorrowingIterator() -> BorrowingIteratorAdapter<Self.Iterator>
    func shuffled<T>(using generator: inout T) -> [Self.Element] where T: RandomNumberGenerator
    func shuffled() -> [Self.Element]
    func joined() -> FlattenSequence<Self>
    func joined<Separator>(separator: Separator) -> JoinedSequence<Self>
    where Separator: Sequence, Separator.Element == Self.Element.Element
    var lazy: LazySequence<Self> { get }
    associatedtype Element where Self.Element == Self.Iterator.Element
    associatedtype Iterator: IteratorProtocol
    func makeIterator() -> Self.Iterator
    var underestimatedCount: Int { get }
    func withContiguousStorageIfAvailable<R>(
        _ body: (UnsafeBufferPointer<Self.Element>) throws -> R
    ) rethrows -> R?
    func makeIterator() -> Self
    func map<T, E>(_ transform: (Self.Element) throws(E) -> T) throws(E) -> [T] where E: Error
    func filter<E>(_ isIncluded: (Self.Element) throws(E) -> Bool) throws(E) -> [Self.Element]
    where E: Error
    func forEach(_ body: (Self.Element) throws -> Void) rethrows
    func first(where predicate: (Self.Element) throws -> Bool) rethrows -> Self.Element?
    func split(separator: Self.Element, maxSplits: Int, omittingEmptySubsequences: Bool)
        -> [ArraySlice<Self.Element>]
    func split(
        maxSplits: Int, omittingEmptySubsequences: Bool,
        whereSeparator isSeparator: (Self.Element) throws -> Bool
    ) rethrows -> [ArraySlice<Self.Element>]
    func suffix(_ maxLength: Int) -> [Self.Element]
    func dropFirst(_ k: Int) -> DropFirstSequence<Self>
    func dropLast(_ k: Int) -> [Self.Element]
    func drop(while predicate: (Self.Element) throws -> Bool) rethrows -> DropWhileSequence<Self>
    func prefix(_ maxLength: Int) -> PrefixSequence<Self>
    func prefix(while predicate: (Self.Element) throws -> Bool) rethrows -> [Self.Element]
    func enumerated() -> EnumeratedSequence<Self>
    @warn_unqualified_access func min(
        by areInIncreasingOrder: (Self.Element, Self.Element) throws -> Bool
    ) rethrows -> Self.Element?
    @warn_unqualified_access func max(
        by areInIncreasingOrder: (Self.Element, Self.Element) throws -> Bool
    ) rethrows -> Self.Element?
    @warn_unqualified_access func min() -> Self.Element?
    @warn_unqualified_access func max() -> Self.Element?
    func starts<PossiblePrefix>(
        with possiblePrefix: PossiblePrefix,
        by areEquivalent: (Self.Element, PossiblePrefix.Element) throws -> Bool
    ) rethrows -> Bool where PossiblePrefix: Sequence
    func starts<PossiblePrefix>(with possiblePrefix: PossiblePrefix) -> Bool
    where PossiblePrefix: Sequence, Self.Element == PossiblePrefix.Element
    func elementsEqual<OtherSequence>(
        _ other: OtherSequence,
        by areEquivalent: (Self.Element, OtherSequence.Element) throws -> Bool
    ) rethrows -> Bool where OtherSequence: Sequence
    func elementsEqual<OtherSequence>(_ other: OtherSequence) -> Bool
    where OtherSequence: Sequence, Self.Element == OtherSequence.Element
    func lexicographicallyPrecedes<OtherSequence>(
        _ other: OtherSequence, by areInIncreasingOrder: (Self.Element, Self.Element) throws -> Bool
    ) rethrows -> Bool where OtherSequence: Sequence, Self.Element == OtherSequence.Element
    func lexicographicallyPrecedes<OtherSequence>(_ other: OtherSequence) -> Bool
    where OtherSequence: Sequence, Self.Element == OtherSequence.Element
    func contains(where predicate: (Self.Element) throws -> Bool) rethrows -> Bool
    func allSatisfy(_ predicate: (Self.Element) throws -> Bool) rethrows -> Bool
    func contains(_ element: Self.Element) -> Bool
    func count<E>(where predicate: (Self.Element) throws(E) -> Bool) throws(E) -> Int where E: Error
    func reduce<Result>(
        _ initialResult: Result, _ nextPartialResult: (Result, Self.Element) throws -> Result
    ) rethrows -> Result
    func reduce<Result>(
        into initialResult: Result,
        _ updateAccumulatingResult: (inout Result, Self.Element) throws -> Void
    ) rethrows -> Result
    func reversed() -> [Self.Element]
    func flatMap<SegmentOfResult>(_ transform: (Self.Element) throws -> SegmentOfResult) rethrows
        -> [SegmentOfResult.Element] where SegmentOfResult: Sequence
    func compactMap<ElementOfResult>(_ transform: (Self.Element) throws -> ElementOfResult?)
        rethrows -> [ElementOfResult]
    func sorted() -> [Self.Element]
    func sorted(by areInIncreasingOrder: (Self.Element, Self.Element) throws -> Bool) rethrows
        -> [Self.Element]
    func joined(separator: String) -> String
    func flatMap<ElementOfResult>(_ transform: (Self.Element) throws -> ElementOfResult?) rethrows
        -> [ElementOfResult]
}

@frozen struct Set<Element> where Element: Hashable {
    func encode(to encoder: any Encoder) throws { fatalError() }
    init(from decoder: any Decoder) throws { fatalError() }
    init(minimumCapacity: Int) { fatalError() }
    init(arrayLiteral elements: Element...) { fatalError() }
    typealias ArrayLiteralElement = Element
    func makeIterator() -> Set<Element>.Iterator { fatalError() }
    func contains(_ member: Element) -> Bool { fatalError() }
    consuming func filter<E>(_ isIncluded: (Element) throws(E) -> Bool) throws(E) -> Set<Element>
    where E: Error { fatalError() }
    var startIndex: Set<Element>.Index { fatalError() }
    var endIndex: Set<Element>.Index { fatalError() }
    subscript(position: Set<Element>.Index) -> Element { fatalError() }
    func index(after i: Set<Element>.Index) -> Set<Element>.Index { fatalError() }
    func formIndex(after i: inout Set<Element>.Index) { fatalError() }
    func firstIndex(of member: Element) -> Set<Element>.Index? { fatalError() }
    var count: Int { fatalError() }
    var isEmpty: Bool { fatalError() }
    typealias Indices = DefaultIndices<Set<Element>>
    typealias SubSequence = Slice<Set<Element>>
    static func == (lhs: Set<Element>, rhs: Set<Element>) -> Bool { fatalError() }
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    @discardableResult mutating func insert(_ newMember: Element) -> (
        inserted: Bool, memberAfterInsert: Element
    ) { fatalError() }
    @discardableResult mutating func update(with newMember: Element) -> Element? { fatalError() }
    @discardableResult mutating func remove(_ member: Element) -> Element? { fatalError() }
    @discardableResult mutating func remove(at position: Set<Element>.Index) -> Element {
        fatalError()
    }
    mutating func removeAll(keepingCapacity keepCapacity: Bool = false) { fatalError() }
    @discardableResult mutating func removeFirst() -> Element { fatalError() }
    init() { fatalError() }
    init<Source>(_ sequence: Source) where Element == Source.Element, Source: Sequence {
        fatalError()
    }
    func isSubset<S>(of possibleSuperset: S) -> Bool where Element == S.Element, S: Sequence {
        fatalError()
    }
    func isStrictSubset<S>(of possibleStrictSuperset: S) -> Bool
    where Element == S.Element, S: Sequence { fatalError() }
    func isSuperset<S>(of possibleSubset: S) -> Bool where Element == S.Element, S: Sequence {
        fatalError()
    }
    func isStrictSuperset<S>(of possibleStrictSubset: S) -> Bool
    where Element == S.Element, S: Sequence { fatalError() }
    func isDisjoint<S>(with other: S) -> Bool where Element == S.Element, S: Sequence {
        fatalError()
    }
    func union<S>(_ other: S) -> Set<Element> where Element == S.Element, S: Sequence {
        fatalError()
    }
    mutating func formUnion<S>(_ other: S) where Element == S.Element, S: Sequence { fatalError() }
    func subtracting<S>(_ other: S) -> Set<Element> where Element == S.Element, S: Sequence {
        fatalError()
    }
    mutating func subtract<S>(_ other: S) where Element == S.Element, S: Sequence { fatalError() }
    func intersection<S>(_ other: S) -> Set<Element> where Element == S.Element, S: Sequence {
        fatalError()
    }
    mutating func formIntersection<S>(_ other: S) where Element == S.Element, S: Sequence {
        fatalError()
    }
    func symmetricDifference<S>(_ other: S) -> Set<Element>
    where Element == S.Element, S: Sequence { fatalError() }
    mutating func formSymmetricDifference<S>(_ other: S) where Element == S.Element, S: Sequence {
        fatalError()
    }
    var description: String { fatalError() }
    var debugDescription: String { fatalError() }
    mutating func subtract(_ other: Set<Element>) { fatalError() }
    func isSubset(of other: Set<Element>) -> Bool { fatalError() }
    func isSuperset(of other: Set<Element>) -> Bool { fatalError() }
    func isDisjoint(with other: Set<Element>) -> Bool { fatalError() }
    func subtracting(_ other: Set<Element>) -> Set<Element> { fatalError() }
    func isStrictSuperset(of other: Set<Element>) -> Bool { fatalError() }
    func isStrictSubset(of other: Set<Element>) -> Bool { fatalError() }
    func intersection(_ other: Set<Element>) -> Set<Element> { fatalError() }
    mutating func formSymmetricDifference(_ other: Set<Element>) { fatalError() }
    var customMirror: Mirror { fatalError() }
    mutating func popFirst() -> Element? { fatalError() }
    var capacity: Int { fatalError() }
    mutating func reserveCapacity(_ minimumCapacity: Int) { fatalError() }
    func isTriviallyIdentical(to other: Set<Element>) -> Bool { fatalError() }
    @discardableResult mutating func insert<ConcreteElement>(_ newMember: ConcreteElement) -> (
        inserted: Bool, memberAfterInsert: ConcreteElement
    ) where ConcreteElement: Hashable { fatalError() }
    @discardableResult mutating func update<ConcreteElement>(with newMember: ConcreteElement)
        -> ConcreteElement? where ConcreteElement: Hashable
    { fatalError() }
    @discardableResult mutating func remove<ConcreteElement>(_ member: ConcreteElement)
        -> ConcreteElement? where ConcreteElement: Hashable
    { fatalError() }
    @frozen struct Index {
        static func == (lhs: Set<Element>.Index, rhs: Set<Element>.Index) -> Bool { fatalError() }
        static func < (lhs: Set<Element>.Index, rhs: Set<Element>.Index) -> Bool { fatalError() }
        func hash(into hasher: inout Hasher) { fatalError() }
        var hashValue: Int { fatalError() }
    }
    @frozen struct Iterator {
        mutating func next() -> Element? { fatalError() }
        var customMirror: Mirror { fatalError() }
    }
}

protocol SetAlgebra<Element>: Equatable, ExpressibleByArrayLiteral {
    associatedtype Element
    init()
    func contains(_ member: Self.Element) -> Bool
    func union(_ other: Self) -> Self
    func intersection(_ other: Self) -> Self
    func symmetricDifference(_ other: Self) -> Self
    @discardableResult mutating func insert(_ newMember: Self.Element) -> (
        inserted: Bool, memberAfterInsert: Self.Element
    )
    @discardableResult mutating func remove(_ member: Self.Element) -> Self.Element?
    @discardableResult mutating func update(with newMember: Self.Element) -> Self.Element?
    mutating func formUnion(_ other: Self)
    mutating func formIntersection(_ other: Self)
    mutating func formSymmetricDifference(_ other: Self)
    func subtracting(_ other: Self) -> Self
    func isSubset(of other: Self) -> Bool
    func isDisjoint(with other: Self) -> Bool
    func isSuperset(of other: Self) -> Bool
    var isEmpty: Bool { get }
    init<S>(_ sequence: S) where S: Sequence, Self.Element == S.Element
    mutating func subtract(_ other: Self)
    func isStrictSuperset(of other: Self) -> Bool
    func isStrictSubset(of other: Self) -> Bool
    init(arrayLiteral: Self.Element...)
}

protocol SignedInteger: BinaryInteger, SignedNumeric {
    static var isSigned: Bool { get }
    init<T>(_ source: T) where T: BinaryInteger
    init?<T>(exactly source: T) where T: BinaryInteger
    static var max: Self { get }
    static var min: Self { get }
    func isMultiple(of other: Self) -> Bool
    func dividingFullWidth(_ dividend: (high: Self, low: Self.Magnitude)) -> (
        quotient: Self, remainder: Self
    )
}

protocol SignedNumeric: Numeric {
    static func - (operand: Self) -> Self
    mutating func negate()
}

protocol SingleValueDecodingContainer {
    var codingPath: [any CodingKey] { get }
    func decodeNil() -> Bool
    func decode(_ type: Bool.Type) throws -> Bool
    func decode(_ type: String.Type) throws -> String
    func decode(_ type: Double.Type) throws -> Double
    func decode(_ type: Float.Type) throws -> Float
    func decode(_ type: Int.Type) throws -> Int
    func decode(_ type: Int8.Type) throws -> Int8
    func decode(_ type: Int16.Type) throws -> Int16
    func decode(_ type: Int32.Type) throws -> Int32
    func decode(_ type: Int64.Type) throws -> Int64
    func decode(_ type: Int128.Type) throws -> Int128
    func decode(_ type: UInt.Type) throws -> UInt
    func decode(_ type: UInt8.Type) throws -> UInt8
    func decode(_ type: UInt16.Type) throws -> UInt16
    func decode(_ type: UInt32.Type) throws -> UInt32
    func decode(_ type: UInt64.Type) throws -> UInt64
    func decode(_ type: UInt128.Type) throws -> UInt128
    func decode<T>(_ type: T.Type) throws -> T where T: Decodable
}

protocol SingleValueEncodingContainer {
    var codingPath: [any CodingKey] { get }
    mutating func encodeNil() throws
    mutating func encode(_ value: Bool) throws
    mutating func encode(_ value: String) throws
    mutating func encode(_ value: Double) throws
    mutating func encode(_ value: Float) throws
    mutating func encode(_ value: Int) throws
    mutating func encode(_ value: Int8) throws
    mutating func encode(_ value: Int16) throws
    mutating func encode(_ value: Int32) throws
    mutating func encode(_ value: Int64) throws
    mutating func encode(_ value: Int128) throws
    mutating func encode(_ value: UInt) throws
    mutating func encode(_ value: UInt8) throws
    mutating func encode(_ value: UInt16) throws
    mutating func encode(_ value: UInt32) throws
    mutating func encode(_ value: UInt64) throws
    mutating func encode(_ value: UInt128) throws
    mutating func encode<T>(_ value: T) throws where T: Encodable
}

@frozen struct Slice<Base> where Base: Collection {
    typealias Elements = Slice<Base>
    init(base: Base, bounds: Range<Base.Index>) { fatalError() }
    var base: Base { fatalError() }
    typealias Index = Base.Index
    typealias Indices = Base.Indices
    typealias Element = Base.Element
    typealias SubSequence = Slice<Base>
    typealias Iterator = IndexingIterator<Slice<Base>>
    var startIndex: Slice<Base>.Index { fatalError() }
    var endIndex: Slice<Base>.Index { fatalError() }
    subscript(index: Slice<Base>.Index) -> Base.Element { fatalError() }
    subscript(bounds: Range<Slice<Base>.Index>) -> Slice<Base> { fatalError() }
    var indices: Slice<Base>.Indices { fatalError() }
    func index(after i: Slice<Base>.Index) -> Slice<Base>.Index { fatalError() }
    func formIndex(after i: inout Slice<Base>.Index) { fatalError() }
    func index(_ i: Slice<Base>.Index, offsetBy n: Int) -> Slice<Base>.Index { fatalError() }
    func index(_ i: Slice<Base>.Index, offsetBy n: Int, limitedBy limit: Slice<Base>.Index)
        -> Slice<Base>.Index?
    { fatalError() }
    func distance(from start: Slice<Base>.Index, to end: Slice<Base>.Index) -> Int { fatalError() }
    func withContiguousStorageIfAvailable<R>(
        _ body: (UnsafeBufferPointer<Slice<Base>.Element>) throws -> R
    ) rethrows -> R? { fatalError() }
    func index(before i: Slice<Base>.Index) -> Slice<Base>.Index { fatalError() }
    func formIndex(before i: inout Slice<Base>.Index) { fatalError() }
    mutating func withContiguousMutableStorageIfAvailable<R>(
        _ body: (inout UnsafeMutableBufferPointer<Slice<Base>.Element>) throws -> R
    ) rethrows -> R? { fatalError() }
    init() { fatalError() }
    init(repeating repeatedValue: Base.Element, count: Int) { fatalError() }
    init<S>(_ elements: S) where S: Sequence, Base.Element == S.Element { fatalError() }
    mutating func replaceSubrange<C>(_ subRange: Range<Slice<Base>.Index>, with newElements: C)
    where C: Collection, Base.Element == C.Element { fatalError() }
    mutating func insert(_ newElement: Base.Element, at i: Slice<Base>.Index) { fatalError() }
    mutating func insert<S>(contentsOf newElements: S, at i: Slice<Base>.Index)
    where S: Collection, Base.Element == S.Element { fatalError() }
    mutating func remove(at i: Slice<Base>.Index) -> Base.Element { fatalError() }
    mutating func removeSubrange(_ bounds: Range<Slice<Base>.Index>) { fatalError() }
    func copyBytes<C>(from source: C) where C: Collection, C.Element == UInt8 { fatalError() }
    @discardableResult func initializeMemory<T>(as type: T.Type, repeating repeatedValue: T)
        -> UnsafeMutableBufferPointer<T>
    { fatalError() }
    func initializeMemory<S>(as type: S.Element.Type, from source: S) -> (
        unwritten: S.Iterator, initialized: UnsafeMutableBufferPointer<S.Element>
    ) where S: Sequence { fatalError() }
    func initializeMemory<C>(as type: C.Element.Type, fromContentsOf source: C)
        -> UnsafeMutableBufferPointer<C.Element> where C: Collection
    { fatalError() }
    @discardableResult func moveInitializeMemory<T>(
        as type: T.Type, fromContentsOf source: UnsafeMutableBufferPointer<T>
    ) -> UnsafeMutableBufferPointer<T> where T: ~Copyable { fatalError() }
    @discardableResult func moveInitializeMemory<T>(
        as type: T.Type, fromContentsOf source: Slice<UnsafeMutableBufferPointer<T>>
    ) -> UnsafeMutableBufferPointer<T> { fatalError() }
    @discardableResult func bindMemory<T>(to type: T.Type) -> UnsafeMutableBufferPointer<T>
    where T: ~Copyable { fatalError() }
    func withMemoryRebound<T, E, Result>(
        to type: T.Type, _ body: (UnsafeMutableBufferPointer<T>) throws(E) -> Result
    ) throws(E) -> Result where E: Error, T: ~Copyable, Result: ~Copyable { fatalError() }
    func assumingMemoryBound<T>(to type: T.Type) -> UnsafeMutableBufferPointer<T>
    where T: ~Copyable { fatalError() }
    func load<T>(fromByteOffset offset: Int = 0, as type: T.Type) -> T { fatalError() }
    func loadUnaligned<T>(fromByteOffset offset: Int = 0, as type: T.Type) -> T
    where T: BitwiseCopyable { fatalError() }
    func loadUnaligned<T>(fromByteOffset offset: Int = 0, as type: T.Type) -> T { fatalError() }
    func storeBytes<T>(of value: T, toByteOffset offset: Int = 0, as type: T.Type) { fatalError() }
    @discardableResult func bindMemory<T>(to type: T.Type) -> UnsafeBufferPointer<T>
    where T: ~Copyable { fatalError() }
    func withMemoryRebound<T, E, Result>(
        to type: T.Type, _ body: (UnsafeBufferPointer<T>) throws(E) -> Result
    ) throws(E) -> Result where E: Error, T: ~Copyable, Result: ~Copyable { fatalError() }
    func assumingMemoryBound<T>(to type: T.Type) -> UnsafeBufferPointer<T> where T: ~Copyable {
        fatalError()
    }
    func withMemoryRebound<T, E, Result, Element>(
        to type: T.Type, _ body: (UnsafeBufferPointer<T>) throws(E) -> Result
    ) throws(E) -> Result
    where Base == UnsafeBufferPointer<Element>, E: Error, T: ~Copyable, Result: ~Copyable {
        fatalError()
    }
    func initialize<Element>(repeating repeatedValue: Element)
    where Base == UnsafeMutableBufferPointer<Element> { fatalError() }
    func initialize<S>(from source: S) -> (unwritten: S.Iterator, index: Slice<Base>.Index)
    where Base == UnsafeMutableBufferPointer<S.Element>, S: Sequence { fatalError() }
    func initialize<Element>(fromContentsOf source: some Collection) -> Slice<Base>.Index
    where Base == UnsafeMutableBufferPointer<Element> { fatalError() }
    func update<Element>(repeating repeatedValue: Element)
    where Base == UnsafeMutableBufferPointer<Element> { fatalError() }
    func update<S>(from source: S) -> (unwritten: S.Iterator, index: Slice<Base>.Index)
    where Base == UnsafeMutableBufferPointer<S.Element>, S: Sequence { fatalError() }
    func update<Element>(fromContentsOf source: some Collection) -> Slice<Base>.Index
    where Base == UnsafeMutableBufferPointer<Element> { fatalError() }
    func moveInitialize<Element>(fromContentsOf source: UnsafeMutableBufferPointer<Element>)
        -> Slice<Base>.Index where Base == UnsafeMutableBufferPointer<Element>
    { fatalError() }
    func moveInitialize<Element>(fromContentsOf source: Slice<UnsafeMutableBufferPointer<Element>>)
        -> Slice<Base>.Index where Base == UnsafeMutableBufferPointer<Element>
    { fatalError() }
    func moveUpdate<Element>(fromContentsOf source: UnsafeMutableBufferPointer<Element>)
        -> Slice<Base>.Index where Base == UnsafeMutableBufferPointer<Element>
    { fatalError() }
    func moveUpdate<Element>(fromContentsOf source: Slice<UnsafeMutableBufferPointer<Element>>)
        -> Slice<Base>.Index where Base == UnsafeMutableBufferPointer<Element>
    { fatalError() }
    @discardableResult func deinitialize<Element>() -> UnsafeMutableRawBufferPointer
    where Base == UnsafeMutableBufferPointer<Element> { fatalError() }
    func initializeElement<Element>(at index: Int, to value: Element)
    where Base == UnsafeMutableBufferPointer<Element> { fatalError() }
    func moveElement<Element>(from index: Slice<Base>.Index) -> Element
    where Base == UnsafeMutableBufferPointer<Element> { fatalError() }
    func deinitializeElement<Element>(at index: UnsafeMutableBufferPointer<Element>.Index)
    where Base == UnsafeMutableBufferPointer<Element> { fatalError() }
    func withMemoryRebound<T, E, Result, Element>(
        to type: T.Type, _ body: (UnsafeMutableBufferPointer<T>) throws(E) -> Result
    ) throws(E) -> Result
    where Base == UnsafeMutableBufferPointer<Element>, E: Error, T: ~Copyable, Result: ~Copyable {
        fatalError()
    }
    func withContiguousMutableStorageIfAvailable<R, Element>(
        _ body: (inout UnsafeMutableBufferPointer<Element>) throws -> R
    ) rethrows -> R? where Base == UnsafeMutableBufferPointer<Element> { fatalError() }
}

@frozen struct Span<Element> where Element: ~Copyable {
    init() { fatalError() }
    init(viewing bytes: RawSpan) where Element: ConvertibleFromBytes { fatalError() }
    var count: Int { fatalError() }
    var isEmpty: Bool { fatalError() }
    typealias Index = Int
    var indices: Range<Span<Element>.Index> { fatalError() }
    subscript(position: Span<Element>.Index) -> Element { fatalError() }
    subscript(unchecked position: Span<Element>.Index) -> Element { fatalError() }
    var bytes: RawSpan { fatalError() }
    func extracting(_ bounds: Range<Span<Element>.Index>) -> Span<Element> { fatalError() }
    func extracting(unchecked bounds: Range<Span<Element>.Index>) -> Span<Element> { fatalError() }
    func extracting(_ bounds: some RangeExpression<Int>) -> Span<Element> { fatalError() }
    func extracting(unchecked bounds: ClosedRange<Span<Element>.Index>) -> Span<Element> {
        fatalError()
    }
    func extracting(_: UnboundedRange) -> Span<Element> { fatalError() }
    func withUnsafeBufferPointer<E, Result>(
        _ body: (UnsafeBufferPointer<Element>) throws(E) -> Result
    ) throws(E) -> Result where E: Error, Result: ~Copyable { fatalError() }
    func withUnsafeBytes<E, Result>(_ body: (UnsafeRawBufferPointer) throws(E) -> Result) throws(E)
        -> Result where E: Error, Result: ~Copyable
    { fatalError() }
    func isIdentical(to other: Span<Element>) -> Bool { fatalError() }
    func isTriviallyIdentical(to other: Span<Element>) -> Bool { fatalError() }
    func indices(of other: borrowing Span<Element>) -> Range<Span<Element>.Index>? { fatalError() }
    func extracting(first maxLength: Int) -> Span<Element> { fatalError() }
    func extracting(droppingLast k: Int) -> Span<Element> { fatalError() }
    func extracting(last maxLength: Int) -> Span<Element> { fatalError() }
    func extracting(droppingFirst k: Int) -> Span<Element> { fatalError() }
    init(viewing bytes: RawSpan) { fatalError() }
    typealias Failure = Never
    @export(implementation) var underestimatedCount: Int { fatalError() }
    @export(implementation) func makeBorrowingIterator() -> Span<Element>.BorrowingIterator {
        fatalError()
    }
    @frozen struct BorrowingIterator {
        typealias Failure = Never
        init(_ elements: Span<Element>) { fatalError() }
        @export(implementation) mutating func nextSpan(maxCount: Int) -> Span<Element> {
            fatalError()
        }
        @export(implementation) mutating func skip(by offset: Int) -> Int { fatalError() }
    }
}

@frozen struct StaticBigInt {
    typealias IntegerLiteralType = StaticBigInt
    func signum() -> Int { fatalError() }
    var bitWidth: Int { fatalError() }
    subscript(wordIndex: Int) -> UInt { fatalError() }
    var debugDescription: String { fatalError() }
    var customMirror: Mirror { fatalError() }
}

@frozen struct StaticString {
    init() { fatalError() }
    var utf8Start: UnsafePointer<UInt8> { fatalError() }
    var unicodeScalar: Unicode.Scalar { fatalError() }
    var utf8CodeUnitCount: Int { fatalError() }
    var hasPointerRepresentation: Bool { fatalError() }
    var isASCII: Bool { fatalError() }
    func withUTF8Buffer<R>(_ body: (UnsafeBufferPointer<UInt8>) -> R) -> R { fatalError() }
    init(unicodeScalarLiteral value: StaticString) { fatalError() }
    typealias UnicodeScalarLiteralType = StaticString
    init(extendedGraphemeClusterLiteral value: StaticString) { fatalError() }
    typealias ExtendedGraphemeClusterLiteralType = StaticString
    init(stringLiteral value: StaticString) { fatalError() }
    typealias StringLiteralType = StaticString
    var description: String { fatalError() }
    var debugDescription: String { fatalError() }
    var customMirror: Mirror { fatalError() }
}

@frozen struct StrideThrough<Element> where Element: Strideable {
    func makeIterator() -> StrideThroughIterator<Element> { fatalError() }
    var underestimatedCount: Int { fatalError() }
    typealias Iterator = StrideThroughIterator<Element>
    var customMirror: Mirror { fatalError() }
}

@frozen struct StrideThroughIterator<Element> where Element: Strideable {
    mutating func next() -> Element? { fatalError() }
}

@frozen struct StrideTo<Element> where Element: Strideable {
    func makeIterator() -> StrideToIterator<Element> { fatalError() }
    var underestimatedCount: Int { fatalError() }
    typealias Iterator = StrideToIterator<Element>
    var customMirror: Mirror { fatalError() }
}

@frozen struct StrideToIterator<Element> where Element: Strideable {
    mutating func next() -> Element? { fatalError() }
}

protocol Strideable<Stride>: Comparable {
    static func + (lhs: Self, rhs: Self.Stride) -> Self
    static func + (lhs: Self.Stride, rhs: Self) -> Self
    static func - (lhs: Self, rhs: Self.Stride) -> Self
    static func - (lhs: Self, rhs: Self) -> Self.Stride
    static func += (lhs: inout Self, rhs: Self.Stride)
    static func -= (lhs: inout Self, rhs: Self.Stride)
    associatedtype Stride: Comparable, SignedNumeric
    func distance(to other: Self) -> Self.Stride
    func advanced(by n: Self.Stride) -> Self
    static func < (x: Self, y: Self) -> Bool
    static func == (x: Self, y: Self) -> Bool
}

@frozen struct String {
    init(_ c: Character) { fatalError() }
    init(from decoder: any Decoder) throws { fatalError() }
    func encode(to encoder: any Encoder) throws { fatalError() }
    var codingKey: any CodingKey { fatalError() }
    init?<T>(codingKey: T) where T: CodingKey { fatalError() }
    init(cString nullTerminatedUTF8: UnsafePointer<CChar>) { fatalError() }
    init(cString nullTerminatedUTF8: [CChar]) { fatalError() }
    init(cString nullTerminatedUTF8: inout CChar) { fatalError() }
    init(cString nullTerminatedUTF8: UnsafePointer<UInt8>) { fatalError() }
    init(cString nullTerminatedUTF8: [UInt8]) { fatalError() }
    init(cString nullTerminatedUTF8: String) { fatalError() }
    init(cString nullTerminatedUTF8: inout UInt8) { fatalError() }
    init?(validatingCString nullTerminatedUTF8: UnsafePointer<CChar>) { fatalError() }
    init?(validatingUTF8 cString: UnsafePointer<CChar>) { fatalError() }
    init?(validatingCString nullTerminatedUTF8: [CChar]) { fatalError() }
    init?(validatingUTF8 cString: [CChar]) { fatalError() }
    init?(validatingCString nullTerminatedUTF8: String) { fatalError() }
    init?(validatingUTF8 cString: String) { fatalError() }
    init?(validatingCString nullTerminatedUTF8: inout CChar) { fatalError() }
    init?(validatingUTF8 cString: inout CChar) { fatalError() }
    static func decodeCString<Encoding>(
        _ cString: UnsafePointer<Encoding.CodeUnit>?, as encoding: Encoding.Type,
        repairingInvalidCodeUnits isRepairing: Bool = true
    ) -> (result: String, repairsMade: Bool)? where Encoding: _UnicodeEncoding { fatalError() }
    static func decodeCString<Encoding>(
        _ cString: [Encoding.CodeUnit], as encoding: Encoding.Type,
        repairingInvalidCodeUnits isRepairing: Bool = true
    ) -> (result: String, repairsMade: Bool)? where Encoding: _UnicodeEncoding { fatalError() }
    static func decodeCString<Encoding>(
        _ cString: String, as encoding: Encoding.Type,
        repairingInvalidCodeUnits isRepairing: Bool = true
    ) -> (result: String, repairsMade: Bool)? where Encoding: _UnicodeEncoding { fatalError() }
    static func decodeCString<Encoding>(
        _ cString: inout Encoding.CodeUnit, as encoding: Encoding.Type,
        repairingInvalidCodeUnits isRepairing: Bool = true
    ) -> (result: String, repairsMade: Bool)? where Encoding: _UnicodeEncoding { fatalError() }
    init<Encoding>(
        decodingCString nullTerminatedCodeUnits: UnsafePointer<Encoding.CodeUnit>,
        as encoding: Encoding.Type
    ) where Encoding: _UnicodeEncoding { fatalError() }
    init<Encoding>(
        decodingCString nullTerminatedCodeUnits: [Encoding.CodeUnit], as encoding: Encoding.Type
    ) where Encoding: _UnicodeEncoding { fatalError() }
    init<Encoding>(decodingCString nullTerminatedCodeUnits: String, as encoding: Encoding.Type)
    where Encoding: _UnicodeEncoding { fatalError() }
    init<Encoding>(
        decodingCString nullTerminatedCodeUnits: inout Encoding.CodeUnit, as encoding: Encoding.Type
    ) where Encoding: _UnicodeEncoding { fatalError() }
    var customMirror: Mirror { fatalError() }
    var customPlaygroundQuickLook: _PlaygroundQuickLook { fatalError() }
    mutating func write(_ other: String) { fatalError() }
    func write<Target>(to target: inout Target) where Target: TextOutputStream { fatalError() }
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    init() { fatalError() }
    init<C, Encoding>(decoding codeUnits: C, as sourceEncoding: Encoding.Type)
    where C: Collection, Encoding: _UnicodeEncoding, C.Element == Encoding.CodeUnit { fatalError() }
    init?<Encoding>(validating codeUnits: some Sequence, as encoding: Encoding.Type)
    where Encoding: _UnicodeEncoding { fatalError() }
    init?<Encoding>(validating codeUnits: some Sequence<Int8>, as encoding: Encoding.Type)
    where Encoding: _UnicodeEncoding, Encoding.CodeUnit == UInt8 { fatalError() }
    init<E>(
        unsafeUninitializedCapacity capacity: Int,
        initializingUTF8With initializer: (UnsafeMutableBufferPointer<UInt8>) throws(E) -> Int
    ) throws(E) where E: Error { fatalError() }
    func withCString<Result, E>(_ body: (UnsafePointer<Int8>) throws(E) -> Result) throws(E)
        -> Result where E: Error
    { fatalError() }
    func withCString<Result, TargetEncoding, E>(
        encodedAs targetEncoding: TargetEncoding.Type,
        _ body: (UnsafePointer<TargetEncoding.CodeUnit>) throws(E) -> Result
    ) throws(E) -> Result where TargetEncoding: _UnicodeEncoding, E: Error { fatalError() }
    init(_ scalar: Unicode.Scalar) { fatalError() }
    init(stringLiteral value: String) { fatalError() }
    typealias ExtendedGraphemeClusterLiteralType = String
    typealias StringLiteralType = String
    typealias UnicodeScalarLiteralType = String
    var debugDescription: String { fatalError() }
    static func + (lhs: String, rhs: String) -> String { fatalError() }
    static func += (lhs: inout String, rhs: String) { fatalError() }
    func lowercased() -> String { fatalError() }
    func uppercased() -> String { fatalError() }
    init<T>(_ value: T) where T: LosslessStringConvertible { fatalError() }
    var description: String { fatalError() }
    func isTriviallyIdentical(to other: String) -> Bool { fatalError() }
    typealias SubSequence = Substring
    typealias Element = Character
    var startIndex: String.Index { fatalError() }
    var endIndex: String.Index { fatalError() }
    var count: Int { fatalError() }
    func index(after i: String.Index) -> String.Index { fatalError() }
    func index(before i: String.Index) -> String.Index { fatalError() }
    func index(_ i: String.Index, offsetBy distance: Int) -> String.Index { fatalError() }
    func index(_ i: String.Index, offsetBy distance: Int, limitedBy limit: String.Index) -> String
        .Index?
    { fatalError() }
    func distance(from start: String.Index, to end: String.Index) -> Int { fatalError() }
    subscript(i: String.Index) -> Character { fatalError() }
    typealias Indices = DefaultIndices<String>
    func makeIterator() -> String.Iterator { fatalError() }
    static func == (lhs: String, rhs: String) -> Bool { fatalError() }
    static func < (lhs: String, rhs: String) -> Bool { fatalError() }
    static func ~= (lhs: String, rhs: Substring) -> Bool { fatalError() }
    var isContiguousUTF8: Bool { fatalError() }
    mutating func makeContiguousUTF8() { fatalError() }
    mutating func withUTF8<R, E>(_ body: (UnsafeBufferPointer<UInt8>) throws(E) -> R) throws(E) -> R
    where E: Error { fatalError() }
    init(stringInterpolation: DefaultStringInterpolation) { fatalError() }
    init(repeating repeatedValue: String, count: Int) { fatalError() }
    var isEmpty: Bool { fatalError() }
    func hasPrefix(_ prefix: String) -> Bool { fatalError() }
    func hasSuffix(_ suffix: String) -> Bool { fatalError() }
    init<T>(_ value: T, radix: Int = 10, uppercase: Bool = false) where T: BinaryInteger {
        fatalError()
    }
    typealias StringInterpolation = DefaultStringInterpolation
    init(repeating repeatedValue: Character, count: Int) { fatalError() }
    init<S>(_ other: S) where S: LosslessStringConvertible, S: Sequence, S.Element == Character {
        fatalError()
    }
    init<S>(_ characters: S) where S: Sequence, S.Element == Character { fatalError() }
    mutating func reserveCapacity(_ n: Int) { fatalError() }
    mutating func append(_ other: String) { fatalError() }
    mutating func append(_ c: Character) { fatalError() }
    mutating func append(contentsOf newElements: String) { fatalError() }
    mutating func append(contentsOf newElements: Substring) { fatalError() }
    mutating func append<S>(contentsOf newElements: S) where S: Sequence, S.Element == Character {
        fatalError()
    }
    mutating func replaceSubrange<C>(_ subrange: Range<String.Index>, with newElements: C)
    where C: Collection, C.Element == Character { fatalError() }
    mutating func insert(_ newElement: Character, at i: String.Index) { fatalError() }
    mutating func insert<S>(contentsOf newElements: S, at i: String.Index)
    where S: Collection, S.Element == Character { fatalError() }
    @discardableResult mutating func remove(at i: String.Index) -> Character { fatalError() }
    mutating func removeSubrange(_ bounds: Range<String.Index>) { fatalError() }
    mutating func removeAll(keepingCapacity keepCapacity: Bool = false) { fatalError() }
    func max<T>(_ x: T, _ y: T) -> T where T: Comparable { fatalError() }
    func min<T>(_ x: T, _ y: T) -> T where T: Comparable { fatalError() }
    init(_ unicodeScalars: String.UnicodeScalarView) { fatalError() }
    typealias UnicodeScalarIndex = String.UnicodeScalarView.Index
    var unicodeScalars: String.UnicodeScalarView { fatalError() }
    var utf16: String.UTF16View { fatalError() }
    init(_ utf16: String.UTF16View) { fatalError() }
    var utf8: String.UTF8View { fatalError() }
    var utf8CString: ContiguousArray<CChar> { fatalError() }
    init(_ utf8: String.UTF8View) { fatalError() }
    init(_ substring: Substring) { fatalError() }
    init?(_ codeUnits: Substring.UTF8View) { fatalError() }
    init?(_ codeUnits: Substring.UTF16View) { fatalError() }
    init(_ content: Substring.UnicodeScalarView) { fatalError() }
    subscript(r: Range<String.Index>) -> Substring { fatalError() }
    init(copying codeUnits: UTF8Span) { fatalError() }
    var utf8Span: UTF8Span { fatalError() }
    typealias CharacterView = String
    var characters: String { fatalError() }
    mutating func withMutableCharacters<R>(_ body: (inout String) -> R) -> R { fatalError() }
    typealias IndexDistance = Int
    init<Subject>(describing instance: Subject) { fatalError() }
    init<Subject>(describing instance: Subject) where Subject: CustomStringConvertible {
        fatalError()
    }
    init<Subject>(describing instance: Subject) where Subject: TextOutputStreamable { fatalError() }
    init<Subject>(describing instance: Subject)
    where Subject: CustomStringConvertible, Subject: TextOutputStreamable { fatalError() }
    init<Subject>(reflecting subject: Subject) { fatalError() }
    @frozen struct Index {
        func utf16Offset<S>(in s: S) -> Int where S: StringProtocol { fatalError() }
        var encodedOffset: Int { fatalError() }
        init<S>(utf16Offset offset: Int, in s: S) where S: StringProtocol { fatalError() }
        init(encodedOffset offset: Int) { fatalError() }
        static func == (lhs: String.Index, rhs: String.Index) -> Bool { fatalError() }
        static func < (lhs: String.Index, rhs: String.Index) -> Bool { fatalError() }
        func hash(into hasher: inout Hasher) { fatalError() }
        var hashValue: Int { fatalError() }
        var debugDescription: String { fatalError() }
        init?(_ sourcePosition: String.Index, within target: String) { fatalError() }
        init?<S>(_ sourcePosition: String.Index, within target: S) where S: StringProtocol {
            fatalError()
        }
        func samePosition(in utf8: String.UTF8View) -> String.UTF8View.Index? { fatalError() }
        func samePosition(in utf16: String.UTF16View) -> String.UTF16View.Index? { fatalError() }
        init?(_ sourcePosition: String.Index, within unicodeScalars: String.UnicodeScalarView) {
            fatalError()
        }
        func samePosition(in characters: String) -> String.Index? { fatalError() }
        init?(_ idx: String.Index, within target: String.UTF16View) { fatalError() }
        func samePosition(in unicodeScalars: String.UnicodeScalarView) -> String.UnicodeScalarIndex?
        { fatalError() }
        init?(_ idx: String.Index, within target: String.UTF8View) { fatalError() }
    }
    @frozen struct Iterator {
        mutating func next() -> Character? { fatalError() }
        typealias Element = Character
    }
    @frozen struct UTF16View {
        typealias Index = String.Index
        var startIndex: String.UTF16View.Index { fatalError() }
        var endIndex: String.UTF16View.Index { fatalError() }
        func index(after idx: String.UTF16View.Index) -> String.UTF16View.Index { fatalError() }
        func index(before idx: String.UTF16View.Index) -> String.UTF16View.Index { fatalError() }
        func index(_ i: String.UTF16View.Index, offsetBy n: Int) -> String.UTF16View.Index {
            fatalError()
        }
        func index(
            _ i: String.UTF16View.Index, offsetBy n: Int, limitedBy limit: String.UTF16View.Index
        ) -> String.UTF16View.Index? { fatalError() }
        func distance(from start: String.UTF16View.Index, to end: String.UTF16View.Index) -> Int {
            fatalError()
        }
        var count: Int { fatalError() }
        subscript(idx: String.UTF16View.Index) -> UTF16.CodeUnit { fatalError() }
        typealias Element = UTF16.CodeUnit
        typealias Indices = DefaultIndices<String.UTF16View>
        func makeIterator() -> String.UTF16View.Iterator { fatalError() }
        var description: String { fatalError() }
        var debugDescription: String { fatalError() }
        var customMirror: Mirror { fatalError() }
        typealias SubSequence = Substring.UTF16View
        subscript(r: Range<String.UTF16View.Index>) -> Substring.UTF16View { fatalError() }
        func isTriviallyIdentical(to other: String.UTF16View) -> Bool { fatalError() }
        var customPlaygroundQuickLook: _PlaygroundQuickLook { fatalError() }
        @frozen struct Iterator {
            mutating func next() -> UInt16? { fatalError() }
            typealias Element = UInt16
        }
    }
    @frozen struct UTF8View {
        typealias Index = String.Index
        typealias Element = UTF8.CodeUnit
        var startIndex: String.UTF8View.Index { fatalError() }
        var endIndex: String.UTF8View.Index { fatalError() }
        func index(after i: String.UTF8View.Index) -> String.UTF8View.Index { fatalError() }
        func index(before i: String.UTF8View.Index) -> String.UTF8View.Index { fatalError() }
        func index(_ i: String.UTF8View.Index, offsetBy n: Int) -> String.UTF8View.Index {
            fatalError()
        }
        func index(
            _ i: String.UTF8View.Index, offsetBy n: Int, limitedBy limit: String.UTF8View.Index
        ) -> String.UTF8View.Index? { fatalError() }
        func distance(from i: String.UTF8View.Index, to j: String.UTF8View.Index) -> Int {
            fatalError()
        }
        subscript(i: String.UTF8View.Index) -> UTF8.CodeUnit { fatalError() }
        typealias Indices = DefaultIndices<String.UTF8View>
        typealias Iterator = IndexingIterator<String.UTF8View>
        var description: String { fatalError() }
        var debugDescription: String { fatalError() }
        var count: Int { fatalError() }
        var span: Span<UTF8.CodeUnit> { fatalError() }
        var customMirror: Mirror { fatalError() }
        typealias SubSequence = Substring.UTF8View
        subscript(r: Range<String.UTF8View.Index>) -> String.UTF8View.SubSequence { fatalError() }
        func withContiguousStorageIfAvailable<R>(
            _ body: (UnsafeBufferPointer<String.UTF8View.Element>) throws -> R
        ) rethrows -> R? { fatalError() }
        func isTriviallyIdentical(to other: String.UTF8View) -> Bool { fatalError() }
        var customPlaygroundQuickLook: _PlaygroundQuickLook { fatalError() }
    }
    @frozen struct UnicodeScalarView {
        typealias Index = String.Index
        var startIndex: String.UnicodeScalarView.Index { fatalError() }
        var endIndex: String.UnicodeScalarView.Index { fatalError() }
        func index(after i: String.UnicodeScalarView.Index) -> String.UnicodeScalarView.Index {
            fatalError()
        }
        func index(before i: String.UnicodeScalarView.Index) -> String.UnicodeScalarView.Index {
            fatalError()
        }
        subscript(position: String.UnicodeScalarView.Index) -> Unicode.Scalar { fatalError() }
        func distance(
            from start: String.UnicodeScalarView.Index, to end: String.UnicodeScalarView.Index
        ) -> Int { fatalError() }
        func index(_ i: String.UnicodeScalarView.Index, offsetBy distance: Int)
            -> String.UnicodeScalarView.Index
        { fatalError() }
        func index(
            _ i: String.UnicodeScalarView.Index, offsetBy distance: Int,
            limitedBy limit: String.UnicodeScalarView.Index
        ) -> String.UnicodeScalarView.Index? { fatalError() }
        typealias Element = Unicode.Scalar
        typealias Indices = DefaultIndices<String.UnicodeScalarView>
        func makeIterator() -> String.UnicodeScalarView.Iterator { fatalError() }
        var description: String { fatalError() }
        var debugDescription: String { fatalError() }
        init() { fatalError() }
        mutating func reserveCapacity(_ n: Int) { fatalError() }
        mutating func append(_ c: Unicode.Scalar) { fatalError() }
        mutating func append<S>(contentsOf newElements: S)
        where S: Sequence, S.Element == Unicode.Scalar { fatalError() }
        mutating func replaceSubrange<C>(
            _ subrange: Range<String.UnicodeScalarView.Index>, with newElements: C
        ) where C: Collection, C.Element == Unicode.Scalar { fatalError() }
        var customMirror: Mirror { fatalError() }
        typealias SubSequence = Substring.UnicodeScalarView
        subscript(r: Range<String.UnicodeScalarView.Index>) -> String.UnicodeScalarView.SubSequence
        { fatalError() }
        func isTriviallyIdentical(to other: String.UnicodeScalarView) -> Bool { fatalError() }
        var customPlaygroundQuickLook: _PlaygroundQuickLook { fatalError() }
        @frozen struct Iterator {
            mutating func next() -> Unicode.Scalar? { fatalError() }
            typealias Element = Unicode.Scalar
        }
    }
}

protocol StringInterpolationProtocol {
    associatedtype StringLiteralType: _ExpressibleByBuiltinStringLiteral
    init(literalCapacity: Int, interpolationCount: Int)
    mutating func appendLiteral(_ literal: Self.StringLiteralType)
}

protocol StringProtocol: BidirectionalCollection, Comparable, ExpressibleByStringInterpolation,
    Hashable, LosslessStringConvertible, TextOutputStream, TextOutputStreamable
where
    Self.Element == Character, Self.Index == String.Index,
    Self.StringInterpolation == DefaultStringInterpolation, Self.SubSequence: StringProtocol
{
    func hash(into hasher: inout Hasher)
    static func == <RHS>(lhs: Self, rhs: RHS) -> Bool where RHS: StringProtocol
    static func != <RHS>(lhs: Self, rhs: RHS) -> Bool where RHS: StringProtocol
    static func < <RHS>(lhs: Self, rhs: RHS) -> Bool where RHS: StringProtocol
    static func > <RHS>(lhs: Self, rhs: RHS) -> Bool where RHS: StringProtocol
    static func <= <RHS>(lhs: Self, rhs: RHS) -> Bool where RHS: StringProtocol
    static func >= <RHS>(lhs: Self, rhs: RHS) -> Bool where RHS: StringProtocol
    associatedtype UTF8View: Collection
    where Self.UTF8View.Element == UInt8, Self.UTF8View.Index == String.Index
    associatedtype UTF16View: BidirectionalCollection
    where Self.UTF16View.Element == UInt16, Self.UTF16View.Index == String.Index
    associatedtype UnicodeScalarView: BidirectionalCollection
    where
        Self.UnicodeScalarView.Element == Unicode.Scalar,
        Self.UnicodeScalarView.Index == String.Index
    associatedtype SubSequence = Substring
    var utf8: Self.UTF8View { get }
    var utf16: Self.UTF16View { get }
    var unicodeScalars: Self.UnicodeScalarView { get }
    func hasPrefix(_ prefix: String) -> Bool
    func hasSuffix(_ suffix: String) -> Bool
    func lowercased() -> String
    func uppercased() -> String
    init<C, Encoding>(decoding codeUnits: C, as sourceEncoding: Encoding.Type)
    where C: Collection, Encoding: _UnicodeEncoding, C.Element == Encoding.CodeUnit
    init(cString nullTerminatedUTF8: UnsafePointer<CChar>)
    init<Encoding>(
        decodingCString nullTerminatedCodeUnits: UnsafePointer<Encoding.CodeUnit>,
        as sourceEncoding: Encoding.Type) where Encoding: _UnicodeEncoding
    func withCString<Result>(_ body: (UnsafePointer<CChar>) throws -> Result) rethrows -> Result
    func withCString<Result, Encoding>(
        encodedAs targetEncoding: Encoding.Type,
        _ body: (UnsafePointer<Encoding.CodeUnit>) throws -> Result
    ) rethrows -> Result where Encoding: _UnicodeEncoding
    func hasPrefix<Prefix>(_ prefix: Prefix) -> Bool where Prefix: StringProtocol
    func hasSuffix<Suffix>(_ suffix: Suffix) -> Bool where Suffix: StringProtocol
}

@frozen struct Substring {
    static func ~= (lhs: Substring, rhs: String) -> Bool { fatalError() }
    var isContiguousUTF8: Bool { fatalError() }
    mutating func makeContiguousUTF8() { fatalError() }
    mutating func withUTF8<R, E>(_ body: (UnsafeBufferPointer<UInt8>) throws(E) -> R) throws(E) -> R
    where E: Error { fatalError() }
    init(stringInterpolation: DefaultStringInterpolation) { fatalError() }
    init() { fatalError() }
    var base: String { fatalError() }
    typealias Index = String.Index
    typealias SubSequence = Substring
    var startIndex: Substring.Index { fatalError() }
    var endIndex: Substring.Index { fatalError() }
    func index(after i: Substring.Index) -> Substring.Index { fatalError() }
    func index(before i: Substring.Index) -> Substring.Index { fatalError() }
    func index(_ i: Substring.Index, offsetBy distance: Int) -> Substring.Index { fatalError() }
    func index(_ i: Substring.Index, offsetBy distance: Int, limitedBy limit: Substring.Index)
        -> Substring.Index?
    { fatalError() }
    func distance(from start: Substring.Index, to end: Substring.Index) -> Int { fatalError() }
    subscript(i: Substring.Index) -> Character { fatalError() }
    mutating func replaceSubrange<C>(_ subrange: Range<Substring.Index>, with newElements: C)
    where C: Collection, C.Element == Character { fatalError() }
    mutating func replaceSubrange(_ subrange: Range<Substring.Index>, with newElements: Substring) {
        fatalError()
    }
    init<C, Encoding>(decoding codeUnits: C, as sourceEncoding: Encoding.Type)
    where C: Collection, Encoding: _UnicodeEncoding, C.Element == Encoding.CodeUnit { fatalError() }
    init(cString nullTerminatedUTF8: UnsafePointer<CChar>) { fatalError() }
    init<Encoding>(
        decodingCString nullTerminatedCodeUnits: UnsafePointer<Encoding.CodeUnit>,
        as sourceEncoding: Encoding.Type
    ) where Encoding: _UnicodeEncoding { fatalError() }
    func withCString<Result, E>(_ body: (UnsafePointer<CChar>) throws(E) -> Result) throws(E)
        -> Result where E: Error
    { fatalError() }
    func withCString<Result, TargetEncoding, E>(
        encodedAs targetEncoding: TargetEncoding.Type,
        _ body: (UnsafePointer<TargetEncoding.CodeUnit>) throws(E) -> Result
    ) throws(E) -> Result where TargetEncoding: _UnicodeEncoding, E: Error { fatalError() }
    typealias Element = Character
    typealias Indices = DefaultIndices<Substring>
    typealias Iterator = IndexingIterator<Substring>
    typealias StringInterpolation = DefaultStringInterpolation
    var hashValue: Int { fatalError() }
    var customMirror: Mirror { fatalError() }
    var description: String { fatalError() }
    var debugDescription: String { fatalError() }
    init(_ content: String) { fatalError() }
    var utf8: Substring.UTF8View { fatalError() }
    init(_ content: Substring.UTF8View) { fatalError() }
    var utf16: Substring.UTF16View { fatalError() }
    init(_ content: Substring.UTF16View) { fatalError() }
    var unicodeScalars: Substring.UnicodeScalarView { fatalError() }
    init(_ content: Substring.UnicodeScalarView) { fatalError() }
    init<S>(_ elements: S) where S: Sequence, S.Element == Character { fatalError() }
    mutating func append<S>(contentsOf elements: S) where S: Sequence, S.Element == Character {
        fatalError()
    }
    func lowercased() -> String { fatalError() }
    func uppercased() -> String { fatalError() }
    func filter<E>(_ isIncluded: (Substring.Element) throws(E) -> Bool) throws(E) -> String
    where E: Error { fatalError() }
    mutating func write(_ other: String) { fatalError() }
    func write<Target>(to target: inout Target) where Target: TextOutputStream { fatalError() }
    init(unicodeScalarLiteral value: String) { fatalError() }
    typealias UnicodeScalarLiteralType = String
    init(extendedGraphemeClusterLiteral value: String) { fatalError() }
    typealias ExtendedGraphemeClusterLiteralType = String
    init(stringLiteral value: String) { fatalError() }
    typealias StringLiteralType = String
    subscript(r: Range<Substring.Index>) -> Substring { fatalError() }
    func isTriviallyIdentical(to other: Substring) -> Bool { fatalError() }
    var utf8Span: UTF8Span { fatalError() }
    typealias CharacterView = Substring
    var characters: Substring { fatalError() }
    mutating func withMutableCharacters<R>(_ body: (inout Substring) -> R) -> R { fatalError() }
    var customPlaygroundQuickLook: _PlaygroundQuickLook { fatalError() }
    @frozen struct UTF16View {
        typealias Index = String.UTF16View.Index
        typealias Indices = String.UTF16View.Indices
        typealias Element = String.UTF16View.Element
        typealias SubSequence = Substring.UTF16View
        var startIndex: Substring.UTF16View.Index { fatalError() }
        var endIndex: Substring.UTF16View.Index { fatalError() }
        subscript(index: Substring.UTF16View.Index) -> Substring.UTF16View.Element { fatalError() }
        var indices: Substring.UTF16View.Indices { fatalError() }
        func index(after i: Substring.UTF16View.Index) -> Substring.UTF16View.Index { fatalError() }
        func formIndex(after i: inout Substring.UTF16View.Index) { fatalError() }
        func index(_ i: Substring.UTF16View.Index, offsetBy n: Int) -> Substring.UTF16View.Index {
            fatalError()
        }
        func index(
            _ i: Substring.UTF16View.Index, offsetBy n: Int,
            limitedBy limit: Substring.UTF16View.Index
        ) -> Substring.UTF16View.Index? { fatalError() }
        func distance(from start: Substring.UTF16View.Index, to end: Substring.UTF16View.Index)
            -> Int
        { fatalError() }
        func index(before i: Substring.UTF16View.Index) -> Substring.UTF16View.Index {
            fatalError()
        }
        func formIndex(before i: inout Substring.UTF16View.Index) { fatalError() }
        subscript(r: Range<Substring.UTF16View.Index>) -> Substring.UTF16View { fatalError() }
        typealias Iterator = IndexingIterator<Substring.UTF16View>
        func isTriviallyIdentical(to other: Substring.UTF16View) -> Bool { fatalError() }
    }
    @frozen struct UTF8View {
        typealias Index = String.UTF8View.Index
        typealias Indices = String.UTF8View.Indices
        typealias Element = String.UTF8View.Element
        typealias SubSequence = Substring.UTF8View
        var startIndex: Substring.UTF8View.Index { fatalError() }
        var endIndex: Substring.UTF8View.Index { fatalError() }
        subscript(index: Substring.UTF8View.Index) -> Substring.UTF8View.Element { fatalError() }
        var indices: Substring.UTF8View.Indices { fatalError() }
        func index(after i: Substring.UTF8View.Index) -> Substring.UTF8View.Index { fatalError() }
        func formIndex(after i: inout Substring.UTF8View.Index) { fatalError() }
        func index(_ i: Substring.UTF8View.Index, offsetBy n: Int) -> Substring.UTF8View.Index {
            fatalError()
        }
        func index(
            _ i: Substring.UTF8View.Index, offsetBy n: Int,
            limitedBy limit: Substring.UTF8View.Index
        ) -> Substring.UTF8View.Index? { fatalError() }
        func distance(from start: Substring.UTF8View.Index, to end: Substring.UTF8View.Index) -> Int
        { fatalError() }
        func withContiguousStorageIfAvailable<R>(
            _ body: (UnsafeBufferPointer<Substring.UTF8View.Element>) throws -> R
        ) rethrows -> R? { fatalError() }
        func index(before i: Substring.UTF8View.Index) -> Substring.UTF8View.Index { fatalError() }
        func formIndex(before i: inout Substring.UTF8View.Index) { fatalError() }
        subscript(r: Range<Substring.UTF8View.Index>) -> Substring.UTF8View { fatalError() }
        typealias Iterator = IndexingIterator<Substring.UTF8View>
        var span: Span<UTF8.CodeUnit> { fatalError() }
        func isTriviallyIdentical(to other: Substring.UTF8View) -> Bool { fatalError() }
    }
    @frozen struct UnicodeScalarView {
        typealias Index = String.UnicodeScalarView.Index
        typealias Indices = String.UnicodeScalarView.Indices
        typealias Element = String.UnicodeScalarView.Element
        typealias SubSequence = Substring.UnicodeScalarView
        var startIndex: Substring.UnicodeScalarView.Index { fatalError() }
        var endIndex: Substring.UnicodeScalarView.Index { fatalError() }
        subscript(index: Substring.UnicodeScalarView.Index) -> Substring.UnicodeScalarView.Element {
            fatalError()
        }
        var indices: Substring.UnicodeScalarView.Indices { fatalError() }
        func index(after i: Substring.UnicodeScalarView.Index) -> Substring.UnicodeScalarView.Index
        { fatalError() }
        func formIndex(after i: inout Substring.UnicodeScalarView.Index) { fatalError() }
        func index(_ i: Substring.UnicodeScalarView.Index, offsetBy n: Int)
            -> Substring.UnicodeScalarView.Index
        { fatalError() }
        func index(
            _ i: Substring.UnicodeScalarView.Index, offsetBy n: Int,
            limitedBy limit: Substring.UnicodeScalarView.Index
        ) -> Substring.UnicodeScalarView.Index? { fatalError() }
        func distance(
            from start: Substring.UnicodeScalarView.Index, to end: Substring.UnicodeScalarView.Index
        ) -> Int { fatalError() }
        func index(before i: Substring.UnicodeScalarView.Index) -> Substring.UnicodeScalarView.Index
        { fatalError() }
        func formIndex(before i: inout Substring.UnicodeScalarView.Index) { fatalError() }
        subscript(r: Range<Substring.UnicodeScalarView.Index>) -> Substring.UnicodeScalarView {
            fatalError()
        }
        typealias Iterator = IndexingIterator<Substring.UnicodeScalarView>
        init() { fatalError() }
        mutating func replaceSubrange<C>(
            _ subrange: Range<Substring.UnicodeScalarView.Index>, with replacement: C
        ) where C: Collection, C.Element == Unicode.Scalar { fatalError() }
        func isTriviallyIdentical(to other: Substring.UnicodeScalarView) -> Bool { fatalError() }
    }
}

@frozen struct SystemRandomNumberGenerator {
    init() { fatalError() }
    mutating func next() -> UInt64 { fatalError() }
}

protocol TextOutputStream {
    mutating func write(_ string: String)
}

protocol TextOutputStreamable {
    func write<Target>(to target: inout Target) where Target: TextOutputStream
}

@frozen struct UInt {
    init(from decoder: any Decoder) throws { fatalError() }
    func encode(to encoder: any Encoder) throws { fatalError() }
    init(bitPattern pointer: OpaquePointer?) { fatalError() }
    var customMirror: Mirror { fatalError() }
    var customPlaygroundQuickLook: _PlaygroundQuickLook { fatalError() }
    init(bitPattern objectID: ObjectIdentifier) { fatalError() }
    init<P>(bitPattern pointer: P?) where P: _Pointer { fatalError() }
    typealias IntegerLiteralType = UInt
    init(bitPattern x: Int) { fatalError() }
    init(_ source: Float) { fatalError() }
    init?(exactly source: Float) { fatalError() }
    init(_ source: Double) { fatalError() }
    init?(exactly source: Double) { fatalError() }
    init(_ source: Float80) { fatalError() }
    init?(exactly source: Float80) { fatalError() }
    static func == (lhs: UInt, rhs: UInt) -> Bool { fatalError() }
    static func < (lhs: UInt, rhs: UInt) -> Bool { fatalError() }
    static func += (lhs: inout UInt, rhs: UInt) { fatalError() }
    static func -= (lhs: inout UInt, rhs: UInt) { fatalError() }
    static func *= (lhs: inout UInt, rhs: UInt) { fatalError() }
    static func /= (lhs: inout UInt, rhs: UInt) { fatalError() }
    func addingReportingOverflow(_ other: UInt) -> (partialValue: UInt, overflow: Bool) {
        fatalError()
    }
    func subtractingReportingOverflow(_ other: UInt) -> (partialValue: UInt, overflow: Bool) {
        fatalError()
    }
    func multipliedReportingOverflow(by other: UInt) -> (partialValue: UInt, overflow: Bool) {
        fatalError()
    }
    func dividedReportingOverflow(by other: UInt) -> (partialValue: UInt, overflow: Bool) {
        fatalError()
    }
    func remainderReportingOverflow(dividingBy other: UInt) -> (partialValue: UInt, overflow: Bool)
    { fatalError() }
    static func %= (lhs: inout UInt, rhs: UInt) { fatalError() }
    static func &= (lhs: inout UInt, rhs: UInt) { fatalError() }
    static func |= (lhs: inout UInt, rhs: UInt) { fatalError() }
    static func ^= (lhs: inout UInt, rhs: UInt) { fatalError() }
    static func &>>= (lhs: inout UInt, rhs: UInt) { fatalError() }
    static func &<<= (lhs: inout UInt, rhs: UInt) { fatalError() }
    static var bitWidth: Int { fatalError() }
    var leadingZeroBitCount: Int { fatalError() }
    var trailingZeroBitCount: Int { fatalError() }
    var nonzeroBitCount: Int { fatalError() }
    var words: UInt.Words { fatalError() }
    typealias Magnitude = UInt
    func multipliedFullWidth(by other: UInt) -> (high: UInt, low: UInt.Magnitude) { fatalError() }
    func dividingFullWidth(_ dividend: (high: UInt, low: UInt.Magnitude)) -> (
        quotient: UInt, remainder: UInt
    ) { fatalError() }
    var byteSwapped: UInt { fatalError() }
    func signum() -> UInt { fatalError() }
    typealias Stride = Int
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    static func & (lhs: UInt, rhs: UInt) -> UInt { fatalError() }
    static func | (lhs: UInt, rhs: UInt) -> UInt { fatalError() }
    static func ^ (lhs: UInt, rhs: UInt) -> UInt { fatalError() }
    static func &>> (lhs: UInt, rhs: UInt) -> UInt { fatalError() }
    static func &<< (lhs: UInt, rhs: UInt) -> UInt { fatalError() }
    static func + (lhs: UInt, rhs: UInt) -> UInt { fatalError() }
    static func - (lhs: UInt, rhs: UInt) -> UInt { fatalError() }
    static func * (lhs: UInt, rhs: UInt) -> UInt { fatalError() }
    static func / (lhs: UInt, rhs: UInt) -> UInt { fatalError() }
    static func % (lhs: UInt, rhs: UInt) -> UInt { fatalError() }
    static func != (lhs: UInt, rhs: UInt) -> Bool { fatalError() }
    static func <= (lhs: UInt, rhs: UInt) -> Bool { fatalError() }
    static func >= (lhs: UInt, rhs: UInt) -> Bool { fatalError() }
    static func > (lhs: UInt, rhs: UInt) -> Bool { fatalError() }
    typealias SIMDMaskScalar = Int
    @frozen struct SIMD16Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> UInt { fatalError() }
        typealias Scalar = UInt
    }
    @frozen struct SIMD2Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> UInt { fatalError() }
        typealias Scalar = UInt
    }
    @frozen struct SIMD32Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> UInt { fatalError() }
        typealias Scalar = UInt
    }
    @frozen struct SIMD4Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> UInt { fatalError() }
        typealias Scalar = UInt
    }
    @frozen struct SIMD64Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> UInt { fatalError() }
        typealias Scalar = UInt
    }
    @frozen struct SIMD8Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> UInt { fatalError() }
        typealias Scalar = UInt
    }
    @frozen struct Words {
        typealias Indices = Range<Int>
        typealias SubSequence = Slice<UInt.Words>
        init(_ value: UInt) { fatalError() }
        var count: Int { fatalError() }
        var startIndex: Int { fatalError() }
        var endIndex: Int { fatalError() }
        var indices: UInt.Words.Indices { fatalError() }
        func index(after i: Int) -> Int { fatalError() }
        func index(before i: Int) -> Int { fatalError() }
        subscript(position: Int) -> UInt { fatalError() }
        typealias Element = UInt
        typealias Index = Int
        typealias Iterator = IndexingIterator<UInt.Words>
    }
}

@frozen struct UInt128 {
    init(from decoder: any Decoder) throws { fatalError() }
    func encode(to encoder: any Encoder) throws { fatalError() }
    var customMirror: Mirror { fatalError() }
    init(bitPattern: Int128) { fatalError() }
    static var zero: UInt128 { fatalError() }
    static var min: UInt128 { fatalError() }
    static var max: UInt128 { fatalError() }
    typealias IntegerLiteralType = UInt128
    init?<T>(exactly source: T) where T: BinaryInteger { fatalError() }
    init<T>(_ source: T) where T: BinaryInteger { fatalError() }
    init<T>(clamping source: T) where T: BinaryInteger { fatalError() }
    init<T>(truncatingIfNeeded source: T) where T: BinaryInteger { fatalError() }
    init?<T>(exactly source: T) where T: BinaryFloatingPoint { fatalError() }
    init<T>(_ source: T) where T: BinaryFloatingPoint { fatalError() }
    static func == (a: UInt128, b: UInt128) -> Bool { fatalError() }
    static func < (a: UInt128, b: UInt128) -> Bool { fatalError() }
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    func addingReportingOverflow(_ other: UInt128) -> (partialValue: UInt128, overflow: Bool) {
        fatalError()
    }
    func subtractingReportingOverflow(_ other: UInt128) -> (partialValue: UInt128, overflow: Bool) {
        fatalError()
    }
    func multipliedReportingOverflow(by other: UInt128) -> (partialValue: UInt128, overflow: Bool) {
        fatalError()
    }
    func dividedReportingOverflow(by other: UInt128) -> (partialValue: UInt128, overflow: Bool) {
        fatalError()
    }
    func remainderReportingOverflow(dividingBy other: UInt128) -> (
        partialValue: UInt128, overflow: Bool
    ) { fatalError() }
    static func + (a: UInt128, b: UInt128) -> UInt128 { fatalError() }
    static func - (a: UInt128, b: UInt128) -> UInt128 { fatalError() }
    static func * (a: UInt128, b: UInt128) -> UInt128 { fatalError() }
    static func *= (a: inout UInt128, b: UInt128) { fatalError() }
    static func / (a: UInt128, b: UInt128) -> UInt128 { fatalError() }
    static func /= (a: inout UInt128, b: UInt128) { fatalError() }
    static func % (a: UInt128, b: UInt128) -> UInt128 { fatalError() }
    static func %= (a: inout UInt128, b: UInt128) { fatalError() }
    typealias Magnitude = UInt128
    var magnitude: UInt128 { fatalError() }
    var words: UInt128.Words { fatalError() }
    static func &= (a: inout UInt128, b: UInt128) { fatalError() }
    static func |= (a: inout UInt128, b: UInt128) { fatalError() }
    static func ^= (a: inout UInt128, b: UInt128) { fatalError() }
    static func &>>= (a: inout UInt128, b: UInt128) { fatalError() }
    static func &<<= (a: inout UInt128, b: UInt128) { fatalError() }
    var trailingZeroBitCount: Int { fatalError() }
    typealias Stride = Int
    static var bitWidth: Int { fatalError() }
    var nonzeroBitCount: Int { fatalError() }
    var leadingZeroBitCount: Int { fatalError() }
    var byteSwapped: UInt128 { fatalError() }
    static func != (lhs: UInt128, rhs: UInt128) -> Bool { fatalError() }
    static func <= (lhs: UInt128, rhs: UInt128) -> Bool { fatalError() }
    static func >= (lhs: UInt128, rhs: UInt128) -> Bool { fatalError() }
    static func > (lhs: UInt128, rhs: UInt128) -> Bool { fatalError() }
    @frozen struct Words {
        typealias Element = UInt
        typealias Index = Int
        typealias SubSequence = Slice<UInt128.Words>
        typealias Indices = Range<Int>
        var count: Int { fatalError() }
        var startIndex: Int { fatalError() }
        var endIndex: Int { fatalError() }
        var indices: UInt128.Words.Indices { fatalError() }
        func index(after i: Int) -> Int { fatalError() }
        func index(before i: Int) -> Int { fatalError() }
        subscript(position: Int) -> UInt { fatalError() }
        typealias Iterator = IndexingIterator<UInt128.Words>
    }
}

@frozen struct UInt16 {
    init(from decoder: any Decoder) throws { fatalError() }
    func encode(to encoder: any Encoder) throws { fatalError() }
    var customMirror: Mirror { fatalError() }
    var customPlaygroundQuickLook: _PlaygroundQuickLook { fatalError() }
    typealias IntegerLiteralType = UInt16
    init(bitPattern x: Int16) { fatalError() }
    init(_ source: Float) { fatalError() }
    init?(exactly source: Float) { fatalError() }
    init(_ source: Double) { fatalError() }
    init?(exactly source: Double) { fatalError() }
    init(_ source: Float80) { fatalError() }
    init?(exactly source: Float80) { fatalError() }
    static func == (lhs: UInt16, rhs: UInt16) -> Bool { fatalError() }
    static func < (lhs: UInt16, rhs: UInt16) -> Bool { fatalError() }
    static func += (lhs: inout UInt16, rhs: UInt16) { fatalError() }
    static func -= (lhs: inout UInt16, rhs: UInt16) { fatalError() }
    static func *= (lhs: inout UInt16, rhs: UInt16) { fatalError() }
    static func /= (lhs: inout UInt16, rhs: UInt16) { fatalError() }
    func addingReportingOverflow(_ other: UInt16) -> (partialValue: UInt16, overflow: Bool) {
        fatalError()
    }
    func subtractingReportingOverflow(_ other: UInt16) -> (partialValue: UInt16, overflow: Bool) {
        fatalError()
    }
    func multipliedReportingOverflow(by other: UInt16) -> (partialValue: UInt16, overflow: Bool) {
        fatalError()
    }
    func dividedReportingOverflow(by other: UInt16) -> (partialValue: UInt16, overflow: Bool) {
        fatalError()
    }
    func remainderReportingOverflow(dividingBy other: UInt16) -> (
        partialValue: UInt16, overflow: Bool
    ) { fatalError() }
    static func %= (lhs: inout UInt16, rhs: UInt16) { fatalError() }
    static func &= (lhs: inout UInt16, rhs: UInt16) { fatalError() }
    static func |= (lhs: inout UInt16, rhs: UInt16) { fatalError() }
    static func ^= (lhs: inout UInt16, rhs: UInt16) { fatalError() }
    static func &>>= (lhs: inout UInt16, rhs: UInt16) { fatalError() }
    static func &<<= (lhs: inout UInt16, rhs: UInt16) { fatalError() }
    static var bitWidth: Int { fatalError() }
    var leadingZeroBitCount: Int { fatalError() }
    var trailingZeroBitCount: Int { fatalError() }
    var nonzeroBitCount: Int { fatalError() }
    var words: UInt16.Words { fatalError() }
    typealias Magnitude = UInt16
    func multipliedFullWidth(by other: UInt16) -> (high: UInt16, low: UInt16.Magnitude) {
        fatalError()
    }
    func dividingFullWidth(_ dividend: (high: UInt16, low: UInt16.Magnitude)) -> (
        quotient: UInt16, remainder: UInt16
    ) { fatalError() }
    var byteSwapped: UInt16 { fatalError() }
    func signum() -> UInt16 { fatalError() }
    typealias Stride = Int
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    static func & (lhs: UInt16, rhs: UInt16) -> UInt16 { fatalError() }
    static func | (lhs: UInt16, rhs: UInt16) -> UInt16 { fatalError() }
    static func ^ (lhs: UInt16, rhs: UInt16) -> UInt16 { fatalError() }
    static func &>> (lhs: UInt16, rhs: UInt16) -> UInt16 { fatalError() }
    static func &<< (lhs: UInt16, rhs: UInt16) -> UInt16 { fatalError() }
    static func + (lhs: UInt16, rhs: UInt16) -> UInt16 { fatalError() }
    static func - (lhs: UInt16, rhs: UInt16) -> UInt16 { fatalError() }
    static func * (lhs: UInt16, rhs: UInt16) -> UInt16 { fatalError() }
    static func / (lhs: UInt16, rhs: UInt16) -> UInt16 { fatalError() }
    static func % (lhs: UInt16, rhs: UInt16) -> UInt16 { fatalError() }
    static func != (lhs: UInt16, rhs: UInt16) -> Bool { fatalError() }
    static func <= (lhs: UInt16, rhs: UInt16) -> Bool { fatalError() }
    static func >= (lhs: UInt16, rhs: UInt16) -> Bool { fatalError() }
    static func > (lhs: UInt16, rhs: UInt16) -> Bool { fatalError() }
    typealias SIMDMaskScalar = Int16
    @frozen struct SIMD16Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> UInt16 { fatalError() }
        typealias Scalar = UInt16
    }
    @frozen struct SIMD2Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> UInt16 { fatalError() }
        typealias Scalar = UInt16
    }
    @frozen struct SIMD32Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> UInt16 { fatalError() }
        typealias Scalar = UInt16
    }
    @frozen struct SIMD4Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> UInt16 { fatalError() }
        typealias Scalar = UInt16
    }
    @frozen struct SIMD64Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> UInt16 { fatalError() }
        typealias Scalar = UInt16
    }
    @frozen struct SIMD8Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> UInt16 { fatalError() }
        typealias Scalar = UInt16
    }
    @frozen struct Words {
        typealias Indices = Range<Int>
        typealias SubSequence = Slice<UInt16.Words>
        init(_ value: UInt16) { fatalError() }
        var count: Int { fatalError() }
        var startIndex: Int { fatalError() }
        var endIndex: Int { fatalError() }
        var indices: UInt16.Words.Indices { fatalError() }
        func index(after i: Int) -> Int { fatalError() }
        func index(before i: Int) -> Int { fatalError() }
        subscript(position: Int) -> UInt { fatalError() }
        typealias Element = UInt
        typealias Index = Int
        typealias Iterator = IndexingIterator<UInt16.Words>
    }
}

@frozen struct UInt32 {
    init(from decoder: any Decoder) throws { fatalError() }
    func encode(to encoder: any Encoder) throws { fatalError() }
    init(_ v: Unicode.Scalar) { fatalError() }
    var customMirror: Mirror { fatalError() }
    var customPlaygroundQuickLook: _PlaygroundQuickLook { fatalError() }
    typealias IntegerLiteralType = UInt32
    init(bitPattern x: Int32) { fatalError() }
    init(_ source: Float) { fatalError() }
    init?(exactly source: Float) { fatalError() }
    init(_ source: Double) { fatalError() }
    init?(exactly source: Double) { fatalError() }
    init(_ source: Float80) { fatalError() }
    init?(exactly source: Float80) { fatalError() }
    static func == (lhs: UInt32, rhs: UInt32) -> Bool { fatalError() }
    static func < (lhs: UInt32, rhs: UInt32) -> Bool { fatalError() }
    static func += (lhs: inout UInt32, rhs: UInt32) { fatalError() }
    static func -= (lhs: inout UInt32, rhs: UInt32) { fatalError() }
    static func *= (lhs: inout UInt32, rhs: UInt32) { fatalError() }
    static func /= (lhs: inout UInt32, rhs: UInt32) { fatalError() }
    func addingReportingOverflow(_ other: UInt32) -> (partialValue: UInt32, overflow: Bool) {
        fatalError()
    }
    func subtractingReportingOverflow(_ other: UInt32) -> (partialValue: UInt32, overflow: Bool) {
        fatalError()
    }
    func multipliedReportingOverflow(by other: UInt32) -> (partialValue: UInt32, overflow: Bool) {
        fatalError()
    }
    func dividedReportingOverflow(by other: UInt32) -> (partialValue: UInt32, overflow: Bool) {
        fatalError()
    }
    func remainderReportingOverflow(dividingBy other: UInt32) -> (
        partialValue: UInt32, overflow: Bool
    ) { fatalError() }
    static func %= (lhs: inout UInt32, rhs: UInt32) { fatalError() }
    static func &= (lhs: inout UInt32, rhs: UInt32) { fatalError() }
    static func |= (lhs: inout UInt32, rhs: UInt32) { fatalError() }
    static func ^= (lhs: inout UInt32, rhs: UInt32) { fatalError() }
    static func &>>= (lhs: inout UInt32, rhs: UInt32) { fatalError() }
    static func &<<= (lhs: inout UInt32, rhs: UInt32) { fatalError() }
    static var bitWidth: Int { fatalError() }
    var leadingZeroBitCount: Int { fatalError() }
    var trailingZeroBitCount: Int { fatalError() }
    var nonzeroBitCount: Int { fatalError() }
    var words: UInt32.Words { fatalError() }
    typealias Magnitude = UInt32
    func multipliedFullWidth(by other: UInt32) -> (high: UInt32, low: UInt32.Magnitude) {
        fatalError()
    }
    func dividingFullWidth(_ dividend: (high: UInt32, low: UInt32.Magnitude)) -> (
        quotient: UInt32, remainder: UInt32
    ) { fatalError() }
    var byteSwapped: UInt32 { fatalError() }
    func signum() -> UInt32 { fatalError() }
    typealias Stride = Int
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    static func & (lhs: UInt32, rhs: UInt32) -> UInt32 { fatalError() }
    static func | (lhs: UInt32, rhs: UInt32) -> UInt32 { fatalError() }
    static func ^ (lhs: UInt32, rhs: UInt32) -> UInt32 { fatalError() }
    static func &>> (lhs: UInt32, rhs: UInt32) -> UInt32 { fatalError() }
    static func &<< (lhs: UInt32, rhs: UInt32) -> UInt32 { fatalError() }
    static func + (lhs: UInt32, rhs: UInt32) -> UInt32 { fatalError() }
    static func - (lhs: UInt32, rhs: UInt32) -> UInt32 { fatalError() }
    static func * (lhs: UInt32, rhs: UInt32) -> UInt32 { fatalError() }
    static func / (lhs: UInt32, rhs: UInt32) -> UInt32 { fatalError() }
    static func % (lhs: UInt32, rhs: UInt32) -> UInt32 { fatalError() }
    static func != (lhs: UInt32, rhs: UInt32) -> Bool { fatalError() }
    static func <= (lhs: UInt32, rhs: UInt32) -> Bool { fatalError() }
    static func >= (lhs: UInt32, rhs: UInt32) -> Bool { fatalError() }
    static func > (lhs: UInt32, rhs: UInt32) -> Bool { fatalError() }
    typealias SIMDMaskScalar = Int32
    @frozen struct SIMD16Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> UInt32 { fatalError() }
        typealias Scalar = UInt32
    }
    @frozen struct SIMD2Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> UInt32 { fatalError() }
        typealias Scalar = UInt32
    }
    @frozen struct SIMD32Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> UInt32 { fatalError() }
        typealias Scalar = UInt32
    }
    @frozen struct SIMD4Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> UInt32 { fatalError() }
        typealias Scalar = UInt32
    }
    @frozen struct SIMD64Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> UInt32 { fatalError() }
        typealias Scalar = UInt32
    }
    @frozen struct SIMD8Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> UInt32 { fatalError() }
        typealias Scalar = UInt32
    }
    @frozen struct Words {
        typealias Indices = Range<Int>
        typealias SubSequence = Slice<UInt32.Words>
        init(_ value: UInt32) { fatalError() }
        var count: Int { fatalError() }
        var startIndex: Int { fatalError() }
        var endIndex: Int { fatalError() }
        var indices: UInt32.Words.Indices { fatalError() }
        func index(after i: Int) -> Int { fatalError() }
        func index(before i: Int) -> Int { fatalError() }
        subscript(position: Int) -> UInt { fatalError() }
        typealias Element = UInt
        typealias Index = Int
        typealias Iterator = IndexingIterator<UInt32.Words>
    }
}

@frozen struct UInt64 {
    init(from decoder: any Decoder) throws { fatalError() }
    func encode(to encoder: any Encoder) throws { fatalError() }
    init(_ v: Unicode.Scalar) { fatalError() }
    var customMirror: Mirror { fatalError() }
    var customPlaygroundQuickLook: _PlaygroundQuickLook { fatalError() }
    typealias IntegerLiteralType = UInt64
    init(bitPattern x: Int64) { fatalError() }
    init(_ source: Float) { fatalError() }
    init?(exactly source: Float) { fatalError() }
    init(_ source: Double) { fatalError() }
    init?(exactly source: Double) { fatalError() }
    init(_ source: Float80) { fatalError() }
    init?(exactly source: Float80) { fatalError() }
    static func == (lhs: UInt64, rhs: UInt64) -> Bool { fatalError() }
    static func < (lhs: UInt64, rhs: UInt64) -> Bool { fatalError() }
    static func += (lhs: inout UInt64, rhs: UInt64) { fatalError() }
    static func -= (lhs: inout UInt64, rhs: UInt64) { fatalError() }
    static func *= (lhs: inout UInt64, rhs: UInt64) { fatalError() }
    static func /= (lhs: inout UInt64, rhs: UInt64) { fatalError() }
    func addingReportingOverflow(_ other: UInt64) -> (partialValue: UInt64, overflow: Bool) {
        fatalError()
    }
    func subtractingReportingOverflow(_ other: UInt64) -> (partialValue: UInt64, overflow: Bool) {
        fatalError()
    }
    func multipliedReportingOverflow(by other: UInt64) -> (partialValue: UInt64, overflow: Bool) {
        fatalError()
    }
    func dividedReportingOverflow(by other: UInt64) -> (partialValue: UInt64, overflow: Bool) {
        fatalError()
    }
    func remainderReportingOverflow(dividingBy other: UInt64) -> (
        partialValue: UInt64, overflow: Bool
    ) { fatalError() }
    static func %= (lhs: inout UInt64, rhs: UInt64) { fatalError() }
    static func &= (lhs: inout UInt64, rhs: UInt64) { fatalError() }
    static func |= (lhs: inout UInt64, rhs: UInt64) { fatalError() }
    static func ^= (lhs: inout UInt64, rhs: UInt64) { fatalError() }
    static func &>>= (lhs: inout UInt64, rhs: UInt64) { fatalError() }
    static func &<<= (lhs: inout UInt64, rhs: UInt64) { fatalError() }
    static var bitWidth: Int { fatalError() }
    var leadingZeroBitCount: Int { fatalError() }
    var trailingZeroBitCount: Int { fatalError() }
    var nonzeroBitCount: Int { fatalError() }
    var words: UInt64.Words { fatalError() }
    typealias Magnitude = UInt64
    func multipliedFullWidth(by other: UInt64) -> (high: UInt64, low: UInt64.Magnitude) {
        fatalError()
    }
    func dividingFullWidth(_ dividend: (high: UInt64, low: UInt64.Magnitude)) -> (
        quotient: UInt64, remainder: UInt64
    ) { fatalError() }
    var byteSwapped: UInt64 { fatalError() }
    func signum() -> UInt64 { fatalError() }
    typealias Stride = Int
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    static func & (lhs: UInt64, rhs: UInt64) -> UInt64 { fatalError() }
    static func | (lhs: UInt64, rhs: UInt64) -> UInt64 { fatalError() }
    static func ^ (lhs: UInt64, rhs: UInt64) -> UInt64 { fatalError() }
    static func &>> (lhs: UInt64, rhs: UInt64) -> UInt64 { fatalError() }
    static func &<< (lhs: UInt64, rhs: UInt64) -> UInt64 { fatalError() }
    static func + (lhs: UInt64, rhs: UInt64) -> UInt64 { fatalError() }
    static func - (lhs: UInt64, rhs: UInt64) -> UInt64 { fatalError() }
    static func * (lhs: UInt64, rhs: UInt64) -> UInt64 { fatalError() }
    static func / (lhs: UInt64, rhs: UInt64) -> UInt64 { fatalError() }
    static func % (lhs: UInt64, rhs: UInt64) -> UInt64 { fatalError() }
    static func != (lhs: UInt64, rhs: UInt64) -> Bool { fatalError() }
    static func <= (lhs: UInt64, rhs: UInt64) -> Bool { fatalError() }
    static func >= (lhs: UInt64, rhs: UInt64) -> Bool { fatalError() }
    static func > (lhs: UInt64, rhs: UInt64) -> Bool { fatalError() }
    typealias SIMDMaskScalar = Int64
    @frozen struct SIMD16Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> UInt64 { fatalError() }
        typealias Scalar = UInt64
    }
    @frozen struct SIMD2Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> UInt64 { fatalError() }
        typealias Scalar = UInt64
    }
    @frozen struct SIMD32Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> UInt64 { fatalError() }
        typealias Scalar = UInt64
    }
    @frozen struct SIMD4Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> UInt64 { fatalError() }
        typealias Scalar = UInt64
    }
    @frozen struct SIMD64Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> UInt64 { fatalError() }
        typealias Scalar = UInt64
    }
    @frozen struct SIMD8Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> UInt64 { fatalError() }
        typealias Scalar = UInt64
    }
    @frozen struct Words {
        typealias Indices = Range<Int>
        typealias SubSequence = Slice<UInt64.Words>
        init(_ value: UInt64) { fatalError() }
        var count: Int { fatalError() }
        var startIndex: Int { fatalError() }
        var endIndex: Int { fatalError() }
        var indices: UInt64.Words.Indices { fatalError() }
        func index(after i: Int) -> Int { fatalError() }
        func index(before i: Int) -> Int { fatalError() }
        subscript(position: Int) -> UInt { fatalError() }
        typealias Element = UInt
        typealias Index = Int
        typealias Iterator = IndexingIterator<UInt64.Words>
    }
}

@frozen struct UInt8 {
    init(from decoder: any Decoder) throws { fatalError() }
    func encode(to encoder: any Encoder) throws { fatalError() }
    init(ascii v: Unicode.Scalar) { fatalError() }
    var customMirror: Mirror { fatalError() }
    var customPlaygroundQuickLook: _PlaygroundQuickLook { fatalError() }
    typealias IntegerLiteralType = UInt8
    init(bitPattern x: Int8) { fatalError() }
    init(_ source: Float) { fatalError() }
    init?(exactly source: Float) { fatalError() }
    init(_ source: Double) { fatalError() }
    init?(exactly source: Double) { fatalError() }
    init(_ source: Float80) { fatalError() }
    init?(exactly source: Float80) { fatalError() }
    static func == (lhs: UInt8, rhs: UInt8) -> Bool { fatalError() }
    static func < (lhs: UInt8, rhs: UInt8) -> Bool { fatalError() }
    static func += (lhs: inout UInt8, rhs: UInt8) { fatalError() }
    static func -= (lhs: inout UInt8, rhs: UInt8) { fatalError() }
    static func *= (lhs: inout UInt8, rhs: UInt8) { fatalError() }
    static func /= (lhs: inout UInt8, rhs: UInt8) { fatalError() }
    func addingReportingOverflow(_ other: UInt8) -> (partialValue: UInt8, overflow: Bool) {
        fatalError()
    }
    func subtractingReportingOverflow(_ other: UInt8) -> (partialValue: UInt8, overflow: Bool) {
        fatalError()
    }
    func multipliedReportingOverflow(by other: UInt8) -> (partialValue: UInt8, overflow: Bool) {
        fatalError()
    }
    func dividedReportingOverflow(by other: UInt8) -> (partialValue: UInt8, overflow: Bool) {
        fatalError()
    }
    func remainderReportingOverflow(dividingBy other: UInt8) -> (
        partialValue: UInt8, overflow: Bool
    ) { fatalError() }
    static func %= (lhs: inout UInt8, rhs: UInt8) { fatalError() }
    static func &= (lhs: inout UInt8, rhs: UInt8) { fatalError() }
    static func |= (lhs: inout UInt8, rhs: UInt8) { fatalError() }
    static func ^= (lhs: inout UInt8, rhs: UInt8) { fatalError() }
    static func &>>= (lhs: inout UInt8, rhs: UInt8) { fatalError() }
    static func &<<= (lhs: inout UInt8, rhs: UInt8) { fatalError() }
    static var bitWidth: Int { fatalError() }
    var leadingZeroBitCount: Int { fatalError() }
    var trailingZeroBitCount: Int { fatalError() }
    var nonzeroBitCount: Int { fatalError() }
    var words: UInt8.Words { fatalError() }
    typealias Magnitude = UInt8
    func multipliedFullWidth(by other: UInt8) -> (high: UInt8, low: UInt8.Magnitude) {
        fatalError()
    }
    func dividingFullWidth(_ dividend: (high: UInt8, low: UInt8.Magnitude)) -> (
        quotient: UInt8, remainder: UInt8
    ) { fatalError() }
    var byteSwapped: UInt8 { fatalError() }
    func signum() -> UInt8 { fatalError() }
    typealias Stride = Int
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    static func & (lhs: UInt8, rhs: UInt8) -> UInt8 { fatalError() }
    static func | (lhs: UInt8, rhs: UInt8) -> UInt8 { fatalError() }
    static func ^ (lhs: UInt8, rhs: UInt8) -> UInt8 { fatalError() }
    static func &>> (lhs: UInt8, rhs: UInt8) -> UInt8 { fatalError() }
    static func &<< (lhs: UInt8, rhs: UInt8) -> UInt8 { fatalError() }
    static func + (lhs: UInt8, rhs: UInt8) -> UInt8 { fatalError() }
    static func - (lhs: UInt8, rhs: UInt8) -> UInt8 { fatalError() }
    static func * (lhs: UInt8, rhs: UInt8) -> UInt8 { fatalError() }
    static func / (lhs: UInt8, rhs: UInt8) -> UInt8 { fatalError() }
    static func % (lhs: UInt8, rhs: UInt8) -> UInt8 { fatalError() }
    static func != (lhs: UInt8, rhs: UInt8) -> Bool { fatalError() }
    static func <= (lhs: UInt8, rhs: UInt8) -> Bool { fatalError() }
    static func >= (lhs: UInt8, rhs: UInt8) -> Bool { fatalError() }
    static func > (lhs: UInt8, rhs: UInt8) -> Bool { fatalError() }
    typealias SIMDMaskScalar = Int8
    @frozen struct SIMD16Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> UInt8 { fatalError() }
        typealias Scalar = UInt8
    }
    @frozen struct SIMD2Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> UInt8 { fatalError() }
        typealias Scalar = UInt8
    }
    @frozen struct SIMD32Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> UInt8 { fatalError() }
        typealias Scalar = UInt8
    }
    @frozen struct SIMD4Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> UInt8 { fatalError() }
        typealias Scalar = UInt8
    }
    @frozen struct SIMD64Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> UInt8 { fatalError() }
        typealias Scalar = UInt8
    }
    @frozen struct SIMD8Storage {
        var scalarCount: Int { fatalError() }
        init() { fatalError() }
        subscript(index: Int) -> UInt8 { fatalError() }
        typealias Scalar = UInt8
    }
    @frozen struct Words {
        typealias Indices = Range<Int>
        typealias SubSequence = Slice<UInt8.Words>
        init(_ value: UInt8) { fatalError() }
        var count: Int { fatalError() }
        var startIndex: Int { fatalError() }
        var endIndex: Int { fatalError() }
        var indices: UInt8.Words.Indices { fatalError() }
        func index(after i: Int) -> Int { fatalError() }
        func index(before i: Int) -> Int { fatalError() }
        subscript(position: Int) -> UInt { fatalError() }
        typealias Element = UInt
        typealias Index = Int
        typealias Iterator = IndexingIterator<UInt8.Words>
    }
}

@frozen struct UTF8Span {
    init(unchecked codeUnits: Span<UInt8>, isKnownASCII: Bool = false) { fatalError() }
    init(validating codeUnits: consuming Span<UInt8>) throws(UTF8.ValidationError) { fatalError() }
    var isEmpty: Bool { fatalError() }
    var span: Span<UInt8> { fatalError() }
    var isKnownASCII: Bool { fatalError() }
    mutating func checkForASCII() -> Bool { fatalError() }
    var isKnownNFC: Bool { fatalError() }
    mutating func checkForNFC(quickCheck: Bool) -> Bool { fatalError() }
    var count: Int { fatalError() }
    func bytesEqual(to other: some Sequence<UInt8>) -> Bool { fatalError() }
    func unicodeScalarsEqual(to other: some Sequence<Unicode.Scalar>) -> Bool { fatalError() }
    func charactersEqual(to other: some Sequence<Character>) -> Bool { fatalError() }
    func isCanonicallyEquivalent(to other: UTF8Span) -> Bool { fatalError() }
    func isCanonicallyLessThan(_ other: UTF8Span) -> Bool { fatalError() }
    func isTriviallyIdentical(to other: UTF8Span) -> Bool { fatalError() }
    func makeUnicodeScalarIterator() -> UTF8Span.UnicodeScalarIterator { fatalError() }
    func makeCharacterIterator() -> UTF8Span.CharacterIterator { fatalError() }
    struct CharacterIterator {
        var codeUnits: UTF8Span { fatalError() }
        var currentCodeUnitOffset: Int { fatalError() }
        init(_ codeUnits: UTF8Span) { fatalError() }
        mutating func next() -> Character? { fatalError() }
        mutating func previous() -> Character? { fatalError() }
        mutating func skipForward() -> Int { fatalError() }
        mutating func skipForward(by n: Int) -> Int { fatalError() }
        mutating func skipBack() -> Int { fatalError() }
        mutating func skipBack(by n: Int) -> Int { fatalError() }
        mutating func reset(roundingBackwardsFrom i: Int) { fatalError() }
        mutating func reset(roundingForwardsFrom i: Int) { fatalError() }
        mutating func reset(toUnchecked codeUnitOffset: Int) { fatalError() }
        func prefix() -> UTF8Span { fatalError() }
        func suffix() -> UTF8Span { fatalError() }
    }
    @frozen struct UnicodeScalarIterator {
        var codeUnits: UTF8Span { fatalError() }
        var currentCodeUnitOffset: Int { fatalError() }
        init(_ codeUnits: UTF8Span) { fatalError() }
        mutating func next() -> Unicode.Scalar? { fatalError() }
        mutating func previous() -> Unicode.Scalar? { fatalError() }
        mutating func skipForward() -> Int { fatalError() }
        mutating func skipForward(by n: Int) -> Int { fatalError() }
        mutating func skipBack() -> Int { fatalError() }
        mutating func skipBack(by n: Int) -> Int { fatalError() }
        mutating func reset(roundingBackwardsFrom i: Int) { fatalError() }
        mutating func reset(roundingForwardsFrom i: Int) { fatalError() }
        mutating func reset(toUnchecked codeUnitOffset: Int) { fatalError() }
        func prefix() -> UTF8Span { fatalError() }
        func suffix() -> UTF8Span { fatalError() }
    }
}

@frozen enum UnboundedRange_ {
    static func ... (_: UnboundedRange_) { fatalError() }
}

@frozen struct UnfoldSequence<Element, State> {
    mutating func next() -> Element? { fatalError() }
    typealias Iterator = UnfoldSequence<Element, State>
}

@frozen enum Unicode {
    typealias Encoding = _UnicodeEncoding
    typealias Parser = _UnicodeParser
    typealias Version = (major: Int, minor: Int)
    @frozen enum ASCII {
        static func transcode<FromEncoding>(
            _ content: FromEncoding.EncodedScalar, from _: FromEncoding.Type
        ) -> Self.EncodedScalar? where FromEncoding: _UnicodeEncoding { fatalError() }
        typealias CodeUnit = UInt8
        typealias EncodedScalar = CollectionOfOne<Unicode.ASCII.CodeUnit>
        static var encodedReplacementCharacter: Unicode.ASCII.EncodedScalar { fatalError() }
        static func isASCII(_ x: Unicode.ASCII.CodeUnit) -> Bool { fatalError() }
        static func decode(_ source: Unicode.ASCII.EncodedScalar) -> Unicode.Scalar { fatalError() }
        static func encode(_ source: Unicode.Scalar) -> Unicode.ASCII.EncodedScalar? {
            fatalError()
        }
        static func transcode<FromEncoding>(
            _ content: FromEncoding.EncodedScalar, from _: FromEncoding.Type
        ) -> Unicode.ASCII.EncodedScalar? where FromEncoding: _UnicodeEncoding { fatalError() }
        typealias ForwardParser = Unicode.ASCII.Parser
        typealias ReverseParser = Unicode.ASCII.Parser
        @frozen struct Parser {
            init() { fatalError() }
            typealias Encoding = Unicode.ASCII
            mutating func parseScalar<I>(from input: inout I)
                -> Unicode.ParseResult<Unicode.ASCII.Parser.Encoding.EncodedScalar>
            where I: IteratorProtocol, I.Element == UInt8 { fatalError() }
        }
    }
    struct CanonicalCombiningClass {
        static var notReordered: Unicode.CanonicalCombiningClass { fatalError() }
        static var overlay: Unicode.CanonicalCombiningClass { fatalError() }
        static var nukta: Unicode.CanonicalCombiningClass { fatalError() }
        static var kanaVoicing: Unicode.CanonicalCombiningClass { fatalError() }
        static var virama: Unicode.CanonicalCombiningClass { fatalError() }
        static var attachedBelowLeft: Unicode.CanonicalCombiningClass { fatalError() }
        static var attachedBelow: Unicode.CanonicalCombiningClass { fatalError() }
        static var attachedAbove: Unicode.CanonicalCombiningClass { fatalError() }
        static var attachedAboveRight: Unicode.CanonicalCombiningClass { fatalError() }
        static var belowLeft: Unicode.CanonicalCombiningClass { fatalError() }
        static var below: Unicode.CanonicalCombiningClass { fatalError() }
        static var belowRight: Unicode.CanonicalCombiningClass { fatalError() }
        static var left: Unicode.CanonicalCombiningClass { fatalError() }
        static var right: Unicode.CanonicalCombiningClass { fatalError() }
        static var aboveLeft: Unicode.CanonicalCombiningClass { fatalError() }
        static var above: Unicode.CanonicalCombiningClass { fatalError() }
        static var aboveRight: Unicode.CanonicalCombiningClass { fatalError() }
        static var doubleBelow: Unicode.CanonicalCombiningClass { fatalError() }
        static var doubleAbove: Unicode.CanonicalCombiningClass { fatalError() }
        static var iotaSubscript: Unicode.CanonicalCombiningClass { fatalError() }
        var rawValue: UInt8 { fatalError() }
        init(rawValue: UInt8) { fatalError() }
        static func == (lhs: Unicode.CanonicalCombiningClass, rhs: Unicode.CanonicalCombiningClass)
            -> Bool
        { fatalError() }
        static func < (lhs: Unicode.CanonicalCombiningClass, rhs: Unicode.CanonicalCombiningClass)
            -> Bool
        { fatalError() }
        var hashValue: Int { fatalError() }
        func hash(into hasher: inout Hasher) { fatalError() }
        typealias RawValue = UInt8
    }
    enum GeneralCategory {
        case uppercaseLetter
        case lowercaseLetter
        case titlecaseLetter
        case modifierLetter
        case otherLetter
        case nonspacingMark
        case spacingMark
        case enclosingMark
        case decimalNumber
        case letterNumber
        case otherNumber
        case connectorPunctuation
        case dashPunctuation
        case openPunctuation
        case closePunctuation
        case initialPunctuation
        case finalPunctuation
        case otherPunctuation
        case mathSymbol
        case currencySymbol
        case modifierSymbol
        case otherSymbol
        case spaceSeparator
        case lineSeparator
        case paragraphSeparator
        case control
        case format
        case surrogate
        case privateUse
        case unassigned
        static func == (a: Unicode.GeneralCategory, b: Unicode.GeneralCategory) -> Bool {
            fatalError()
        }
        func hash(into hasher: inout Hasher) { fatalError() }
        var hashValue: Int { fatalError() }
    }
    enum NumericType {
        case decimal
        case digit
        case numeric
        static func == (a: Unicode.NumericType, b: Unicode.NumericType) -> Bool { fatalError() }
        func hash(into hasher: inout Hasher) { fatalError() }
        var hashValue: Int { fatalError() }
    }
    @frozen enum ParseResult<T> {
        case valid(T)
        case emptyInput
        case error(length: Int)
    }
    @frozen struct Scalar {
        var value: UInt32 { fatalError() }
        init(unicodeScalarLiteral value: Unicode.Scalar) { fatalError() }
        init?(_ v: UInt32) { fatalError() }
        init?(_ v: UInt16) { fatalError() }
        init(_ v: UInt8) { fatalError() }
        init(_ v: Unicode.Scalar) { fatalError() }
        func escaped(asASCII forceASCII: Bool) -> String { fatalError() }
        var isASCII: Bool { fatalError() }
        typealias UnicodeScalarLiteralType = Unicode.Scalar
        var description: String { fatalError() }
        var debugDescription: String { fatalError() }
        init?(_ description: String) { fatalError() }
        func hash(into hasher: inout Hasher) { fatalError() }
        var hashValue: Int { fatalError() }
        init?(_ v: Int) { fatalError() }
        static func == (lhs: Unicode.Scalar, rhs: Unicode.Scalar) -> Bool { fatalError() }
        static func < (lhs: Unicode.Scalar, rhs: Unicode.Scalar) -> Bool { fatalError() }
        var utf16: Unicode.Scalar.UTF16View { fatalError() }
        var utf8: Unicode.Scalar.UTF8View { fatalError() }
        var customMirror: Mirror { fatalError() }
        var customPlaygroundQuickLook: _PlaygroundQuickLook { fatalError() }
        func write<Target>(to target: inout Target) where Target: TextOutputStream { fatalError() }
        var properties: Unicode.Scalar.Properties { fatalError() }
        struct Properties {
            var isAlphabetic: Bool { fatalError() }
            var isASCIIHexDigit: Bool { fatalError() }
            var isBidiControl: Bool { fatalError() }
            var isBidiMirrored: Bool { fatalError() }
            var isDash: Bool { fatalError() }
            var isDefaultIgnorableCodePoint: Bool { fatalError() }
            var isDeprecated: Bool { fatalError() }
            var isDiacritic: Bool { fatalError() }
            var isExtender: Bool { fatalError() }
            var isFullCompositionExclusion: Bool { fatalError() }
            var isGraphemeBase: Bool { fatalError() }
            var isGraphemeExtend: Bool { fatalError() }
            var isHexDigit: Bool { fatalError() }
            var isIDContinue: Bool { fatalError() }
            var isIDStart: Bool { fatalError() }
            var isIdeographic: Bool { fatalError() }
            var isIDSBinaryOperator: Bool { fatalError() }
            var isIDSTrinaryOperator: Bool { fatalError() }
            var isJoinControl: Bool { fatalError() }
            var isLogicalOrderException: Bool { fatalError() }
            var isLowercase: Bool { fatalError() }
            var isMath: Bool { fatalError() }
            var isNoncharacterCodePoint: Bool { fatalError() }
            var isQuotationMark: Bool { fatalError() }
            var isRadical: Bool { fatalError() }
            var isSoftDotted: Bool { fatalError() }
            var isTerminalPunctuation: Bool { fatalError() }
            var isUnifiedIdeograph: Bool { fatalError() }
            var isUppercase: Bool { fatalError() }
            var isWhitespace: Bool { fatalError() }
            var isXIDContinue: Bool { fatalError() }
            var isXIDStart: Bool { fatalError() }
            var isSentenceTerminal: Bool { fatalError() }
            var isVariationSelector: Bool { fatalError() }
            var isPatternSyntax: Bool { fatalError() }
            var isPatternWhitespace: Bool { fatalError() }
            var isCased: Bool { fatalError() }
            var isCaseIgnorable: Bool { fatalError() }
            var changesWhenLowercased: Bool { fatalError() }
            var changesWhenUppercased: Bool { fatalError() }
            var changesWhenTitlecased: Bool { fatalError() }
            var changesWhenCaseFolded: Bool { fatalError() }
            var changesWhenCaseMapped: Bool { fatalError() }
            var changesWhenNFKCCaseFolded: Bool { fatalError() }
            var isEmoji: Bool { fatalError() }
            var isEmojiPresentation: Bool { fatalError() }
            var isEmojiModifier: Bool { fatalError() }
            var isEmojiModifierBase: Bool { fatalError() }
            var lowercaseMapping: String { fatalError() }
            var titlecaseMapping: String { fatalError() }
            var uppercaseMapping: String { fatalError() }
            var age: Unicode.Version? { fatalError() }
            var generalCategory: Unicode.GeneralCategory { fatalError() }
            var name: String? { fatalError() }
            var nameAlias: String? { fatalError() }
            var canonicalCombiningClass: Unicode.CanonicalCombiningClass { fatalError() }
            var numericType: Unicode.NumericType? { fatalError() }
            var numericValue: Double? { fatalError() }
        }
        @frozen struct UTF16View {
            typealias Indices = Range<Int>
            var startIndex: Int { fatalError() }
            var endIndex: Int { fatalError() }
            subscript(position: Int) -> UTF16.CodeUnit { fatalError() }
            typealias Element = UTF16.CodeUnit
            typealias Index = Int
            typealias Iterator = IndexingIterator<Unicode.Scalar.UTF16View>
            typealias SubSequence = Slice<Unicode.Scalar.UTF16View>
        }
        @frozen struct UTF8View {
            typealias Indices = Range<Int>
            var startIndex: Int { fatalError() }
            var endIndex: Int { fatalError() }
            subscript(position: Int) -> UTF8.CodeUnit { fatalError() }
            typealias Element = UTF8.CodeUnit
            typealias Index = Int
            typealias Iterator = IndexingIterator<Unicode.Scalar.UTF8View>
            typealias SubSequence = Slice<Unicode.Scalar.UTF8View>
        }
    }
    @frozen enum UTF16 {
        static func transcode<FromEncoding>(
            _ content: FromEncoding.EncodedScalar, from _: FromEncoding.Type
        ) -> Self.EncodedScalar? where FromEncoding: _UnicodeEncoding { fatalError() }
        static func width(_ x: Unicode.Scalar) -> Int { fatalError() }
        static func leadSurrogate(_ x: Unicode.Scalar) -> UTF16.CodeUnit { fatalError() }
        static func trailSurrogate(_ x: Unicode.Scalar) -> UTF16.CodeUnit { fatalError() }
        static func isLeadSurrogate(_ x: Unicode.UTF16.CodeUnit) -> Bool { fatalError() }
        static func isTrailSurrogate(_ x: Unicode.UTF16.CodeUnit) -> Bool { fatalError() }
        static func isSurrogate(_ x: Unicode.UTF16.CodeUnit) -> Bool { fatalError() }
        static func transcodedLength<Input, Encoding>(
            of input: Input, decodedAs sourceEncoding: Encoding.Type,
            repairingIllFormedSequences: Bool
        ) -> (count: Int, isASCII: Bool)?
        where
            Input: IteratorProtocol, Encoding: _UnicodeEncoding, Input.Element == Encoding.CodeUnit
        { fatalError() }
        typealias CodeUnit = UInt16
        typealias EncodedScalar = Any
        static var encodedReplacementCharacter: Unicode.UTF16.EncodedScalar { fatalError() }
        static func isASCII(_ x: Unicode.UTF16.CodeUnit) -> Bool { fatalError() }
        static func decode(_ source: Unicode.UTF16.EncodedScalar) -> Unicode.Scalar { fatalError() }
        static func encode(_ source: Unicode.Scalar) -> Unicode.UTF16.EncodedScalar? {
            fatalError()
        }
        static func transcode<FromEncoding>(
            _ content: FromEncoding.EncodedScalar, from _: FromEncoding.Type
        ) -> Unicode.UTF16.EncodedScalar? where FromEncoding: _UnicodeEncoding { fatalError() }
        init() { fatalError() }
        mutating func decode<I>(_ input: inout I) -> UnicodeDecodingResult
        where I: IteratorProtocol, I.Element == UInt16 { fatalError() }
        static func encode(
            _ input: Unicode.Scalar, into processCodeUnit: (Unicode.UTF16.CodeUnit) -> Void
        ) { fatalError() }
        @frozen struct ForwardParser {
            mutating func parseScalar<I>(from input: inout I)
                -> Unicode.ParseResult<Self.Encoding.EncodedScalar>
            where I: IteratorProtocol, I.Element == Self.Encoding.CodeUnit { fatalError() }
            init() { fatalError() }
            typealias Encoding = Unicode.UTF16
        }
        @frozen struct ReverseParser {
            mutating func parseScalar<I>(from input: inout I)
                -> Unicode.ParseResult<Self.Encoding.EncodedScalar>
            where I: IteratorProtocol, I.Element == Self.Encoding.CodeUnit { fatalError() }
            init() { fatalError() }
            typealias Encoding = Unicode.UTF16
        }
    }
    @frozen enum UTF32 {
        static func transcode<FromEncoding>(
            _ content: FromEncoding.EncodedScalar, from _: FromEncoding.Type
        ) -> Self.EncodedScalar? where FromEncoding: _UnicodeEncoding { fatalError() }
        static func == (a: Unicode.UTF32, b: Unicode.UTF32) -> Bool { fatalError() }
        func hash(into hasher: inout Hasher) { fatalError() }
        var hashValue: Int { fatalError() }
        typealias CodeUnit = UInt32
        typealias EncodedScalar = CollectionOfOne<UInt32>
        static var encodedReplacementCharacter: Unicode.UTF32.EncodedScalar { fatalError() }
        static func isASCII(_ x: Unicode.UTF32.CodeUnit) -> Bool { fatalError() }
        static func decode(_ source: Unicode.UTF32.EncodedScalar) -> Unicode.Scalar { fatalError() }
        static func encode(_ source: Unicode.Scalar) -> Unicode.UTF32.EncodedScalar? {
            fatalError()
        }
        typealias ForwardParser = Unicode.UTF32.Parser
        typealias ReverseParser = Unicode.UTF32.Parser
        init() { fatalError() }
        mutating func decode<I>(_ input: inout I) -> UnicodeDecodingResult
        where I: IteratorProtocol, I.Element == UInt32 { fatalError() }
        static func encode(
            _ input: Unicode.Scalar, into processCodeUnit: (Unicode.UTF32.CodeUnit) -> Void
        ) { fatalError() }
        @frozen struct Parser {
            init() { fatalError() }
            typealias Encoding = Unicode.UTF32
            mutating func parseScalar<I>(from input: inout I)
                -> Unicode.ParseResult<Unicode.UTF32.Parser.Encoding.EncodedScalar>
            where I: IteratorProtocol, I.Element == UInt32 { fatalError() }
        }
    }
    @frozen enum UTF8 {
        static func transcode<FromEncoding>(
            _ content: FromEncoding.EncodedScalar, from _: FromEncoding.Type
        ) -> Self.EncodedScalar? where FromEncoding: _UnicodeEncoding { fatalError() }
        static func width(_ x: Unicode.Scalar) -> Int { fatalError() }
        typealias CodeUnit = UInt8
        typealias EncodedScalar = Any
        static var encodedReplacementCharacter: Unicode.UTF8.EncodedScalar { fatalError() }
        static func isASCII(_ x: Unicode.UTF8.CodeUnit) -> Bool { fatalError() }
        static func decode(_ source: Unicode.UTF8.EncodedScalar) -> Unicode.Scalar { fatalError() }
        static func encode(_ source: Unicode.Scalar) -> Unicode.UTF8.EncodedScalar? { fatalError() }
        static func transcode<FromEncoding>(
            _ content: FromEncoding.EncodedScalar, from _: FromEncoding.Type
        ) -> Unicode.UTF8.EncodedScalar? where FromEncoding: _UnicodeEncoding { fatalError() }
        init() { fatalError() }
        mutating func decode<I>(_ input: inout I) -> UnicodeDecodingResult
        where I: IteratorProtocol, I.Element == UInt8 { fatalError() }
        static func encode(
            _ input: Unicode.Scalar, into processCodeUnit: (Unicode.UTF8.CodeUnit) -> Void
        ) { fatalError() }
        static func isContinuation(_ byte: Unicode.UTF8.CodeUnit) -> Bool { fatalError() }
        @frozen struct ForwardParser {
            mutating func parseScalar<I>(from input: inout I)
                -> Unicode.ParseResult<Self.Encoding.EncodedScalar>
            where I: IteratorProtocol, I.Element == Self.Encoding.CodeUnit { fatalError() }
            init() { fatalError() }
            typealias Encoding = Unicode.UTF8
        }
        @frozen struct ReverseParser {
            mutating func parseScalar<I>(from input: inout I)
                -> Unicode.ParseResult<Self.Encoding.EncodedScalar>
            where I: IteratorProtocol, I.Element == Self.Encoding.CodeUnit { fatalError() }
            init() { fatalError() }
            typealias Encoding = Unicode.UTF8
        }
        @frozen struct ValidationError {
            var kind: Unicode.UTF8.ValidationError.Kind { fatalError() }
            var byteOffsets: Range<Int> { fatalError() }
            init(_ kind: Unicode.UTF8.ValidationError.Kind, _ byteOffsets: Range<Int>) {
                fatalError()
            }
            init(_ kind: Unicode.UTF8.ValidationError.Kind, at byteOffset: Int) { fatalError() }
            static func == (a: Unicode.UTF8.ValidationError, b: Unicode.UTF8.ValidationError)
                -> Bool
            { fatalError() }
            func hash(into hasher: inout Hasher) { fatalError() }
            var hashValue: Int { fatalError() }
            var description: String { fatalError() }
            @frozen struct Kind {
                var rawValue: UInt8 { fatalError() }
                init?(rawValue: UInt8) { fatalError() }
                static var unexpectedContinuationByte: Unicode.UTF8.ValidationError.Kind {
                    fatalError()
                }
                static var surrogateCodePointByte: Unicode.UTF8.ValidationError.Kind {
                    fatalError()
                }
                static var invalidNonSurrogateCodePointByte: Unicode.UTF8.ValidationError.Kind {
                    fatalError()
                }
                static var overlongEncodingByte: Unicode.UTF8.ValidationError.Kind { fatalError() }
                static var truncatedScalar: Unicode.UTF8.ValidationError.Kind { fatalError() }
                typealias RawValue = UInt8
                var description: String { fatalError() }
            }
        }
    }
}

protocol UnicodeCodec: _UnicodeEncoding {
    init()
    mutating func decode<I>(_ input: inout I) -> UnicodeDecodingResult
    where I: IteratorProtocol, Self.CodeUnit == I.Element
    static func encode(_ input: Unicode.Scalar, into processCodeUnit: (Self.CodeUnit) -> Void)
}

@frozen enum UnicodeDecodingResult {
    case scalarValue(Unicode.Scalar)
    case emptyInput
    case error
    static func == (lhs: UnicodeDecodingResult, rhs: UnicodeDecodingResult) -> Bool { fatalError() }
}

@frozen struct UniqueArray<Element> where Element: ~Copyable {
    var capacity: Int { fatalError() }
    var freeCapacity: Int { fatalError() }
    var span: Span<Element> { fatalError() }
    var mutableSpan: MutableSpan<Element> { fatalError() }
    mutating func edit<E, R>(_ body: (inout OutputSpan<Element>) throws(E) -> R) throws(E) -> R
    where E: Error, R: ~Copyable { fatalError() }
    mutating func setCapacity(_ newCapacity: Int) { fatalError() }
    mutating func reserveCapacity(_ n: Int) { fatalError() }
    func clone() -> UniqueArray<Element> { fatalError() }
    func clone(capacity: Int) -> UniqueArray<Element> { fatalError() }
    typealias BorrowingIterator = Span<Element>.BorrowingIterator
    typealias Failure = Never
    @export(implementation) var underestimatedCount: Int { fatalError() }
    @export(implementation) func makeBorrowingIterator() -> UniqueArray<Element>.BorrowingIterator {
        fatalError()
    }
    mutating func append(_ item: consuming Element) { fatalError() }
    mutating func append<E>(
        addingCount newItemCount: Int,
        initializingWith initializer: (inout OutputSpan<Element>) throws(E) -> Void
    ) throws(E) where E: Error { fatalError() }
    mutating func append(moving items: UnsafeMutableBufferPointer<Element>) { fatalError() }
    mutating func append(moving items: inout OutputSpan<Element>) { fatalError() }
    mutating func append(copying newElements: UnsafeBufferPointer<Element>) { fatalError() }
    mutating func append(copying newElements: UnsafeMutableBufferPointer<Element>) { fatalError() }
    mutating func append(copying newElements: Span<Element>) { fatalError() }
    mutating func append(copying newElements: some Sequence<Element>) { fatalError() }
    var isEmpty: Bool { fatalError() }
    var count: Int { fatalError() }
    typealias Index = Int
    var startIndex: Int { fatalError() }
    var endIndex: Int { fatalError() }
    var indices: Range<Int> { fatalError() }
    subscript(position: Int) -> Element { fatalError() }
    mutating func swapAt(_ i: Int, _ j: Int) { fatalError() }
    func index(after index: Int) -> Int { fatalError() }
    func index(before index: Int) -> Int { fatalError() }
    func formIndex(after index: inout Int) { fatalError() }
    func formIndex(before index: inout Int) { fatalError() }
    func index(_ index: Int, offsetBy n: Int) -> Int { fatalError() }
    func distance(from start: UniqueArray<Element>.Index, to end: UniqueArray<Element>.Index) -> Int
    { fatalError() }
    func formIndex(
        _ index: inout UniqueArray<Element>.Index, offsetBy n: inout Int,
        limitedBy limit: UniqueArray<Element>.Index
    ) { fatalError() }
    var description: String { fatalError() }
    var debugDescription: String { fatalError() }
    func isTriviallyIdentical(to other: borrowing UniqueArray<Element>) -> Bool { fatalError() }
    static func == (left: borrowing UniqueArray<Element>, right: borrowing UniqueArray<Element>)
        -> Bool
    { fatalError() }
    func hash(into hasher: inout Hasher) { fatalError() }
    var hashValue: Int { fatalError() }
    init() { fatalError() }
    init(capacity: Int) { fatalError() }
    init(minimumCapacity: Int) { fatalError() }
    init<E>(capacity: Int, initializingWith body: (inout OutputSpan<Element>) throws(E) -> Void)
        throws(E) where E: Error
    { fatalError() }
    init(repeating repeatedValue: Element, count: Int) { fatalError() }
    init(capacity: Int? = nil, copying contents: some Sequence<Element>) { fatalError() }
    init(capacity: Int? = nil, copying span: Span<Element>) { fatalError() }
    mutating func insert(_ item: consuming Element, at index: Int) { fatalError() }
    mutating func insert<E>(
        addingCount newItemCount: Int, at index: Int,
        initializingWith initializer: (inout OutputSpan<Element>) throws(E) -> Void
    ) throws(E) where E: Error { fatalError() }
    mutating func insert(moving items: UnsafeMutableBufferPointer<Element>, at index: Int) {
        fatalError()
    }
    mutating func insert(moving items: inout OutputSpan<Element>, at index: Int) { fatalError() }
    mutating func insert(copying newElements: UnsafeBufferPointer<Element>, at index: Int) {
        fatalError()
    }
    mutating func insert(copying newElements: UnsafeMutableBufferPointer<Element>, at index: Int) {
        fatalError()
    }
    mutating func insert(copying newElements: Span<Element>, at index: Int) { fatalError() }
    mutating func insert(copying newElements: some Collection<Element>, at index: Int) {
        fatalError()
    }
    mutating func removeAll() { fatalError() }
    @discardableResult mutating func removeLast() -> Element { fatalError() }
    mutating func removeLast(_ k: Int) { fatalError() }
    @discardableResult mutating func remove(at index: Int) -> Element { fatalError() }
    mutating func removeSubrange(_ bounds: Range<Int>) { fatalError() }
    mutating func removeSubrange(_ bounds: some RangeExpression<Int>) { fatalError() }
    mutating func popLast() -> Element? { fatalError() }
    mutating func replaceSubrange<E>(
        _ subrange: Range<Int>, addingCount newItemCount: Int,
        initializingWith initializer: (inout OutputSpan<Element>) throws(E) -> Void
    ) throws(E) where E: Error { fatalError() }
    mutating func replaceSubrange(
        _ subrange: Range<Int>, moving newElements: UnsafeMutableBufferPointer<Element>
    ) { fatalError() }
    mutating func replaceSubrange(_ subrange: Range<Int>, moving items: inout OutputSpan<Element>) {
        fatalError()
    }
    mutating func replaceSubrange(
        _ subrange: Range<Int>, copying newElements: UnsafeBufferPointer<Element>
    ) { fatalError() }
    mutating func replaceSubrange(
        _ subrange: Range<Int>, copying newElements: UnsafeMutableBufferPointer<Element>
    ) { fatalError() }
    mutating func replaceSubrange(_ subrange: Range<Int>, copying newElements: Span<Element>) {
        fatalError()
    }
    mutating func replaceSubrange(
        _ subrange: Range<Int>, copying newElements: consuming some Collection<Element>
    ) { fatalError() }
}

@frozen struct UniqueBox<Value> where Value: ~Copyable {
    init(_ initialValue: consuming Value) { fatalError() }
    var value: Value { fatalError() }
    consuming func consume() -> Value { fatalError() }
    var span: Span<Value> { fatalError() }
    var mutableSpan: MutableSpan<Value> { fatalError() }
    func clone() -> UniqueBox<Value> { fatalError() }
}

protocol UnkeyedDecodingContainer {
    var codingPath: [any CodingKey] { get }
    var count: Int? { get }
    var isAtEnd: Bool { get }
    var currentIndex: Int { get }
    mutating func decodeNil() throws -> Bool
    mutating func decode(_ type: Bool.Type) throws -> Bool
    mutating func decode(_ type: String.Type) throws -> String
    mutating func decode(_ type: Double.Type) throws -> Double
    mutating func decode(_ type: Float.Type) throws -> Float
    mutating func decode(_ type: Int.Type) throws -> Int
    mutating func decode(_ type: Int8.Type) throws -> Int8
    mutating func decode(_ type: Int16.Type) throws -> Int16
    mutating func decode(_ type: Int32.Type) throws -> Int32
    mutating func decode(_ type: Int64.Type) throws -> Int64
    mutating func decode(_ type: Int128.Type) throws -> Int128
    mutating func decode(_ type: UInt.Type) throws -> UInt
    mutating func decode(_ type: UInt8.Type) throws -> UInt8
    mutating func decode(_ type: UInt16.Type) throws -> UInt16
    mutating func decode(_ type: UInt32.Type) throws -> UInt32
    mutating func decode(_ type: UInt64.Type) throws -> UInt64
    mutating func decode(_ type: UInt128.Type) throws -> UInt128
    mutating func decode<T>(_ type: T.Type) throws -> T where T: Decodable
    mutating func decodeIfPresent(_ type: Bool.Type) throws -> Bool?
    mutating func decodeIfPresent(_ type: String.Type) throws -> String?
    mutating func decodeIfPresent(_ type: Double.Type) throws -> Double?
    mutating func decodeIfPresent(_ type: Float.Type) throws -> Float?
    mutating func decodeIfPresent(_ type: Int.Type) throws -> Int?
    mutating func decodeIfPresent(_ type: Int8.Type) throws -> Int8?
    mutating func decodeIfPresent(_ type: Int16.Type) throws -> Int16?
    mutating func decodeIfPresent(_ type: Int32.Type) throws -> Int32?
    mutating func decodeIfPresent(_ type: Int64.Type) throws -> Int64?
    mutating func decodeIfPresent(_ type: Int128.Type) throws -> Int128?
    mutating func decodeIfPresent(_ type: UInt.Type) throws -> UInt?
    mutating func decodeIfPresent(_ type: UInt8.Type) throws -> UInt8?
    mutating func decodeIfPresent(_ type: UInt16.Type) throws -> UInt16?
    mutating func decodeIfPresent(_ type: UInt32.Type) throws -> UInt32?
    mutating func decodeIfPresent(_ type: UInt64.Type) throws -> UInt64?
    mutating func decodeIfPresent(_ type: UInt128.Type) throws -> UInt128?
    mutating func decodeIfPresent<T>(_ type: T.Type) throws -> T? where T: Decodable
    mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws
        -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey
    mutating func nestedUnkeyedContainer() throws -> any UnkeyedDecodingContainer
    mutating func superDecoder() throws -> any Decoder
}

protocol UnkeyedEncodingContainer {
    var codingPath: [any CodingKey] { get }
    var count: Int { get }
    mutating func encodeNil() throws
    mutating func encode(_ value: Bool) throws
    mutating func encode(_ value: String) throws
    mutating func encode(_ value: Double) throws
    mutating func encode(_ value: Float) throws
    mutating func encode(_ value: Int) throws
    mutating func encode(_ value: Int8) throws
    mutating func encode(_ value: Int16) throws
    mutating func encode(_ value: Int32) throws
    mutating func encode(_ value: Int64) throws
    mutating func encode(_ value: Int128) throws
    mutating func encode(_ value: UInt) throws
    mutating func encode(_ value: UInt8) throws
    mutating func encode(_ value: UInt16) throws
    mutating func encode(_ value: UInt32) throws
    mutating func encode(_ value: UInt64) throws
    mutating func encode(_ value: UInt128) throws
    mutating func encode<T>(_ value: T) throws where T: Encodable
    mutating func encodeConditional<T>(_ object: T) throws where T: AnyObject, T: Encodable
    mutating func encode<T>(contentsOf sequence: T) throws where T: Sequence, T.Element == Bool
    mutating func encode<T>(contentsOf sequence: T) throws where T: Sequence, T.Element == String
    mutating func encode<T>(contentsOf sequence: T) throws where T: Sequence, T.Element == Double
    mutating func encode<T>(contentsOf sequence: T) throws where T: Sequence, T.Element == Float
    mutating func encode<T>(contentsOf sequence: T) throws where T: Sequence, T.Element == Int
    mutating func encode<T>(contentsOf sequence: T) throws where T: Sequence, T.Element == Int8
    mutating func encode<T>(contentsOf sequence: T) throws where T: Sequence, T.Element == Int16
    mutating func encode<T>(contentsOf sequence: T) throws where T: Sequence, T.Element == Int32
    mutating func encode<T>(contentsOf sequence: T) throws where T: Sequence, T.Element == Int64
    mutating func encode<T>(contentsOf sequence: T) throws where T: Sequence, T.Element == Int128
    mutating func encode<T>(contentsOf sequence: T) throws where T: Sequence, T.Element == UInt
    mutating func encode<T>(contentsOf sequence: T) throws where T: Sequence, T.Element == UInt8
    mutating func encode<T>(contentsOf sequence: T) throws where T: Sequence, T.Element == UInt16
    mutating func encode<T>(contentsOf sequence: T) throws where T: Sequence, T.Element == UInt32
    mutating func encode<T>(contentsOf sequence: T) throws where T: Sequence, T.Element == UInt64
    mutating func encode<T>(contentsOf sequence: T) throws where T: Sequence, T.Element == UInt128
    mutating func encode<T>(contentsOf sequence: T) throws where T: Sequence, T.Element: Encodable
    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type)
        -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey
    mutating func nestedUnkeyedContainer() -> any UnkeyedEncodingContainer
    mutating func superEncoder() -> any Encoder
}

@frozen struct Unmanaged<Instance> where Instance: AnyObject {
    static func fromOpaque(_ value: UnsafeRawPointer) -> Unmanaged<Instance> { fatalError() }
    func toOpaque() -> UnsafeMutableRawPointer { fatalError() }
    static func passRetained(_ value: Instance) -> Unmanaged<Instance> { fatalError() }
    static func passUnretained(_ value: Instance) -> Unmanaged<Instance> { fatalError() }
    func takeUnretainedValue() -> Instance { fatalError() }
    func takeRetainedValue() -> Instance { fatalError() }
    func retain() -> Unmanaged<Instance> { fatalError() }
    func release() { fatalError() }
    func autorelease() -> Unmanaged<Instance> { fatalError() }
}

@frozen struct UnsafeBufferPointer<Element> where Element: ~Copyable {
    var count: Int { fatalError() }
    init(start: UnsafePointer<Element>?, count: Int) { fatalError() }
    init(_ other: UnsafeMutableBufferPointer<Element>) { fatalError() }
    var baseAddress: UnsafePointer<Element>? { fatalError() }
    func makeIterator() -> UnsafeBufferPointer<Element>.Iterator { fatalError() }
    func withContiguousStorageIfAvailable<R>(_ body: (UnsafeBufferPointer<Element>) throws -> R)
        rethrows -> R?
    { fatalError() }
    typealias Index = Int
    var isEmpty: Bool { fatalError() }
    var startIndex: Int { fatalError() }
    var endIndex: Int { fatalError() }
    var indices: Range<Int> { fatalError() }
    func index(after i: Int) -> Int { fatalError() }
    func formIndex(after i: inout Int) { fatalError() }
    func index(before i: Int) -> Int { fatalError() }
    func formIndex(before i: inout Int) { fatalError() }
    func index(_ i: Int, offsetBy n: Int) -> Int { fatalError() }
    func index(_ i: Int, offsetBy n: Int, limitedBy limit: Int) -> Int? { fatalError() }
    func distance(from start: Int, to end: Int) -> Int { fatalError() }
    subscript(i: Int) -> Element { fatalError() }
    func extracting(_ bounds: Range<Int>) -> UnsafeBufferPointer<Element> { fatalError() }
    func extracting(_ bounds: some RangeExpression<Int>) -> UnsafeBufferPointer<Element> {
        fatalError()
    }
    func extracting(_ bounds: UnboundedRange) -> UnsafeBufferPointer<Element> { fatalError() }
    var span: Span<Element> { fatalError() }
    func isTriviallyIdentical(to other: UnsafeBufferPointer<Element>) -> Bool { fatalError() }
    typealias Indices = Range<Int>
    typealias SubSequence = Slice<UnsafeBufferPointer<Element>>
    subscript(bounds: Range<Int>) -> Slice<UnsafeBufferPointer<Element>> { fatalError() }
    init(rebasing slice: Slice<UnsafeBufferPointer<Element>>) { fatalError() }
    init(rebasing slice: Slice<UnsafeMutableBufferPointer<Element>>) { fatalError() }
    func deallocate() { fatalError() }
    func withMemoryRebound<T, E, Result>(
        to type: T.Type, _ body: (UnsafeBufferPointer<T>) throws(E) -> Result
    ) throws(E) -> Result where E: Error, T: ~Copyable, Result: ~Copyable { fatalError() }
    var debugDescription: String { fatalError() }
    @frozen struct Iterator {
        mutating func next() -> Element? { fatalError() }
    }
}

@frozen struct UnsafeMutableBufferPointer<Element> where Element: ~Copyable {
    var count: Int { fatalError() }
    init(start: UnsafeMutablePointer<Element>?, count: Int) { fatalError() }
    init(mutating other: UnsafeBufferPointer<Element>) { fatalError() }
    var baseAddress: UnsafeMutablePointer<Element>? { fatalError() }
    typealias Iterator = UnsafeBufferPointer<Element>.Iterator
    func makeIterator() -> UnsafeMutableBufferPointer<Element>.Iterator { fatalError() }
    func withContiguousStorageIfAvailable<R>(_ body: (UnsafeBufferPointer<Element>) throws -> R)
        rethrows -> R?
    { fatalError() }
    typealias Index = Int
    var isEmpty: Bool { fatalError() }
    var startIndex: Int { fatalError() }
    var endIndex: Int { fatalError() }
    var indices: Range<Int> { fatalError() }
    func index(after i: Int) -> Int { fatalError() }
    func formIndex(after i: inout Int) { fatalError() }
    func index(before i: Int) -> Int { fatalError() }
    func formIndex(before i: inout Int) { fatalError() }
    func index(_ i: Int, offsetBy n: Int) -> Int { fatalError() }
    func index(_ i: Int, offsetBy n: Int, limitedBy limit: Int) -> Int? { fatalError() }
    func distance(from start: Int, to end: Int) -> Int { fatalError() }
    subscript(i: Int) -> Element { fatalError() }
    func swapAt(_ i: Int, _ j: Int) { fatalError() }
    func extracting(_ bounds: Range<Int>) -> UnsafeMutableBufferPointer<Element> { fatalError() }
    func extracting(_ bounds: some RangeExpression<Int>) -> UnsafeMutableBufferPointer<Element> {
        fatalError()
    }
    func extracting(_ bounds: UnboundedRange) -> UnsafeMutableBufferPointer<Element> {
        fatalError()
    }
    var span: Span<Element> { fatalError() }
    var mutableSpan: MutableSpan<Element> { fatalError() }
    func isTriviallyIdentical(to other: UnsafeMutableBufferPointer<Element>) -> Bool {
        fatalError()
    }
    typealias Indices = Range<Int>
    typealias SubSequence = Slice<UnsafeMutableBufferPointer<Element>>
    subscript(bounds: Range<Int>) -> Slice<UnsafeMutableBufferPointer<Element>> { fatalError() }
    mutating func withContiguousMutableStorageIfAvailable<R>(
        _ body: (inout UnsafeMutableBufferPointer<Element>) throws -> R
    ) rethrows -> R? { fatalError() }
    init(rebasing slice: Slice<UnsafeMutableBufferPointer<Element>>) { fatalError() }
    func deallocate() { fatalError() }
    static func allocate(capacity count: Int) -> UnsafeMutableBufferPointer<Element> {
        fatalError()
    }
    func initialize(repeating repeatedValue: Element) { fatalError() }
    func initialize<S>(from source: S) -> (
        unwritten: S.Iterator, index: UnsafeMutableBufferPointer<Element>.Index
    ) where Element == S.Element, S: Sequence { fatalError() }
    func initialize(fromContentsOf source: some Collection<Element>)
        -> UnsafeMutableBufferPointer<Element>.Index
    { fatalError() }
    func update(repeating repeatedValue: Element) { fatalError() }
    func assign(repeating repeatedValue: Element) { fatalError() }
    func update<S>(from source: S) -> (
        unwritten: S.Iterator, index: UnsafeMutableBufferPointer<Element>.Index
    ) where Element == S.Element, S: Sequence { fatalError() }
    func update(fromContentsOf source: some Collection<Element>)
        -> UnsafeMutableBufferPointer<Element>.Index
    { fatalError() }
    func moveInitialize(fromContentsOf source: UnsafeMutableBufferPointer<Element>)
        -> UnsafeMutableBufferPointer<Element>.Index
    { fatalError() }
    func moveInitialize(fromContentsOf source: Slice<UnsafeMutableBufferPointer<Element>>)
        -> UnsafeMutableBufferPointer<Element>.Index
    { fatalError() }
    func moveUpdate(fromContentsOf source: UnsafeMutableBufferPointer<Element>)
        -> UnsafeMutableBufferPointer<Element>.Index
    { fatalError() }
    func moveUpdate(fromContentsOf source: Slice<UnsafeMutableBufferPointer<Element>>)
        -> UnsafeMutableBufferPointer<Element>.Index
    { fatalError() }
    @discardableResult func deinitialize() -> UnsafeMutableRawBufferPointer { fatalError() }
    func initializeElement(
        at index: UnsafeMutableBufferPointer<Element>.Index, to value: consuming Element
    ) { fatalError() }
    func moveElement(from index: UnsafeMutableBufferPointer<Element>.Index) -> Element {
        fatalError()
    }
    func deinitializeElement(at index: UnsafeMutableBufferPointer<Element>.Index) { fatalError() }
    func withMemoryRebound<T, E, Result>(
        to type: T.Type, _ body: (UnsafeMutableBufferPointer<T>) throws(E) -> Result
    ) throws(E) -> Result where E: Error, T: ~Copyable, Result: ~Copyable { fatalError() }
    var debugDescription: String { fatalError() }
}

@frozen struct UnsafeMutablePointer<Pointee> where Pointee: ~Copyable {
    init(_ from: OpaquePointer) { fatalError() }
    init?(_ from: OpaquePointer?) { fatalError() }
    init?(bitPattern: Int) { fatalError() }
    init?(bitPattern: UInt) { fatalError() }
    init(_ other: Self) { fatalError() }
    init?(_ other: Self?) { fatalError() }
    static func == (lhs: Self, rhs: Self) -> Bool { fatalError() }
    static func == <Other>(lhs: Self, rhs: Other) -> Bool where Other: _Pointer { fatalError() }
    static func != <Other>(lhs: Self, rhs: Other) -> Bool where Other: _Pointer { fatalError() }
    static func < (lhs: Self, rhs: Self) -> Bool { fatalError() }
    static func < <Other>(lhs: Self, rhs: Other) -> Bool where Other: _Pointer { fatalError() }
    static func <= <Other>(lhs: Self, rhs: Other) -> Bool where Other: _Pointer { fatalError() }
    static func > <Other>(lhs: Self, rhs: Other) -> Bool where Other: _Pointer { fatalError() }
    static func >= <Other>(lhs: Self, rhs: Other) -> Bool where Other: _Pointer { fatalError() }
    func successor() -> Self { fatalError() }
    func predecessor() -> Self { fatalError() }
    func distance(to end: Self) -> Int { fatalError() }
    func advanced(by n: Int) -> Self { fatalError() }
    var debugDescription: String { fatalError() }
    typealias Distance = Int
    var hashValue: Int { fatalError() }
    typealias Stride = Int
    init(mutating other: UnsafePointer<Pointee>) { fatalError() }
    init?(mutating other: UnsafePointer<Pointee>?) { fatalError() }
    init(_ other: UnsafeMutablePointer<Pointee>) { fatalError() }
    init?(_ other: UnsafeMutablePointer<Pointee>?) { fatalError() }
    static func allocate(capacity count: Int) -> UnsafeMutablePointer<Pointee> { fatalError() }
    func deallocate() { fatalError() }
    var pointee: Pointee { fatalError() }
    func initialize(repeating repeatedValue: Pointee, count: Int) { fatalError() }
    func initialize(to value: consuming Pointee) { fatalError() }
    func move() -> Pointee { fatalError() }
    func update(repeating repeatedValue: Pointee, count: Int) { fatalError() }
    func assign(repeating repeatedValue: Pointee, count: Int) { fatalError() }
    func update(from source: UnsafePointer<Pointee>, count: Int) { fatalError() }
    func assign(from source: UnsafePointer<Pointee>, count: Int) { fatalError() }
    func moveInitialize(from source: UnsafeMutablePointer<Pointee>, count: Int) { fatalError() }
    func initialize(from source: UnsafePointer<Pointee>, count: Int) { fatalError() }
    func moveUpdate(from source: UnsafeMutablePointer<Pointee>, count: Int) { fatalError() }
    func moveAssign(from source: UnsafeMutablePointer<Pointee>, count: Int) { fatalError() }
    @discardableResult func deinitialize(count: Int) -> UnsafeMutableRawPointer { fatalError() }
    func withMemoryRebound<T, E, Result>(
        to type: T.Type, capacity count: Int, _ body: (UnsafeMutablePointer<T>) throws(E) -> Result
    ) throws(E) -> Result where E: Error, T: ~Copyable, Result: ~Copyable { fatalError() }
    subscript(i: Int) -> Pointee { fatalError() }
    func pointer<Property>(to property: KeyPath<Pointee, Property>) -> UnsafePointer<Property>? {
        fatalError()
    }
    func pointer<Property>(to property: WritableKeyPath<Pointee, Property>) -> UnsafeMutablePointer<
        Property
    >? { fatalError() }
    func initialize(to newValue: Pointee, count: Int = 1) { fatalError() }
    @discardableResult func deinitialize() -> UnsafeMutableRawPointer { fatalError() }
    func deallocate(capacity _: Int) { fatalError() }
    func initialize<C>(from source: C) where Pointee == C.Element, C: Collection { fatalError() }
    var customPlaygroundQuickLook: PlaygroundQuickLook { fatalError() }
}

@frozen struct UnsafeMutableRawBufferPointer {
    static func allocate(count: Int) -> UnsafeMutableRawBufferPointer { fatalError() }
    func copyBytes(from source: UnsafeRawBufferPointer) { fatalError() }
    init(start: UnsafeMutableRawPointer?, count: Int) { fatalError() }
    typealias Iterator = UnsafeRawBufferPointer.Iterator
    typealias SubSequence = Slice<UnsafeMutableRawBufferPointer>
    func makeIterator() -> UnsafeMutableRawBufferPointer.Iterator { fatalError() }
    typealias Element = UInt8
    typealias Index = Int
    typealias Indices = Range<Int>
    var startIndex: UnsafeMutableRawBufferPointer.Index { fatalError() }
    var endIndex: UnsafeMutableRawBufferPointer.Index { fatalError() }
    var indices: UnsafeMutableRawBufferPointer.Indices { fatalError() }
    subscript(i: Int) -> UnsafeMutableRawBufferPointer.Element { fatalError() }
    subscript(bounds: Range<Int>) -> UnsafeMutableRawBufferPointer.SubSequence { fatalError() }
    func swapAt(_ i: Int, _ j: Int) { fatalError() }
    var count: Int { fatalError() }
    static func allocate(byteCount: Int, alignment: Int) -> UnsafeMutableRawBufferPointer {
        fatalError()
    }
    func deallocate() { fatalError() }
    func load<T>(fromByteOffset offset: Int = 0, as type: T.Type) -> T { fatalError() }
    func loadUnaligned<T>(fromByteOffset offset: Int = 0, as type: T.Type) -> T
    where T: BitwiseCopyable, T: ~Escapable { fatalError() }
    func loadUnaligned<T>(fromByteOffset offset: Int = 0, as type: T.Type) -> T { fatalError() }
    func storeBytes<T>(of value: T, toByteOffset offset: Int = 0, as type: T.Type) { fatalError() }
    func copyMemory(from source: UnsafeRawBufferPointer) { fatalError() }
    func copyBytes<C>(from source: C) where C: Collection, C.Element == UInt8 { fatalError() }
    init(_ bytes: UnsafeMutableRawBufferPointer) { fatalError() }
    init(mutating bytes: UnsafeRawBufferPointer) { fatalError() }
    init<T>(_ buffer: UnsafeMutableBufferPointer<T>) where T: ~Copyable { fatalError() }
    init(rebasing slice: Slice<UnsafeMutableRawBufferPointer>) { fatalError() }
    var baseAddress: UnsafeMutableRawPointer? { fatalError() }
    @discardableResult func initializeMemory<T>(as type: T.Type, repeating repeatedValue: T)
        -> UnsafeMutableBufferPointer<T>
    { fatalError() }
    func initializeMemory<S>(as type: S.Element.Type, from source: S) -> (
        unwritten: S.Iterator, initialized: UnsafeMutableBufferPointer<S.Element>
    ) where S: Sequence { fatalError() }
    func initializeMemory<C>(as type: C.Element.Type, fromContentsOf source: C)
        -> UnsafeMutableBufferPointer<C.Element> where C: Collection
    { fatalError() }
    @discardableResult func moveInitializeMemory<T>(
        as type: T.Type, fromContentsOf source: UnsafeMutableBufferPointer<T>
    ) -> UnsafeMutableBufferPointer<T> where T: ~Copyable { fatalError() }
    @discardableResult func moveInitializeMemory<T>(
        as type: T.Type, fromContentsOf source: Slice<UnsafeMutableBufferPointer<T>>
    ) -> UnsafeMutableBufferPointer<T> { fatalError() }
    @discardableResult func bindMemory<T>(to type: T.Type) -> UnsafeMutableBufferPointer<T>
    where T: ~Copyable { fatalError() }
    func withMemoryRebound<T, E, Result>(
        to type: T.Type, _ body: (UnsafeMutableBufferPointer<T>) throws(E) -> Result
    ) throws(E) -> Result where E: Error, T: ~Copyable, Result: ~Copyable { fatalError() }
    func assumingMemoryBound<T>(to: T.Type) -> UnsafeMutableBufferPointer<T> where T: ~Copyable {
        fatalError()
    }
    func withContiguousMutableStorageIfAvailable<R>(
        _ body: (inout UnsafeMutableBufferPointer<UnsafeMutableRawBufferPointer.Element>) throws ->
            R
    ) rethrows -> R? { fatalError() }
    func withContiguousStorageIfAvailable<R>(
        _ body: (UnsafeBufferPointer<UnsafeMutableRawBufferPointer.Element>) throws -> R
    ) rethrows -> R? { fatalError() }
    var bytes: RawSpan { fatalError() }
    var mutableBytes: MutableRawSpan { fatalError() }
    func isTriviallyIdentical(to other: UnsafeMutableRawBufferPointer) -> Bool { fatalError() }
    var debugDescription: String { fatalError() }
}

@frozen struct UnsafeMutableRawPointer {
    init<T>(_ other: AutoreleasingUnsafeMutablePointer<T>) { fatalError() }
    init?<T>(_ other: AutoreleasingUnsafeMutablePointer<T>?) { fatalError() }
    init(_ from: OpaquePointer) { fatalError() }
    init?(_ from: OpaquePointer?) { fatalError() }
    init?(bitPattern: Int) { fatalError() }
    init?(bitPattern: UInt) { fatalError() }
    init(_ other: Self) { fatalError() }
    init?(_ other: Self?) { fatalError() }
    static func == (lhs: Self, rhs: Self) -> Bool { fatalError() }
    static func == <Other>(lhs: Self, rhs: Other) -> Bool where Other: _Pointer { fatalError() }
    static func != <Other>(lhs: Self, rhs: Other) -> Bool where Other: _Pointer { fatalError() }
    static func < (lhs: Self, rhs: Self) -> Bool { fatalError() }
    static func < <Other>(lhs: Self, rhs: Other) -> Bool where Other: _Pointer { fatalError() }
    static func <= <Other>(lhs: Self, rhs: Other) -> Bool where Other: _Pointer { fatalError() }
    static func > <Other>(lhs: Self, rhs: Other) -> Bool where Other: _Pointer { fatalError() }
    static func >= <Other>(lhs: Self, rhs: Other) -> Bool where Other: _Pointer { fatalError() }
    func successor() -> Self { fatalError() }
    func predecessor() -> Self { fatalError() }
    func distance(to end: Self) -> Int { fatalError() }
    var debugDescription: String { fatalError() }
    typealias Pointee = UInt8
    var hashValue: Int { fatalError() }
    init<T>(_ other: UnsafeMutablePointer<T>) where T: ~Copyable { fatalError() }
    init?<T>(_ other: UnsafeMutablePointer<T>?) where T: ~Copyable { fatalError() }
    init(mutating other: UnsafeRawPointer) { fatalError() }
    init?(mutating other: UnsafeRawPointer?) { fatalError() }
    static func allocate(byteCount: Int, alignment: Int) -> UnsafeMutableRawPointer { fatalError() }
    func deallocate() { fatalError() }
    @discardableResult func bindMemory<T>(to type: T.Type, capacity count: Int)
        -> UnsafeMutablePointer<T> where T: ~Copyable
    { fatalError() }
    func withMemoryRebound<T, E, Result>(
        to type: T.Type, capacity count: Int, _ body: (UnsafeMutablePointer<T>) throws(E) -> Result
    ) throws(E) -> Result where E: Error, T: ~Copyable, Result: ~Copyable { fatalError() }
    func assumingMemoryBound<T>(to: T.Type) -> UnsafeMutablePointer<T> where T: ~Copyable {
        fatalError()
    }
    @discardableResult func initializeMemory<T>(as type: T.Type, to value: consuming T)
        -> UnsafeMutablePointer<T> where T: ~Copyable
    { fatalError() }
    @discardableResult func initializeMemory<T>(
        as type: T.Type, repeating repeatedValue: T, count: Int
    ) -> UnsafeMutablePointer<T> { fatalError() }
    @discardableResult func initializeMemory<T>(
        as type: T.Type, from source: UnsafePointer<T>, count: Int
    ) -> UnsafeMutablePointer<T> { fatalError() }
    @discardableResult func moveInitializeMemory<T>(
        as type: T.Type, from source: UnsafeMutablePointer<T>, count: Int
    ) -> UnsafeMutablePointer<T> where T: ~Copyable { fatalError() }
    func load<T>(fromByteOffset offset: Int = 0, as type: T.Type) -> T where T: ~Escapable {
        fatalError()
    }
    func loadUnaligned<T>(fromByteOffset offset: Int = 0, as type: T.Type) -> T
    where T: BitwiseCopyable, T: ~Escapable { fatalError() }
    func loadUnaligned<T>(fromByteOffset offset: Int = 0, as type: T.Type) -> T { fatalError() }
    func storeBytes<T>(of value: T, toByteOffset offset: Int = 0, as type: T.Type)
    where T: BitwiseCopyable, T: ~Escapable { fatalError() }
    func storeBytes<T>(of value: T, toByteOffset offset: Int = 0, as type: T.Type) { fatalError() }
    func copyMemory(from source: UnsafeRawPointer, byteCount: Int) { fatalError() }
    func advanced(by n: Int) -> UnsafeMutableRawPointer { fatalError() }
    typealias Stride = Int
    func alignedUp<T>(for type: T.Type) -> UnsafeMutableRawPointer
    where T: ~Copyable, T: ~Escapable { fatalError() }
    func alignedDown<T>(for type: T.Type) -> UnsafeMutableRawPointer
    where T: ~Copyable, T: ~Escapable { fatalError() }
    func alignedUp(toMultipleOf alignment: Int) -> UnsafeMutableRawPointer { fatalError() }
    func alignedDown(toMultipleOf alignment: Int) -> UnsafeMutableRawPointer { fatalError() }
    var customPlaygroundQuickLook: _PlaygroundQuickLook { fatalError() }
    static func allocate(bytes size: Int, alignedTo alignment: Int) -> UnsafeMutableRawPointer {
        fatalError()
    }
    func deallocate(bytes _: Int, alignedTo _: Int) { fatalError() }
    func copyBytes(from source: UnsafeRawPointer, count: Int) { fatalError() }
    @discardableResult func initializeMemory<T>(
        as type: T.Type, at offset: Int = 0, count: Int = 1, to repeatedValue: T
    ) -> UnsafeMutablePointer<T> { fatalError() }
    @discardableResult func initializeMemory<C>(as type: C.Element.Type, from source: C)
        -> UnsafeMutablePointer<C.Element> where C: Collection
    { fatalError() }
}

@frozen struct UnsafePointer<Pointee> where Pointee: ~Copyable {
    init(_ from: OpaquePointer) { fatalError() }
    init?(_ from: OpaquePointer?) { fatalError() }
    init?(bitPattern: Int) { fatalError() }
    init?(bitPattern: UInt) { fatalError() }
    init(_ other: Self) { fatalError() }
    init?(_ other: Self?) { fatalError() }
    static func == (lhs: Self, rhs: Self) -> Bool { fatalError() }
    static func == <Other>(lhs: Self, rhs: Other) -> Bool where Other: _Pointer { fatalError() }
    static func != <Other>(lhs: Self, rhs: Other) -> Bool where Other: _Pointer { fatalError() }
    static func < (lhs: Self, rhs: Self) -> Bool { fatalError() }
    static func < <Other>(lhs: Self, rhs: Other) -> Bool where Other: _Pointer { fatalError() }
    static func <= <Other>(lhs: Self, rhs: Other) -> Bool where Other: _Pointer { fatalError() }
    static func > <Other>(lhs: Self, rhs: Other) -> Bool where Other: _Pointer { fatalError() }
    static func >= <Other>(lhs: Self, rhs: Other) -> Bool where Other: _Pointer { fatalError() }
    func successor() -> Self { fatalError() }
    func predecessor() -> Self { fatalError() }
    func distance(to end: Self) -> Int { fatalError() }
    func advanced(by n: Int) -> Self { fatalError() }
    var debugDescription: String { fatalError() }
    typealias Distance = Int
    var hashValue: Int { fatalError() }
    typealias Stride = Int
    func deallocate() { fatalError() }
    var pointee: Pointee { fatalError() }
    subscript(i: Int) -> Pointee { fatalError() }
    func withMemoryRebound<T, E, Result>(
        to type: T.Type, capacity count: Int, _ body: (UnsafePointer<T>) throws(E) -> Result
    ) throws(E) -> Result where E: Error, T: ~Copyable, Result: ~Copyable { fatalError() }
    func pointer<Property>(to property: KeyPath<Pointee, Property>) -> UnsafePointer<Property>? {
        fatalError()
    }
    var customPlaygroundQuickLook: PlaygroundQuickLook { fatalError() }
}

@frozen struct UnsafeRawBufferPointer {
    init(start: UnsafeRawPointer?, count: Int) { fatalError() }
    typealias SubSequence = Slice<UnsafeRawBufferPointer>
    func makeIterator() -> UnsafeRawBufferPointer.Iterator { fatalError() }
    typealias Element = UInt8
    typealias Index = Int
    typealias Indices = Range<Int>
    var startIndex: UnsafeRawBufferPointer.Index { fatalError() }
    var endIndex: UnsafeRawBufferPointer.Index { fatalError() }
    var indices: UnsafeRawBufferPointer.Indices { fatalError() }
    subscript(i: Int) -> UnsafeRawBufferPointer.Element { fatalError() }
    subscript(bounds: Range<Int>) -> UnsafeRawBufferPointer.SubSequence { fatalError() }
    var count: Int { fatalError() }
    func deallocate() { fatalError() }
    func load<T>(fromByteOffset offset: Int = 0, as type: T.Type) -> T { fatalError() }
    func loadUnaligned<T>(fromByteOffset offset: Int = 0, as type: T.Type) -> T
    where T: BitwiseCopyable, T: ~Escapable { fatalError() }
    func loadUnaligned<T>(fromByteOffset offset: Int = 0, as type: T.Type) -> T { fatalError() }
    init(_ bytes: UnsafeMutableRawBufferPointer) { fatalError() }
    init(_ bytes: UnsafeRawBufferPointer) { fatalError() }
    init<T>(_ buffer: UnsafeMutableBufferPointer<T>) where T: ~Copyable { fatalError() }
    init<T>(_ buffer: UnsafeBufferPointer<T>) where T: ~Copyable { fatalError() }
    init(rebasing slice: Slice<UnsafeRawBufferPointer>) { fatalError() }
    init(rebasing slice: Slice<UnsafeMutableRawBufferPointer>) { fatalError() }
    var baseAddress: UnsafeRawPointer? { fatalError() }
    @discardableResult func bindMemory<T>(to type: T.Type) -> UnsafeBufferPointer<T>
    where T: ~Copyable { fatalError() }
    func withMemoryRebound<T, E, Result>(
        to type: T.Type, _ body: (UnsafeBufferPointer<T>) throws(E) -> Result
    ) throws(E) -> Result where E: Error, T: ~Copyable, Result: ~Copyable { fatalError() }
    func assumingMemoryBound<T>(to: T.Type) -> UnsafeBufferPointer<T> where T: ~Copyable {
        fatalError()
    }
    func withContiguousStorageIfAvailable<R>(
        _ body: (UnsafeBufferPointer<UnsafeRawBufferPointer.Element>) throws -> R
    ) rethrows -> R? { fatalError() }
    var bytes: RawSpan { fatalError() }
    func isTriviallyIdentical(to other: UnsafeRawBufferPointer) -> Bool { fatalError() }
    var debugDescription: String { fatalError() }
    @frozen struct Iterator {
        mutating func next() -> UInt8? { fatalError() }
        typealias Element = UInt8
        typealias Iterator = UnsafeRawBufferPointer.Iterator
    }
}

@frozen struct UnsafeRawPointer {
    init<T>(_ other: AutoreleasingUnsafeMutablePointer<T>) { fatalError() }
    init?<T>(_ other: AutoreleasingUnsafeMutablePointer<T>?) { fatalError() }
    init(_ from: OpaquePointer) { fatalError() }
    init?(_ from: OpaquePointer?) { fatalError() }
    init?(bitPattern: Int) { fatalError() }
    init?(bitPattern: UInt) { fatalError() }
    init(_ other: Self) { fatalError() }
    init?(_ other: Self?) { fatalError() }
    static func == (lhs: Self, rhs: Self) -> Bool { fatalError() }
    static func == <Other>(lhs: Self, rhs: Other) -> Bool where Other: _Pointer { fatalError() }
    static func != <Other>(lhs: Self, rhs: Other) -> Bool where Other: _Pointer { fatalError() }
    static func < (lhs: Self, rhs: Self) -> Bool { fatalError() }
    static func < <Other>(lhs: Self, rhs: Other) -> Bool where Other: _Pointer { fatalError() }
    static func <= <Other>(lhs: Self, rhs: Other) -> Bool where Other: _Pointer { fatalError() }
    static func > <Other>(lhs: Self, rhs: Other) -> Bool where Other: _Pointer { fatalError() }
    static func >= <Other>(lhs: Self, rhs: Other) -> Bool where Other: _Pointer { fatalError() }
    func successor() -> Self { fatalError() }
    func predecessor() -> Self { fatalError() }
    func distance(to end: Self) -> Int { fatalError() }
    var debugDescription: String { fatalError() }
    typealias Pointee = UInt8
    var hashValue: Int { fatalError() }
    init<T>(_ other: UnsafePointer<T>) where T: ~Copyable { fatalError() }
    init?<T>(_ other: UnsafePointer<T>?) where T: ~Copyable { fatalError() }
    init(_ other: UnsafeMutableRawPointer) { fatalError() }
    init?(_ other: UnsafeMutableRawPointer?) { fatalError() }
    init<T>(_ other: UnsafeMutablePointer<T>) where T: ~Copyable { fatalError() }
    init?<T>(_ other: UnsafeMutablePointer<T>?) where T: ~Copyable { fatalError() }
    func deallocate() { fatalError() }
    @discardableResult func bindMemory<T>(to type: T.Type, capacity count: Int) -> UnsafePointer<T>
    where T: ~Copyable { fatalError() }
    func withMemoryRebound<T, E, Result>(
        to type: T.Type, capacity count: Int, _ body: (UnsafePointer<T>) throws(E) -> Result
    ) throws(E) -> Result where E: Error, T: ~Copyable, Result: ~Copyable { fatalError() }
    func assumingMemoryBound<T>(to: T.Type) -> UnsafePointer<T> where T: ~Copyable { fatalError() }
    func load<T>(fromByteOffset offset: Int = 0, as type: T.Type) -> T where T: ~Escapable {
        fatalError()
    }
    func loadUnaligned<T>(fromByteOffset offset: Int = 0, as type: T.Type) -> T
    where T: BitwiseCopyable, T: ~Escapable { fatalError() }
    func loadUnaligned<T>(fromByteOffset offset: Int = 0, as type: T.Type) -> T { fatalError() }
    func advanced(by n: Int) -> UnsafeRawPointer { fatalError() }
    typealias Stride = Int
    func alignedUp<T>(for type: T.Type) -> UnsafeRawPointer where T: ~Copyable, T: ~Escapable {
        fatalError()
    }
    func alignedDown<T>(for type: T.Type) -> UnsafeRawPointer where T: ~Copyable, T: ~Escapable {
        fatalError()
    }
    func alignedUp(toMultipleOf alignment: Int) -> UnsafeRawPointer { fatalError() }
    func alignedDown(toMultipleOf alignment: Int) -> UnsafeRawPointer { fatalError() }
    var customPlaygroundQuickLook: _PlaygroundQuickLook { fatalError() }
}

protocol UnsafeSendable: Sendable {
}

protocol UnsignedInteger: BinaryInteger {
    var magnitude: Self { get }
    static var isSigned: Bool { get }
    init<T>(_ source: T) where T: BinaryInteger
    init?<T>(exactly source: T) where T: BinaryInteger
    static var max: Self { get }
    static var min: Self { get }
    func dividingFullWidth(_ dividend: (high: Self, low: Self.Magnitude)) -> (
        quotient: Self, remainder: Self
    )
}

class WritableKeyPath<Root, Value> {
}

@frozen struct Zip2Sequence<Sequence1, Sequence2> where Sequence1: Sequence, Sequence2: Sequence {
    typealias Stream1 = Sequence1.Iterator
    typealias Stream2 = Sequence2.Iterator
    typealias Element = (Sequence1.Element, Sequence2.Element)
    func makeIterator() -> Zip2Sequence<Sequence1, Sequence2>.Iterator { fatalError() }
    var underestimatedCount: Int { fatalError() }
    @frozen struct Iterator {
        typealias Element = (Sequence1.Element, Sequence2.Element)
        mutating func next() -> Zip2Sequence<Sequence1, Sequence2>.Iterator.Element? {
            fatalError()
        }
    }
}

func min<T>(_ x: T, _ y: T) -> T where T: Comparable { fatalError() }
func min<T>(_ x: T, _ y: T, _ z: T, _ rest: T...) -> T where T: Comparable { fatalError() }
func max<T>(_ x: T, _ y: T) -> T where T: Comparable { fatalError() }
func max<T>(_ x: T, _ y: T, _ z: T, _ rest: T...) -> T where T: Comparable { fatalError() }
func assert(
    _ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = String(),
    file: StaticString = #file, line: UInt = #line
) { fatalError() }
func precondition(
    _ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = String(),
    file: StaticString = #file, line: UInt = #line
) { fatalError() }
func assertionFailure(
    _ message: @autoclosure () -> String = String(), file: StaticString = #file, line: UInt = #line
) { fatalError() }
func preconditionFailure(
    _ message: @autoclosure () -> String = String(), file: StaticString = #file, line: UInt = #line
) -> Never { fatalError() }
func fatalError(
    _ message: @autoclosure () -> String = String(), file: StaticString = #file, line: UInt = #line
) -> Never { fatalError() }
func unsafeBitCast<T, U>(_ x: T, to type: U.Type) -> U { fatalError() }
func == (t0: (any (~Copyable & ~Escapable).Type)?, t1: (any (~Copyable & ~Escapable).Type)?) -> Bool
{ fatalError() }
func != (t0: (any (~Copyable & ~Escapable).Type)?, t1: (any (~Copyable & ~Escapable).Type)?) -> Bool
{ fatalError() }
func unsafeDowncast<T>(_ x: AnyObject, to type: T.Type) -> T where T: AnyObject { fatalError() }
func type<T, Metatype>(of value: borrowing T) -> Metatype where T: ~Copyable, T: ~Escapable {
    fatalError()
}
func withoutActuallyEscaping<ClosureType, ResultType, Failure>(
    _ closure: ClosureType, do body: (ClosureType) throws(Failure) -> ResultType
) throws(Failure) -> ResultType where Failure: Error { fatalError() }
typealias Codable = Decodable & Encodable
func == <T>(lhs: T, rhs: T) -> Bool where T: RawRepresentable, T.RawValue: Equatable {
    fatalError()
}
func != <T>(lhs: T, rhs: T) -> Bool where T: RawRepresentable, T.RawValue: Equatable {
    fatalError()
}
func != <T>(lhs: T, rhs: T) -> Bool where T: Equatable, T: RawRepresentable, T.RawValue: Equatable {
    fatalError()
}
typealias ConcurrentValue = Sendable
typealias UnsafeConcurrentValue = UnsafeSendable
typealias CountableClosedRange<Bound> = ClosedRange<Bound>
where Bound: Strideable, Bound.Stride: SignedInteger
typealias CChar = Int8
typealias CUnsignedChar = UInt8
typealias CUnsignedShort = UInt16
typealias CUnsignedInt = UInt32
typealias CUnsignedLong = UInt
typealias CUnsignedLongLong = UInt64
typealias CSignedChar = Int8
typealias CShort = Int16
typealias CInt = Int32
typealias CLong = Int
typealias CLongLong = Int64
typealias CFloat = Float
typealias CDouble = Double
typealias CLongDouble = Float80
typealias CWideChar = Unicode.Scalar
typealias CChar8 = UInt8
typealias CChar16 = UInt16
typealias CChar32 = Unicode.Scalar
typealias CBool = Bool
@attached(member) @attached(memberAttribute) macro DebugDescription()
typealias DictionaryIndex<Key, Value> = Dictionary<Key, Value>.Index where Key: Hashable
typealias DictionaryIterator<Key, Value> = Dictionary<Key, Value>.Iterator where Key: Hashable
typealias LazyDropWhileCollection<T> = LazyDropWhileSequence<T> where T: Collection
@discardableResult func dump<T, TargetStream>(
    _ value: T, to target: inout TargetStream, name: String? = nil, indent: Int = 0,
    maxDepth: Int = .max, maxItems: Int = .max
) -> T where TargetStream: TextOutputStream { fatalError() }
@discardableResult func dump<T>(
    _ value: T, name: String? = nil, indent: Int = 0, maxDepth: Int = .max, maxItems: Int = .max
) -> T { fatalError() }
func === (lhs: AnyObject?, rhs: AnyObject?) -> Bool { fatalError() }
func !== (lhs: AnyObject?, rhs: AnyObject?) -> Bool { fatalError() }
typealias LazyFilterCollection<T> = LazyFilterSequence<T> where T: Collection
typealias FlattenCollection<T> = FlattenSequence<T> where T: Collection, T.Element: Collection
typealias FullyInhabited = ConvertibleFromBytes & ConvertibleToBytes
func bitCast<T, U>(_ original: T, to type: U.Type) -> U
where T: ConvertibleToBytes, U: ConvertibleFromBytes { fatalError() }
func readLine(strippingNewline: Bool = true) -> String? { fatalError() }
func abs<T>(_ x: T) -> T where T: Comparable, T: SignedNumeric { fatalError() }
func numericCast<T, U>(_ x: T) -> U where T: BinaryInteger, U: BinaryInteger { fatalError() }
typealias LazyCollection<T> = LazySequence<T> where T: Collection
func extendLifetime<T>(_ x: borrowing T) where T: ~Copyable, T: ~Escapable { fatalError() }
func withExtendedLifetime<T, E, Result>(_ x: borrowing T, _ body: () throws(E) -> Result) throws(E)
    -> Result where E: Error, T: ~Copyable, T: ~Escapable, Result: ~Copyable
{ fatalError() }
func withExtendedLifetime<T, E, Result>(_ x: borrowing T, _ body: (borrowing T) throws(E) -> Result)
    throws(E) -> Result where E: Error, T: ~Copyable, T: ~Escapable, Result: ~Copyable
{ fatalError() }
func withUnsafeMutablePointer<T, E, Result>(
    to value: inout T, _ body: (UnsafeMutablePointer<T>) throws(E) -> Result
) throws(E) -> Result where E: Error, T: ~Copyable, Result: ~Copyable { fatalError() }
func withUnsafePointer<T, E, Result>(
    to value: borrowing T, _ body: (UnsafePointer<T>) throws(E) -> Result
) throws(E) -> Result where E: Error, T: ~Copyable, Result: ~Copyable { fatalError() }
func withUnsafePointer<T, E, Result>(
    to value: inout T, _ body: (UnsafePointer<T>) throws(E) -> Result
) throws(E) -> Result where E: Error, T: ~Copyable, Result: ~Copyable { fatalError() }
@freestanding(expression) macro externalMacro<T>(module: String, type: String) -> T
@freestanding(expression) macro fileID<T>() -> T where T: ExpressibleByStringLiteral
@freestanding(expression) macro filePath<T>() -> T where T: ExpressibleByStringLiteral
@freestanding(expression) macro file<T>() -> T where T: ExpressibleByStringLiteral
@freestanding(expression) macro function<T>() -> T where T: ExpressibleByStringLiteral
@freestanding(expression) macro line<T>() -> T where T: ExpressibleByIntegerLiteral
@freestanding(expression) macro column<T>() -> T where T: ExpressibleByIntegerLiteral
@freestanding(expression) macro dsohandle() -> UnsafeRawPointer
@freestanding(declaration) macro warning(_ message: String)
@freestanding(declaration) macro error(_ message: String)
func isKnownUniquelyReferenced<T>(_ object: inout T) -> Bool where T: AnyObject { fatalError() }
func isKnownUniquelyReferenced<T>(_ object: inout T?) -> Bool where T: AnyObject { fatalError() }
typealias LazyMapCollection<T, U> = LazyMapSequence<T, U> where T: Collection
func swap<T>(_ a: inout T, _ b: inout T) where T: ~Copyable { fatalError() }
func exchange<T>(_ item: inout T, with newValue: consuming T) -> T where T: ~Copyable {
    fatalError()
}
func ?? <T>(optional: consuming T?, defaultValue: @autoclosure () throws -> T) rethrows -> T
where T: ~Copyable { fatalError() }
func ?? <T>(optional: consuming T?, defaultValue: @autoclosure () throws -> T?) rethrows -> T?
where T: ~Copyable { fatalError() }
typealias Float32 = Float
typealias Float64 = Double
typealias IntegerLiteralType = Int
typealias FloatLiteralType = Double
typealias BooleanLiteralType = Bool
typealias UnicodeScalarType = String
typealias ExtendedGraphemeClusterType = String
typealias StringLiteralType = String
typealias AnyObject = Builtin.AnyObject
typealias AnyClass = any AnyObject.Type
func ~= <T>(a: T, b: T) -> Bool where T: Equatable { fatalError() }
typealias LazyPrefixWhileCollection<T> = LazyPrefixWhileSequence<T> where T: Collection
func print(_ items: Any..., separator: String = " ", terminator: String = "\n") { fatalError() }
func debugPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    fatalError()
}
func print<Target>(
    _ items: Any..., separator: String = " ", terminator: String = "\n", to output: inout Target
) where Target: TextOutputStream { fatalError() }
func debugPrint<Target>(
    _ items: Any..., separator: String = " ", terminator: String = "\n", to output: inout Target
) where Target: TextOutputStream { fatalError() }
typealias UnboundedRange = (UnboundedRange_) -> Void
typealias CountableRange<Bound> = Range<Bound> where Bound: Strideable, Bound.Stride: SignedInteger
typealias CountablePartialRangeFrom<Bound> = PartialRangeFrom<Bound>
where Bound: Strideable, Bound.Stride: SignedInteger
func repeatElement<T>(_ element: T, count n: Int) -> Repeated<T> { fatalError() }
typealias SetIndex<Element> = Set<Element>.Index where Element: Hashable
typealias SetIterator<Element> = Set<Element>.Iterator where Element: Hashable
func stride<T>(from start: T, to end: T, by stride: T.Stride) -> StrideTo<T> where T: Strideable {
    fatalError()
}
func stride<T>(from start: T, through end: T, by stride: T.Stride) -> StrideThrough<T>
where T: Strideable { fatalError() }
func withUnsafeTemporaryAllocation<R, E>(
    byteCount: Int, alignment: Int, _ body: (UnsafeMutableRawBufferPointer) throws(E) -> R
) throws(E) -> R where E: Error, R: ~Copyable { fatalError() }
func withTemporaryAllocation<T, R, E>(
    of type: T.Type, capacity: Int, _ body: (inout OutputSpan<T>) throws(E) -> R
) throws(E) -> R where E: Error, T: ~Copyable, R: ~Copyable { fatalError() }
func withTemporaryAllocation<R, E>(
    byteCount: Int, alignment: Int, _ body: (inout OutputRawSpan) throws(E) -> R
) throws(E) -> R where E: Error, R: ~Copyable { fatalError() }
func withUnsafeTemporaryAllocation<T, R, E>(
    of type: T.Type, capacity: Int, _ body: (UnsafeMutableBufferPointer<T>) throws(E) -> R
) throws(E) -> R where E: Error, T: ~Copyable, R: ~Copyable { fatalError() }
func transcode<Input, InputEncoding, OutputEncoding>(
    _ input: Input, from inputEncoding: InputEncoding.Type, to outputEncoding: OutputEncoding.Type,
    stoppingOnError stopOnError: Bool, into processCodeUnit: (OutputEncoding.CodeUnit) -> Void
) -> Bool
where
    Input: IteratorProtocol, InputEncoding: _UnicodeEncoding, OutputEncoding: _UnicodeEncoding,
    Input.Element == InputEncoding.CodeUnit
{ fatalError() }
typealias BidirectionalIndexable = BidirectionalCollection
typealias IndexableBase = Collection
typealias Indexable = Collection
typealias MutableIndexable = MutableCollection
typealias RandomAccessIndexable = RandomAccessCollection
typealias RangeReplaceableIndexable = RangeReplaceableCollection
typealias EnumeratedIterator<T> = EnumeratedSequence<T>.Iterator where T: Sequence
typealias IteratorOverOne<T> = CollectionOfOne<T>.Iterator
typealias EmptyIterator<T> = EmptyCollection<T>.Iterator
typealias LazyFilterIterator<T> = LazyFilterSequence<T>.Iterator where T: Sequence
typealias LazyFilterIndex<Base> = Base.Index where Base: Collection
typealias LazyDropWhileIterator<T> = LazyDropWhileSequence<T>.Iterator where T: Sequence
typealias LazyDropWhileIndex<T> = LazyDropWhileCollection<T>.Index where T: Collection
typealias LazyDropWhileBidirectionalCollection<T> = LazyDropWhileCollection<T>
where T: BidirectionalCollection
typealias LazyFilterBidirectionalCollection<T> = LazyFilterCollection<T>
where T: BidirectionalCollection
typealias LazyMapIterator<T, E> = LazyMapSequence<T, E>.Iterator where T: Sequence
typealias LazyMapBidirectionalCollection<T, E> = LazyMapCollection<T, E>
where T: BidirectionalCollection
typealias LazyMapRandomAccessCollection<T, E> = LazyMapCollection<T, E>
where T: RandomAccessCollection
typealias LazyBidirectionalCollection<T> = LazyCollection<T> where T: BidirectionalCollection
typealias LazyRandomAccessCollection<T> = LazyCollection<T> where T: RandomAccessCollection
typealias FlattenCollectionIndex<T> = FlattenCollection<T>.Index
where T: Collection, T.Element: Collection
typealias FlattenBidirectionalCollectionIndex<T> = FlattenCollection<T>.Index
where T: BidirectionalCollection, T.Element: BidirectionalCollection
typealias FlattenBidirectionalCollection<T> = FlattenCollection<T>
where T: BidirectionalCollection, T.Element: BidirectionalCollection
typealias JoinedIterator<T> = JoinedSequence<T>.Iterator where T: Sequence, T.Element: Sequence
typealias Zip2Iterator<T, U> = Zip2Sequence<T, U>.Iterator where T: Sequence, U: Sequence
typealias LazyPrefixWhileIterator<T> = LazyPrefixWhileSequence<T>.Iterator where T: Sequence
typealias LazyPrefixWhileIndex<T> = LazyPrefixWhileCollection<T>.Index where T: Collection
typealias LazyPrefixWhileBidirectionalCollection<T> = LazyPrefixWhileCollection<T>
where T: BidirectionalCollection
typealias ReversedRandomAccessCollection<T> = ReversedCollection<T> where T: RandomAccessCollection
typealias ReversedIndex<T> = ReversedCollection<T>.Index where T: BidirectionalCollection
typealias BidirectionalSlice<T> = Slice<T> where T: BidirectionalCollection
typealias RandomAccessSlice<T> = Slice<T> where T: RandomAccessCollection
typealias RangeReplaceableSlice<T> = Slice<T> where T: RangeReplaceableCollection
typealias RangeReplaceableBidirectionalSlice<T> = Slice<T>
where T: BidirectionalCollection, T: RangeReplaceableCollection
typealias RangeReplaceableRandomAccessSlice<T> = Slice<T>
where T: RandomAccessCollection, T: RangeReplaceableCollection
typealias MutableSlice<T> = Slice<T> where T: MutableCollection
typealias MutableBidirectionalSlice<T> = Slice<T>
where T: BidirectionalCollection, T: MutableCollection
typealias MutableRandomAccessSlice<T> = Slice<T>
where T: MutableCollection, T: RandomAccessCollection
typealias MutableRangeReplaceableSlice<T> = Slice<T>
where T: MutableCollection, T: RangeReplaceableCollection
typealias MutableRangeReplaceableBidirectionalSlice<T> = Slice<T>
where T: BidirectionalCollection, T: MutableCollection, T: RangeReplaceableCollection
typealias MutableRangeReplaceableRandomAccessSlice<T> = Slice<T>
where T: MutableCollection, T: RandomAccessCollection, T: RangeReplaceableCollection
typealias DefaultBidirectionalIndices<T> = DefaultIndices<T> where T: BidirectionalCollection
typealias DefaultRandomAccessIndices<T> = DefaultIndices<T> where T: RandomAccessCollection
typealias NilLiteralConvertible = ExpressibleByNilLiteral
typealias IntegerLiteralConvertible = ExpressibleByIntegerLiteral
typealias FloatLiteralConvertible = ExpressibleByFloatLiteral
typealias BooleanLiteralConvertible = ExpressibleByBooleanLiteral
typealias UnicodeScalarLiteralConvertible = ExpressibleByUnicodeScalarLiteral
typealias ExtendedGraphemeClusterLiteralConvertible = ExpressibleByExtendedGraphemeClusterLiteral
typealias StringLiteralConvertible = ExpressibleByStringLiteral
typealias ArrayLiteralConvertible = ExpressibleByArrayLiteral
typealias DictionaryLiteralConvertible = ExpressibleByDictionaryLiteral
typealias StringInterpolationConvertible = ExpressibleByStringInterpolation
typealias ClosedRangeIndex<T> = ClosedRange<T>.Index where T: Strideable, T.Stride: SignedInteger
typealias DictionaryLiteral<Key, Value> = KeyValuePairs<Key, Value>
typealias UTF8 = Unicode.UTF8
typealias UTF16 = Unicode.UTF16
typealias UTF32 = Unicode.UTF32
typealias UnicodeScalar = Unicode.Scalar
typealias UnsafeBufferPointerIterator<T> = UnsafeBufferPointer<T>.Iterator
typealias UnsafeRawBufferPointerIterator<T> = UnsafeBufferPointer<T>.Iterator
typealias UnsafeMutableRawBufferPointerIterator<T> = UnsafeBufferPointer<T>.Iterator
typealias PlaygroundQuickLook = Any
typealias CustomPlaygroundQuickLookable = _CustomPlaygroundQuickLookable
func sequence<T>(first: T, next: @escaping (T) -> T?) -> UnfoldFirstSequence<T> { fatalError() }
func sequence<T, State>(state: State, next: @escaping (inout State) -> T?) -> UnfoldSequence<
    T, State
> { fatalError() }
typealias UnfoldFirstSequence<T> = UnfoldSequence<T, (T?, Bool)>
func withVaList<R>(_ args: [any CVarArg], _ body: (CVaListPointer) -> R) -> R { fatalError() }
func getVaList(_ args: [any CVarArg]) -> CVaListPointer { fatalError() }
func zip<Sequence1, Sequence2>(_ sequence1: Sequence1, _ sequence2: Sequence2) -> Zip2Sequence<
    Sequence1, Sequence2
> where Sequence1: Sequence, Sequence2: Sequence { fatalError() }
func withUnsafeMutableBytes<T, E, Result>(
    of value: inout T, _ body: (UnsafeMutableRawBufferPointer) throws(E) -> Result
) throws(E) -> Result where E: Error, T: ~Copyable, T: ~Escapable, Result: ~Copyable {
    fatalError()
}
func withUnsafeBytes<T, E, Result>(
    of value: inout T, _ body: (UnsafeRawBufferPointer) throws(E) -> Result
) throws(E) -> Result where E: Error, T: ~Copyable, T: ~Escapable, Result: ~Copyable {
    fatalError()
}
func withUnsafeBytes<T, E, Result>(
    of value: borrowing T, _ body: (UnsafeRawBufferPointer) throws(E) -> Result
) throws(E) -> Result where E: Error, T: ~Copyable, Result: ~Copyable { fatalError() }
func == (lhs: (), rhs: ()) -> Bool { fatalError() }
func != (lhs: (), rhs: ()) -> Bool { fatalError() }
func < (lhs: (), rhs: ()) -> Bool { fatalError() }
func <= (lhs: (), rhs: ()) -> Bool { fatalError() }
func > (lhs: (), rhs: ()) -> Bool { fatalError() }
func >= (lhs: (), rhs: ()) -> Bool { fatalError() }
func == <A, B>(lhs: (A, B), rhs: (A, B)) -> Bool where A: Equatable, B: Equatable { fatalError() }
func != <A, B>(lhs: (A, B), rhs: (A, B)) -> Bool where A: Equatable, B: Equatable { fatalError() }
func < <A, B>(lhs: (A, B), rhs: (A, B)) -> Bool where A: Comparable, B: Comparable { fatalError() }
func <= <A, B>(lhs: (A, B), rhs: (A, B)) -> Bool where A: Comparable, B: Comparable { fatalError() }
func > <A, B>(lhs: (A, B), rhs: (A, B)) -> Bool where A: Comparable, B: Comparable { fatalError() }
func >= <A, B>(lhs: (A, B), rhs: (A, B)) -> Bool where A: Comparable, B: Comparable { fatalError() }
func == <A, B, C>(lhs: (A, B, C), rhs: (A, B, C)) -> Bool
where A: Equatable, B: Equatable, C: Equatable { fatalError() }
func != <A, B, C>(lhs: (A, B, C), rhs: (A, B, C)) -> Bool
where A: Equatable, B: Equatable, C: Equatable { fatalError() }
func < <A, B, C>(lhs: (A, B, C), rhs: (A, B, C)) -> Bool
where A: Comparable, B: Comparable, C: Comparable { fatalError() }
func <= <A, B, C>(lhs: (A, B, C), rhs: (A, B, C)) -> Bool
where A: Comparable, B: Comparable, C: Comparable { fatalError() }
func > <A, B, C>(lhs: (A, B, C), rhs: (A, B, C)) -> Bool
where A: Comparable, B: Comparable, C: Comparable { fatalError() }
func >= <A, B, C>(lhs: (A, B, C), rhs: (A, B, C)) -> Bool
where A: Comparable, B: Comparable, C: Comparable { fatalError() }
func == <A, B, C, D>(lhs: (A, B, C, D), rhs: (A, B, C, D)) -> Bool
where A: Equatable, B: Equatable, C: Equatable, D: Equatable { fatalError() }
func != <A, B, C, D>(lhs: (A, B, C, D), rhs: (A, B, C, D)) -> Bool
where A: Equatable, B: Equatable, C: Equatable, D: Equatable { fatalError() }
func < <A, B, C, D>(lhs: (A, B, C, D), rhs: (A, B, C, D)) -> Bool
where A: Comparable, B: Comparable, C: Comparable, D: Comparable { fatalError() }
func <= <A, B, C, D>(lhs: (A, B, C, D), rhs: (A, B, C, D)) -> Bool
where A: Comparable, B: Comparable, C: Comparable, D: Comparable { fatalError() }
func > <A, B, C, D>(lhs: (A, B, C, D), rhs: (A, B, C, D)) -> Bool
where A: Comparable, B: Comparable, C: Comparable, D: Comparable { fatalError() }
func >= <A, B, C, D>(lhs: (A, B, C, D), rhs: (A, B, C, D)) -> Bool
where A: Comparable, B: Comparable, C: Comparable, D: Comparable { fatalError() }
func == <A, B, C, D, E>(lhs: (A, B, C, D, E), rhs: (A, B, C, D, E)) -> Bool
where A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable { fatalError() }
func != <A, B, C, D, E>(lhs: (A, B, C, D, E), rhs: (A, B, C, D, E)) -> Bool
where A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable { fatalError() }
func < <A, B, C, D, E>(lhs: (A, B, C, D, E), rhs: (A, B, C, D, E)) -> Bool
where A: Comparable, B: Comparable, C: Comparable, D: Comparable, E: Comparable { fatalError() }
func <= <A, B, C, D, E>(lhs: (A, B, C, D, E), rhs: (A, B, C, D, E)) -> Bool
where A: Comparable, B: Comparable, C: Comparable, D: Comparable, E: Comparable { fatalError() }
func > <A, B, C, D, E>(lhs: (A, B, C, D, E), rhs: (A, B, C, D, E)) -> Bool
where A: Comparable, B: Comparable, C: Comparable, D: Comparable, E: Comparable { fatalError() }
func >= <A, B, C, D, E>(lhs: (A, B, C, D, E), rhs: (A, B, C, D, E)) -> Bool
where A: Comparable, B: Comparable, C: Comparable, D: Comparable, E: Comparable { fatalError() }
func == <A, B, C, D, E, F>(lhs: (A, B, C, D, E, F), rhs: (A, B, C, D, E, F)) -> Bool
where A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable, F: Equatable {
    fatalError()
}
func != <A, B, C, D, E, F>(lhs: (A, B, C, D, E, F), rhs: (A, B, C, D, E, F)) -> Bool
where A: Equatable, B: Equatable, C: Equatable, D: Equatable, E: Equatable, F: Equatable {
    fatalError()
}
func < <A, B, C, D, E, F>(lhs: (A, B, C, D, E, F), rhs: (A, B, C, D, E, F)) -> Bool
where A: Comparable, B: Comparable, C: Comparable, D: Comparable, E: Comparable, F: Comparable {
    fatalError()
}
func <= <A, B, C, D, E, F>(lhs: (A, B, C, D, E, F), rhs: (A, B, C, D, E, F)) -> Bool
where A: Comparable, B: Comparable, C: Comparable, D: Comparable, E: Comparable, F: Comparable {
    fatalError()
}
func > <A, B, C, D, E, F>(lhs: (A, B, C, D, E, F), rhs: (A, B, C, D, E, F)) -> Bool
where A: Comparable, B: Comparable, C: Comparable, D: Comparable, E: Comparable, F: Comparable {
    fatalError()
}
func >= <A, B, C, D, E, F>(lhs: (A, B, C, D, E, F), rhs: (A, B, C, D, E, F)) -> Bool
where A: Comparable, B: Comparable, C: Comparable, D: Comparable, E: Comparable, F: Comparable {
    fatalError()
}
func any<Storage>(_ mask: SIMDMask<Storage>) -> Bool
where Storage: SIMD, Storage.Scalar: FixedWidthInteger, Storage.Scalar: SignedInteger {
    fatalError()
}
func all<Storage>(_ mask: SIMDMask<Storage>) -> Bool
where Storage: SIMD, Storage.Scalar: FixedWidthInteger, Storage.Scalar: SignedInteger {
    fatalError()
}
func pointwiseMin<T>(_ a: T, _ b: T) -> T where T: SIMD, T.Scalar: Comparable { fatalError() }
func pointwiseMax<T>(_ a: T, _ b: T) -> T where T: SIMD, T.Scalar: Comparable { fatalError() }
func pointwiseMin<T>(_ a: T, _ b: T) -> T where T: SIMD, T.Scalar: FloatingPoint { fatalError() }
func pointwiseMax<T>(_ a: T, _ b: T) -> T where T: SIMD, T.Scalar: FloatingPoint { fatalError() }

// Compiler intrinsic namespace and types.
enum Builtin {
    struct AnyObject {}
    struct Borrow {}
    struct BridgeObject {}
    struct FPIEEE32 {}
    struct FPIEEE64 {}
    struct FPIEEE80 {}
    struct Int1 {}
    struct Int128 {}
    struct Int16 {}
    struct Int32 {}
    struct Int64 {}
    struct Int8 {}
    struct IntLiteral {}
    struct NativeObject {}
    struct RawPointer {}
    struct Vec16xFPIEEE32 {}
    struct Vec16xFPIEEE64 {}
    struct Vec16xInt1 {}
    struct Vec16xInt16 {}
    struct Vec16xInt32 {}
    struct Vec16xInt64 {}
    struct Vec16xInt8 {}
    struct Vec2xFPIEEE32 {}
    struct Vec2xFPIEEE64 {}
    struct Vec2xInt1 {}
    struct Vec2xInt16 {}
    struct Vec2xInt32 {}
    struct Vec2xInt64 {}
    struct Vec2xInt8 {}
    struct Vec32xFPIEEE32 {}
    struct Vec32xFPIEEE64 {}
    struct Vec32xInt1 {}
    struct Vec32xInt16 {}
    struct Vec32xInt32 {}
    struct Vec32xInt64 {}
    struct Vec32xInt8 {}
    struct Vec4xFPIEEE32 {}
    struct Vec4xFPIEEE64 {}
    struct Vec4xInt1 {}
    struct Vec4xInt16 {}
    struct Vec4xInt32 {}
    struct Vec4xInt64 {}
    struct Vec4xInt8 {}
    struct Vec64xFPIEEE32 {}
    struct Vec64xFPIEEE64 {}
    struct Vec64xInt1 {}
    struct Vec64xInt16 {}
    struct Vec64xInt32 {}
    struct Vec64xInt64 {}
    struct Vec64xInt8 {}
    struct Vec8xFPIEEE32 {}
    struct Vec8xFPIEEE64 {}
    struct Vec8xInt1 {}
    struct Vec8xInt16 {}
    struct Vec8xInt32 {}
    struct Vec8xInt64 {}
    struct Vec8xInt8 {}
    struct Word {}
    static func COWBufferForReading<T>(_: T) -> T where T: ~Copyable { fatalError() }
    static func add_Vec16xInt16(_: Builtin.Vec16xInt16, _: Builtin.Vec16xInt16)
        -> Builtin.Vec16xInt16
    { fatalError() }
    static func add_Vec16xInt32(_: Builtin.Vec16xInt32, _: Builtin.Vec16xInt32)
        -> Builtin.Vec16xInt32
    { fatalError() }
    static func add_Vec16xInt64(_: Builtin.Vec16xInt64, _: Builtin.Vec16xInt64)
        -> Builtin.Vec16xInt64
    { fatalError() }
    static func add_Vec16xInt8(_: Builtin.Vec16xInt8, _: Builtin.Vec16xInt8) -> Builtin.Vec16xInt8 {
        fatalError()
    }
    static func add_Vec2xInt16(_: Builtin.Vec2xInt16, _: Builtin.Vec2xInt16) -> Builtin.Vec2xInt16 {
        fatalError()
    }
    static func add_Vec2xInt32(_: Builtin.Vec2xInt32, _: Builtin.Vec2xInt32) -> Builtin.Vec2xInt32 {
        fatalError()
    }
    static func add_Vec2xInt64(_: Builtin.Vec2xInt64, _: Builtin.Vec2xInt64) -> Builtin.Vec2xInt64 {
        fatalError()
    }
    static func add_Vec2xInt8(_: Builtin.Vec2xInt8, _: Builtin.Vec2xInt8) -> Builtin.Vec2xInt8 {
        fatalError()
    }
    static func add_Vec32xInt16(_: Builtin.Vec32xInt16, _: Builtin.Vec32xInt16)
        -> Builtin.Vec32xInt16
    { fatalError() }
    static func add_Vec32xInt32(_: Builtin.Vec32xInt32, _: Builtin.Vec32xInt32)
        -> Builtin.Vec32xInt32
    { fatalError() }
    static func add_Vec32xInt64(_: Builtin.Vec32xInt64, _: Builtin.Vec32xInt64)
        -> Builtin.Vec32xInt64
    { fatalError() }
    static func add_Vec32xInt8(_: Builtin.Vec32xInt8, _: Builtin.Vec32xInt8) -> Builtin.Vec32xInt8 {
        fatalError()
    }
    static func add_Vec4xInt16(_: Builtin.Vec4xInt16, _: Builtin.Vec4xInt16) -> Builtin.Vec4xInt16 {
        fatalError()
    }
    static func add_Vec4xInt32(_: Builtin.Vec4xInt32, _: Builtin.Vec4xInt32) -> Builtin.Vec4xInt32 {
        fatalError()
    }
    static func add_Vec4xInt64(_: Builtin.Vec4xInt64, _: Builtin.Vec4xInt64) -> Builtin.Vec4xInt64 {
        fatalError()
    }
    static func add_Vec4xInt8(_: Builtin.Vec4xInt8, _: Builtin.Vec4xInt8) -> Builtin.Vec4xInt8 {
        fatalError()
    }
    static func add_Vec64xInt16(_: Builtin.Vec64xInt16, _: Builtin.Vec64xInt16)
        -> Builtin.Vec64xInt16
    { fatalError() }
    static func add_Vec64xInt32(_: Builtin.Vec64xInt32, _: Builtin.Vec64xInt32)
        -> Builtin.Vec64xInt32
    { fatalError() }
    static func add_Vec64xInt64(_: Builtin.Vec64xInt64, _: Builtin.Vec64xInt64)
        -> Builtin.Vec64xInt64
    { fatalError() }
    static func add_Vec64xInt8(_: Builtin.Vec64xInt8, _: Builtin.Vec64xInt8) -> Builtin.Vec64xInt8 {
        fatalError()
    }
    static func add_Vec8xInt16(_: Builtin.Vec8xInt16, _: Builtin.Vec8xInt16) -> Builtin.Vec8xInt16 {
        fatalError()
    }
    static func add_Vec8xInt32(_: Builtin.Vec8xInt32, _: Builtin.Vec8xInt32) -> Builtin.Vec8xInt32 {
        fatalError()
    }
    static func add_Vec8xInt64(_: Builtin.Vec8xInt64, _: Builtin.Vec8xInt64) -> Builtin.Vec8xInt64 {
        fatalError()
    }
    static func add_Vec8xInt8(_: Builtin.Vec8xInt8, _: Builtin.Vec8xInt8) -> Builtin.Vec8xInt8 {
        fatalError()
    }
    static func addressOfBorrow<T>(_: T) -> Builtin.RawPointer where T: ~Copyable, T: ~Escapable {
        fatalError()
    }
    static func addressof<T>(_: inout T) -> Builtin.RawPointer where T: ~Copyable, T: ~Escapable {
        fatalError()
    }
    static func alignof<T>(_: T.Type) -> Builtin.Word where T: ~Copyable, T: ~Escapable {
        fatalError()
    }
    static func allocRaw(_: Builtin.Word, _: Builtin.Word) -> Builtin.RawPointer { fatalError() }
    static func allocWithTailElems_1<T, U>(_: T.Type, _: Builtin.Word, _: U.Type) -> T
    where T: ~Copyable, U: ~Copyable, U: ~Escapable { fatalError() }
    static func and_Int128(_: Builtin.Int128, _: Builtin.Int128) -> Builtin.Int128 { fatalError() }
    static func and_Int16(_: Builtin.Int16, _: Builtin.Int16) -> Builtin.Int16 { fatalError() }
    static func and_Int32(_: Builtin.Int32, _: Builtin.Int32) -> Builtin.Int32 { fatalError() }
    static func and_Int64(_: Builtin.Int64, _: Builtin.Int64) -> Builtin.Int64 { fatalError() }
    static func and_Int8(_: Builtin.Int8, _: Builtin.Int8) -> Builtin.Int8 { fatalError() }
    static func and_Vec16xInt16(_: Builtin.Vec16xInt16, _: Builtin.Vec16xInt16)
        -> Builtin.Vec16xInt16
    { fatalError() }
    static func and_Vec16xInt32(_: Builtin.Vec16xInt32, _: Builtin.Vec16xInt32)
        -> Builtin.Vec16xInt32
    { fatalError() }
    static func and_Vec16xInt64(_: Builtin.Vec16xInt64, _: Builtin.Vec16xInt64)
        -> Builtin.Vec16xInt64
    { fatalError() }
    static func and_Vec16xInt8(_: Builtin.Vec16xInt8, _: Builtin.Vec16xInt8) -> Builtin.Vec16xInt8 {
        fatalError()
    }
    static func and_Vec2xInt16(_: Builtin.Vec2xInt16, _: Builtin.Vec2xInt16) -> Builtin.Vec2xInt16 {
        fatalError()
    }
    static func and_Vec2xInt32(_: Builtin.Vec2xInt32, _: Builtin.Vec2xInt32) -> Builtin.Vec2xInt32 {
        fatalError()
    }
    static func and_Vec2xInt64(_: Builtin.Vec2xInt64, _: Builtin.Vec2xInt64) -> Builtin.Vec2xInt64 {
        fatalError()
    }
    static func and_Vec2xInt8(_: Builtin.Vec2xInt8, _: Builtin.Vec2xInt8) -> Builtin.Vec2xInt8 {
        fatalError()
    }
    static func and_Vec32xInt16(_: Builtin.Vec32xInt16, _: Builtin.Vec32xInt16)
        -> Builtin.Vec32xInt16
    { fatalError() }
    static func and_Vec32xInt32(_: Builtin.Vec32xInt32, _: Builtin.Vec32xInt32)
        -> Builtin.Vec32xInt32
    { fatalError() }
    static func and_Vec32xInt64(_: Builtin.Vec32xInt64, _: Builtin.Vec32xInt64)
        -> Builtin.Vec32xInt64
    { fatalError() }
    static func and_Vec32xInt8(_: Builtin.Vec32xInt8, _: Builtin.Vec32xInt8) -> Builtin.Vec32xInt8 {
        fatalError()
    }
    static func and_Vec4xInt16(_: Builtin.Vec4xInt16, _: Builtin.Vec4xInt16) -> Builtin.Vec4xInt16 {
        fatalError()
    }
    static func and_Vec4xInt32(_: Builtin.Vec4xInt32, _: Builtin.Vec4xInt32) -> Builtin.Vec4xInt32 {
        fatalError()
    }
    static func and_Vec4xInt64(_: Builtin.Vec4xInt64, _: Builtin.Vec4xInt64) -> Builtin.Vec4xInt64 {
        fatalError()
    }
    static func and_Vec4xInt8(_: Builtin.Vec4xInt8, _: Builtin.Vec4xInt8) -> Builtin.Vec4xInt8 {
        fatalError()
    }
    static func and_Vec64xInt16(_: Builtin.Vec64xInt16, _: Builtin.Vec64xInt16)
        -> Builtin.Vec64xInt16
    { fatalError() }
    static func and_Vec64xInt32(_: Builtin.Vec64xInt32, _: Builtin.Vec64xInt32)
        -> Builtin.Vec64xInt32
    { fatalError() }
    static func and_Vec64xInt64(_: Builtin.Vec64xInt64, _: Builtin.Vec64xInt64)
        -> Builtin.Vec64xInt64
    { fatalError() }
    static func and_Vec64xInt8(_: Builtin.Vec64xInt8, _: Builtin.Vec64xInt8) -> Builtin.Vec64xInt8 {
        fatalError()
    }
    static func and_Vec8xInt16(_: Builtin.Vec8xInt16, _: Builtin.Vec8xInt16) -> Builtin.Vec8xInt16 {
        fatalError()
    }
    static func and_Vec8xInt32(_: Builtin.Vec8xInt32, _: Builtin.Vec8xInt32) -> Builtin.Vec8xInt32 {
        fatalError()
    }
    static func and_Vec8xInt64(_: Builtin.Vec8xInt64, _: Builtin.Vec8xInt64) -> Builtin.Vec8xInt64 {
        fatalError()
    }
    static func and_Vec8xInt8(_: Builtin.Vec8xInt8, _: Builtin.Vec8xInt8) -> Builtin.Vec8xInt8 {
        fatalError()
    }
    static func ashr_Int128(_: Builtin.Int128, _: Builtin.Int128) -> Builtin.Int128 { fatalError() }
    static func ashr_Int16(_: Builtin.Int16, _: Builtin.Int16) -> Builtin.Int16 { fatalError() }
    static func ashr_Int32(_: Builtin.Int32, _: Builtin.Int32) -> Builtin.Int32 { fatalError() }
    static func ashr_Int64(_: Builtin.Int64, _: Builtin.Int64) -> Builtin.Int64 { fatalError() }
    static func ashr_Int8(_: Builtin.Int8, _: Builtin.Int8) -> Builtin.Int8 { fatalError() }
    static func assert_configuration() -> Builtin.Int32 { fatalError() }
    static func assignCopyArrayBackToFront<T>(
        _: T.Type, _: Builtin.RawPointer, _: Builtin.RawPointer, _: Builtin.Word
    ) where T: ~Escapable { fatalError() }
    static func assignCopyArrayFrontToBack<T>(
        _: T.Type, _: Builtin.RawPointer, _: Builtin.RawPointer, _: Builtin.Word
    ) where T: ~Escapable { fatalError() }
    static func assignTakeArray<T>(
        _: T.Type, _: Builtin.RawPointer, _: Builtin.RawPointer, _: Builtin.Word
    ) where T: ~Copyable, T: ~Escapable { fatalError() }
    static func assumeAlignment(_: Builtin.RawPointer, _: Builtin.Word) -> Builtin.RawPointer {
        fatalError()
    }
    static func assumeNonNegative_Int16(_: Builtin.Int16) -> Builtin.Int16 { fatalError() }
    static func assumeNonNegative_Int32(_: Builtin.Int32) -> Builtin.Int32 { fatalError() }
    static func assumeNonNegative_Int64(_: Builtin.Int64) -> Builtin.Int64 { fatalError() }
    static func assumeNonNegative_Int8(_: Builtin.Int8) -> Builtin.Int8 { fatalError() }
    static func assume_Int1(_: Builtin.Int1) -> Builtin.Int1 { fatalError() }
    static func atomicload_acquire_Word(_: Builtin.RawPointer) -> Builtin.Word { fatalError() }
    static func atomicload_seqcst_Word(_: Builtin.RawPointer) -> Builtin.Word { fatalError() }
    static func autorelease<T>(_: T) where T: ~Escapable { fatalError() }
    static func beginCOWMutation<T>(_: inout T) -> Builtin.Int1 where T: ~Copyable, T: ~Escapable {
        fatalError()
    }
    static func beginCOWMutation_native<T>(_: inout T) -> Builtin.Int1
    where T: ~Copyable, T: ~Escapable { fatalError() }
    static func bindMemory<T>(_: Builtin.RawPointer, _: Builtin.Word, _: T.Type) -> Builtin.Word
    where T: ~Copyable, T: ~Escapable { fatalError() }
    static func bitWidth_IntLiteral(_: Builtin.IntLiteral) -> Builtin.Word { fatalError() }
    static func bitcast_FPIEEE32_Int32(_: Builtin.FPIEEE32) -> Builtin.Int32 { fatalError() }
    static func bitcast_FPIEEE64_Int64(_: Builtin.FPIEEE64) -> Builtin.Int64 { fatalError() }
    static func bitcast_Int32_FPIEEE32(_: Builtin.Int32) -> Builtin.FPIEEE32 { fatalError() }
    static func bitcast_Int64_FPIEEE64(_: Builtin.Int64) -> Builtin.FPIEEE64 { fatalError() }
    static func bridgeFromRawPointer<T>(_: Builtin.RawPointer) -> T { fatalError() }
    static func bridgeToRawPointer<T>(_: T) -> Builtin.RawPointer { fatalError() }
    static func canBeClass<T>(_: T.Type) -> Builtin.Int8 where T: ~Copyable, T: ~Escapable {
        fatalError()
    }
    static func castBitPatternFromBridgeObject(_: Builtin.BridgeObject) -> Builtin.Word {
        fatalError()
    }
    static func castFromNativeObject<T>(_: __owned Builtin.NativeObject) -> T { fatalError() }
    static func castReference<T, U>(_: __owned T) -> U
    where T: ~Copyable, T: ~Escapable, U: ~Copyable { fatalError() }
    static func castReferenceFromBridgeObject<T>(_: __owned Builtin.BridgeObject) -> T {
        fatalError()
    }
    static func castToBridgeObject<T>(_: __owned T, _: Builtin.Word) -> Builtin.BridgeObject {
        fatalError()
    }
    static func castToNativeObject<T>(_: __owned T) -> Builtin.NativeObject { fatalError() }
    static func classifyBridgeObject(_: Builtin.BridgeObject) -> (
        isObjCObject: Builtin.Int1, isObjCTaggedPointer: Builtin.Int1
    ) { fatalError() }
    static func cmp_eq_Int1(_: Builtin.Int1, _: Builtin.Int1) -> Builtin.Int1 { fatalError() }
    static func cmp_eq_Int128(_: Builtin.Int128, _: Builtin.Int128) -> Builtin.Int1 { fatalError() }
    static func cmp_eq_Int16(_: Builtin.Int16, _: Builtin.Int16) -> Builtin.Int1 { fatalError() }
    static func cmp_eq_Int32(_: Builtin.Int32, _: Builtin.Int32) -> Builtin.Int1 { fatalError() }
    static func cmp_eq_Int64(_: Builtin.Int64, _: Builtin.Int64) -> Builtin.Int1 { fatalError() }
    static func cmp_eq_Int8(_: Builtin.Int8, _: Builtin.Int8) -> Builtin.Int1 { fatalError() }
    static func cmp_eq_RawPointer(_: Builtin.RawPointer, _: Builtin.RawPointer) -> Builtin.Int1 {
        fatalError()
    }
    static func cmp_eq_Vec16xInt16(_: Builtin.Vec16xInt16, _: Builtin.Vec16xInt16)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_eq_Vec16xInt32(_: Builtin.Vec16xInt32, _: Builtin.Vec16xInt32)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_eq_Vec16xInt64(_: Builtin.Vec16xInt64, _: Builtin.Vec16xInt64)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_eq_Vec16xInt8(_: Builtin.Vec16xInt8, _: Builtin.Vec16xInt8)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_eq_Vec2xInt16(_: Builtin.Vec2xInt16, _: Builtin.Vec2xInt16) -> Builtin.Vec2xInt1
    { fatalError() }
    static func cmp_eq_Vec2xInt32(_: Builtin.Vec2xInt32, _: Builtin.Vec2xInt32) -> Builtin.Vec2xInt1
    { fatalError() }
    static func cmp_eq_Vec2xInt64(_: Builtin.Vec2xInt64, _: Builtin.Vec2xInt64) -> Builtin.Vec2xInt1
    { fatalError() }
    static func cmp_eq_Vec2xInt8(_: Builtin.Vec2xInt8, _: Builtin.Vec2xInt8) -> Builtin.Vec2xInt1 {
        fatalError()
    }
    static func cmp_eq_Vec32xInt16(_: Builtin.Vec32xInt16, _: Builtin.Vec32xInt16)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_eq_Vec32xInt32(_: Builtin.Vec32xInt32, _: Builtin.Vec32xInt32)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_eq_Vec32xInt64(_: Builtin.Vec32xInt64, _: Builtin.Vec32xInt64)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_eq_Vec32xInt8(_: Builtin.Vec32xInt8, _: Builtin.Vec32xInt8)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_eq_Vec4xInt16(_: Builtin.Vec4xInt16, _: Builtin.Vec4xInt16) -> Builtin.Vec4xInt1
    { fatalError() }
    static func cmp_eq_Vec4xInt32(_: Builtin.Vec4xInt32, _: Builtin.Vec4xInt32) -> Builtin.Vec4xInt1
    { fatalError() }
    static func cmp_eq_Vec4xInt64(_: Builtin.Vec4xInt64, _: Builtin.Vec4xInt64) -> Builtin.Vec4xInt1
    { fatalError() }
    static func cmp_eq_Vec4xInt8(_: Builtin.Vec4xInt8, _: Builtin.Vec4xInt8) -> Builtin.Vec4xInt1 {
        fatalError()
    }
    static func cmp_eq_Vec64xInt16(_: Builtin.Vec64xInt16, _: Builtin.Vec64xInt16)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_eq_Vec64xInt32(_: Builtin.Vec64xInt32, _: Builtin.Vec64xInt32)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_eq_Vec64xInt64(_: Builtin.Vec64xInt64, _: Builtin.Vec64xInt64)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_eq_Vec64xInt8(_: Builtin.Vec64xInt8, _: Builtin.Vec64xInt8)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_eq_Vec8xInt16(_: Builtin.Vec8xInt16, _: Builtin.Vec8xInt16) -> Builtin.Vec8xInt1
    { fatalError() }
    static func cmp_eq_Vec8xInt32(_: Builtin.Vec8xInt32, _: Builtin.Vec8xInt32) -> Builtin.Vec8xInt1
    { fatalError() }
    static func cmp_eq_Vec8xInt64(_: Builtin.Vec8xInt64, _: Builtin.Vec8xInt64) -> Builtin.Vec8xInt1
    { fatalError() }
    static func cmp_eq_Vec8xInt8(_: Builtin.Vec8xInt8, _: Builtin.Vec8xInt8) -> Builtin.Vec8xInt1 {
        fatalError()
    }
    static func cmp_ne_RawPointer(_: Builtin.RawPointer, _: Builtin.RawPointer) -> Builtin.Int1 {
        fatalError()
    }
    static func cmp_ne_Vec16xInt16(_: Builtin.Vec16xInt16, _: Builtin.Vec16xInt16)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_ne_Vec16xInt32(_: Builtin.Vec16xInt32, _: Builtin.Vec16xInt32)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_ne_Vec16xInt64(_: Builtin.Vec16xInt64, _: Builtin.Vec16xInt64)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_ne_Vec16xInt8(_: Builtin.Vec16xInt8, _: Builtin.Vec16xInt8)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_ne_Vec2xInt16(_: Builtin.Vec2xInt16, _: Builtin.Vec2xInt16) -> Builtin.Vec2xInt1
    { fatalError() }
    static func cmp_ne_Vec2xInt32(_: Builtin.Vec2xInt32, _: Builtin.Vec2xInt32) -> Builtin.Vec2xInt1
    { fatalError() }
    static func cmp_ne_Vec2xInt64(_: Builtin.Vec2xInt64, _: Builtin.Vec2xInt64) -> Builtin.Vec2xInt1
    { fatalError() }
    static func cmp_ne_Vec2xInt8(_: Builtin.Vec2xInt8, _: Builtin.Vec2xInt8) -> Builtin.Vec2xInt1 {
        fatalError()
    }
    static func cmp_ne_Vec32xInt16(_: Builtin.Vec32xInt16, _: Builtin.Vec32xInt16)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_ne_Vec32xInt32(_: Builtin.Vec32xInt32, _: Builtin.Vec32xInt32)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_ne_Vec32xInt64(_: Builtin.Vec32xInt64, _: Builtin.Vec32xInt64)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_ne_Vec32xInt8(_: Builtin.Vec32xInt8, _: Builtin.Vec32xInt8)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_ne_Vec4xInt16(_: Builtin.Vec4xInt16, _: Builtin.Vec4xInt16) -> Builtin.Vec4xInt1
    { fatalError() }
    static func cmp_ne_Vec4xInt32(_: Builtin.Vec4xInt32, _: Builtin.Vec4xInt32) -> Builtin.Vec4xInt1
    { fatalError() }
    static func cmp_ne_Vec4xInt64(_: Builtin.Vec4xInt64, _: Builtin.Vec4xInt64) -> Builtin.Vec4xInt1
    { fatalError() }
    static func cmp_ne_Vec4xInt8(_: Builtin.Vec4xInt8, _: Builtin.Vec4xInt8) -> Builtin.Vec4xInt1 {
        fatalError()
    }
    static func cmp_ne_Vec64xInt16(_: Builtin.Vec64xInt16, _: Builtin.Vec64xInt16)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_ne_Vec64xInt32(_: Builtin.Vec64xInt32, _: Builtin.Vec64xInt32)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_ne_Vec64xInt64(_: Builtin.Vec64xInt64, _: Builtin.Vec64xInt64)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_ne_Vec64xInt8(_: Builtin.Vec64xInt8, _: Builtin.Vec64xInt8)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_ne_Vec8xInt16(_: Builtin.Vec8xInt16, _: Builtin.Vec8xInt16) -> Builtin.Vec8xInt1
    { fatalError() }
    static func cmp_ne_Vec8xInt32(_: Builtin.Vec8xInt32, _: Builtin.Vec8xInt32) -> Builtin.Vec8xInt1
    { fatalError() }
    static func cmp_ne_Vec8xInt64(_: Builtin.Vec8xInt64, _: Builtin.Vec8xInt64) -> Builtin.Vec8xInt1
    { fatalError() }
    static func cmp_ne_Vec8xInt8(_: Builtin.Vec8xInt8, _: Builtin.Vec8xInt8) -> Builtin.Vec8xInt1 {
        fatalError()
    }
    static func cmp_sge_Vec16xInt16(_: Builtin.Vec16xInt16, _: Builtin.Vec16xInt16)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_sge_Vec16xInt32(_: Builtin.Vec16xInt32, _: Builtin.Vec16xInt32)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_sge_Vec16xInt64(_: Builtin.Vec16xInt64, _: Builtin.Vec16xInt64)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_sge_Vec16xInt8(_: Builtin.Vec16xInt8, _: Builtin.Vec16xInt8)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_sge_Vec2xInt16(_: Builtin.Vec2xInt16, _: Builtin.Vec2xInt16)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func cmp_sge_Vec2xInt32(_: Builtin.Vec2xInt32, _: Builtin.Vec2xInt32)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func cmp_sge_Vec2xInt64(_: Builtin.Vec2xInt64, _: Builtin.Vec2xInt64)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func cmp_sge_Vec2xInt8(_: Builtin.Vec2xInt8, _: Builtin.Vec2xInt8) -> Builtin.Vec2xInt1 {
        fatalError()
    }
    static func cmp_sge_Vec32xInt16(_: Builtin.Vec32xInt16, _: Builtin.Vec32xInt16)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_sge_Vec32xInt32(_: Builtin.Vec32xInt32, _: Builtin.Vec32xInt32)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_sge_Vec32xInt64(_: Builtin.Vec32xInt64, _: Builtin.Vec32xInt64)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_sge_Vec32xInt8(_: Builtin.Vec32xInt8, _: Builtin.Vec32xInt8)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_sge_Vec4xInt16(_: Builtin.Vec4xInt16, _: Builtin.Vec4xInt16)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func cmp_sge_Vec4xInt32(_: Builtin.Vec4xInt32, _: Builtin.Vec4xInt32)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func cmp_sge_Vec4xInt64(_: Builtin.Vec4xInt64, _: Builtin.Vec4xInt64)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func cmp_sge_Vec4xInt8(_: Builtin.Vec4xInt8, _: Builtin.Vec4xInt8) -> Builtin.Vec4xInt1 {
        fatalError()
    }
    static func cmp_sge_Vec64xInt16(_: Builtin.Vec64xInt16, _: Builtin.Vec64xInt16)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_sge_Vec64xInt32(_: Builtin.Vec64xInt32, _: Builtin.Vec64xInt32)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_sge_Vec64xInt64(_: Builtin.Vec64xInt64, _: Builtin.Vec64xInt64)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_sge_Vec64xInt8(_: Builtin.Vec64xInt8, _: Builtin.Vec64xInt8)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_sge_Vec8xInt16(_: Builtin.Vec8xInt16, _: Builtin.Vec8xInt16)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func cmp_sge_Vec8xInt32(_: Builtin.Vec8xInt32, _: Builtin.Vec8xInt32)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func cmp_sge_Vec8xInt64(_: Builtin.Vec8xInt64, _: Builtin.Vec8xInt64)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func cmp_sge_Vec8xInt8(_: Builtin.Vec8xInt8, _: Builtin.Vec8xInt8) -> Builtin.Vec8xInt1 {
        fatalError()
    }
    static func cmp_sgt_Vec16xInt16(_: Builtin.Vec16xInt16, _: Builtin.Vec16xInt16)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_sgt_Vec16xInt32(_: Builtin.Vec16xInt32, _: Builtin.Vec16xInt32)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_sgt_Vec16xInt64(_: Builtin.Vec16xInt64, _: Builtin.Vec16xInt64)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_sgt_Vec16xInt8(_: Builtin.Vec16xInt8, _: Builtin.Vec16xInt8)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_sgt_Vec2xInt16(_: Builtin.Vec2xInt16, _: Builtin.Vec2xInt16)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func cmp_sgt_Vec2xInt32(_: Builtin.Vec2xInt32, _: Builtin.Vec2xInt32)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func cmp_sgt_Vec2xInt64(_: Builtin.Vec2xInt64, _: Builtin.Vec2xInt64)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func cmp_sgt_Vec2xInt8(_: Builtin.Vec2xInt8, _: Builtin.Vec2xInt8) -> Builtin.Vec2xInt1 {
        fatalError()
    }
    static func cmp_sgt_Vec32xInt16(_: Builtin.Vec32xInt16, _: Builtin.Vec32xInt16)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_sgt_Vec32xInt32(_: Builtin.Vec32xInt32, _: Builtin.Vec32xInt32)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_sgt_Vec32xInt64(_: Builtin.Vec32xInt64, _: Builtin.Vec32xInt64)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_sgt_Vec32xInt8(_: Builtin.Vec32xInt8, _: Builtin.Vec32xInt8)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_sgt_Vec4xInt16(_: Builtin.Vec4xInt16, _: Builtin.Vec4xInt16)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func cmp_sgt_Vec4xInt32(_: Builtin.Vec4xInt32, _: Builtin.Vec4xInt32)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func cmp_sgt_Vec4xInt64(_: Builtin.Vec4xInt64, _: Builtin.Vec4xInt64)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func cmp_sgt_Vec4xInt8(_: Builtin.Vec4xInt8, _: Builtin.Vec4xInt8) -> Builtin.Vec4xInt1 {
        fatalError()
    }
    static func cmp_sgt_Vec64xInt16(_: Builtin.Vec64xInt16, _: Builtin.Vec64xInt16)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_sgt_Vec64xInt32(_: Builtin.Vec64xInt32, _: Builtin.Vec64xInt32)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_sgt_Vec64xInt64(_: Builtin.Vec64xInt64, _: Builtin.Vec64xInt64)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_sgt_Vec64xInt8(_: Builtin.Vec64xInt8, _: Builtin.Vec64xInt8)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_sgt_Vec8xInt16(_: Builtin.Vec8xInt16, _: Builtin.Vec8xInt16)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func cmp_sgt_Vec8xInt32(_: Builtin.Vec8xInt32, _: Builtin.Vec8xInt32)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func cmp_sgt_Vec8xInt64(_: Builtin.Vec8xInt64, _: Builtin.Vec8xInt64)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func cmp_sgt_Vec8xInt8(_: Builtin.Vec8xInt8, _: Builtin.Vec8xInt8) -> Builtin.Vec8xInt1 {
        fatalError()
    }
    static func cmp_sle_Vec16xInt16(_: Builtin.Vec16xInt16, _: Builtin.Vec16xInt16)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_sle_Vec16xInt32(_: Builtin.Vec16xInt32, _: Builtin.Vec16xInt32)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_sle_Vec16xInt64(_: Builtin.Vec16xInt64, _: Builtin.Vec16xInt64)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_sle_Vec16xInt8(_: Builtin.Vec16xInt8, _: Builtin.Vec16xInt8)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_sle_Vec2xInt16(_: Builtin.Vec2xInt16, _: Builtin.Vec2xInt16)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func cmp_sle_Vec2xInt32(_: Builtin.Vec2xInt32, _: Builtin.Vec2xInt32)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func cmp_sle_Vec2xInt64(_: Builtin.Vec2xInt64, _: Builtin.Vec2xInt64)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func cmp_sle_Vec2xInt8(_: Builtin.Vec2xInt8, _: Builtin.Vec2xInt8) -> Builtin.Vec2xInt1 {
        fatalError()
    }
    static func cmp_sle_Vec32xInt16(_: Builtin.Vec32xInt16, _: Builtin.Vec32xInt16)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_sle_Vec32xInt32(_: Builtin.Vec32xInt32, _: Builtin.Vec32xInt32)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_sle_Vec32xInt64(_: Builtin.Vec32xInt64, _: Builtin.Vec32xInt64)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_sle_Vec32xInt8(_: Builtin.Vec32xInt8, _: Builtin.Vec32xInt8)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_sle_Vec4xInt16(_: Builtin.Vec4xInt16, _: Builtin.Vec4xInt16)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func cmp_sle_Vec4xInt32(_: Builtin.Vec4xInt32, _: Builtin.Vec4xInt32)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func cmp_sle_Vec4xInt64(_: Builtin.Vec4xInt64, _: Builtin.Vec4xInt64)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func cmp_sle_Vec4xInt8(_: Builtin.Vec4xInt8, _: Builtin.Vec4xInt8) -> Builtin.Vec4xInt1 {
        fatalError()
    }
    static func cmp_sle_Vec64xInt16(_: Builtin.Vec64xInt16, _: Builtin.Vec64xInt16)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_sle_Vec64xInt32(_: Builtin.Vec64xInt32, _: Builtin.Vec64xInt32)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_sle_Vec64xInt64(_: Builtin.Vec64xInt64, _: Builtin.Vec64xInt64)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_sle_Vec64xInt8(_: Builtin.Vec64xInt8, _: Builtin.Vec64xInt8)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_sle_Vec8xInt16(_: Builtin.Vec8xInt16, _: Builtin.Vec8xInt16)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func cmp_sle_Vec8xInt32(_: Builtin.Vec8xInt32, _: Builtin.Vec8xInt32)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func cmp_sle_Vec8xInt64(_: Builtin.Vec8xInt64, _: Builtin.Vec8xInt64)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func cmp_sle_Vec8xInt8(_: Builtin.Vec8xInt8, _: Builtin.Vec8xInt8) -> Builtin.Vec8xInt1 {
        fatalError()
    }
    static func cmp_slt_Int128(_: Builtin.Int128, _: Builtin.Int128) -> Builtin.Int1 {
        fatalError()
    }
    static func cmp_slt_Int16(_: Builtin.Int16, _: Builtin.Int16) -> Builtin.Int1 { fatalError() }
    static func cmp_slt_Int32(_: Builtin.Int32, _: Builtin.Int32) -> Builtin.Int1 { fatalError() }
    static func cmp_slt_Int64(_: Builtin.Int64, _: Builtin.Int64) -> Builtin.Int1 { fatalError() }
    static func cmp_slt_Int8(_: Builtin.Int8, _: Builtin.Int8) -> Builtin.Int1 { fatalError() }
    static func cmp_slt_Vec16xInt16(_: Builtin.Vec16xInt16, _: Builtin.Vec16xInt16)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_slt_Vec16xInt32(_: Builtin.Vec16xInt32, _: Builtin.Vec16xInt32)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_slt_Vec16xInt64(_: Builtin.Vec16xInt64, _: Builtin.Vec16xInt64)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_slt_Vec16xInt8(_: Builtin.Vec16xInt8, _: Builtin.Vec16xInt8)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_slt_Vec2xInt16(_: Builtin.Vec2xInt16, _: Builtin.Vec2xInt16)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func cmp_slt_Vec2xInt32(_: Builtin.Vec2xInt32, _: Builtin.Vec2xInt32)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func cmp_slt_Vec2xInt64(_: Builtin.Vec2xInt64, _: Builtin.Vec2xInt64)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func cmp_slt_Vec2xInt8(_: Builtin.Vec2xInt8, _: Builtin.Vec2xInt8) -> Builtin.Vec2xInt1 {
        fatalError()
    }
    static func cmp_slt_Vec32xInt16(_: Builtin.Vec32xInt16, _: Builtin.Vec32xInt16)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_slt_Vec32xInt32(_: Builtin.Vec32xInt32, _: Builtin.Vec32xInt32)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_slt_Vec32xInt64(_: Builtin.Vec32xInt64, _: Builtin.Vec32xInt64)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_slt_Vec32xInt8(_: Builtin.Vec32xInt8, _: Builtin.Vec32xInt8)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_slt_Vec4xInt16(_: Builtin.Vec4xInt16, _: Builtin.Vec4xInt16)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func cmp_slt_Vec4xInt32(_: Builtin.Vec4xInt32, _: Builtin.Vec4xInt32)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func cmp_slt_Vec4xInt64(_: Builtin.Vec4xInt64, _: Builtin.Vec4xInt64)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func cmp_slt_Vec4xInt8(_: Builtin.Vec4xInt8, _: Builtin.Vec4xInt8) -> Builtin.Vec4xInt1 {
        fatalError()
    }
    static func cmp_slt_Vec64xInt16(_: Builtin.Vec64xInt16, _: Builtin.Vec64xInt16)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_slt_Vec64xInt32(_: Builtin.Vec64xInt32, _: Builtin.Vec64xInt32)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_slt_Vec64xInt64(_: Builtin.Vec64xInt64, _: Builtin.Vec64xInt64)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_slt_Vec64xInt8(_: Builtin.Vec64xInt8, _: Builtin.Vec64xInt8)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_slt_Vec8xInt16(_: Builtin.Vec8xInt16, _: Builtin.Vec8xInt16)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func cmp_slt_Vec8xInt32(_: Builtin.Vec8xInt32, _: Builtin.Vec8xInt32)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func cmp_slt_Vec8xInt64(_: Builtin.Vec8xInt64, _: Builtin.Vec8xInt64)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func cmp_slt_Vec8xInt8(_: Builtin.Vec8xInt8, _: Builtin.Vec8xInt8) -> Builtin.Vec8xInt1 {
        fatalError()
    }
    static func cmp_uge_RawPointer(_: Builtin.RawPointer, _: Builtin.RawPointer) -> Builtin.Int1 {
        fatalError()
    }
    static func cmp_uge_Vec16xInt16(_: Builtin.Vec16xInt16, _: Builtin.Vec16xInt16)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_uge_Vec16xInt32(_: Builtin.Vec16xInt32, _: Builtin.Vec16xInt32)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_uge_Vec16xInt64(_: Builtin.Vec16xInt64, _: Builtin.Vec16xInt64)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_uge_Vec16xInt8(_: Builtin.Vec16xInt8, _: Builtin.Vec16xInt8)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_uge_Vec2xInt16(_: Builtin.Vec2xInt16, _: Builtin.Vec2xInt16)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func cmp_uge_Vec2xInt32(_: Builtin.Vec2xInt32, _: Builtin.Vec2xInt32)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func cmp_uge_Vec2xInt64(_: Builtin.Vec2xInt64, _: Builtin.Vec2xInt64)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func cmp_uge_Vec2xInt8(_: Builtin.Vec2xInt8, _: Builtin.Vec2xInt8) -> Builtin.Vec2xInt1 {
        fatalError()
    }
    static func cmp_uge_Vec32xInt16(_: Builtin.Vec32xInt16, _: Builtin.Vec32xInt16)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_uge_Vec32xInt32(_: Builtin.Vec32xInt32, _: Builtin.Vec32xInt32)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_uge_Vec32xInt64(_: Builtin.Vec32xInt64, _: Builtin.Vec32xInt64)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_uge_Vec32xInt8(_: Builtin.Vec32xInt8, _: Builtin.Vec32xInt8)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_uge_Vec4xInt16(_: Builtin.Vec4xInt16, _: Builtin.Vec4xInt16)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func cmp_uge_Vec4xInt32(_: Builtin.Vec4xInt32, _: Builtin.Vec4xInt32)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func cmp_uge_Vec4xInt64(_: Builtin.Vec4xInt64, _: Builtin.Vec4xInt64)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func cmp_uge_Vec4xInt8(_: Builtin.Vec4xInt8, _: Builtin.Vec4xInt8) -> Builtin.Vec4xInt1 {
        fatalError()
    }
    static func cmp_uge_Vec64xInt16(_: Builtin.Vec64xInt16, _: Builtin.Vec64xInt16)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_uge_Vec64xInt32(_: Builtin.Vec64xInt32, _: Builtin.Vec64xInt32)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_uge_Vec64xInt64(_: Builtin.Vec64xInt64, _: Builtin.Vec64xInt64)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_uge_Vec64xInt8(_: Builtin.Vec64xInt8, _: Builtin.Vec64xInt8)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_uge_Vec8xInt16(_: Builtin.Vec8xInt16, _: Builtin.Vec8xInt16)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func cmp_uge_Vec8xInt32(_: Builtin.Vec8xInt32, _: Builtin.Vec8xInt32)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func cmp_uge_Vec8xInt64(_: Builtin.Vec8xInt64, _: Builtin.Vec8xInt64)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func cmp_uge_Vec8xInt8(_: Builtin.Vec8xInt8, _: Builtin.Vec8xInt8) -> Builtin.Vec8xInt1 {
        fatalError()
    }
    static func cmp_ugt_RawPointer(_: Builtin.RawPointer, _: Builtin.RawPointer) -> Builtin.Int1 {
        fatalError()
    }
    static func cmp_ugt_Vec16xInt16(_: Builtin.Vec16xInt16, _: Builtin.Vec16xInt16)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_ugt_Vec16xInt32(_: Builtin.Vec16xInt32, _: Builtin.Vec16xInt32)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_ugt_Vec16xInt64(_: Builtin.Vec16xInt64, _: Builtin.Vec16xInt64)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_ugt_Vec16xInt8(_: Builtin.Vec16xInt8, _: Builtin.Vec16xInt8)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_ugt_Vec2xInt16(_: Builtin.Vec2xInt16, _: Builtin.Vec2xInt16)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func cmp_ugt_Vec2xInt32(_: Builtin.Vec2xInt32, _: Builtin.Vec2xInt32)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func cmp_ugt_Vec2xInt64(_: Builtin.Vec2xInt64, _: Builtin.Vec2xInt64)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func cmp_ugt_Vec2xInt8(_: Builtin.Vec2xInt8, _: Builtin.Vec2xInt8) -> Builtin.Vec2xInt1 {
        fatalError()
    }
    static func cmp_ugt_Vec32xInt16(_: Builtin.Vec32xInt16, _: Builtin.Vec32xInt16)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_ugt_Vec32xInt32(_: Builtin.Vec32xInt32, _: Builtin.Vec32xInt32)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_ugt_Vec32xInt64(_: Builtin.Vec32xInt64, _: Builtin.Vec32xInt64)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_ugt_Vec32xInt8(_: Builtin.Vec32xInt8, _: Builtin.Vec32xInt8)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_ugt_Vec4xInt16(_: Builtin.Vec4xInt16, _: Builtin.Vec4xInt16)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func cmp_ugt_Vec4xInt32(_: Builtin.Vec4xInt32, _: Builtin.Vec4xInt32)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func cmp_ugt_Vec4xInt64(_: Builtin.Vec4xInt64, _: Builtin.Vec4xInt64)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func cmp_ugt_Vec4xInt8(_: Builtin.Vec4xInt8, _: Builtin.Vec4xInt8) -> Builtin.Vec4xInt1 {
        fatalError()
    }
    static func cmp_ugt_Vec64xInt16(_: Builtin.Vec64xInt16, _: Builtin.Vec64xInt16)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_ugt_Vec64xInt32(_: Builtin.Vec64xInt32, _: Builtin.Vec64xInt32)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_ugt_Vec64xInt64(_: Builtin.Vec64xInt64, _: Builtin.Vec64xInt64)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_ugt_Vec64xInt8(_: Builtin.Vec64xInt8, _: Builtin.Vec64xInt8)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_ugt_Vec8xInt16(_: Builtin.Vec8xInt16, _: Builtin.Vec8xInt16)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func cmp_ugt_Vec8xInt32(_: Builtin.Vec8xInt32, _: Builtin.Vec8xInt32)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func cmp_ugt_Vec8xInt64(_: Builtin.Vec8xInt64, _: Builtin.Vec8xInt64)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func cmp_ugt_Vec8xInt8(_: Builtin.Vec8xInt8, _: Builtin.Vec8xInt8) -> Builtin.Vec8xInt1 {
        fatalError()
    }
    static func cmp_ule_RawPointer(_: Builtin.RawPointer, _: Builtin.RawPointer) -> Builtin.Int1 {
        fatalError()
    }
    static func cmp_ule_Vec16xInt16(_: Builtin.Vec16xInt16, _: Builtin.Vec16xInt16)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_ule_Vec16xInt32(_: Builtin.Vec16xInt32, _: Builtin.Vec16xInt32)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_ule_Vec16xInt64(_: Builtin.Vec16xInt64, _: Builtin.Vec16xInt64)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_ule_Vec16xInt8(_: Builtin.Vec16xInt8, _: Builtin.Vec16xInt8)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_ule_Vec2xInt16(_: Builtin.Vec2xInt16, _: Builtin.Vec2xInt16)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func cmp_ule_Vec2xInt32(_: Builtin.Vec2xInt32, _: Builtin.Vec2xInt32)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func cmp_ule_Vec2xInt64(_: Builtin.Vec2xInt64, _: Builtin.Vec2xInt64)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func cmp_ule_Vec2xInt8(_: Builtin.Vec2xInt8, _: Builtin.Vec2xInt8) -> Builtin.Vec2xInt1 {
        fatalError()
    }
    static func cmp_ule_Vec32xInt16(_: Builtin.Vec32xInt16, _: Builtin.Vec32xInt16)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_ule_Vec32xInt32(_: Builtin.Vec32xInt32, _: Builtin.Vec32xInt32)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_ule_Vec32xInt64(_: Builtin.Vec32xInt64, _: Builtin.Vec32xInt64)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_ule_Vec32xInt8(_: Builtin.Vec32xInt8, _: Builtin.Vec32xInt8)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_ule_Vec4xInt16(_: Builtin.Vec4xInt16, _: Builtin.Vec4xInt16)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func cmp_ule_Vec4xInt32(_: Builtin.Vec4xInt32, _: Builtin.Vec4xInt32)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func cmp_ule_Vec4xInt64(_: Builtin.Vec4xInt64, _: Builtin.Vec4xInt64)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func cmp_ule_Vec4xInt8(_: Builtin.Vec4xInt8, _: Builtin.Vec4xInt8) -> Builtin.Vec4xInt1 {
        fatalError()
    }
    static func cmp_ule_Vec64xInt16(_: Builtin.Vec64xInt16, _: Builtin.Vec64xInt16)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_ule_Vec64xInt32(_: Builtin.Vec64xInt32, _: Builtin.Vec64xInt32)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_ule_Vec64xInt64(_: Builtin.Vec64xInt64, _: Builtin.Vec64xInt64)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_ule_Vec64xInt8(_: Builtin.Vec64xInt8, _: Builtin.Vec64xInt8)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_ule_Vec8xInt16(_: Builtin.Vec8xInt16, _: Builtin.Vec8xInt16)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func cmp_ule_Vec8xInt32(_: Builtin.Vec8xInt32, _: Builtin.Vec8xInt32)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func cmp_ule_Vec8xInt64(_: Builtin.Vec8xInt64, _: Builtin.Vec8xInt64)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func cmp_ule_Vec8xInt8(_: Builtin.Vec8xInt8, _: Builtin.Vec8xInt8) -> Builtin.Vec8xInt1 {
        fatalError()
    }
    static func cmp_ult_Int128(_: Builtin.Int128, _: Builtin.Int128) -> Builtin.Int1 {
        fatalError()
    }
    static func cmp_ult_Int16(_: Builtin.Int16, _: Builtin.Int16) -> Builtin.Int1 { fatalError() }
    static func cmp_ult_Int32(_: Builtin.Int32, _: Builtin.Int32) -> Builtin.Int1 { fatalError() }
    static func cmp_ult_Int64(_: Builtin.Int64, _: Builtin.Int64) -> Builtin.Int1 { fatalError() }
    static func cmp_ult_Int8(_: Builtin.Int8, _: Builtin.Int8) -> Builtin.Int1 { fatalError() }
    static func cmp_ult_RawPointer(_: Builtin.RawPointer, _: Builtin.RawPointer) -> Builtin.Int1 {
        fatalError()
    }
    static func cmp_ult_Vec16xInt16(_: Builtin.Vec16xInt16, _: Builtin.Vec16xInt16)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_ult_Vec16xInt32(_: Builtin.Vec16xInt32, _: Builtin.Vec16xInt32)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_ult_Vec16xInt64(_: Builtin.Vec16xInt64, _: Builtin.Vec16xInt64)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_ult_Vec16xInt8(_: Builtin.Vec16xInt8, _: Builtin.Vec16xInt8)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func cmp_ult_Vec2xInt16(_: Builtin.Vec2xInt16, _: Builtin.Vec2xInt16)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func cmp_ult_Vec2xInt32(_: Builtin.Vec2xInt32, _: Builtin.Vec2xInt32)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func cmp_ult_Vec2xInt64(_: Builtin.Vec2xInt64, _: Builtin.Vec2xInt64)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func cmp_ult_Vec2xInt8(_: Builtin.Vec2xInt8, _: Builtin.Vec2xInt8) -> Builtin.Vec2xInt1 {
        fatalError()
    }
    static func cmp_ult_Vec32xInt16(_: Builtin.Vec32xInt16, _: Builtin.Vec32xInt16)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_ult_Vec32xInt32(_: Builtin.Vec32xInt32, _: Builtin.Vec32xInt32)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_ult_Vec32xInt64(_: Builtin.Vec32xInt64, _: Builtin.Vec32xInt64)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_ult_Vec32xInt8(_: Builtin.Vec32xInt8, _: Builtin.Vec32xInt8)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func cmp_ult_Vec4xInt16(_: Builtin.Vec4xInt16, _: Builtin.Vec4xInt16)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func cmp_ult_Vec4xInt32(_: Builtin.Vec4xInt32, _: Builtin.Vec4xInt32)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func cmp_ult_Vec4xInt64(_: Builtin.Vec4xInt64, _: Builtin.Vec4xInt64)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func cmp_ult_Vec4xInt8(_: Builtin.Vec4xInt8, _: Builtin.Vec4xInt8) -> Builtin.Vec4xInt1 {
        fatalError()
    }
    static func cmp_ult_Vec64xInt16(_: Builtin.Vec64xInt16, _: Builtin.Vec64xInt16)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_ult_Vec64xInt32(_: Builtin.Vec64xInt32, _: Builtin.Vec64xInt32)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_ult_Vec64xInt64(_: Builtin.Vec64xInt64, _: Builtin.Vec64xInt64)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_ult_Vec64xInt8(_: Builtin.Vec64xInt8, _: Builtin.Vec64xInt8)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func cmp_ult_Vec8xInt16(_: Builtin.Vec8xInt16, _: Builtin.Vec8xInt16)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func cmp_ult_Vec8xInt32(_: Builtin.Vec8xInt32, _: Builtin.Vec8xInt32)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func cmp_ult_Vec8xInt64(_: Builtin.Vec8xInt64, _: Builtin.Vec8xInt64)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func cmp_ult_Vec8xInt8(_: Builtin.Vec8xInt8, _: Builtin.Vec8xInt8) -> Builtin.Vec8xInt1 {
        fatalError()
    }
    static func cmpxchg_acqrel_acquire_Word(_: Builtin.RawPointer, _: Builtin.Word, _: Builtin.Word)
        -> (Builtin.Word, Builtin.Int1)
    { fatalError() }
    static func cmpxchg_seqcst_seqcst_Word(_: Builtin.RawPointer, _: Builtin.Word, _: Builtin.Word)
        -> (Builtin.Word, Builtin.Int1)
    { fatalError() }
    static func condfail_message(_: Builtin.Int1, _: Builtin.RawPointer) { fatalError() }
    static func conditionallyUnreachable() -> Never { fatalError() }
    static func convertUnownedUnsafeToGuaranteed<T, U, V>(_: T, _: inout U) -> V
    where T: ~Copyable, T: ~Escapable, U: ~Copyable, U: ~Escapable, V: ~Copyable { fatalError() }
    static func copyArray<T>(
        _: T.Type, _: Builtin.RawPointer, _: Builtin.RawPointer, _: Builtin.Word
    ) where T: ~Escapable { fatalError() }
    static func deallocRaw(_: Builtin.RawPointer, _: Builtin.Word, _: Builtin.Word) { fatalError() }
    static func dereferenceBorrow<T>(_: __shared Builtin.Borrow<τ_0_0>) -> T
    where T: ~Copyable, T: ~Escapable { fatalError() }
    static func destroyArray<T>(_: T.Type, _: Builtin.RawPointer, _: Builtin.Word)
    where T: ~Copyable, T: ~Escapable { fatalError() }
    static func endCOWMutation<T>(_: inout T) where T: ~Copyable, T: ~Escapable { fatalError() }
    static func extractelement_Vec16xFPIEEE32_Int32(_: Builtin.Vec16xFPIEEE32, _: Builtin.Int32)
        -> Builtin.FPIEEE32
    { fatalError() }
    static func extractelement_Vec16xFPIEEE64_Int32(_: Builtin.Vec16xFPIEEE64, _: Builtin.Int32)
        -> Builtin.FPIEEE64
    { fatalError() }
    static func extractelement_Vec16xInt16_Int32(_: Builtin.Vec16xInt16, _: Builtin.Int32)
        -> Builtin.Int16
    { fatalError() }
    static func extractelement_Vec16xInt32_Int32(_: Builtin.Vec16xInt32, _: Builtin.Int32)
        -> Builtin.Int32
    { fatalError() }
    static func extractelement_Vec16xInt64_Int32(_: Builtin.Vec16xInt64, _: Builtin.Int32)
        -> Builtin.Int64
    { fatalError() }
    static func extractelement_Vec16xInt8_Int32(_: Builtin.Vec16xInt8, _: Builtin.Int32)
        -> Builtin.Int8
    { fatalError() }
    static func extractelement_Vec2xFPIEEE32_Int32(_: Builtin.Vec2xFPIEEE32, _: Builtin.Int32)
        -> Builtin.FPIEEE32
    { fatalError() }
    static func extractelement_Vec2xFPIEEE64_Int32(_: Builtin.Vec2xFPIEEE64, _: Builtin.Int32)
        -> Builtin.FPIEEE64
    { fatalError() }
    static func extractelement_Vec2xInt16_Int32(_: Builtin.Vec2xInt16, _: Builtin.Int32)
        -> Builtin.Int16
    { fatalError() }
    static func extractelement_Vec2xInt32_Int32(_: Builtin.Vec2xInt32, _: Builtin.Int32)
        -> Builtin.Int32
    { fatalError() }
    static func extractelement_Vec2xInt64_Int32(_: Builtin.Vec2xInt64, _: Builtin.Int32)
        -> Builtin.Int64
    { fatalError() }
    static func extractelement_Vec2xInt8_Int32(_: Builtin.Vec2xInt8, _: Builtin.Int32)
        -> Builtin.Int8
    { fatalError() }
    static func extractelement_Vec32xFPIEEE32_Int32(_: Builtin.Vec32xFPIEEE32, _: Builtin.Int32)
        -> Builtin.FPIEEE32
    { fatalError() }
    static func extractelement_Vec32xFPIEEE64_Int32(_: Builtin.Vec32xFPIEEE64, _: Builtin.Int32)
        -> Builtin.FPIEEE64
    { fatalError() }
    static func extractelement_Vec32xInt16_Int32(_: Builtin.Vec32xInt16, _: Builtin.Int32)
        -> Builtin.Int16
    { fatalError() }
    static func extractelement_Vec32xInt32_Int32(_: Builtin.Vec32xInt32, _: Builtin.Int32)
        -> Builtin.Int32
    { fatalError() }
    static func extractelement_Vec32xInt64_Int32(_: Builtin.Vec32xInt64, _: Builtin.Int32)
        -> Builtin.Int64
    { fatalError() }
    static func extractelement_Vec32xInt8_Int32(_: Builtin.Vec32xInt8, _: Builtin.Int32)
        -> Builtin.Int8
    { fatalError() }
    static func extractelement_Vec4xFPIEEE32_Int32(_: Builtin.Vec4xFPIEEE32, _: Builtin.Int32)
        -> Builtin.FPIEEE32
    { fatalError() }
    static func extractelement_Vec4xFPIEEE64_Int32(_: Builtin.Vec4xFPIEEE64, _: Builtin.Int32)
        -> Builtin.FPIEEE64
    { fatalError() }
    static func extractelement_Vec4xInt16_Int32(_: Builtin.Vec4xInt16, _: Builtin.Int32)
        -> Builtin.Int16
    { fatalError() }
    static func extractelement_Vec4xInt32_Int32(_: Builtin.Vec4xInt32, _: Builtin.Int32)
        -> Builtin.Int32
    { fatalError() }
    static func extractelement_Vec4xInt64_Int32(_: Builtin.Vec4xInt64, _: Builtin.Int32)
        -> Builtin.Int64
    { fatalError() }
    static func extractelement_Vec4xInt8_Int32(_: Builtin.Vec4xInt8, _: Builtin.Int32)
        -> Builtin.Int8
    { fatalError() }
    static func extractelement_Vec64xFPIEEE32_Int32(_: Builtin.Vec64xFPIEEE32, _: Builtin.Int32)
        -> Builtin.FPIEEE32
    { fatalError() }
    static func extractelement_Vec64xFPIEEE64_Int32(_: Builtin.Vec64xFPIEEE64, _: Builtin.Int32)
        -> Builtin.FPIEEE64
    { fatalError() }
    static func extractelement_Vec64xInt16_Int32(_: Builtin.Vec64xInt16, _: Builtin.Int32)
        -> Builtin.Int16
    { fatalError() }
    static func extractelement_Vec64xInt32_Int32(_: Builtin.Vec64xInt32, _: Builtin.Int32)
        -> Builtin.Int32
    { fatalError() }
    static func extractelement_Vec64xInt64_Int32(_: Builtin.Vec64xInt64, _: Builtin.Int32)
        -> Builtin.Int64
    { fatalError() }
    static func extractelement_Vec64xInt8_Int32(_: Builtin.Vec64xInt8, _: Builtin.Int32)
        -> Builtin.Int8
    { fatalError() }
    static func extractelement_Vec8xFPIEEE32_Int32(_: Builtin.Vec8xFPIEEE32, _: Builtin.Int32)
        -> Builtin.FPIEEE32
    { fatalError() }
    static func extractelement_Vec8xFPIEEE64_Int32(_: Builtin.Vec8xFPIEEE64, _: Builtin.Int32)
        -> Builtin.FPIEEE64
    { fatalError() }
    static func extractelement_Vec8xInt16_Int32(_: Builtin.Vec8xInt16, _: Builtin.Int32)
        -> Builtin.Int16
    { fatalError() }
    static func extractelement_Vec8xInt32_Int32(_: Builtin.Vec8xInt32, _: Builtin.Int32)
        -> Builtin.Int32
    { fatalError() }
    static func extractelement_Vec8xInt64_Int32(_: Builtin.Vec8xInt64, _: Builtin.Int32)
        -> Builtin.Int64
    { fatalError() }
    static func extractelement_Vec8xInt8_Int32(_: Builtin.Vec8xInt8, _: Builtin.Int32)
        -> Builtin.Int8
    { fatalError() }
    static func fadd_FPIEEE32(_: Builtin.FPIEEE32, _: Builtin.FPIEEE32) -> Builtin.FPIEEE32 {
        fatalError()
    }
    static func fadd_FPIEEE64(_: Builtin.FPIEEE64, _: Builtin.FPIEEE64) -> Builtin.FPIEEE64 {
        fatalError()
    }
    static func fadd_FPIEEE80(_: Builtin.FPIEEE80, _: Builtin.FPIEEE80) -> Builtin.FPIEEE80 {
        fatalError()
    }
    static func fcmp_oeq_FPIEEE32(_: Builtin.FPIEEE32, _: Builtin.FPIEEE32) -> Builtin.Int1 {
        fatalError()
    }
    static func fcmp_oeq_FPIEEE64(_: Builtin.FPIEEE64, _: Builtin.FPIEEE64) -> Builtin.Int1 {
        fatalError()
    }
    static func fcmp_oeq_FPIEEE80(_: Builtin.FPIEEE80, _: Builtin.FPIEEE80) -> Builtin.Int1 {
        fatalError()
    }
    static func fcmp_oeq_Vec16xFPIEEE32(_: Builtin.Vec16xFPIEEE32, _: Builtin.Vec16xFPIEEE32)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func fcmp_oeq_Vec16xFPIEEE64(_: Builtin.Vec16xFPIEEE64, _: Builtin.Vec16xFPIEEE64)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func fcmp_oeq_Vec2xFPIEEE32(_: Builtin.Vec2xFPIEEE32, _: Builtin.Vec2xFPIEEE32)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func fcmp_oeq_Vec2xFPIEEE64(_: Builtin.Vec2xFPIEEE64, _: Builtin.Vec2xFPIEEE64)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func fcmp_oeq_Vec32xFPIEEE32(_: Builtin.Vec32xFPIEEE32, _: Builtin.Vec32xFPIEEE32)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func fcmp_oeq_Vec32xFPIEEE64(_: Builtin.Vec32xFPIEEE64, _: Builtin.Vec32xFPIEEE64)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func fcmp_oeq_Vec4xFPIEEE32(_: Builtin.Vec4xFPIEEE32, _: Builtin.Vec4xFPIEEE32)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func fcmp_oeq_Vec4xFPIEEE64(_: Builtin.Vec4xFPIEEE64, _: Builtin.Vec4xFPIEEE64)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func fcmp_oeq_Vec64xFPIEEE32(_: Builtin.Vec64xFPIEEE32, _: Builtin.Vec64xFPIEEE32)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func fcmp_oeq_Vec64xFPIEEE64(_: Builtin.Vec64xFPIEEE64, _: Builtin.Vec64xFPIEEE64)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func fcmp_oeq_Vec8xFPIEEE32(_: Builtin.Vec8xFPIEEE32, _: Builtin.Vec8xFPIEEE32)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func fcmp_oeq_Vec8xFPIEEE64(_: Builtin.Vec8xFPIEEE64, _: Builtin.Vec8xFPIEEE64)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func fcmp_oge_Vec16xFPIEEE32(_: Builtin.Vec16xFPIEEE32, _: Builtin.Vec16xFPIEEE32)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func fcmp_oge_Vec16xFPIEEE64(_: Builtin.Vec16xFPIEEE64, _: Builtin.Vec16xFPIEEE64)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func fcmp_oge_Vec2xFPIEEE32(_: Builtin.Vec2xFPIEEE32, _: Builtin.Vec2xFPIEEE32)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func fcmp_oge_Vec2xFPIEEE64(_: Builtin.Vec2xFPIEEE64, _: Builtin.Vec2xFPIEEE64)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func fcmp_oge_Vec32xFPIEEE32(_: Builtin.Vec32xFPIEEE32, _: Builtin.Vec32xFPIEEE32)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func fcmp_oge_Vec32xFPIEEE64(_: Builtin.Vec32xFPIEEE64, _: Builtin.Vec32xFPIEEE64)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func fcmp_oge_Vec4xFPIEEE32(_: Builtin.Vec4xFPIEEE32, _: Builtin.Vec4xFPIEEE32)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func fcmp_oge_Vec4xFPIEEE64(_: Builtin.Vec4xFPIEEE64, _: Builtin.Vec4xFPIEEE64)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func fcmp_oge_Vec64xFPIEEE32(_: Builtin.Vec64xFPIEEE32, _: Builtin.Vec64xFPIEEE32)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func fcmp_oge_Vec64xFPIEEE64(_: Builtin.Vec64xFPIEEE64, _: Builtin.Vec64xFPIEEE64)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func fcmp_oge_Vec8xFPIEEE32(_: Builtin.Vec8xFPIEEE32, _: Builtin.Vec8xFPIEEE32)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func fcmp_oge_Vec8xFPIEEE64(_: Builtin.Vec8xFPIEEE64, _: Builtin.Vec8xFPIEEE64)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func fcmp_ogt_Vec16xFPIEEE32(_: Builtin.Vec16xFPIEEE32, _: Builtin.Vec16xFPIEEE32)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func fcmp_ogt_Vec16xFPIEEE64(_: Builtin.Vec16xFPIEEE64, _: Builtin.Vec16xFPIEEE64)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func fcmp_ogt_Vec2xFPIEEE32(_: Builtin.Vec2xFPIEEE32, _: Builtin.Vec2xFPIEEE32)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func fcmp_ogt_Vec2xFPIEEE64(_: Builtin.Vec2xFPIEEE64, _: Builtin.Vec2xFPIEEE64)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func fcmp_ogt_Vec32xFPIEEE32(_: Builtin.Vec32xFPIEEE32, _: Builtin.Vec32xFPIEEE32)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func fcmp_ogt_Vec32xFPIEEE64(_: Builtin.Vec32xFPIEEE64, _: Builtin.Vec32xFPIEEE64)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func fcmp_ogt_Vec4xFPIEEE32(_: Builtin.Vec4xFPIEEE32, _: Builtin.Vec4xFPIEEE32)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func fcmp_ogt_Vec4xFPIEEE64(_: Builtin.Vec4xFPIEEE64, _: Builtin.Vec4xFPIEEE64)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func fcmp_ogt_Vec64xFPIEEE32(_: Builtin.Vec64xFPIEEE32, _: Builtin.Vec64xFPIEEE32)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func fcmp_ogt_Vec64xFPIEEE64(_: Builtin.Vec64xFPIEEE64, _: Builtin.Vec64xFPIEEE64)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func fcmp_ogt_Vec8xFPIEEE32(_: Builtin.Vec8xFPIEEE32, _: Builtin.Vec8xFPIEEE32)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func fcmp_ogt_Vec8xFPIEEE64(_: Builtin.Vec8xFPIEEE64, _: Builtin.Vec8xFPIEEE64)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func fcmp_ole_FPIEEE32(_: Builtin.FPIEEE32, _: Builtin.FPIEEE32) -> Builtin.Int1 {
        fatalError()
    }
    static func fcmp_ole_FPIEEE64(_: Builtin.FPIEEE64, _: Builtin.FPIEEE64) -> Builtin.Int1 {
        fatalError()
    }
    static func fcmp_ole_FPIEEE80(_: Builtin.FPIEEE80, _: Builtin.FPIEEE80) -> Builtin.Int1 {
        fatalError()
    }
    static func fcmp_ole_Vec16xFPIEEE32(_: Builtin.Vec16xFPIEEE32, _: Builtin.Vec16xFPIEEE32)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func fcmp_ole_Vec16xFPIEEE64(_: Builtin.Vec16xFPIEEE64, _: Builtin.Vec16xFPIEEE64)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func fcmp_ole_Vec2xFPIEEE32(_: Builtin.Vec2xFPIEEE32, _: Builtin.Vec2xFPIEEE32)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func fcmp_ole_Vec2xFPIEEE64(_: Builtin.Vec2xFPIEEE64, _: Builtin.Vec2xFPIEEE64)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func fcmp_ole_Vec32xFPIEEE32(_: Builtin.Vec32xFPIEEE32, _: Builtin.Vec32xFPIEEE32)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func fcmp_ole_Vec32xFPIEEE64(_: Builtin.Vec32xFPIEEE64, _: Builtin.Vec32xFPIEEE64)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func fcmp_ole_Vec4xFPIEEE32(_: Builtin.Vec4xFPIEEE32, _: Builtin.Vec4xFPIEEE32)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func fcmp_ole_Vec4xFPIEEE64(_: Builtin.Vec4xFPIEEE64, _: Builtin.Vec4xFPIEEE64)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func fcmp_ole_Vec64xFPIEEE32(_: Builtin.Vec64xFPIEEE32, _: Builtin.Vec64xFPIEEE32)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func fcmp_ole_Vec64xFPIEEE64(_: Builtin.Vec64xFPIEEE64, _: Builtin.Vec64xFPIEEE64)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func fcmp_ole_Vec8xFPIEEE32(_: Builtin.Vec8xFPIEEE32, _: Builtin.Vec8xFPIEEE32)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func fcmp_ole_Vec8xFPIEEE64(_: Builtin.Vec8xFPIEEE64, _: Builtin.Vec8xFPIEEE64)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func fcmp_olt_FPIEEE32(_: Builtin.FPIEEE32, _: Builtin.FPIEEE32) -> Builtin.Int1 {
        fatalError()
    }
    static func fcmp_olt_FPIEEE64(_: Builtin.FPIEEE64, _: Builtin.FPIEEE64) -> Builtin.Int1 {
        fatalError()
    }
    static func fcmp_olt_FPIEEE80(_: Builtin.FPIEEE80, _: Builtin.FPIEEE80) -> Builtin.Int1 {
        fatalError()
    }
    static func fcmp_olt_Vec16xFPIEEE32(_: Builtin.Vec16xFPIEEE32, _: Builtin.Vec16xFPIEEE32)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func fcmp_olt_Vec16xFPIEEE64(_: Builtin.Vec16xFPIEEE64, _: Builtin.Vec16xFPIEEE64)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func fcmp_olt_Vec2xFPIEEE32(_: Builtin.Vec2xFPIEEE32, _: Builtin.Vec2xFPIEEE32)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func fcmp_olt_Vec2xFPIEEE64(_: Builtin.Vec2xFPIEEE64, _: Builtin.Vec2xFPIEEE64)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func fcmp_olt_Vec32xFPIEEE32(_: Builtin.Vec32xFPIEEE32, _: Builtin.Vec32xFPIEEE32)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func fcmp_olt_Vec32xFPIEEE64(_: Builtin.Vec32xFPIEEE64, _: Builtin.Vec32xFPIEEE64)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func fcmp_olt_Vec4xFPIEEE32(_: Builtin.Vec4xFPIEEE32, _: Builtin.Vec4xFPIEEE32)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func fcmp_olt_Vec4xFPIEEE64(_: Builtin.Vec4xFPIEEE64, _: Builtin.Vec4xFPIEEE64)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func fcmp_olt_Vec64xFPIEEE32(_: Builtin.Vec64xFPIEEE32, _: Builtin.Vec64xFPIEEE32)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func fcmp_olt_Vec64xFPIEEE64(_: Builtin.Vec64xFPIEEE64, _: Builtin.Vec64xFPIEEE64)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func fcmp_olt_Vec8xFPIEEE32(_: Builtin.Vec8xFPIEEE32, _: Builtin.Vec8xFPIEEE32)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func fcmp_olt_Vec8xFPIEEE64(_: Builtin.Vec8xFPIEEE64, _: Builtin.Vec8xFPIEEE64)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func fcmp_une_Vec16xFPIEEE32(_: Builtin.Vec16xFPIEEE32, _: Builtin.Vec16xFPIEEE32)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func fcmp_une_Vec16xFPIEEE64(_: Builtin.Vec16xFPIEEE64, _: Builtin.Vec16xFPIEEE64)
        -> Builtin.Vec16xInt1
    { fatalError() }
    static func fcmp_une_Vec2xFPIEEE32(_: Builtin.Vec2xFPIEEE32, _: Builtin.Vec2xFPIEEE32)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func fcmp_une_Vec2xFPIEEE64(_: Builtin.Vec2xFPIEEE64, _: Builtin.Vec2xFPIEEE64)
        -> Builtin.Vec2xInt1
    { fatalError() }
    static func fcmp_une_Vec32xFPIEEE32(_: Builtin.Vec32xFPIEEE32, _: Builtin.Vec32xFPIEEE32)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func fcmp_une_Vec32xFPIEEE64(_: Builtin.Vec32xFPIEEE64, _: Builtin.Vec32xFPIEEE64)
        -> Builtin.Vec32xInt1
    { fatalError() }
    static func fcmp_une_Vec4xFPIEEE32(_: Builtin.Vec4xFPIEEE32, _: Builtin.Vec4xFPIEEE32)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func fcmp_une_Vec4xFPIEEE64(_: Builtin.Vec4xFPIEEE64, _: Builtin.Vec4xFPIEEE64)
        -> Builtin.Vec4xInt1
    { fatalError() }
    static func fcmp_une_Vec64xFPIEEE32(_: Builtin.Vec64xFPIEEE32, _: Builtin.Vec64xFPIEEE32)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func fcmp_une_Vec64xFPIEEE64(_: Builtin.Vec64xFPIEEE64, _: Builtin.Vec64xFPIEEE64)
        -> Builtin.Vec64xInt1
    { fatalError() }
    static func fcmp_une_Vec8xFPIEEE32(_: Builtin.Vec8xFPIEEE32, _: Builtin.Vec8xFPIEEE32)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func fcmp_une_Vec8xFPIEEE64(_: Builtin.Vec8xFPIEEE64, _: Builtin.Vec8xFPIEEE64)
        -> Builtin.Vec8xInt1
    { fatalError() }
    static func fdiv_FPIEEE32(_: Builtin.FPIEEE32, _: Builtin.FPIEEE32) -> Builtin.FPIEEE32 {
        fatalError()
    }
    static func fdiv_FPIEEE64(_: Builtin.FPIEEE64, _: Builtin.FPIEEE64) -> Builtin.FPIEEE64 {
        fatalError()
    }
    static func fdiv_FPIEEE80(_: Builtin.FPIEEE80, _: Builtin.FPIEEE80) -> Builtin.FPIEEE80 {
        fatalError()
    }
    static func fixLifetime<T>(_: T) where T: ~Copyable, T: ~Escapable { fatalError() }
    static func fmul_FPIEEE32(_: Builtin.FPIEEE32, _: Builtin.FPIEEE32) -> Builtin.FPIEEE32 {
        fatalError()
    }
    static func fmul_FPIEEE64(_: Builtin.FPIEEE64, _: Builtin.FPIEEE64) -> Builtin.FPIEEE64 {
        fatalError()
    }
    static func fmul_FPIEEE80(_: Builtin.FPIEEE80, _: Builtin.FPIEEE80) -> Builtin.FPIEEE80 {
        fatalError()
    }
    static func fneg_FPIEEE32(_: Builtin.FPIEEE32) -> Builtin.FPIEEE32 { fatalError() }
    static func fneg_FPIEEE64(_: Builtin.FPIEEE64) -> Builtin.FPIEEE64 { fatalError() }
    static func fneg_FPIEEE80(_: Builtin.FPIEEE80) -> Builtin.FPIEEE80 { fatalError() }
    static func fpext_FPIEEE32_FPIEEE64(_: Builtin.FPIEEE32) -> Builtin.FPIEEE64 { fatalError() }
    static func fpext_FPIEEE32_FPIEEE80(_: Builtin.FPIEEE32) -> Builtin.FPIEEE80 { fatalError() }
    static func fpext_FPIEEE64_FPIEEE80(_: Builtin.FPIEEE64) -> Builtin.FPIEEE80 { fatalError() }
    static func fptosi_FPIEEE32_Int16(_: Builtin.FPIEEE32) -> Builtin.Int16 { fatalError() }
    static func fptosi_FPIEEE32_Int32(_: Builtin.FPIEEE32) -> Builtin.Int32 { fatalError() }
    static func fptosi_FPIEEE32_Int64(_: Builtin.FPIEEE32) -> Builtin.Int64 { fatalError() }
    static func fptosi_FPIEEE32_Int8(_: Builtin.FPIEEE32) -> Builtin.Int8 { fatalError() }
    static func fptosi_FPIEEE64_Int16(_: Builtin.FPIEEE64) -> Builtin.Int16 { fatalError() }
    static func fptosi_FPIEEE64_Int32(_: Builtin.FPIEEE64) -> Builtin.Int32 { fatalError() }
    static func fptosi_FPIEEE64_Int64(_: Builtin.FPIEEE64) -> Builtin.Int64 { fatalError() }
    static func fptosi_FPIEEE64_Int8(_: Builtin.FPIEEE64) -> Builtin.Int8 { fatalError() }
    static func fptosi_FPIEEE80_Int16(_: Builtin.FPIEEE80) -> Builtin.Int16 { fatalError() }
    static func fptosi_FPIEEE80_Int32(_: Builtin.FPIEEE80) -> Builtin.Int32 { fatalError() }
    static func fptosi_FPIEEE80_Int64(_: Builtin.FPIEEE80) -> Builtin.Int64 { fatalError() }
    static func fptosi_FPIEEE80_Int8(_: Builtin.FPIEEE80) -> Builtin.Int8 { fatalError() }
    static func fptoui_FPIEEE32_Int16(_: Builtin.FPIEEE32) -> Builtin.Int16 { fatalError() }
    static func fptoui_FPIEEE32_Int32(_: Builtin.FPIEEE32) -> Builtin.Int32 { fatalError() }
    static func fptoui_FPIEEE32_Int64(_: Builtin.FPIEEE32) -> Builtin.Int64 { fatalError() }
    static func fptoui_FPIEEE32_Int8(_: Builtin.FPIEEE32) -> Builtin.Int8 { fatalError() }
    static func fptoui_FPIEEE64_Int16(_: Builtin.FPIEEE64) -> Builtin.Int16 { fatalError() }
    static func fptoui_FPIEEE64_Int32(_: Builtin.FPIEEE64) -> Builtin.Int32 { fatalError() }
    static func fptoui_FPIEEE64_Int64(_: Builtin.FPIEEE64) -> Builtin.Int64 { fatalError() }
    static func fptoui_FPIEEE64_Int8(_: Builtin.FPIEEE64) -> Builtin.Int8 { fatalError() }
    static func fptoui_FPIEEE80_Int16(_: Builtin.FPIEEE80) -> Builtin.Int16 { fatalError() }
    static func fptoui_FPIEEE80_Int32(_: Builtin.FPIEEE80) -> Builtin.Int32 { fatalError() }
    static func fptoui_FPIEEE80_Int64(_: Builtin.FPIEEE80) -> Builtin.Int64 { fatalError() }
    static func fptoui_FPIEEE80_Int8(_: Builtin.FPIEEE80) -> Builtin.Int8 { fatalError() }
    static func fptrunc_FPIEEE64_FPIEEE32(_: Builtin.FPIEEE64) -> Builtin.FPIEEE32 { fatalError() }
    static func fptrunc_FPIEEE80_FPIEEE32(_: Builtin.FPIEEE80) -> Builtin.FPIEEE32 { fatalError() }
    static func fptrunc_FPIEEE80_FPIEEE64(_: Builtin.FPIEEE80) -> Builtin.FPIEEE64 { fatalError() }
    static func frem_FPIEEE32(_: Builtin.FPIEEE32, _: Builtin.FPIEEE32) -> Builtin.FPIEEE32 {
        fatalError()
    }
    static func frem_FPIEEE64(_: Builtin.FPIEEE64, _: Builtin.FPIEEE64) -> Builtin.FPIEEE64 {
        fatalError()
    }
    static func frem_FPIEEE80(_: Builtin.FPIEEE80, _: Builtin.FPIEEE80) -> Builtin.FPIEEE80 {
        fatalError()
    }
    static func fsub_FPIEEE32(_: Builtin.FPIEEE32, _: Builtin.FPIEEE32) -> Builtin.FPIEEE32 {
        fatalError()
    }
    static func fsub_FPIEEE64(_: Builtin.FPIEEE64, _: Builtin.FPIEEE64) -> Builtin.FPIEEE64 {
        fatalError()
    }
    static func fsub_FPIEEE80(_: Builtin.FPIEEE80, _: Builtin.FPIEEE80) -> Builtin.FPIEEE80 {
        fatalError()
    }
    static func gepRaw_Word(_: Builtin.RawPointer, _: Builtin.Word) -> Builtin.RawPointer {
        fatalError()
    }
    static func gep_Word<T>(_: Builtin.RawPointer, _: Builtin.Word, _: T.Type) -> Builtin.RawPointer
    where T: ~Copyable, T: ~Escapable { fatalError() }
    static func getObjCTypeEncoding<T>(_: T.Type) -> Builtin.RawPointer
    where T: ~Copyable, T: ~Escapable { fatalError() }
    static func initialize<T>(_: __owned T, _: Builtin.RawPointer)
    where T: ~Copyable, T: ~Escapable { fatalError() }
    static func insertelement_Vec16xFPIEEE32_FPIEEE32_Int32(
        _: Builtin.Vec16xFPIEEE32, _: Builtin.FPIEEE32, _: Builtin.Int32
    ) -> Builtin.Vec16xFPIEEE32 { fatalError() }
    static func insertelement_Vec16xFPIEEE64_FPIEEE64_Int32(
        _: Builtin.Vec16xFPIEEE64, _: Builtin.FPIEEE64, _: Builtin.Int32
    ) -> Builtin.Vec16xFPIEEE64 { fatalError() }
    static func insertelement_Vec16xInt16_Int16_Int32(
        _: Builtin.Vec16xInt16, _: Builtin.Int16, _: Builtin.Int32
    ) -> Builtin.Vec16xInt16 { fatalError() }
    static func insertelement_Vec16xInt32_Int32_Int32(
        _: Builtin.Vec16xInt32, _: Builtin.Int32, _: Builtin.Int32
    ) -> Builtin.Vec16xInt32 { fatalError() }
    static func insertelement_Vec16xInt64_Int64_Int32(
        _: Builtin.Vec16xInt64, _: Builtin.Int64, _: Builtin.Int32
    ) -> Builtin.Vec16xInt64 { fatalError() }
    static func insertelement_Vec16xInt8_Int8_Int32(
        _: Builtin.Vec16xInt8, _: Builtin.Int8, _: Builtin.Int32
    ) -> Builtin.Vec16xInt8 { fatalError() }
    static func insertelement_Vec2xFPIEEE32_FPIEEE32_Int32(
        _: Builtin.Vec2xFPIEEE32, _: Builtin.FPIEEE32, _: Builtin.Int32
    ) -> Builtin.Vec2xFPIEEE32 { fatalError() }
    static func insertelement_Vec2xFPIEEE64_FPIEEE64_Int32(
        _: Builtin.Vec2xFPIEEE64, _: Builtin.FPIEEE64, _: Builtin.Int32
    ) -> Builtin.Vec2xFPIEEE64 { fatalError() }
    static func insertelement_Vec2xInt16_Int16_Int32(
        _: Builtin.Vec2xInt16, _: Builtin.Int16, _: Builtin.Int32
    ) -> Builtin.Vec2xInt16 { fatalError() }
    static func insertelement_Vec2xInt32_Int32_Int32(
        _: Builtin.Vec2xInt32, _: Builtin.Int32, _: Builtin.Int32
    ) -> Builtin.Vec2xInt32 { fatalError() }
    static func insertelement_Vec2xInt64_Int64_Int32(
        _: Builtin.Vec2xInt64, _: Builtin.Int64, _: Builtin.Int32
    ) -> Builtin.Vec2xInt64 { fatalError() }
    static func insertelement_Vec2xInt8_Int8_Int32(
        _: Builtin.Vec2xInt8, _: Builtin.Int8, _: Builtin.Int32
    ) -> Builtin.Vec2xInt8 { fatalError() }
    static func insertelement_Vec32xFPIEEE32_FPIEEE32_Int32(
        _: Builtin.Vec32xFPIEEE32, _: Builtin.FPIEEE32, _: Builtin.Int32
    ) -> Builtin.Vec32xFPIEEE32 { fatalError() }
    static func insertelement_Vec32xFPIEEE64_FPIEEE64_Int32(
        _: Builtin.Vec32xFPIEEE64, _: Builtin.FPIEEE64, _: Builtin.Int32
    ) -> Builtin.Vec32xFPIEEE64 { fatalError() }
    static func insertelement_Vec32xInt16_Int16_Int32(
        _: Builtin.Vec32xInt16, _: Builtin.Int16, _: Builtin.Int32
    ) -> Builtin.Vec32xInt16 { fatalError() }
    static func insertelement_Vec32xInt32_Int32_Int32(
        _: Builtin.Vec32xInt32, _: Builtin.Int32, _: Builtin.Int32
    ) -> Builtin.Vec32xInt32 { fatalError() }
    static func insertelement_Vec32xInt64_Int64_Int32(
        _: Builtin.Vec32xInt64, _: Builtin.Int64, _: Builtin.Int32
    ) -> Builtin.Vec32xInt64 { fatalError() }
    static func insertelement_Vec32xInt8_Int8_Int32(
        _: Builtin.Vec32xInt8, _: Builtin.Int8, _: Builtin.Int32
    ) -> Builtin.Vec32xInt8 { fatalError() }
    static func insertelement_Vec4xFPIEEE32_FPIEEE32_Int32(
        _: Builtin.Vec4xFPIEEE32, _: Builtin.FPIEEE32, _: Builtin.Int32
    ) -> Builtin.Vec4xFPIEEE32 { fatalError() }
    static func insertelement_Vec4xFPIEEE64_FPIEEE64_Int32(
        _: Builtin.Vec4xFPIEEE64, _: Builtin.FPIEEE64, _: Builtin.Int32
    ) -> Builtin.Vec4xFPIEEE64 { fatalError() }
    static func insertelement_Vec4xInt16_Int16_Int32(
        _: Builtin.Vec4xInt16, _: Builtin.Int16, _: Builtin.Int32
    ) -> Builtin.Vec4xInt16 { fatalError() }
    static func insertelement_Vec4xInt32_Int32_Int32(
        _: Builtin.Vec4xInt32, _: Builtin.Int32, _: Builtin.Int32
    ) -> Builtin.Vec4xInt32 { fatalError() }
    static func insertelement_Vec4xInt64_Int64_Int32(
        _: Builtin.Vec4xInt64, _: Builtin.Int64, _: Builtin.Int32
    ) -> Builtin.Vec4xInt64 { fatalError() }
    static func insertelement_Vec4xInt8_Int8_Int32(
        _: Builtin.Vec4xInt8, _: Builtin.Int8, _: Builtin.Int32
    ) -> Builtin.Vec4xInt8 { fatalError() }
    static func insertelement_Vec64xFPIEEE32_FPIEEE32_Int32(
        _: Builtin.Vec64xFPIEEE32, _: Builtin.FPIEEE32, _: Builtin.Int32
    ) -> Builtin.Vec64xFPIEEE32 { fatalError() }
    static func insertelement_Vec64xFPIEEE64_FPIEEE64_Int32(
        _: Builtin.Vec64xFPIEEE64, _: Builtin.FPIEEE64, _: Builtin.Int32
    ) -> Builtin.Vec64xFPIEEE64 { fatalError() }
    static func insertelement_Vec64xInt16_Int16_Int32(
        _: Builtin.Vec64xInt16, _: Builtin.Int16, _: Builtin.Int32
    ) -> Builtin.Vec64xInt16 { fatalError() }
    static func insertelement_Vec64xInt32_Int32_Int32(
        _: Builtin.Vec64xInt32, _: Builtin.Int32, _: Builtin.Int32
    ) -> Builtin.Vec64xInt32 { fatalError() }
    static func insertelement_Vec64xInt64_Int64_Int32(
        _: Builtin.Vec64xInt64, _: Builtin.Int64, _: Builtin.Int32
    ) -> Builtin.Vec64xInt64 { fatalError() }
    static func insertelement_Vec64xInt8_Int8_Int32(
        _: Builtin.Vec64xInt8, _: Builtin.Int8, _: Builtin.Int32
    ) -> Builtin.Vec64xInt8 { fatalError() }
    static func insertelement_Vec8xFPIEEE32_FPIEEE32_Int32(
        _: Builtin.Vec8xFPIEEE32, _: Builtin.FPIEEE32, _: Builtin.Int32
    ) -> Builtin.Vec8xFPIEEE32 { fatalError() }
    static func insertelement_Vec8xFPIEEE64_FPIEEE64_Int32(
        _: Builtin.Vec8xFPIEEE64, _: Builtin.FPIEEE64, _: Builtin.Int32
    ) -> Builtin.Vec8xFPIEEE64 { fatalError() }
    static func insertelement_Vec8xInt16_Int16_Int32(
        _: Builtin.Vec8xInt16, _: Builtin.Int16, _: Builtin.Int32
    ) -> Builtin.Vec8xInt16 { fatalError() }
    static func insertelement_Vec8xInt32_Int32_Int32(
        _: Builtin.Vec8xInt32, _: Builtin.Int32, _: Builtin.Int32
    ) -> Builtin.Vec8xInt32 { fatalError() }
    static func insertelement_Vec8xInt64_Int64_Int32(
        _: Builtin.Vec8xInt64, _: Builtin.Int64, _: Builtin.Int32
    ) -> Builtin.Vec8xInt64 { fatalError() }
    static func insertelement_Vec8xInt8_Int8_Int32(
        _: Builtin.Vec8xInt8, _: Builtin.Int8, _: Builtin.Int32
    ) -> Builtin.Vec8xInt8 { fatalError() }
    static func int_bswap_Int16(_: Builtin.Int16) -> Builtin.Int16 { fatalError() }
    static func int_bswap_Int32(_: Builtin.Int32) -> Builtin.Int32 { fatalError() }
    static func int_bswap_Int64(_: Builtin.Int64) -> Builtin.Int64 { fatalError() }
    static func int_ceil_FPIEEE32(_: Builtin.FPIEEE32) -> Builtin.FPIEEE32 { fatalError() }
    static func int_ceil_FPIEEE64(_: Builtin.FPIEEE64) -> Builtin.FPIEEE64 { fatalError() }
    static func int_ceil_FPIEEE80(_: Builtin.FPIEEE80) -> Builtin.FPIEEE80 { fatalError() }
    static func int_copysign_FPIEEE32(_: Builtin.FPIEEE32, _: Builtin.FPIEEE32) -> Builtin.FPIEEE32
    { fatalError() }
    static func int_copysign_FPIEEE64(_: Builtin.FPIEEE64, _: Builtin.FPIEEE64) -> Builtin.FPIEEE64
    { fatalError() }
    static func int_copysign_FPIEEE80(_: Builtin.FPIEEE80, _: Builtin.FPIEEE80) -> Builtin.FPIEEE80
    { fatalError() }
    static func int_cos_FPIEEE32(_: Builtin.FPIEEE32) -> Builtin.FPIEEE32 { fatalError() }
    static func int_cos_FPIEEE64(_: Builtin.FPIEEE64) -> Builtin.FPIEEE64 { fatalError() }
    static func int_cos_FPIEEE80(_: Builtin.FPIEEE80) -> Builtin.FPIEEE80 { fatalError() }
    static func int_ctlz_Int16(_: Builtin.Int16, _: Builtin.Int1) -> Builtin.Int16 { fatalError() }
    static func int_ctlz_Int32(_: Builtin.Int32, _: Builtin.Int1) -> Builtin.Int32 { fatalError() }
    static func int_ctlz_Int64(_: Builtin.Int64, _: Builtin.Int1) -> Builtin.Int64 { fatalError() }
    static func int_ctlz_Int8(_: Builtin.Int8, _: Builtin.Int1) -> Builtin.Int8 { fatalError() }
    static func int_ctpop_Int16(_: Builtin.Int16) -> Builtin.Int16 { fatalError() }
    static func int_ctpop_Int32(_: Builtin.Int32) -> Builtin.Int32 { fatalError() }
    static func int_ctpop_Int64(_: Builtin.Int64) -> Builtin.Int64 { fatalError() }
    static func int_ctpop_Int8(_: Builtin.Int8) -> Builtin.Int8 { fatalError() }
    static func int_cttz_Int16(_: Builtin.Int16, _: Builtin.Int1) -> Builtin.Int16 { fatalError() }
    static func int_cttz_Int32(_: Builtin.Int32, _: Builtin.Int1) -> Builtin.Int32 { fatalError() }
    static func int_cttz_Int64(_: Builtin.Int64, _: Builtin.Int1) -> Builtin.Int64 { fatalError() }
    static func int_cttz_Int8(_: Builtin.Int8, _: Builtin.Int1) -> Builtin.Int8 { fatalError() }
    static func int_exp2_FPIEEE32(_: Builtin.FPIEEE32) -> Builtin.FPIEEE32 { fatalError() }
    static func int_exp2_FPIEEE64(_: Builtin.FPIEEE64) -> Builtin.FPIEEE64 { fatalError() }
    static func int_exp2_FPIEEE80(_: Builtin.FPIEEE80) -> Builtin.FPIEEE80 { fatalError() }
    static func int_exp_FPIEEE32(_: Builtin.FPIEEE32) -> Builtin.FPIEEE32 { fatalError() }
    static func int_exp_FPIEEE64(_: Builtin.FPIEEE64) -> Builtin.FPIEEE64 { fatalError() }
    static func int_exp_FPIEEE80(_: Builtin.FPIEEE80) -> Builtin.FPIEEE80 { fatalError() }
    static func int_expect_Int1(_: Builtin.Int1, _: Builtin.Int1) -> Builtin.Int1 { fatalError() }
    static func int_fabs_FPIEEE32(_: Builtin.FPIEEE32) -> Builtin.FPIEEE32 { fatalError() }
    static func int_fabs_FPIEEE64(_: Builtin.FPIEEE64) -> Builtin.FPIEEE64 { fatalError() }
    static func int_fabs_FPIEEE80(_: Builtin.FPIEEE80) -> Builtin.FPIEEE80 { fatalError() }
    static func int_floor_FPIEEE32(_: Builtin.FPIEEE32) -> Builtin.FPIEEE32 { fatalError() }
    static func int_floor_FPIEEE64(_: Builtin.FPIEEE64) -> Builtin.FPIEEE64 { fatalError() }
    static func int_floor_FPIEEE80(_: Builtin.FPIEEE80) -> Builtin.FPIEEE80 { fatalError() }
    static func int_fma_FPIEEE32(_: Builtin.FPIEEE32, _: Builtin.FPIEEE32, _: Builtin.FPIEEE32)
        -> Builtin.FPIEEE32
    { fatalError() }
    static func int_fma_FPIEEE64(_: Builtin.FPIEEE64, _: Builtin.FPIEEE64, _: Builtin.FPIEEE64)
        -> Builtin.FPIEEE64
    { fatalError() }
    static func int_fma_FPIEEE80(_: Builtin.FPIEEE80, _: Builtin.FPIEEE80, _: Builtin.FPIEEE80)
        -> Builtin.FPIEEE80
    { fatalError() }
    static func int_is_constant_Word(_: Builtin.Word) -> Builtin.Int1 { fatalError() }
    static func int_log10_FPIEEE32(_: Builtin.FPIEEE32) -> Builtin.FPIEEE32 { fatalError() }
    static func int_log10_FPIEEE64(_: Builtin.FPIEEE64) -> Builtin.FPIEEE64 { fatalError() }
    static func int_log10_FPIEEE80(_: Builtin.FPIEEE80) -> Builtin.FPIEEE80 { fatalError() }
    static func int_log2_FPIEEE32(_: Builtin.FPIEEE32) -> Builtin.FPIEEE32 { fatalError() }
    static func int_log2_FPIEEE64(_: Builtin.FPIEEE64) -> Builtin.FPIEEE64 { fatalError() }
    static func int_log2_FPIEEE80(_: Builtin.FPIEEE80) -> Builtin.FPIEEE80 { fatalError() }
    static func int_log_FPIEEE32(_: Builtin.FPIEEE32) -> Builtin.FPIEEE32 { fatalError() }
    static func int_log_FPIEEE64(_: Builtin.FPIEEE64) -> Builtin.FPIEEE64 { fatalError() }
    static func int_log_FPIEEE80(_: Builtin.FPIEEE80) -> Builtin.FPIEEE80 { fatalError() }
    static func int_memcpy_RawPointer_RawPointer_Int64(
        _: Builtin.RawPointer, _: Builtin.RawPointer, _: Builtin.Int64, _: Builtin.Int1
    ) { fatalError() }
    static func int_memmove_RawPointer_RawPointer_Int64(
        _: Builtin.RawPointer, _: Builtin.RawPointer, _: Builtin.Int64, _: Builtin.Int1
    ) { fatalError() }
    static func int_nearbyint_FPIEEE32(_: Builtin.FPIEEE32) -> Builtin.FPIEEE32 { fatalError() }
    static func int_nearbyint_FPIEEE64(_: Builtin.FPIEEE64) -> Builtin.FPIEEE64 { fatalError() }
    static func int_nearbyint_FPIEEE80(_: Builtin.FPIEEE80) -> Builtin.FPIEEE80 { fatalError() }
    static func int_rint_FPIEEE32(_: Builtin.FPIEEE32) -> Builtin.FPIEEE32 { fatalError() }
    static func int_rint_FPIEEE64(_: Builtin.FPIEEE64) -> Builtin.FPIEEE64 { fatalError() }
    static func int_rint_FPIEEE80(_: Builtin.FPIEEE80) -> Builtin.FPIEEE80 { fatalError() }
    static func int_round_FPIEEE32(_: Builtin.FPIEEE32) -> Builtin.FPIEEE32 { fatalError() }
    static func int_round_FPIEEE64(_: Builtin.FPIEEE64) -> Builtin.FPIEEE64 { fatalError() }
    static func int_round_FPIEEE80(_: Builtin.FPIEEE80) -> Builtin.FPIEEE80 { fatalError() }
    static func int_sin_FPIEEE32(_: Builtin.FPIEEE32) -> Builtin.FPIEEE32 { fatalError() }
    static func int_sin_FPIEEE64(_: Builtin.FPIEEE64) -> Builtin.FPIEEE64 { fatalError() }
    static func int_sin_FPIEEE80(_: Builtin.FPIEEE80) -> Builtin.FPIEEE80 { fatalError() }
    static func int_trap() -> Never { fatalError() }
    static func int_trunc_FPIEEE32(_: Builtin.FPIEEE32) -> Builtin.FPIEEE32 { fatalError() }
    static func int_trunc_FPIEEE64(_: Builtin.FPIEEE64) -> Builtin.FPIEEE64 { fatalError() }
    static func int_trunc_FPIEEE80(_: Builtin.FPIEEE80) -> Builtin.FPIEEE80 { fatalError() }
    static func inttoptr_Word(_: Builtin.Word) -> Builtin.RawPointer { fatalError() }
    static func isConcrete<T>(_: T.Type) -> Builtin.Int1 where T: ~Copyable, T: ~Escapable {
        fatalError()
    }
    static func isNegative_IntLiteral(_: Builtin.IntLiteral) -> Builtin.Int1 { fatalError() }
    static func isOptional<T>(_: T.Type) -> Builtin.Int1 where T: ~Copyable, T: ~Escapable {
        fatalError()
    }
    static func isUnique<T>(_: inout T) -> Builtin.Int1 where T: ~Copyable, T: ~Escapable {
        fatalError()
    }
    static func isUnique_native<T>(_: inout T) -> Builtin.Int1 where T: ~Copyable, T: ~Escapable {
        fatalError()
    }
    static func is_same_metatype(
        _: any (~Copyable & ~Escapable).Type, _: any (~Copyable & ~Escapable).Type
    ) -> Builtin.Int1 { fatalError() }
    static func isbitwisetakable<T>(_: T.Type) -> Builtin.Int1 where T: ~Copyable, T: ~Escapable {
        fatalError()
    }
    static func ispod<T>(_: T.Type) -> Builtin.Int1 where T: ~Copyable, T: ~Escapable {
        fatalError()
    }
    static func itofp_with_overflow_IntLiteral_FPIEEE32(_: Builtin.IntLiteral) -> Builtin.FPIEEE32 {
        fatalError()
    }
    static func itofp_with_overflow_IntLiteral_FPIEEE64(_: Builtin.IntLiteral) -> Builtin.FPIEEE64 {
        fatalError()
    }
    static func itofp_with_overflow_IntLiteral_FPIEEE80(_: Builtin.IntLiteral) -> Builtin.FPIEEE80 {
        fatalError()
    }
    static func loadRaw<T>(_: Builtin.RawPointer) -> T where T: ~Escapable { fatalError() }
    static func lshr_Int128(_: Builtin.Int128, _: Builtin.Int128) -> Builtin.Int128 { fatalError() }
    static func lshr_Int16(_: Builtin.Int16, _: Builtin.Int16) -> Builtin.Int16 { fatalError() }
    static func lshr_Int32(_: Builtin.Int32, _: Builtin.Int32) -> Builtin.Int32 { fatalError() }
    static func lshr_Int64(_: Builtin.Int64, _: Builtin.Int64) -> Builtin.Int64 { fatalError() }
    static func lshr_Int8(_: Builtin.Int8, _: Builtin.Int8) -> Builtin.Int8 { fatalError() }
    static func makeBorrow<T>(_: __shared T) -> Builtin.Borrow<τ_0_0>
    where T: ~Copyable, T: ~Escapable { fatalError() }
    static func markDependence<T, U>(_: T, _: U) -> T
    where T: ~Copyable, T: ~Escapable, U: ~Copyable, U: ~Escapable { fatalError() }
    static func mul_Int128(_: Builtin.Int128, _: Builtin.Int128) -> Builtin.Int128 { fatalError() }
    static func mul_Int16(_: Builtin.Int16, _: Builtin.Int16) -> Builtin.Int16 { fatalError() }
    static func mul_Int32(_: Builtin.Int32, _: Builtin.Int32) -> Builtin.Int32 { fatalError() }
    static func mul_Int64(_: Builtin.Int64, _: Builtin.Int64) -> Builtin.Int64 { fatalError() }
    static func mul_Vec16xInt16(_: Builtin.Vec16xInt16, _: Builtin.Vec16xInt16)
        -> Builtin.Vec16xInt16
    { fatalError() }
    static func mul_Vec16xInt32(_: Builtin.Vec16xInt32, _: Builtin.Vec16xInt32)
        -> Builtin.Vec16xInt32
    { fatalError() }
    static func mul_Vec16xInt64(_: Builtin.Vec16xInt64, _: Builtin.Vec16xInt64)
        -> Builtin.Vec16xInt64
    { fatalError() }
    static func mul_Vec16xInt8(_: Builtin.Vec16xInt8, _: Builtin.Vec16xInt8) -> Builtin.Vec16xInt8 {
        fatalError()
    }
    static func mul_Vec2xInt16(_: Builtin.Vec2xInt16, _: Builtin.Vec2xInt16) -> Builtin.Vec2xInt16 {
        fatalError()
    }
    static func mul_Vec2xInt32(_: Builtin.Vec2xInt32, _: Builtin.Vec2xInt32) -> Builtin.Vec2xInt32 {
        fatalError()
    }
    static func mul_Vec2xInt64(_: Builtin.Vec2xInt64, _: Builtin.Vec2xInt64) -> Builtin.Vec2xInt64 {
        fatalError()
    }
    static func mul_Vec2xInt8(_: Builtin.Vec2xInt8, _: Builtin.Vec2xInt8) -> Builtin.Vec2xInt8 {
        fatalError()
    }
    static func mul_Vec32xInt16(_: Builtin.Vec32xInt16, _: Builtin.Vec32xInt16)
        -> Builtin.Vec32xInt16
    { fatalError() }
    static func mul_Vec32xInt32(_: Builtin.Vec32xInt32, _: Builtin.Vec32xInt32)
        -> Builtin.Vec32xInt32
    { fatalError() }
    static func mul_Vec32xInt64(_: Builtin.Vec32xInt64, _: Builtin.Vec32xInt64)
        -> Builtin.Vec32xInt64
    { fatalError() }
    static func mul_Vec32xInt8(_: Builtin.Vec32xInt8, _: Builtin.Vec32xInt8) -> Builtin.Vec32xInt8 {
        fatalError()
    }
    static func mul_Vec4xInt16(_: Builtin.Vec4xInt16, _: Builtin.Vec4xInt16) -> Builtin.Vec4xInt16 {
        fatalError()
    }
    static func mul_Vec4xInt32(_: Builtin.Vec4xInt32, _: Builtin.Vec4xInt32) -> Builtin.Vec4xInt32 {
        fatalError()
    }
    static func mul_Vec4xInt64(_: Builtin.Vec4xInt64, _: Builtin.Vec4xInt64) -> Builtin.Vec4xInt64 {
        fatalError()
    }
    static func mul_Vec4xInt8(_: Builtin.Vec4xInt8, _: Builtin.Vec4xInt8) -> Builtin.Vec4xInt8 {
        fatalError()
    }
    static func mul_Vec64xInt16(_: Builtin.Vec64xInt16, _: Builtin.Vec64xInt16)
        -> Builtin.Vec64xInt16
    { fatalError() }
    static func mul_Vec64xInt32(_: Builtin.Vec64xInt32, _: Builtin.Vec64xInt32)
        -> Builtin.Vec64xInt32
    { fatalError() }
    static func mul_Vec64xInt64(_: Builtin.Vec64xInt64, _: Builtin.Vec64xInt64)
        -> Builtin.Vec64xInt64
    { fatalError() }
    static func mul_Vec64xInt8(_: Builtin.Vec64xInt8, _: Builtin.Vec64xInt8) -> Builtin.Vec64xInt8 {
        fatalError()
    }
    static func mul_Vec8xInt16(_: Builtin.Vec8xInt16, _: Builtin.Vec8xInt16) -> Builtin.Vec8xInt16 {
        fatalError()
    }
    static func mul_Vec8xInt32(_: Builtin.Vec8xInt32, _: Builtin.Vec8xInt32) -> Builtin.Vec8xInt32 {
        fatalError()
    }
    static func mul_Vec8xInt64(_: Builtin.Vec8xInt64, _: Builtin.Vec8xInt64) -> Builtin.Vec8xInt64 {
        fatalError()
    }
    static func mul_Vec8xInt8(_: Builtin.Vec8xInt8, _: Builtin.Vec8xInt8) -> Builtin.Vec8xInt8 {
        fatalError()
    }
    static func onFastPath() { fatalError() }
    static func or_Int1(_: Builtin.Int1, _: Builtin.Int1) -> Builtin.Int1 { fatalError() }
    static func or_Int128(_: Builtin.Int128, _: Builtin.Int128) -> Builtin.Int128 { fatalError() }
    static func or_Int16(_: Builtin.Int16, _: Builtin.Int16) -> Builtin.Int16 { fatalError() }
    static func or_Int32(_: Builtin.Int32, _: Builtin.Int32) -> Builtin.Int32 { fatalError() }
    static func or_Int64(_: Builtin.Int64, _: Builtin.Int64) -> Builtin.Int64 { fatalError() }
    static func or_Int8(_: Builtin.Int8, _: Builtin.Int8) -> Builtin.Int8 { fatalError() }
    static func or_Vec16xInt16(_: Builtin.Vec16xInt16, _: Builtin.Vec16xInt16)
        -> Builtin.Vec16xInt16
    { fatalError() }
    static func or_Vec16xInt32(_: Builtin.Vec16xInt32, _: Builtin.Vec16xInt32)
        -> Builtin.Vec16xInt32
    { fatalError() }
    static func or_Vec16xInt64(_: Builtin.Vec16xInt64, _: Builtin.Vec16xInt64)
        -> Builtin.Vec16xInt64
    { fatalError() }
    static func or_Vec16xInt8(_: Builtin.Vec16xInt8, _: Builtin.Vec16xInt8) -> Builtin.Vec16xInt8 {
        fatalError()
    }
    static func or_Vec2xInt16(_: Builtin.Vec2xInt16, _: Builtin.Vec2xInt16) -> Builtin.Vec2xInt16 {
        fatalError()
    }
    static func or_Vec2xInt32(_: Builtin.Vec2xInt32, _: Builtin.Vec2xInt32) -> Builtin.Vec2xInt32 {
        fatalError()
    }
    static func or_Vec2xInt64(_: Builtin.Vec2xInt64, _: Builtin.Vec2xInt64) -> Builtin.Vec2xInt64 {
        fatalError()
    }
    static func or_Vec2xInt8(_: Builtin.Vec2xInt8, _: Builtin.Vec2xInt8) -> Builtin.Vec2xInt8 {
        fatalError()
    }
    static func or_Vec32xInt16(_: Builtin.Vec32xInt16, _: Builtin.Vec32xInt16)
        -> Builtin.Vec32xInt16
    { fatalError() }
    static func or_Vec32xInt32(_: Builtin.Vec32xInt32, _: Builtin.Vec32xInt32)
        -> Builtin.Vec32xInt32
    { fatalError() }
    static func or_Vec32xInt64(_: Builtin.Vec32xInt64, _: Builtin.Vec32xInt64)
        -> Builtin.Vec32xInt64
    { fatalError() }
    static func or_Vec32xInt8(_: Builtin.Vec32xInt8, _: Builtin.Vec32xInt8) -> Builtin.Vec32xInt8 {
        fatalError()
    }
    static func or_Vec4xInt16(_: Builtin.Vec4xInt16, _: Builtin.Vec4xInt16) -> Builtin.Vec4xInt16 {
        fatalError()
    }
    static func or_Vec4xInt32(_: Builtin.Vec4xInt32, _: Builtin.Vec4xInt32) -> Builtin.Vec4xInt32 {
        fatalError()
    }
    static func or_Vec4xInt64(_: Builtin.Vec4xInt64, _: Builtin.Vec4xInt64) -> Builtin.Vec4xInt64 {
        fatalError()
    }
    static func or_Vec4xInt8(_: Builtin.Vec4xInt8, _: Builtin.Vec4xInt8) -> Builtin.Vec4xInt8 {
        fatalError()
    }
    static func or_Vec64xInt16(_: Builtin.Vec64xInt16, _: Builtin.Vec64xInt16)
        -> Builtin.Vec64xInt16
    { fatalError() }
    static func or_Vec64xInt32(_: Builtin.Vec64xInt32, _: Builtin.Vec64xInt32)
        -> Builtin.Vec64xInt32
    { fatalError() }
    static func or_Vec64xInt64(_: Builtin.Vec64xInt64, _: Builtin.Vec64xInt64)
        -> Builtin.Vec64xInt64
    { fatalError() }
    static func or_Vec64xInt8(_: Builtin.Vec64xInt8, _: Builtin.Vec64xInt8) -> Builtin.Vec64xInt8 {
        fatalError()
    }
    static func or_Vec8xInt16(_: Builtin.Vec8xInt16, _: Builtin.Vec8xInt16) -> Builtin.Vec8xInt16 {
        fatalError()
    }
    static func or_Vec8xInt32(_: Builtin.Vec8xInt32, _: Builtin.Vec8xInt32) -> Builtin.Vec8xInt32 {
        fatalError()
    }
    static func or_Vec8xInt64(_: Builtin.Vec8xInt64, _: Builtin.Vec8xInt64) -> Builtin.Vec8xInt64 {
        fatalError()
    }
    static func or_Vec8xInt8(_: Builtin.Vec8xInt8, _: Builtin.Vec8xInt8) -> Builtin.Vec8xInt8 {
        fatalError()
    }
    static func projectTailElems<T, U>(_: T, _: U.Type) -> Builtin.RawPointer
    where T: ~Copyable, T: ~Escapable, U: ~Copyable, U: ~Escapable { fatalError() }
    static func ptrtoint_Word(_: Builtin.RawPointer) -> Builtin.Word { fatalError() }
    static func rebindMemory(_: Builtin.RawPointer, _: Builtin.Word) -> Builtin.Word {
        fatalError()
    }
    static func reinterpretCast<T, U>(_: __owned T) -> U
    where T: ~Copyable, T: ~Escapable, U: ~Copyable { fatalError() }
    static func release<T>(_: T) where T: ~Escapable { fatalError() }
    static func retain<T>(_: T) where T: ~Escapable { fatalError() }
    static func s_to_s_checked_trunc_Int128_Int64(_: Builtin.Int128) -> (
        Builtin.Int64, Builtin.Int1
    ) { fatalError() }
    static func s_to_s_checked_trunc_IntLiteral_Int128(_: Builtin.IntLiteral) -> (
        Builtin.Int128, Builtin.Int1
    ) { fatalError() }
    static func s_to_s_checked_trunc_IntLiteral_Int16(_: Builtin.IntLiteral) -> (
        Builtin.Int16, Builtin.Int1
    ) { fatalError() }
    static func s_to_s_checked_trunc_IntLiteral_Int32(_: Builtin.IntLiteral) -> (
        Builtin.Int32, Builtin.Int1
    ) { fatalError() }
    static func s_to_s_checked_trunc_IntLiteral_Int64(_: Builtin.IntLiteral) -> (
        Builtin.Int64, Builtin.Int1
    ) { fatalError() }
    static func s_to_s_checked_trunc_IntLiteral_Int8(_: Builtin.IntLiteral) -> (
        Builtin.Int8, Builtin.Int1
    ) { fatalError() }
    static func s_to_u_checked_trunc_IntLiteral_Int128(_: Builtin.IntLiteral) -> (
        Builtin.Int128, Builtin.Int1
    ) { fatalError() }
    static func s_to_u_checked_trunc_IntLiteral_Int16(_: Builtin.IntLiteral) -> (
        Builtin.Int16, Builtin.Int1
    ) { fatalError() }
    static func s_to_u_checked_trunc_IntLiteral_Int32(_: Builtin.IntLiteral) -> (
        Builtin.Int32, Builtin.Int1
    ) { fatalError() }
    static func s_to_u_checked_trunc_IntLiteral_Int64(_: Builtin.IntLiteral) -> (
        Builtin.Int64, Builtin.Int1
    ) { fatalError() }
    static func s_to_u_checked_trunc_IntLiteral_Int8(_: Builtin.IntLiteral) -> (
        Builtin.Int8, Builtin.Int1
    ) { fatalError() }
    static func sadd_with_overflow_Int128(_: Builtin.Int128, _: Builtin.Int128, _: Builtin.Int1)
        -> (Builtin.Int128, Builtin.Int1)
    { fatalError() }
    static func sadd_with_overflow_Int16(_: Builtin.Int16, _: Builtin.Int16, _: Builtin.Int1) -> (
        Builtin.Int16, Builtin.Int1
    ) { fatalError() }
    static func sadd_with_overflow_Int32(_: Builtin.Int32, _: Builtin.Int32, _: Builtin.Int1) -> (
        Builtin.Int32, Builtin.Int1
    ) { fatalError() }
    static func sadd_with_overflow_Int64(_: Builtin.Int64, _: Builtin.Int64, _: Builtin.Int1) -> (
        Builtin.Int64, Builtin.Int1
    ) { fatalError() }
    static func sadd_with_overflow_Int8(_: Builtin.Int8, _: Builtin.Int8, _: Builtin.Int1) -> (
        Builtin.Int8, Builtin.Int1
    ) { fatalError() }
    static func sdiv_Int128(_: Builtin.Int128, _: Builtin.Int128) -> Builtin.Int128 { fatalError() }
    static func sdiv_Int16(_: Builtin.Int16, _: Builtin.Int16) -> Builtin.Int16 { fatalError() }
    static func sdiv_Int32(_: Builtin.Int32, _: Builtin.Int32) -> Builtin.Int32 { fatalError() }
    static func sdiv_Int64(_: Builtin.Int64, _: Builtin.Int64) -> Builtin.Int64 { fatalError() }
    static func sdiv_Int8(_: Builtin.Int8, _: Builtin.Int8) -> Builtin.Int8 { fatalError() }
    static func sextOrBitCast_Int16_Int64(_: Builtin.Int16) -> Builtin.Int64 { fatalError() }
    static func sextOrBitCast_Int32_Int64(_: Builtin.Int32) -> Builtin.Int64 { fatalError() }
    static func sextOrBitCast_Int64_Int64(_: Builtin.Int64) -> Builtin.Int64 { fatalError() }
    static func sextOrBitCast_Int8_Int64(_: Builtin.Int8) -> Builtin.Int64 { fatalError() }
    static func sextOrBitCast_Word_Int64(_: Builtin.Word) -> Builtin.Int64 { fatalError() }
    static func sext_Int16_Int32(_: Builtin.Int16) -> Builtin.Int32 { fatalError() }
    static func sext_Int32_Int64(_: Builtin.Int32) -> Builtin.Int64 { fatalError() }
    static func sext_Int64_Int128(_: Builtin.Int64) -> Builtin.Int128 { fatalError() }
    static func sext_Int8_Int16(_: Builtin.Int8) -> Builtin.Int16 { fatalError() }
    static func sext_Vec16xInt1_Vec16xInt16(_: Builtin.Vec16xInt1) -> Builtin.Vec16xInt16 {
        fatalError()
    }
    static func sext_Vec16xInt1_Vec16xInt32(_: Builtin.Vec16xInt1) -> Builtin.Vec16xInt32 {
        fatalError()
    }
    static func sext_Vec16xInt1_Vec16xInt64(_: Builtin.Vec16xInt1) -> Builtin.Vec16xInt64 {
        fatalError()
    }
    static func sext_Vec16xInt1_Vec16xInt8(_: Builtin.Vec16xInt1) -> Builtin.Vec16xInt8 {
        fatalError()
    }
    static func sext_Vec2xInt1_Vec2xInt16(_: Builtin.Vec2xInt1) -> Builtin.Vec2xInt16 {
        fatalError()
    }
    static func sext_Vec2xInt1_Vec2xInt32(_: Builtin.Vec2xInt1) -> Builtin.Vec2xInt32 {
        fatalError()
    }
    static func sext_Vec2xInt1_Vec2xInt64(_: Builtin.Vec2xInt1) -> Builtin.Vec2xInt64 {
        fatalError()
    }
    static func sext_Vec2xInt1_Vec2xInt8(_: Builtin.Vec2xInt1) -> Builtin.Vec2xInt8 { fatalError() }
    static func sext_Vec32xInt1_Vec32xInt16(_: Builtin.Vec32xInt1) -> Builtin.Vec32xInt16 {
        fatalError()
    }
    static func sext_Vec32xInt1_Vec32xInt32(_: Builtin.Vec32xInt1) -> Builtin.Vec32xInt32 {
        fatalError()
    }
    static func sext_Vec32xInt1_Vec32xInt64(_: Builtin.Vec32xInt1) -> Builtin.Vec32xInt64 {
        fatalError()
    }
    static func sext_Vec32xInt1_Vec32xInt8(_: Builtin.Vec32xInt1) -> Builtin.Vec32xInt8 {
        fatalError()
    }
    static func sext_Vec4xInt1_Vec4xInt16(_: Builtin.Vec4xInt1) -> Builtin.Vec4xInt16 {
        fatalError()
    }
    static func sext_Vec4xInt1_Vec4xInt32(_: Builtin.Vec4xInt1) -> Builtin.Vec4xInt32 {
        fatalError()
    }
    static func sext_Vec4xInt1_Vec4xInt64(_: Builtin.Vec4xInt1) -> Builtin.Vec4xInt64 {
        fatalError()
    }
    static func sext_Vec4xInt1_Vec4xInt8(_: Builtin.Vec4xInt1) -> Builtin.Vec4xInt8 { fatalError() }
    static func sext_Vec64xInt1_Vec64xInt16(_: Builtin.Vec64xInt1) -> Builtin.Vec64xInt16 {
        fatalError()
    }
    static func sext_Vec64xInt1_Vec64xInt32(_: Builtin.Vec64xInt1) -> Builtin.Vec64xInt32 {
        fatalError()
    }
    static func sext_Vec64xInt1_Vec64xInt64(_: Builtin.Vec64xInt1) -> Builtin.Vec64xInt64 {
        fatalError()
    }
    static func sext_Vec64xInt1_Vec64xInt8(_: Builtin.Vec64xInt1) -> Builtin.Vec64xInt8 {
        fatalError()
    }
    static func sext_Vec8xInt1_Vec8xInt16(_: Builtin.Vec8xInt1) -> Builtin.Vec8xInt16 {
        fatalError()
    }
    static func sext_Vec8xInt1_Vec8xInt32(_: Builtin.Vec8xInt1) -> Builtin.Vec8xInt32 {
        fatalError()
    }
    static func sext_Vec8xInt1_Vec8xInt64(_: Builtin.Vec8xInt1) -> Builtin.Vec8xInt64 {
        fatalError()
    }
    static func sext_Vec8xInt1_Vec8xInt8(_: Builtin.Vec8xInt1) -> Builtin.Vec8xInt8 { fatalError() }
    static func shl_Int128(_: Builtin.Int128, _: Builtin.Int128) -> Builtin.Int128 { fatalError() }
    static func shl_Int16(_: Builtin.Int16, _: Builtin.Int16) -> Builtin.Int16 { fatalError() }
    static func shl_Int32(_: Builtin.Int32, _: Builtin.Int32) -> Builtin.Int32 { fatalError() }
    static func shl_Int64(_: Builtin.Int64, _: Builtin.Int64) -> Builtin.Int64 { fatalError() }
    static func shl_Int8(_: Builtin.Int8, _: Builtin.Int8) -> Builtin.Int8 { fatalError() }
    static func shufflevector_Vec16xFPIEEE32_Vec16xInt32(
        _: Builtin.Vec16xFPIEEE32, _: Builtin.Vec16xFPIEEE32, _: Builtin.Vec16xInt32
    ) -> Builtin.Vec16xFPIEEE32 { fatalError() }
    static func shufflevector_Vec16xFPIEEE64_Vec16xInt32(
        _: Builtin.Vec16xFPIEEE64, _: Builtin.Vec16xFPIEEE64, _: Builtin.Vec16xInt32
    ) -> Builtin.Vec16xFPIEEE64 { fatalError() }
    static func shufflevector_Vec16xInt16_Vec16xInt32(
        _: Builtin.Vec16xInt16, _: Builtin.Vec16xInt16, _: Builtin.Vec16xInt32
    ) -> Builtin.Vec16xInt16 { fatalError() }
    static func shufflevector_Vec16xInt32_Vec16xInt32(
        _: Builtin.Vec16xInt32, _: Builtin.Vec16xInt32, _: Builtin.Vec16xInt32
    ) -> Builtin.Vec16xInt32 { fatalError() }
    static func shufflevector_Vec16xInt64_Vec16xInt32(
        _: Builtin.Vec16xInt64, _: Builtin.Vec16xInt64, _: Builtin.Vec16xInt32
    ) -> Builtin.Vec16xInt64 { fatalError() }
    static func shufflevector_Vec16xInt8_Vec16xInt32(
        _: Builtin.Vec16xInt8, _: Builtin.Vec16xInt8, _: Builtin.Vec16xInt32
    ) -> Builtin.Vec16xInt8 { fatalError() }
    static func shufflevector_Vec2xFPIEEE32_Vec2xInt32(
        _: Builtin.Vec2xFPIEEE32, _: Builtin.Vec2xFPIEEE32, _: Builtin.Vec2xInt32
    ) -> Builtin.Vec2xFPIEEE32 { fatalError() }
    static func shufflevector_Vec2xFPIEEE64_Vec2xInt32(
        _: Builtin.Vec2xFPIEEE64, _: Builtin.Vec2xFPIEEE64, _: Builtin.Vec2xInt32
    ) -> Builtin.Vec2xFPIEEE64 { fatalError() }
    static func shufflevector_Vec2xInt16_Vec2xInt32(
        _: Builtin.Vec2xInt16, _: Builtin.Vec2xInt16, _: Builtin.Vec2xInt32
    ) -> Builtin.Vec2xInt16 { fatalError() }
    static func shufflevector_Vec2xInt32_Vec2xInt32(
        _: Builtin.Vec2xInt32, _: Builtin.Vec2xInt32, _: Builtin.Vec2xInt32
    ) -> Builtin.Vec2xInt32 { fatalError() }
    static func shufflevector_Vec2xInt64_Vec2xInt32(
        _: Builtin.Vec2xInt64, _: Builtin.Vec2xInt64, _: Builtin.Vec2xInt32
    ) -> Builtin.Vec2xInt64 { fatalError() }
    static func shufflevector_Vec2xInt8_Vec2xInt32(
        _: Builtin.Vec2xInt8, _: Builtin.Vec2xInt8, _: Builtin.Vec2xInt32
    ) -> Builtin.Vec2xInt8 { fatalError() }
    static func shufflevector_Vec32xFPIEEE32_Vec32xInt32(
        _: Builtin.Vec32xFPIEEE32, _: Builtin.Vec32xFPIEEE32, _: Builtin.Vec32xInt32
    ) -> Builtin.Vec32xFPIEEE32 { fatalError() }
    static func shufflevector_Vec32xFPIEEE64_Vec32xInt32(
        _: Builtin.Vec32xFPIEEE64, _: Builtin.Vec32xFPIEEE64, _: Builtin.Vec32xInt32
    ) -> Builtin.Vec32xFPIEEE64 { fatalError() }
    static func shufflevector_Vec32xInt16_Vec32xInt32(
        _: Builtin.Vec32xInt16, _: Builtin.Vec32xInt16, _: Builtin.Vec32xInt32
    ) -> Builtin.Vec32xInt16 { fatalError() }
    static func shufflevector_Vec32xInt32_Vec32xInt32(
        _: Builtin.Vec32xInt32, _: Builtin.Vec32xInt32, _: Builtin.Vec32xInt32
    ) -> Builtin.Vec32xInt32 { fatalError() }
    static func shufflevector_Vec32xInt64_Vec32xInt32(
        _: Builtin.Vec32xInt64, _: Builtin.Vec32xInt64, _: Builtin.Vec32xInt32
    ) -> Builtin.Vec32xInt64 { fatalError() }
    static func shufflevector_Vec32xInt8_Vec32xInt32(
        _: Builtin.Vec32xInt8, _: Builtin.Vec32xInt8, _: Builtin.Vec32xInt32
    ) -> Builtin.Vec32xInt8 { fatalError() }
    static func shufflevector_Vec4xFPIEEE32_Vec4xInt32(
        _: Builtin.Vec4xFPIEEE32, _: Builtin.Vec4xFPIEEE32, _: Builtin.Vec4xInt32
    ) -> Builtin.Vec4xFPIEEE32 { fatalError() }
    static func shufflevector_Vec4xFPIEEE64_Vec4xInt32(
        _: Builtin.Vec4xFPIEEE64, _: Builtin.Vec4xFPIEEE64, _: Builtin.Vec4xInt32
    ) -> Builtin.Vec4xFPIEEE64 { fatalError() }
    static func shufflevector_Vec4xInt16_Vec4xInt32(
        _: Builtin.Vec4xInt16, _: Builtin.Vec4xInt16, _: Builtin.Vec4xInt32
    ) -> Builtin.Vec4xInt16 { fatalError() }
    static func shufflevector_Vec4xInt32_Vec4xInt32(
        _: Builtin.Vec4xInt32, _: Builtin.Vec4xInt32, _: Builtin.Vec4xInt32
    ) -> Builtin.Vec4xInt32 { fatalError() }
    static func shufflevector_Vec4xInt64_Vec4xInt32(
        _: Builtin.Vec4xInt64, _: Builtin.Vec4xInt64, _: Builtin.Vec4xInt32
    ) -> Builtin.Vec4xInt64 { fatalError() }
    static func shufflevector_Vec4xInt8_Vec4xInt32(
        _: Builtin.Vec4xInt8, _: Builtin.Vec4xInt8, _: Builtin.Vec4xInt32
    ) -> Builtin.Vec4xInt8 { fatalError() }
    static func shufflevector_Vec64xFPIEEE32_Vec64xInt32(
        _: Builtin.Vec64xFPIEEE32, _: Builtin.Vec64xFPIEEE32, _: Builtin.Vec64xInt32
    ) -> Builtin.Vec64xFPIEEE32 { fatalError() }
    static func shufflevector_Vec64xFPIEEE64_Vec64xInt32(
        _: Builtin.Vec64xFPIEEE64, _: Builtin.Vec64xFPIEEE64, _: Builtin.Vec64xInt32
    ) -> Builtin.Vec64xFPIEEE64 { fatalError() }
    static func shufflevector_Vec64xInt16_Vec64xInt32(
        _: Builtin.Vec64xInt16, _: Builtin.Vec64xInt16, _: Builtin.Vec64xInt32
    ) -> Builtin.Vec64xInt16 { fatalError() }
    static func shufflevector_Vec64xInt32_Vec64xInt32(
        _: Builtin.Vec64xInt32, _: Builtin.Vec64xInt32, _: Builtin.Vec64xInt32
    ) -> Builtin.Vec64xInt32 { fatalError() }
    static func shufflevector_Vec64xInt64_Vec64xInt32(
        _: Builtin.Vec64xInt64, _: Builtin.Vec64xInt64, _: Builtin.Vec64xInt32
    ) -> Builtin.Vec64xInt64 { fatalError() }
    static func shufflevector_Vec64xInt8_Vec64xInt32(
        _: Builtin.Vec64xInt8, _: Builtin.Vec64xInt8, _: Builtin.Vec64xInt32
    ) -> Builtin.Vec64xInt8 { fatalError() }
    static func shufflevector_Vec8xFPIEEE32_Vec8xInt32(
        _: Builtin.Vec8xFPIEEE32, _: Builtin.Vec8xFPIEEE32, _: Builtin.Vec8xInt32
    ) -> Builtin.Vec8xFPIEEE32 { fatalError() }
    static func shufflevector_Vec8xFPIEEE64_Vec8xInt32(
        _: Builtin.Vec8xFPIEEE64, _: Builtin.Vec8xFPIEEE64, _: Builtin.Vec8xInt32
    ) -> Builtin.Vec8xFPIEEE64 { fatalError() }
    static func shufflevector_Vec8xInt16_Vec8xInt32(
        _: Builtin.Vec8xInt16, _: Builtin.Vec8xInt16, _: Builtin.Vec8xInt32
    ) -> Builtin.Vec8xInt16 { fatalError() }
    static func shufflevector_Vec8xInt32_Vec8xInt32(
        _: Builtin.Vec8xInt32, _: Builtin.Vec8xInt32, _: Builtin.Vec8xInt32
    ) -> Builtin.Vec8xInt32 { fatalError() }
    static func shufflevector_Vec8xInt64_Vec8xInt32(
        _: Builtin.Vec8xInt64, _: Builtin.Vec8xInt64, _: Builtin.Vec8xInt32
    ) -> Builtin.Vec8xInt64 { fatalError() }
    static func shufflevector_Vec8xInt8_Vec8xInt32(
        _: Builtin.Vec8xInt8, _: Builtin.Vec8xInt8, _: Builtin.Vec8xInt32
    ) -> Builtin.Vec8xInt8 { fatalError() }
    static func sitofp_Int64_FPIEEE32(_: Builtin.Int64) -> Builtin.FPIEEE32 { fatalError() }
    static func sitofp_Int64_FPIEEE64(_: Builtin.Int64) -> Builtin.FPIEEE64 { fatalError() }
    static func sitofp_Int64_FPIEEE80(_: Builtin.Int64) -> Builtin.FPIEEE80 { fatalError() }
    static func sizeof<T>(_: T.Type) -> Builtin.Word where T: ~Copyable, T: ~Escapable {
        fatalError()
    }
    static func smul_with_overflow_Int16(_: Builtin.Int16, _: Builtin.Int16, _: Builtin.Int1) -> (
        Builtin.Int16, Builtin.Int1
    ) { fatalError() }
    static func smul_with_overflow_Int32(_: Builtin.Int32, _: Builtin.Int32, _: Builtin.Int1) -> (
        Builtin.Int32, Builtin.Int1
    ) { fatalError() }
    static func smul_with_overflow_Int64(_: Builtin.Int64, _: Builtin.Int64, _: Builtin.Int1) -> (
        Builtin.Int64, Builtin.Int1
    ) { fatalError() }
    static func smul_with_overflow_Int8(_: Builtin.Int8, _: Builtin.Int8, _: Builtin.Int1) -> (
        Builtin.Int8, Builtin.Int1
    ) { fatalError() }
    static func srem_Int128(_: Builtin.Int128, _: Builtin.Int128) -> Builtin.Int128 { fatalError() }
    static func srem_Int16(_: Builtin.Int16, _: Builtin.Int16) -> Builtin.Int16 { fatalError() }
    static func srem_Int32(_: Builtin.Int32, _: Builtin.Int32) -> Builtin.Int32 { fatalError() }
    static func srem_Int64(_: Builtin.Int64, _: Builtin.Int64) -> Builtin.Int64 { fatalError() }
    static func srem_Int8(_: Builtin.Int8, _: Builtin.Int8) -> Builtin.Int8 { fatalError() }
    static func ssub_with_overflow_Int128(_: Builtin.Int128, _: Builtin.Int128, _: Builtin.Int1)
        -> (Builtin.Int128, Builtin.Int1)
    { fatalError() }
    static func ssub_with_overflow_Int16(_: Builtin.Int16, _: Builtin.Int16, _: Builtin.Int1) -> (
        Builtin.Int16, Builtin.Int1
    ) { fatalError() }
    static func ssub_with_overflow_Int32(_: Builtin.Int32, _: Builtin.Int32, _: Builtin.Int1) -> (
        Builtin.Int32, Builtin.Int1
    ) { fatalError() }
    static func ssub_with_overflow_Int64(_: Builtin.Int64, _: Builtin.Int64, _: Builtin.Int1) -> (
        Builtin.Int64, Builtin.Int1
    ) { fatalError() }
    static func ssub_with_overflow_Int8(_: Builtin.Int8, _: Builtin.Int8, _: Builtin.Int1) -> (
        Builtin.Int8, Builtin.Int1
    ) { fatalError() }
    static func stackAlloc(_: Builtin.Word, _: Builtin.Word, _: Builtin.Word) -> Builtin.RawPointer
    { fatalError() }
    static func stackDealloc(_: Builtin.RawPointer) { fatalError() }
    static func staticReport(_: Builtin.Int1, _: Builtin.Int1, _: Builtin.RawPointer) {
        fatalError()
    }
    static func storeRaw<T>(_: __owned T, _: Builtin.RawPointer) where T: ~Copyable, T: ~Escapable {
        fatalError()
    }
    static func strideof<T>(_: T.Type) -> Builtin.Word where T: ~Copyable, T: ~Escapable {
        fatalError()
    }
    static func stringObjectOr_Int64(_: Builtin.Int64, _: Builtin.Int64) -> Builtin.Int64 {
        fatalError()
    }
    static func sub_Vec16xInt16(_: Builtin.Vec16xInt16, _: Builtin.Vec16xInt16)
        -> Builtin.Vec16xInt16
    { fatalError() }
    static func sub_Vec16xInt32(_: Builtin.Vec16xInt32, _: Builtin.Vec16xInt32)
        -> Builtin.Vec16xInt32
    { fatalError() }
    static func sub_Vec16xInt64(_: Builtin.Vec16xInt64, _: Builtin.Vec16xInt64)
        -> Builtin.Vec16xInt64
    { fatalError() }
    static func sub_Vec16xInt8(_: Builtin.Vec16xInt8, _: Builtin.Vec16xInt8) -> Builtin.Vec16xInt8 {
        fatalError()
    }
    static func sub_Vec2xInt16(_: Builtin.Vec2xInt16, _: Builtin.Vec2xInt16) -> Builtin.Vec2xInt16 {
        fatalError()
    }
    static func sub_Vec2xInt32(_: Builtin.Vec2xInt32, _: Builtin.Vec2xInt32) -> Builtin.Vec2xInt32 {
        fatalError()
    }
    static func sub_Vec2xInt64(_: Builtin.Vec2xInt64, _: Builtin.Vec2xInt64) -> Builtin.Vec2xInt64 {
        fatalError()
    }
    static func sub_Vec2xInt8(_: Builtin.Vec2xInt8, _: Builtin.Vec2xInt8) -> Builtin.Vec2xInt8 {
        fatalError()
    }
    static func sub_Vec32xInt16(_: Builtin.Vec32xInt16, _: Builtin.Vec32xInt16)
        -> Builtin.Vec32xInt16
    { fatalError() }
    static func sub_Vec32xInt32(_: Builtin.Vec32xInt32, _: Builtin.Vec32xInt32)
        -> Builtin.Vec32xInt32
    { fatalError() }
    static func sub_Vec32xInt64(_: Builtin.Vec32xInt64, _: Builtin.Vec32xInt64)
        -> Builtin.Vec32xInt64
    { fatalError() }
    static func sub_Vec32xInt8(_: Builtin.Vec32xInt8, _: Builtin.Vec32xInt8) -> Builtin.Vec32xInt8 {
        fatalError()
    }
    static func sub_Vec4xInt16(_: Builtin.Vec4xInt16, _: Builtin.Vec4xInt16) -> Builtin.Vec4xInt16 {
        fatalError()
    }
    static func sub_Vec4xInt32(_: Builtin.Vec4xInt32, _: Builtin.Vec4xInt32) -> Builtin.Vec4xInt32 {
        fatalError()
    }
    static func sub_Vec4xInt64(_: Builtin.Vec4xInt64, _: Builtin.Vec4xInt64) -> Builtin.Vec4xInt64 {
        fatalError()
    }
    static func sub_Vec4xInt8(_: Builtin.Vec4xInt8, _: Builtin.Vec4xInt8) -> Builtin.Vec4xInt8 {
        fatalError()
    }
    static func sub_Vec64xInt16(_: Builtin.Vec64xInt16, _: Builtin.Vec64xInt16)
        -> Builtin.Vec64xInt16
    { fatalError() }
    static func sub_Vec64xInt32(_: Builtin.Vec64xInt32, _: Builtin.Vec64xInt32)
        -> Builtin.Vec64xInt32
    { fatalError() }
    static func sub_Vec64xInt64(_: Builtin.Vec64xInt64, _: Builtin.Vec64xInt64)
        -> Builtin.Vec64xInt64
    { fatalError() }
    static func sub_Vec64xInt8(_: Builtin.Vec64xInt8, _: Builtin.Vec64xInt8) -> Builtin.Vec64xInt8 {
        fatalError()
    }
    static func sub_Vec8xInt16(_: Builtin.Vec8xInt16, _: Builtin.Vec8xInt16) -> Builtin.Vec8xInt16 {
        fatalError()
    }
    static func sub_Vec8xInt32(_: Builtin.Vec8xInt32, _: Builtin.Vec8xInt32) -> Builtin.Vec8xInt32 {
        fatalError()
    }
    static func sub_Vec8xInt64(_: Builtin.Vec8xInt64, _: Builtin.Vec8xInt64) -> Builtin.Vec8xInt64 {
        fatalError()
    }
    static func sub_Vec8xInt8(_: Builtin.Vec8xInt8, _: Builtin.Vec8xInt8) -> Builtin.Vec8xInt8 {
        fatalError()
    }
    static func sub_Word(_: Builtin.Word, _: Builtin.Word) -> Builtin.Word { fatalError() }
    static func take<T>(_: Builtin.RawPointer) -> T where T: ~Copyable, T: ~Escapable {
        fatalError()
    }
    static func takeArrayBackToFront<T>(
        _: T.Type, _: Builtin.RawPointer, _: Builtin.RawPointer, _: Builtin.Word
    ) where T: ~Copyable, T: ~Escapable { fatalError() }
    static func takeArrayFrontToBack<T>(
        _: T.Type, _: Builtin.RawPointer, _: Builtin.RawPointer, _: Builtin.Word
    ) where T: ~Copyable, T: ~Escapable { fatalError() }
    static func targetOSVersionAtLeast(_: Builtin.Int32, _: Builtin.Int32, _: Builtin.Int32)
        -> Builtin.Int32
    { fatalError() }
    static func truncOrBitCast_Int128_Int64(_: Builtin.Int128) -> Builtin.Int64 { fatalError() }
    static func truncOrBitCast_Int16_Int8(_: Builtin.Int16) -> Builtin.Int8 { fatalError() }
    static func truncOrBitCast_Int32_Int16(_: Builtin.Int32) -> Builtin.Int16 { fatalError() }
    static func truncOrBitCast_Int64_Int16(_: Builtin.Int64) -> Builtin.Int16 { fatalError() }
    static func truncOrBitCast_Int64_Int32(_: Builtin.Int64) -> Builtin.Int32 { fatalError() }
    static func truncOrBitCast_Int64_Int64(_: Builtin.Int64) -> Builtin.Int64 { fatalError() }
    static func truncOrBitCast_Int64_Int8(_: Builtin.Int64) -> Builtin.Int8 { fatalError() }
    static func truncOrBitCast_Int64_Word(_: Builtin.Int64) -> Builtin.Word { fatalError() }
    static func trunc_Int128_Int64(_: Builtin.Int128) -> Builtin.Int64 { fatalError() }
    static func trunc_Int8_Int1(_: Builtin.Int8) -> Builtin.Int1 { fatalError() }
    static func uadd_with_overflow_Int128(_: Builtin.Int128, _: Builtin.Int128, _: Builtin.Int1)
        -> (Builtin.Int128, Builtin.Int1)
    { fatalError() }
    static func uadd_with_overflow_Int16(_: Builtin.Int16, _: Builtin.Int16, _: Builtin.Int1) -> (
        Builtin.Int16, Builtin.Int1
    ) { fatalError() }
    static func uadd_with_overflow_Int32(_: Builtin.Int32, _: Builtin.Int32, _: Builtin.Int1) -> (
        Builtin.Int32, Builtin.Int1
    ) { fatalError() }
    static func uadd_with_overflow_Int64(_: Builtin.Int64, _: Builtin.Int64, _: Builtin.Int1) -> (
        Builtin.Int64, Builtin.Int1
    ) { fatalError() }
    static func uadd_with_overflow_Int8(_: Builtin.Int8, _: Builtin.Int8, _: Builtin.Int1) -> (
        Builtin.Int8, Builtin.Int1
    ) { fatalError() }
    static func udiv_Int128(_: Builtin.Int128, _: Builtin.Int128) -> Builtin.Int128 { fatalError() }
    static func udiv_Int16(_: Builtin.Int16, _: Builtin.Int16) -> Builtin.Int16 { fatalError() }
    static func udiv_Int32(_: Builtin.Int32, _: Builtin.Int32) -> Builtin.Int32 { fatalError() }
    static func udiv_Int64(_: Builtin.Int64, _: Builtin.Int64) -> Builtin.Int64 { fatalError() }
    static func udiv_Int8(_: Builtin.Int8, _: Builtin.Int8) -> Builtin.Int8 { fatalError() }
    static func uitofp_Int64_FPIEEE32(_: Builtin.Int64) -> Builtin.FPIEEE32 { fatalError() }
    static func uitofp_Int64_FPIEEE64(_: Builtin.Int64) -> Builtin.FPIEEE64 { fatalError() }
    static func uitofp_Int64_FPIEEE80(_: Builtin.Int64) -> Builtin.FPIEEE80 { fatalError() }
    static func umul_with_overflow_Int128(_: Builtin.Int128, _: Builtin.Int128, _: Builtin.Int1)
        -> (Builtin.Int128, Builtin.Int1)
    { fatalError() }
    static func umul_with_overflow_Int16(_: Builtin.Int16, _: Builtin.Int16, _: Builtin.Int1) -> (
        Builtin.Int16, Builtin.Int1
    ) { fatalError() }
    static func umul_with_overflow_Int32(_: Builtin.Int32, _: Builtin.Int32, _: Builtin.Int1) -> (
        Builtin.Int32, Builtin.Int1
    ) { fatalError() }
    static func umul_with_overflow_Int64(_: Builtin.Int64, _: Builtin.Int64, _: Builtin.Int1) -> (
        Builtin.Int64, Builtin.Int1
    ) { fatalError() }
    static func umul_with_overflow_Int8(_: Builtin.Int8, _: Builtin.Int8, _: Builtin.Int1) -> (
        Builtin.Int8, Builtin.Int1
    ) { fatalError() }
    static func unprotectedAddressOf<T>(_: inout T) -> Builtin.RawPointer
    where T: ~Copyable, T: ~Escapable { fatalError() }
    static func unprotectedAddressOfBorrow<T>(_: T) -> Builtin.RawPointer
    where T: ~Copyable, T: ~Escapable { fatalError() }
    static func unprotectedStackAlloc(_: Builtin.Word, _: Builtin.Word, _: Builtin.Word)
        -> Builtin.RawPointer
    { fatalError() }
    static func unreachable() -> Never { fatalError() }
    static func unsafeCastToNativeObject<T>(_: __owned T) -> Builtin.NativeObject
    where T: ~Copyable, T: ~Escapable { fatalError() }
    static func urem_Int128(_: Builtin.Int128, _: Builtin.Int128) -> Builtin.Int128 { fatalError() }
    static func urem_Int16(_: Builtin.Int16, _: Builtin.Int16) -> Builtin.Int16 { fatalError() }
    static func urem_Int32(_: Builtin.Int32, _: Builtin.Int32) -> Builtin.Int32 { fatalError() }
    static func urem_Int64(_: Builtin.Int64, _: Builtin.Int64) -> Builtin.Int64 { fatalError() }
    static func urem_Int8(_: Builtin.Int8, _: Builtin.Int8) -> Builtin.Int8 { fatalError() }
    static func usub_with_overflow_Int128(_: Builtin.Int128, _: Builtin.Int128, _: Builtin.Int1)
        -> (Builtin.Int128, Builtin.Int1)
    { fatalError() }
    static func usub_with_overflow_Int16(_: Builtin.Int16, _: Builtin.Int16, _: Builtin.Int1) -> (
        Builtin.Int16, Builtin.Int1
    ) { fatalError() }
    static func usub_with_overflow_Int32(_: Builtin.Int32, _: Builtin.Int32, _: Builtin.Int1) -> (
        Builtin.Int32, Builtin.Int1
    ) { fatalError() }
    static func usub_with_overflow_Int64(_: Builtin.Int64, _: Builtin.Int64, _: Builtin.Int1) -> (
        Builtin.Int64, Builtin.Int1
    ) { fatalError() }
    static func usub_with_overflow_Int8(_: Builtin.Int8, _: Builtin.Int8, _: Builtin.Int1) -> (
        Builtin.Int8, Builtin.Int1
    ) { fatalError() }
    static func valueToBridgeObject<T>(_: T) -> Builtin.BridgeObject { fatalError() }
    static func wordAtIndex_IntLiteral(_: Builtin.IntLiteral, _: Builtin.Word) -> Builtin.Word {
        fatalError()
    }
    static func xor_Int1(_: Builtin.Int1, _: Builtin.Int1) -> Builtin.Int1 { fatalError() }
    static func xor_Int128(_: Builtin.Int128, _: Builtin.Int128) -> Builtin.Int128 { fatalError() }
    static func xor_Int16(_: Builtin.Int16, _: Builtin.Int16) -> Builtin.Int16 { fatalError() }
    static func xor_Int32(_: Builtin.Int32, _: Builtin.Int32) -> Builtin.Int32 { fatalError() }
    static func xor_Int64(_: Builtin.Int64, _: Builtin.Int64) -> Builtin.Int64 { fatalError() }
    static func xor_Int8(_: Builtin.Int8, _: Builtin.Int8) -> Builtin.Int8 { fatalError() }
    static func xor_Vec16xInt16(_: Builtin.Vec16xInt16, _: Builtin.Vec16xInt16)
        -> Builtin.Vec16xInt16
    { fatalError() }
    static func xor_Vec16xInt32(_: Builtin.Vec16xInt32, _: Builtin.Vec16xInt32)
        -> Builtin.Vec16xInt32
    { fatalError() }
    static func xor_Vec16xInt64(_: Builtin.Vec16xInt64, _: Builtin.Vec16xInt64)
        -> Builtin.Vec16xInt64
    { fatalError() }
    static func xor_Vec16xInt8(_: Builtin.Vec16xInt8, _: Builtin.Vec16xInt8) -> Builtin.Vec16xInt8 {
        fatalError()
    }
    static func xor_Vec2xInt16(_: Builtin.Vec2xInt16, _: Builtin.Vec2xInt16) -> Builtin.Vec2xInt16 {
        fatalError()
    }
    static func xor_Vec2xInt32(_: Builtin.Vec2xInt32, _: Builtin.Vec2xInt32) -> Builtin.Vec2xInt32 {
        fatalError()
    }
    static func xor_Vec2xInt64(_: Builtin.Vec2xInt64, _: Builtin.Vec2xInt64) -> Builtin.Vec2xInt64 {
        fatalError()
    }
    static func xor_Vec2xInt8(_: Builtin.Vec2xInt8, _: Builtin.Vec2xInt8) -> Builtin.Vec2xInt8 {
        fatalError()
    }
    static func xor_Vec32xInt16(_: Builtin.Vec32xInt16, _: Builtin.Vec32xInt16)
        -> Builtin.Vec32xInt16
    { fatalError() }
    static func xor_Vec32xInt32(_: Builtin.Vec32xInt32, _: Builtin.Vec32xInt32)
        -> Builtin.Vec32xInt32
    { fatalError() }
    static func xor_Vec32xInt64(_: Builtin.Vec32xInt64, _: Builtin.Vec32xInt64)
        -> Builtin.Vec32xInt64
    { fatalError() }
    static func xor_Vec32xInt8(_: Builtin.Vec32xInt8, _: Builtin.Vec32xInt8) -> Builtin.Vec32xInt8 {
        fatalError()
    }
    static func xor_Vec4xInt16(_: Builtin.Vec4xInt16, _: Builtin.Vec4xInt16) -> Builtin.Vec4xInt16 {
        fatalError()
    }
    static func xor_Vec4xInt32(_: Builtin.Vec4xInt32, _: Builtin.Vec4xInt32) -> Builtin.Vec4xInt32 {
        fatalError()
    }
    static func xor_Vec4xInt64(_: Builtin.Vec4xInt64, _: Builtin.Vec4xInt64) -> Builtin.Vec4xInt64 {
        fatalError()
    }
    static func xor_Vec4xInt8(_: Builtin.Vec4xInt8, _: Builtin.Vec4xInt8) -> Builtin.Vec4xInt8 {
        fatalError()
    }
    static func xor_Vec64xInt16(_: Builtin.Vec64xInt16, _: Builtin.Vec64xInt16)
        -> Builtin.Vec64xInt16
    { fatalError() }
    static func xor_Vec64xInt32(_: Builtin.Vec64xInt32, _: Builtin.Vec64xInt32)
        -> Builtin.Vec64xInt32
    { fatalError() }
    static func xor_Vec64xInt64(_: Builtin.Vec64xInt64, _: Builtin.Vec64xInt64)
        -> Builtin.Vec64xInt64
    { fatalError() }
    static func xor_Vec64xInt8(_: Builtin.Vec64xInt8, _: Builtin.Vec64xInt8) -> Builtin.Vec64xInt8 {
        fatalError()
    }
    static func xor_Vec8xInt16(_: Builtin.Vec8xInt16, _: Builtin.Vec8xInt16) -> Builtin.Vec8xInt16 {
        fatalError()
    }
    static func xor_Vec8xInt32(_: Builtin.Vec8xInt32, _: Builtin.Vec8xInt32) -> Builtin.Vec8xInt32 {
        fatalError()
    }
    static func xor_Vec8xInt64(_: Builtin.Vec8xInt64, _: Builtin.Vec8xInt64) -> Builtin.Vec8xInt64 {
        fatalError()
    }
    static func xor_Vec8xInt8(_: Builtin.Vec8xInt8, _: Builtin.Vec8xInt8) -> Builtin.Vec8xInt8 {
        fatalError()
    }
    static func zeroInitializer<T>() -> T where T: ~Copyable { fatalError() }
    static func zextOrBitCast_Int16_Int64(_: Builtin.Int16) -> Builtin.Int64 { fatalError() }
    static func zextOrBitCast_Int32_Int64(_: Builtin.Int32) -> Builtin.Int64 { fatalError() }
    static func zextOrBitCast_Int64_Int64(_: Builtin.Int64) -> Builtin.Int64 { fatalError() }
    static func zextOrBitCast_Int8_Int128(_: Builtin.Int8) -> Builtin.Int128 { fatalError() }
    static func zextOrBitCast_Int8_Int16(_: Builtin.Int8) -> Builtin.Int16 { fatalError() }
    static func zextOrBitCast_Int8_Int32(_: Builtin.Int8) -> Builtin.Int32 { fatalError() }
    static func zextOrBitCast_Int8_Int64(_: Builtin.Int8) -> Builtin.Int64 { fatalError() }
    static func zextOrBitCast_Word_Int64(_: Builtin.Word) -> Builtin.Int64 { fatalError() }
    static func zext_Int16_Int32(_: Builtin.Int16) -> Builtin.Int32 { fatalError() }
    static func zext_Int1_Int16(_: Builtin.Int1) -> Builtin.Int16 { fatalError() }
    static func zext_Int1_Int32(_: Builtin.Int1) -> Builtin.Int32 { fatalError() }
    static func zext_Int1_Int64(_: Builtin.Int1) -> Builtin.Int64 { fatalError() }
    static func zext_Int1_Int8(_: Builtin.Int1) -> Builtin.Int8 { fatalError() }
    static func zext_Int32_Int64(_: Builtin.Int32) -> Builtin.Int64 { fatalError() }
    static func zext_Int64_Int128(_: Builtin.Int64) -> Builtin.Int128 { fatalError() }
    static func zext_Int8_Int16(_: Builtin.Int8) -> Builtin.Int16 { fatalError() }
    static func globalStringTablePointer(_ constant: String) -> Builtin.RawPointer { fatalError() }
}

// Language-level types used by the extractor but not declared by the Swift module.
struct Function<Args, Return> {
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
