func getSubSlice(buf []byte, start int, offset int) []byte {
	if(start + offset < start) {
		return nil
	}
	return buf[start:start + offset]
}