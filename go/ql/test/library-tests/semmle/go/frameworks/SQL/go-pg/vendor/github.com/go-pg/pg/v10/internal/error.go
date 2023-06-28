package internal

import (
	"fmt"
)

var (
	ErrNoRows    = Errorf("pg: no rows in result set")
	ErrMultiRows = Errorf("pg: multiple rows in result set")
)

type Error struct {
	s string
}

func Errorf(s string, args ...interface{}) Error {
	return Error{s: fmt.Sprintf(s, args...)}
}

func (err Error) Error() string {
	return err.s
}

type PGError struct {
	m map[byte]string
}

func NewPGError(m map[byte]string) PGError {
	return PGError{
		m: m,
	}
}

func (err PGError) Field(k byte) string {
	return err.m[k]
}

func (err PGError) IntegrityViolation() bool {
	switch err.Field('C') {
	case "23000", "23001", "23502", "23503", "23505", "23514", "23P01":
		return true
	default:
		return false
	}
}

func (err PGError) Error() string {
	return fmt.Sprintf("%s #%s %s",
		err.Field('S'), err.Field('C'), err.Field('M'))
}

func AssertOneRow(l int) error {
	switch {
	case l == 0:
		return ErrNoRows
	case l > 1:
		return ErrMultiRows
	default:
		return nil
	}
}
