package sqlx

import "database/sql"

type Row struct {
	// Mapper *reflectx.Mapper
}

// stub Row::MapScan, Row::StructScan, Row::SliceScan, Row::Scan

func (r *Row) MapScan(dest map[string]interface{}) error {
	return nil
}

func (r *Row) StructScan(dest interface{}) error {
	return nil
}

func (r *Row) SliceScan(dest []interface{}) error {
	return nil
}

func (r *Row) Scan(dest ...interface{}) error {
	return nil
}

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

func (r *Rows) Scan(dest ...interface{}) error {
	return nil
}
