package test

//go:generate depstubber -vendor github.com/Masterminds/squirrel DeleteBuilder,InsertBuilder,QueryRower,QueryRowerContext,Queryer,QueryerContext,SelectBuilder,StdSql,StdSqlCtx,UpdateBuilder QueryContextWith,QueryRowContextWith,QueryRowWith,QueryWith

import (
	"context"

	"github.com/Masterminds/squirrel"
)

func Source[T any]() T {
	return *new(T)
}

func test_Masterminds_squirrel_QueryRower(ctx context.Context, db squirrel.QueryRower, sqlizer squirrel.Sqlizer) {
	scanner := db.QueryRow("") // $ source

	var r1, r2, r3 string
	scanner.Scan(&r1, &r2, &r3)

	sink(r1) // $ hasTaintFlow="r1"
	sink(r2) // $ hasTaintFlow="r2"
	sink(r3) // $ hasTaintFlow="r3"

	scanner2 := squirrel.QueryRowWith(db, sqlizer) // $ source

	var r4, r5, r6 string
	scanner2.Scan(&r4, &r5, &r6)

	sink(r4) // $ hasTaintFlow="r4"
	sink(r5) // $ hasTaintFlow="r5"
	sink(r6) // $ hasTaintFlow="r6"
}

func test_Masterminds_squirrel_QueryRowerContext(ctx context.Context, db squirrel.QueryRowerContext, sqlizer squirrel.Sqlizer) {
	scanner := db.QueryRowContext(ctx, "") // $ source

	var r1, r2, r3 string
	scanner.Scan(&r1, &r2, &r3)

	sink(r1) // $ hasTaintFlow="r1"
	sink(r2) // $ hasTaintFlow="r2"
	sink(r3) // $ hasTaintFlow="r3"

	scanner2 := squirrel.QueryRowContextWith(ctx, db, sqlizer) // $ source

	var r4, r5, r6 string
	scanner2.Scan(&r4, &r5, &r6)

	sink(r4) // $ hasTaintFlow="r4"
	sink(r5) // $ hasTaintFlow="r5"
	sink(r6) // $ hasTaintFlow="r6"
}

func test_Masterminds_squirrel_Queryer(ctx context.Context, db squirrel.Queryer, sqlizer squirrel.Sqlizer) {
	v1, err := db.Query("") // $ source
	if err != nil {
		return
	}
	sink(v1) // $ hasTaintFlow="v1"

	v2, err := squirrel.QueryWith(db, sqlizer) // $ source
	if err != nil {
		return
	}
	sink(v2) // $ hasTaintFlow="v2"
}

func test_Masterminds_squirrel_QueryerContext(ctx context.Context, db squirrel.QueryerContext, sqlizer squirrel.Sqlizer) {
	v1, err := db.QueryContext(ctx, "") // $ source
	if err != nil {
		return
	}
	sink(v1) // $ hasTaintFlow="v1"

	v2, err := squirrel.QueryContextWith(ctx, db, sqlizer) // $ source
	if err != nil {
		return
	}
	sink(v2) // $ hasTaintFlow="v2"
}

// StdSqlCtx extends StdSql so we can test both with a StdSqlCtx
func test_Masterminds_squirrel_StdSql_StdSqlCtx(ctx context.Context, std squirrel.StdSqlCtx) {
	v1, err := std.Query("") // $ source
	if err != nil {
		return
	}
	sink(v1) // $ hasTaintFlow="v1"

	v2, err := std.QueryContext(ctx, "") // $ source
	if err != nil {
		return
	}

	sink(v2) // $ hasTaintFlow="v2"

	s3 := std.QueryRow("") // $ source

	if err != nil {
		return
	}
	var r31, r32, r33 string
	s3.Scan(&r31, &r32, &r33)

	sink(r31) // $ hasTaintFlow="r31"
	sink(r32) // $ hasTaintFlow="r32"
	sink(r33) // $ hasTaintFlow="r33"

	s4 := std.QueryRowContext(ctx, "") // $ source

	var r41, r42, r43 string
	s4.Scan(&r41, &r42, &r43)

	sink(r41) // $ hasTaintFlow="r41"
	sink(r42) // $ hasTaintFlow="r42"
	sink(r43) // $ hasTaintFlow="r43"
}

func test_Masterminds_squirrel_DeleteBuilder(ctx context.Context, builder squirrel.DeleteBuilder) {
	v1, err := builder.Query() // $ source
	if err != nil {
		return
	}
	sink(v1) // $ hasTaintFlow="v1"

	v2, err := builder.QueryContext(ctx) // $ source
	if err != nil {
		return
	}
	sink(v2) // $ hasTaintFlow="v2"

	s3 := builder.QueryRowContext(ctx) // $ source

	var r31, r32, r33 string
	s3.Scan(&r31, &r32, &r33)

	sink(r31) // $ hasTaintFlow="r31"
	sink(r32) // $ hasTaintFlow="r32"
	sink(r33) // $ hasTaintFlow="r33"

	builder2 := Source[squirrel.DeleteBuilder]() // $ source

	var r41, r42, r43 string
	builder2.ScanContext(ctx, &r41, &r42, &r43)

	sink(r41) // $ hasTaintFlow="r41"
	sink(r42) // $ hasTaintFlow="r42"
	sink(r43) // $ hasTaintFlow="r43"
}

func test_Masterminds_squirrel_InsertBuilder(ctx context.Context, builder squirrel.InsertBuilder) {
	v1, err := builder.Query() // $ source
	if err != nil {
		return
	}
	sink(v1) // $ hasTaintFlow="v1"

	v2, err := builder.QueryContext(ctx) // $ source
	if err != nil {
		return
	}
	sink(v2) // $ hasTaintFlow="v2"

	s3 := builder.QueryRow() // $ source

	var r31, r32, r33 string
	s3.Scan(&r31, &r32, &r33)

	sink(r31) // $ hasTaintFlow="r31"
	sink(r32) // $ hasTaintFlow="r32"
	sink(r33) // $ hasTaintFlow="r33"

	s4 := builder.QueryRowContext(ctx) // $ source

	var r41, r42, r43 string
	s4.Scan(&r41, &r42, &r43)

	sink(r41) // $ hasTaintFlow="r41"
	sink(r42) // $ hasTaintFlow="r42"
	sink(r43) // $ hasTaintFlow="r43"

	builder2 := Source[squirrel.InsertBuilder]() // $ source

	var r51, r52, r53 string
	builder2.Scan(&r51, &r52, &r53)

	sink(r51) // $ hasTaintFlow="r51"
	sink(r52) // $ hasTaintFlow="r52"
	sink(r53) // $ hasTaintFlow="r53"

	var r61, r62, r63 string
	builder2.ScanContext(ctx, &r61, &r62, &r63)

	sink(r61) // $ hasTaintFlow="r61"
	sink(r62) // $ hasTaintFlow="r62"
	sink(r63) // $ hasTaintFlow="r63"
}

func test_Masterminds_squirrel_SelectBuilder(ctx context.Context, builder squirrel.SelectBuilder) {
	v1, err := builder.Query() // $ source
	if err != nil {
		return
	}
	sink(v1) // $ hasTaintFlow="v1"

	v2, err := builder.QueryContext(ctx) // $ source
	if err != nil {
		return
	}
	sink(v2) // $ hasTaintFlow="v2"

	s3 := builder.QueryRow() // $ source

	var r31, r32, r33 string
	s3.Scan(&r31, &r32, &r33)

	sink(r31) // $ hasTaintFlow="r31"
	sink(r32) // $ hasTaintFlow="r32"
	sink(r33) // $ hasTaintFlow="r33"

	s4 := builder.QueryRowContext(ctx) // $ source

	var r41, r42, r43 string
	s4.Scan(&r41, &r42, &r43)

	sink(r41) // $ hasTaintFlow="r41"
	sink(r42) // $ hasTaintFlow="r42"
	sink(r43) // $ hasTaintFlow="r43"

	builder2 := Source[squirrel.SelectBuilder]() // $ source

	var r51, r52, r53 string
	builder2.Scan(&r51, &r52, &r53)

	sink(r51) // $ hasTaintFlow="r51"
	sink(r52) // $ hasTaintFlow="r52"
	sink(r53) // $ hasTaintFlow="r53"

	var r61, r62, r63 string
	builder2.ScanContext(ctx, &r61, &r62, &r63)

	sink(r61) // $ hasTaintFlow="r61"
	sink(r62) // $ hasTaintFlow="r62"
	sink(r63) // $ hasTaintFlow="r63"
}

func test_Masterminds_squirrel_UpdateBuilder(ctx context.Context, builder squirrel.UpdateBuilder) {
	v1, err := builder.Query() // $ source
	if err != nil {
		return
	}
	sink(v1) // $ hasTaintFlow="v1"

	v2, err := builder.QueryContext(ctx) // $ source
	if err != nil {
		return
	}
	sink(v2) // $ hasTaintFlow="v2"

	s3 := builder.QueryRow() // $ source

	var r31, r32, r33 string
	s3.Scan(&r31, &r32, &r33)

	sink(r31) // $ hasTaintFlow="r31"
	sink(r32) // $ hasTaintFlow="r32"
	sink(r33) // $ hasTaintFlow="r33"

	s4 := builder.QueryRowContext(ctx) // $ source

	var r41, r42, r43 string
	s4.Scan(&r41, &r42, &r43)

	sink(r41) // $ hasTaintFlow="r41"
	sink(r42) // $ hasTaintFlow="r42"
	sink(r43) // $ hasTaintFlow="r43"

	builder2 := Source[squirrel.UpdateBuilder]() // $ source

	var r51, r52, r53 string
	builder2.Scan(&r51, &r52, &r53)

	sink(r51) // $ hasTaintFlow="r51"
	sink(r52) // $ hasTaintFlow="r52"
	sink(r53) // $ hasTaintFlow="r53"

	var r61, r62, r63 string
	builder2.ScanContext(ctx, &r61, &r62, &r63)

	sink(r61) // $ hasTaintFlow="r61"
	sink(r62) // $ hasTaintFlow="r62"
	sink(r63) // $ hasTaintFlow="r63"
}
