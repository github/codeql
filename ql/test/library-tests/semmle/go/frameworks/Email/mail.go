package main

//go:generate depstubber -vendor github.com/sendgrid/sendgrid-go/helpers/mail "" NewEmail,NewSingleEmail,NewContent,NewV3Mail,NewV3MailInit

import (
	"io"
	"net/smtp"

	sendgrid "github.com/sendgrid/sendgrid-go/helpers/mail"
)

func main() {
	untrustedInput := "test"

	// Not OK - 1 alert
	smtp.SendMail("test.test", nil, "from@from.com", nil, []byte(untrustedInput))

	s, _ := smtp.Dial("test.test")
	write, _ := s.Data()

	// Not OK - 1 alert
	io.WriteString(write, untrustedInput)

	from := sendgrid.NewEmail("from", "from@from.com")
	to := sendgrid.NewEmail("to", "to@to.com")
	alert := "sub"

	// Not OK - 3 alerts
	sendgrid.NewSingleEmail(from, alert, to, alert, alert)

	// Not OK - 1 alert
	content := sendgrid.NewContent("text/html", alert)
	v := sendgrid.NewV3Mail()
	v.AddContent(content)

	content2 := sendgrid.NewContent("text/html", alert)
	content3 := sendgrid.NewContent("text/html", alert)

	// Not OK - 3 alerts
	v = sendgrid.NewV3MailInit(from, alert, to, content2, content3)

}
