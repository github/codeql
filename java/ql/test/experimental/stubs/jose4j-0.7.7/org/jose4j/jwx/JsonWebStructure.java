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

package org.jose4j.jwx;

import org.jose4j.lang.JoseException;

import java.security.Key;

/**
 */
public abstract class JsonWebStructure
{
    public static JsonWebStructure fromCompactSerialization(String cs) throws JoseException
    {
        return null;
    }

    public void setCompactSerialization(String compactSerialization) throws JoseException
    {
    }

    /**
     * @deprecated replaced by {@link #getHeaders()} and {@link org.jose4j.jwx.Headers#getFullHeaderAsJsonString()}
     */
    public String getHeader()
    {
        return null;
    }

    protected String getEncodedHeader()
    {
        return null;
    }

    public void setHeader(String name, String value)
    {
    }

    public String getHeader(String name)
    {
        return null;
    }

    public void setHeader(String name, Object value)
    {
    }

    public Object getObjectHeader(String name)
    {
        return null;
    }

    public void setAlgorithmHeaderValue(String alg)
    {
    }

    public String getAlgorithmHeaderValue()
    {
        return null;
    }

    public void setContentTypeHeaderValue(String cty)
    {
    }

    public String getContentTypeHeaderValue()
    {
        return null;
    }

    public void setKeyIdHeaderValue(String kid)
    {
    }

    public String getKeyIdHeaderValue()
    {
        return null;
    }

    public Key getKey()
    {
        return null;
    }

    public void setKey(Key key)
    {
    }

    public boolean isDoKeyValidation()
    {
        return false;
    }

    public void setDoKeyValidation(boolean doKeyValidation)
    {
    }

    /**
     * Sets the value(s) of the critical ("crit") header, defined in
     * <a href="http://tools.ietf.org/html/rfc7515#section-4.1.11">section 4.1.11 of RFC 7515</a>,
     * which indicates that those headers MUST be understood and processed by the recipient.
     * @param headerNames the name(s) of headers that will be marked as critical
     */
    public void setCriticalHeaderNames(String... headerNames)
    {
    }

    /**
     * Sets the values of the critical ("crit") header that are acceptable for the library to process.
     * Basically calling this  is telling the jose4j library to allow these headers marked as critical
     * and saying that the caller knows how to process them and will do so.
     * @param knownCriticalHeaders one or more header names that will be allowed as values of the critical header
     */
    public void setKnownCriticalHeaders(String... knownCriticalHeaders)
    {
    }
}

