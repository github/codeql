# SQL-first Golang ORM for PostgreSQL, MySQL, MSSQL, and SQLite

[![build workflow](https://github.com/uptrace/bun/actions/workflows/build.yml/badge.svg)](https://github.com/uptrace/bun/actions)
[![PkgGoDev](https://pkg.go.dev/badge/github.com/uptrace/bun)](https://pkg.go.dev/github.com/uptrace/bun)
[![Documentation](https://img.shields.io/badge/bun-documentation-informational)](https://bun.uptrace.dev/)
[![Chat](https://discordapp.com/api/guilds/752070105847955518/widget.png)](https://discord.gg/rWtp5Aj)

> Bun is brought to you by :star: [**uptrace/uptrace**](https://github.com/uptrace/uptrace). Uptrace
> is an open-source APM tool that supports distributed tracing, metrics, and logs. You can use it to
> monitor applications and set up automatic alerts to receive notifications via email, Slack,
> Telegram, and others.
>
> See [OpenTelemetry](example/opentelemetry) example which demonstrates how you can use Uptrace to
> monitor Bun.

## Features

- Works with [PostgreSQL](https://bun.uptrace.dev/guide/drivers.html#postgresql),
  [MySQL](https://bun.uptrace.dev/guide/drivers.html#mysql) (including MariaDB),
  [MSSQL](https://bun.uptrace.dev/guide/drivers.html#mssql),
  [SQLite](https://bun.uptrace.dev/guide/drivers.html#sqlite).
- [ORM-like](/example/basic/) experience using good old SQL. Bun supports structs, map, scalars, and
  slices of map/structs/scalars.
- [Bulk inserts](https://bun.uptrace.dev/guide/query-insert.html).
- [Bulk updates](https://bun.uptrace.dev/guide/query-update.html) using common table expressions.
- [Bulk deletes](https://bun.uptrace.dev/guide/query-delete.html).
- [Fixtures](https://bun.uptrace.dev/guide/fixtures.html).
- [Migrations](https://bun.uptrace.dev/guide/migrations.html).
- [Soft deletes](https://bun.uptrace.dev/guide/soft-deletes.html).

### Resources

- [**Get started**](https://bun.uptrace.dev/guide/golang-orm.html)
- [Examples](https://github.com/uptrace/bun/tree/master/example)
- [Discussions](https://github.com/uptrace/bun/discussions)
- [Chat](https://discord.gg/rWtp5Aj)
- [Reference](https://pkg.go.dev/github.com/uptrace/bun)
- [Starter kit](https://github.com/go-bun/bun-starter-kit)

### Tutorials

Wrote a tutorial for Bun? Create a PR to add here and on [Bun](https://bun.uptrace.dev/) site.

### Featured projects using Bun

- [uptrace](https://github.com/uptrace/uptrace) - Distributed tracing and metrics.
- [paralus](https://github.com/paralus/paralus) - All-in-one Kubernetes access manager.
- [inovex/scrumlr.io](https://github.com/inovex/scrumlr.io) - Webapp for collaborative online
  retrospectives.
- [gotosocial](https://github.com/superseriousbusiness/gotosocial) - Golang fediverse server.
- [lorawan-stack](https://github.com/TheThingsNetwork/lorawan-stack) - The Things Stack, an Open
  Source LoRaWAN Network Server.
- [anti-phishing-bot](https://github.com/Benricheson101/anti-phishing-bot) - Discord bot for
  deleting Steam/Discord phishing links.
- [emerald-web3-gateway](https://github.com/oasisprotocol/emerald-web3-gateway) - Web3 Gateway for
  the Oasis Emerald paratime.
- [lndhub.go](https://github.com/getAlby/lndhub.go) - accounting wrapper for the Lightning Network.
- [penguin-statistics](https://github.com/penguin-statistics/backend-next) - Penguin Statistics v3
  Backend.
- And
  [hundreds more](https://github.com/uptrace/bun/network/dependents?package_id=UGFja2FnZS0yMjkxOTc4OTA4).

## Why another database client?

So you can elegantly write complex queries:

```go
regionalSales := db.NewSelect().
	ColumnExpr("region").
	ColumnExpr("SUM(amount) AS total_sales").
	TableExpr("orders").
	GroupExpr("region")

topRegions := db.NewSelect().
	ColumnExpr("region").
	TableExpr("regional_sales").
	Where("total_sales > (SELECT SUM(total_sales) / 10 FROM regional_sales)")

var items []map[string]interface{}
err := db.NewSelect().
	With("regional_sales", regionalSales).
	With("top_regions", topRegions).
	ColumnExpr("region").
	ColumnExpr("product").
	ColumnExpr("SUM(quantity) AS product_units").
	ColumnExpr("SUM(amount) AS product_sales").
	TableExpr("orders").
	Where("region IN (SELECT region FROM top_regions)").
	GroupExpr("region").
	GroupExpr("product").
	Scan(ctx, &items)
```

```sql
WITH regional_sales AS (
    SELECT region, SUM(amount) AS total_sales
    FROM orders
    GROUP BY region
), top_regions AS (
    SELECT region
    FROM regional_sales
    WHERE total_sales > (SELECT SUM(total_sales)/10 FROM regional_sales)
)
SELECT region,
       product,
       SUM(quantity) AS product_units,
       SUM(amount) AS product_sales
FROM orders
WHERE region IN (SELECT region FROM top_regions)
GROUP BY region, product
```

And scan results into scalars, structs, maps, slices of structs/maps/scalars:

```go
users := make([]User, 0)
if err := db.NewSelect().Model(&users).OrderExpr("id ASC").Scan(ctx); err != nil {
	panic(err)
}

user1 := new(User)
if err := db.NewSelect().Model(user1).Where("id = ?", 1).Scan(ctx); err != nil {
	panic(err)
}
```

See [**Getting started**](https://bun.uptrace.dev/guide/golang-orm.html) guide and check
[examples](example).

## See also

- [Golang HTTP router](https://github.com/uptrace/bunrouter)
- [Golang ClickHouse ORM](https://github.com/uptrace/go-clickhouse)
- [Golang msgpack](https://github.com/vmihailenco/msgpack)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for some hints.

And thanks to all the people who already contributed!

<a href="https://github.com/uptrace/bun/graphs/contributors">
  <img src="https://contributors-img.web.app/image?repo=uptrace/bun" />
</a>
