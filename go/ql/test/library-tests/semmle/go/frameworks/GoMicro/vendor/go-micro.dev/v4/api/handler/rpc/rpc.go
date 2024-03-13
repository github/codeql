// Package rpc is a go-micro rpc handler.
package rpc

import (
	"encoding/json"
	"io"
	"net/http"
	"net/textproto"
	"strconv"
	"strings"

	jsonpatch "github.com/evanphx/json-patch/v5"
	"github.com/oxtoacart/bpool"
	"go-micro.dev/v4/api/handler"
	"go-micro.dev/v4/api/internal/proto"
	"go-micro.dev/v4/api/router"
	"go-micro.dev/v4/client"
	"go-micro.dev/v4/codec"
	"go-micro.dev/v4/codec/jsonrpc"
	"go-micro.dev/v4/codec/protorpc"
	"go-micro.dev/v4/errors"
	log "go-micro.dev/v4/logger"
	"go-micro.dev/v4/metadata"
	"go-micro.dev/v4/registry"
	"go-micro.dev/v4/selector"
	"go-micro.dev/v4/util/ctx"
	"go-micro.dev/v4/util/qson"
)

const (
	// Handler is the name of this handler.
	Handler   = "rpc"
	packageID = "go.micro.api"
)

var (
	// supported json codecs.
	jsonCodecs = []string{
		"application/grpc+json",
		"application/json",
		"application/json-rpc",
	}

	// support proto codecs.
	protoCodecs = []string{
		"application/grpc",
		"application/grpc+proto",
		"application/proto",
		"application/protobuf",
		"application/proto-rpc",
		"application/octet-stream",
	}

	bufferPool = bpool.NewSizedBufferPool(1024, 8)
)

type rpcHandler struct {
	opts handler.Options
}

type buffer struct {
	io.ReadCloser
}

func (b *buffer) Write(_ []byte) (int, error) {
	return 0, nil
}

// strategy is a hack for selection.
func strategy(services []*registry.Service) selector.Strategy {
	return func(_ []*registry.Service) selector.Next {
		// ignore input to this function, use services above
		return selector.Random(services)
	}
}

func (h *rpcHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	logger := h.opts.Logger
	bsize := handler.DefaultMaxRecvSize

	if h.opts.MaxRecvSize > 0 {
		bsize = h.opts.MaxRecvSize
	}

	r.Body = http.MaxBytesReader(w, r.Body, bsize)

	defer r.Body.Close()

	var service *router.Route

	if h.opts.Router != nil {
		// try get service from router
		s, err := h.opts.Router.Route(r)
		if err != nil {
			werr := writeError(w, r, errors.InternalServerError(packageID, err.Error()))
			if werr != nil {
				logger.Log(log.ErrorLevel, werr)
			}

			return
		}

		service = s
	} else {
		// we have no way of routing the request
		werr := writeError(w, r, errors.InternalServerError(packageID, "no route found"))
		if werr != nil {
			logger.Log(log.ErrorLevel, werr)
		}
		return
	}

	contentType := r.Header.Get("Content-Type")

	// Strip charset from Content-Type (like `application/json; charset=UTF-8`)
	if idx := strings.IndexRune(contentType, ';'); idx >= 0 {
		contentType = contentType[:idx]
	}

	// micro client
	myClient := h.opts.Client

	// create context
	myContext := ctx.FromRequest(r)
	// get context from http handler wrappers
	md, ok := metadata.FromContext(r.Context())
	if !ok {
		md = make(metadata.Metadata)
	}
	// fill contex with http headers
	md["Host"] = r.Host
	md["Method"] = r.Method
	// get canonical headers
	for k := range r.Header {
		// may be need to get all values for key like r.Header.Values() provide in go 1.14
		md[textproto.CanonicalMIMEHeaderKey(k)] = r.Header.Get(k)
	}

	// merge context with overwrite
	myContext = metadata.MergeContext(myContext, md, true)

	// set merged context to request
	*r = *r.Clone(myContext)
	// if stream we currently only support json
	if isStream(r, service) {
		// drop older context as it can have timeouts and create new
		//		md, _ := metadata.FromContext(cx)
		// serveWebsocket(context.TODO(), w, r, service, c)
		if err := serveWebsocket(myContext, w, r, service, myClient); err != nil {
			logger.Log(log.ErrorLevel, err)
		}

		return
	}

	// create strategy
	mySelector := selector.WithStrategy(strategy(service.Versions))

	// walk the standard call path
	// get payload
	br, err := requestPayload(r)
	if err != nil {
		if werr := writeError(w, r, err); werr != nil {
			logger.Log(log.ErrorLevel, werr)
		}

		return
	}

	var rsp []byte

	switch {
	// proto codecs
	case hasCodec(contentType, protoCodecs):
		request := &proto.Message{}
		// if the extracted payload isn't empty lets use it
		if len(br) > 0 {
			request = proto.NewMessage(br)
		}

		// create request/response
		response := &proto.Message{}

		req := myClient.NewRequest(
			service.Service,
			service.Endpoint.Name,
			request,
			client.WithContentType(contentType),
		)

		// make the call
		if err := myClient.Call(myContext, req, response, client.WithSelectOption(mySelector)); err != nil {
			if werr := writeError(w, r, err); werr != nil {
				logger.Log(log.ErrorLevel, werr)
			}

			return
		}

		// marshall response
		rsp, err = response.Marshal()
		if err != nil {
			if werr := writeError(w, r, err); werr != nil {
				logger.Log(log.ErrorLevel, werr)
			}

			return
		}

	default:
		// if json codec is not present set to json
		if !hasCodec(contentType, jsonCodecs) {
			contentType = "application/json"
		}

		// default to trying json
		var request json.RawMessage
		// if the extracted payload isn't empty lets use it
		if len(br) > 0 {
			request = json.RawMessage(br)
		}

		// create request/response
		var response json.RawMessage

		req := myClient.NewRequest(
			service.Service,
			service.Endpoint.Name,
			&request,
			client.WithContentType(contentType),
		)
		// make the call
		if err := myClient.Call(myContext, req, &response, client.WithSelectOption(mySelector)); err != nil {
			if werr := writeError(w, r, err); werr != nil {
				logger.Log(log.ErrorLevel, werr)
			}

			return
		}

		// marshall response
		rsp, err = response.MarshalJSON()
		if err != nil {
			if werr := writeError(w, r, err); werr != nil {
				logger.Log(log.ErrorLevel, werr)
			}

			return
		}
	}

	// write the response
	if err := writeResponse(w, r, rsp); err != nil {
		logger.Log(log.ErrorLevel, err)
	}
}

func (h *rpcHandler) String() string {
	return Handler
}

func hasCodec(ct string, codecs []string) bool {
	for _, codec := range codecs {
		if ct == codec {
			return true
		}
	}

	return false
}

// requestPayload takes a *http.Request.
// If the request is a GET the query string parameters are extracted and marshaled to JSON and the raw bytes are returned.
// If the request method is a POST the request body is read and returned.
func requestPayload(r *http.Request) ([]byte, error) {
	var err error

	// we have to decode json-rpc and proto-rpc because we suck
	// well actually because there's no proxy codec right now

	myCt := r.Header.Get("Content-Type")

	switch {
	case strings.Contains(myCt, "application/json-rpc"):
		msg := codec.Message{
			Type:   codec.Request,
			Header: make(map[string]string),
		}

		c := jsonrpc.NewCodec(&buffer{r.Body})
		if err = c.ReadHeader(&msg, codec.Request); err != nil {
			return nil, err
		}

		var raw json.RawMessage
		if err = c.ReadBody(&raw); err != nil {
			return nil, err
		}

		return ([]byte)(raw), nil
	case strings.Contains(myCt, "application/proto-rpc"), strings.Contains(myCt, "application/octet-stream"):
		msg := codec.Message{
			Type:   codec.Request,
			Header: make(map[string]string),
		}

		c := protorpc.NewCodec(&buffer{r.Body})
		if err = c.ReadHeader(&msg, codec.Request); err != nil {
			return nil, err
		}

		var raw proto.Message
		if err = c.ReadBody(&raw); err != nil {
			return nil, err
		}

		return raw.Marshal()
	case strings.Contains(myCt, "application/www-x-form-urlencoded"), strings.Contains(myCt, "application/x-www-form-urlencoded"):
		if err := r.ParseForm(); err != nil {
			return nil, err
		}

		// generate a new set of values from the form
		vals := make(map[string]string)
		for k, v := range r.Form {
			vals[k] = strings.Join(v, ",")
		}

		// marshal
		return json.Marshal(vals)
		// TODO: application/grpc
	}

	// otherwise as per usual
	ctx := r.Context()

	// dont user meadata.FromContext as it mangles names
	md, ok := metadata.FromContext(ctx)
	if !ok {
		md = make(map[string]string)
	}

	// allocate maximum
	matches := make(map[string]interface{}, len(md))
	bodydst := ""

	// get fields from url path
	for k, v := range md {
		k = strings.ToLower(k)
		// filter own keys
		if strings.HasPrefix(k, "x-api-field-") {
			matches[strings.TrimPrefix(k, "x-api-field-")] = v

			delete(md, k)
		} else if k == "x-api-body" {
			bodydst = v

			delete(md, k)
		}
	}

	// map of all fields
	req := make(map[string]interface{}, len(md))

	// get fields from url values
	if len(r.URL.RawQuery) > 0 {
		umd := make(map[string]interface{})

		err = qson.Unmarshal(&umd, r.URL.RawQuery)
		if err != nil {
			return nil, err
		}

		for k, v := range umd {
			matches[k] = v
		}
	}

	// restore context without fields
	*r = *r.Clone(metadata.NewContext(ctx, md))

	for k, v := range matches {
		ps := strings.Split(k, ".")
		if len(ps) == 1 {
			req[k] = v
			continue
		}

		em := make(map[string]interface{})
		em[ps[len(ps)-1]] = v

		for i := len(ps) - 2; i > 0; i-- {
			nm := make(map[string]interface{})
			nm[ps[i]] = em
			em = nm
		}

		if vm, ok := req[ps[0]]; ok {
			// nested map
			nm := vm.(map[string]interface{})
			for vk, vv := range em {
				nm[vk] = vv
			}

			req[ps[0]] = nm
		} else {
			req[ps[0]] = em
		}
	}

	pathbuf := []byte("{}")
	if len(req) > 0 {
		pathbuf, err = json.Marshal(req)
		if err != nil {
			return nil, err
		}
	}

	urlbuf := []byte("{}")

	out, err := jsonpatch.MergeMergePatches(urlbuf, pathbuf)
	if err != nil {
		return nil, err
	}

	switch r.Method {
	case http.MethodGet:
		// empty response
		if strings.Contains(myCt, "application/json") && string(out) == "{}" {
			return out, nil
		} else if string(out) == "{}" && !strings.Contains(myCt, "application/json") {
			return []byte{}, nil
		}

		return out, nil
	case http.MethodPatch, http.MethodPost, http.MethodPut, http.MethodDelete:
		bodybuf := []byte("{}")
		buf := bufferPool.Get()

		defer bufferPool.Put(buf)
		if _, err := buf.ReadFrom(r.Body); err != nil {
			return nil, err
		}

		if b := buf.Bytes(); len(b) > 0 {
			bodybuf = b
		}

		if bodydst == "" || bodydst == "*" {
			if out, err = jsonpatch.MergeMergePatches(out, bodybuf); err == nil {
				return out, nil
			}
		}

		var jsonbody map[string]interface{}
		if json.Valid(bodybuf) {
			if err = json.Unmarshal(bodybuf, &jsonbody); err != nil {
				return nil, err
			}
		}

		dstmap := make(map[string]interface{})
		ps := strings.Split(bodydst, ".")
		if len(ps) == 1 {
			if jsonbody != nil {
				dstmap[ps[0]] = jsonbody
			} else {
				// old unexpected behavior
				dstmap[ps[0]] = bodybuf
			}
		} else {
			em := make(map[string]interface{})
			if jsonbody != nil {
				em[ps[len(ps)-1]] = jsonbody
			} else {
				// old unexpected behavior
				em[ps[len(ps)-1]] = bodybuf
			}
			for i := len(ps) - 2; i > 0; i-- {
				nm := make(map[string]interface{})
				nm[ps[i]] = em
				em = nm
			}
			dstmap[ps[0]] = em
		}

		bodyout, err := json.Marshal(dstmap)
		if err != nil {
			return nil, err
		}

		if out, err = jsonpatch.MergeMergePatches(out, bodyout); err == nil {
			return out, nil
		}

		return bodybuf, nil
	}

	return []byte{}, nil
}

func writeError(rsp http.ResponseWriter, req *http.Request, err error) error {
	ce := errors.Parse(err.Error())

	switch ce.Code {
	case 0:
		// assuming it's totally screwed
		ce.Code = http.StatusInternalServerError
		ce.Id = packageID
		ce.Status = http.StatusText(http.StatusInternalServerError)
		ce.Detail = "error during request: " + ce.Detail

		rsp.WriteHeader(http.StatusInternalServerError)
	default:
		rsp.WriteHeader(int(ce.Code))
	}

	// response content type
	rsp.Header().Set("Content-Type", "application/json")

	// Set trailers
	if strings.Contains(req.Header.Get("Content-Type"), "application/grpc") {
		rsp.Header().Set("Trailer", "grpc-status")
		rsp.Header().Set("Trailer", "grpc-message")
		rsp.Header().Set("grpc-status", "13")
		rsp.Header().Set("grpc-message", ce.Detail)
	}

	_, werr := rsp.Write([]byte(ce.Error()))

	return werr
}

func writeResponse(w http.ResponseWriter, r *http.Request, rsp []byte) error {
	w.Header().Set("Content-Type", r.Header.Get("Content-Type"))
	w.Header().Set("Content-Length", strconv.Itoa(len(rsp)))

	// Set trailers
	if strings.Contains(r.Header.Get("Content-Type"), "application/grpc") {
		w.Header().Set("Trailer", "grpc-status")
		w.Header().Set("Trailer", "grpc-message")
		w.Header().Set("grpc-status", "0")
		w.Header().Set("grpc-message", "")
	}

	// write 204 status if rsp is nil
	if len(rsp) == 0 {
		w.WriteHeader(http.StatusNoContent)
	}

	// write response
	_, err := w.Write(rsp)

	return err
}

// NewHandler returns a new RPC handler.
func NewHandler(opts ...handler.Option) handler.Handler {
	options := handler.NewOptions(opts...)

	return &rpcHandler{
		opts: options,
	}
}
