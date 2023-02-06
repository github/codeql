class S {}

protocol P {}

func foo<Param,
         ParamWithSuperclass: S,
         ParamWithProtocols: P & Equatable,
         ParamWithSuperclassAndProtocols: S & Equatable & P>(
  _: Param, _: ParamWithSuperclass, _: ParamWithProtocols, _: ParamWithSuperclassAndProtocols) {}
