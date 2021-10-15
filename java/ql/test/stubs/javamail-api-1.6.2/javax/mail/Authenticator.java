/*
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS HEADER.
 *
 * Copyright (c) 1997-2017 Oracle and/or its affiliates. All rights reserved.
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

import java.net.InetAddress;

/**
 * The class Authenticator represents an object that knows how to obtain
 * authentication for a network connection. Usually, it will do this by
 * prompting the user for information.
 * <p>
 * Applications use this class by creating a subclass, and registering an
 * instance of that subclass with the session when it is created. When
 * authentication is required, the system will invoke a method on the subclass
 * (like getPasswordAuthentication). The subclass's method can query about the
 * authentication being requested with a number of inherited methods
 * (getRequestingXXX()), and form an appropriate message for the user.
 * <p>
 * All methods that request authentication have a default implementation that
 * fails.
 *
 * @see java.net.Authenticator
 * @see javax.mail.Session#getInstance(java.util.Properties,
 *      javax.mail.Authenticator)
 * @see javax.mail.Session#getDefaultInstance(java.util.Properties,
 *      javax.mail.Authenticator)
 * @see javax.mail.Session#requestPasswordAuthentication
 * @see javax.mail.PasswordAuthentication
 *
 * @author Bill Foote
 * @author Bill Shannon
 */

// There are no abstract methods, but to be useful the user must
// subclass.
public abstract class Authenticator {

    /**
     * Ask the authenticator for a password.
     * <p>
     *
     * @param addr     The InetAddress of the site requesting authorization, or null
     *                 if not known.
     * @param port     the port for the requested connection
     * @param protocol The protocol that's requesting the connection (@see
     *                 java.net.Authenticator.getProtocol())
     * @param prompt   A prompt string for the user
     *
     * @return The username/password, or null if one can't be gotten.
     */
    final synchronized PasswordAuthentication requestPasswordAuthentication(InetAddress addr, int port, String protocol,
            String prompt, String defaultUserName) {
        return null;
    }

    /**
     * @return the InetAddress of the site requesting authorization, or null if it's
     *         not available.
     */
    protected final InetAddress getRequestingSite() {
        return null;
    }

    /**
     * @return the port for the requested connection
     */
    protected final int getRequestingPort() {
        return -1;
    }

    /**
     * Give the protocol that's requesting the connection. Often this will be based
     * on a URLName.
     *
     * @return the protcol
     *
     * @see javax.mail.URLName#getProtocol
     */
    protected final String getRequestingProtocol() {
        return null;
    }

    /**
     * @return the prompt string given by the requestor
     */
    protected final String getRequestingPrompt() {
        return null;
    }

    /**
     * @return the default user name given by the requestor
     */
    protected final String getDefaultUserName() {
        return null;
    }

    /**
     * Called when password authentication is needed. Subclasses should override the
     * default implementation, which returns null.
     * <p>
     *
     * Note that if this method uses a dialog to prompt the user for this
     * information, the dialog needs to block until the user supplies the
     * information. This method can not simply return after showing the dialog.
     * 
     * @return The PasswordAuthentication collected from the user, or null if none
     *         is provided.
     */
    protected PasswordAuthentication getPasswordAuthentication() {
        return null;
    }
}
