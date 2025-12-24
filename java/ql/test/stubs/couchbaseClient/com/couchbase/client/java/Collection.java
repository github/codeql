/*
 * Copyright (c) 2018 Couchbase, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.couchbase.client.java;

import com.couchbase.client.java.kv.InsertOptions;
import com.couchbase.client.java.kv.MutationResult;
import com.couchbase.client.java.kv.ReplaceOptions;
import com.couchbase.client.java.kv.UpsertOptions;

public class Collection {

  public MutationResult insert(final String id, final Object content) {
    return null;
  }

  public MutationResult insert(final String id, final Object content, final InsertOptions options) {
    return null;
  }

  public MutationResult upsert(final String id, final Object content) {
    return null;
  }

  public MutationResult upsert(final String id, final Object content, final UpsertOptions options) {
    return null;
  }

  public MutationResult replace(final String id, final Object content) {
    return null;
  }

  public MutationResult replace(
      final String id, final Object content, final ReplaceOptions options) {
    return null;
  }
}