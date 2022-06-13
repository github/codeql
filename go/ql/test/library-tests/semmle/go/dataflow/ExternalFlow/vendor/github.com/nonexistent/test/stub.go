package test

type T struct{}

func (t *T) StepArgRes(arg interface{}) interface{} { return nil }

func (t *T) StepArgRes1(arg interface{}) (interface{}, interface{}) { return nil, nil }

func (t *T) StepArgArg(a1 interface{}, a2 interface{}) {}

func (t *T) StepArgQual(arg interface{}) {}

func (t *T) StepQualRes() interface{} { return nil }

func (t *T) StepQualArg(arg interface{}) {}

func StepArgResNoQual(arg interface{}) interface{} { return nil }

func StepArgResArrayContent(arg interface{}) []interface{} { return nil }

func StepArgArrayContentRes(arg []interface{}) interface{} { return nil }

func StepArgResCollectionContent(arg interface{}) interface{} { return nil }

func StepArgCollectionContentRes(arg interface{}) interface{} { return nil }

func StepArgResMapKeyContent(arg interface{}) interface{} { return nil }

func StepArgMapKeyContentRes(arg interface{}) interface{} { return nil }

func StepArgResMapValueContent(arg interface{}) interface{} { return nil }

func StepArgMapValueContentRes(arg interface{}) interface{} { return nil }

func GetElement(x interface{}) interface{} { return nil }

func SetElement(x interface{}) interface{} { return nil }

func GetMapKey(x interface{}) interface{} { return nil }

type A interface {
	Src1() interface{}
	Src2() interface{}
	Src3() (interface{}, interface{})
	SrcArg(arg interface{})
}

type A1 struct{}

func (a *A1) Src1() interface{} { return nil }

func (a *A1) Src2() interface{} { return nil }

func (a *A1) Src3() (interface{}, interface{}) { return nil, nil }

func (a *A1) SrcArg(arg interface{}) {}

type B interface {
	Sink1(arg interface{})
	SinkMethod() interface{}
	SinkManyArgs(arg1 interface{}, arg2 interface{}, arg3 interface{}, arg4 interface{})
}

type C struct {
	F string
}

func (c C) Set(f string) {}
func (c C) Get() string  { return "" }
