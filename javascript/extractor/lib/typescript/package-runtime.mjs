// This script is used in `BUILD.bazel` to manage the TypeScript native
// executables.
//
// Run it with an `action` argument and a `distribution` argument. On
// - packages <distribution> it prints the pinned native packages to install.
// - stage <distribution> it moves the relevant native executables into
//   `native/`, leaving `node_modules` with only the common JavaScript
//   dependencies.

import {
    chmodSync,
    mkdirSync,
    readFileSync,
    renameSync,
    rmSync,
    statSync,
} from "node:fs";
import { join } from "node:path";

const platformsByDistribution = {
    linux64: ["linux-x64"],
    "linux-arm64": ["linux-arm64"],
    osx64: ["darwin-arm64", "darwin-x64"],
    win64: ["win32-x64"],
};
const [action, distribution] = process.argv.slice(2);
if (process.argv.length !== 4 || !["packages", "stage"].includes(action)) {
    throw new Error(
        "Usage: node package-runtime.mjs <packages|stage> <distribution>",
    );
}
const platforms = platformsByDistribution[distribution];
if (platforms == null) {
    throw new Error("Unsupported CodeQL distribution: " + distribution);
}
const readJson = (filename) => JSON.parse(readFileSync(filename, "utf8"));
const typescript = readJson("node_modules/typescript/package.json");

if (action === "packages") {
    // Print the native packages for the specified distribution
    console.log(
        platforms
            .map(
                (platform) => `@typescript/typescript-${platform}@${typescript.version}`,
            )
            .join(" "),
    );
    process.exit(0);
} else {
    // Move the native Go executables for the specified distribution into the
    // `native/` directory
    mkdirSync("native");
    for (const platform of platforms) {
        const name = "typescript-" + platform;
        const source = join("node_modules", "@typescript", name);
        const manifest = readJson(join(source, "package.json"));
        if (
            manifest.name !== "@typescript/" + name ||
            manifest.version !== typescript.version ||
            typescript.optionalDependencies[manifest.name] !== manifest.version
        ) {
            throw new Error(
                "Native runtime does not match TypeScript: " + manifest.name,
            );
        }
        const executableName = platform.startsWith("win32-") ? "tsc.exe" : "tsc";
        const executable = join(source, "lib", executableName);
        if (!statSync(executable).isFile()) {
            throw new Error("Native executable is not a file: " + executable);
        }
        chmodSync(executable, 0o755);
        renameSync(source, join("native", name));
    }
    rmSync("node_modules/@typescript", { recursive: true });
}
