/*
 * Copyright (C) 2019 jsonwebtoken.io
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

import java.security.Key;
import java.util.Date;
import java.util.Map;

/**
 * A builder to construct a {@link JwtParser}. Example usage:
 * <pre>{@code
 *     Jwts.parserBuilder()
 *         .setSigningKey(...)
 *         .requireIssuer("https://issuer.example.com")
 *         .build()
 *         .parse(jwtString)
 * }</pre>
 * @since 0.11.0
 */
public interface JwtParserBuilder {


    /**
     * Sets the signing key used to verify any discovered JWS digital signature.  If the specified JWT string is not
     * a JWS (no signature), this key is not used.
     * <p>
     * <p>Note that this key <em>MUST</em> be a valid key for the signature algorithm found in the JWT header
     * (as the {@code alg} header parameter).</p>
     * <p>
     * <p>This method overwrites any previously set key.</p>
     *
     * @param key the algorithm-specific signature verification key used to validate any discovered JWS digital
     *            signature.
     * @return the parser builder for method chaining.
     */
    JwtParserBuilder setSigningKey(byte[] key);

    /**
     * Sets the signing key used to verify any discovered JWS digital signature.  If the specified JWT string is not
     * a JWS (no signature), this key is not used.
     *
     * <p>Note that this key <em>MUST</em> be a valid key for the signature algorithm found in the JWT header
     * (as the {@code alg} header parameter).</p>
     *
     * <p>This method overwrites any previously set key.</p>
     *
     * <p>This is a convenience method: the string argument is first BASE64-decoded to a byte array and this resulting
     * byte array is used to invoke {@link #setSigningKey(byte[])}.</p>
     *
     * <h4>Deprecation Notice: Deprecated as of 0.10.0, will be removed in 1.0.0</h4>
     *
     * <p>This method has been deprecated because the {@code key} argument for this method can be confusing: keys for
     * cryptographic operations are always binary (byte arrays), and many people were confused as to how bytes were
     * obtained from the String argument.</p>
     *
     * <p>This method always expected a String argument that was effectively the same as the result of the following
     * (pseudocode):</p>
     *
     * <p>{@code String base64EncodedSecretKey = base64Encode(secretKeyBytes);}</p>
     *
     * <p>However, a non-trivial number of JJWT users were confused by the method signature and attempted to
     * use raw password strings as the key argument - for example {@code setSigningKey(myPassword)} - which is
     * almost always incorrect for cryptographic hashes and can produce erroneous or insecure results.</p>
     *
     * <p>See this
     * <a href="https://stackoverflow.com/questions/40252903/static-secret-as-byte-key-or-string/40274325#40274325">
     * StackOverflow answer</a> explaining why raw (non-base64-encoded) strings are almost always incorrect for
     * signature operations.</p>
     *
     * <p>Finally, please use the {@link #setSigningKey(Key) setSigningKey(Key)} instead, as this method and the
     * {@code byte[]} variant will be removed before the 1.0.0 release.</p>
     *
     * @param base64EncodedSecretKey the BASE64-encoded algorithm-specific signature verification key to use to validate
     *                               any discovered JWS digital signature.
     * @return the parser builder for method chaining.
     */
    JwtParserBuilder setSigningKey(String base64EncodedSecretKey);

    /**
     * Sets the signing key used to verify any discovered JWS digital signature.  If the specified JWT string is not
     * a JWS (no signature), this key is not used.
     * <p>
     * <p>Note that this key <em>MUST</em> be a valid key for the signature algorithm found in the JWT header
     * (as the {@code alg} header parameter).</p>
     * <p>
     * <p>This method overwrites any previously set key.</p>
     *
     * @param key the algorithm-specific signature verification key to use to validate any discovered JWS digital
     *            signature.
     * @return the parser builder for method chaining.
     */
    JwtParserBuilder setSigningKey(Key key);

    /**
     * Sets the {@link SigningKeyResolver} used to acquire the <code>signing key</code> that should be used to verify
     * a JWS's signature.  If the parsed String is not a JWS (no signature), this resolver is not used.
     * <p>
     * <p>Specifying a {@code SigningKeyResolver} is necessary when the signing key is not already known before parsing
     * the JWT and the JWT header or payload (plaintext body or Claims) must be inspected first to determine how to
     * look up the signing key.  Once returned by the resolver, the JwtParser will then verify the JWS signature with the
     * returned key.  For example:</p>
     * <p>
     * <pre>
     * Jws&lt;Claims&gt; jws = Jwts.parser().setSigningKeyResolver(new SigningKeyResolverAdapter() {
     *         &#64;Override
     *         public byte[] resolveSigningKeyBytes(JwsHeader header, Claims claims) {
     *             //inspect the header or claims, lookup and return the signing key
     *             return getSigningKey(header, claims); //implement me
     *         }})
     *     .parseClaimsJws(compact);
     * </pre>
     * <p>
     * <p>A {@code SigningKeyResolver} is invoked once during parsing before the signature is verified.</p>
     * <p>
     * <p>This method should only be used if a signing key is not provided by the other {@code setSigningKey*} builder
     * methods.</p>
     *
     * @param signingKeyResolver the signing key resolver used to retrieve the signing key.
     * @return the parser builder for method chaining.
     */
    JwtParserBuilder setSigningKeyResolver(SigningKeyResolver signingKeyResolver);

    /**
     * Returns an immutable/thread-safe {@link JwtParser} created from the configuration from this JwtParserBuilder.
     * @return an immutable/thread-safe JwtParser created from the configuration from this JwtParserBuilder.
     */
    JwtParser build();
}
