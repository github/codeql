import * as ts from "./typescript";
import { TypeTable } from "./type_table";

export class Project {
  public program: ts.Program = null;

  constructor(public tsConfig: string, public config: ts.ParsedCommandLine, public typeTable: TypeTable) {}

  public unload(): void {
    this.typeTable.releaseProgram();
    this.program = null;
  }

  public load(): void {
    this.program = ts.createProgram(this.config.fileNames, this.config.options);
    this.typeTable.setProgram(this.program);
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
