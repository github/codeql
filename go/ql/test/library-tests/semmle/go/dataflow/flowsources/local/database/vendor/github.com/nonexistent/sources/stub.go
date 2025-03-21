package nonexistent

func Source[T any]() T {
	return *new(T)
}
