interface IBase {
  x: string;
}
interface ISub extends IBase {
  y: string;
}

interface IGenericBase<T> {
  w: T;
}
interface IStringSub extends IGenericBase<string> {}
interface IGenericSub<Q> extends IGenericBase<Q> {}

class CBase {}
class CSub extends CBase {}

class CGenericBase<T> {}
class CStringSub extends CGenericBase<string> {}
class CGenericSub<Q> extends CGenericBase<Q> {}

interface IMulti<T> extends IBase, IGenericBase<T> {}

abstract class CImplements implements IBase {
  x: string;
}
abstract class CImplementsString implements IGenericBase<string> {
  w: string;
}
abstract class CImplementsGeneric<Q> implements IGenericBase<Q> {
  w: Q;
}

abstract class CEverything<S,T> extends CGenericBase<S> implements IGenericSub<T>, IBase {
  x: string;
  w: T;
}

interface IEmpty {}
interface IEmptySub extends IEmpty {}
