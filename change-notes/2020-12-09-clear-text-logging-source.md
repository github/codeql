lgtm,codescanning
* The query "Clear-text logging of sensitive information" has been improved to recognize `SecretInterface` from `k8s.io/client-go/kubernetes/typed/core/v1` as a source of sensitive data, which may lead to more alerts.
