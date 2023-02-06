module codeql-go-tests/frameworks/K8sIoClientGo

go 1.14

require (
	github.com/google/gofuzz v1.2.0 // indirect
	golang.org/x/crypto v0.0.0-20201208171446-5f87f3452ae9 // indirect
	golang.org/x/net v0.0.0-20201207224615-747e23833adb // indirect
	golang.org/x/oauth2 v0.0.0-20201208152858-08078c50e5b5 // indirect
	golang.org/x/time v0.0.0-20201208040808-7e3f01d25324 // indirect
	k8s.io/client-go v0.20.0
)

replace k8s.io/apimachinery => k8s.io/apimachinery v0.19.0
