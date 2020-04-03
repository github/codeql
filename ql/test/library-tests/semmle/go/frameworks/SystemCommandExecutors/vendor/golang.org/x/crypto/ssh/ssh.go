package ssh

type Session struct{}

func (s *Session) CombinedOutput(cmd string) ([]byte, error) {
	return nil, nil
}
func (s *Session) Output(cmd string) ([]byte, error) {
	return nil, nil
}
func (s *Session) Run(cmd string) error {
	return nil
}
func (s *Session) Start(cmd string) error {
	return nil
}
