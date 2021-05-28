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

import java.util.Date;
import java.util.Map;

/**
 * A JWT <a href="https://tools.ietf.org/html/draft-ietf-oauth-json-web-token-25#section-4">Claims set</a>.
 *
 * <p>This is ultimately a JSON map and any values can be added to it, but JWT standard names are provided as
 * type-safe getters and setters for convenience.</p>
 *
 * <p>Because this interface extends {@code Map&lt;String, Object&gt;}, if you would like to add your own properties,
 * you simply use map methods, for example:</p>
 *
 * <pre>
 * claims.{@link Map#put(Object, Object) put}("someKey", "someValue");
 * </pre>
 *
 * <h3>Creation</h3>
 *
 * <p>It is easiest to create a {@code Claims} instance by calling one of the
 * {@link Jwts#claims() JWTs.claims()} factory methods.</p>
 *
 * @since 0.1
 */
public interface Claims extends Map<String, Object>, ClaimsMutator<Claims> {

}
