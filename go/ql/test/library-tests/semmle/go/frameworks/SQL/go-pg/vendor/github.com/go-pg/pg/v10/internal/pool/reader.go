package pool

import (
	"sync"
)

type Reader interface {
	Buffered() int

	Bytes() []byte
	Read([]byte) (int, error)
	ReadByte() (byte, error)
	UnreadByte() error
	ReadSlice(byte) ([]byte, error)
	Discard(int) (int, error)

	// ReadBytes(fn func(byte) bool) ([]byte, error)
	// ReadN(int) ([]byte, error)
	ReadFull() ([]byte, error)
	ReadFullTemp() ([]byte, error)
}

type ColumnInfo struct {
	Index    int16
	DataType int32
	Name     string
}

type ColumnAlloc struct {
	columns []ColumnInfo
}

func NewColumnAlloc() *ColumnAlloc {
	return new(ColumnAlloc)
}

func (c *ColumnAlloc) Reset() {
	c.columns = c.columns[:0]
}

func (c *ColumnAlloc) New(index int16, name []byte) *ColumnInfo {
	c.columns = append(c.columns, ColumnInfo{
		Index: index,
		Name:  string(name),
	})
	return &c.columns[len(c.columns)-1]
}

func (c *ColumnAlloc) Columns() []ColumnInfo {
	return c.columns
}

type ReaderContext struct {
	*BufReader
	ColumnAlloc *ColumnAlloc
}

func NewReaderContext() *ReaderContext {
	const bufSize = 1 << 20 // 1mb
	return &ReaderContext{
		BufReader:   NewBufReader(bufSize),
		ColumnAlloc: NewColumnAlloc(),
	}
}

var readerPool = sync.Pool{
	New: func() interface{} {
		return NewReaderContext()
	},
}

func GetReaderContext() *ReaderContext {
	rd := readerPool.Get().(*ReaderContext)
	return rd
}

func PutReaderContext(rd *ReaderContext) {
	rd.ColumnAlloc.Reset()
	readerPool.Put(rd)
}
