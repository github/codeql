package sh

type Session struct{}

func InteractiveSession() *Session {
	return &Session{}
}

func Command(name string, a ...interface{}) *Session {
	s := &Session{}
	return s.Command(name, a...)
}
func (s *Session) Command(name string, a ...interface{}) *Session {
	return s
}

// combine Command and Run
func (s *Session) Call(name string, a ...interface{}) error {
	return s.Command(name, a...).Run()
}
func (s *Session) Run() (err error) {
	return nil
}
