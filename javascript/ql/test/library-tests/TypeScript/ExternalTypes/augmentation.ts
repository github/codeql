import { ExternalType1, Augmentation } from "esmodule";

declare module "esmodule" {
  export interface Augmentation {
    x: ExternalType1;
  }
}

let x: Augmentation;
