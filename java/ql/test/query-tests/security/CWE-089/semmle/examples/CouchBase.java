package com.example;

import com.couchbase.client.java.Bucket;
import com.couchbase.client.java.Cluster;

public class CouchBase {
  public static void main(String[] args) { // $ Source[java/sql-injection]
    Cluster cluster = Cluster.connect("192.168.0.158", "Administrator", "Administrator");
    Bucket bucket = cluster.bucket("travel-sample");
    cluster.analyticsQuery(args[1]); // $ Alert[java/sql-injection]
    cluster.analyticsQuery(args[1], null); // $ Alert[java/sql-injection]
    cluster.query(args[1]); // $ Alert[java/sql-injection]
    cluster.query(args[1], null); // $ Alert[java/sql-injection]
    cluster.queryStreaming(args[1], null); // $ Alert[java/sql-injection]
    cluster.queryStreaming(args[1], null, null); // $ Alert[java/sql-injection]
  }
}
