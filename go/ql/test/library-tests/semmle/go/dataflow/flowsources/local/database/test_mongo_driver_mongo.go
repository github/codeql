package test

//go:generate depstubber -vendor go.mongodb.org/mongo-driver/mongo Client,Collection,Database

import (
	"context"

	"go.mongodb.org/mongo-driver/mongo"
)

func test_mongo_driver_mongo_collection(coll *mongo.Collection, ctx context.Context, pipeline any) {
	cursor, err := coll.Aggregate(ctx, pipeline) // $ source
	if err != nil {
		return
	}

	var users []User

	err = cursor.All(ctx, &users)

	sink(users) // $ hasTaintFlow="users"

	distinct, err := coll.Distinct(ctx, "name", nil) // $ source
	if err != nil {
		return
	}

	sink(distinct) // $ hasTaintFlow="distinct"

	cursor2, err := coll.Find(ctx, nil) // $ source
	if err != nil {
		return
	}

	sink(cursor2) // $ hasTaintFlow="cursor2"

	var user1, user2, user3, user4 User

	single1 := coll.FindOne(ctx, nil) // $ source
	if err != nil {
		return
	}

	single1.Decode(&user1)

	sink(user1) // $ hasTaintFlow="user1"

	single2 := coll.FindOneAndDelete(ctx, nil) // $ source
	if err != nil {
		return
	}

	single2.Decode(&user2)

	sink(user2) // $ hasTaintFlow="user2"

	single3 := coll.FindOneAndReplace(ctx, nil, nil) // $ source
	if err != nil {
		return
	}

	single3.Decode(&user3)

	sink(user3) // $ hasTaintFlow="user3"

	single4 := coll.FindOneAndUpdate(ctx, nil, nil) // $ source
	if err != nil {
		return
	}

	single4.Decode(&user4)

	sink(user4) // $ hasTaintFlow="user4"

	changeStream, err := coll.Watch(ctx, pipeline) // $ source
	if err != nil {
		return
	}

	for changeStream.Next(ctx) {
		var userCs User
		changeStream.Decode(&userCs)
		sink(userCs) // $ hasTaintFlow="userCs"
	}
}

func test_mongo_driver_mongo_database(db *mongo.Database, ctx context.Context, pipeline any) {
	agg, err := db.Aggregate(ctx, pipeline) // $ source

	if err != nil {
		return
	}

	var user User
	agg.Decode(&user)
	sink(user) // $ hasTaintFlow="user"

	changeStream, err := db.Watch(ctx, pipeline) // $ source
	if err != nil {
		return
	}

	for changeStream.Next(ctx) {
		var userCs User
		changeStream.Decode(&userCs)
		sink(userCs) // $ hasTaintFlow="userCs"
	}
}

func test_mongo_driver_mongo_Client(client *mongo.Client, ctx context.Context) {
	changestream, err := client.Watch(ctx, nil) // $ source
	if err != nil {
		return
	}

	for changestream.Next(ctx) {
		var user User
		changestream.Decode(&user)
		sink(user) // $ hasTaintFlow="user"
	}
}
