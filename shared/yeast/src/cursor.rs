pub trait Cursor<'a, T, N, F> {
    fn node(&self) -> &'a N;
    fn field_id(&self) -> Option<F>;
    fn goto_first_child(&mut self) -> bool;
    fn goto_next_sibling(&mut self) -> bool;
    fn goto_parent(&mut self) -> bool;
}
