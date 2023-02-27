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

// These used to distinguish strictly-comparable interfaces (i.e. those which will not panic at runtime on attempting a comparison),
// which were required to satisfy the `comparable` type constraint in Go <1.20. Now they all match `comparable` as all interfaces
// are accepted. I mark those which are also strictly comparable for the future in case we want to expose that concept in QL.

type testComparable[T comparable] struct{}            // $ implementsComparable isStrictlyComparable
type testComparable0[T0 i0] struct{}                  // $ implementsComparable isStrictlyComparable
type testComparable1[T1 i1] struct{}                  // $ implementsComparable isStrictlyComparable
type testComparable2[T2 i2] struct{}                  // $ implementsComparable isStrictlyComparable
type testComparable3[T3 i3] struct{}                  // $ implementsComparable isStrictlyComparable
type testComparable4[T4 i4] struct{}                  // $ implementsComparable isStrictlyComparable
type testComparable5[T5 i5] struct{}                  // $ implementsComparable
type testComparable6[T6 i6] struct{}                  // $ implementsComparable
type testComparable7[T7 i7] struct{}                  // $ implementsComparable isStrictlyComparable
type testComparable8[T8 i8] struct{}                  // $ implementsComparable
type testComparable9[T9 i9] struct{}                  // $ implementsComparable
type testComparable10[T10 i10] struct{}               // $ implementsComparable isStrictlyComparable
type testComparable11[T11 i11] struct{}               // $ implementsComparable isStrictlyComparable
type testComparable12[T12 i12] struct{}               // $ implementsComparable
type testComparable13[T13 i13] struct{}               // $ implementsComparable
type testComparable14[T14 i14] struct{}               // $ implementsComparable isStrictlyComparable
type testComparable15[T15 i15] struct{}               // $ implementsComparable isStrictlyComparable
type testComparable16[T16 i16] struct{}               // $ implementsComparable
type testComparable17[T17 i17] struct{}               // $ implementsComparable
type testComparable18[T18 i18] struct{}               // $ implementsComparable isStrictlyComparable
type testComparable19[T19 i19] struct{}               // $ implementsComparable
type testComparable20[T20 i20] struct{}               // $ implementsComparable isStrictlyComparable
type testComparable21[T21 ~[]byte | string] struct{}  // $ implementsComparable
type testComparable22[T22 any] struct{}               // $ implementsComparable
type testComparable23[T23 ~[5]byte | string] struct{} // $ implementsComparable isStrictlyComparable
