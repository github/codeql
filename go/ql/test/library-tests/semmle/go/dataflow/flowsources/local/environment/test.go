package test

import (
	"fmt"
	"github.com/caarlos0/env"
	"github.com/gobuffalo/envy"
	"github.com/hashicorp/go-envparse"
	"github.com/joho/godotenv"
	"github.com/kelseyhightower/envconfig"
	"os"
	"syscall"
)

func osEnvironmentVariables() {
	home := os.Getenv("HOME") // $ source

	port, ok := os.LookupEnv("PORT") // $ source
	if !ok {
		port = "3000"
	}

	for _, e := range os.Environ() { // $ source
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
	envconfig.Process("myapp", &cfg) // $ source
}

func godotenvEnvironmentVariables() {
	var err error
	var username, greeting string

	users, err := godotenv.Read("user.env") // $ source
	if err != nil {
		return
	}

	username = users["USERNAME"]

	greetings, err := godotenv.Unmarshal("HELLO=hello") // $ source
	if err != nil {
		return
	}

	greeting = greetings["HELLO"]

	fmt.Printf("%s, %s!\n", greeting, username)
}

func envparseEnvironmentVariables() {
	f, err := os.Open("file.txt")
	if err != nil {
		return
	}
	defer f.Close()
	envVars, err := envparse.Parse(f) // $ source

	if err != nil {
		return
	}

	fmt.Printf("HOME: %s\n", envVars["HOME"])
}

func caarlos0EnvironmentVariables() {
	type config struct {
		Home string `env:"HOME"`
		Port int    `env:"PORT"`
	}

	cfg := config{}
	err := env.Parse(&cfg) // $ source

	fmt.Printf("HOME: %s\n", cfg.Home)

	cfg, err = env.ParseAs[config]() // $ source

	if err != nil {
		return
	}

	fmt.Printf("HOME: %s\n", cfg.Home)
}

func envyEnvironmentVariables() {
	goPath := envy.GoPath() // $ source

	fmt.Printf("GOPATH: %s\n", goPath)

	homeDir := envy.MustGet("HOME") // $ source

	fmt.Printf("HOME: %s\n", homeDir)
}

func syscallEnvironmentVariables() {
	for _, envVar := range syscall.Environ() { // $ source
		fmt.Println("%s", envVar)
	}

	home, found := syscall.Getenv("HOME") // $ source
	if !found {
		return
	}
	fmt.Println("HOME: %s", home)
}
