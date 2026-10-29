/*
 * Copyright (C) 2011 The Guava Authors
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

package com.google.common.hash;
import java.nio.ByteBuffer;
import java.nio.charset.Charset;

public interface HashFunction {
  Hasher newHasher();

  Hasher newHasher(int expectedInputSize);

  HashCode hashInt(int input);

  HashCode hashLong(long input);

  HashCode hashBytes(byte[] input);

  HashCode hashBytes(byte[] input, int off, int len);

  HashCode hashBytes(ByteBuffer input);

  HashCode hashUnencodedChars(CharSequence input);

  HashCode hashString(CharSequence input, Charset charset);

  <T> HashCode hashObject(T instance, Funnel<? super T> funnel);

  int bits();

}
