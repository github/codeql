/*
 * Copyright (C) 2006 The Android Open Source Project
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

package android.os;

import java.io.Closeable;
import java.io.File;
import java.io.FileDescriptor;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.DatagramSocket;
import java.net.Socket;

public class ParcelFileDescriptor implements Parcelable, Closeable {
  public ParcelFileDescriptor(ParcelFileDescriptor wrapped) {}

  public ParcelFileDescriptor(FileDescriptor fd) {}

  public ParcelFileDescriptor(FileDescriptor fd, FileDescriptor commChannel) {}

  public static ParcelFileDescriptor open(File file, int mode) throws FileNotFoundException {
    return null;
  }

  public static ParcelFileDescriptor dup(FileDescriptor orig) throws IOException {
    return null;
  }

  public ParcelFileDescriptor dup() throws IOException {
    return null;
  }

  public static ParcelFileDescriptor fromFd(int fd) throws IOException {
    return null;
  }

  public static ParcelFileDescriptor adoptFd(int fd) {
    return null;
  }

  public static ParcelFileDescriptor fromSocket(Socket socket) {
    return null;
  }

  public static ParcelFileDescriptor fromDatagramSocket(DatagramSocket datagramSocket) {
    return null;
  }

  public static ParcelFileDescriptor[] createPipe() throws IOException {
    return null;
  }

  public static ParcelFileDescriptor[] createReliablePipe() throws IOException {
    return null;
  }

  public static ParcelFileDescriptor[] createSocketPair() throws IOException {
    return null;
  }

  public static ParcelFileDescriptor[] createSocketPair(int type) throws IOException {
    return null;
  }

  public static ParcelFileDescriptor[] createReliableSocketPair() throws IOException {
    return null;
  }

  public static ParcelFileDescriptor[] createReliableSocketPair(int type) throws IOException {
    return null;
  }

  public static ParcelFileDescriptor fromData(byte[] data, String name) throws IOException {
    return null;
  }

  public static int parseMode(String mode) {
    return 0;
  }

  public static File getFile(FileDescriptor fd) throws IOException {
    return null;
  }

  public FileDescriptor getFileDescriptor() {
    return null;
  }

  public long getStatSize() {
    return 0;
  }

  public long seekTo(long pos) throws IOException {
    return 0;
  }

  public int getFd() {
    return 0;
  }

  public int detachFd() {
    return 0;
  }

  @Override
  public void close() throws IOException {}

  public void closeWithError(String msg) throws IOException {}

  public void releaseResources() {}

  public boolean canDetectErrors() {
    return false;
  }

  public void checkError() throws IOException {}

  @Override
  public String toString() {
    return null;
  }

  public int describeContents() {
    return 0;
  }

  @Override
  public void writeToParcel(Parcel out, int flags) {}

  public interface OnCloseListener {
    public void onClose(IOException e);

  }
  public static class FileDescriptorDetachedException extends IOException {
    public FileDescriptorDetachedException() {}

  }
}
