
/*
 * Copyright (C) 2019 jsonwebtoken.io
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
package io.jsonwebtoken.impl;

import java.security.Key;
import io.jsonwebtoken.JwtParser;
import io.jsonwebtoken.JwtParserBuilder;
import io.jsonwebtoken.SigningKeyResolver;


public class DefaultJwtParserBuilder implements JwtParserBuilder {

    @Override
    public JwtParserBuilder setSigningKey(byte[] key) {
        return this;
    }

    @Override
    public JwtParserBuilder setSigningKey(String base64EncodedSecretKey) {
        return this;
    }

    @Override
    public JwtParserBuilder setSigningKey(Key key) {
        return this;
    }

    @Override
    public JwtParserBuilder setSigningKeyResolver(SigningKeyResolver signingKeyResolver) {
        return this;
    }

    @Override
    public JwtParser build() {
        return null;
    }
}
