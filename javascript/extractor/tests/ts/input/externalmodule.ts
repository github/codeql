declare module "X" {
  module M {
    export interface I {}
  }
  interface M {
    method(): M.I;
  }
  export = M;
}
