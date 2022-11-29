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

function* walkCaches(dir) {
  const files = fs.readdirSync(dir, { withFileTypes: true });
  for (const file of files) {
    if (file.isDirectory()) {
      const filePath = path.join(dir, file.name);
      yield* walkCaches(filePath);
      if (file.name === ".cache") {
        yield filePath;
      }
    }
  }
}

async function copyDir(src, dest) {
  for await (const file of await fs.promises.readdir(src, { withFileTypes: true })) {
    const srcPath = path.join(src, file.name);
    const destPath = path.join(dest, file.name);
    if (file.isDirectory()) {
      if (!fs.existsSync(destPath)) {
        fs.mkdirSync(destPath);
      }
      await copyDir(srcPath, destPath);
    } else {
      await fs.promises.copyFile(srcPath, destPath);
    }
  }
}

async function main() {
  const cacheDirs = [...walkCaches(".")];

  for (const dir of cacheDirs) {
    console.log(`Found .cache dir at ${dir}`);
  }

  // mkdir -p ${COMBINED_CACHE_DIR}
  fs.mkdirSync(COMBINED_CACHE_DIR, { recursive: true });

  // rm -f **/.cache/{lock,size} # -f to avoid errors if the cache is empty.
  await Promise.all(
    cacheDirs.map((cacheDir) =>
      (async function () {
        await fs.promises.rm(path.join(cacheDir, "lock"), { force: true });
        await fs.promises.rm(path.join(cacheDir, "size"), { force: true });
      })()
    )
  );

  // # copy the contents of the .cache folders into the combined cache folder.
  // cp -r **/.cache/* ${COMBINED_CACHE_DIR}/ || : # ignore missing files
  await Promise.all(
    cacheDirs.map((cacheDir) => copyDir(cacheDir, COMBINED_CACHE_DIR))
  );

  // # clean up the .cache folders
  // rm -rf **/.cache/*
  await Promise.all(
    cacheDirs.map((cacheDir) => fs.promises.rm(cacheDir, { recursive: true }))
  );
}
main();
