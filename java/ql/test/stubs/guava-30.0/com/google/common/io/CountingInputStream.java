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
import java.io.FilterInputStream;
import java.io.IOException;
import java.io.InputStream;

public final class CountingInputStream extends FilterInputStream {
  public CountingInputStream(InputStream in) {
    super(in);
  }

  public long getCount() {
    return 0;
  }

  @Override
  public int read() throws IOException {
    return 0;
  }

  @Override
  public int read(byte[] b, int off, int len) throws IOException {
    return 0;
  }

  @Override
  public long skip(long n) throws IOException {
    return 0;
  }

  @Override
  public synchronized void mark(int readlimit) {
  }

  @Override
  public synchronized void reset() throws IOException {
  }

}
