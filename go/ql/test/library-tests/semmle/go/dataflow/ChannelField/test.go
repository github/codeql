package test

type State struct {
	c chan string
}

func handler(s *State) {

	sink(<-s.c)

}

func requester(s *State) {

	data := source()
	s.c <- data

}

func source() string {

	return "tainted"

}

func sink(s string) {}
