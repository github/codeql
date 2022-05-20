interface A {}
interface B {}

class Implement1 implements A {}
class Implement2 implements A, B {}
var Implement3 = class implements A {}
var Implement4 = class implements A, B {}

class BaseClass {}
class SubClass1 extends BaseClass implements A {}
class SubClass2 extends BaseClass implements A, B {}
var SubClass3 = class extends BaseClass implements A {}
var SubClass4 = class extends BaseClass implements A, B {}

interface Extend1 extends A {}
interface Extend2 extends A, B {}

interface G<T> {}
class ImplementGeneric1 implements G<number> {}
var ImplementGeneric2 = class implements G<number> {}
interface ExtendGeneric extends G<number> {}

class GenericBase<T> {}
class ExtendGenericBase1 extends GenericBase<string> {}
var ExtendGenericBase2 = class extends GenericBase<string> {}

function f(x) : typeof GenericBase { return GenericBase }
class ComplexBase1 extends f("reachable")<number> {}
var ComplexBase2 = class extends f("reachable")<number> {}

"also reachable";
