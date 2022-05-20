package main

type I interface {
	m() // name: I.m
}

type s1 struct{}

type s2 struct{}

type s3 struct{}

type mybool bool

func (s1) m() {} // name: s1.m

func (*s2) m() {} // name: s2.m

func (s3) m(int) {} // name: s3.m

func (mybool) m() {} // name: mybool.m

func test(x *s1, y s2, z s3, b mybool, i I) {
	x.m()                              // callee: s1.m
	y.m()                              // callee: s2.m
	z.m(0)                             // callee: s3.m
	b.m()                              // callee: mybool.m
	i.m()                              // callee: s1.m callee: s2.m callee: mybool.m
	s1.m(*x)                           // callee: s1.m
	s3.m(z, 0)                         // callee: s3.m
	mybool.m(b)                        // callee: mybool.m
	(func() {})()                      // name: func(){} callee: func(){}
	id := func(x int) int { return x } // name: id
	id(1)                              // callee: id
}

func test2(v interface{}) {
	v.(interface{ m(int) }).m(0) // callee: s3.m
}

func test3(v I) {
	if v == nil {
		v = s1{}
		v.m() // callee: s1.m
	}
	v.m() // callee: s1.m callee: s2.m callee: mybool.m
}

func test4(b bool) {
	var v I
	if b {
		v = s1{}
	} else {
		v = &s2{}
	}
	v.m() // callee: s1.m callee: s2.m
}
