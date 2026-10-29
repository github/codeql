package pkg1

// A struct type with methods defined on it
type S struct {
	SField string
}

func (t S) SMethod() interface{} {
	return nil
}

// A struct type with methods defined on its pointer type
type P struct {
	PField string
}

func (t *P) PMethod() interface{} {
	return nil
}

// A struct type embedding S
type SEmbedS struct{ S }

// A struct type embedding P
type SEmbedP struct{ P }
