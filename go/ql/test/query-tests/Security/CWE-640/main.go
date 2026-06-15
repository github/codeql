package main

//go:generate depstubber -vendor github.com/sendgrid/sendgrid-go/helpers/mail "" NewEmail,NewSingleEmail,NewContent,NewV3Mail,NewV3MailInit

import (
	"bytes"
	"crypto/hmac"
	"crypto/sha256"
	"encoding/base64"
	"io"
	"log"
	"mime/multipart"
	"net/http"
	"net/smtp"

	sendgrid "github.com/sendgrid/sendgrid-go/helpers/mail"
)

func main() {
	var w http.ResponseWriter
	var r *http.Request

	// Not OK
	mail(w, r)

	// OK
	mailGood(w, r)

	// Not OK
	http.HandleFunc("/ex0", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer() // $ Source

		smtp.SendMail("test.test", nil, "from@from.com", nil, []byte(untrustedInput)) // $ Alert

	})

	// Not OK
	http.HandleFunc("/ex1", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer() // $ Source

		s, _ := smtp.Dial("test.test")
		write, _ := s.Data()
		io.WriteString(write, untrustedInput) // $ Alert
	})

	// Not OK
	http.HandleFunc("/ex2", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer() // $ Source

		from := sendgrid.NewEmail("from", "from@from.com")
		to := sendgrid.NewEmail("to", "to@to.com")
		subject := "test"
		body := "body"
		sendgrid.NewSingleEmail(from, subject, to, untrustedInput, body) // $ Alert
		sendgrid.NewSingleEmail(from, subject, to, body, untrustedInput) // $ Alert
	})

	// Not OK
	http.HandleFunc("/ex3", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer() // $ Source

		content := sendgrid.NewContent("text/html", untrustedInput)

		v := sendgrid.NewV3Mail()
		v.AddContent(content) // $ Alert
	})

	// Not OK
	http.HandleFunc("/ex4", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer() // $ Source

		from := sendgrid.NewEmail("from", "from@from.com")
		to := sendgrid.NewEmail("to", "to@to.com")
		subject := "test"

		content := sendgrid.NewContent("text/html", untrustedInput)

		v := sendgrid.NewV3MailInit(from, subject, to, content, content) // $ Alert
		v.AddContent(content)                                            // $ Alert
	})

	// Not OK
	http.HandleFunc("/ex5", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer() // $ Source

		from := sendgrid.NewEmail("from", "from@from.com")
		to := sendgrid.NewEmail("to", "to@to.com")

		content := sendgrid.NewContent("text/html", "test")

		v := sendgrid.NewV3MailInit(from, untrustedInput, to, content, content) // $ Alert

		content2 := sendgrid.NewContent("text/html", untrustedInput)

		v.AddContent(content2) // $ Alert
	})

	// OK
	http.HandleFunc("/ex6", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer()

		sha256 := sha256.New
		appsecret := "appid"
		hash := hmac.New(sha256, []byte(appsecret))
		hash.Write([]byte(untrustedInput))
		signature := base64.StdEncoding.EncodeToString(hash.Sum(nil))

		smtp.SendMail("test.test", nil, "from@from.com", nil, []byte(signature))
	})

	// Not OK - mime/multipart.New.Writer test
	http.HandleFunc("/multipart1", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer() // $ Source

		var b bytes.Buffer
		mw := multipart.NewWriter(&b)

		// Add user-controlled data directly to the multipart writer
		mw.WriteField("message", untrustedInput) // Injection point

		mw.Close()

		// Send the potentially malicious email content
		smtp.SendMail("test.test", nil, "from@from.com", nil, b.Bytes()) // $ Alert
	})

	// Not OK - alternative multipart test
	http.HandleFunc("/multipart2", func(w http.ResponseWriter, r *http.Request) {
		untrustedInput := r.Referer() // $ Source

		var b bytes.Buffer
		mw := multipart.NewWriter(&b)

		// Create form file with untrusted content
		formWriter, _ := mw.CreateFormFile("attachment", "message.txt")
		io.WriteString(formWriter, untrustedInput) // Injection point

		mw.Close()

		// Send email with user-controlled form file content
		smtp.SendMail("test.test", nil, "from@from.com", nil, b.Bytes()) // $ Alert
	})

	// Not OK - check only one result when sink is Client.Data() from net/smtp
	{
		untrustedInput1 := r.Referer() // $ Source=s1
		untrustedInput2 := r.Referer() // $ Source=s2
		c, _ := smtp.Dial("mail.example.com:smtp")
		w, _ := c.Data()
		w.Write([]byte("safe text"))
		w.Write([]byte(untrustedInput1)) // $ Alert=s1
		w.Write([]byte(untrustedInput2)) // $ Alert=s2
		w.Close()
		c.Quit()
	}

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
