package com.semmle.util.files;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;

public class NativeCanonicalizer {
  private static final boolean available;

  static {
    boolean loaded = false;
    if (File.separatorChar == '\\') {
      String dist = System.getenv("CODEQL_DIST");
      if (dist != null && !dist.isEmpty()) {
        try {
          Path library = Paths.get(dist).resolve("tools").resolve("win64")
              .resolve("codeql_canonical_path.dll").toAbsolutePath();
          System.load(library.toString());
          loaded = true;
        } catch (RuntimeException | UnsatisfiedLinkError ignored) {
        }
      }
    }
    available = loaded;
  }

  private NativeCanonicalizer() {}

  // UTF-16 JNI interface — no encoding conversion
  private static native String nativeCanonicalizePath(String path);

  public static File resolve(File path) {
    if (!available) return path;
    String result = nativeCanonicalizePath(path.getAbsolutePath());
    return result != null ? new File(result) : path;
  }

  public static boolean isAvailable() {
    return available;
  }
}
