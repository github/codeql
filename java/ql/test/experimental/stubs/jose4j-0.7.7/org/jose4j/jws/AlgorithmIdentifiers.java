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

/**
 */
public class AlgorithmIdentifiers
{
    public static final String NONE = "none";

    public static final String HMAC_SHA256 = "HS256";
    public static final String HMAC_SHA384 = "HS384";
    public static final String HMAC_SHA512 = "HS512";

    public static final String RSA_USING_SHA256 = "RS256";
    public static final String RSA_USING_SHA384 = "RS384";
    public static final String RSA_USING_SHA512 = "RS512";

    public static final String ECDSA_USING_P256_CURVE_AND_SHA256 = "ES256";
    public static final String ECDSA_USING_P384_CURVE_AND_SHA384 = "ES384";
    public static final String ECDSA_USING_P521_CURVE_AND_SHA512 = "ES512";

    public static final String RSA_PSS_USING_SHA256 = "PS256";
    public static final String RSA_PSS_USING_SHA384 = "PS384";
    public static final String RSA_PSS_USING_SHA512 = "PS512";

}