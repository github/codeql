/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.commons.mail;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

/**
 * This is a very simple authentication object that can be used for any
 * transport needing basic userName and password type authentication.
 *
 * @since 1.0
 */
public class DefaultAuthenticator extends Authenticator
{
    /** Stores the login information for authentication. */
    private final PasswordAuthentication authentication;

    /**
     * Default constructor.
     *
     * @param userName user name to use when authentication is requested
     * @param password password to use when authentication is requested
     * @since 1.0
     */
    public DefaultAuthenticator(final String userName, final String password)
    {
        this.authentication = new PasswordAuthentication(userName, password);
    }

    /**
     * Gets the authentication object that will be used to login to the mail
     * server.
     *
     * @return A {@code PasswordAuthentication} object containing the
     *         login information.
     * @since 1.0
     */
    @Override
    protected PasswordAuthentication getPasswordAuthentication()
    {
        return this.authentication;
    }
}
