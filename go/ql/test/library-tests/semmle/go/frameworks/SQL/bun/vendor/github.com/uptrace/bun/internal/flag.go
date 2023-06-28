package internal

type Flag uint64

func (flag Flag) Has(other Flag) bool {
	return flag&other != 0
}

func (flag Flag) Set(other Flag) Flag {
	return flag | other
}

func (flag Flag) Remove(other Flag) Flag {
	flag &= ^other
	return flag
}
