package main

type wrapper struct {
	s    string
	hash int
}

func mkWrapper() (w wrapper) {
	w.hash = -1 // OK
	return
}

func (w wrapper) reset2() wrapper {
	w.hash = -1 // OK
	return w
}

func (w wrapper) reset3(out *wrapper) {
	w.hash = -1 // OK
	*out = w
}

func sameHash(w1, w2 wrapper) bool {
	w1.s = "" // OK
	w2.s = "" // OK
	return w1 == w2
}

func lookup(cs map[wrapper]int, w wrapper) int {
	w.hash = -1 // OK
	return cs[w]
}

func send(ch chan<- wrapper, w wrapper) {
	w.hash = -1 // OK
	ch <- w
}

func test() (w wrapper) {
	defer (func() {
		w.hash = -1 // OK
	})()
	return wrapper{}
}

func test2() (w wrapper) {
	w.hash = -1 // NOT OK, but not currently flagged because w is a result variable
	return wrapper{"hi", 0}
}

var cbs = make([]func() string, 10, 10)

func (w *wrapper) getString() string {
	return w.s
}

func test3() {
	w := wrapper{"hi", 0}
	w.hash = -1 // OK
	cbs = append(cbs, w.getString)
}

type wrapperPtr *wrapper

func test4(p wrapperPtr) {
	p.hash = -1 // OK
}

func test5(w wrapper) int {
	w.hash = -1
	return w.hash
}

type S struct {
	x int
}

type T struct {
	*S
}

func (t T) reset() {
	t.x = 0 // OK: field is promoted through pointer type
}

func test6() int {
	t := T{&S{1}}
	t.reset()
	return t.x
}
