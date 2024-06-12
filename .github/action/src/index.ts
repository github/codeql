import * as path from "path";
import * as core from "@actions/core";
import * as cql from "./codeql";

/**
 * The main function for the action.
 * @returns {Promise<void>} Resolves when the action is complete.
 */
export async function run(): Promise<void> {
  try {
    // set up codeql
    var codeql = await cql.newCodeQL();

    core.debug(`CodeQL CLI found at '${codeql.path}'`);

    await cql.runCommand(codeql, ["version", "--format", "terse"]);

    // check javascript support
    var languages = await cql.runCommandJson(codeql, [
      "resolve",
      "languages",
      "--format",
      "json",
    ]);

    if (!languages.hasOwnProperty("javascript")) {
      core.setFailed("CodeQL javascript extractor not installed");
      throw new Error("CodeQL javascript extractor not installed");
    }

    // download pack
    core.info(`Downloading CodeQL Actions pack '${codeql.pack}'`);
    var pack_downloaded = await cql.downloadPack(codeql);

    if (pack_downloaded === false) {
      var action_path = path.resolve(path.join(__dirname, "..", "..", ".."));
      codeql.pack = path.join(action_path, "ql", "src");

      core.info(`Pack defaulting back to local pack: '${codeql.pack}'`);
    } else {
      core.info(`Pack downloaded '${codeql.pack}'`);
    }

    core.info("Creating CodeQL database...");
    var database_path = await cql.codeqlDatabaseCreate(codeql);

    core.info("Running CodeQL analysis...");
    var sarif = await cql.codeqlDatabaseAnalyze(codeql, database_path);

    core.info(`SARIF results: '${sarif}'`);
    core.setOutput("sarif", sarif);

    core.info("Finished CodeQL analysis");
  } catch (error) {
    // Fail the workflow run if an error occurs
    if (error instanceof Error) core.setFailed(error.message);
  }
}

// eslint-disable-next-line @typescript-eslint/no-floating-promises
run();
