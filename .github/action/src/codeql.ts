import * as fs from "fs";
import * as path from "path";

import * as core from "@actions/core";
import * as toolcache from "@actions/tool-cache";
import * as toolrunner from "@actions/exec/lib/toolrunner";

export interface CodeQLConfig {
  // The path to the codeql bundle.
  path: string;
  // The language to use for analysis.
  language: string;
  // CodeQL pack to use for analysis.
  pack: string;
  // The codeql suite to use for analysis.
  suite: string;
  // The source root to use for analysis.
  source_root?: string;
  // The output file for the SARIF file.
  output?: string;
}

export async function newCodeQL(): Promise<CodeQLConfig> {
  return {
    language: "yaml",
    path: await findCodeQL(),
    pack: "githubsecuritylab/actions-queries",
    suite: `codeql-suites/${core.getInput("suite") || "actions-code-scanning"}.qls`,
    source_root: core.getInput("source-root"),
    output: core.getInput("sarif"),
  };
}

export async function runCommand(
  config: CodeQLConfig,
  args: string[],
  cwd_arg?: string,
): Promise<any> {
  var bin = path.join(config.path, "codeql");
  let output = "";
  var cwd: string = process.cwd();
  if (cwd_arg) {
    cwd = cwd_arg;
  }
  core.info("Current working directory: " + cwd);
  var options = {
    cwd: cwd,
    listeners: {
      stdout: (data: Buffer) => {
        output += data.toString();
      },
    },
  };

  await new toolrunner.ToolRunner(bin, args, options).exec();
  core.debug(`Finished running command :: ${bin} ${args.join(" ")}`);

  return output.trim();
}

export async function runCommandJson(
  config: CodeQLConfig,
  args: string[],
): Promise<object> {
  return JSON.parse(await runCommand(config, args));
}
async function findCodeQL(): Promise<string> {
  // check if codeql is in the toolcache
  var codeqlPath = await findCodeQlInToolcache();
  if (codeqlPath !== undefined) {
    return codeqlPath;
  }
  // default to the codeql in the path
  return "codeql";
}

async function findCodeQlInToolcache(): Promise<string | undefined> {
  const candidates = toolcache
    .findAllVersions("CodeQL")
    .map((version) => ({
      folder: toolcache.find("CodeQL", version),
      version,
    }))
    .filter(({ folder }) => fs.existsSync(path.join(folder, "pinned-version")));

  if (candidates.length === 1) {
    const candidate = candidates[0];
    core.info(`CodeQL tools found in toolcache: '${candidate.folder}'.`);
    core.debug(`CodeQL toolcache version: '${candidate.version}'.`);

    return path.join(candidate.folder, "codeql");
  }

  core.warning(`No CodeQL tools found in toolcache.`);

  return undefined;
}

export async function downloadPack(codeql: CodeQLConfig): Promise<boolean> {
  try {
    await runCommand(codeql, ["pack", "download", codeql.pack]);
    return true;
  } catch (error) {
    core.warning("Failed to download pack from GitHub...");
  }
  return false;
}

export async function codeqlDatabaseCreate(
  codeql: CodeQLConfig,
): Promise<string> {
  // get runner temp directory for database
  var temp = process.env["RUNNER_TEMP"];
  if (temp === undefined) {
    temp = "/tmp";
  }
  var database_path = path.join(temp, "codeql-actions-db");
  var source_root =
    codeql.source_root || process.env["GITHUB_WORKSPACE"] || "./";

  await runCommand(codeql, [
    "database",
    "create",
    "--language",
    codeql.language,
    "--source-root",
    source_root,
    database_path,
  ]);

  return database_path;
}

export async function codeqlDatabaseAnalyze(
  codeql: CodeQLConfig,
  database_path: string,
): Promise<string> {
  var codeql_output = codeql.output || "codeql-actions.sarif";

  var cmd = [
    "database",
    "analyze",
    "--format",
    "sarif-latest",
    "--sarif-add-query-help",
    "--output",
    codeql_output,
  ];

  const useWorkflowModels = process.env["USE_WORKFLOW_MODELS"];
  if (useWorkflowModels !== undefined && useWorkflowModels == "true") {
    cmd.push("--extension-packs", "local/workflow-models");
  }

  // remote pack or local pack
  if (codeql.pack.startsWith("githubsecuritylab/")) {
    var suite = codeql.pack + ":" + codeql.suite;
  } else {
    // assume path
    var suite = path.join(codeql.pack, codeql.suite);
    cmd.push("--search-path", codeql.pack);
  }

  cmd.push(database_path, suite);

  await runCommand(codeql, cmd);

  return codeql_output;
}
