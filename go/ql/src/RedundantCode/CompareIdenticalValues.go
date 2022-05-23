package main

type Rectangle struct {
	x, y, width, height float64
}

func (r *Rectangle) containsBad(x, y float64) bool {
	return r.x <= x &&
		y <= y &&
		x <= r.x+r.width &&
		y <= r.y+r.height
}
