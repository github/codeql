package sqlx

import "database/sql"

type Rows struct {
	*sql.Rows

	// Mapper *reflectx.Mapper
	// contains filtered or unexported fields
}

func (r *Rows) MapScan(dest map[string]interface{}) error {
	return nil
}

func (r *Rows) StructScan(dest interface{}) error {
	return nil
}

func (r *Rows) SliceScan(dest []interface{}) error {
	return nil
}
