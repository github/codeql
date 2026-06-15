import * as ts from "./typescript";

export class Project {
  public program: ts.Program = null;
  private host: ts.CompilerHost;

  constructor(
    public tsConfig: string,
    public config: ts.ParsedCommandLine,
    public packageEntryPoints: Map<string, string>) {

    let host = ts.createCompilerHost(config.options, true);
    host.trace = undefined; // Disable tracing which would otherwise go to standard out
    this.host = host;
  }

  public unload(): void {
    this.program = null;
  }

  public load(): void {
    const { config, host } = this;
    this.program = ts.createProgram(config.fileNames, config.options, host);
  }

  /**
   * Discards the old compiler instance and starts a new one.
   */
  public reload(): void {
    // Ensure all references to the old compiler instance
    // are cleared before calling `createProgram`.
    this.unload();
    this.load();
  }
}
