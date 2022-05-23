package main

//go:generate depstubber -vendor github.com/sendgrid/sendgrid-go/helpers/mail "" NewEmail,NewSingleEmail,NewContent,NewV3Mail,NewV3MailInit

import (
	"io"
	"net/smtp"

	sendgrid "github.com/sendgrid/sendgrid-go/helpers/mail"
)

func main() {
	untrustedInput := "test"

	smtp.SendMail("test.test", nil, "from@from.com", nil /* email data */, []byte(untrustedInput))

	s, _ := smtp.Dial("test.test")
	/* email data */ write, _ := s.Data()

	io.WriteString(write, untrustedInput)

	from := sendgrid.NewEmail("from", "from@from.com")
	to := sendgrid.NewEmail("to", "to@to.com")
	text := "sub"

	sendgrid.NewSingleEmail(from /* email data */, text, to /* email data */, text,
		/* email data */ text)

	content := sendgrid.NewContent("text/html", text)
	v := sendgrid.NewV3Mail()
	v.AddContent( /* email data */ content)

	content2 := sendgrid.NewContent("text/html", text)
	content3 := sendgrid.NewContent("text/html", text)

	v = sendgrid.NewV3MailInit(from /* email data */, text, to /* email data */, content2,
		/* email data */ content3)
}
