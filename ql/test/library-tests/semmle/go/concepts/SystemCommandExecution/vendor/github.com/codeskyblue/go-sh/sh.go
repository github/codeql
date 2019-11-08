package sh

type Cmd struct{}

func (*Cmd) Run() {}

func Command(name string, a ...string) *Cmd {
	return nil
}
