package main

//go:generate depstubber -vendor github.com/Masterminds/squirrel DeleteBuilder,Eq,InsertBuilder,SelectBuilder,UpdateBuilder Delete,Expr,Insert,Select,Update

import (
	"github.com/Masterminds/squirrel"
)

func squirrelTest(querypart string) {
	squirrel.Expr(querypart)                    // $ querystring=querypart
	deleteBuilder := squirrel.Delete(querypart) // $ querystring=querypart
	deleteBuilder.From(querypart)               // $ querystring=querypart
	deleteBuilder.OrderBy(querypart)            // $ querystring=querypart
	deleteBuilder.Prefix(querypart)             // $ querystring=querypart
	deleteBuilder.Suffix(querypart)             // $ querystring=querypart
	deleteBuilder.Where(querypart)              // $ querystring=querypart

	insertBuilder := squirrel.Insert(querypart) // $ querystring=querypart
	insertBuilder.Columns(querypart)            // $ querystring=querypart
	insertBuilder.Options(querypart)            // $ querystring=querypart
	insertBuilder.Prefix(querypart)             // $ querystring=querypart
	insertBuilder.Suffix(querypart)             // $ querystring=querypart
	insertBuilder.Into(querypart)               // $ querystring=querypart

	selectBuilder := squirrel.Select(querypart) // $ querystring=querypart
	selectBuilder.Columns(querypart)            // $ querystring=querypart
	selectBuilder.From(querypart)               // $ querystring=querypart
	selectBuilder.Options(querypart)            // $ querystring=querypart
	selectBuilder.OrderBy(querypart)            // $ querystring=querypart
	selectBuilder.Prefix(querypart)             // $ querystring=querypart
	selectBuilder.Suffix(querypart)             // $ querystring=querypart
	selectBuilder.Where(querypart)              // $ querystring=querypart
	selectBuilder.CrossJoin(querypart)          // $ querystring=querypart
	selectBuilder.GroupBy(querypart)            // $ querystring=querypart
	selectBuilder.InnerJoin(querypart)          // $ querystring=querypart
	selectBuilder.LeftJoin(querypart)           // $ querystring=querypart
	selectBuilder.RightJoin(querypart)          // $ querystring=querypart

	updateBuilder := squirrel.Update(querypart) // $ querystring=querypart
	updateBuilder.From(querypart)               // $ querystring=querypart
	updateBuilder.OrderBy(querypart)            // $ querystring=querypart
	updateBuilder.Prefix(querypart)             // $ querystring=querypart
	updateBuilder.Suffix(querypart)             // $ querystring=querypart
	updateBuilder.Where(querypart)              // $ querystring=querypart
	updateBuilder.Set(querypart, "")            // $ querystring=querypart
	updateBuilder.Table(querypart)              // $ querystring=querypart

	// safe
	wrapped := squirrel.Eq{"id": querypart}
	deleteBuilder.Where(wrapped)
	selectBuilder.Where(wrapped)
	updateBuilder.Where(wrapped)
}
