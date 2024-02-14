export class PublicClass {} // $ name=(pack1).PublicClass

class PrivateClass {}

export const ExportedConst = class ExportedConstClass {} // $ name=(pack1).ExportedConst

class ClassWithEscapingInstance {}

export function getEscapingInstance() {
    return new ClassWithEscapingInstance();
} // $ name=(pack1).getEscapingInstance

export function publicFunction() {} // $ name=(pack1).publicFunction
