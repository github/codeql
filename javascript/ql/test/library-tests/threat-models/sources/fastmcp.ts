import { FastMCP } from "fastmcp";
import { z } from "zod";

declare function SINK(value: unknown): void;

const server = new FastMCP({ name: "test", version: "1.0.0" });

server.addTool({
  name: "run",
  parameters: z.object({ command: z.string() }),
  execute: async (args) => { // $ threat-source=remote
    SINK(args.command); // $ hasFlow
    return "";
  },
});

server.addResourceTemplate({
  uriTemplate: "note://{name}",
  name: "note",
  arguments: [{ name: "name" }],
  async load({ name }) { // $ threat-source=remote
    SINK(name); // $ hasFlow
    return { text: "" };
  },
});

server.addPrompt({
  name: "summarize",
  arguments: [{ name: "topic" }],
  load: async ({ topic }) => { // $ threat-source=remote
    SINK(topic); // $ hasFlow
    return "";
  },
});

// A static resource takes no arguments: no source.
server.addResource({
  uri: "file:///log",
  name: "log",
  async load() {
    return { text: "" };
  },
});
