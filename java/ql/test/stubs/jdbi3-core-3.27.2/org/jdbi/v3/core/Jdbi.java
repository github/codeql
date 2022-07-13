/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.jdbi.v3.core;

import org.jdbi.v3.core.config.Configurable;
import java.util.Properties;

public class Jdbi implements Configurable<Jdbi> {

    public static Jdbi create(final String url) {
        return null;
    }

    /**
     * Creates a new {@link Jdbi} instance from a database URL.
     *
     * @param url   JDBC URL for connections
     * @param properties Properties to pass to DriverManager.getConnection(url, props) for each new handle
     *
     * @return a Jdbi which uses {@link DriverManager} as a connection factory.
     */
    public static Jdbi create(final String url, final Properties properties) {
        return null;
    }

    /**
     * Creates a new {@link Jdbi} instance from a database URL.
     *
     * @param url      JDBC URL for connections
     * @param username User name for connection authentication
     * @param password Password for connection authentication
     *
     * @return a Jdbi which uses {@link DriverManager} as a connection factory.
     */
    public static Jdbi create(final String url, final String username, final String password) {
        return null;
    }

    public static Handle open(final String url) {
        return null;
    }

    /**
     * Obtain a handle with just a JDBC URL
     *
     * @param url      JDBC Url
     * @param username JDBC username for authentication
     * @param password JDBC password for authentication
     *
     * @return newly opened Handle
     */
    public static Handle open(final String url, final String username, final String password) {
        return null;
    }

    /**
     * Obtain a handle with just a JDBC URL
     *
     * @param url   JDBC Url
     * @param props JDBC properties
     *
     * @return newly opened Handle
     */
    public static Handle open(final String url, final Properties props) {
        return null;
    }
}