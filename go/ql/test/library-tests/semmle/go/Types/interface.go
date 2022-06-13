package main

type i0 comparable

type i1 interface {
	int
}

type i2 interface {
	~string
}

type i3 interface {
	[5]int | ~string
}

// typeset: int | ~string | float32
type i4 interface {
	i1 | i2 | float32
}

// typeset: []byte
type i5 interface {
	int | ~[]byte
	[]byte
}

type i6 interface {
	~[]int | ~string
	String() string
}

// typeset: ~string
type i7 interface {
	i3
	~string
	String() string
}

// typeset: ~[]int | ~string
type i8 interface {
	i6
	StringA() string
}

// typeset: ~[]int | ~string
type i9 interface {
	i6
	StringB() string
}

type i10 interface {
	comparable
}

// typeset: the empty set
type i11 interface {
	[5]byte | string
	int
}

// typeset: []byte | string
type i12 interface {
	[]byte | string
	comparable
}

// typeset: []byte | string
type i13 interface {
	[]byte | string
	i10
}

// typeset: string
type i14 interface {
	[]byte | string
	i8
}

// typeset: string
type i15 interface {
	[]byte | string
	i9
}

// The empty interface does not implement comparable
type i16 interface {
}

// A basic interface, so not comparable
type i17 interface {
	StringA() string
}

type i18 interface {
	comparable
	StringA() string
}

// A basic interface, so not comparable
type i19 interface {
	StringB() string
}

type i20 interface {
	comparable
	StringB() string
}

type testComparable[T comparable] struct{}            // $ implementsComparable
type testComparable0[T0 i0] struct{}                  // $ implementsComparable
type testComparable1[T1 i1] struct{}                  // $ implementsComparable
type testComparable2[T2 i2] struct{}                  // $ implementsComparable
type testComparable3[T3 i3] struct{}                  // $ implementsComparable
type testComparable4[T4 i4] struct{}                  // $ implementsComparable
type testComparable5[T5 i5] struct{}                  // does not implement comparable
type testComparable6[T6 i6] struct{}                  // does not implement comparable
type testComparable7[T7 i7] struct{}                  // $ implementsComparable
type testComparable8[T8 i8] struct{}                  // does not implement comparable
type testComparable9[T9 i9] struct{}                  // does not implement comparable
type testComparable10[T10 i10] struct{}               // $ implementsComparable
type testComparable11[T11 i11] struct{}               // $ implementsComparable
type testComparable12[T12 i12] struct{}               // does not implement comparable
type testComparable13[T13 i13] struct{}               // does not implement comparable
type testComparable14[T14 i14] struct{}               // $ implementsComparable
type testComparable15[T15 i15] struct{}               // $ implementsComparable
type testComparable16[T16 i16] struct{}               // does not implement comparable
type testComparable17[T17 i17] struct{}               // does not implement comparable
type testComparable18[T18 i18] struct{}               // $ implementsComparable
type testComparable19[T19 i19] struct{}               // does not implement comparable
type testComparable20[T20 i20] struct{}               // $ implementsComparable
type testComparable21[T21 ~[]byte | string] struct{}  // does not implement comparable
type testComparable22[T22 any] struct{}               // does not implement comparable
type testComparable23[T23 ~[5]byte | string] struct{} // $ implementsComparable
