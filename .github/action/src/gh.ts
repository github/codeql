import * as path from "path";
import * as core from "@actions/core";
import * as toolrunner from "@actions/exec/lib/toolrunner";

export interface GHConfig {
  // The path to the codeql bundle.
  path: string;
}

export async function newGHConfig(): Promise<GHConfig> {
  return {
    path: "/usr/bin/",
  };
}

export async function runCommand(
  config: GHConfig,
  args: string[],
): Promise<any> {
  var bin = path.join(config.path, "gh");
  let output = "";
  var options = {
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
  config: GHConfig,
  args: string[],
): Promise<object> {
  return JSON.parse(await runCommand(config, args));
}

export async function clonePackRepo(
  gh: GHConfig,
  path: string,
): Promise<boolean> {
  try {
    await runCommand(gh, [
      "repo",
      "clone",
      "GitHubSecurityLab/codeql-actions",
      path,
    ]);
    return true;
  } catch (error) {
    core.warning("Failed to clone pack from GitHub...");
  }
  return false;
}
