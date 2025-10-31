package worker

import "example.com/configmodule/config"

func Use() string {
    return config.Value()
}
