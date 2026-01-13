package com.example;

import com.couchbase.client.java.Bucket;
import com.couchbase.client.java.Cluster;

public class CouchBase {
  public static void main(String[] args) {
    Cluster cluster = Cluster.connect("192.168.0.158", "Administrator", "Administrator");
    Bucket bucket = cluster.bucket("travel-sample");
    cluster.analyticsQuery(args[1]);
    cluster.analyticsQuery(args[1], null);
    cluster.query(args[1]);
    cluster.query(args[1], null);
    cluster.queryStreaming(args[1], null);
    cluster.queryStreaming(args[1], null, null);
  }
}
