package jet

import (
	"errors"
	"fmt"
	"reflect"
	"sync"
)

// Ranger describes an interface for types that iterate over something.
// Implementing this interface means the ranger will be used when it's
// encountered on the right hand side of a range's "let" expression.
type Ranger interface {
	// Range calls should return a key, a value and a done bool to indicate
	// whether there are more values to be generated.
	//
	// When the done flag is true, then the loop ends.
	Range() (reflect.Value, reflect.Value, bool)

	// ProvidesIndex should return true if keys are produced during Range()
	// calls. This call should be idempotent across Range() calls (i.e.
	// its return value must not change during an iteration).
	ProvidesIndex() bool
}

type intsRanger struct {
	i, val, to int64
}

var _ Ranger = &intsRanger{}

func (r *intsRanger) Range() (index, value reflect.Value, end bool) {
	r.i++
	r.val++
	end = r.val == r.to

	// The indirection in the ValueOf calls avoids an allocation versus
	// using the concrete value of 'i' and 'val'. The downside is having
	// to interpret 'r.i' as "the current value" after Range() returns,
	// and so it needs to be initialized as -1.
	index = reflect.ValueOf(&r.i).Elem()
	value = reflect.ValueOf(&r.val).Elem()
	return
}

func (r *intsRanger) ProvidesIndex() bool { return true }

func newIntsRanger(from, to int64) *intsRanger {
	r := &intsRanger{
		to:  to,
		i:   -1,
		val: from - 1,
	}
	return r
}

type pooledRanger interface {
	Ranger
	Setup(reflect.Value)
}

type sliceRanger struct {
	v reflect.Value
	i int
}

var _ Ranger = &sliceRanger{}
var _ pooledRanger = &sliceRanger{}

func (r *sliceRanger) Setup(v reflect.Value) {
	r.i = 0
	r.v = v
}

func (r *sliceRanger) Range() (index, value reflect.Value, end bool) {
	if r.i == r.v.Len() {
		end = true
		return
	}
	index = reflect.ValueOf(r.i)
	value = r.v.Index(r.i)
	r.i++
	return
}

func (r *sliceRanger) ProvidesIndex() bool { return true }

type mapRanger struct {
	iter    *reflect.MapIter
	hasMore bool
}

var _ Ranger = &mapRanger{}
var _ pooledRanger = &mapRanger{}

func (r *mapRanger) Setup(v reflect.Value) {
	r.iter = v.MapRange()
	r.hasMore = r.iter.Next()
}

func (r *mapRanger) Range() (key, value reflect.Value, end bool) {
	if !r.hasMore {
		end = true
		return
	}
	key, value = r.iter.Key(), r.iter.Value()
	r.hasMore = r.iter.Next()
	return
}

func (r *mapRanger) ProvidesIndex() bool { return true }

type chanRanger struct {
	v reflect.Value
}

var _ Ranger = &chanRanger{}
var _ pooledRanger = &chanRanger{}

func (r *chanRanger) Setup(v reflect.Value) {
	r.v = v
}

func (r *chanRanger) Range() (_, value reflect.Value, end bool) {
	v, ok := r.v.Recv()
	value, end = v, !ok
	return
}

func (r *chanRanger) ProvidesIndex() bool { return false }

// ranger pooling

var (
	poolSliceRanger = &sync.Pool{
		New: func() interface{} {
			return new(sliceRanger)
		},
	}

	poolsByKind = map[reflect.Kind]*sync.Pool{
		reflect.Slice: poolSliceRanger,
		reflect.Array: poolSliceRanger,
		reflect.Map: &sync.Pool{
			New: func() interface{} {
				return new(mapRanger)
			},
		},
		reflect.Chan: &sync.Pool{
			New: func() interface{} {
				return new(chanRanger)
			},
		},
	}
)

func getRanger(v reflect.Value) (r Ranger, cleanup func(), err error) {
	if !v.IsValid() {
		return nil, nil, errors.New("can't range over invalid value")
	}
	t := v.Type()
	if t.Implements(rangerType) {
		return v.Interface().(Ranger), func() { /* no cleanup needed */ }, nil
	}

	v, isNil := indirect(v)
	if isNil {
		return nil, nil, fmt.Errorf("cannot range over nil pointer/interface (%s)", t)
	}

	pool, ok := poolsByKind[v.Kind()]
	if !ok {
		return nil, nil, fmt.Errorf("value %v (type %s) is not rangeable", v, t)
	}

	pr := pool.Get().(pooledRanger)
	pr.Setup(v)
	return pr, func() { pool.Put(pr) }, nil
}
