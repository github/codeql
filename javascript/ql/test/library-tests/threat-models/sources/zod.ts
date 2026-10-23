import { z } from "zod";
import * as z4 from "zod/v4";

declare function SINK(value: unknown): void;

const raw = JSON.parse(process.argv[2]); // $ threat-source=commandargs

const Options = z.object({ command: z.string() });
const NextOptions = z4.object({ command: z4.string() });

SINK(Options.parse(raw).command); // $ hasFlow
SINK(NextOptions.parse(raw).command); // $ hasFlow

const checked = Options.safeParse(raw);
if (checked.success) {
  SINK(checked.data.command); // $ hasFlow
}
SINK(checked.error);

async function later() {
  SINK((await Options.parseAsync(raw)).command); // $ hasFlow

  const result = await Options.safeParseAsync(raw);
  if (result.success) {
    SINK(result.data.command); // $ hasFlow
  }
}

// A value that did not come from a source stays clean.
SINK(Options.parse({ command: "ls" }).command);
