package main

type Rectangle struct {
	x, y, width, height int
}

func (r *Rectangle) containsBad(x, y int) bool {
	return r.x <= x &&
		y <= y && // NOT OK
		x <= r.x+r.width &&
		y <= r.y+r.height
}
