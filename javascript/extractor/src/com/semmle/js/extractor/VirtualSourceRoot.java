package com.semmle.js.extractor;

import java.nio.file.Path;

public class VirtualSourceRoot {
  private Path sourceRoot;
  private Path virtualSourceRoot;
  private Object lock = new Object();

  public static final VirtualSourceRoot none = new VirtualSourceRoot(null, null);

  public VirtualSourceRoot(Path sourceRoot, Path virtualSourceRoot) {
    this.sourceRoot = sourceRoot;
    this.virtualSourceRoot = virtualSourceRoot;
  }

  /**
   * Returns the source root mirrored by {@link #getVirtualSourceRoot()} or <code>null</code> if no
   * virtual source root exists.
   *
   * <p>When invoked from the AutoBuilder, this corresponds to the source root. When invoked from
   * ODASA, there is no notion of source root, so this is always <code>null</code> in that context.
   */
  public Path getSourceRoot() {
    return sourceRoot;
  }

  /**
   * Returns the virtual source root or <code>null</code> if no virtual source root exists.
   *
   * <p>The virtual source root is a directory hierarchy that mirrors the real source root, where
   * dependencies are installed.
   */
  public Path getVirtualSourceRoot() {
    return virtualSourceRoot;
  }

  private static Path translate(Path oldRoot, Path newRoot, Path file) {
    if (oldRoot == null || newRoot == null) return null;
    Path relative = oldRoot.relativize(file);
    if (relative.startsWith("..") || relative.isAbsolute()) return null;
    return newRoot.resolve(relative);
  }

  public Path toVirtualFile(Path file) {
    if (file.startsWith(virtualSourceRoot)) {
      // 'qltest' creates a virtual source root inside the real source root.
      // Make sure such files don't appear to be inside the real source root.
      return null;
    }
    return translate(sourceRoot, virtualSourceRoot, file);
  }

  public Path fromVirtualFile(Path file) {
    return translate(virtualSourceRoot, sourceRoot, file);
  }

  public Path getVirtualFileForSnippet(FileSnippet snippet, String extension) {
    String basename =
        snippet.getOriginalFile().getFileName()
            + ".snippet."
            + snippet.getLine()
            + "."
            + snippet.getColumn()
            + extension;
    return toVirtualFile(snippet.getOriginalFile().resolveSibling(basename));
  }

  @Override
  public String toString() {
    return "[sourceRoot=" + sourceRoot + ", virtualSourceRoot=" + virtualSourceRoot + "]";
  }

  /**
   * Gets the lock to use when writing to the virtual source root in a multi-threaded context.
   */
  public Object getLock() {
    return lock;
  }
}
