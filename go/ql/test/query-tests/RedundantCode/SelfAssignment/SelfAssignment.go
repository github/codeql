package main

type Rect struct {
	x, y, width, height int
}

func (r *Rect) setWidth(width int) {
	r.width = width
}

func (r *Rect) setHeight(height int) {
	height = height
}
