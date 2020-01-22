import * as pathlib from "path";
import * as ts from "./typescript";

/**
 * Mapping from the source root to the virtual source root.
 */
export class VirtualSourceRoot {
  constructor(
    private sourceRoot: string,

    /** Directory whose folder structure mirrors the real source root, but with `node_modules` installed. */
    private virtualSourceRoot: string,
  ) {}

  /**
   * Maps a path under the real source root to the corresonding path in the virtual source root.
   */
  public toVirtualPath(path: string) {
    let relative = pathlib.relative(this.sourceRoot, path);
    if (relative.startsWith('..') || pathlib.isAbsolute(relative)) return null;
    return pathlib.join(this.virtualSourceRoot, relative);
  }

  /**
   * Maps a path under the real source root to the corresonding path in the virtual source root.
   */
  public toVirtualPathIfFileExists(path: string) {
    let virtualPath = this.toVirtualPath(path);
    if (virtualPath != null && ts.sys.fileExists(virtualPath)) {
        return virtualPath;
    }
    return null;
  }
}
