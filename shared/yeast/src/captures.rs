use std::collections::{BTreeMap, BTreeSet};

use crate::Id;

#[derive(Debug, Clone)]
pub struct Captures {
    captures: BTreeMap<&'static str, Vec<Id>>,
}

impl Default for Captures {
    fn default() -> Self {
        Self::new()
    }
}

impl Captures {
    pub fn new() -> Self {
        Captures {
            captures: BTreeMap::new(),
        }
    }

    pub fn get_var(&self, key: &str) -> Result<Id, String> {
        let ids = self.captures.get(key);
        if let Some(ids) = ids {
            if ids.len() == 1 {
                Ok(ids[0])
            } else {
                Err(format!(
                    "Variable {} has {} matches, use * to allow repetition",
                    key,
                    ids.len()
                ))
            }
        } else {
            Err(format!("No variable named {key}"))
        }
    }

    /// Get all values of a capture variable (for repeated captures).
    pub fn get_all(&self, key: &str) -> Vec<Id> {
        self.captures.get(key).cloned().unwrap_or_default()
    }

    /// Get an optional capture variable. Returns None if unmatched,
    /// Some(id) if matched exactly once.
    pub fn get_opt(&self, key: &str) -> Option<Id> {
        self.captures
            .get(key)
            .and_then(|ids| if ids.len() == 1 { Some(ids[0]) } else { None })
    }

    pub fn insert(&mut self, key: &'static str, id: Id) {
        self.captures.entry(key).or_default().push(id);
    }

    pub fn map_captures(&mut self, kind: &str, f: &mut impl FnMut(Id) -> Id) {
        if let Some(ids) = self.captures.get_mut(kind) {
            for id in ids {
                *id = f(*id);
            }
        }
    }

    /// Apply a fallible function to every captured id (across all keys),
    /// replacing each id with the results. A function returning an empty
    /// vector removes the capture; returning multiple ids splices them
    /// into the capture's value list (suitable for `*`/`+` captures).
    /// Stops and returns the error on the first failure.
    pub fn try_map_all_captures<E>(
        &mut self,
        mut f: impl FnMut(Id) -> Result<Vec<Id>, E>,
    ) -> Result<(), E> {
        for ids in self.captures.values_mut() {
            let mut new_ids = Vec::with_capacity(ids.len());
            for &id in ids.iter() {
                new_ids.extend(f(id)?);
            }
            *ids = new_ids;
        }
        Ok(())
    }
    pub fn map_captures_to(&mut self, from: &str, to: &'static str, f: &mut impl FnMut(Id) -> Id) {
        if let Some(from_ids) = self.captures.get(from) {
            let new_values = from_ids.iter().copied().map(f).collect();
            self.captures.insert(to, new_values);
        }
    }

    pub fn merge(&mut self, other: &Captures) {
        for (key, ids) in &other.captures {
            self.captures.entry(key).or_default().extend(ids);
        }
    }

    pub fn un_star<'a>(
        &'a self,
        children: &'a BTreeSet<&'static str>,
    ) -> Result<impl Iterator<Item = Captures> + 'a, String> {
        let mut id_iter = children.iter();

        if let Some(fst) = id_iter.next() {
            let repeats = self
                .captures
                .get(fst)
                .ok_or_else(|| format!("No variable named {fst}"))?
                .len();
            // TODO: better error on missing capture
            if id_iter.any(|id| self.captures.get(id).map(Vec::len).unwrap_or(0) != repeats) {
                return Err("Repeated captures must have the same number of matches".to_string());
            }
            Ok((0..repeats).map(move |iter| {
                let mut new_vars: Captures = Captures::new();
                for id in children {
                    let child_capture = self.captures.get(id).unwrap()[iter];
                    new_vars.captures.insert(id, vec![child_capture]);
                }
                new_vars
            }))
        } else {
            Err("Repeated captures must have at least one capture".to_string())
        }
    }
}
