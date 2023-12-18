# bufpool

[![Build Status](https://travis-ci.org/vmihailenco/bufpool.svg)](https://travis-ci.org/vmihailenco/bufpool)
[![GoDoc](https://godoc.org/github.com/vmihailenco/bufpool?status.svg)](https://godoc.org/github.com/vmihailenco/bufpool)

bufpool is an implementation of a pool of byte buffers with anti-memory-waste protection. It is based on the code and ideas from these 2 projects:
- https://github.com/libp2p/go-buffer-pool
- https://github.com/valyala/bytebufferpool

bufpool consists of global pool of buffers that have a capacity of a power of 2 starting from 64 bytes to 32 megabytes. It also provides individual pools that maintain usage stats to provide buffers of the size that satisfies 95% of the calls. Global pool is used to reuse buffers between different parts of the app.

# Installation

``` go
go get github.com/vmihailenco/bufpool
```

# Usage

bufpool can be used as a replacement for `sync.Pool`:

``` go
var jsonPool bufpool.Pool // basically sync.Pool with usage stats

func writeJSON(w io.Writer, obj interface{}) error {
	buf := jsonPool.Get()
	defer jsonPool.Put(buf)

	if err := json.NewEncoder(buf).Encode(obj); err != nil {
		return err
	}

	_, err := w.Write(buf.Bytes())
	return err
}
```

or to allocate buffer of the given size:

``` go
func writeHex(w io.Writer, data []byte) error {
	n := hex.EncodedLen(len(data)))

	buf := bufpool.Get(n) // buf.Len() is guaranteed to equal n
	defer bufpool.Put(buf)

	tmp := buf.Bytes()
	hex.Encode(tmp, data)

	_, err := w.Write(tmp)
	return err
}
```

If you need to append data to the buffer you can use following pattern:

``` go
buf := bufpool.Get(n)
defer bufpool.Put(buf)

bb := buf.Bytes()[:0]

bb = append(bb, ...)

buf.ResetBuf(bb)
```

You can also change default pool thresholds:

``` go
var jsonPool = bufpool.Pool{
	ServePctile:   0.95, // serve p95 buffers
}
```
