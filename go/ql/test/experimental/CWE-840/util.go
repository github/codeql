package main

type Config struct{}

func (_ Config) get(s string) string {
	return ""
}

var config = Config{}
