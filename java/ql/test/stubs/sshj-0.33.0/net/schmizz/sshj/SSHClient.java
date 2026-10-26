/*
 * Copyright (C)2009 - SSHJ Contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package net.schmizz.sshj;

import net.schmizz.sshj.connection.channel.direct.SessionFactory;
import net.schmizz.sshj.userauth.UserAuthException;
import net.schmizz.sshj.transport.TransportException;

import java.io.Closeable;

public class SSHClient
        extends SocketClient
        implements Closeable, SessionFactory {

    public void authPassword(String username, String password)
            throws UserAuthException, TransportException {

    }

    public void authPassword(final String username, final char[] password)
            throws UserAuthException, TransportException {

    }

    public void close() { }

}
