package pool

import (
	"context"
	"net"
	"strconv"
	"sync/atomic"
	"time"
)

var noDeadline = time.Time{}

type Conn struct {
	netConn net.Conn
	rd      *ReaderContext

	ProcessID int32
	SecretKey int32
	lastID    int64

	createdAt time.Time
	usedAt    uint32 // atomic
	pooled    bool
	Inited    bool
}

func NewConn(netConn net.Conn) *Conn {
	cn := &Conn{
		createdAt: time.Now(),
	}
	cn.SetNetConn(netConn)
	cn.SetUsedAt(time.Now())
	return cn
}

func (cn *Conn) UsedAt() time.Time {
	unix := atomic.LoadUint32(&cn.usedAt)
	return time.Unix(int64(unix), 0)
}

func (cn *Conn) SetUsedAt(tm time.Time) {
	atomic.StoreUint32(&cn.usedAt, uint32(tm.Unix()))
}

func (cn *Conn) RemoteAddr() net.Addr {
	return cn.netConn.RemoteAddr()
}

func (cn *Conn) SetNetConn(netConn net.Conn) {
	cn.netConn = netConn
	if cn.rd != nil {
		cn.rd.Reset(netConn)
	}
}

func (cn *Conn) LockReader() {
	if cn.rd != nil {
		panic("not reached")
	}
	cn.rd = NewReaderContext()
	cn.rd.Reset(cn.netConn)
}

func (cn *Conn) NetConn() net.Conn {
	return cn.netConn
}

func (cn *Conn) NextID() string {
	cn.lastID++
	return strconv.FormatInt(cn.lastID, 10)
}

func (cn *Conn) WithReader(
	ctx context.Context, timeout time.Duration, fn func(rd *ReaderContext) error,
) error {
	if err := cn.netConn.SetReadDeadline(cn.deadline(ctx, timeout)); err != nil {
		return err
	}

	rd := cn.rd
	if rd == nil {
		rd = GetReaderContext()
		defer PutReaderContext(rd)

		rd.Reset(cn.netConn)
	}

	rd.bytesRead = 0

	if err := fn(rd); err != nil {
		return err
	}

	return nil
}

func (cn *Conn) WithWriter(
	ctx context.Context, timeout time.Duration, fn func(wb *WriteBuffer) error,
) error {
	wb := GetWriteBuffer()
	defer PutWriteBuffer(wb)

	if err := fn(wb); err != nil {
		return err
	}

	return cn.writeBuffer(ctx, timeout, wb)
}

func (cn *Conn) WriteBuffer(ctx context.Context, timeout time.Duration, wb *WriteBuffer) error {
	return cn.writeBuffer(ctx, timeout, wb)
}

func (cn *Conn) writeBuffer(
	ctx context.Context,
	timeout time.Duration,
	wb *WriteBuffer,
) error {
	if err := cn.netConn.SetWriteDeadline(cn.deadline(ctx, timeout)); err != nil {
		return err
	}
	if _, err := cn.netConn.Write(wb.Bytes); err != nil {
		return err
	}
	return nil
}

func (cn *Conn) Close() error {
	return cn.netConn.Close()
}

func (cn *Conn) deadline(ctx context.Context, timeout time.Duration) time.Time {
	tm := time.Now()
	cn.SetUsedAt(tm)

	if timeout > 0 {
		tm = tm.Add(timeout)
	}

	if ctx != nil {
		deadline, ok := ctx.Deadline()
		if ok {
			if timeout == 0 {
				return deadline
			}
			if deadline.Before(tm) {
				return deadline
			}
			return tm
		}
	}

	if timeout > 0 {
		return tm
	}

	return noDeadline
}
