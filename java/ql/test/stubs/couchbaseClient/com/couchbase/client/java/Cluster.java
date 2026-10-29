package com.couchbase.client.java;

import com.couchbase.client.core.env.SeedNode;
import com.couchbase.client.java.analytics.AnalyticsOptions;
import com.couchbase.client.java.analytics.AnalyticsResult;
import com.couchbase.client.java.query.QueryMetaData;
import com.couchbase.client.java.query.QueryOptions;
import com.couchbase.client.java.query.QueryResult;
import com.couchbase.client.java.query.QueryRow;
import java.io.Closeable;
import java.util.Set;
import java.util.function.Consumer;

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

  public AnalyticsResult analyticsQuery(final String statement) {
    return null;
  }

  public AnalyticsResult analyticsQuery(final String statement, final AnalyticsOptions options) {
    return null;
  }

  public QueryResult query(final String statement) {
    return null;
  }

  public QueryResult query(final String statement, final QueryOptions options) {
    return null;
  }

  public QueryMetaData queryStreaming(String statement, Consumer<QueryRow> rowAction) {

    return null;
  }

  public QueryMetaData queryStreaming(
      String statement, QueryOptions options, Consumer<QueryRow> rowAction) {

    return null;
  }

  @Override
  public void close() {}
}