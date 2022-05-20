package main

//go:generate depstubber -vendor go.mongodb.org/mongo-driver/bson/primitive D
//go:generate depstubber -vendor go.mongodb.org/mongo-driver/mongo Collection,Pipeline
//go:generate depstubber -vendor  gopkg.in/couchbase/gocb.v1 Bucket,Cluster
//go:generate depstubber -vendor  github.com/couchbase/gocb/v2 Cluster,Scope

import (
	"context"

	gocbv2 "github.com/couchbase/gocb/v2"
	gocbv1 "gopkg.in/couchbase/gocb.v1"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
)

func test(coll *mongo.Collection, filter interface{}, models []mongo.WriteModel, ctx context.Context) {

	fieldName := "test"
	document := filter
	documents := []interface{}{
		document,
		bson.D{{"name", "Bob"}},
	}
	matchStage := bson.D{{"$match", filter}}
	pipeline := mongo.Pipeline{matchStage}

	coll.Aggregate(ctx, pipeline, nil) // $ nosqlquery=pipeline
	coll.BulkWrite(ctx, models, nil)
	coll.Clone(nil)
	coll.CountDocuments(ctx, filter, nil) // $ nosqlquery=filter
	coll.Database()
	coll.DeleteMany(ctx, filter, nil) // $ nosqlquery=filter
	coll.DeleteOne(ctx, filter, nil)  // $ nosqlquery=filter

	coll.Distinct(ctx, fieldName, filter) // $ nosqlquery=filter
	coll.Drop(ctx)
	coll.EstimatedDocumentCount(ctx, nil)
	coll.Find(ctx, filter, nil)              // $ nosqlquery=filter
	coll.FindOne(ctx, filter, nil)           // $ nosqlquery=filter
	coll.FindOneAndDelete(ctx, filter, nil)  // $ nosqlquery=filter
	coll.FindOneAndReplace(ctx, filter, nil) // $ nosqlquery=filter
	coll.FindOneAndUpdate(ctx, filter, nil)  // $ nosqlquery=filter
	coll.Indexes()
	coll.InsertMany(ctx, documents)
	coll.InsertOne(ctx, document, nil)
	coll.Name()
	replacement := bson.D{{"location", "NYC"}}
	coll.ReplaceOne(ctx, filter, replacement) // $ nosqlquery=filter
	update := bson.D{{"$inc", bson.D{{"age", 1}}}}
	coll.UpdateMany(ctx, filter, update) // $ nosqlquery=filter
	coll.UpdateOne(ctx, filter, update)  // $ nosqlquery=filter
	coll.Watch(ctx, pipeline)            // $ nosqlquery=pipeline
}

func testGocbV1(bucket gocbv1.Bucket, cluster gocbv1.Cluster, aq *gocbv1.AnalyticsQuery, nq *gocbv1.N1qlQuery) {
	bucket.ExecuteAnalyticsQuery(aq, nil)  // $ nosqlquery=aq
	cluster.ExecuteAnalyticsQuery(aq, nil) // $ nosqlquery=aq
	bucket.ExecuteN1qlQuery(nq, nil)       // $ nosqlquery=nq
	cluster.ExecuteN1qlQuery(nq, nil)      // $ nosqlquery=nq
}

func testGocbV2(cluster gocbv2.Cluster, scope gocbv2.Scope) {
	cluster.AnalyticsQuery("a", nil) // $ nosqlquery="a"
	scope.AnalyticsQuery("b", nil)   // $ nosqlquery="b"
	cluster.Query("c", nil)          // $ nosqlquery="c"
	scope.Query("d", nil)            // $ nosqlquery="d"
}

func main() {}
