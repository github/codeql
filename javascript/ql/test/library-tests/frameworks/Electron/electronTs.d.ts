declare namespace Electron {
  export class BrowserWindow { }
  export class BrowserView { }
}

declare module 'electron' {
  export = Electron;
}
