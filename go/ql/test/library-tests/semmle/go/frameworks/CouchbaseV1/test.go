package test

//go:generate depstubber -vendor  gopkg.in/couchbase/gocb.v1 Bucket,Cluster NewAnalyticsQuery,NewN1qlQuery,QueryProfileNone,StatementPlus

import (
	"net/http"
	"time"

	"gopkg.in/couchbase/gocb.v1"
)

func analyticsQuery(bucket gocb.Bucket, untrustedSource *http.Request) {
	untrusted := untrustedSource.UserAgent()
	q0 := gocb.NewAnalyticsQuery(untrusted)
	q1 := q0.ContextId("")
	q2 := q1.Deferred(true)
	q3 := q2.Pretty(true)
	q4 := q3.Priority(true)
	q5 := q4.RawParam("name", nil)
	duration, _ := time.ParseDuration("300s")
	q6 := q5.ServerSideTimeout(duration)
	bucket.ExecuteAnalyticsQuery(q6, nil) // $ sqlinjection=q6
}

func n1qlQuery(cluster gocb.Cluster, untrustedSource *http.Request) {
	untrusted := untrustedSource.UserAgent()
	q0 := gocb.NewN1qlQuery(untrusted)
	q1 := q0.AdHoc(true)
	q2 := q1.Consistency(gocb.StatementPlus)
	q3 := q2.ConsistentWith(&gocb.MutationState{})
	q4 := q3.Custom("name", nil)
	q5 := q4.PipelineBatch(2)
	q6 := q5.PipelineCap(5)
	q7 := q6.Profile(gocb.QueryProfileNone)
	q8 := q7.ReadOnly(false)
	q9 := q8.ScanCap(10)
	duration, _ := time.ParseDuration("300s")
	q10 := q9.Timeout(duration)
	cluster.ExecuteN1qlQuery(q10, nil) // $ sqlinjection=q10
}
