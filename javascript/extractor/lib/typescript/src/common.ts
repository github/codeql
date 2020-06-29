import * as ts from "./typescript";
import { TypeTable } from "./type_table";
import * as pathlib from "path";
import { VirtualSourceRoot } from "./virtual_source_root";

/**
 * Extracts the package name from the prefix of an import string.
 */
const packageNameRex = /^(?:@[\w.-]+[/\\]+)?\w[\w.-]*(?=[/\\]|$)/;
const extensions = ['.ts', '.tsx', '.d.ts', '.js', '.jsx'];

function getPackageName(importString: string) {
  let packageNameMatch = packageNameRex.exec(importString);
  if (packageNameMatch == null) return null;
  let packageName = packageNameMatch[0];
  if (packageName.charAt(0) === '@') {
    packageName = packageName.replace(/[/\\]+/g, '/'); // Normalize slash after the scope.
  }
  return packageName;
}

export class Project {
  public program: ts.Program = null;
  private host: ts.CompilerHost;
  private resolutionCache: ts.ModuleResolutionCache;

  constructor(
        public tsConfig: string,
        public config: ts.ParsedCommandLine,
        public typeTable: TypeTable,
        public packageEntryPoints: Map<string, string>,
        public virtualSourceRoot: VirtualSourceRoot) {

    this.resolveModuleNames = this.resolveModuleNames.bind(this);

    this.resolutionCache = ts.createModuleResolutionCache(pathlib.dirname(tsConfig), ts.sys.realpath, config.options);
    let host = ts.createCompilerHost(config.options, true);
    host.resolveModuleNames = this.resolveModuleNames;
    host.trace = undefined; // Disable tracing which would otherwise go to standard out
    this.host = host;
  }

  public unload(): void {
    this.typeTable.releaseProgram();
    this.program = null;
  }

  public load(): void {
    const { config, host } = this;
    this.program = ts.createProgram(config.fileNames, config.options, host);
    this.typeTable.setProgram(this.program, this.virtualSourceRoot);
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

  /**
   * Override for module resolution in the TypeScript compiler host.
   */
  private resolveModuleNames(
        moduleNames: string[],
        containingFile: string,
        reusedNames: string[],
        redirectedReference: ts.ResolvedProjectReference,
        options: ts.CompilerOptions) {

    let oppositePath =
      this.virtualSourceRoot.toVirtualPath(containingFile) ||
      this.virtualSourceRoot.fromVirtualPath(containingFile);

    const { host, resolutionCache } = this;
    return moduleNames.map((moduleName) => {
      let redirected = this.redirectModuleName(moduleName, containingFile, options);
      if (redirected != null) return redirected;
      if (oppositePath != null) {
        // If the containing file is in the virtual source root, try resolving from the real source root, and vice versa.
        redirected = ts.resolveModuleName(moduleName, oppositePath, options,  host, resolutionCache).resolvedModule;
        if (redirected != null) return redirected;
      }
      return ts.resolveModuleName(moduleName, containingFile, options,  host, resolutionCache).resolvedModule;
    });
  }

  /**
   * Returns the path that the given import string should be redirected to, or null if it should
   * fall back to standard module resolution.
   */
  private redirectModuleName(moduleName: string, containingFile: string, options: ts.CompilerOptions): ts.ResolvedModule {
    // Get a package name from the leading part of the module name, e.g. '@scope/foo' from '@scope/foo/bar'.
    let packageName = getPackageName(moduleName);
    if (packageName == null) return null;

    // Get the overridden location of this package, if one exists.
    let packageEntryPoint = this.packageEntryPoints.get(packageName);
    if (packageEntryPoint == null) return null;

    // If the requested module name is exactly the overridden package name,
    // return the entry point file (it is not necessarily called `index.ts`).
    if (moduleName === packageName) {
      return { resolvedFileName: packageEntryPoint, isExternalLibraryImport: true };
    }

    // Get the suffix after the package name, e.g. the '/bar' in '@scope/foo/bar'.
    let suffix = moduleName.substring(packageName.length);

    // Resolve the suffix relative to the package directory.
    let packageDir = pathlib.dirname(packageEntryPoint);
    let joinedPath = pathlib.join(packageDir, suffix);

    // Add implicit '/index'
    if (ts.sys.directoryExists(joinedPath)) {
      joinedPath = pathlib.join(joinedPath, 'index');
    }

    // Try each recognized extension. We must not return a file whose extension is not
    // recognized by TypeScript.
    for (let ext of extensions) {
      let candidate = joinedPath.endsWith(ext) ? joinedPath : (joinedPath + ext);
      if (ts.sys.fileExists(candidate)) {
        return { resolvedFileName: candidate, isExternalLibraryImport: true };
      }
    }

    return null;
  }
}
