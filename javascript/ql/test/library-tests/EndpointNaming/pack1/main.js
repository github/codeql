export class PublicClass {} // $ name=(pack1).PublicClass

class PrivateClass {}

export const ExportedConst = class ExportedConstClass {} // $ name=(pack1).ExportedConst

class ClassWithEscapingInstance {
    m() {} // $ name=(pack1).ClassWithEscapingInstance.prototype.m
}

export function getEscapingInstance() {
    return new ClassWithEscapingInstance();
} // $ name=(pack1).getEscapingInstance

export function publicFunction() {} // $ name=(pack1).publicFunction

// Escapes into an upstream library, but is not exposed downstream
class InternalClass {
    m() {}
}
require('foo').bar(new InternalClass());
