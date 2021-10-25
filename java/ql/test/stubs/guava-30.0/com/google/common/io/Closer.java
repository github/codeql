/*
 * Copyright (C) 2012 The Guava Authors
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
import java.io.Closeable;
import java.io.IOException;
import org.checkerframework.checker.nullness.qual.Nullable;

public final class Closer implements Closeable {
  public static Closer create() {
    return null;
  }

  public <C extends Closeable> C register(@Nullable C closeable) {
    return null;
  }

  public RuntimeException rethrow(Throwable e) throws IOException {
    return null;
  }

  public <X extends Exception> RuntimeException rethrow(Throwable e, Class<X> declaredType)
      throws IOException, X {
    return null;
  }

  public <X1 extends Exception, X2 extends Exception> RuntimeException rethrow(
      Throwable e, Class<X1> declaredType1, Class<X2> declaredType2) throws IOException, X1, X2 {
    return null;
  }

  @Override
  public void close() throws IOException {
  }

}
