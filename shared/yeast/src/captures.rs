use std::collections::{BTreeMap, BTreeSet};

use crate::Id;

#[derive(Debug, Clone)]
pub struct Captures {
    captures: BTreeMap<&'static str, Vec<Id>>,
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
            Err(format!("No variable named {}", key))
        }
    }

    pub fn insert(&mut self, key: &'static str, id: Id) {
        self.captures.entry(key).or_default().push(id);
    }

    pub fn map_captures(&mut self, kind : &str, f: &mut impl FnMut(Id) -> Id) {
        self.captures.get_mut(kind).map( |ids| {
            for id in ids {
                *id = f(*id);
            }
        });
    }
    pub fn map_captures_to(&mut self, from : &str, to: &'static str, f: &mut  impl FnMut(Id) -> Id) {
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
                .ok_or_else(|| format!("No variable named {}", fst))?
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
