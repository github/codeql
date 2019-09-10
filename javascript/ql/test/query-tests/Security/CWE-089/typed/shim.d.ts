declare module "mongodb" {
  interface Collection {
    find(query: any): any;
  }
}
