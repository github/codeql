package com.semmle.util.files;

import java.io.File;
import java.net.URISyntaxException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

/**
 * Resolves Windows {@code subst}ed drive letters to their underlying paths. On non-Windows
 * platforms, or when the native library failed to load, resolving will be a no-op.
 */
public class SubstResolver {
  private static final boolean available;

  static {
    boolean loaded = false;
    if (File.separatorChar == '\\') {
      String dist = System.getenv("CODEQL_DIST");
    if (dist != null && !dist.isEmpty()) {
        try {
          Path library = Paths.get(dist).resolve("tools")
                  .resolve("win64").resolve("canonicalize.dll").toAbsolutePath();
          System.load(library.toString());
          loaded = true;
        } catch (RuntimeException | UnsatisfiedLinkError ignored) {
        }
      }
    }
    available = loaded;
  }

  private SubstResolver() {}

  /**
   * Given a drive root like {@code "X:\\"} (or {@code "X:/"}), returns the path that drive is
   * {@code subst}ed to, or {@code null} if the drive root was not subst drive or if an internal
   * error occurred.
   */
  private static native String nativeResolveSubst(String driveRoot);

  /**
   * If {@code f} is an absolute path starting with a {@code subst}ed drive letter, return an
   * equivalent path with the drive letter replaced by its target. Otherwise return {@code f}
   * unchanged.
   */
  public static File resolve(File f) {
    if (!available) {
      return f;
    }
    String path = f.getPath();
    if (path.length() < 3 || path.charAt(1) != ':') {
      return f;
    }
    char sep = path.charAt(2);
    if (sep != '\\' && sep != '/') {
      return f;
    }
    if (!isDriveLetter(path.charAt(0))) {
      return f;
    }

    String resolved = nativeResolveSubst(path.substring(0, 3));
    if (resolved == null) {
      return f;
    }

    // Append the remainder of the original path. The native side strips away
    // any trailing separator.
    return new File(resolved + path.substring(2));
  }

  private static boolean isDriveLetter(char c) {
    return (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z');
  }
}
