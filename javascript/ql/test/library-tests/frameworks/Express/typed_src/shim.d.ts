declare namespace ServeStaticCore {
  interface Request {
    body: any;
  }
}

declare module 'express' {
  interface Request extends ServeStaticCore.Request {}
}

declare module 'express-serve-static-core' {
  export = ServeStaticCore;
}
