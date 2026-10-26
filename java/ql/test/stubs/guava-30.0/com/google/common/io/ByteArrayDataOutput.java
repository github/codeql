/*
 * Copyright (C) 2009 The Guava Authors
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
import java.io.DataOutput;

public interface ByteArrayDataOutput extends DataOutput {
  @Override
  void write(int b);

  @Override
  void write(byte b[]);

  @Override
  void write(byte b[], int off, int len);

  @Override
  void writeBoolean(boolean v);

  @Override
  void writeByte(int v);

  @Override
  void writeShort(int v);

  @Override
  void writeChar(int v);

  @Override
  void writeInt(int v);

  @Override
  void writeLong(long v);

  @Override
  void writeFloat(float v);

  @Override
  void writeDouble(double v);

  @Override
  void writeChars(String s);

  @Override
  void writeUTF(String s);

  @Override
  void writeBytes(String s);

  byte[] toByteArray();

}
