/*
 * Copyright (C) 2007 The Guava Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 */

package com.google.common.io;
import com.google.common.base.Predicate;
import com.google.common.graph.Traverser;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel.MapMode;
import java.nio.charset.Charset;
import java.util.List;

public final class Files {
  public static BufferedReader newReader(File file, Charset charset) throws FileNotFoundException {
    return null;
  }

  public static BufferedWriter newWriter(File file, Charset charset) throws FileNotFoundException {
    return null;
  }

  public static ByteSource asByteSource(File file) {
    return null;
  }

  public static ByteSink asByteSink(File file, FileWriteMode... modes) {
    return null;
  }

  public static CharSource asCharSource(File file, Charset charset) {
    return null;
  }

  public static CharSink asCharSink(File file, Charset charset, FileWriteMode... modes) {
    return null;
  }

  public static byte[] toByteArray(File file) throws IOException {
    return null;
  }

  public static String toString(File file, Charset charset) throws IOException {
    return null;
  }

  public static void write(byte[] from, File to) throws IOException {
  }

  public static void write(CharSequence from, File to, Charset charset) throws IOException {
  }

  public static void copy(File from, OutputStream to) throws IOException {
  }

  public static void copy(File from, File to) throws IOException {
  }

  public static boolean equal(File file1, File file2) throws IOException {
    return false;
  }

  public static File createTempDir() {
    return null;
  }

  public static void touch(File file) throws IOException {
  }

  public static void createParentDirs(File file) throws IOException {
  }

  public static void move(File from, File to) throws IOException {
  }

  public static List<String> readLines(File file, Charset charset) throws IOException {
    return null;
  }

  public static MappedByteBuffer map(File file) throws IOException {
    return null;
  }

  public static MappedByteBuffer map(File file, MapMode mode) throws IOException {
    return null;
  }

  public static MappedByteBuffer map(File file, MapMode mode, long size) throws IOException {
    return null;
  }

  public static String simplifyPath(String pathname) {
    return null;
  }

  public static String getFileExtension(String fullName) {
    return null;
  }

  public static String getNameWithoutExtension(String file) {
    return null;
  }

  public static Traverser<File> fileTraverser() {
    return null;
  }

  public static Predicate<File> isDirectory() {
    return null;
  }

  public static Predicate<File> isFile() {
    return null;
  }

}
