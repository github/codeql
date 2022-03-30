package main

import (
	"net/http"
	"net/smtp"
)

func mailGood(w http.ResponseWriter, r *http.Request) {
	host := config["Host"]
	token := backend.getUserSecretResetToken(email)
	body := "Click to reset password: " + host + "/" + token
	smtp.SendMail("test.test", nil, "from@from.com", nil, []byte(body))
}
