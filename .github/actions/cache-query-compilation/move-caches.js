// # Move all the existing cache into another folder, so we only preserve the cache for the current queries.
// mkdir -p ${COMBINED_CACHE_DIR}
// rm -f **/.cache/{lock,size} # -f to avoid errors if the cache is empty.
// # copy the contents of the .cache folders into the combined cache folder.
// cp -r **/.cache/* ${COMBINED_CACHE_DIR}/ || : # ignore missing files
// # clean up the .cache folders
// rm -rf **/.cache/*

const fs = require("fs");
const path = require("path");

// the first argv is the cache folder to create.
const COMBINED_CACHE_DIR = process.argv[2];

// mkdir -p ${COMBINED_CACHE_DIR}
fs.mkdirSync(COMBINED_CACHE_DIR, { recursive: true });

function walkCaches(dir, cb) {
  const files = fs.readdirSync(dir);
  for (const file of files) {
    const filePath = path.join(dir, file);
    const stat = fs.statSync(filePath);
    if (stat.isDirectory()) {
      walkCaches(filePath, cb);
      if (file === ".cache") {
        cb(filePath);
      }
    }
  }
}

// rm -f **/.cache/{lock,size} # -f to avoid errors if the cache is empty.
walkCaches(".", (dir) => {
  fs.rmSync(path.join(dir, "lock"), { force: true });
  fs.rmSync(path.join(dir, "size"), { force: true });
});

function copyDirSync(src, dest) {
  const files = fs.readdirSync(src);
  for (const file of files) {
    const srcPath = path.join(src, file);
    const destPath = path.join(dest, file);
    const stat = fs.statSync(srcPath);
    if (stat.isDirectory()) {
      if (!fs.existsSync(destPath)) {
        fs.mkdirSync(destPath);
      }
      copyDirSync(srcPath, destPath);
    } else {
      fs.copyFileSync(srcPath, destPath);
    }
  }
}

// # copy the contents of the .cache folders into the combined cache folder.
// cp -r **/.cache/* ${COMBINED_CACHE_DIR}/ || : # ignore missing files
walkCaches(".", (dir) => {
  copyDirSync(dir, COMBINED_CACHE_DIR);
});

// # clean up the .cache folders
// rm -rf **/.cache/*
walkCaches(".", (dir) => {
  fs.rmSync(dir, { recursive: true });
});
