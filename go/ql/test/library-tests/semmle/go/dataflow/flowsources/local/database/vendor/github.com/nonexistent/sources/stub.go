package sources

func Source[T any]() T {
	return *new(T)
}
