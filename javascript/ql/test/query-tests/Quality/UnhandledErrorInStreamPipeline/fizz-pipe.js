import React, { Suspense } from "react";
import { renderToPipeableStream } from "react-dom/server";
import { PassThrough } from "stream";
import { act } from "react-dom/test-utils";


const writable = new PassThrough();
let output = "";
writable.on("data", chunk => { output += chunk.toString(); });
writable.on("end", () => { /* stream ended */ });

let errors = [];
let shellErrors = [];

await act(async () => {
  renderToPipeableStream(
    <Suspense fallback={<Fallback />}>
      <Throw />
    </Suspense>,
    {
      onError(err) {
        errors.push(err.message);
      },
      onShellError(err) {
        shellErrors.push(err.message);
      }
    }
  ).pipe(writable);
});
