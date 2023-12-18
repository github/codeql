package orm

type mapSliceModel struct {
	mapModel
	slice *[]map[string]interface{}
}

var _ Model = (*mapSliceModel)(nil)

func newMapSliceModel(ptr *[]map[string]interface{}) *mapSliceModel {
	return &mapSliceModel{
		slice: ptr,
	}
}

func (m *mapSliceModel) Init() error {
	slice := *m.slice
	if len(slice) > 0 {
		*m.slice = slice[:0]
	}
	return nil
}

func (m *mapSliceModel) NextColumnScanner() ColumnScanner {
	slice := *m.slice
	if len(slice) == cap(slice) {
		m.mapModel.m = make(map[string]interface{})
		*m.slice = append(slice, m.mapModel.m) //nolint:gocritic
		return m
	}

	slice = slice[:len(slice)+1]
	el := slice[len(slice)-1]
	if el != nil {
		m.mapModel.m = el
	} else {
		el = make(map[string]interface{})
		slice[len(slice)-1] = el
		m.mapModel.m = el
	}
	*m.slice = slice
	return m
}

func (mapSliceModel) useQueryOne() {} //nolint:unused
