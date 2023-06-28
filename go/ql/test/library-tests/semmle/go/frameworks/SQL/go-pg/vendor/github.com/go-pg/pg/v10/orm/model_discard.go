package orm

import (
	"github.com/go-pg/pg/v10/types"
)

type Discard struct {
	hookStubs
}

var _ Model = (*Discard)(nil)

func (Discard) Init() error {
	return nil
}

func (m Discard) NextColumnScanner() ColumnScanner {
	return m
}

func (m Discard) AddColumnScanner(ColumnScanner) error {
	return nil
}

func (m Discard) ScanColumn(col types.ColumnInfo, rd types.Reader, n int) error {
	return nil
}
