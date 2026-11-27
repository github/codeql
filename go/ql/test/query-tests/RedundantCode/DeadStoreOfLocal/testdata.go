// adapted from https://raw.githubusercontent.com/gordonklaus/ineffassign/master/testdata/testdata.go

package p

var b bool

func deadStore() int {
	return 0
}

func deadStore2() string {
	return "abc"
}

func _() {
	var x int
	x = 0
	_ = x
}

func _() {
	var x int
	x = 0
	if b {
		_ = x
	}
}

func _() {
	var x int
	_ = x
	x = deadStore() // $ Alert // BAD
}

func _() {
	var x int
	x = deadStore() // $ Alert // BAD
	x = 0
	_ = x
}

func _() {
	x := 0
	x = 0
	_ = x
}

func _() {
	x := int64(0)
	x = 0
	_ = x
}

func _() {
	x := ""
	x = "abc"
	_ = x
}

func _() {
	x := deadStore2() // $ Alert // BAD
	x = "def"
	_ = x
}

func _() {
	x := deadStore() // $ Alert // BAD
	x = 0
	_ = x
}

func _() {
	x := 0
	x = x + 0
	_ = x
}

func _() {
	x := 0
	x += 0
	_ = x
}

func _() {
	x := 0
	x++
	_ = x
}

func _() {
	x := 0
	if b {
		x = 0
	}
	_ = x
}

func _() {
	x := deadStore() // $ Alert // BAD
	if b {
		x = deadStore() // $ Alert // BAD
	}
	x = 0
	_ = x
}

func _() {
	x := deadStore() // $ Alert // BAD
	for b {
		x = deadStore() // $ Alert // BAD
	}
	x = 0
	_ = x
}

func _() {
	x := 0
	if b {
		x = 0
	}
	if b {
		x = 0
	}
	_ = x
}

func _() {
	x := deadStore() // $ Alert // BAD
	if b {
		x = deadStore() // $ Alert // BAD
		x = deadStore() // $ Alert // BAD
	}
	if b {
		x = deadStore() // $ Alert // BAD
	}
	x = 0
	_ = x
}

func _() {
	x := 0
	if b {
		x = deadStore() // $ Alert // BAD
		x = 0
	}
	if b {
		x = 0
	}
	_ = x
}

func _() {
	x := 0
	for {
		_ = x
		x = 0
	}
}

func _() {
	x := 0
	for {
		_ = x
		x = deadStore() // $ Alert // BAD
		x = 0
	}
}

func _() {
	x := 0
	for {
		x += deadStore() // $ Alert // BAD
		x = 0
	}
}

func _() {
	x := 0
	for {
		x++ // $ Alert // BAD
		x = 0
	}
}

func _() {
	x := 0
	for {
		x++
	}
}

func _() {
	x := 0
	_ = &x
	x = 0
}

func _() {
	x := struct{ f int }{42}
	_ = x.f
	x = struct{ f int }{23} // $ Alert
}

func _() {
	x := []int{2}
	_ = &x[0]
	x = []int{}
}

func _() {
	x := []int{}
	_ = x[:]
	x = []int{}
}

func _() {
	x := 0
	func() {
		_ = x
	}()
	x = 0
}

func _() {
	x := 0
	func() {
		x++
	}()
	x = 0
}

func _() {
	x := 0
	func() {
		x += 0
	}()
	x = 0
}

func _() {
	x := 0
	func() {
		x = 0
	}()
	_ = x
}

func _() {
	x := 0
	_ = x
	func() {
		x = 0
	}()
}

func _() (x int) {
	x = 0
	return
}

func _() (x int) {
	x = deadStore() // $ Alert // BAD
	x = 0
	return
}

func _() (x int) {
	x = deadStore() // $ Alert // BAD
	return 0
}

func _() (x int) {
	x = 0
	return x
}

func _() (x int) {
	x = 1
	anyFunctionMightPanic()
	return 2
}

func _(a []int, i int) (x int) {
	x = 1
	_ = a[i]
	return 2
}

func _(a []string, i int, j int) (x int) {
	x = 1
	_ = a[i:j]
	return 2
}

func _(a float32, b float32) (x int) {
	x = 1
	_ = a == b
	return 2
}

func _(a float32, b float32) (x int) {
	x = 1
	_ = a / b
	return 2
}

func _(a float32, b float32) (x int) {
	x = 1
	a /= b // $ Alert
	return 2
}

func _(a int, b int) (x int) {
	x = 1
	_ = a % b
	return 2
}

func _(a int, b int) (x int) {
	x = 1
	a %= b // $ Alert
	return 2
}

func _(a struct{ b int }) (x int) {
	x = 1
	_ = a.b
	return 2
}

func _(a *int) (x int) {
	x = 1
	_ = *a
	return 2
}

func _(a interface{}) (x int) {
	x = 1
	_ = a.(int)
	return 2
}

func _(a chan int, b int) (x int) {
	x = 1
	a <- b
	return 2
}

func _() {
	global = 0
}

var global int

func _() {
	global = 0
	global = 0
}

func _() {
	var x int
	if b {
		x = 0
	} else {
		x = 0
	}
	_ = x
}

func _() {
	var x int
	switch b {
	case true:
		x = 0
	case false:
		x = 0
	}
	_ = x
}

func _() {
	var x int
	switch b {
	case true:
		_ = x
	default:
		x = deadStore() // $ Alert // BAD
		fallthrough
	case b:
	}
}

func _() {
	var x int
	switch b {
	default:
		x = 0
		fallthrough
	case b:
		_ = x
	}
}

func _() {
	var x int
	switch interface{}(b).(type) {
	case bool:
		x = 0
	case int:
		x = 0
	}
	_ = x
}

func _() {
	var x int
	var ch chan int
	select {
	case ch <- 0:
		x = 0
	case <-ch:
		x = 0
	}
	_ = x
}

func _() {
	var x int
	var ch chan int
	select {
	case ch <- 0:
		x = deadStore() // $ Alert // BAD
	case <-ch:
		x = deadStore() // $ Alert // BAD
	default:
		_ = x
	}
}

func _() {
	x := deadStore() // $ Alert // BAD
	var ch chan int
	select {
	case ch <- 0:
		x = 0
	case <-ch:
		x = 0
	default:
		x = 0
	}
	_ = x
}

func _() {
	x := 0
	var ch chan int
	select {
	case ch <- 0:
		x = 0
	case <-ch:
		x = 0
	}
	_ = x
}

func _() (x int) {
	if b {
		x = 0
		return
	}
	x = 0
	return
}

func _() {
	var x int
	if b {
		x = 0
	} else if x = 0; b {

	}
	_ = x
}

func _() {
	var x int
	if b {
		x = deadStore() // $ Alert // BAD
	}
	if x = 0; b {

	}
	_ = x
}

func _() {
	var x int
	if b {
		x = 0
	} else if b {
		x = 0
	}
	_ = x
}

func _() {
	var x int
	if b {
		x = 0
	} else {
		x = 0
	}
	_ = x
}

func _() {
	x := 0
	for b {
		_ = x
		x = 0
	}
	x = 0
	_ = x
}

func _() {
	x := 0
	for {
		_ = x
		x = 0
		if b {
			break
		}
		x = 0
	}
	_ = x
}

func _() {
	x := 0
	for x < 0 {
		x = deadStore() // $ Alert // BAD
		if b {
			break
		}
		x = 0
	}
}

func _() {
	x := 0
	for {
		_ = x
		x = 0
		if b {
			continue
		}
		x = 0
	}
}

func _() {
	var x int
	for x = range []int{} {
		_ = x
		x = 0
		if b {
			continue
		} else {
			break
		}
	}
	_ = x
}

func _() {
	var x int
	for {
		if b {
			x = deadStore() // $ Alert // BAD
			break
		}
		_ = x
	}
}

func _() {
	var x int
loop:
	for b {
		_ = x
		for b {
			x = 0
			break loop
		}
		x = 0
	}
	_ = x
}

func _() {
	var x int
	for range []int{} {
		if b {
			x = 0
			continue
		}
		x = 0
	}
	_ = x
}

func _(v1, v2 int32) (int32, int32) {
	if v1 > v2 {
		v1, _ = v2, v1
	}
	return v1, v2
}

func _(v1, v2 int32) (int32, int32) {
	if v1 > v2 {
		_, v1 = v2, v1
	}
	return v1, v2
}

func _(v1, v2 int32) (int32, int32) {
	if v1 > v2 {
		v1, _ = v2, v1 // $ Alert
	}
	v1, v2 = 0, 0
	return v1, v2
}

func anyFunctionMightPanic()

func capturedInitialization() {
	x := deadStore() // $ MISSING: Alert
	x = usedValue()
	read := func() { _ = x }
	read()
}

func capturedWriteBack() int {
	x := 0
	update := func() { x = usedValue() }
	update()
	return x
}

func usedValue() int { return 1 }

func overwrittenCapturedWrites() int {
	x := 0
	update := func() {
		x = deadStore() // $ MISSING: Alert
		x = 1
		x = deadStore() // $ MISSING: Alert
		if b {
			x = 2
		} else {
			x = 3
		}
		for b {
			x = deadStore() // $ MISSING: Alert
			x = 4
		}
	}
	update()
	return x
}

func overwrittenAfterClosureCreation() {
	y := usedValue()
	x := deadStore() // $ MISSING: Alert
	read := func() { _ = x }
	x = y
	read()
}

func returnedClosureCapturesWrite() func() int {
	x := usedValue()
	return func() int { return x }
}

func conditionallyOverwrittenCapture() int {
	x := 0
	update := func() {
		x = usedValue()
		if b {
			x = 1
		}
	}
	update()
	return x
}

func observedCapturedWrite() int {
	x := 0
	read := func() { _ = x }
	update := func() {
		x = usedValue()
		read()
		x = 1
		x = usedValue()
		_ = x
		x = 2
	}
	update()
	return x
}

func panickingCapturedOverwrite(xs []int, i int) {
	x := 0
	defer func() { _ = x }()
	update := func() {
		x = usedValue()
		_ = xs[i]
		x = 1
	}
	update()
}

func deferredReadAfterCapturedOverwrite() int {
	x := 0
	update := func() {
		x = deadStore() // $ MISSING: Alert
		defer func() { _ = x }()
		x = 1
	}
	update()
	return x
}

func storedClosureBeforeWrite() map[string]func() int {
	var x int
	handlers := map[string]func() int{"read": func() int { return x }}
	x = usedValue()
	return handlers
}

func registeredClosureBeforeWrite(register func(func() int)) {
	var x int
	register(func() int { return x })
	x = usedValue()
}

func goroutineBeforeWrite() {
	var x int
	ready := make(chan struct{})
	go func() {
		<-ready
		global = x
	}()
	x = usedValue()
	ready <- struct{}{}
}
