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
import java.io.DataInput;

public interface ByteArrayDataInput extends DataInput {
  @Override
  void readFully(byte b[]);

  @Override
  void readFully(byte b[], int off, int len);

  @Override
  int skipBytes(int n);

  @Override
  boolean readBoolean();

  @Override
  byte readByte();

  @Override
  int readUnsignedByte();

  @Override
  short readShort();

  @Override
  int readUnsignedShort();

  @Override
  char readChar();

  @Override
  int readInt();

  @Override
  long readLong();

  @Override
  float readFloat();

  @Override
  double readDouble();

  @Override
  String readLine();

  @Override
  String readUTF();

}
