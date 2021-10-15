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
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.WritableByteChannel;

public final class ByteStreams {
  public static long copy(InputStream from, OutputStream to) throws IOException {
    return 0;
  }

  public static long copy(ReadableByteChannel from, WritableByteChannel to) throws IOException {
    return 0;
  }

  public static byte[] toByteArray(InputStream in) throws IOException {
    return null;
  }

  public static long exhaust(InputStream in) throws IOException {
    return 0;
  }

  public static ByteArrayDataInput newDataInput(byte[] bytes) {
    return null;
  }

  public static ByteArrayDataInput newDataInput(byte[] bytes, int start) {
    return null;
  }

  public static ByteArrayDataInput newDataInput(ByteArrayInputStream byteArrayInputStream) {
    return null;
  }

  public static ByteArrayDataOutput newDataOutput() {
    return null;
  }

  public static ByteArrayDataOutput newDataOutput(int size) {
    return null;
  }

  public static ByteArrayDataOutput newDataOutput(ByteArrayOutputStream byteArrayOutputStream) {
    return null;
  }

  public static OutputStream nullOutputStream() {
    return null;
  }

  public static InputStream limit(InputStream in, long limit) {
    return null;
  }

  public static void readFully(InputStream in, byte[] b) throws IOException {
  }

  public static void readFully(InputStream in, byte[] b, int off, int len) throws IOException {
  }

  public static void skipFully(InputStream in, long n) throws IOException {
  }

  public static <T> T readBytes(InputStream input, ByteProcessor<T> processor) throws IOException {
    return null;
  }

  public static int read(InputStream in, byte[] b, int off, int len) throws IOException {
    return 0;
  }

}
