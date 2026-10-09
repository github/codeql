import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { McpServer, ResourceTemplate } from "@modelcontextprotocol/sdk/server/mcp.js";
import { McpServer as McpServerNoSuffix } from "@modelcontextprotocol/sdk/server/mcp";
import { CallToolRequestSchema } from "@modelcontextprotocol/sdk/types.js";
import { McpServer as McpServerV2, Server as ServerV2 } from "@modelcontextprotocol/server";
import { z } from "zod";

declare function SINK(value: unknown): void;

const server = new McpServer({ name: "test", version: "1.0.0" });

// Tools and prompts: the first parameter of the callback holds the arguments.
server.tool("run", { command: z.string() }, async ({ command }) => { // $ threat-source=remote
  SINK(command); // $ hasFlow
  return { content: [] };
});

server.tool("read", "Read a file", { path: z.string() }, async (args) => { // $ threat-source=remote
  SINK(args.path); // $ hasFlow
  return { content: [] };
});

server.registerTool("fetch", { inputSchema: { url: z.string() } }, async ({ url }) => { // $ threat-source=remote
  SINK(url); // $ hasFlow
  return { content: [] };
});

async function namedHandler({ target }: { target: string }) { // $ threat-source=remote
  SINK(target); // $ hasFlow
  return { content: [] };
}
server.tool("remove", { target: z.string() }, namedHandler);

server.prompt("summarize", { topic: z.string() }, ({ topic }) => { // $ threat-source=remote
  SINK(topic); // $ hasFlow
  return { messages: [] };
});

server.registerPrompt("explain", { argsSchema: { file: z.string() } }, ({ file }) => { // $ threat-source=remote
  SINK(file); // $ hasFlow
  return { messages: [] };
});

// Resources: the URI and the variables of the template.
server.resource("note", new ResourceTemplate("note://{name}", { list: undefined }), async (uri, { name }) => { // $ threat-source=remote
  SINK(uri.href); // $ hasFlow
  SINK(name); // $ hasFlow
  return { contents: [] };
});

server.registerResource("page", new ResourceTemplate("page://{host}", { list: undefined }), {}, async (uri, variables) => { // $ threat-source=remote
  SINK(variables.host); // $ hasFlow
  return { contents: [] };
});

// The request headers and the bearer token that the SDK hands to a callback.
server.tool("forward", { id: z.string() }, async (_args, extra) => { // $ threat-source=remote
  SINK(extra.requestInfo?.headers["x-target"]); // $ hasFlow threat-source=remote
  SINK(extra.authInfo?.token); // $ hasFlow threat-source=remote
  SINK(extra.sessionId);
  return { content: [] };
});

// The low-level server: handlers receive the request.
const lowLevel = new Server({ name: "test", version: "1.0.0" }, { capabilities: { tools: {} } });
lowLevel.setRequestHandler(CallToolRequestSchema, async (request) => {
  SINK(request.params.arguments?.command); // $ hasFlow threat-source=remote
  return { content: [] };
});

server.server.setRequestHandler(CallToolRequestSchema, async (request) => {
  SINK(request.params.name); // $ hasFlow threat-source=remote
  return { content: [] };
});

// An import path without the file suffix, and a server that arrives as a typed parameter.
new McpServerNoSuffix({ name: "test", version: "1.0.0" }).tool("run", { command: z.string() }, async ({ command }) => { // $ threat-source=remote
  SINK(command); // $ hasFlow
  return { content: [] };
});

export function register(target: McpServer) {
  target.tool("run", { command: z.string() }, async ({ command }) => { // $ threat-source=remote
    SINK(command); // $ hasFlow
    return { content: [] };
  });
}

// Version 2 of the SDK: one package, and a context object instead of `extra`.
const serverV2 = new McpServerV2({ name: "test", version: "2.0.0" });
serverV2.registerTool("fetch", { inputSchema: z.object({ url: z.string() }) }, async ({ url }, ctx) => { // $ threat-source=remote
  SINK(url); // $ hasFlow
  SINK(ctx.http?.req.headers.get("x-target")); // $ hasFlow threat-source=remote
  SINK(ctx.http?.authInfo?.token); // $ hasFlow threat-source=remote
  return { content: [] };
});

const lowLevelV2 = new ServerV2({ name: "test", version: "2.0.0" });
lowLevelV2.setRequestHandler("tools/call", async (request) => {
  SINK(request.params.arguments); // $ hasFlow threat-source=remote
  return { content: [] };
});

lowLevelV2.setRequestHandler("acme/search", { params: z.object({ query: z.string() }), result: z.object({}) }, async (params) => { // $ threat-source=remote
  SINK(params.query); // $ hasFlow
  return {};
});

// Not registered with a server: no source.
export function notAHandler(command: string) {
  SINK(command);
}
