package test

// An interface
type I1 interface {
	Source() interface{}
	Step(interface{}) interface{}
	Sink(interface{})
}

// An interface which is a subtype of I1
type I2 interface {
	Source() interface{}
	Step(interface{}) interface{}
	Sink(interface{})
	ExtraMethodI2()
}

// A struct type implementing I1
type S1 struct {
	SourceField   string
	SinkField     string
	UniqueFieldS1 int // this only exists to make this struct type different from other struct types
}

func (t S1) Source() interface{} {
	return nil
}

func (t S1) Sink(interface{}) {}

func (t S1) Step(val interface{}) interface{} {
	return val
}

// A struct type whose pointer type implements I1
type P1 struct {
	SourceField   string
	SinkField     string
	UniqueFieldP1 int // this only exists to make this struct type different from other struct types
}

func (t *P1) Source() interface{} {
	return nil
}

func (t *P1) Sink(interface{}) {}

func (t *P1) Step(val interface{}) interface{} {
	return val
}

// A struct type implementing I2
type S2 struct {
	UniqueFieldS2 int // this only exists to make this struct type different from other struct types
}

func (t S2) Source() interface{} {
	return nil
}

func (t S2) Sink(interface{}) {}

func (t S2) Step(val interface{}) interface{} {
	return val
}

func (t S2) ExtraMethodI2() {}

// A struct type whose pointer type implements I2
type P2 struct{}

func (t *P2) Source() interface{} {
	return nil
}

func (t *P2) Sink(interface{}) {}

func (t *P2) Step(val interface{}) interface{} {
	return val
}

func (t *P2) ExtraMethodI2() {}

// A struct type embedding I1
type SEmbedI1 struct {
	I1
	SourceField         string
	SinkField           string
	UniqueFieldSEmbedI1 int // this only exists to make this struct type different from other struct types
}

// A struct type embedding I2
type SEmbedI2 struct{ I2 }

// An interface type embedding I1
type IEmbedI1 interface {
	I1
	ExtraMethodIEmbedI1()
}

// An interface type embedding I2
type IEmbedI2 interface {
	I2
	ExtraMethodIEmbedI2()
}

// A struct type embedding I1 and separately implementing its methods, so the
// methods of the embedded field are not promoted.
type SImplEmbedI1 struct {
	I1
	SourceField             string
	SinkField               string
	UniqueFieldSImplEmbedI1 int // this only exists to make this struct type different from other struct types
}

func (t SImplEmbedI1) Source() interface{} {
	return nil
}

func (t SImplEmbedI1) Sink(interface{}) {}

func (t SImplEmbedI1) Step(val interface{}) interface{} {
	return val
}

// A struct type embedding I2 and separately implementing its methods, so the
// methods of the embedded field are not promoted.
type SImplEmbedI2 struct {
	I2
	UniqueFieldSImplEmbedI2 int // this only exists to make this struct type different from other struct types
}

func (t SImplEmbedI2) Source() interface{} {
	return nil
}

func (t SImplEmbedI2) Sink(interface{}) {}

func (t SImplEmbedI2) Step(val interface{}) interface{} {
	return val
}

func (t SImplEmbedI2) ExtraMethodI2() {}

// A struct type embedding I1 and separately implementing its methods on its
// pointer type, so the methods of the embedded field are not promoted.
type PImplEmbedI1 struct {
	I1
	SourceField             string
	SinkField               string
	UniqueFieldPImplEmbedI1 int // this only exists to make this struct type different from other struct types
}

func (t *PImplEmbedI1) Source() interface{} {
	return nil
}

func (t *PImplEmbedI1) Sink(interface{}) {}

func (t *PImplEmbedI1) Step(val interface{}) interface{} {
	return val
}

// A struct type embedding I2 and separately implementing its methods, so the
// methods of the embedded field are not promoted.
type PImplEmbedI2 struct{ I2 }

func (t *PImplEmbedI2) Source() interface{} {
	return nil
}

func (t *PImplEmbedI2) Sink(interface{}) {}

func (t *PImplEmbedI2) Step(val interface{}) interface{} {
	return val
}

func (t *PImplEmbedI2) ExtraMethodI2() {}

// A struct type embedding S1
type SEmbedS1 struct{ S1 }

// A struct type embedding S2
type SEmbedS2 struct{ S2 }

// A struct type embedding P1
type SEmbedP1 struct{ P1 }

// A struct type embedding P2
type SEmbedP2 struct{ P2 }

// A struct type embedding *S1
type SEmbedPtrS1 struct{ *S1 }

// A struct type embedding *S2
type SEmbedPtrS2 struct{ *S2 }

// A struct type embedding *P1
type SEmbedPtrP1 struct{ *P1 }

// A struct type embedding *P2
type SEmbedPtrP2 struct{ *P2 }

// A struct type embedding S1 and separately implementing I1's methods and
// fields, so the methods and fields of the embedded field are not promoted.
type SImplEmbedS1 struct {
	S1
	SourceField             string
	SinkField               string
	UniqueFieldSImplEmbedS1 int // this only exists to make this struct type different from other struct types
}

func (t *SImplEmbedS1) Source() interface{} {
	return nil
}

func (t *SImplEmbedS1) Sink(interface{}) {}

func (t *SImplEmbedS1) Step(val interface{}) interface{} {
	return val
}

// A struct type embedding S2 and separately implementing I2's methods, so the
// methods of the embedded field are not promoted.
type SImplEmbedS2 struct {
	S2
	UniqueFieldSImplEmbedS2 int // this only exists to make this struct type different from other struct types
}

func (t *SImplEmbedS2) Source() interface{} {
	return nil
}

func (t *SImplEmbedS2) Sink(interface{}) {}

func (t *SImplEmbedS2) Step(val interface{}) interface{} {
	return val
}

func (t *SImplEmbedS2) ExtraMethodI2() {}

// A struct type embedding SEmbedI1
type SEmbedSEmbedI1 struct {
	SEmbedI1
	SourceField               string
	SinkField                 string
	UniqueFieldSEmbedSEmbedI1 int // this only exists to make this struct type different from other struct types
}

// A struct type embedding SEmbedS1
type SEmbedSEmbedS1 struct{ SEmbedS1 }

// A struct type embedding SEmbedPtrS1
type SEmbedSEmbedPtrS1 struct{ SEmbedPtrS1 }

// A struct type embedding SEmbedS1
type SEmbedPtrSEmbedS1 struct{ *SEmbedS1 }

// A struct type embedding SEmbedPtrS1
type SEmbedPtrSEmbedPtrS1 struct{ *SEmbedPtrS1 }

// A struct type embedding S1 and SEmbedS1
type SEmbedS1AndSEmbedS1 struct {
	S1
	SEmbedS1
	UniqueFieldSEmbedS1AndSEmbedS1 int // this only exists to make this struct type different from other struct types
}
