# PostgreSQL client and ORM for Golang

## Maintenance mode

go-pg is in a maintenance mode and only critical issues are addressed. New development happens in
[**Bun**](https://bun.uptrace.dev/guide/pg-migration.html) repo which offers similar functionality
but works with PostgreSQL, MySQL, MariaDB, and SQLite.

## [Golang ORM](https://github.com/uptrace/bun)

---

[![Build Status](https://travis-ci.org/go-pg/pg.svg?branch=v10)](https://travis-ci.org/go-pg/pg)
[![PkgGoDev](https://pkg.go.dev/badge/github.com/go-pg/pg/v10)](https://pkg.go.dev/github.com/go-pg/pg/v10)
[![Documentation](https://img.shields.io/badge/pg-documentation-informational)](https://pg.uptrace.dev/)
[![Chat](https://discordapp.com/api/guilds/752070105847955518/widget.png)](https://discord.gg/rWtp5Aj)

- [Documentation](https://pg.uptrace.dev)
- [Reference](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc)
- [Examples](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc#pkg-examples)
- Example projects:
  - [monetr](https://github.com/monetr/monetr) - budgeting application focused on planning for
    recurring expenses
  - [bunrouter](https://github.com/go-bun/bun-realworld-app)
  - [gin](https://github.com/gogjango/gjango)
  - [go-kit](https://github.com/Tsovak/rest-api-demo)
  - [aah framework](https://github.com/kieusonlam/golamapi)

## Tutorials

- [GraphQL Tutorial on YouTube](https://www.youtube.com/playlist?list=PLzQWIQOqeUSNwXcneWYJHUREAIucJ5UZn).
- [Modern API design with Golang, PostgreSQL and Docker](https://bognov.tech/modern-api-design-with-golang-postgresql-and-docker)

## Ecosystem

- Migrations by [vmihailenco](https://github.com/go-pg/migrations) and
  [robinjoseph08](https://github.com/robinjoseph08/go-pg-migrations).
- [Genna - cli tool for generating go-pg models](https://github.com/dizzyfool/genna).
- [bigint](https://github.com/d-fal/bigint) - big.Int type for go-pg.
- [urlstruct](https://github.com/go-pg/urlstruct) to decode `url.Values` into structs.
- [Sharding](https://github.com/go-pg/sharding).
- [go-pg-monitor](https://github.com/hypnoglow/go-pg-monitor) - Prometheus metrics based on go-pg
  client stats.

## Features

- Basic types: integers, floats, string, bool, time.Time, net.IP, net.IPNet.
- sql.NullBool, sql.NullString, sql.NullInt64, sql.NullFloat64 and
  [pg.NullTime](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc#NullTime).
- [sql.Scanner](http://golang.org/pkg/database/sql/#Scanner) and
  [sql/driver.Valuer](http://golang.org/pkg/database/sql/driver/#Valuer) interfaces.
- Structs, maps and arrays are marshalled as JSON by default.
- PostgreSQL multidimensional Arrays using
  [array tag](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc#example-DB-Model-PostgresArrayStructTag)
  and [Array wrapper](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc#example-Array).
- Hstore using
  [hstore tag](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc#example-DB-Model-HstoreStructTag)
  and [Hstore wrapper](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc#example-Hstore).
- [Composite types](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc#example-DB-Model-CompositeType).
- All struct fields are nullable by default and zero values (empty string, 0, zero time, empty map
  or slice, nil ptr) are marshalled as SQL `NULL`. `pg:",notnull"` is used to add SQL `NOT NULL`
  constraint and `pg:",use_zero"` to allow Go zero values.
- [Transactions](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc#example-DB-Begin).
- [Prepared statements](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc#example-DB-Prepare).
- [Notifications](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc#example-Listener) using
  `LISTEN` and `NOTIFY`.
- [Copying data](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc#example-DB-CopyFrom) using
  `COPY FROM` and `COPY TO`.
- [Timeouts](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc#Options) and canceling queries using
  context.Context.
- Automatic connection pooling with
  [circuit breaker](https://en.wikipedia.org/wiki/Circuit_breaker_design_pattern) support.
- Queries retry on network errors.
- Working with models using
  [ORM](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc#example-DB.Model) and
  [SQL](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc#example-DB.Query).
- Scanning variables using
  [ORM](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc#example-DB.Model-SelectSomeColumnsIntoVars)
  and [SQL](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc#example-Scan).
- [SelectOrInsert](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc#example-DB.Model-InsertSelectOrInsert)
  using on-conflict.
- [INSERT ... ON CONFLICT DO UPDATE](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc#example-DB.Model-InsertOnConflictDoUpdate)
  using ORM.
- Bulk/batch
  [inserts](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc#example-DB.Model-BulkInsert),
  [updates](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc#example-DB.Model-BulkUpdate), and
  [deletes](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc#example-DB.Model-BulkDelete).
- Common table expressions using
  [WITH](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc#example-DB.Model-SelectWith) and
  [WrapWith](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc#example-DB.Model-SelectWrapWith).
- [CountEstimate](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc#example-DB.Model-CountEstimate)
  using `EXPLAIN` to get
  [estimated number of matching rows](https://wiki.postgresql.org/wiki/Count_estimate).
- ORM supports
  [has one](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc#example-DB.Model-HasOne),
  [belongs to](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc#example-DB.Model-BelongsTo),
  [has many](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc#example-DB.Model-HasMany), and
  [many to many](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc#example-DB.Model-ManyToMany)
  with composite/multi-column primary keys.
- [Soft deletes](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc#example-DB.Model-SoftDelete).
- [Creating tables from structs](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc#example-DB.Model-CreateTable).
- [ForEach](https://pkg.go.dev/github.com/go-pg/pg/v10?tab=doc#example-DB.Model-ForEach) that calls
  a function for each row returned by the query without loading all rows into the memory.

## Installation

go-pg supports 2 last Go versions and requires a Go version with
[modules](https://github.com/golang/go/wiki/Modules) support. So make sure to initialize a Go
module:

```shell
go mod init github.com/my/repo
```

And then install go-pg (note _v10_ in the import; omitting it is a popular mistake):

```shell
go get github.com/go-pg/pg/v10
```

## Quickstart

```go
package pg_test

import (
    "fmt"

    "github.com/go-pg/pg/v10"
    "github.com/go-pg/pg/v10/orm"
)

type User struct {
    Id     int64
    Name   string
    Emails []string
}

func (u User) String() string {
    return fmt.Sprintf("User<%d %s %v>", u.Id, u.Name, u.Emails)
}

type Story struct {
    Id       int64
    Title    string
    AuthorId int64
    Author   *User `pg:"rel:has-one"`
}

func (s Story) String() string {
    return fmt.Sprintf("Story<%d %s %s>", s.Id, s.Title, s.Author)
}

func ExampleDB_Model() {
    db := pg.Connect(&pg.Options{
        User: "postgres",
    })
    defer db.Close()

    err := createSchema(db)
    if err != nil {
        panic(err)
    }

    user1 := &User{
        Name:   "admin",
        Emails: []string{"admin1@admin", "admin2@admin"},
    }
    _, err = db.Model(user1).Insert()
    if err != nil {
        panic(err)
    }

    _, err = db.Model(&User{
        Name:   "root",
        Emails: []string{"root1@root", "root2@root"},
    }).Insert()
    if err != nil {
        panic(err)
    }

    story1 := &Story{
        Title:    "Cool story",
        AuthorId: user1.Id,
    }
    _, err = db.Model(story1).Insert()
    if err != nil {
        panic(err)
    }

    // Select user by primary key.
    user := &User{Id: user1.Id}
    err = db.Model(user).WherePK().Select()
    if err != nil {
        panic(err)
    }

    // Select all users.
    var users []User
    err = db.Model(&users).Select()
    if err != nil {
        panic(err)
    }

    // Select story and associated author in one query.
    story := new(Story)
    err = db.Model(story).
        Relation("Author").
        Where("story.id = ?", story1.Id).
        Select()
    if err != nil {
        panic(err)
    }

    fmt.Println(user)
    fmt.Println(users)
    fmt.Println(story)
    // Output: User<1 admin [admin1@admin admin2@admin]>
    // [User<1 admin [admin1@admin admin2@admin]> User<2 root [root1@root root2@root]>]
    // Story<1 Cool story User<1 admin [admin1@admin admin2@admin]>>
}

// createSchema creates database schema for User and Story models.
func createSchema(db *pg.DB) error {
    models := []interface{}{
        (*User)(nil),
        (*Story)(nil),
    }

    for _, model := range models {
        err := db.Model(model).CreateTable(&orm.CreateTableOptions{
            Temp: true,
        })
        if err != nil {
            return err
        }
    }
    return nil
}
```

## See also

- [Golang PostgreSQL](https://bun.uptrace.dev/postgres/)
- [Golang HTTP router](https://github.com/uptrace/bunrouter)
- [Golang ClickHouse ORM](https://github.com/uptrace/go-clickhouse)
- [Golang msgpack](https://github.com/vmihailenco/msgpack)
- [Distributed tracing tools](https://get.uptrace.dev/compare/distributed-tracing-tools.html)
