func namedOpaque() -> <T> T { () }
func constrainedOpaque() -> <T: Protocol> (T, T) { () }
func genericOpaque() -> <T, U: Protocol> Pair<T, U> { () }
func constrainedResult<U>() -> <T: Protocol where T.Element == U> T { () }
func legacy<T where T: Protocol>() {}
