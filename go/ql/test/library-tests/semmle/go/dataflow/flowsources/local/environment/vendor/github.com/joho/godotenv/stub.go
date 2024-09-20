package godotenv

import "io"

func Exec(filenames []string, cmd string, cmdArgs []string, overload bool) error {
	return nil
}

func Load(filenames ...string) (err error) {
	return nil
}

func Marshal(envMap map[string]string) (string, error) {
	return "", nil
}

func Overload(filenames ...string) (err error) {
	return nil
}

func Parse(r io.Reader) (map[string]string, error) {
	return nil, nil
}

func Read(filenames ...string) (envMap map[string]string, err error) {
	return nil, nil
}

func Unmarshal(str string) (envMap map[string]string, err error) {
	return nil, nil
}

func UnmarshalBytes(src []byte) (map[string]string, error) {
	return nil, nil
}

func Write(envMap map[string]string, filename string) error {
	return nil
}
