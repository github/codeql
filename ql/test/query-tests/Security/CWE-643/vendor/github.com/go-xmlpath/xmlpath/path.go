package xmlpath

type Path struct {
}

func MustCompile(path string) *Path
func Compile(path string) (*Path, error)
