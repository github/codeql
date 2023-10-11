package svg

import (
	"math"
	strconvStdlib "strconv"

	"github.com/tdewolff/minify/v2"
	"github.com/tdewolff/parse/v2"
	"github.com/tdewolff/parse/v2/strconv"
)

// PathData represents a path data string.
type PathData struct {
	o *Minifier

	x, y        float64
	x0, y0      float64
	coords      [][]byte
	coordFloats []float64
	cx, cy      float64 // last control point for cubic bezier
	qx, qy      float64 // last control point for quadratic bezier

	state       PathDataState
	curBuffer   []byte
	altBuffer   []byte
	coordBuffer []byte
}

// PathDataState is the state of the current path.
type PathDataState struct {
	cmd            byte
	prevDigit      bool
	prevDigitIsInt bool
	prevFlag       bool
}

// NewPathData returns a new PathData.
func NewPathData(o *Minifier) *PathData {
	return &PathData{
		o:  o,
		cx: math.NaN(),
		cy: math.NaN(),
		qx: math.NaN(),
		qy: math.NaN(),
	}
}

var pathCmds = map[byte]bool{
	'M': true,
	'm': true,
	'L': true,
	'l': true,
	'H': true,
	'h': true,
	'V': true,
	'v': true,
	'Q': true,
	'q': true,
	'T': true,
	't': true,
	'C': true,
	'c': true,
	'S': true,
	's': true,
	'A': true,
	'a': true,
	'Z': true,
	'z': true,
}

// ShortenPathData takes a full pathdata string and returns a shortened version. The original string is overwritten.
// It parses all commands (M, A, Z, ...) and coordinates (numbers) and calls copyInstruction for each command.
func (p *PathData) ShortenPathData(b []byte) []byte {
	if 100000 < len(b) {
		// prevent extremely long paths for being too costly (OSS-Fuzz)
		return b
	}

	var cmd byte
	p.x, p.y = 0.0, 0.0
	p.coords = p.coords[:0]
	p.coordFloats = p.coordFloats[:0]
	p.state = PathDataState{}

	j := 0
	for i := 0; i < len(b); i++ {
		c := b[i]
		if c == ' ' || c == ',' || c == '\n' || c == '\r' || c == '\t' {
			continue
		} else if pathCmds[c] && (cmd == 0 || cmd != c || c == 'M' || c == 'm') { // any command
			if cmd != 0 {
				j += p.copyInstruction(b[j:], cmd)
			}
			cmd = c
			p.coords = p.coords[:0]
			p.coordFloats = p.coordFloats[:0]
		} else if (cmd == 'A' || cmd == 'a') && (len(p.coordFloats)%7 == 3 || len(p.coordFloats)%7 == 4) {
			// boolean flags for arc command
			if c == '1' {
				p.coords = append(p.coords, b[i:i+1])
				p.coordFloats = append(p.coordFloats, 1.0)
			} else if c == '0' {
				p.coords = append(p.coords, b[i:i+1])
				p.coordFloats = append(p.coordFloats, 0.0)
			} else {
				cmd = 0 // bad format, don't minify
			}
		} else if n := parse.Number(b[i:]); n > 0 {
			f, _ := strconv.ParseFloat(b[i : i+n])
			p.coords = append(p.coords, b[i:i+n])
			p.coordFloats = append(p.coordFloats, f)
			i += n - 1
		}
	}
	if cmd == 0 {
		return b
	}
	j += p.copyInstruction(b[j:], cmd)
	return b[:j]
}

// copyInstruction copies pathdata of a single command, but may be comprised of multiple sets for that command. For example, L takes two coordinates, but this function may process 2*N coordinates. Lowercase commands are relative commands, where the coordinates are relative to the previous point. Uppercase commands have absolute coordinates.
// We update p.x and p.y (the current coordinates) according to the commands given. For each set of coordinates we call shortenCurPosInstruction and shortenAltPosInstruction. The former just minifies the coordinates, the latter will inverse the lowercase/uppercase of the command, and see if the coordinates get smaller due to that. The shortest is chosen and copied to b, i.e. b is the destination and is not read from.
func (p *PathData) copyInstruction(b []byte, cmd byte) int {
	n := len(p.coords)
	if n == 0 {
		if cmd == 'Z' || cmd == 'z' {
			p.x = p.x0
			p.y = p.y0
			b[0] = 'z'
			return 1
		}
		return 0
	}
	isRelCmd := cmd >= 'a'

	// get new cursor coordinates
	di := 0
	if (cmd == 'M' || cmd == 'm' || cmd == 'L' || cmd == 'l' || cmd == 'T' || cmd == 't') && n%2 == 0 {
		di = 2
		// reprint M always, as the first pair is a move but subsequent pairs are L
		if cmd == 'M' || cmd == 'm' {
			p.state.cmd = byte(0)
		}
	} else if cmd == 'H' || cmd == 'h' || cmd == 'V' || cmd == 'v' {
		di = 1
	} else if (cmd == 'S' || cmd == 's' || cmd == 'Q' || cmd == 'q') && n%4 == 0 {
		di = 4
	} else if (cmd == 'C' || cmd == 'c') && n%6 == 0 {
		di = 6
	} else if (cmd == 'A' || cmd == 'a') && n%7 == 0 {
		di = 7
	} else {
		return 0
	}

	j := 0
	origCmd := cmd
	for i := 0; i < n; i += di {
		// subsequent coordinate pairs for M are really L
		if i > 0 && (origCmd == 'M' || origCmd == 'm') {
			origCmd = 'L' + (origCmd - 'M')
		}

		cmd = origCmd
		coords := p.coords[i : i+di]
		coordFloats := p.coordFloats[i : i+di]

		// set next coordinate
		var ax, ay float64
		if cmd == 'H' || cmd == 'h' {
			ax = coordFloats[di-1]
			if isRelCmd {
				ax += p.x
			}
			ay = p.y
		} else if cmd == 'V' || cmd == 'v' {
			ax = p.x
			ay = coordFloats[di-1]
			if isRelCmd {
				ay += p.y
			}
		} else {
			ax = coordFloats[di-2]
			ay = coordFloats[di-1]
			if isRelCmd {
				ax += p.x
				ay += p.y
			}
		}

		// switch from C to S whenever possible
		if cmd == 'C' || cmd == 'c' || cmd == 'S' || cmd == 's' {
			if math.IsNaN(p.cx) {
				p.cx, p.cy = p.x, p.y
			} else {
				p.cx, p.cy = 2*p.x-p.cx, 2*p.y-p.cy
			}

			var cp1x, cp1y float64
			cp2x, cp2y := coordFloats[di-4], coordFloats[di-3]
			if isRelCmd {
				cp2x += p.x
				cp2y += p.y
			}
			if cmd == 'C' || cmd == 'c' {
				cp1x, cp1y = coordFloats[di-6], coordFloats[di-5]
				if isRelCmd {
					cp1x += p.x
					cp1y += p.y
				}
				if cp1x == p.cx && cp1y == p.cy {
					if isRelCmd {
						cmd = 's'
					} else {
						cmd = 'S'
					}
					coords = coords[2:]
					coordFloats = coordFloats[2:]
				}
			} else {
				cp1x, cp1y = p.cx, p.cy
			}

			// if control points overlap begin/end points, this is a straight line
			// even though if the control points would be along the straight line, we won't minify that as the control points influence the speed along the curve (important for dashes for example)
			// only change to a lines if we start with s or S and none follow
			if (cmd == 'C' || cmd == 'c' || i == 0 && i+di >= n) && (cp1x == p.x && cp1y == p.y || cp1x == ax && cp1y == ay) && (cp2x == p.x && cp2y == p.y || cp2x == ax && cp2y == ay) {
				if isRelCmd {
					cmd = 'l'
				} else {
					cmd = 'L'
				}
				coords = coords[len(coords)-2:]
				coordFloats = coordFloats[len(coordFloats)-2:]
				cp2x, cp2y = math.NaN(), math.NaN()
			}
			p.cx, p.cy = cp2x, cp2y
		} else {
			p.cx, p.cy = math.NaN(), math.NaN()
		}

		// switch from Q to T whenever possible
		if cmd == 'Q' || cmd == 'q' || cmd == 'T' || cmd == 't' {
			if math.IsNaN(p.qx) {
				p.qx, p.qy = p.x, p.y
			} else {
				p.qx, p.qy = 2*p.x-p.qx, 2*p.y-p.qy
			}

			var cpx, cpy float64
			if cmd == 'Q' || cmd == 'q' {
				cpx, cpy = coordFloats[di-4], coordFloats[di-3]
				if isRelCmd {
					cpx += p.x
					cpy += p.y
				}
				if cpx == p.qx && cpy == p.qy {
					if isRelCmd {
						cmd = 't'
					} else {
						cmd = 'T'
					}
					coords = coords[2:]
					coordFloats = coordFloats[2:]
				}
			} else {
				cpx, cpy = p.qx, p.qy
			}

			// if control point overlaps begin/end points, this is a straight line
			// even if the control point would be along the straight line, we won't minify that as the control point influences the speed along the curve (important for dashes for example)
			// only change to line if we start with t or T and none follow
			if (cmd == 'Q' || cmd == 'q' || i == 0 && i+di >= n) && (cpx == p.x && cpy == p.y || cpx == ax && cpy == ay) {
				if isRelCmd {
					cmd = 'l'
				} else {
					cmd = 'L'
				}
				coords = coords[len(coords)-2:]
				coordFloats = coordFloats[len(coordFloats)-2:]
				cpx, cpy = math.NaN(), math.NaN()
			}
			p.qx, p.qy = cpx, cpy
		} else {
			p.qx, p.qy = math.NaN(), math.NaN()
		}

		// switch from L to H or V whenever possible
		if cmd == 'L' || cmd == 'l' {
			if ax == p.x && ay == p.y {
				continue
			} else if ax == p.x {
				if isRelCmd {
					cmd = 'v'
				} else {
					cmd = 'V'
				}
				coords = coords[1:]
				coordFloats = coordFloats[1:]
			} else if ay == p.y {
				if isRelCmd {
					cmd = 'h'
				} else {
					cmd = 'H'
				}
				coords = coords[:1]
				coordFloats = coordFloats[:1]
			}
		}

		// make a current and alternated path with absolute/relative altered
		var curState, altState PathDataState
		curState = p.shortenCurPosInstruction(cmd, coords)
		if isRelCmd {
			altState = p.shortenAltPosInstruction(cmd-'a'+'A', coordFloats, p.x, p.y)
		} else {
			altState = p.shortenAltPosInstruction(cmd-'A'+'a', coordFloats, -p.x, -p.y)
		}

		// choose shortest, relative or absolute path?
		if len(p.altBuffer) < len(p.curBuffer) {
			j += copy(b[j:], p.altBuffer)
			p.state = altState
		} else {
			j += copy(b[j:], p.curBuffer)
			p.state = curState
		}

		p.x = ax
		p.y = ay
		if i == 0 && (origCmd == 'M' || origCmd == 'm') {
			p.x0 = p.x
			p.y0 = p.y
		}
	}
	return j
}

// shortenCurPosInstruction only minifies the coordinates.
func (p *PathData) shortenCurPosInstruction(cmd byte, coords [][]byte) PathDataState {
	state := p.state
	p.curBuffer = p.curBuffer[:0]
	if cmd != state.cmd && !(state.cmd == 'M' && cmd == 'L' || state.cmd == 'm' && cmd == 'l') {
		p.curBuffer = append(p.curBuffer, cmd)
		state.cmd = cmd
		state.prevDigit = false
		state.prevDigitIsInt = false
	}
	for i, coord := range coords {
		// Arc has boolean flags that can only be 0 or 1. copyFlag prevents from adding a dot before a zero (instead of a space). However, when the dot already was there, the command is malformed and could make the path longer than before, introducing bugs.
		if (cmd == 'A' || cmd == 'a') && (i%7 == 3 || i%7 == 4) {
			state.copyFlag(&p.curBuffer, coord[0] == '1')
			continue
		}

		coord = minify.Number(coord, p.o.Precision)
		state.copyNumber(&p.curBuffer, coord)
	}
	return state
}

// shortenAltPosInstruction toggles the command between absolute / relative coordinates and minifies the coordinates.
func (p *PathData) shortenAltPosInstruction(cmd byte, coordFloats []float64, x, y float64) PathDataState {
	state := p.state
	p.altBuffer = p.altBuffer[:0]
	if cmd != state.cmd && !(state.cmd == 'M' && cmd == 'L' || state.cmd == 'm' && cmd == 'l') {
		p.altBuffer = append(p.altBuffer, cmd)
		state.cmd = cmd
		state.prevDigit = false
		state.prevDigitIsInt = false
	}
	for i, f := range coordFloats {
		if cmd == 'L' || cmd == 'l' || cmd == 'C' || cmd == 'c' || cmd == 'S' || cmd == 's' || cmd == 'Q' || cmd == 'q' || cmd == 'T' || cmd == 't' || cmd == 'M' || cmd == 'm' {
			if i%2 == 0 {
				f += x
			} else {
				f += y
			}
		} else if cmd == 'H' || cmd == 'h' {
			f += x
		} else if cmd == 'V' || cmd == 'v' {
			f += y
		} else if cmd == 'A' || cmd == 'a' {
			if i%7 == 5 {
				f += x
			} else if i%7 == 6 {
				f += y
			} else if i%7 == 3 || i%7 == 4 {
				state.copyFlag(&p.altBuffer, f == 1.0)
				continue
			}
		}

		p.coordBuffer = strconvStdlib.AppendFloat(p.coordBuffer[:0], f, 'g', -1, 64)
		coord := minify.Number(p.coordBuffer, p.o.newPrecision)
		state.copyNumber(&p.altBuffer, coord)
	}
	return state
}

// copyNumber will copy a number to the destination buffer, taking into account space or dot insertion to guarantee the shortest pathdata.
func (state *PathDataState) copyNumber(buffer *[]byte, coord []byte) {
	if state.prevDigit && (coord[0] >= '0' && coord[0] <= '9' || coord[0] == '.' && state.prevDigitIsInt) {
		if coord[0] == '0' && !state.prevDigitIsInt {
			*buffer = append(*buffer, '.', '0') // aggresively add dot so subsequent numbers could drop leading space
			// prevDigit stays true and prevDigitIsInt stays false
			return
		}
		*buffer = append(*buffer, ' ')
	}
	state.prevDigit = true
	state.prevDigitIsInt = true
	if len(coord) > 2 && coord[len(coord)-2] == '0' && coord[len(coord)-1] == '0' {
		coord[len(coord)-2] = 'e'
		coord[len(coord)-1] = '2'
		state.prevDigitIsInt = false
	} else {
		for _, c := range coord {
			if c == '.' || c == 'e' || c == 'E' {
				state.prevDigitIsInt = false
				break
			}
		}
	}
	*buffer = append(*buffer, coord...)
	state.prevFlag = false
}

func (state *PathDataState) copyFlag(buffer *[]byte, flag bool) {
	if !state.prevFlag {
		if flag {
			*buffer = append(*buffer, ' ', '1')
		} else {
			*buffer = append(*buffer, ' ', '0')
		}
	} else {
		if flag {
			*buffer = append(*buffer, '1')
		} else {
			*buffer = append(*buffer, '0')
		}
	}
	state.prevFlag = true
	state.prevDigit = false
	state.prevDigitIsInt = false
}
