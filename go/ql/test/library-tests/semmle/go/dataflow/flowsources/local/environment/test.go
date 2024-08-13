package test

import (
	"fmt"
	"github.com/hashicorp/go-envparse"
	"github.com/joho/godotenv"
	"github.com/kelseyhightower/envconfig"
	"os"
)

func osEnvironmentVariables() {
	home := os.Getenv("HOME")

	port, ok := os.LookupEnv("PORT")
	if !ok {
		port = "3000"
	}

	for _, e := range os.Environ() {
		_ = e
	}

	fmt.Printf("HOME: %s\n", home)
	fmt.Printf("PORT: %s\n", port)
}

type ServerConfig struct {
	Port int    `envconfig:"PORT"`
	Host string `envconfig:"HOST"`
}

func envconfigEnvironmentVariables() {
	var cfg ServerConfig
	envconfig.Process("myapp", &cfg)
}

func godotenvEnvironmentVariables() {
	var err error
	var username, greeting string

	users, err := godotenv.Read("user.env")
	if err != nil {
		return
	}

	username := users["USERNAME"]

	greetings, err := godotenv.Unmarshal("HELLO=hello")
	if err != nil {
		return
	}

	greeting := greetings["HELLO"]

	fmt.Printf("%s, %s!\n", greeting, username)
}

func envparseEnvironmentVariables() {
	f := os.OpenRead("file.txt")
	defer f.Close()
	envVars, ok := envparse.Parse(f)

	if !ok {
		return
	}

	fmt.Printf("HOME: %s\n", envVars["HOME"])
}
