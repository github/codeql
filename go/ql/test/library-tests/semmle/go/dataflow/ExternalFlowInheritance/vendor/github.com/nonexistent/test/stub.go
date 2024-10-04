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
type S1 struct{}

func (t *S1) Source() interface{} {
	return nil
}

func (t *S1) Sink(interface{}) {}

func (t *S1) Step(val interface{}) interface{} {
	return val
}

// A struct type implementing I2
type S2 struct{}

func (t *S2) Source() interface{} {
	return nil
}

func (t *S2) Sink(interface{}) {}

func (t *S2) Step(val interface{}) interface{} {
	return val
}

func (t *S2) ExtraMethodI2() {}

// A struct type embedding I1
type SEmbedI1 struct{ I1 }

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
type SImplEmbedI1 struct{ I1 }

func (t *SImplEmbedI1) Source() interface{} {
	return nil
}

func (t *SImplEmbedI1) Sink(interface{}) {}

func (t *SImplEmbedI1) Step(val interface{}) interface{} {
	return val
}

// A struct type embedding I2 and separately implementing its methods, so the
// methods of the embedded field are not promoted.
type SImplEmbedI2 struct{ I2 }

func (t *SImplEmbedI2) Source() interface{} {
	return nil
}

func (t *SImplEmbedI2) Sink(interface{}) {}

func (t *SImplEmbedI2) Step(val interface{}) interface{} {
	return val
}

func (t *SImplEmbedI2) ExtraMethodI2() {}

// A struct type embedding S1
type SEmbedS1 struct{ S1 }

// A struct type embedding S2
type SEmbedS2 struct{ S2 }

// A struct type embedding S1 and separately implementing I1's methods, so the
// methods of the embedded field are not promoted.
type SImplEmbedS1 struct{ S1 }

func (t *SImplEmbedS1) Source() interface{} {
	return nil
}

func (t *SImplEmbedS1) Sink(interface{}) {}

func (t *SImplEmbedS1) Step(val interface{}) interface{} {
	return val
}

// A struct type embedding S2 and separately implementing I2's methods, so the
// methods of the embedded field are not promoted.
type SImplEmbedS2 struct{ S2 }

func (t *SImplEmbedS2) Source() interface{} {
	return nil
}

func (t *SImplEmbedS2) Sink(interface{}) {}

func (t *SImplEmbedS2) Step(val interface{}) interface{} {
	return val
}

func (t *SImplEmbedS2) ExtraMethodI2() {}
