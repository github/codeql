type Options struct {}

func Must[T any](t T, err error) T {
	if err != nil {
		panic(err)
	}
	return t
}

func Parse(v interface{}) error {
	return nil
}

func ParseAs[T any]() (T, error) {
	return nil, nil
}

func ParseAsWithOptions[T any](opts Options) (T, error) {
	return nil, nil
}

func ParseWithOptions(v interface{}, opts Options) error {
	return nil
}

func ToMap(env []string) map[string]string {
	return nil
}