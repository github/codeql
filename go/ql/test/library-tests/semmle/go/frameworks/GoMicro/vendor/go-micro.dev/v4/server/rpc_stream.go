package server

import (
	"context"
	"errors"
	"io"
	"sync"

	"go-micro.dev/v4/codec"
)

// Implements the Streamer interface.
type rpcStream struct {
	err     error
	request Request
	codec   codec.Codec
	context context.Context
	id      string
	sync.RWMutex
	closed bool
}

func (r *rpcStream) Context() context.Context {
	return r.context
}

func (r *rpcStream) Request() Request {
	return r.request
}

func (r *rpcStream) Send(msg interface{}) error {
	r.Lock()
	defer r.Unlock()

	resp := codec.Message{
		Target:   r.request.Service(),
		Method:   r.request.Method(),
		Endpoint: r.request.Endpoint(),
		Id:       r.id,
		Type:     codec.Response,
	}

	if err := r.codec.Write(&resp, msg); err != nil {
		r.err = err
	}

	return nil
}

func (r *rpcStream) Recv(msg interface{}) error {
	req := new(codec.Message)
	req.Type = codec.Request

	err := r.codec.ReadHeader(req, req.Type)
	r.Lock()
	defer r.Unlock()
	if err != nil {
		// discard body
		r.codec.ReadBody(nil)
		r.err = err
		return err
	}

	// check the error
	if len(req.Error) > 0 {
		// Check the client closed the stream
		switch req.Error {
		case errLastStreamResponse.Error():
			// discard body
			r.Unlock()
			r.codec.ReadBody(nil)
			r.Lock()
			r.err = io.EOF
			return io.EOF
		default:
			return errors.New(req.Error)
		}
	}

	// we need to stay up to date with sequence numbers
	r.id = req.Id
	r.Unlock()
	err = r.codec.ReadBody(msg)
	r.Lock()
	if err != nil {
		r.err = err
		return err
	}

	return nil
}

func (r *rpcStream) Error() error {
	r.RLock()
	defer r.RUnlock()
	return r.err
}

func (r *rpcStream) Close() error {
	r.Lock()
	defer r.Unlock()
	r.closed = true
	return r.codec.Close()
}
