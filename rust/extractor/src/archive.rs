use crate::path;
use anyhow;
use log::{debug, warn};
use std::fs;
use std::path::{Path, PathBuf};

pub struct Archiver {
    pub root: PathBuf,
}

impl Archiver {
    pub fn archive(&self, source: &Path) {
        if let Err(e) = self.try_archive(source) {
            warn!("unable to archive {}: {e}", source.display());
        }
    }

    fn try_archive(&self, source: &Path) -> std::io::Result<()> {
        let mut dest = self.root.clone();
        dest.push(path::key(source));
        let parent = dest.parent().unwrap();
        if fs::metadata(&dest).is_ok() {
            return Ok(());
        }
        fs::create_dir_all(parent)?;
        fs::copy(source, dest)?;
        debug!("archived {}", source.display());
        Ok(())
    }
}
