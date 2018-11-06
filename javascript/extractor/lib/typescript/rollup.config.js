import resolve from "rollup-plugin-node-resolve";
import commonjs from "rollup-plugin-commonjs";
import * as fs from "fs";
import * as pathlib from "path";

const copyTypeScriptFiles = (options) => ({
  generateBundle() {
    if (!fs.existsSync('dist')) {
      fs.mkdirSync('dist');
    }
    let typescriptDir = pathlib.dirname(require.resolve("typescript"));
    for (let file of fs.readdirSync(typescriptDir)) {
      // Don't include bundles like `tsc.js`.
      if (file.endsWith(".js")) continue;

      // Only include library typings, not `typescript.d.ts` and friends
      if (file.endsWith(".d.ts") && !file.startsWith("lib")) continue;

      let filePath = `${typescriptDir}/${file}`;

      // Skip directories. They contain locale translations and are not needed.
      if (fs.statSync(filePath).isDirectory()) continue;

      fs.copyFileSync(filePath, `dist/${file}`);
    }
  }
});

export default {
  input: 'build/main.js',
  output: {
    file: 'dist/main.js',
    format: 'cjs'
  },
  plugins: [
    resolve(), // Resolve paths using Node.js rules
    commonjs({ // Make rollup understand `require`
      ignore: [ 'source-map-support' ] // Optional required - do not hoist to top-level.
    }),
    copyTypeScriptFiles(), // Copy files needed by TypeScript compiler
  ],
  // List Node.js modules to avoid warnings about unresolved modules.
  external: [
    'buffer',
    'crypto',
    'fs',
    'os',
    'path',
    'readline',
  ],
}
