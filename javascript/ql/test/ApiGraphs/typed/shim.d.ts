declare module "mongodb" {
  interface Collection {
    find(query: any): any;
  }
}
declare module "mongoose" {
  interface Model {
    find(query: any): any;
  }
  interface Query {
    find(query: any): any;
  }
}
