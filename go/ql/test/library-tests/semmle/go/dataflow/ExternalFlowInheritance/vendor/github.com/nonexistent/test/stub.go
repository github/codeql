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
	ExtraMethod()
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

func (t *S2) ExtraMethod() {}

// A struct type embedding I1
type StructEmbeddingI1 struct{ I1 }

// A struct type embedding I2
type StructEmbeddingI2 struct{ I2 }

// A struct type embedding I1 and "overriding" its methods
type StructEmbeddingAndOverridingI1 struct{ I1 }

func (t *StructEmbeddingAndOverridingI1) Source() interface{} {
	return nil
}

func (t *StructEmbeddingAndOverridingI1) Sink(interface{}) {}

func (t *StructEmbeddingAndOverridingI1) Step(val interface{}) interface{} {
	return val
}

// A struct type embedding I2 and "overriding" its methods
type StructEmbeddingAndOverridingI2 struct{ I2 }

func (t *StructEmbeddingAndOverridingI2) Source() interface{} {
	return nil
}

func (t *StructEmbeddingAndOverridingI2) Sink(interface{}) {}

func (t *StructEmbeddingAndOverridingI2) Step(val interface{}) interface{} {
	return val
}

func (t *StructEmbeddingAndOverridingI2) ExtraMethod() {}

// A struct type embedding S1
type StructEmbeddingS1 struct{ S1 }

// A struct type embedding S2
type StructEmbeddingS2 struct{ S2 }

// A struct type embedding S1 and "overriding" its methods
type StructEmbeddingAndOverridingS1 struct{ S1 }

func (t *StructEmbeddingAndOverridingS1) Source() interface{} {
	return nil
}

func (t *StructEmbeddingAndOverridingS1) Sink(interface{}) {}

func (t *StructEmbeddingAndOverridingS1) Step(val interface{}) interface{} {
	return val
}

// A struct type embedding S2 and "overriding" its methods
type StructEmbeddingAndOverridingS2 struct{ S2 }

func (t *StructEmbeddingAndOverridingS2) Source() interface{} {
	return nil
}

func (t *StructEmbeddingAndOverridingS2) Sink(interface{}) {}

func (t *StructEmbeddingAndOverridingS2) Step(val interface{}) interface{} {
	return val
}

func (t *StructEmbeddingAndOverridingS2) ExtraMethod() {}
