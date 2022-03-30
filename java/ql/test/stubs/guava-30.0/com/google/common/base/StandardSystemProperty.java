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

package com.google.common.base;

public enum StandardSystemProperty {

  /** Java Runtime Environment version. */
  JAVA_VERSION("java.version"),

  /** Java Runtime Environment vendor. */
  JAVA_VENDOR("java.vendor"),

  /** Java vendor URL. */
  JAVA_VENDOR_URL("java.vendor.url"),

  /** Java installation directory. */
  JAVA_HOME("java.home"),

  /** Java Virtual Machine specification version. */
  JAVA_VM_SPECIFICATION_VERSION("java.vm.specification.version"),

  /** Java Virtual Machine specification vendor. */
  JAVA_VM_SPECIFICATION_VENDOR("java.vm.specification.vendor"),

  /** Java Virtual Machine specification name. */
  JAVA_VM_SPECIFICATION_NAME("java.vm.specification.name"),

  /** Java Virtual Machine implementation version. */
  JAVA_VM_VERSION("java.vm.version"),

  /** Java Virtual Machine implementation vendor. */
  JAVA_VM_VENDOR("java.vm.vendor"),

  /** Java Virtual Machine implementation name. */
  JAVA_VM_NAME("java.vm.name"),

  /** Java Runtime Environment specification version. */
  JAVA_SPECIFICATION_VERSION("java.specification.version"),

  /** Java Runtime Environment specification vendor. */
  JAVA_SPECIFICATION_VENDOR("java.specification.vendor"),

  /** Java Runtime Environment specification name. */
  JAVA_SPECIFICATION_NAME("java.specification.name"),

  /** Java class format version number. */
  JAVA_CLASS_VERSION("java.class.version"),

  /** Java class path. */
  JAVA_CLASS_PATH("java.class.path"),

  /** List of paths to search when loading libraries. */
  JAVA_LIBRARY_PATH("java.library.path"),

  /** Default temp file path. */
  JAVA_IO_TMPDIR("java.io.tmpdir"),

  /** Name of JIT compiler to use. */
  JAVA_COMPILER("java.compiler"),

  /**
   * Path of extension directory or directories.
   *
   * @deprecated This property was <a
   *     href="https://openjdk.java.net/jeps/220#Removed:-The-extension-mechanism">deprecated</a> in
   *     Java 8 and removed in Java 9. We do not plan to remove this API from Guava, but if you are
   *     using it, it is probably not doing what you want.
   */
  @Deprecated
  JAVA_EXT_DIRS("java.ext.dirs"),

  /** Operating system name. */
  OS_NAME("os.name"),

  /** Operating system architecture. */
  OS_ARCH("os.arch"),

  /** Operating system version. */
  OS_VERSION("os.version"),

  /** File separator ("/" on UNIX). */
  FILE_SEPARATOR("file.separator"),

  /** Path separator (":" on UNIX). */
  PATH_SEPARATOR("path.separator"),

  /** Line separator ("\n" on UNIX). */
  LINE_SEPARATOR("line.separator"),

  /** User's account name. */
  USER_NAME("user.name"),

  /** User's home directory. */
  USER_HOME("user.home"),

  /** User's current working directory. */
  USER_DIR("user.dir");

  private final String key;

  StandardSystemProperty(String key) {
    this.key = key;
  }

  /** Returns the key used to lookup this system property. */
  public String key() {
    return null;
  }

  public String value() {
    return null;
  }

  /** Returns a string representation of this system property. */
  @Override
  public String toString() {
    return null;
  }
}