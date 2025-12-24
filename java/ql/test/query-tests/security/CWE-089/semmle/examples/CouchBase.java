package com.example;

import com.couchbase.client.java.Bucket;
import com.couchbase.client.java.Cluster;
import com.couchbase.client.java.Collection;
import com.couchbase.client.java.json.JsonObject;

public class CouchBase {
  public static void main(String[] args) {
    Cluster cluster = Cluster.connect("192.168.0.158", "Administrator", "Administrator");
    Bucket bucket = cluster.bucket("travel-sample");
    cluster.query(args[1]);

    Collection collection = bucket.defaultCollection();
    collection.replace("airbnb_1", JsonObject.create().putNull(System.getenv("ITEM_CATEGORY")));
    collection.upsert("airbnb_1", JsonObject.create().put("country", args[1]));
  }
}
