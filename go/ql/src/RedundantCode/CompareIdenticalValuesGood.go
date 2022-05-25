package main

func (r *Rectangle) containsGood(x, y float64) bool {
	return r.x <= x &&
		r.y <= y &&
		x <= r.x+r.width &&
		y <= r.y+r.height
}
