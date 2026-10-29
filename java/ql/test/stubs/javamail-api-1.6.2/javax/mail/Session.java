/*
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
 *
 * Copyright (c) 1997-2018 Oracle and/or its affiliates. All rights reserved.
 *
 * The contents of this file are subject to the terms of either the GNU
 * General Public License Version 2 only ("GPL") or the Common Development
 * and Distribution License("CDDL") (collectively, the "License").  You
 * may not use this file except in compliance with the License.  You can
 * obtain a copy of the License at
 * https://oss.oracle.com/licenses/CDDL+GPL-1.1
 * or LICENSE.txt.  See the License for the specific
 * language governing permissions and limitations under the License.
 *
 * When distributing the software, include this License Header Notice in each
 * file and include the License file at LICENSE.txt.
 *
 * GPL Classpath Exception:
 * Oracle designates this particular file as subject to the "Classpath"
 * exception as provided by Oracle in the GPL Version 2 section of the License
 * file that accompanied this code.
 *
 * Modifications:
 * If applicable, add the following below the License Header, with the fields
 * enclosed by brackets [] replaced by your own identifying information:
 * "Portions Copyright [year] [name of copyright owner]"
 *
 * Contributor(s):
 * If you wish your version of this file to be governed by only the CDDL or
 * only the GPL Version 2, indicate your decision by adding "[Contributor]
 * elects to include this software in this distribution under the [CDDL or GPL
 * Version 2] license."  If you don't indicate a single choice of license, a
 * recipient has the option to distribute your version of this file under
 * either the CDDL, the GPL Version 2 or to extend the choice of license to
 * its licensees as provided above.  However, if you add GPL Version 2 code
 * and therefore, elected the GPL Version 2 license, then the option applies
 * only if the new code is made subject to such option by the copyright
 * holder.
 */

package javax.mail;

import java.lang.reflect.*;
import java.io.*;
import java.net.*;
import java.security.*;
import java.util.Collections;
import java.util.Hashtable;
import java.util.Map;
import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;
import java.util.Properties;
import java.util.StringTokenizer;
import java.util.ServiceLoader;
import java.util.logging.Level;
import java.util.concurrent.Executor;

/**
 * The Session class represents a mail session and is not subclassed. It
 * collects together properties and defaults used by the mail API's. A single
 * default session can be shared by multiple applications on the desktop.
 * Unshared sessions can also be created.
 * <p>
 *
 * The Session class provides access to the protocol providers that implement
 * the <code>Store</code>, <code>Transport</code>, and related classes. The
 * protocol providers are configured using the following files:
 * <ul>
 * <li><code>javamail.providers</code> and
 * <code>javamail.default.providers</code></li>
 * <li><code>javamail.address.map</code> and
 * <code>javamail.default.address.map</code></li>
 * </ul>
 * <p>
 * Each <code>javamail.</code><i>X</i> resource file is searched for using three
 * methods in the following order:
 * <ol>
 * <li><code><i>java.home</i>/<i>conf</i>/javamail.</code><i>X</i></li>
 * <li><code>META-INF/javamail.</code><i>X</i></li>
 * <li><code>META-INF/javamail.default.</code><i>X</i></li>
 * </ol>
 * <p>
 * (Where <i>java.home</i> is the value of the "java.home" System property and
 * <i>conf</i> is the directory named "conf" if it exists, otherwise the
 * directory named "lib"; the "conf" directory was introduced in JDK 1.9.)
 * <p>
 * The first method allows the user to include their own version of the resource
 * file by placing it in the <i>conf</i> directory where the
 * <code>java.home</code> property points. The second method allows an
 * application that uses the JavaMail APIs to include their own resource files
 * in their application's or jar file's <code>META-INF</code> directory. The
 * <code>javamail.default.</code><i>X</i> default files are part of the JavaMail
 * <code>mail.jar</code> file and should not be supplied by users.
 * <p>
 *
 * File location depends upon how the <code>ClassLoader</code> method
 * <code>getResource</code> is implemented. Usually, the
 * <code>getResource</code> method searches through CLASSPATH until it finds the
 * requested file and then stops.
 * <p>
 *
 * The ordering of entries in the resource files matters. If multiple entries
 * exist, the first entries take precedence over the later entries. For example,
 * the first IMAP provider found will be set as the default IMAP implementation
 * until explicitly changed by the application. The user- or system-supplied
 * resource files augment, they do not override, the default files included with
 * the JavaMail APIs. This means that all entries in all files loaded will be
 * available.
 * <p>
 *
 * <b><code>javamail.providers</code></b> and
 * <b><code>javamail.default.providers</code></b>
 * <p>
 *
 * These resource files specify the stores and transports that are available on
 * the system, allowing an application to "discover" what store and transport
 * implementations are available. The protocol implementations are listed one
 * per line. The file format defines four attributes that describe a protocol
 * implementation. Each attribute is an "="-separated name-value pair with the
 * name in lowercase. Each name-value pair is semi-colon (";") separated. The
 * following names are defined.
 *
 * <table border=1>
 * <caption> Attribute Names in Providers Files </caption>
 * <tr>
 * <th>Name</th>
 * <th>Description</th>
 * </tr>
 * <tr>
 * <td>protocol</td>
 * <td>Name assigned to protocol. For example, <code>smtp</code> for
 * Transport.</td>
 * </tr>
 * <tr>
 * <td>type</td>
 * <td>Valid entries are <code>store</code> and <code>transport</code>.</td>
 * </tr>
 * <tr>
 * <td>class</td>
 * <td>Class name that implements this protocol.</td>
 * </tr>
 * <tr>
 * <td>vendor</td>
 * <td>Optional string identifying the vendor.</td>
 * </tr>
 * <tr>
 * <td>version</td>
 * <td>Optional string identifying the version.</td>
 * </tr>
 * </table>
 * <p>
 *
 * Here's an example of <code>META-INF/javamail.default.providers</code> file
 * contents:
 * 
 * <pre>
 * protocol=imap; type=store; class=com.sun.mail.imap.IMAPStore; vendor=Oracle;
 * protocol=smtp; type=transport; class=com.sun.mail.smtp.SMTPTransport; vendor=Oracle;
 * </pre>
 * <p>
 *
 * The current implementation also supports configuring providers using the Java
 * SE {@link java.util.ServiceLoader ServiceLoader} mechanism. When creating
 * your own provider, create a {@link Provider} subclass, for example:
 * 
 * <pre>
 * package com.example;
 *
 * import javax.mail.Provider;
 *
 * public class MyProvider extends Provider {
 * 	public MyProvider() {
 * 		super(Provider.Type.STORE, "myprot", MyStore.class.getName(), "Example", null);
 * 	}
 * }
 * </pre>
 * 
 * Then include a file named <code>META-INF/services/javax.mail.Provider</code>
 * in your jar file that lists the name of your Provider class:
 * 
 * <pre>
 * com.example.MyProvider
 * </pre>
 * <p>
 *
 * <b><code>javamail.address.map</code></b> and
 * <b><code>javamail.default.address.map</code></b>
 * <p>
 *
 * These resource files map transport address types to the transport protocol.
 * The <code>getType</code> method of <code>javax.mail.Address</code> returns
 * the address type. The <code>javamail.address.map</code> file maps the
 * transport type to the protocol. The file format is a series of name-value
 * pairs. Each key name should correspond to an address type that is currently
 * installed on the system; there should also be an entry for each
 * <code>javax.mail.Address</code> implementation that is present if it is to be
 * used. For example, the <code>javax.mail.internet.InternetAddress</code>
 * method <code>getType</code> returns "rfc822". Each referenced protocol should
 * be installed on the system. For the case of <code>news</code>, below, the
 * client should install a Transport provider supporting the nntp protocol.
 * <p>
 *
 * Here are the typical contents of a <code>javamail.address.map</code> file:
 * 
 * <pre>
 * rfc822=smtp
 * news=nntp
 * </pre>
 *
 * @author John Mani
 * @author Bill Shannon
 * @author Max Spivak
 */

public final class Session {
	/**
	 * Get a new Session object.
	 *
	 * @param props         Properties object that hold relevant properties.<br>
	 *                      It is expected that the client supplies values for the
	 *                      properties listed in Appendix A of the JavaMail spec
	 *                      (particularly mail.store.protocol,
	 *                      mail.transport.protocol, mail.host, mail.user, and
	 *                      mail.from) as the defaults are unlikely to work in all
	 *                      cases.
	 * @param authenticator Authenticator object used to call back to the
	 *                      application when a user name and password is needed.
	 * @return a new Session object
	 * @see javax.mail.Authenticator
	 */
	public static Session getInstance(Properties props, Authenticator authenticator) {
		return null;
	}

	/**
	 * Get a new Session object.
	 *
	 * @param props Properties object that hold relevant properties.<br>
	 *              It is expected that the client supplies values for the
	 *              properties listed in Appendix A of the JavaMail spec
	 *              (particularly mail.store.protocol, mail.transport.protocol,
	 *              mail.host, mail.user, and mail.from) as the defaults are
	 *              unlikely to work in all cases.
	 * @return a new Session object
	 * @since JavaMail 1.2
	 */
	public static Session getInstance(Properties props) {
		return null;
	}

	/**
	 * Get the default Session object. If a default has not yet been setup, a new
	 * Session object is created and installed as the default.
	 * <p>
	 *
	 * Since the default session is potentially available to all code executing in
	 * the same Java virtual machine, and the session can contain security sensitive
	 * information such as user names and passwords, access to the default session
	 * is restricted. The Authenticator object, which must be created by the caller,
	 * is used indirectly to check access permission. The Authenticator object
	 * passed in when the session is created is compared with the Authenticator
	 * object passed in to subsequent requests to get the default session. If both
	 * objects are the same, or are from the same ClassLoader, the request is
	 * allowed. Otherwise, it is denied.
	 * <p>
	 *
	 * Note that if the Authenticator object used to create the session is null,
	 * anyone can get the default session by passing in null.
	 * <p>
	 *
	 * Note also that the Properties object is used only the first time this method
	 * is called, when a new Session object is created. Subsequent calls return the
	 * Session object that was created by the first call, and ignore the passed
	 * Properties object. Use the <code>getInstance</code> method to get a new
	 * Session object every time the method is called.
	 * <p>
	 *
	 * Additional security Permission objects may be used to control access to the
	 * default session.
	 * <p>
	 *
	 * In the current implementation, if a SecurityManager is set, the caller must
	 * have the <code>RuntimePermission("setFactory")</code> permission.
	 *
	 * @param props         Properties object. Used only if a new Session object is
	 *                      created.<br>
	 *                      It is expected that the client supplies values for the
	 *                      properties listed in Appendix A of the JavaMail spec
	 *                      (particularly mail.store.protocol,
	 *                      mail.transport.protocol, mail.host, mail.user, and
	 *                      mail.from) as the defaults are unlikely to work in all
	 *                      cases.
	 * @param authenticator Authenticator object. Used only if a new Session object
	 *                      is created. Otherwise, it must match the Authenticator
	 *                      used to create the Session.
	 * @return the default Session object
	 */
	public static synchronized Session getDefaultInstance(Properties props, Authenticator authenticator) {
		return null;
	}

	/**
	 * Get the default Session object. If a default has not yet been setup, a new
	 * Session object is created and installed as the default.
	 * <p>
	 *
	 * Note that a default session created with no Authenticator is available to all
	 * code executing in the same Java virtual machine, and the session can contain
	 * security sensitive information such as user names and passwords.
	 *
	 * @param props Properties object. Used only if a new Session object is
	 *              created.<br>
	 *              It is expected that the client supplies values for the
	 *              properties listed in Appendix A of the JavaMail spec
	 *              (particularly mail.store.protocol, mail.transport.protocol,
	 *              mail.host, mail.user, and mail.from) as the defaults are
	 *              unlikely to work in all cases.
	 * @return the default Session object
	 * @since JavaMail 1.2
	 */
	public static Session getDefaultInstance(Properties props) {
		return null;
	}
}
