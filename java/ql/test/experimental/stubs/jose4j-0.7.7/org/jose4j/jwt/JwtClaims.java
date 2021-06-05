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

package org.jose4j.jwt;

import java.util.*;

/**
 *
 */
public class JwtClaims
{
    public JwtClaims()
    {
    }

    public String getIssuer() throws MalformedClaimException
    {
        return null;
    }

    public void setIssuer(String issuer)
    {
    }

    public String getSubject()  throws MalformedClaimException
    {
        return null;
    }

    public void setSubject(String subject)
    {
    }

    public void setAudience(String audience)
    {
    }

    public void setAudience(String... audience)
    {
    }

    public void setAudience(List<String> audiences)
    {
    }

    public void setExpirationTimeMinutesInTheFuture(float minutes)
    {
    }

    public void setNotBeforeMinutesInThePast(float minutes)
    {
    }

    public void setIssuedAtToNow()
    {
    }

    public String getJwtId() throws MalformedClaimException
    {
        return null;
    }

    public void setJwtId(String jwtId)
    {
    }

    public void setGeneratedJwtId(int numberOfBytes)
    {
    }

    public void setGeneratedJwtId()
    {
    }

    public void unsetClaim(String claimName)
    {
    }

    public Object getClaimValue(String claimName)
    {
        return null;
    }

    public String getStringClaimValue(String claimName) throws MalformedClaimException
    {
        return null;
    }

    public String toJson()
    {
        return null;
    }

    public String getRawJson()
    {
        return null;
    }
}
