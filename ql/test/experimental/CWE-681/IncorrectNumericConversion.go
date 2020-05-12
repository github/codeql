package main

import (
	"math"
	"strconv"
)

func main() {

}

type Something struct {
}
type Config struct {
}
type Registry struct {
}

func LookupTarget(conf *Config, num int32) (int32, error) {
	return 567, nil
}
func LookupNumberByName(reg *Registry, name string) (int32, error) {
	return 567, nil
}
func lab(s string) (*Something, error) {
	num, err := strconv.Atoi(s)

	if err != nil {
		number, err := LookupNumberByName(&Registry{}, s)
		if err != nil {
			return nil, err
		}
		num = int(number)
	}
	target, err := LookupTarget(&Config{}, int32(num))
	if err != nil {
		return nil, err
	}

	// convert the resolved target number back to a string

	s = strconv.Itoa(int(target))

	return nil, nil
}

const CustomMaxInt16 = 1<<15 - 1

type CustomInt int16

func badParseFloat() {
	{
		parsed, err := strconv.ParseFloat("1.32", 32)
		if err != nil {
			panic(err)
		}
		_ = int16(parsed)
	}
	{
		parsed, err := strconv.ParseFloat("1.32", 64)
		if err != nil {
			panic(err)
		}
		_ = int32(parsed)
	}
}
func badParseInt() {
	{
		parsed, err := strconv.ParseInt("3456", 10, 16)
		if err != nil {
			panic(err)
		}
		_ = int8(parsed)
	}
	{
		parsed, err := strconv.ParseInt("3456", 10, 32)
		if err != nil {
			panic(err)
		}
		_ = int16(parsed)
	}
	{
		parsed, err := strconv.ParseInt("3456", 10, 64)
		if err != nil {
			panic(err)
		}
		_ = int32(parsed)
	}
	{
		parsed, err := strconv.ParseInt("3456", 10, 0)
		if err != nil {
			panic(err)
		}
		_ = int32(parsed)
	}
}
func badParseUint() {
	{
		parsed, err := strconv.ParseUint("3456", 10, 16)
		if err != nil {
			panic(err)
		}
		_ = int8(parsed)
	}
	{
		parsed, err := strconv.ParseUint("3456", 10, 32)
		if err != nil {
			panic(err)
		}
		_ = int16(parsed)
	}
	{
		parsed, err := strconv.ParseUint("3456", 10, 64)
		if err != nil {
			panic(err)
		}
		_ = int32(parsed)
	}
	{
		parsed, err := strconv.ParseUint("3456", 10, 0)
		if err != nil {
			panic(err)
		}
		_ = int32(parsed)
	}
}

func goodParseFloat() {
	{
		parsed, err := strconv.ParseFloat("1.32", 32)
		if err != nil {
			panic(err)
		}
		_ = int32(parsed)
	}
	{
		parsed, err := strconv.ParseFloat("1.32", 64)
		if err != nil {
			panic(err)
		}
		_ = int64(parsed)
	}
}
func goodParseInt() {
	{
		parsed, err := strconv.ParseInt("3456", 10, 16)
		if err != nil {
			panic(err)
		}
		_ = int16(parsed)
	}
	{
		parsed, err := strconv.ParseInt("3456", 10, 32)
		if err != nil {
			panic(err)
		}
		_ = int32(parsed)
	}
	{
		parsed, err := strconv.ParseInt("3456", 10, 64)
		if err != nil {
			panic(err)
		}
		_ = int64(parsed)
	}
	{
		parsed, err := strconv.ParseInt("3456", 10, 0)
		if err != nil {
			panic(err)
		}
		_ = int64(parsed)
	}
}
func goodParseUint() {
	{
		parsed, err := strconv.ParseUint("3456", 10, 16)
		if err != nil {
			panic(err)
		}
		_ = int16(parsed)
	}
	{
		parsed, err := strconv.ParseUint("3456", 10, 32)
		if err != nil {
			panic(err)
		}
		_ = int32(parsed)
	}
	{
		parsed, err := strconv.ParseUint("3456", 10, 64)
		if err != nil {
			panic(err)
		}
		_ = int64(parsed)
	}
	{
		parsed, err := strconv.ParseUint("3456", 10, 0)
		if err != nil {
			panic(err)
		}
		_ = int64(parsed)
	}
}

// these should be caught:
func upperBoundIsNOTChecked(input string) {
	{
		parsed, err := strconv.Atoi(input)
		if err != nil {
			panic(err)
		}
		_ = int8(parsed)
	}
	{
		parsed, err := strconv.Atoi(input)
		if err != nil {
			panic(err)
		}
		_ = int16(parsed)
	}
	{
		parsed, err := strconv.Atoi(input)
		if err != nil {
			panic(err)
		}
		_ = int32(parsed)
	}
	{
		parsed, err := strconv.Atoi(input)
		if err != nil {
			panic(err)
		}
		_ = uint8(parsed)
	}
	{
		parsed, err := strconv.Atoi(input)
		if err != nil {
			panic(err)
		}
		_ = uint16(parsed)
	}
	{
		parsed, err := strconv.Atoi(input)
		if err != nil {
			panic(err)
		}
		_ = uint32(parsed)
	}
	{
		parsed, err := strconv.Atoi(input)
		if err != nil {
			panic(err)
		}
		_ = float32(parsed)
	}
	{
		parsed, err := strconv.Atoi(input)
		if err != nil {
			panic(err)
		}
		// NOTE: byte is uint8
		_ = byte(parsed)
	}
	{
		// using custom type:
		parsed, err := strconv.Atoi(input)
		if err != nil {
			panic(err)
		}
		_ = CustomInt(parsed)
	}

}

// these should NOT be caught:
func upperBoundIsChecked(input string) {
	{
		parsed, err := strconv.Atoi(input)
		if err != nil {
			panic(err)
		}
		if parsed < math.MaxInt8 {
			_ = int8(parsed)
		}
	}
	{
		parsed, err := strconv.Atoi(input)
		if err != nil {
			panic(err)
		}
		if parsed < math.MaxInt16 {
			_ = int16(parsed)
		}
	}
	{
		parsed, err := strconv.Atoi(input)
		if err != nil {
			panic(err)
		}
		if parsed > 0 {
			_ = int32(parsed)
		}
	}
	{
		parsed, err := strconv.Atoi(input)
		if err != nil {
			panic(err)
		}
		if parsed < math.MaxInt32 {
			_ = int32(parsed)
		}
	}
	{
		parsed, err := strconv.Atoi(input)
		if err != nil {
			panic(err)
		}
		if parsed < math.MaxUint8 {
			_ = uint8(parsed)
		}
	}
	{
		parsed, err := strconv.Atoi(input)
		if err != nil {
			panic(err)
		}
		if parsed < math.MaxUint16 {
			_ = uint16(parsed)
		}
	}
	{
		parsed, err := strconv.Atoi(input)
		if err != nil {
			panic(err)
		}
		if parsed < math.MaxUint8 {
			_ = byte(parsed)
		}
	}
	{ // multiple `and` conditions
		parsed, err := strconv.Atoi(input)
		if err == nil && 1 == 1 && parsed < math.MaxInt8 {
			_ = int8(parsed)
		}
	}
	{ // custom maxInt16
		parsed, err := strconv.Atoi(input)
		if err != nil {
			panic(err)
		}
		if parsed < CustomMaxInt16 {
			_ = int16(parsed)
		}
	}
}
