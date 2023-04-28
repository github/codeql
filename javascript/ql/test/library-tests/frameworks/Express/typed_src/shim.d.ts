declare namespace ServeStaticCore {
  interface Request {
    body: any;
  }
  interface Response {
  }
}

declare module 'express' {
  interface Request extends ServeStaticCore.Request {}
  interface Response extends ServeStaticCore.Response {}
}

declare module 'express-serve-static-core' {
  export = ServeStaticCore;
}
