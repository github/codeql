package main

//go:generate depstubber -vendor github.com/sendgrid/sendgrid-go/helpers/mail "" NewEmail,NewSingleEmail,NewContent,NewV3Mail,NewV3MailInit

import (
	"io"
	"log"
	"net/http"
	"net/smtp"

	sendgrid "github.com/sendgrid/sendgrid-go/helpers/mail"
)

// OK
func mailGood(w http.ResponseWriter, r *http.Request) {
	host := config["Host"]
	token := backend.getUserSecretResetToken(email)
	body := "Click to reset password: " + host + "/" + token
	smtp.SendMail("test.test", nil, "from@from.com", nil, []byte(body))
}

// Not OK
func mail(w http.ResponseWriter, r *http.Request) {
	host := r.Header.Get("Host")
	token := backend.getUserSecretResetToken(email)
	body := "Click to reset password: " + host + "/" + token
	smtp.SendMail("test.test", nil, "from@from.com", nil, []byte(body))
}

func main() {

	// Not OK
	http.HandleFunc("/ex0", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer()

		smtp.SendMail("test.test", nil, "from@from.com", nil, []byte(untrustedInput))

	})

	// Not OK
	http.HandleFunc("/ex1", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer()

		s, _ := smtp.Dial("test.test")
		write, _ := s.Data()
		io.WriteString(write, untrustedInput)
	})

	// Not OK
	http.HandleFunc("/ex2", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer()

		from := sendgrid.NewEmail("from", "from@from.com")
		to := sendgrid.NewEmail("to", "to@to.com")
		subject := "test"
		body := "body"
		sendgrid.NewSingleEmail(from, subject, to, untrustedInput, body)
		sendgrid.NewSingleEmail(from, subject, to, body, untrustedInput)
	})

	// Not OK
	http.HandleFunc("/ex3", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer()

		content := sendgrid.NewContent("text/html", untrustedInput)

		v := sendgrid.NewV3Mail()
		v.AddContent(content)
	})

	// Not OK
	http.HandleFunc("/ex4", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer()

		from := sendgrid.NewEmail("from", "from@from.com")
		to := sendgrid.NewEmail("to", "to@to.com")
		subject := "test"

		content := sendgrid.NewContent("text/html", untrustedInput)

		v := sendgrid.NewV3MailInit(from, subject, to, content, content)
		v.AddContent(content)
	})

	// Not OK
	http.HandleFunc("/ex5", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer()

		from := sendgrid.NewEmail("from", "from@from.com")
		to := sendgrid.NewEmail("to", "to@to.com")

		content := sendgrid.NewContent("text/html", "test")

		v := sendgrid.NewV3MailInit(from, untrustedInput, to, content, content)

		content2 := sendgrid.NewContent("text/html", untrustedInput)

		v.AddContent(content2)
	})

	log.Println(http.ListenAndServe(":80", nil))

}

// Backend is an empty struct
type Backend struct{}

func (*Backend) getUserSecretResetToken(email string) string {
	return ""
}

var email = "test@test.com"

var config map[string]string
var backend = &Backend{}
