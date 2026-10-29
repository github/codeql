package main

import "fmt"

func good() (string, error) {
	t, err := pam.StartFunc("", "username", func(s pam.Style, msg string) (string, error) {
		switch s {
		case pam.PromptEchoOff:
			return string(pass), nil
		}
		return "", fmt.Errorf("unsupported message style")
	})
	if err != nil {
		return nil, err
	}

	if err := t.Authenticate(0); err != nil {
		return nil, fmt.Errorf("Authenticate: %w", err)
	}
	if err := t.AcctMgmt(0); err != nil {
		return nil, fmt.Errorf("AcctMgmt: %w", err)
	}
}
