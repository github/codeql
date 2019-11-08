package main

func (r *Rectangle) containsGood(x, y int) bool {
	return r.x <= x &&
		r.y <= y &&
		x <= r.x+r.width &&
		y <= r.y+r.height
}
