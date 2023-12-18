package pg

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"sync"
	"time"

	"github.com/go-pg/pg/v10/internal"
	"github.com/go-pg/pg/v10/internal/pool"
	"github.com/go-pg/pg/v10/types"
)

const gopgChannel = "gopg:ping"

var (
	errListenerClosed = errors.New("pg: listener is closed")
	errPingTimeout    = errors.New("pg: ping timeout")
)

// Notification which is received with LISTEN command.
type Notification struct {
	Channel string
	Payload string
}

// Listener listens for notifications sent with NOTIFY command.
// It's NOT safe for concurrent use by multiple goroutines
// except the Channel API.
type Listener struct {
	db *DB

	channels []string

	mu     sync.Mutex
	cn     *pool.Conn
	exit   chan struct{}
	closed bool

	chOnce sync.Once
	ch     chan Notification
	pingCh chan struct{}
}

func (ln *Listener) String() string {
	ln.mu.Lock()
	defer ln.mu.Unlock()

	return fmt.Sprintf("Listener(%s)", strings.Join(ln.channels, ", "))
}

func (ln *Listener) init() {
	ln.exit = make(chan struct{})
}

func (ln *Listener) connWithLock(ctx context.Context) (*pool.Conn, error) {
	ln.mu.Lock()
	cn, err := ln.conn(ctx)
	ln.mu.Unlock()

	switch err {
	case nil:
		return cn, nil
	case errListenerClosed:
		return nil, err
	case pool.ErrClosed:
		_ = ln.Close()
		return nil, errListenerClosed
	default:
		internal.Logger.Printf(ctx, "pg: Listen failed: %s", err)
		return nil, err
	}
}

func (ln *Listener) conn(ctx context.Context) (*pool.Conn, error) {
	if ln.closed {
		return nil, errListenerClosed
	}

	if ln.cn != nil {
		return ln.cn, nil
	}

	cn, err := ln.db.pool.NewConn(ctx)
	if err != nil {
		return nil, err
	}

	if err := ln.db.initConn(ctx, cn); err != nil {
		_ = ln.db.pool.CloseConn(cn)
		return nil, err
	}

	cn.LockReader()

	if len(ln.channels) > 0 {
		err := ln.listen(ctx, cn, ln.channels...)
		if err != nil {
			_ = ln.db.pool.CloseConn(cn)
			return nil, err
		}
	}

	ln.cn = cn
	return cn, nil
}

func (ln *Listener) releaseConn(ctx context.Context, cn *pool.Conn, err error, allowTimeout bool) {
	ln.mu.Lock()
	if ln.cn == cn {
		if bad, _ := isBadConn(err, allowTimeout); bad {
			ln.reconnect(ctx, err)
		}
	}
	ln.mu.Unlock()
}

func (ln *Listener) reconnect(ctx context.Context, reason error) {
	_ = ln.closeTheCn(reason)
	_, _ = ln.conn(ctx)
}

func (ln *Listener) closeTheCn(reason error) error {
	if ln.cn == nil {
		return nil
	}
	if !ln.closed {
		internal.Logger.Printf(ln.db.ctx, "pg: discarding bad listener connection: %s", reason)
	}

	err := ln.db.pool.CloseConn(ln.cn)
	ln.cn = nil
	return err
}

// Close closes the listener, releasing any open resources.
func (ln *Listener) Close() error {
	ln.mu.Lock()
	defer ln.mu.Unlock()

	if ln.closed {
		return errListenerClosed
	}
	ln.closed = true
	close(ln.exit)

	return ln.closeTheCn(errListenerClosed)
}

// Listen starts listening for notifications on channels.
func (ln *Listener) Listen(ctx context.Context, channels ...string) error {
	// Always append channels so DB.Listen works correctly.
	ln.mu.Lock()
	ln.channels = appendIfNotExists(ln.channels, channels...)
	ln.mu.Unlock()

	cn, err := ln.connWithLock(ctx)
	if err != nil {
		return err
	}

	if err := ln.listen(ctx, cn, channels...); err != nil {
		ln.releaseConn(ctx, cn, err, false)
		return err
	}

	return nil
}

func (ln *Listener) listen(ctx context.Context, cn *pool.Conn, channels ...string) error {
	err := cn.WithWriter(ctx, ln.db.opt.WriteTimeout, func(wb *pool.WriteBuffer) error {
		for _, channel := range channels {
			if err := writeQueryMsg(wb, ln.db.fmter, "LISTEN ?", pgChan(channel)); err != nil {
				return err
			}
		}
		return nil
	})
	return err
}

// Unlisten stops listening for notifications on channels.
func (ln *Listener) Unlisten(ctx context.Context, channels ...string) error {
	ln.mu.Lock()
	ln.channels = removeIfExists(ln.channels, channels...)

	cn, err := ln.conn(ctx)
	// I don't want to defer this unlock as the mutex is re-acquired in the `.releaseConn` function. But it is safe to
	// unlock here regardless of an error.
	ln.mu.Unlock()
	if err != nil {
		return err
	}

	if err := ln.unlisten(ctx, cn, channels...); err != nil {
		ln.releaseConn(ctx, cn, err, false)
		return err
	}

	return nil
}

func (ln *Listener) unlisten(ctx context.Context, cn *pool.Conn, channels ...string) error {
	err := cn.WithWriter(ctx, ln.db.opt.WriteTimeout, func(wb *pool.WriteBuffer) error {
		for _, channel := range channels {
			if err := writeQueryMsg(wb, ln.db.fmter, "UNLISTEN ?", pgChan(channel)); err != nil {
				return err
			}
		}
		return nil
	})
	return err
}

// Receive indefinitely waits for a notification. This is low-level API
// and in most cases Channel should be used instead.
func (ln *Listener) Receive(ctx context.Context) (channel string, payload string, err error) {
	return ln.ReceiveTimeout(ctx, 0)
}

// ReceiveTimeout waits for a notification until timeout is reached.
// This is low-level API and in most cases Channel should be used instead.
func (ln *Listener) ReceiveTimeout(
	ctx context.Context, timeout time.Duration,
) (channel, payload string, err error) {
	cn, err := ln.connWithLock(ctx)
	if err != nil {
		return "", "", err
	}

	err = cn.WithReader(ctx, timeout, func(rd *pool.ReaderContext) error {
		channel, payload, err = readNotification(rd)
		return err
	})
	if err != nil {
		ln.releaseConn(ctx, cn, err, timeout > 0)
		return "", "", err
	}

	return channel, payload, nil
}

// Channel returns a channel for concurrently receiving notifications.
// It periodically sends Ping notification to test connection health.
//
// The channel is closed with Listener. Receive* APIs can not be used
// after channel is created.
func (ln *Listener) Channel() <-chan Notification {
	return ln.channel(100)
}

// ChannelSize is like Channel, but creates a Go channel
// with specified buffer size.
func (ln *Listener) ChannelSize(size int) <-chan Notification {
	return ln.channel(size)
}

func (ln *Listener) channel(size int) <-chan Notification {
	ln.chOnce.Do(func() {
		ln.initChannel(size)
	})
	if cap(ln.ch) != size {
		err := fmt.Errorf("pg: Listener.Channel is called with different buffer size")
		panic(err)
	}
	return ln.ch
}

func (ln *Listener) initChannel(size int) {
	const pingTimeout = time.Second
	const chanSendTimeout = time.Minute

	ctx := ln.db.ctx
	_ = ln.Listen(ctx, gopgChannel)

	ln.ch = make(chan Notification, size)
	ln.pingCh = make(chan struct{}, 1)

	go func() {
		timer := time.NewTimer(time.Minute)
		timer.Stop()

		var errCount int
		for {
			channel, payload, err := ln.Receive(ctx)
			if err != nil {
				if err == errListenerClosed {
					close(ln.ch)
					return
				}

				if errCount > 0 {
					time.Sleep(500 * time.Millisecond)
				}
				errCount++

				continue
			}

			errCount = 0

			// Any notification is as good as a ping.
			select {
			case ln.pingCh <- struct{}{}:
			default:
			}

			switch channel {
			case gopgChannel:
				// ignore
			default:
				timer.Reset(chanSendTimeout)
				select {
				case ln.ch <- Notification{channel, payload}:
					if !timer.Stop() {
						<-timer.C
					}
				case <-timer.C:
					internal.Logger.Printf(
						ctx,
						"pg: %s channel is full for %s (notification is dropped)",
						ln,
						chanSendTimeout,
					)
				}
			}
		}
	}()

	go func() {
		timer := time.NewTimer(time.Minute)
		timer.Stop()

		healthy := true
		for {
			timer.Reset(pingTimeout)
			select {
			case <-ln.pingCh:
				healthy = true
				if !timer.Stop() {
					<-timer.C
				}
			case <-timer.C:
				pingErr := ln.ping()
				if healthy {
					healthy = false
				} else {
					if pingErr == nil {
						pingErr = errPingTimeout
					}
					ln.mu.Lock()
					ln.reconnect(ctx, pingErr)
					ln.mu.Unlock()
				}
			case <-ln.exit:
				return
			}
		}
	}()
}

func (ln *Listener) ping() error {
	_, err := ln.db.Exec("NOTIFY ?", pgChan(gopgChannel))
	return err
}

func appendIfNotExists(ss []string, es ...string) []string {
loop:
	for _, e := range es {
		for _, s := range ss {
			if s == e {
				continue loop
			}
		}
		ss = append(ss, e)
	}
	return ss
}

func removeIfExists(ss []string, es ...string) []string {
	for _, e := range es {
		for i, s := range ss {
			if s == e {
				last := len(ss) - 1
				ss[i] = ss[last]
				ss = ss[:last]
				break
			}
		}
	}
	return ss
}

type pgChan string

var _ types.ValueAppender = pgChan("")

func (ch pgChan) AppendValue(b []byte, quote int) ([]byte, error) {
	if quote == 0 {
		return append(b, ch...), nil
	}

	b = append(b, '"')
	for _, c := range []byte(ch) {
		if c == '"' {
			b = append(b, '"', '"')
		} else {
			b = append(b, c)
		}
	}
	b = append(b, '"')

	return b, nil
}
