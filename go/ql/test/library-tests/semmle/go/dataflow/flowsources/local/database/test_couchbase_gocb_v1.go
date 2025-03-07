package test

import "github.com/couchbase/gocb"

func test_couchbase_gocb_v1_Cluster(cluster *gocb.Cluster, aq *gocb.AnalyticsQuery, n1ql *gocb.N1qlQuery, sq *gocb.SearchQuery) {
	// Analytics
	r1, err := cluster.ExecuteAnalyticsQuery(aq, nil) // $ source

	if err != nil {
		return
	}

	var user1, user2 User

	r1.One(&user1)
	sink(user1) // $ hasTaintFlow="user1"

	for r1.Next(user2) {
		sink(user2) // $ hasTaintFlow="user2"
	}

	var b1 []byte
	b1 = r1.NextBytes()
	sink(b1) // $ hasTaintFlow="b1"

	// N1QL
	r2, err := cluster.ExecuteN1qlQuery(n1ql, nil) // $ source

	if err != nil {
		return
	}

	var user3, user4 User

	r2.One(&user3)
	sink(user3) // $ hasTaintFlow="user3"

	for r2.Next(user4) {
		sink(user4) // $ hasTaintFlow="user4"
	}

	var b2 []byte
	b2 = r2.NextBytes()
	sink(b2) // $ hasTaintFlow="b2"

	// Search
	r3, err := cluster.ExecuteSearchQuery(sq) // $ source

	if err != nil {
		return
	}

	hit := r3.Hits()[0]
	sink(hit) // $ hasTaintFlow="hit"
}
