/*
 * Copyright (c) 1997, 2020 Oracle and/or its affiliates. All rights reserved.
 *
 * This program and the accompanying materials are made available under the terms of the Eclipse
 * Public License v. 2.0, which is available at http://www.eclipse.org/legal/epl-2.0.
 *
 * This Source Code may also be made available under the following Secondary Licenses when the
 * conditions for such availability set forth in the Eclipse Public License v. 2.0 are satisfied:
 * GNU General Public License, version 2 with the GNU Classpath Exception, which is available at
 * https://www.gnu.org/software/classpath/license.html.
 *
 * SPDX-License-Identifier: EPL-2.0 OR GPL-2.0 WITH Classpath-exception-2.0
 */

package jakarta.mail;

import java.lang.reflect.*;
import java.io.*;
import java.net.*;
import java.security.*;
import java.util.Properties;

public final class Session {
  public static Session getInstance(Properties props, Authenticator authenticator) {
    return null;
  }

  public static Session getInstance(Properties props) {
    return null;
  }

  public static synchronized Session getDefaultInstance(Properties props,
      Authenticator authenticator) {
    return null;
  }

  public static Session getDefaultInstance(Properties props) {
    return null;
  }

  public synchronized void setDebug(boolean debug) {}

  public synchronized boolean getDebug() {
    return false;
  }

  public synchronized void setDebugOut(PrintStream out) {}

  public synchronized PrintStream getDebugOut() {
    return null;
  }

  public synchronized Provider[] getProviders() {
    return null;
  }

  public synchronized Provider getProvider(String protocol) throws NoSuchProviderException {
    return null;
  }

  public synchronized void setProvider(Provider provider) throws NoSuchProviderException {}

  public PasswordAuthentication requestPasswordAuthentication(InetAddress addr, int port,
      String protocol, String prompt, String defaultUserName) {
    return null;
  }

  public Properties getProperties() {
    return null;
  }

  public String getProperty(String name) {
    return null;
  }

  public synchronized void addProvider(Provider provider) {}

  public synchronized void setProtocolForAddress(String addresstype, String protocol) {}

}
