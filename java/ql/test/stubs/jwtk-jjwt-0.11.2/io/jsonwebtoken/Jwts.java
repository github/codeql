/*
 * Copyright (C) 2014 jsonwebtoken.io
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
package io.jsonwebtoken;

import java.util.Map;

/**
 * Factory class useful for creating instances of JWT interfaces.  Using this factory class can be a good
 * alternative to tightly coupling your code to implementation classes.
 *
 * @since 0.1
 */
public final class Jwts {

    private Jwts() {
    }


    /**
     * Returns a new {@link JwtParser} instance that can be configured and then used to parse JWT strings.
     *
     * @return a new {@link JwtParser} instance that can be configured and then used to parse JWT strings.
     * @deprecated use {@link Jwts#parserBuilder()} instead. See {@link JwtParserBuilder} for usage details.
     * <p>Migration to new method structure is minimal, for example:
     * <p>Old code:
     * <pre>{@code
     *     Jwts.parser()
     *         .requireAudience("string")
     *         .parse(jwtString)
     * }</pre>
     * <p>New code:
     * <pre>{@code
     *     Jwts.parserBuilder()
     *         .requireAudience("string")
     *         .build()
     *         .parse(jwtString)
     * }</pre>
     * <p><b>NOTE: this method will be removed before version 1.0</b>
     */
    @Deprecated
    public static JwtParser parser() {
        return null;
    }

    /**
     * Returns a new {@link JwtParserBuilder} instance that can be configured to create an immutable/thread-safe {@link JwtParser).
     *
     * @return a new {@link JwtParser} instance that can be configured create an immutable/thread-safe {@link JwtParser).
     */
    public static JwtParserBuilder parserBuilder() {
        return null;
    }
}
