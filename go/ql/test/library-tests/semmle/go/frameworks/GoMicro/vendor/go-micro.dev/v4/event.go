package micro

import (
	"context"

	"go-micro.dev/v4/client"
)

type event struct {
	c     client.Client
	topic string
}

func (e *event) Publish(ctx context.Context, msg interface{}, opts ...client.PublishOption) error {
	return e.c.Publish(ctx, e.c.NewMessage(e.topic, msg), opts...)
}
