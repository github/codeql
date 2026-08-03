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
	untrustedInput := r.Referer() // $ Source[go/sql-injection]

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

	coll.Aggregate(ctx, pipeline, nil) // $ Alert[go/sql-injection]
	// coll.BulkWrite(ctx, models, nil)
	coll.BulkWrite(ctx, nil, nil)
	coll.Clone(nil)
	coll.CountDocuments(ctx, filter, nil) // $ Alert[go/sql-injection]
	coll.Database()
	coll.DeleteMany(ctx, filter, nil) // $ Alert[go/sql-injection]
	coll.DeleteOne(ctx, filter, nil)  // $ Alert[go/sql-injection]

	coll.Distinct(ctx, fieldName, filter) // $ Alert[go/sql-injection]
	coll.Drop(ctx)
	coll.EstimatedDocumentCount(ctx, nil)
	coll.Find(ctx, filter, nil)              // $ Alert[go/sql-injection]
	coll.FindOne(ctx, filter, nil)           // $ Alert[go/sql-injection]
	coll.FindOneAndDelete(ctx, filter, nil)  // $ Alert[go/sql-injection]
	coll.FindOneAndReplace(ctx, filter, nil) // $ Alert[go/sql-injection]
	coll.FindOneAndUpdate(ctx, filter, nil)  // $ Alert[go/sql-injection]
	coll.Indexes()
	coll.InsertMany(ctx, documents)
	coll.InsertOne(ctx, document, nil)
	coll.Name()
	coll.ReplaceOne(ctx, filter, replacement) // $ Alert[go/sql-injection]
	coll.UpdateMany(ctx, filter, update)      // $ Alert[go/sql-injection]
	coll.UpdateOne(ctx, filter, update)       // $ Alert[go/sql-injection]
	coll.Watch(ctx, pipeline)                 // $ Alert[go/sql-injection]

}
