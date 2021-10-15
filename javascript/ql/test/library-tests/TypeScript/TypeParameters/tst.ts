// At the time of writing, our tests run using TypeScript-2.2.1 which does not yet
// support type parameter defaults, so all defaults have been outcommented in this file.

function decorator() {}

interface A {}

class ClassDecl<T> {}

let anomymousClassExpr = class<T> {}
let w = class NamedClassExpr<T> {}

class HasBound<T extends Array> {}
class HasDefault<T extends Array> {}
//class HasBoundAndDefault<T extends Array = number[]> {}

class HasMany<S, T extends S, U extends S> {}
//class HasManyWithDefault<S, T extends S, U extends S = T> {}

@decorator
class HasEverything<S, T> extends ClassDecl<S> implements A {}

interface InterfaceDecl<T> {}
interface InterfaceMany<S, T extends S, U extends S> extends A {}
//interface InterfaceManyWithDefault<S, T extends S, U extends S = T> extends A {}

function functionDecl<T>(x: T): T {}
@decorator
function functionWithEverything<S,T,U>(s: S = null, t: T = undefined, u: U = functionDecl(null)): [S, T, U] {}
let v = function namedFunctionExpr<T>(x: T): T {}
let anonymousFunction = function <T>(x: T): T {}
let arrowFunction = <T>(x: T): T => x;

function hasCallback(callback: <T>(x:T) => T) {}


interface InterfaceMembers {
  method<T>(x: T): T;
  <T>(x: T): T;
}
class ClassMembers {
  method<T>(x: T): T {}
}

var mappedType: { [K in keyof ClassDecl<K>]: K }
type Q<T> = ClassDecl<T>
