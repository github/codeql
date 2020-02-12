type A = { x: int };
type B = { ...A, y: string };
type C<T> = {c: null | T, ...} | ((r: null | T) => mixed);
type D = { d: D, ..., };