package test

//go:generate depstubber -vendor github.com/couchbase/gocb/v2 AnalyticsResult,AnalyticsResultRaw,Cluster,Collection,ExistsResult,GetResult,LookupInReplicaResult,LookupInResult,MutateInResult,MutationResult,QueryResult,QueryResultRaw,Result,ScanResult,ScanResultItem,Scope,SearchResult,SearchResultRaw,TransactionAttemptContext,TransactionGetResult,TransactionQueryResult,ViewIndexManager,ViewResult,ViewResultRaw

import "github.com/couchbase/gocb/v2"

func test_couchbase_gocb_v2_Cluster(cluster *gocb.Cluster) {
	r1, err := cluster.AnalyticsQuery("SELECT * FROM `travel-sample`", nil) // $ source

	if err != nil {
		return
	}

	for r1.Next() {
		var name1, name2 string

		r1.One(&name1)

		sink(name1) // $ hasTaintFlow="name1"

		r1.Row(&name2)
		sink(name2) // $ hasTaintFlow="name2"

		b := r1.Raw().NextBytes()
		sink(b) // $ hasTaintFlow="b"
	}

	r2, err := cluster.Query("SELECT * FROM `travel-sample`", nil) // $ source

	if err != nil {
		return
	}

	for r2.Next() {
		var name1, name2 string

		r2.One(&name1)

		sink(name1) // $ hasTaintFlow="name1"

		r2.Row(&name2)
		sink(name2) // $ hasTaintFlow="name2"

		b := r2.Raw().NextBytes()
		sink(b) // $ hasTaintFlow="b"
	}
}

func test_couchbase_gocb_v2_Scope(scope *gocb.Scope) {
	r1, err := scope.AnalyticsQuery("SELECT * FROM `travel-sample`", nil) // $ source

	if err != nil {
		return
	}

	for r1.Next() {
		var name1, name2 string

		r1.One(&name1)

		sink(name1) // $ hasTaintFlow="name1"

		r1.Row(&name2)
		sink(name2) // $ hasTaintFlow="name2"

		b := r1.Raw().NextBytes()
		sink(b) // $ hasTaintFlow="b"
	}

	r2, err := scope.Query("SELECT * FROM `travel-sample`", nil) // $ source

	if err != nil {
		return
	}

	for r2.Next() {
		var name1, name2 string

		r2.One(&name1)

		sink(name1) // $ hasTaintFlow="name1"

		r2.Row(&name2)
		sink(name2) // $ hasTaintFlow="name2"

		b := r2.Raw().NextBytes()
		sink(b) // $ hasTaintFlow="b"
	}
}

func test_couchbase_gocb_v2_Collection(coll *gocb.Collection) {
	type User struct {
		Name string
	}

	var user User

	r1, err := coll.Get("documentID", nil) // $ source

	if err != nil {
		return
	}

	r1.Content(&user)

	sink(user) // $ hasTaintFlow="user"

	r2, err := coll.GetAndLock("documentID", 30, nil) // $ source

	if err != nil {
		return
	}

	sink(r2) // $ hasTaintFlow="r2"

	r3, err := coll.GetAndTouch("documentID", 30, nil) // $ source

	if err != nil {
		return
	}

	var user3 User
	r3.Content(&user3)
	sink(user3) // $ hasTaintFlow="user3"

	r4, err := coll.GetAnyReplica("documentID", nil) // $ source

	if err != nil {
		return
	}

	sink(r4) // $ hasTaintFlow="r4"

	r5, err := coll.LookupIn("documentID", []gocb.LookupInSpec{}, nil) // $ source

	if err != nil {
		return
	}

	var user5 User
	r5.ContentAt(0, &user5)
	sink(user5) // $ hasTaintFlow="user5"

	r6, err := coll.LookupInAllReplicas("documentID", []gocb.LookupInSpec{}, nil) // $ source

	if err != nil {
		return
	}

	var user6 User
	r6.Next().ContentAt(0, &user6)
	sink(user6) // $ hasTaintFlow="user6"

	r7, err := coll.LookupInAnyReplica("documentID", []gocb.LookupInSpec{}, nil) // $ source

	if err != nil {
		return
	}

	var user7 User
	r7.ContentAt(0, &user7)
	sink(user7) // $ hasTaintFlow="user7"

	r8, err := coll.Scan(nil, nil) // $ source

	if err != nil {
		return
	}

	var user8 User
	r8.Next().Content(&user8)
	sink(user8) // $ hasTaintFlow="user8"
}

func test_couchbase_gocb_v2_TransactionAttemptContext(tam *gocb.TransactionAttemptContext, coll *gocb.Collection) {
	r1, err := tam.Get(coll, "documentID") // $ source

	if err != nil {
		return
	}

	var user User
	r1.Content(&user)

	sink(user) // $ hasTaintFlow="user"

	r2, err := tam.GetReplicaFromPreferredServerGroup(coll, "documentID") // $ source

	if err != nil {
		return
	}

	var user2 User
	r2.Content(&user2)
	sink(user2) // $ hasTaintFlow="user2"

	var user3 User

	r3, err := tam.Insert(coll, "documentID", &user3) // $ source
	if err != nil {
		return
	}

	var user4 User
	r3.Content(&user4)
	sink(user4) // $ hasTaintFlow="user4"

	r4, err := tam.Query("SELECT * FROM `travel-sample`", nil) // $ source
	if err != nil {
		return
	}

	for r4.Next() {
		var user5 User
		r4.One(&user5)
		sink(user5) // $ hasTaintFlow="user5"

		var user6 User
		r4.Row(&user6)
		sink(user6) // $ hasTaintFlow="user6"
	}

	r5, err := tam.Replace(r3, user4) // $ source
	if err != nil {
		return
	}

	sink(r5) // $ hasTaintFlow="r5"
}

func test_couchbase_gocb_v2_ViewIndexManager(v *gocb.ViewIndexManager) {
	doc, err := v.GetDesignDocument("name", 0, nil) // $ source

	if err != nil {
		return
	}

	sink(doc) // $ hasTaintFlow="doc"

	docs, err := v.GetAllDesignDocuments(0, nil) // $ source

	if err != nil {
		return
	}

	sink(docs) // $ hasTaintFlow="docs"
}
