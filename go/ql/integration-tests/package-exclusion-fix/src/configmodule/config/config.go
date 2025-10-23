package config

type Settings struct {
    Value string
}

func Value() string {
    return Settings{Value: "ok"}.Value
}
