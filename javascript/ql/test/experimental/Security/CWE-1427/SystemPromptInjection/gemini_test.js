const express = require("express");
const { GoogleGenAI } = require("@google/genai");

const app = express();
const ai = new GoogleGenAI({ apiKey: "test-key" });

app.get("/test", async (req, res) => {
  const persona = req.query.persona;
  const query = req.query.query;

  // === generateContent: systemInstruction ===

  // SHOULD ALERT
  const g1 = await ai.models.generateContent({
    model: "gemini-2.0-flash",
    contents: "Hello",
    config: {
      systemInstruction: "Talk like a " + persona, // $ Alert[js/system-prompt-injection]
    },
  });

  // === generateContent: contents with model role ===

  // SHOULD ALERT
  const g2 = await ai.models.generateContent({
    model: "gemini-2.0-flash",
    contents: [
      {
        role: "model",
        parts: [{ text: "Talk like a " + persona }], // $ Alert[js/system-prompt-injection]
      },
      {
        role: "user",
        parts: [{ text: query }],
      },
    ],
  });

  // === generateContent: contents with user role ===

  // SHOULD NOT ALERT
  const g3 = await ai.models.generateContent({
    model: "gemini-2.0-flash",
    contents: [
      {
        role: "user",
        parts: [{ text: query }], // OK - user role
      },
    ],
  });

  // === generateContentStream: systemInstruction ===

  // SHOULD ALERT
  const g4 = await ai.models.generateContentStream({
    model: "gemini-2.0-flash",
    contents: "Hello",
    config: {
      systemInstruction: "Talk like a " + persona, // $ Alert[js/system-prompt-injection]
    },
  });

  // === generateImages: prompt ===

  // SHOULD ALERT
  const g5 = await ai.models.generateImages({
    model: "imagen-3.0-generate-002",
    prompt: "Draw a picture of " + persona, // $ Alert[js/system-prompt-injection]
  });

  // === editImage: prompt ===

  // SHOULD ALERT
  const g6 = await ai.models.editImage({
    model: "imagen-3.0-capability-001",
    prompt: "Edit to look like " + persona, // $ Alert[js/system-prompt-injection]
  });

  // === chats.create: systemInstruction ===

  // SHOULD ALERT
  const chat = ai.chats.create({
    model: "gemini-2.0-flash",
    config: {
      systemInstruction: "Talk like a " + persona, // $ Alert[js/system-prompt-injection]
    },
  });

  // === chat.sendMessage: per-request systemInstruction ===

  // SHOULD ALERT
  await chat.sendMessage({
    message: query,
    config: {
      systemInstruction: "Talk like a " + persona, // $ Alert[js/system-prompt-injection]
    },
  });

  // === live.connect: systemInstruction ===

  // SHOULD ALERT
  const session = await ai.live.connect({
    model: "gemini-2.0-flash-live-001",
    config: {
      systemInstruction: "Talk like a " + persona, // $ Alert[js/system-prompt-injection]
    },
    callbacks: {
      onmessage: (msg) => {},
    },
  });

  // === Sanitizer: constant comparison ===

  // SHOULD NOT ALERT
  if (persona === "pirate") {
    const g7 = await ai.models.generateContent({
      model: "gemini-2.0-flash",
      contents: "Hello",
      config: {
        systemInstruction: "Talk like a " + persona, // OK - sanitized by constant check
      },
    });
  }

  res.send("done");
});
