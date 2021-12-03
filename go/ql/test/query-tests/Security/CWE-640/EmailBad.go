package main

import (
	"net/http"
	"net/smtp"
)

func mail(w http.ResponseWriter, r *http.Request) {
	host := r.Header.Get("Host")
	token := backend.getUserSecretResetToken(email)
	body := "Click to reset password: " + host + "/" + token
	smtp.SendMail("test.test", nil, "from@from.com", nil, []byte(body))
}
