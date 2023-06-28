package orm

// Result summarizes an executed SQL command.
type Result interface {
	Model() Model

	// RowsAffected returns the number of rows affected by SELECT, INSERT, UPDATE,
	// or DELETE queries. It returns -1 if query can't possibly affect any rows,
	// e.g. in case of CREATE or SHOW queries.
	RowsAffected() int

	// RowsReturned returns the number of rows returned by the query.
	RowsReturned() int
}
