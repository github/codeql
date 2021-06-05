/*
 * Copyright 2012-2017 Brian Campbell
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

package org.jose4j.jws;

import org.jose4j.jwx.JsonWebStructure;
import org.jose4j.lang.JoseException;

/**
 * The JsonWebSignature class is used to produce and consume JSON Web Signature (JWS) as defined in
 * RFC 7515.
 */
public class JsonWebSignature extends JsonWebStructure
{
    public JsonWebSignature()
    {
    }

    /**
     * Sets the JWS payload as a string.
     * Use {@link #setPayloadCharEncoding(String)} before calling this method, to use a character
     * encoding other than UTF-8.
     * @param payload the payload, as a string, to be singed.
     */
    public void setPayload(String payload)
    {
    }

    /**
     * <p>
     * Sign and produce the JWS Compact Serialization.
     * </p>
     * <p>
     * The JWS Compact Serialization represents digitally signed or MACed
     * content as a compact, URL-safe string.  This string is:
     * <p>
     * BASE64URL(UTF8(JWS Protected Header)) || '.' ||
     * BASE64URL(JWS Payload) || '.' ||
     * BASE64URL(JWS Signature)
     * </p>
     * @return the Compact Serialization: the encoded header + "." + the encoded payload + "." + the encoded signature
     * @throws JoseException
     */
    public String getCompactSerialization() throws JoseException
    {
        return null;
    }    
}
