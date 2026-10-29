class S {}
class S2 {}

protocol P {}
protocol P2 {}

func foo<Param,
         ParamWithSuperclass: S,
         ParamWithProtocols: P & Equatable,
         ParamWithSuperclassAndProtocols: S & Equatable & P>(
  _: Param, _: ParamWithSuperclass, _: ParamWithProtocols, _: ParamWithSuperclassAndProtocols) {}

class Generic<Base> {}
extension Generic where Base : P {
  func f(_: Base) {}
}
extension Generic where Base : P2 {
  func f(_: Base) {}
}
extension Generic where Base : S {
  func f(_: Base) {}
}
extension Generic where Base : S2 {
  func f(_: Base) {}
}
