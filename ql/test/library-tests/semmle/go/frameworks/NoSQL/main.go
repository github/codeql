package main

//go:generate depstubber -vendor go.mongodb.org/mongo-driver/bson/primitive D
//go:generate depstubber -vendor go.mongodb.org/mongo-driver/mongo Collection,Pipeline

import (
	"context"

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

	coll.Aggregate(ctx, pipeline, nil) // $nosqlquery=pipeline
	coll.BulkWrite(ctx, models, nil)
	coll.Clone(nil)
	coll.CountDocuments(ctx, filter, nil) // $nosqlquery=filter
	coll.Database()
	coll.DeleteMany(ctx, filter, nil) // $nosqlquery=filter
	coll.DeleteOne(ctx, filter, nil)  // $nosqlquery=filter

	coll.Distinct(ctx, fieldName, filter) // $nosqlquery=filter
	coll.Drop(ctx)
	coll.EstimatedDocumentCount(ctx, nil)
	coll.Find(ctx, filter, nil)              // $nosqlquery=filter
	coll.FindOne(ctx, filter, nil)           // $nosqlquery=filter
	coll.FindOneAndDelete(ctx, filter, nil)  // $nosqlquery=filter
	coll.FindOneAndReplace(ctx, filter, nil) // $nosqlquery=filter
	coll.FindOneAndUpdate(ctx, filter, nil)  // $nosqlquery=filter
	coll.Indexes()
	coll.InsertMany(ctx, documents)
	coll.InsertOne(ctx, document, nil)
	coll.Name()
	replacement := bson.D{{"location", "NYC"}}
	coll.ReplaceOne(ctx, filter, replacement) // $nosqlquery=filter
	update := bson.D{{"$inc", bson.D{{"age", 1}}}}
	coll.UpdateMany(ctx, filter, update) // $nosqlquery=filter
	coll.UpdateOne(ctx, filter, update)  // $nosqlquery=filter
	coll.Watch(ctx, pipeline)            // $nosqlquery=pipeline
}

func main() {}
