# sessions

[![GoDoc](https://godoc.org/github.com/gorilla/sessions?status.svg)](https://godoc.org/github.com/gorilla/sessions) [![Build Status](https://travis-ci.org/gorilla/sessions.svg?branch=master)](https://travis-ci.org/gorilla/sessions)
[![Sourcegraph](https://sourcegraph.com/github.com/gorilla/sessions/-/badge.svg)](https://sourcegraph.com/github.com/gorilla/sessions?badge)

gorilla/sessions provides cookie and filesystem sessions and infrastructure for
custom session backends.

The key features are:

- Simple API: use it as an easy way to set signed (and optionally
  encrypted) cookies.
- Built-in backends to store sessions in cookies or the filesystem.
- Flash messages: session values that last until read.
- Convenient way to switch session persistency (aka "remember me") and set
  other attributes.
- Mechanism to rotate authentication and encryption keys.
- Multiple sessions per request, even using different backends.
- Interfaces and infrastructure for custom session backends: sessions from
  different stores can be retrieved and batch-saved using a common API.

Let's start with an example that shows the sessions API in a nutshell:

```go
	import (
		"net/http"
		"github.com/gorilla/sessions"
	)

	// Note: Don't store your key in your source code. Pass it via an
	// environmental variable, or flag (or both), and don't accidentally commit it
	// alongside your code. Ensure your key is sufficiently random - i.e. use Go's
	// crypto/rand or securecookie.GenerateRandomKey(32) and persist the result.
	var store = sessions.NewCookieStore([]byte(os.Getenv("SESSION_KEY")))

	func MyHandler(w http.ResponseWriter, r *http.Request) {
		// Get a session. We're ignoring the error resulted from decoding an
		// existing session: Get() always returns a session, even if empty.
		session, _ := store.Get(r, "session-name")
		// Set some session values.
		session.Values["foo"] = "bar"
		session.Values[42] = 43
		// Save it before we write to the response/return from the handler.
		err := session.Save(r, w)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
	}
```

First we initialize a session store calling `NewCookieStore()` and passing a
secret key used to authenticate the session. Inside the handler, we call
`store.Get()` to retrieve an existing session or create a new one. Then we set
some session values in session.Values, which is a `map[interface{}]interface{}`.
And finally we call `session.Save()` to save the session in the response.

More examples are available [on the Gorilla
website](https://www.gorillatoolkit.org/pkg/sessions).

## Store Implementations

Other implementations of the `sessions.Store` interface:

- [github.com/starJammer/gorilla-sessions-arangodb](https://github.com/starJammer/gorilla-sessions-arangodb) - ArangoDB
- [github.com/yosssi/boltstore](https://github.com/yosssi/boltstore) - Bolt
- [github.com/srinathgs/couchbasestore](https://github.com/srinathgs/couchbasestore) - Couchbase
- [github.com/denizeren/dynamostore](https://github.com/denizeren/dynamostore) - Dynamodb on AWS
- [github.com/savaki/dynastore](https://github.com/savaki/dynastore) - DynamoDB on AWS (Official AWS library)
- [github.com/bradleypeabody/gorilla-sessions-memcache](https://github.com/bradleypeabody/gorilla-sessions-memcache) - Memcache
- [github.com/dsoprea/go-appengine-sessioncascade](https://github.com/dsoprea/go-appengine-sessioncascade) - Memcache/Datastore/Context in AppEngine
- [github.com/kidstuff/mongostore](https://github.com/kidstuff/mongostore) - MongoDB
- [github.com/srinathgs/mysqlstore](https://github.com/srinathgs/mysqlstore) - MySQL
- [github.com/EnumApps/clustersqlstore](https://github.com/EnumApps/clustersqlstore) - MySQL Cluster
- [github.com/antonlindstrom/pgstore](https://github.com/antonlindstrom/pgstore) - PostgreSQL
- [github.com/boj/redistore](https://github.com/boj/redistore) - Redis
- [github.com/rbcervilla/redisstore](https://github.com/rbcervilla/redisstore) - Redis (Single, Sentinel, Cluster)
- [github.com/boj/rethinkstore](https://github.com/boj/rethinkstore) - RethinkDB
- [github.com/boj/riakstore](https://github.com/boj/riakstore) - Riak
- [github.com/michaeljs1990/sqlitestore](https://github.com/michaeljs1990/sqlitestore) - SQLite
- [github.com/wader/gormstore](https://github.com/wader/gormstore) - GORM (MySQL, PostgreSQL, SQLite)
- [github.com/gernest/qlstore](https://github.com/gernest/qlstore) - ql
- [github.com/quasoft/memstore](https://github.com/quasoft/memstore) - In-memory implementation for use in unit tests
- [github.com/lafriks/xormstore](https://github.com/lafriks/xormstore) - XORM (MySQL, PostgreSQL, SQLite, Microsoft SQL Server, TiDB)
- [github.com/GoogleCloudPlatform/firestore-gorilla-sessions](https://github.com/GoogleCloudPlatform/firestore-gorilla-sessions) - Cloud Firestore
- [github.com/stephenafamo/crdbstore](https://github.com/stephenafamo/crdbstore) - CockroachDB

## License

BSD licensed. See the LICENSE file for details.
