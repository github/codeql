package main

import (
	context "context"

	"k8s.io/client-go/kubernetes/typed/core/v1"
)

//go:generate depstubber -vendor k8s.io/client-go/kubernetes/typed/core/v1 SecretInterface

func main() {
	var s mySecretInterface
	var t core.SecretInterface
	var ctx context.Context
	var secret interface{}
	var opts interface{}
	var listOpts interface{}
	var name string
	var pt interface{}
	var data []byte

	use(s.Create(ctx, secret, opts))
	use(t.Create(ctx, secret, opts))
	use(s.Update(ctx, secret, opts))
	use(t.Update(ctx, secret, opts))
	use(s.Delete(ctx, name, opts))
	use(t.Delete(ctx, name, opts))
	use(s.DeleteCollection(ctx, opts, listOpts))
	use(t.DeleteCollection(ctx, opts, listOpts))
	use(s.Get(ctx, name, opts)) // $ KsIoClientGo
	use(t.Get(ctx, name, opts)) // $ KsIoClientGo
	use(s.List(ctx, opts))      // $ KsIoClientGo
	use(t.List(ctx, opts))      // $ KsIoClientGo
	use(s.Watch(ctx, opts))
	use(t.Watch(ctx, opts))
	use(s.Patch(ctx, name, pt, data, opts)) // $ KsIoClientGo
	use(t.Patch(ctx, name, pt, data, opts)) // $ KsIoClientGo
}

func use(arg ...interface{}) {}

type mySecretInterface struct {
}

// func (m mySecretInterface) Create(ctx context.Context, secret *v1.Secret, opts metav1.CreateOptions) (*v1.Secret, error) {
func (m mySecretInterface) Create(ctx context.Context, secret interface{}, opts interface{}) (interface{}, error) {
	return nil, nil
}

// func (m mySecretInterface) Update(ctx context.Context, secret *v1.Secret, opts metav1.UpdateOptions) (*v1.Secret, error) {
func (m mySecretInterface) Update(ctx context.Context, secret interface{}, opts interface{}) (interface{}, error) {
	return nil, nil
}

// func (m mySecretInterface) Delete(ctx context.Context, name string, opts metav1.DeleteOptions) error {
func (m mySecretInterface) Delete(ctx context.Context, name string, opts interface{}) error {
	return nil
}

// func (m mySecretInterface) DeleteCollection(ctx context.Context, opts metav1.DeleteOptions, listOpts metav1.ListOptions) error {
func (m mySecretInterface) DeleteCollection(ctx context.Context, opts interface{}, listOpts interface{}) error {
	return nil
}

// func (m mySecretInterface) Get(ctx context.Context, name string, opts metav1.GetOptions) (*v1.Secret, error) {
func (m mySecretInterface) Get(ctx context.Context, name string, opts interface{}) (interface{}, error) {
	return nil, nil
}

// func (m mySecretInterface) List(ctx context.Context, opts metav1.ListOptions) (*v1.SecretList, error) {
func (m mySecretInterface) List(ctx context.Context, opts interface{}) (interface{}, error) {
	return nil, nil
}

// func (m mySecretInterface) Watch(ctx context.Context, opts metav1.ListOptions) (watch.Interface, error) {
func (m mySecretInterface) Watch(ctx context.Context, opts interface{}) (interface{}, error) {
	return nil, nil
}

// func (m mySecretInterface) Patch(ctx context.Context, name string, pt types.PatchType, data []byte, opts metav1.PatchOptions, subresources ...string) (result *v1.Secret, err error) {
func (m mySecretInterface) Patch(ctx context.Context, name string, pt interface{}, data []byte, opts interface{}, subresources ...string) (result interface{}, err error) {
	return nil, nil
}
