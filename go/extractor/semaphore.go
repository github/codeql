package extractor

import (
	"log"
)

type Unit struct{}

var unit = Unit{}

type semaphore struct {
	counter, lock chan Unit
}

func (s *semaphore) acquire(n int) {
	if s != nil {
		if cap(s.counter) < n {
			log.Fatalf("Tried to acquire more resources than were available.")
		}
		s.lock <- unit
		for i := 0; i < n; i++ {
			s.counter <- unit
		}
		<-s.lock
	}
}

func (s *semaphore) release(n int) {
	if s != nil {
		for i := 0; i < n; i++ {
			<-s.counter
		}
	}
}

func newSemaphore(max int) *semaphore {
	if max > 0 {
		return &semaphore{make(chan Unit, max), make(chan Unit, 1)}
	} else {
		return nil
	}
}
