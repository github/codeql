/*
 * Copyright (C) 2013 The Guava Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.google.common.io;
import com.google.common.base.Predicate;
import com.google.common.collect.ImmutableList;
import com.google.common.graph.Traverser;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.LinkOption;
import java.nio.file.OpenOption;
import java.nio.file.Path;
import java.nio.file.attribute.FileAttribute;

public final class MoreFiles {
  public static ByteSource asByteSource(Path path, OpenOption... options) {
    return null;
  }

  public static ByteSink asByteSink(Path path, OpenOption... options) {
    return null;
  }

  public static CharSource asCharSource(Path path, Charset charset, OpenOption... options) {
    return null;
  }

  public static CharSink asCharSink(Path path, Charset charset, OpenOption... options) {
    return null;
  }

  public static ImmutableList<Path> listFiles(Path dir) throws IOException {
    return null;
  }

  public static Traverser<Path> fileTraverser() {
    return null;
  }

  public static Predicate<Path> isDirectory(LinkOption... options) {
    return null;
  }

  public static Predicate<Path> isRegularFile(LinkOption... options) {
    return null;
  }

  public static boolean equal(Path path1, Path path2) throws IOException {
    return false;
  }

  public static void touch(Path path) throws IOException {
  }

  public static void createParentDirectories(Path path, FileAttribute<?>... attrs)
      throws IOException {
  }

  public static String getFileExtension(Path path) {
    return null;
  }

  public static String getNameWithoutExtension(Path path) {
    return null;
  }

  public static void deleteRecursively(Path path, RecursiveDeleteOption... options)
      throws IOException {
  }

  public static void deleteDirectoryContents(Path path, RecursiveDeleteOption... options)
      throws IOException {
  }

}
