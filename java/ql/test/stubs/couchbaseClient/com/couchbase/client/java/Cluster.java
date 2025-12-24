/*
 * Copyright (c) 2016 Couchbase, Inc.
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

import com.couchbase.client.core.env.SeedNode;
import com.couchbase.client.java.query.QueryResult;
import java.io.Closeable;
import java.util.Set;

public class Cluster implements Closeable {

  public Bucket bucket(String bucketName) {
    return null;
  }

  public static Cluster connect(
      final String connectionString, final String username, final String password) {
    return null;
  }

  public static Cluster connect(final String connectionString, final ClusterOptions options) {
    return null;
  }

  public static Cluster connect(final Set<SeedNode> seedNodes, final ClusterOptions options) {
    return null;
  }

  public QueryResult query(final String statement) {
    return null;
  }

  @Override
  public void close() {}
}