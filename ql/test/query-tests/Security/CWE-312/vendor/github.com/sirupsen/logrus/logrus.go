package logrus

func Warning(args ...interface{}) {}

type Fields map[interface{}]interface{}

type Entry struct{}

func WithFields(args ...interface{}) Entry { return Entry{} }
func WithField(args ...interface{}) Entry  { return Entry{} }

func (e Entry) Errorf(args ...interface{}) {}
func (e Entry) Panic(args ...interface{})  {}
