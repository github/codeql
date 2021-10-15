declare namespace __Framework1 {
  class Component {}
}

declare module "framework1" {
  export = __Framework1
}

declare namespace Util {
  import Framework1 = __Framework1;
  
  class DefaultComponent extends Framework1.Component {}
}
