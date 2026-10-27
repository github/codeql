use std::collections::{BTreeMap, BTreeSet};

use crate::{Id, OutputId};

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

    pub(crate) fn try_translate_except<E>(
        &self,
        skip: &[&str],
        mut f: impl FnMut(Id) -> Result<Vec<OutputId>, E>,
    ) -> Result<TranslatedCaptures, E> {
        let mut translated = TranslatedCaptures::new();
        for (name, ids) in &self.captures {
            if skip.contains(name) {
                continue;
            }
            for &id in ids {
                for translated_id in f(id)? {
                    translated.insert(name, translated_id);
                }
            }
        }
        Ok(translated)
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

/// Output ids produced by eagerly translating non-raw query captures.
#[derive(Debug, Clone, Default)]
pub struct TranslatedCaptures {
    captures: BTreeMap<&'static str, Vec<OutputId>>,
}

impl TranslatedCaptures {
    pub fn new() -> Self {
        Self::default()
    }

    pub fn get_var(&self, key: &str) -> Result<OutputId, String> {
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

    pub fn get_all(&self, key: &str) -> Vec<OutputId> {
        self.captures.get(key).cloned().unwrap_or_default()
    }

    pub fn get_opt(&self, key: &str) -> Option<OutputId> {
        self.captures
            .get(key)
            .and_then(|ids| if ids.len() == 1 { Some(ids[0]) } else { None })
    }

    fn insert(&mut self, key: &'static str, id: OutputId) {
        self.captures.entry(key).or_default().push(id);
    }
}
