package types

import (
	"time"

	"github.com/go-pg/pg/v10/internal"
)

const (
	dateFormat         = "2006-01-02"
	timeFormat         = "15:04:05.999999999"
	timestampFormat    = "2006-01-02 15:04:05.999999999"
	timestamptzFormat  = "2006-01-02 15:04:05.999999999-07:00:00"
	timestamptzFormat2 = "2006-01-02 15:04:05.999999999-07:00"
	timestamptzFormat3 = "2006-01-02 15:04:05.999999999-07"
)

func ParseTime(b []byte) (time.Time, error) {
	s := internal.BytesToString(b)
	return ParseTimeString(s)
}

func ParseTimeString(s string) (time.Time, error) {
	switch l := len(s); {
	case l <= len(timeFormat):
		if s[2] == ':' {
			return time.ParseInLocation(timeFormat, s, time.UTC)
		}
		return time.ParseInLocation(dateFormat, s, time.UTC)
	default:
		if s[10] == 'T' {
			return time.Parse(time.RFC3339Nano, s)
		}
		if c := s[l-9]; c == '+' || c == '-' {
			return time.Parse(timestamptzFormat, s)
		}
		if c := s[l-6]; c == '+' || c == '-' {
			return time.Parse(timestamptzFormat2, s)
		}
		if c := s[l-3]; c == '+' || c == '-' {
			return time.Parse(timestamptzFormat3, s)
		}
		return time.ParseInLocation(timestampFormat, s, time.UTC)
	}
}

func AppendTime(b []byte, tm time.Time, flags int) []byte {
	if flags == 1 {
		b = append(b, '\'')
	}
	b = tm.UTC().AppendFormat(b, timestamptzFormat)
	if flags == 1 {
		b = append(b, '\'')
	}
	return b
}
