@classDecorator
class Class {
  @methodDecorator
  method(): number { return this.field }
  
  @fieldDecorator
  field: number;
}

@functionDecorator
function fun() {}

@classDecorator2
export class Class2 {}
