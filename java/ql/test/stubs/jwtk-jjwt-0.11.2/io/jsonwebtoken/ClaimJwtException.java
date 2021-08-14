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

/**
 * ClaimJwtException is a subclass of the {@link JwtException} that is thrown after a validation of an JTW claim failed.
 *
 * @since 0.5
 */
public abstract class ClaimJwtException extends JwtException {

    protected ClaimJwtException(Header header, Claims claims, String message) {
        super(message);
    }

    protected ClaimJwtException(Header header, Claims claims, String message, Throwable cause) {
        super(message, cause);
    }

    public Claims getClaims() {
        return null;
    }

    public Header getHeader() {
        return null;
    }
}
