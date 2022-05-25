package main

//go:generate depstubber -vendor go.mongodb.org/mongo-driver/bson/primitive D
//go:generate depstubber -vendor go.mongodb.org/mongo-driver/mongo Pipeline Connect
//go:generate depstubber -vendor go.mongodb.org/mongo-driver/mongo/options "" Client

import (
	"context"
	"fmt"
	"log"
	"net/http"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

func mongo2(w http.ResponseWriter, r *http.Request) {

	// Set client options
	clientOptions := options.Client().ApplyURI("mongodb://test:test@localhost:27017")

	// Connect to MongoDB
	client, err := mongo.Connect(context.TODO(), clientOptions)
	if err != nil {
		log.Fatal(err)
	}

	// Check the connection
	err = client.Ping(context.TODO(), nil)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("Connected to MongoDB!")

	// Get a handle for your collection
	db := client.Database("test")
	coll := db.Collection("collection")
	untrustedInput := r.Referer()

	filter := bson.D{{"name", untrustedInput}}

	fieldName := "test"
	document := filter
	documents := []interface{}{
		document,
		bson.D{{"name", "Bob"}},
	}
	matchStage := bson.D{{"$match", filter}}
	pipeline := mongo.Pipeline{matchStage}
	ctx := context.TODO()
	replacement := bson.D{{"location", "NYC"}}
	update := bson.D{{"$inc", bson.D{{"age", 1}}}}
	// models := nil

	coll.Aggregate(ctx, pipeline, nil)
	// coll.BulkWrite(ctx, models, nil)
	coll.BulkWrite(ctx, nil, nil)
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
	coll.ReplaceOne(ctx, filter, replacement)
	coll.UpdateMany(ctx, filter, update)
	coll.UpdateOne(ctx, filter, update)
	coll.Watch(ctx, pipeline)

}
