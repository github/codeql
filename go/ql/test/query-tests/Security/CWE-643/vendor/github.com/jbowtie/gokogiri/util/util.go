package util

var EmptyStringBytes = []byte{0}

func AppendCStringTerminator(b []byte) []byte {
	if num := len(b); num > 0 {
		if b[num-1] != 0 {
			return append(b, 0)
		}
	}
	return b
}

func GetCString(b []byte) []byte {
	b = AppendCStringTerminator(b)
	if len(b) == 0 {
		return EmptyStringBytes
	}
	return b
}
