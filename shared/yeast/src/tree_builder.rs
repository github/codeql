use std::cell::Cell;
use std::collections::BTreeMap;

/// Tracks fresh identifier generation during a single tree-building operation.
/// All occurrences of the same `$name` within one build share the same generated value.
pub struct FreshScope {
    counter: Cell<u32>,
    resolved: std::cell::RefCell<BTreeMap<String, String>>,
}

impl Default for FreshScope {
    fn default() -> Self {
        Self::new()
    }
}

impl FreshScope {
    pub fn new() -> Self {
        Self {
            counter: Cell::new(0),
            resolved: std::cell::RefCell::new(BTreeMap::new()),
        }
    }

    pub fn resolve(&self, name: &str) -> String {
        self.resolved
            .borrow_mut()
            .entry(name.to_string())
            .or_insert_with(|| {
                let id = self.counter.get();
                self.counter.set(id + 1);
                format!("${name}-{id}")
            })
            .clone()
    }

    /// Clear resolved names but keep the counter. Called between rule
    /// applications so that `$tmp` in different rules gets different values
    /// while the counter increases monotonically.
    pub fn next_scope(&self) {
        self.resolved.borrow_mut().clear();
    }
}
