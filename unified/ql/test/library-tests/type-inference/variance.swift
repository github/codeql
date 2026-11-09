// Recursive variance through function inputs, outputs, and generic constructors.

class A<Ta> {}

class B<Tb>: A<Tb> {}

func foo<T1, T2>(f: (B<T1>) -> A<T2>) -> (T1, T2) {
  fatalError()  // placeholder implementation
}

let lam = { (a: A<Int>) -> B<String> in B<String>() }  // $ target=A.init

let x = foo(f: lam)  // $ target=foo $ MISSING: type=x@Tuple2<T0>:Int type=x@Tuple2<T1>:String

func bar<T>() -> B<T> { B() }  // $ target=A.init

func baz() {
  let x: A<Int> = bar()  // $ target=bar $ MISSING: type=bar(...)@B<Tb>:Int
}

func boundLower<T>(_ value: [T]) -> T { fatalError() }
let boundLowerActual = [1]
let lower = boundLower(boundLowerActual)  // $ target=boundLower type=lower:Int

func boundUpper<T>(_ callback: (T) -> Int) -> T { fatalError() }
let boundUpperActual = { (value: Int) -> Int in value }  // $ type=value:Int
let upper = boundUpper(boundUpperActual)  // $ target=boundUpper type=upper:Int

func boundDouble<T>(_ callback: ((T) -> Int) -> Int) -> T { fatalError() }
let boundDoubleActual = { (callback: (Int) -> Int) -> Int in callback(1) }  // $ target=Function.callAsFunction
let double = boundDouble(boundDoubleActual)  // $ target=boundDouble type=double:Int

func boundInvariant<T>(_ value: A<T>) -> T { fatalError() }
let boundInvariantActual = A<Int>()  // $ target=A.init
let invariant = boundInvariant(boundInvariantActual)  // $ target=boundInvariant type=invariant:Int

func boundNested<T>(_ value: [A<T>]) -> T { fatalError() }
let boundNestedActual = [B<Int>()]  // $ target=A.init
let nested = boundNested(boundNestedActual)  // $ target=boundNested $ MISSING: type=nested:Int

// Neither reversing a covariant conversion nor converting through an invariant
// parameter can establish a bound. These calls intentionally have incompatible types.
func boundWrongDirection<T>(_ value: [B<T>]) -> T { fatalError() }
let boundWrongDirectionActual = [A<Int>()]  // $ target=A.init
let wrongDirection = boundWrongDirection(boundWrongDirectionActual)  // $ target=boundWrongDirection

func boundInvariantConversion<T>(_ value: A<A<T>>) -> T { fatalError() }
let boundInvariantConversionActual = A<B<Int>>()  // $ target=A.init
let invariantConversion = boundInvariantConversion(boundInvariantConversionActual)  // $ target=boundInvariantConversion

func boundContext<T>(_ first: T, _ values: [A<T>]) {}
boundContext(1, [B()])  // $ target=boundContext target=A.init $ MISSING: type=B(...)@B<Tb>:Int

func boundAlternatives<T>(_ first: [T], _ second: [T]) -> T { fatalError() }
let alternatives = boundAlternatives([1], ["x"])  // $ target=boundAlternatives type=alternatives:Int type=alternatives:String

// Keep lower and upper bounds distinct, without solving their inconsistency.
func boundMixed<T>(_ callback: (T) -> T) -> T { fatalError() }
let boundMixedActual = { (value: Int) -> String in "x" }
let mixed = boundMixed(boundMixedActual)  // $ target=boundMixed type=mixed:Int type=mixed:String

class Shift<C>: A<[C]> {
  override init() { super.init() }  // $ target=A.init
}
func boundShift<T>(_ value: [A<[T]>]) -> T { fatalError() }
let boundShiftActual = [Shift<Int>()]  // $ target=Shift.init
let shifted = boundShift(boundShiftActual)  // $ target=boundShift $ MISSING: type=shifted:Int

func shiftedContext<T>(_ first: T, _ values: [A<[T]>]) {}
shiftedContext(1, [Shift()])  // $ target=shiftedContext target=Shift.init $ MISSING: type=Shift(...)@Shift<C>:Int

func boundContraReverse<T>(_ callback: (A<T>) -> Int) -> T { fatalError() }
let boundContraReverseActual = { (value: B<Int>) -> Int in 1 }
let contraReverse = boundContraReverse(boundContraReverseActual)  // $ target=boundContraReverse

func boundDoubleNested<T>(_ callback: ((A<T>) -> Int) -> Int) -> T { fatalError() }
let boundDoubleNestedActual = { (callback: (B<Int>) -> Int) -> Int in 1 }
let doubleNested = boundDoubleNested(boundDoubleNestedActual)  // $ target=boundDoubleNested $ MISSING: type=doubleNested:Int

func boundInvariantFunction<T>(_ value: A<(A<T>) -> Int>) -> T { fatalError() }
let boundInvariantFunctionActual = A<(B<Int>) -> Int>()  // $ target=A.init
let invariantFunction = boundInvariantFunction(boundInvariantFunctionActual)  // $ target=boundInvariantFunction

func boundOptional<T>(_ value: A<T>?) -> T { fatalError() }
let boundOptionalActual: B<Int>? = B<Int>()  // $ target=A.init
let optional = boundOptional(boundOptionalActual)  // $ target=boundOptional $ MISSING: type=optional:Int
