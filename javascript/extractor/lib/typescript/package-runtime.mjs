import { chmodSync, mkdirSync, readFileSync, renameSync, rmSync, statSync } from "node:fs";
import { join } from "node:path";

const platforms = {
    "linux64": ["linux-x64"],
    "linux-arm64": ["linux-arm64"],
    "osx64": ["darwin-arm64", "darwin-x64"],
    "win64": ["win32-x64"],
};
const packagesOnly = process.argv[2] === "--packages";
const distribution = process.argv[packagesOnly ? 3 : 2];
if (!Object.hasOwn(platforms, distribution)) {
    throw new Error("Unsupported CodeQL distribution: " + distribution);
}
const readJson = filename => JSON.parse(readFileSync(filename, "utf8"));
const typescript = readJson("node_modules/typescript/package.json");
if (packagesOnly) {
    console.log(platforms[distribution]
        .map(platform => "@typescript/typescript-" + platform + "@" + typescript.version).join(" "));
    process.exit(0);
}
mkdirSync("native");
for (const platform of platforms[distribution]) {
    const name = "typescript-" + platform;
    const source = join("node_modules", "@typescript", name);
    const manifest = readJson(join(source, "package.json"));
    if (manifest.name !== "@typescript/" + name
        || manifest.version !== typescript.version
        || typescript.optionalDependencies[manifest.name] !== manifest.version) {
        throw new Error("Native runtime does not match TypeScript: " + manifest.name);
    }
    const executable = join(source, "lib", platform.startsWith("win32-") ? "tsc.exe" : "tsc");
    if (!statSync(executable).isFile()) {
        throw new Error("Native executable is not a file: " + executable);
    }
    chmodSync(executable, 0o755);
    renameSync(source, join("native", name));
}
rmSync("node_modules/@typescript", { recursive: true });
