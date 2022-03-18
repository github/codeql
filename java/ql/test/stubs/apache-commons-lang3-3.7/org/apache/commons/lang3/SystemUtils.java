/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.commons.lang3;

import java.io.File;

/**
 * <p>
 * Helpers for {@code java.lang.System}.
 * </p>
 * <p>
 * If a system property cannot be read due to security restrictions, the corresponding field in this class will be set
 * to {@code null} and a message will be written to {@code System.err}.
 * </p>
 * <p>
 * #ThreadSafe#
 * </p>
 *
 * @since 1.0
 */
public class SystemUtils {

    /**
     * The prefix String for all Windows OS.
     */
    private static final String OS_NAME_WINDOWS_PREFIX = "Windows";

    // System property constants
    // -----------------------------------------------------------------------
    // These MUST be declared first. Other constants depend on this.

    /**
     * The System property key for the user home directory.
     */
    private static final String USER_HOME_KEY = "user.home";

    /**
     * The System property key for the user name.
     */
    private static final String USER_NAME_KEY = "user.name";

    /**
     * The System property key for the user directory.
     */
    private static final String USER_DIR_KEY = "user.dir";

    /**
     * The System property key for the Java IO temporary directory.
     */
    private static final String JAVA_IO_TMPDIR_KEY = "java.io.tmpdir";

    /**
     * The System property key for the Java home directory.
     */
    private static final String JAVA_HOME_KEY = "java.home";

    /**
     * <p>
     * The {@code awt.toolkit} System Property.
     * </p>
     * <p>
     * Holds a class name, on Windows XP this is {@code sun.awt.windows.WToolkit}.
     * </p>
     * <p>
     * <b>On platforms without a GUI, this value is {@code null}.</b>
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since 2.1
     */
    public static final String AWT_TOOLKIT = null;

    /**
     * <p>
     * The {@code file.encoding} System Property.
     * </p>
     * <p>
     * File encoding, such as {@code Cp1252}.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since 2.0
     * @since Java 1.2
     */
    public static final String FILE_ENCODING = null;

    /**
     * <p>
     * The {@code file.separator} System Property.
     * The file separator is:
     * </p>
     * <ul>
     * <li>{@code "/"} on UNIX</li>
     * <li>{@code "\"} on Windows.</li>
     * </ul>
     *
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @deprecated Use {@link File#separator}, since it is guaranteed to be a
     *             string containing a single character and it does not require a privilege check.
     * @since Java 1.1
     */
    @Deprecated
    public static final String FILE_SEPARATOR = null;

    /**
     * <p>
     * The {@code java.awt.fonts} System Property.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since 2.1
     */
    public static final String JAVA_AWT_FONTS = null;

    /**
     * <p>
     * The {@code java.awt.graphicsenv} System Property.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since 2.1
     */
    public static final String JAVA_AWT_GRAPHICSENV = null;

    /**
     * <p>
     * The {@code java.awt.headless} System Property. The value of this property is the String {@code "true"} or
     * {@code "false"}.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @see #isJavaAwtHeadless()
     * @since 2.1
     * @since Java 1.4
     */
    public static final String JAVA_AWT_HEADLESS = null;

    /**
     * <p>
     * The {@code java.awt.printerjob} System Property.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since 2.1
     */
    public static final String JAVA_AWT_PRINTERJOB = null;

    /**
     * <p>
     * The {@code java.class.path} System Property. Java class path.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since Java 1.1
     */
    public static final String JAVA_CLASS_PATH = null;

    /**
     * <p>
     * The {@code java.class.version} System Property. Java class format version number.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since Java 1.1
     */
    public static final String JAVA_CLASS_VERSION = null;

    /**
     * <p>
     * The {@code java.compiler} System Property. Name of JIT compiler to use. First in JDK version 1.2. Not used in Sun
     * JDKs after 1.2.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since Java 1.2. Not used in Sun versions after 1.2.
     */
    public static final String JAVA_COMPILER = null;

    /**
     * <p>
     * The {@code java.endorsed.dirs} System Property. Path of endorsed directory or directories.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since Java 1.4
     */
    public static final String JAVA_ENDORSED_DIRS = null;

    /**
     * <p>
     * The {@code java.ext.dirs} System Property. Path of extension directory or directories.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since Java 1.3
     */
    public static final String JAVA_EXT_DIRS = null;

    /**
     * <p>
     * The {@code java.home} System Property. Java installation directory.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since Java 1.1
     */
    public static final String JAVA_HOME = null;

    /**
     * <p>
     * The {@code java.io.tmpdir} System Property. Default temp file path.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since Java 1.2
     */
    public static final String JAVA_IO_TMPDIR = null;

    /**
     * <p>
     * The {@code java.library.path} System Property. List of paths to search when loading libraries.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since Java 1.2
     */
    public static final String JAVA_LIBRARY_PATH = null;

    /**
     * <p>
     * The {@code java.runtime.name} System Property. Java Runtime Environment name.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since 2.0
     * @since Java 1.3
     */
    public static final String JAVA_RUNTIME_NAME = null;

    /**
     * <p>
     * The {@code java.runtime.version} System Property. Java Runtime Environment version.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since 2.0
     * @since Java 1.3
     */
    public static final String JAVA_RUNTIME_VERSION = null;

    /**
     * <p>
     * The {@code java.specification.name} System Property. Java Runtime Environment specification name.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since Java 1.2
     */
    public static final String JAVA_SPECIFICATION_NAME = null;

    /**
     * <p>
     * The {@code java.specification.vendor} System Property. Java Runtime Environment specification vendor.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since Java 1.2
     */
    public static final String JAVA_SPECIFICATION_VENDOR = null;

    /**
     * <p>
     * The {@code java.specification.version} System Property. Java Runtime Environment specification version.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since Java 1.3
     */
    public static final String JAVA_SPECIFICATION_VERSION = null;
    
    /**
     * <p>
     * The {@code java.util.prefs.PreferencesFactory} System Property. A class name.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since 2.1
     * @since Java 1.4
     */
    public static final String JAVA_UTIL_PREFS_PREFERENCES_FACTORY =
        null;

    /**
     * <p>
     * The {@code java.vendor} System Property. Java vendor-specific string.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since Java 1.1
     */
    public static final String JAVA_VENDOR = null;

    /**
     * <p>
     * The {@code java.vendor.url} System Property. Java vendor URL.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since Java 1.1
     */
    public static final String JAVA_VENDOR_URL = null;

    /**
     * <p>
     * The {@code java.version} System Property. Java version number.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since Java 1.1
     */
    public static final String JAVA_VERSION = null;

    /**
     * <p>
     * The {@code java.vm.info} System Property. Java Virtual Machine implementation info.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since 2.0
     * @since Java 1.2
     */
    public static final String JAVA_VM_INFO = null;

    /**
     * <p>
     * The {@code java.vm.name} System Property. Java Virtual Machine implementation name.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since Java 1.2
     */
    public static final String JAVA_VM_NAME = null;

    /**
     * <p>
     * The {@code java.vm.specification.name} System Property. Java Virtual Machine specification name.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since Java 1.2
     */
    public static final String JAVA_VM_SPECIFICATION_NAME = null;

    /**
     * <p>
     * The {@code java.vm.specification.vendor} System Property. Java Virtual Machine specification vendor.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since Java 1.2
     */
    public static final String JAVA_VM_SPECIFICATION_VENDOR = null;

    /**
     * <p>
     * The {@code java.vm.specification.version} System Property. Java Virtual Machine specification version.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since Java 1.2
     */
    public static final String JAVA_VM_SPECIFICATION_VERSION = null;

    /**
     * <p>
     * The {@code java.vm.vendor} System Property. Java Virtual Machine implementation vendor.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since Java 1.2
     */
    public static final String JAVA_VM_VENDOR = null;

    /**
     * <p>
     * The {@code java.vm.version} System Property. Java Virtual Machine implementation version.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since Java 1.2
     */
    public static final String JAVA_VM_VERSION = null;

    /**
     * <p>
     * The {@code line.separator} System Property. Line separator ({@code &quot;\n&quot;} on UNIX).
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @deprecated Use {@link System#lineSeparator()} instead, since it does not require a privilege check.
     * @since Java 1.1
     */
    @Deprecated
    public static final String LINE_SEPARATOR = null;

    /**
     * <p>
     * The {@code os.arch} System Property. Operating system architecture.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since Java 1.1
     */
    public static final String OS_ARCH = null;

    /**
     * <p>
     * The {@code os.name} System Property. Operating system name.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since Java 1.1
     */
    public static final String OS_NAME = null;

    /**
     * <p>
     * The {@code os.version} System Property. Operating system version.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since Java 1.1
     */
    public static final String OS_VERSION = null;

    /**
     * <p>
     * The {@code path.separator} System Property. Path separator ({@code &quot;:&quot;} on UNIX).
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @deprecated Use {@link File#pathSeparator}, since it is guaranteed to be a
     *             string containing a single character and it does not require a privilege check.
     * @since Java 1.1
     */
    @Deprecated
    public static final String PATH_SEPARATOR = null;

    /**
     * <p>
     * The {@code user.country} or {@code user.region} System Property. User's country code, such as {@code GB}. First
     * in Java version 1.2 as {@code user.region}. Renamed to {@code user.country} in 1.4
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since 2.0
     * @since Java 1.2
     */
    public static final String USER_COUNTRY = null == null ? null : null;

    /**
     * <p>
     * The {@code user.dir} System Property. User's current working directory.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since Java 1.1
     */
    public static final String USER_DIR = null;

    /**
     * <p>
     * The {@code user.home} System Property. User's home directory.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since Java 1.1
     */
    public static final String USER_HOME = null;

    /**
     * <p>
     * The {@code user.language} System Property. User's language code, such as {@code "en"}.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since 2.0
     * @since Java 1.2
     */
    public static final String USER_LANGUAGE = null;

    /**
     * <p>
     * The {@code user.name} System Property. User's account name.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since Java 1.1
     */
    public static final String USER_NAME = null;

    /**
     * <p>
     * The {@code user.timezone} System Property. For example: {@code "America/Los_Angeles"}.
     * </p>
     * <p>
     * Defaults to {@code null} if the runtime does not have security access to read this property or the property does
     * not exist.
     * </p>
     * <p>
     * This value is initialized when the class is loaded. If {@link System#setProperty(String,String)} or
     * {@link System#setProperties(java.util.Properties)} is called after this class is loaded, the value will be out of
     * sync with that System property.
     * </p>
     *
     * @since 2.1
     */
    public static final String USER_TIMEZONE = null;

    // Java version checks
    // -----------------------------------------------------------------------
    // These MUST be declared after those above as they depend on the
    // values being set up

    /**
     * <p>
     * Is {@code true} if this is Java version 1.1 (also 1.1.x versions).
     * </p>
     * <p>
     * The field will return {@code false} if {@link #JAVA_VERSION} is {@code null}.
     * </p>
     */
    public static final boolean IS_JAVA_1_1 = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Java version 1.2 (also 1.2.x versions).
     * </p>
     * <p>
     * The field will return {@code false} if {@link #JAVA_VERSION} is {@code null}.
     * </p>
     */
    public static final boolean IS_JAVA_1_2 = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Java version 1.3 (also 1.3.x versions).
     * </p>
     * <p>
     * The field will return {@code false} if {@link #JAVA_VERSION} is {@code null}.
     * </p>
     */
    public static final boolean IS_JAVA_1_3 = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Java version 1.4 (also 1.4.x versions).
     * </p>
     * <p>
     * The field will return {@code false} if {@link #JAVA_VERSION} is {@code null}.
     * </p>
     */
    public static final boolean IS_JAVA_1_4 = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Java version 1.5 (also 1.5.x versions).
     * </p>
     * <p>
     * The field will return {@code false} if {@link #JAVA_VERSION} is {@code null}.
     * </p>
     */
    public static final boolean IS_JAVA_1_5 = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Java version 1.6 (also 1.6.x versions).
     * </p>
     * <p>
     * The field will return {@code false} if {@link #JAVA_VERSION} is {@code null}.
     * </p>
     */
    public static final boolean IS_JAVA_1_6 = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Java version 1.7 (also 1.7.x versions).
     * </p>
     * <p>
     * The field will return {@code false} if {@link #JAVA_VERSION} is {@code null}.
     * </p>
     *
     * @since 3.0
     */
    public static final boolean IS_JAVA_1_7 = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Java version 1.8 (also 1.8.x versions).
     * </p>
     * <p>
     * The field will return {@code false} if {@link #JAVA_VERSION} is {@code null}.
     * </p>
     *
     * @since 3.3.2
     */
    public static final boolean IS_JAVA_1_8 = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Java version 1.9 (also 1.9.x versions).
     * </p>
     * <p>
     * The field will return {@code false} if {@link #JAVA_VERSION} is {@code null}.
     * </p>
     *
     * @since 3.4
     *
     * @deprecated As of release 3.5, replaced by {@link #IS_JAVA_9}
     */
    @Deprecated
    public static final boolean IS_JAVA_1_9 = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Java version 9 (also 9.x versions).
     * </p>
     * <p>
     * The field will return {@code false} if {@link #JAVA_VERSION} is {@code null}.
     * </p>
     *
     * @since 3.5
     */
    public static final boolean IS_JAVA_9 = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Java version 10 (also 10.x versions).
     * </p>
     * <p>
     * The field will return {@code false} if {@link #JAVA_VERSION} is {@code null}.
     * </p>
     *
     * @since 3.7
     */
    public static final boolean IS_JAVA_10 = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Java version 11 (also 11.x versions).
     * </p>
     * <p>
     * The field will return {@code false} if {@link #JAVA_VERSION} is {@code null}.
     * </p>
     *
     * @since 3.8
     */
    public static final boolean IS_JAVA_11 = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Java version 12 (also 12.x versions).
     * </p>
     * <p>
     * The field will return {@code false} if {@link #JAVA_VERSION} is {@code null}.
     * </p>
     *
     * @since 3.9
     */
    public static final boolean IS_JAVA_12 = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Java version 13 (also 13.x versions).
     * </p>
     * <p>
     * The field will return {@code false} if {@link #JAVA_VERSION} is {@code null}.
     * </p>
     *
     * @since 3.9
     */
    public static final boolean IS_JAVA_13 = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Java version 14 (also 14.x versions).
     * </p>
     * <p>
     * The field will return {@code false} if {@link #JAVA_VERSION} is {@code null}.
     * </p>
     *
     * @since 3.10
     */
    public static final boolean IS_JAVA_14 = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Java version 15 (also 15.x versions).
     * </p>
     * <p>
     * The field will return {@code false} if {@link #JAVA_VERSION} is {@code null}.
     * </p>
     *
     * @since 3.10
     */
    public static final boolean IS_JAVA_15 = compileTimeConstantBreakerBoolean();

    /**
     * Is {@code true} if this is Java version 16 (also 16.x versions).
     * <p>
     * The field will return {@code false} if {@link #JAVA_VERSION} is {@code null}.
     * </p>
     *
     * @since 3.13.0
     */
    public static final boolean IS_JAVA_16 = compileTimeConstantBreakerBoolean();

    // Operating system checks
    // -----------------------------------------------------------------------
    // These MUST be declared after those above as they depend on the
    // values being set up
    // OS names from http://www.vamphq.com/os.html
    // Selected ones included - please advise dev@commons.apache.org
    // if you want another added or a mistake corrected

    /**
     * <p>
     * Is {@code true} if this is AIX.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 2.0
     */
    public static final boolean IS_OS_AIX = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is HP-UX.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 2.0
     */
    public static final boolean IS_OS_HP_UX = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is IBM OS/400.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 3.3
     */
    public static final boolean IS_OS_400 = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Irix.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 2.0
     */
    public static final boolean IS_OS_IRIX = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Linux.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 2.0
     */
    public static final boolean IS_OS_LINUX = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Mac.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 2.0
     */
    public static final boolean IS_OS_MAC = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Mac.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 2.0
     */
    public static final boolean IS_OS_MAC_OSX = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Mac OS X Cheetah.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 3.4
     */
    public static final boolean IS_OS_MAC_OSX_CHEETAH = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Mac OS X Puma.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 3.4
     */
    public static final boolean IS_OS_MAC_OSX_PUMA = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Mac OS X Jaguar.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 3.4
     */
    public static final boolean IS_OS_MAC_OSX_JAGUAR = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Mac OS X Panther.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 3.4
     */
    public static final boolean IS_OS_MAC_OSX_PANTHER = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Mac OS X Tiger.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 3.4
     */
    public static final boolean IS_OS_MAC_OSX_TIGER = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Mac OS X Leopard.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 3.4
     */
    public static final boolean IS_OS_MAC_OSX_LEOPARD = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Mac OS X Snow Leopard.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 3.4
     */
    public static final boolean IS_OS_MAC_OSX_SNOW_LEOPARD = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Mac OS X Lion.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 3.4
     */
    public static final boolean IS_OS_MAC_OSX_LION = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Mac OS X Mountain Lion.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 3.4
     */
    public static final boolean IS_OS_MAC_OSX_MOUNTAIN_LION = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Mac OS X Mavericks.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 3.4
     */
    public static final boolean IS_OS_MAC_OSX_MAVERICKS = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Mac OS X Yosemite.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 3.4
     */
    public static final boolean IS_OS_MAC_OSX_YOSEMITE = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Mac OS X El Capitan.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 3.5
     */
    public static final boolean IS_OS_MAC_OSX_EL_CAPITAN = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Mac OS X Sierra.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 3.12.0
     */
    public static final boolean IS_OS_MAC_OSX_SIERRA = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Mac OS X High Sierra.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 3.12.0
     */
    public static final boolean IS_OS_MAC_OSX_HIGH_SIERRA = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Mac OS X Mojave.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 3.12.0
     */
    public static final boolean IS_OS_MAC_OSX_MOJAVE = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Mac OS X Catalina.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 3.12.0
     */
    public static final boolean IS_OS_MAC_OSX_CATALINA = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Mac OS X Big Sur.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 3.12.0
     */
    public static final boolean IS_OS_MAC_OSX_BIG_SUR = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is FreeBSD.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 3.1
     */
    public static final boolean IS_OS_FREE_BSD = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is OpenBSD.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 3.1
     */
    public static final boolean IS_OS_OPEN_BSD = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is NetBSD.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 3.1
     */
    public static final boolean IS_OS_NET_BSD = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is OS/2.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 2.0
     */
    public static final boolean IS_OS_OS2 = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Solaris.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 2.0
     */
    public static final boolean IS_OS_SOLARIS = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is SunOS.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 2.0
     */
    public static final boolean IS_OS_SUN_OS = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is a UNIX like system, as in any of AIX, HP-UX, Irix, Linux, MacOSX, Solaris or SUN OS.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 2.1
     */
    public static final boolean IS_OS_UNIX = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Windows.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 2.0
     */
    public static final boolean IS_OS_WINDOWS = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Windows 2000.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 2.0
     */
    public static final boolean IS_OS_WINDOWS_2000 = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Windows 2003.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 3.1
     */
    public static final boolean IS_OS_WINDOWS_2003 = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Windows Server 2008.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 3.1
     */
    public static final boolean IS_OS_WINDOWS_2008 = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Windows Server 2012.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 3.4
     */
    public static final boolean IS_OS_WINDOWS_2012 = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Windows 95.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 2.0
     */
    public static final boolean IS_OS_WINDOWS_95 = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Windows 98.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 2.0
     */
    public static final boolean IS_OS_WINDOWS_98 = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Windows ME.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 2.0
     */
    public static final boolean IS_OS_WINDOWS_ME = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Windows NT.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 2.0
     */
    public static final boolean IS_OS_WINDOWS_NT = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Windows XP.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 2.0
     */
    public static final boolean IS_OS_WINDOWS_XP = compileTimeConstantBreakerBoolean();

    // -----------------------------------------------------------------------
    /**
     * <p>
     * Is {@code true} if this is Windows Vista.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 2.4
     */
    public static final boolean IS_OS_WINDOWS_VISTA = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Windows 7.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 3.0
     */
    public static final boolean IS_OS_WINDOWS_7 = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Windows 8.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 3.2
     */
    public static final boolean IS_OS_WINDOWS_8 = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is Windows 10.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 3.5
     */
    public static final boolean IS_OS_WINDOWS_10 = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Is {@code true} if this is z/OS.
     * </p>
     * <p>
     * The field will return {@code false} if {@code OS_NAME} is {@code null}.
     * </p>
     *
     * @since 3.5
     */
    // Values on a z/OS system I tested (Gary Gregory - 2016-03-12)
    // os.arch = s390x
    // os.encoding = ISO8859_1
    // os.name = z/OS
    // os.version = 02.02.00
    public static final boolean IS_OS_ZOS = compileTimeConstantBreakerBoolean();

    /**
     * <p>
     * Gets an environment variable, defaulting to {@code defaultValue} if the variable cannot be read.
     * </p>
     * <p>
     * If a {@code SecurityException} is caught, the return value is {@code defaultValue} and a message is written to
     * {@code System.err}.
     * </p>
     *
     * @param name
     *            the environment variable name
     * @param defaultValue
     *            the default value
     * @return the environment variable value or {@code defaultValue} if a security problem occurs
     * @since 3.8
     */
    public static String getEnvironmentVariable(final String name, final String defaultValue) {
        return null;
    }

    /**
     * Gets the host name from an environment variable
     * (COMPUTERNAME on Windows, HOSTNAME elsewhere).
     *
     * <p>
     * If you want to know what the network stack says is the host name, you should use {@code InetAddress.getLocalHost().getHostName()}.
     * </p>
     *
     * @return the host name. Will be {@code null} if the environment variable is not defined.
     * @since 3.6
     */
    public static String getHostName() {
        return null;
    }

    /**
     * <p>
     * Gets the Java home directory as a {@code File}.
     * </p>
     *
     * @return a directory
     * @throws SecurityException if a security manager exists and its {@code checkPropertyAccess} method doesn't allow
     * access to the specified system property.
     * @see System#getProperty(String)
     * @since 2.1
     */
    public static File getJavaHome() {
        return null;
    }

    /**
     * <p>
     * Gets the Java IO temporary directory as a {@code File}.
     * </p>
     *
     * @return a directory
     * @throws SecurityException if a security manager exists and its {@code checkPropertyAccess} method doesn't allow
     * access to the specified system property.
     * @see System#getProperty(String)
     * @since 2.1
     */
    public static File getJavaIoTmpDir() {
        return null;
    }
 
    /**
     * <p>
     * Gets the user directory as a {@code File}.
     * </p>
     *
     * @return a directory
     * @throws SecurityException if a security manager exists and its {@code checkPropertyAccess} method doesn't allow
     * access to the specified system property.
     * @see System#getProperty(String)
     * @since 2.1
     */
    public static File getUserDir() {
        return null;
    }

    /**
     * <p>
     * Gets the user home directory as a {@code File}.
     * </p>
     *
     * @return a directory
     * @throws SecurityException if a security manager exists and its {@code checkPropertyAccess} method doesn't allow
     * access to the specified system property.
     * @see System#getProperty(String)
     * @since 2.1
     */
    public static File getUserHome() {
        return null;
    }

    /**
     * <p>
     * Gets the user name.
     * </p>
     *
     * @return a name
     * @throws SecurityException if a security manager exists and its {@code checkPropertyAccess} method doesn't allow
     * access to the specified system property.
     * @see System#getProperty(String)
     * @since 3.10
     */
    public static String getUserName() {
        return null;
    }

    /**
     * <p>
     * Gets the user name.
     * </p>
     *
     * @param defaultValue A default value.
     * @return a name
     * @throws SecurityException if a security manager exists and its {@code checkPropertyAccess} method doesn't allow
     * access to the specified system property.
     * @see System#getProperty(String)
     * @since 3.10
     */
    public static String getUserName(final String defaultValue) {
        return null;
    }

    /**
     * Returns whether the {@link #JAVA_AWT_HEADLESS} value is {@code true}.
     *
     * @return {@code true} if {@code JAVA_AWT_HEADLESS} is {@code "true"}, {@code false} otherwise.
     * @see #JAVA_AWT_HEADLESS
     * @since 2.1
     * @since Java 1.4
     */
    public static boolean isJavaAwtHeadless() {
        return Boolean.TRUE.toString().equals(JAVA_AWT_HEADLESS);
    }

    /**
     * A method that can be called to break the compile-time constant generation by the java compiler.
     * This makes the CodeQL tests more accurate to when user code is compiled against the real implementation of this library. 
     */
    private static boolean compileTimeConstantBreakerBoolean() {
        return "".contains(".");
    }

    // -----------------------------------------------------------------------
    /**
     * <p>
     * SystemUtils instances should NOT be constructed in standard programming. Instead, the class should be used as
     * {@code SystemUtils.FILE_SEPARATOR}.
     * </p>
     * <p>
     * This constructor is public to permit tools that require a JavaBean instance to operate.
     * </p>
     */
    public SystemUtils() {
    }

}