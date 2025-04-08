private import javascript

signature module ResolverSig {
  class FileNode {
    FileNode getChild(string name);

    FileNode getParent();
  }

  /**
   * Holds if `path` should be resolved to a file or folder, relative to `base`.
   */
  predicate shouldResolve(FileNode base, string path);
}

/**
 * Provides a mechanism for resolving relative file paths.
 *
 * Absolute paths are not handled.
 */
module Resolver<ResolverSig S> {
  private import S

  private string getPathSegment(string path, int n) {
    shouldResolve(_, path) and
    result = path.replaceAll("\\", "/").splitAt("/", n)
  }

  private int getNumPathSegment(string path) {
    result = strictcount(int n | exists(getPathSegment(path, n)))
  }

  private FileNode resolve(FileNode base, string path, int n) {
    shouldResolve(base, path) and n = 0 and result = base
    or
    exists(FileNode cur, string segment |
      cur = resolve(base, path, n - 1) and
      segment = getPathSegment(path, n - 1)
    |
      result = cur.getChild(segment)
      or
      segment = [".", ""] and
      result = cur
      or
      segment = ".." and
      result = cur.getParent()
    )
  }

  /**
   * Gets the file or folder that `path` resolves to when resolved from `base`.
   *
   * Only has results for the `base`, `path` pairs provided by `shouldResolve`
   * in the instantiation of this module.
   */
  FileNode resolve(FileNode base, string path) {
    result = resolve(base, path, getNumPathSegment(path))
  }
}

class ContainerAsFileNode instanceof Container {
  string toString() { result = super.toString() }

  Location getLocation() { result = this.(File).getLocation() }

  ContainerAsFileNode getChild(string name) { result = this.(Folder).getChildContainer(name) }

  ContainerAsFileNode getParent() { result = super.getParentContainer() }
}

signature module VirtualFileSystemSig {
  Container getAnAdditionalChild(Container base, string path);
}

module VirtualFileSystem<VirtualFileSystemSig S> {
  private import S

  private string getPathSegment(string path, int n) {
    exists(getAnAdditionalChild(_, path)) and
    result = path.replaceAll("\\", "/").splitAt("/", n)
  }

  private int getNumPathSegment(string path) {
    result = strictcount(int n | exists(getPathSegment(path, n)))
  }

  private newtype TFileNode =
    MkContainer(Container container) or
    MkVirtualChild(Container base, string path, int n) {
      exists(getAnAdditionalChild(base, path)) and
      n in [1 .. getNumPathSegment(path) - 1] // any interior point in the path (not beginning or end)
    }

  class FileNode extends TFileNode {
    Container asContainer() { this = MkContainer(result) }

    Container getNearestContainer() {
      result = this.asContainer() or this = MkVirtualChild(result, _, _)
    }

    /** Gets the name of this virtual folder */
    private string getVirtualChildName() {
      exists(string path, int n |
        this = MkVirtualChild(_, path, n) and
        result = getPathSegment(path, n - 1)
      )
    }

    /** Gets the parent of this virtual folder */
    private FileNode getVirtualParent() {
      exists(Container base, string path, int n | this = MkVirtualChild(base, path, n) |
        n = 0 and
        result.asContainer() = base
        or
        result = MkVirtualChild(base, path, n - 1)
      )
    }

    FileNode getParent() {
      result.asContainer() = this.asContainer().getParentContainer()
      or
      result = this.getVirtualParent()
    }

    FileNode getChild(string name) {
      result.asContainer() = this.asContainer().(Folder).getChildContainer(name)
      or
      result.getVirtualChildName() = name and
      result.getParent() = this
    }

    string toString() {
      result = this.asContainer().toString()
      or
      exists(Container base, string path, int n |
        this = MkVirtualChild(base, path, n) and
        result = base + "[" + path + "]n=" + n
      )
    }

    Location getLocation() { result = this.asContainer().(File).getLocation() }
  }
}
