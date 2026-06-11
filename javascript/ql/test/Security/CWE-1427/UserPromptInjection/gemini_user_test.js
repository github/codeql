const express = require("express");
const { GoogleGenAI } = require("@google/genai");

const app = express();
const ai = new GoogleGenAI({ apiKey: "test-key" });

app.get("/test", async (req, res) => {
  const userInput = req.query.userInput;

  // === generateContent with string contents (SHOULD ALERT) ===

  await ai.models.generateContent({
    model: "gemini-2.0-flash",
    contents: userInput, // $ Alert[js/user-prompt-injection]
  });

  // === generateContent with user role parts (SHOULD ALERT) ===

  await ai.models.generateContent({
    model: "gemini-2.0-flash",
    contents: [
      {
        role: "user",
        parts: [
          {
            text: userInput, // $ Alert[js/user-prompt-injection]
          },
        ],
      },
    ],
  });

  // === generateContentStream (SHOULD ALERT) ===

  await ai.models.generateContentStream({
    model: "gemini-2.0-flash",
    contents: userInput, // $ Alert[js/user-prompt-injection]
  });

  // === generateImages (SHOULD ALERT) ===

  await ai.models.generateImages({
    model: "imagen-3.0-generate-002",
    prompt: userInput, // $ Alert[js/user-prompt-injection]
  });

  // === editImage (SHOULD ALERT) ===

  await ai.models.editImage({
    model: "imagen-3.0-generate-002",
    prompt: userInput, // $ Alert[js/user-prompt-injection]
  });

  // === generateVideos (SHOULD ALERT) ===

  await ai.models.generateVideos({
    model: "veo-2.0-generate-001",
    prompt: userInput, // $ Alert[js/user-prompt-injection]
  });

  // === Constant comparison sanitizer (SHOULD NOT ALERT) ===

  const userInput2 = req.query.userInput2;
  if (userInput2 === "hello") {
    await ai.models.generateContent({
      model: "gemini-2.0-flash",
      contents: userInput2, // OK - sanitized by constant comparison
    });
  }

  // === Model role should not be a user prompt sink ===

  await ai.models.generateContent({
    model: "gemini-2.0-flash",
    contents: [
      {
        role: "model",
        parts: [
          {
            text: userInput, // OK for user-prompt-injection (model role)
          },
        ],
      },
    ],
  });

  res.send("done");
});
