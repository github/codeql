@ClassDecorator
class C {
  dummy=123; 
  
  constructor(@CtorDecorator x) {}
  
  @MethodDecorator
  m(@ParamDecorator y) {}
  
  @FieldDecorator
  field = 3;
  
  @StaticFieldDecorator
  static staticField = 4;
}
