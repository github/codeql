module codeql-go-tests/frameworks/K8sIoClientGo

go 1.14

require (
	github.com/google/gofuzz v1.2.0 // indirect
	golang.org/x/crypto v0.1.0 // indirect
	golang.org/x/oauth2 v0.0.0-20201208152858-08078c50e5b5 // indirect
	golang.org/x/time v0.0.0-20201208040808-7e3f01d25324 // indirect
	k8s.io/client-go v0.19.0
	k8s.io/utils v0.0.0-20201110183641-67b214c5f920 // indirect
)

replace k8s.io/apimachinery => k8s.io/apimachinery v0.19.0
