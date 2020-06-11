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

	coll.Aggregate(ctx, pipeline, nil)
	coll.BulkWrite(ctx, models, nil)
	coll.Clone(nil)
	coll.CountDocuments(ctx, filter, nil)
	coll.Database()
	coll.DeleteMany(ctx, filter, nil)
	coll.DeleteOne(ctx, filter, nil)

	coll.Distinct(ctx, fieldName, filter)
	coll.Drop(ctx)
	coll.EstimatedDocumentCount(ctx, nil)
	coll.Find(ctx, filter, nil)
	coll.FindOne(ctx, filter, nil)
	coll.FindOneAndDelete(ctx, filter, nil)
	coll.FindOneAndReplace(ctx, filter, nil)
	coll.FindOneAndUpdate(ctx, filter, nil)
	coll.Indexes()
	coll.InsertMany(ctx, documents)
	coll.InsertOne(ctx, document, nil)
	coll.Name()
	replacement := bson.D{{"location", "NYC"}}
	coll.ReplaceOne(ctx, filter, replacement)
	update := bson.D{{"$inc", bson.D{{"age", 1}}}}
	coll.UpdateMany(ctx, filter, update)
	coll.UpdateOne(ctx, filter, update)
	coll.Watch(ctx, pipeline)
}

func main() {}
