package main

import (
	"fmt"
	"math"
	"strconv"
)

func main() {

}

type something struct {
}
type config struct {
}
type registry struct {
}

func lookupTarget(conf *config, num int32) (int32, error) {
	return 567, nil
}
func lookupNumberByName(reg *registry, name string) (int32, error) {
	return 567, nil
}
func lab(s string) (*something, error) {
	num, err := strconv.Atoi(s)

	if err != nil {
		number, err := lookupNumberByName(&registry{}, s)
		if err != nil {
			return nil, err
		}
		num = int(number)
	}
	target, err := lookupTarget(&config{}, int32(num)) // $ hasValueFlow="type conversion"
	if err != nil {
		return nil, err
	}

	// convert the resolved target number back to a string

	s = strconv.Itoa(int(target))

	return nil, nil
}

func testParseInt() {
	{
		parsed, err := strconv.ParseInt("3456", 10, 8)
		if err != nil {
			panic(err)
		}
		_ = int8(parsed)
		_ = uint8(parsed)
		_ = int16(parsed)
		_ = uint16(parsed)
		_ = int32(parsed)
		_ = uint32(parsed)
		_ = int64(parsed)
		_ = uint64(parsed)
		_ = int(parsed)
		_ = uint(parsed)
	}
	{
		parsed, err := strconv.ParseInt("3456", 10, 16)
		if err != nil {
			panic(err)
		}
		_ = int8(parsed)  // $ hasValueFlow="type conversion"
		_ = uint8(parsed) // $ hasValueFlow="type conversion"
		_ = int16(parsed)
		_ = uint16(parsed)
		_ = int32(parsed)
		_ = uint32(parsed)
		_ = int64(parsed)
		_ = uint64(parsed)
		_ = int(parsed)
		_ = uint(parsed)
	}
	{
		parsed, err := strconv.ParseInt("3456", 10, 32)
		if err != nil {
			panic(err)
		}
		_ = int8(parsed)   // $ hasValueFlow="type conversion"
		_ = uint8(parsed)  // $ hasValueFlow="type conversion"
		_ = int16(parsed)  // $ hasValueFlow="type conversion"
		_ = uint16(parsed) // $ hasValueFlow="type conversion"
		_ = int32(parsed)
		_ = uint32(parsed)
		_ = int64(parsed)
		_ = uint64(parsed)
		_ = int(parsed)
		_ = uint(parsed)
	}
	{
		parsed, err := strconv.ParseInt("3456", 10, 64)
		if err != nil {
			panic(err)
		}
		_ = int8(parsed)   // $ hasValueFlow="type conversion"
		_ = uint8(parsed)  // $ hasValueFlow="type conversion"
		_ = int16(parsed)  // $ hasValueFlow="type conversion"
		_ = uint16(parsed) // $ hasValueFlow="type conversion"
		_ = int32(parsed)  // $ hasValueFlow="type conversion"
		_ = uint32(parsed) // $ hasValueFlow="type conversion"
		_ = int64(parsed)
		_ = uint64(parsed)
		_ = int(parsed)  // $ hasValueFlow="type conversion"
		_ = uint(parsed) // $ hasValueFlow="type conversion"
	}
	{
		parsed, err := strconv.ParseInt("3456", 10, 0)
		if err != nil {
			panic(err)
		}
		_ = int8(parsed)   // $ hasValueFlow="type conversion"
		_ = uint8(parsed)  // $ hasValueFlow="type conversion"
		_ = int16(parsed)  // $ hasValueFlow="type conversion"
		_ = uint16(parsed) // $ hasValueFlow="type conversion"
		_ = int32(parsed)  // $ hasValueFlow="type conversion"
		_ = uint32(parsed) // $ hasValueFlow="type conversion"
		_ = int64(parsed)
		_ = uint64(parsed)
		_ = int(parsed)
		_ = uint(parsed)
	}
}

func testParseUint() {
	{
		parsed, err := strconv.ParseUint("3456", 10, 8)
		if err != nil {
			panic(err)
		}
		_ = int8(parsed)
		_ = uint8(parsed)
		_ = int16(parsed)
		_ = uint16(parsed)
		_ = int32(parsed)
		_ = uint32(parsed)
		_ = int64(parsed)
		_ = uint64(parsed)
		_ = int(parsed)
		_ = uint(parsed)
	}
	{
		parsed, err := strconv.ParseUint("3456", 10, 16)
		if err != nil {
			panic(err)
		}
		_ = int8(parsed)  // $ hasValueFlow="type conversion"
		_ = uint8(parsed) // $ hasValueFlow="type conversion"
		_ = int16(parsed)
		_ = uint16(parsed)
		_ = int32(parsed)
		_ = uint32(parsed)
		_ = int64(parsed)
		_ = uint64(parsed)
		_ = int(parsed)
		_ = uint(parsed)
	}
	{
		parsed, err := strconv.ParseUint("3456", 10, 32)
		if err != nil {
			panic(err)
		}
		_ = int8(parsed)   // $ hasValueFlow="type conversion"
		_ = uint8(parsed)  // $ hasValueFlow="type conversion"
		_ = int16(parsed)  // $ hasValueFlow="type conversion"
		_ = uint16(parsed) // $ hasValueFlow="type conversion"
		_ = int32(parsed)
		_ = uint32(parsed)
		_ = int64(parsed)
		_ = uint64(parsed)
		_ = int(parsed)
		_ = uint(parsed)
	}
	{
		parsed, err := strconv.ParseUint("3456", 10, 64)
		if err != nil {
			panic(err)
		}
		_ = int8(parsed)   // $ hasValueFlow="type conversion"
		_ = uint8(parsed)  // $ hasValueFlow="type conversion"
		_ = int16(parsed)  // $ hasValueFlow="type conversion"
		_ = uint16(parsed) // $ hasValueFlow="type conversion"
		_ = int32(parsed)  // $ hasValueFlow="type conversion"
		_ = uint32(parsed) // $ hasValueFlow="type conversion"
		_ = int64(parsed)
		_ = uint64(parsed)
		_ = int(parsed)  // $ hasValueFlow="type conversion"
		_ = uint(parsed) // $ hasValueFlow="type conversion"
	}
	{
		parsed, err := strconv.ParseUint("3456", 10, 0)
		if err != nil {
			panic(err)
		}
		_ = int8(parsed)   // $ hasValueFlow="type conversion"
		_ = uint8(parsed)  // $ hasValueFlow="type conversion"
		_ = int16(parsed)  // $ hasValueFlow="type conversion"
		_ = uint16(parsed) // $ hasValueFlow="type conversion"
		_ = int32(parsed)  // $ hasValueFlow="type conversion"
		_ = uint32(parsed) // $ hasValueFlow="type conversion"
		_ = int64(parsed)
		_ = uint64(parsed)
		_ = int(parsed)
		_ = uint(parsed)
	}
}

func testAtoi() {
	parsed, err := strconv.Atoi("3456")
	if err != nil {
		panic(err)
	}
	_ = int8(parsed)   // $ hasValueFlow="type conversion"
	_ = uint8(parsed)  // $ hasValueFlow="type conversion"
	_ = int16(parsed)  // $ hasValueFlow="type conversion"
	_ = uint16(parsed) // $ hasValueFlow="type conversion"
	_ = int32(parsed)  // $ hasValueFlow="type conversion"
	_ = uint32(parsed) // $ hasValueFlow="type conversion"
	_ = int64(parsed)
	_ = uint64(parsed)
	_ = int(parsed)
	_ = uint(parsed)
}

type customInt int16

// these should be caught:
func typeAliases(input string) {
	{
		parsed, err := strconv.ParseInt(input, 10, 32)
		if err != nil {
			panic(err)
		}
		// NOTE: byte is uint8
		_ = byte(parsed)      // $ hasValueFlow="type conversion"
		_ = customInt(parsed) // $ hasValueFlow="type conversion"
	}
}

func testBoundsChecking(input string) {
	{
		parsed, err := strconv.Atoi(input)
		if err != nil {
			panic(err)
		}
		if parsed <= math.MaxInt8 && parsed >= math.MinInt8 {
			_ = int8(parsed)
		}
		if parsed < math.MaxInt8 {
			_ = int8(parsed) // $ MISSING: hasValueFlow="type conversion"  // Not found because we only check for upper bounds
			if parsed >= 0 {
				_ = int16(parsed)
			}
		}
		if parsed >= math.MinInt8 {
			_ = int8(parsed) // $ hasValueFlow="type conversion"
			if parsed <= 0 {
				_ = int16(parsed)
			}
		}
	}
	{
		parsed, err := strconv.ParseUint(input, 10, 32)
		if err != nil {
			panic(err)
		}
		if parsed <= math.MaxUint8 {
			_ = uint8(parsed)
		}
		if parsed < 5 {
			_ = uint16(parsed)
		}
		if err == nil && 1 == 1 && parsed < math.MaxInt8 {
			_ = int8(parsed)
		}
		if parsed > 42 {
			_ = uint16(parsed) // $ hasValueFlow="type conversion"
		}
		if parsed >= math.MaxUint8+1 {
			return
		}
		_ = uint8(parsed)
	}
}

func testRightShifted(input string) {
	{
		parsed, err := strconv.ParseInt(input, 10, 32)
		if err != nil {
			panic(err)
		}
		_ = byte(parsed)
		_ = byte(parsed >> 8)
		_ = byte(parsed >> 16)
		_ = byte(parsed >> 24)
	}
	{
		parsed, err := strconv.ParseInt(input, 10, 16)
		if err != nil {
			panic(err)
		}
		_ = byte(parsed)
		_ = byte(parsed & 0xff00 >> 8)
	}
	{
		parsed, err := strconv.ParseInt(input, 10, 32)
		if err != nil {
			panic(err)
		}
		_ = byte(parsed)
		_ = byte(parsed >> 8 & 0xff)
	}
	{
		parsed, err := strconv.ParseInt(input, 10, 16)
		if err != nil {
			panic(err)
		}
		_ = byte(parsed) // $ hasValueFlow="type conversion"
		_ = byte(parsed << 8)
	}
}

func testPathWithMoreThanOneSink(input string) {
	{
		parsed, err := strconv.ParseInt(input, 10, 32)
		if err != nil {
			panic(err)
		}
		v1 := int16(parsed) // $ hasValueFlow="type conversion"
		_ = int16(v1)
	}
	{
		parsed, err := strconv.ParseInt(input, 10, 32)
		if err != nil {
			panic(err)
		}
		v := int16(parsed) // $ hasValueFlow="type conversion"
		_ = int8(v)
	}
	{
		parsed, err := strconv.ParseInt(input, 10, 32)
		if err != nil {
			panic(err)
		}
		v1 := int32(parsed)
		v2 := int16(v1) // $ hasValueFlow="type conversion"
		_ = int8(v2)
	}
	{
		parsed, err := strconv.ParseInt(input, 10, 16)
		if err != nil {
			panic(err)
		}
		v1 := int64(parsed)
		v2 := int32(v1)
		v3 := int16(v2)
		_ = int8(v3) // $ hasValueFlow="type conversion"
	}
}

func testUsingStrConvIntSize(input string) {
	parsed, err := strconv.ParseInt(input, 10, strconv.IntSize)
	if err != nil {
		panic(err)
	}
	_ = int8(parsed)   // $ hasValueFlow="type conversion"
	_ = uint8(parsed)  // $ hasValueFlow="type conversion"
	_ = int16(parsed)  // $ hasValueFlow="type conversion"
	_ = uint16(parsed) // $ hasValueFlow="type conversion"
	_ = int32(parsed)  // $ hasValueFlow="type conversion"
	_ = uint32(parsed) // $ hasValueFlow="type conversion"
	_ = int64(parsed)
	_ = uint64(parsed)
	_ = int(parsed)
	_ = uint(parsed)
}

// parsePositiveInt parses value as an int. It returns an error if value cannot
// be parsed or is negative.
func parsePositiveInt1(value string) (int, error) {
	switch i64, err := strconv.ParseInt(value, 10, 64); {
	case err != nil:
		return 0, fmt.Errorf("unable to parse positive integer %q: %v", value, err)
	case i64 < 0:
		return 0, fmt.Errorf("unable to parse positive integer %q: negative value", value)
	case i64 > math.MaxInt:
		return 0, fmt.Errorf("unable to parse positive integer %q: overflow", value)
	default:
		return int(i64), nil
	}
}

func parsePositiveInt2(value string) (int, error) {
	i64, err := strconv.ParseInt(value, 10, 64)
	if err != nil {
		return 0, fmt.Errorf("unable to parse positive integer %q: %w", value, err)
	}
	if i64 < 0 {
		return 0, fmt.Errorf("unable to parse positive integer %q: negative value", value)
	}
	if i64 > math.MaxInt {
		return 0, fmt.Errorf("unable to parse positive integer %q: overflow", value)
	}
	return int(i64), nil
}

func typeAssertion(s string) {
	n, err := strconv.ParseInt(s, 10, 0)
	if err == nil {
		var itf interface{} = n
		i32 := itf.(int32)
		println(i32)
	}

}
