
abstract class AbstractClass {
  abstract abstractMethod(x: number): number;
  
  abstract overloadedAbstractMethod(x: string): string;
  abstract overloadedAbstractMethod(x: number): number;
  
  overloadedMethod(x: string): string;
  overloadedMethod(x: number): number;
  overloadedMethod(x: any): any { return x + x; }
  
  abstract get abstractAccessor(): number;
  abstract set abstractAccessor(value: number);
  
  abstract abstractField: number;
  concreteField: number;
  
  constructor(x: string);
  constructor(x: number);
  constructor(x: any) {}
}

class ConcreteClass {
  overloadedMethod(x: string): string;
  overloadedMethod(x: number): number;
  overloadedMethod(x: any): any { return x + x; }
  
  notOverloaded(x: string): string { return x; }
  
  constructor(x: string);
  constructor(x: number);
  constructor(x: any) {}
}

class ImplicitConstructor {}

interface Interface {
  overloadedInterfaceMethod(x: string): string;
  overloadedInterfaceMethod(x: number): number;
  
  interfaceMethod(x: boolean): boolean;
}

declare class AmbientClass {
  constructor(x: number);
  constructor(x: string);
  
  overloadedAmbientMethod(x: number): number;
  overloadedAmbientMethod(x: string): string;
  
  ambientField: number;
  abstract abstractAmbientField: number;
}
