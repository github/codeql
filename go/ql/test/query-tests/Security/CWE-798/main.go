package main

import "fmt"

const (
	passwd    = "p4ssw0rd" // NOT OK
	_password = ""         // OK
)

// generated using http://travistidwell.com/jsencrypt/demo
const totallyNotAPrivateKey = // NOT OK
`-----BEGIN RSA PRIVATE KEY-----
MIICXQIBAAKBgQC/tzdtXKXcX6F3v3hR6+uYyZpIeXhhLflJkY2eILLQfAnwKlT5
xIHW5QZcHQV9sCyZ8qSdPGif7PwgMbButMbByiZhCSugUFb6vjVqoktmslYF4LKH
iDgvmlwuJW0TvynxBLzDCwrRP+gpRT8wuAortWAx/03POTw7Mzi2cIPNsQIDAQAB
AoGAMHCrqY9CPTdQhgAz94cDpTwzJmLCvtMt7J/BR5X9eF4O6MbZZ652HAUMIVQX
4hUUf+VmIHB2AwqO/ddwO9ijaz04BslOSy/iYevHGlH65q4587NSlFWjvILMIQCM
GBjfzJIxlLHVhjc2cFnyAE5YWjF/OMnJN0OhP9pxmCP/iM0CQQDxmQndQLdnV7+6
8SvBHE8bg1LE8/BzTt68U3aWwiBjrHMFgzr//7Za4VF7h4ilFgmbh0F3sYz+C8iO
0JrBRPeLAkEAyyTwnv/pgqTS/wuxIHUxRBpbdk3YvILAthNrGQg5uzA7eSeFu7Mv
GtEkXsaqCDbdehgarFfNN8PB6OMRIbsXMwJBAOjhH8UJ0L/osYO9XPO0GfznRS1c
Bnbfm4vk1/bSAO6TF/xEVubU0i4f6q8sIecfqvskEVMS7lkjeptPMR0DIakCQE+7
uQH/Wizf+r0GXshplyOu4LVHisk63N7aMlAJ7XbuUHmWLKRmiReSfR8CBNzig/2X
FmkMsUyw9hwte5zsrQcCQQCrOkZvzUj9j1HKG+32EJ2E4kisJZmAgF9GI+z6oxpi
Exped5tp8EWytCjRwKhOcc0068SgaqhKvyyUWpbx32VQ
-----END RSA PRIVATE KEY-----`

const publicKey = // OK
`-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC/tzdtXKXcX6F3v3hR6+uYyZpI
eXhhLflJkY2eILLQfAnwKlT5xIHW5QZcHQV9sCyZ8qSdPGif7PwgMbButMbByiZh
CSugUFb6vjVqoktmslYF4LKHiDgvmlwuJW0TvynxBLzDCwrRP+gpRT8wuAortWAx
/03POTw7Mzi2cIPNsQIDAQAB
-----END PUBLIC KEY-----`

var secretKey = "" // OK

type info struct {
	username string
	password string
}

func main() {
	password := "p4ss" // NOT OK
	tmp := password
	i := info{
		username: "me",
		password: tmp, // NOT OK
	}
	i.password = "p4ss2" // NOT OK
	fmt.Println(password, i)
	testPassword := "p4ss"          // OK
	i.password = "test"             // OK
	i.password = testPassword       // OK
	secretKey = "secret"            // OK
	i.password = "--- redacted ---" // OK
	certsDir := "/certs"            // OK
	fmt.Println(certsDir)
	accountParameter := "ACCOUNT" // OK
	fmt.Println(accountParameter)
}
