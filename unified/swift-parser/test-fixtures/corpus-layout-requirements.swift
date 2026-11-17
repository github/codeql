func sized<T>(_ value: T) where T: _Trivial(8, 4) {}
func trivial<T>(_ value: T) where T: _Trivial, T: _Class {}
