export class PublicClass {} // $ class=(pack1).PublicClass instance=(pack1).PublicClass.prototype

class PrivateClass {}

export const ExportedConst = class ExportedConstClass {} // $ class=(pack1).ExportedConst instance=(pack1).ExportedConst.prototype

class ClassWithEscapingInstance {} // $ instance=(pack1).ClassWithEscapingInstance.prototype

export function getEscapingInstance() {
    return new ClassWithEscapingInstance();
} // $ method=(pack1).getEscapingInstance

export function publicFunction() {} // $ method=(pack1).publicFunction
