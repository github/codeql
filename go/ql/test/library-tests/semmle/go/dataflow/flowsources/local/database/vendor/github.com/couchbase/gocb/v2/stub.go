package gocb

type Result struct{}

type GetResult struct {
	Result
}

type GetAnyReplicaResult struct {
	GetResult
}

type GetOptions struct{}

type Collection struct{}

func (c *Collection) Get(key string, opts *GetOptions) (GetResult, error) {
	return GetResult{}, nil
}

func (c *Collection) GetAnyReplica(key string, opts *GetOptions) (GetResult, error) {
	return GetResult{}, nil
}

func (gr *GetResult) Content(v interface{}) error {
	return nil
}
