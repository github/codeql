import * as pathlib from "path";
import * as ts from "./typescript";

/**
 * Mapping from the real source root to the virtual source root,
 * a directory whose folder structure mirrors the real source root, but with `node_modules` installed.
 */
export class VirtualSourceRoot {
  constructor(
    public sourceRoot: string | null,

    /**
     * Directory whose folder structure mirrors the real source root, but with `node_modules` installed,
     * or undefined if no virtual source root exists.
     */
    public virtualSourceRoot: string | null,
  ) {}

  private static translate(oldRoot: string, newRoot: string, path: string) {
    if (!oldRoot || !newRoot) return null;
    let relative = pathlib.relative(oldRoot, path);
    if (relative.startsWith('..') || pathlib.isAbsolute(relative)) return null;
    return pathlib.join(newRoot, relative);
  }

  /**
   * Maps a path under the real source root to the corresponding path in the virtual source root.
   *
   * Returns `null` for paths already in the virtual source root.
   */
  public toVirtualPath(path: string) {
    let { virtualSourceRoot } = this;
    if (path.startsWith(virtualSourceRoot)) {
      // 'qltest' creates a virtual source root inside the real source root.
      // Make sure such files don't appear to be inside the real source root.
      return null;
    }
    return VirtualSourceRoot.translate(this.sourceRoot, virtualSourceRoot, path);
  }

  /**
   * Maps a path under the virtual source root to the corresponding path in the real source root.
   */
  public fromVirtualPath(path: string) {
    return VirtualSourceRoot.translate(this.virtualSourceRoot, this.sourceRoot, path);
  }

  /**
   * Maps a path under the real source root to the corresponding path in the virtual source root.
   */
  public toVirtualPathIfFileExists(path: string) {
    let virtualPath = this.toVirtualPath(path);
    if (virtualPath != null && ts.sys.fileExists(virtualPath)) {
        return virtualPath;
    }
    return null;
  }

  /**
   * Maps a path under the real source root to the corresponding path in the virtual source root.
   */
  public toVirtualPathIfDirectoryExists(path: string) {
    let virtualPath = this.toVirtualPath(path);
    if (virtualPath != null && ts.sys.directoryExists(virtualPath)) {
        return virtualPath;
    }
    return null;
  }
}
