package sqlx

type Row struct {
	// Mapper *reflectx.Mapper
}

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
