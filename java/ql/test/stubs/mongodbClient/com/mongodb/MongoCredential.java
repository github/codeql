/*
 * Copyright 2008-present MongoDB, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.mongodb;

import com.mongodb.annotations.Immutable;
import com.mongodb.lang.Nullable;

@Immutable
public final class MongoCredential {

    public static MongoCredential createCredential(final String userName, final String database, final char[] password) {
        return null;
    }

    public static MongoCredential createScramSha1Credential(final String userName, final String source, final char[] password) {
        return null;
    }

    public static MongoCredential createScramSha256Credential(final String userName, final String source, final char[] password) {
        return null;
    }

    public static MongoCredential createMongoX509Credential(final String userName) {
        return null;
    }

    public static MongoCredential createPlainCredential(final String userName, final String source, final char[] password) {
        return null;
    }

    public static MongoCredential createGSSAPICredential(final String userName) {
        return null;
    }

    public static MongoCredential createAwsCredential(@Nullable final String userName, @Nullable final char[] password) {
        return null;
    }

    public static MongoCredential createMongoCRCredential(String userName, String database, char[] password) {
        // Deprecated function removed in most recent releases of the Mongo driver.
        return null;
    }

}
