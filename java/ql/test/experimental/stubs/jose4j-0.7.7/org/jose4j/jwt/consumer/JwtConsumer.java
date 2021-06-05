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

package org.jose4j.jwt.consumer;

import org.jose4j.jwt.JwtClaims;

import java.security.Key;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;

/**
 *
 */
public class JwtConsumer
{
    JwtConsumer()
    {
    }

    void setRequireSignature(boolean requireSignature)
    {
    }

    void setRequireEncryption(boolean requireEncryption)
    {
    }

    void setRequireIntegrity(boolean requireIntegrity)
    {
    }

    void setSkipSignatureVerification(boolean skipSignatureVerification)
    {
    }

    void setRelaxVerificationKeyValidation(boolean relaxVerificationKeyValidation)
    {
    }

    public void setSkipVerificationKeyResolutionOnNone(boolean skipVerificationKeyResolutionOnNone)
    {
    }

    void setRelaxDecryptionKeyValidation(boolean relaxDecryptionKeyValidation)
    {
    }

    public JwtClaims processToClaims(String jwt) throws InvalidJwtException
    {
        return null;
    }
}
