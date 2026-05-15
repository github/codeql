# `js/prompt-injection` Detection Report

**Date:** May 15, 2026  
**Branch:** `bazookamusic/cwe-1427`  
**Queries:** `SystemPromptInjection.ql`, `UserPromptInjection.ql`

## Summary

Evaluated 11 repositories with `js/prompt-injection` findings. **9 True Positives, 2 False Positives.**

## Detections

### 1. Harsh5225/CodeBuddy — **TP**

**Finding:** System prompt injection  
**Description:** Direct system prompt injection. User-controlled input flows into the system prompt of an LLM call without sanitization.

---

### 2. barnesy/momentum (×6 findings) — **TP**

**Finding:** System prompt injection (6 paths)  
**Description:** Multiple system prompt injection paths. User input is concatenated or interpolated into system-level prompts across several endpoints.

---

### 3. shane-reaume/TalkToDev (×3 findings) — **TP**

**Finding:** System prompt injection (3 paths)  
**Description:** Multiple system prompt injection paths. User-controlled data flows into system prompts for LLM calls.

---

### 4. huggingface/responses.js — **TP**

**Finding:** `responses.ts:271`  
**Description:** An open API endpoint populates the system prompt directly from request data. There is no authentication guarding the endpoint, meaning any caller can control the system-level instructions sent to the model.

---

### 5. FlowiseAI/Flowise — **TP**

**Finding:** `assistants/index.ts:107`  
**Description:** User input flows into the OpenAI Assistants API `instructions` field. The `instructions` field is a developer-level system prompt — it defines the assistant's behavior and is not designed for end-user content. Even though Flowise has RBAC, authenticated users can craft `instructions` that affect other users' conversations with the created assistant. Exposing this field to user input is a prompt injection vector regardless of authentication.

---

### 6. sjinnovation/CollabAI (×2 findings) — **TP**

**Finding:** `openai.js` (2 paths)  
**Description:** The POST route for creating OpenAI assistants does **not** have `authenticateUser` middleware applied. Unauthenticated users can create OpenAI assistants with arbitrary `instructions`, directly controlling the system prompt. The missing auth middleware is visible in the route definition — other routes in the same file do use `authenticateUser`.

---

### 7. theodi/chat2db — **TP**

**Finding:** `openaiClient.js:49`  
**Description:** No authentication on the `/v1/chat/completions` route. The route accepts a `messages` array from the client, which can include `role: "system"` messages. An unauthenticated caller can fully override the system prompt.

---

### 8. torarnehave1/mystmkra.io — **TP**

**Finding:** `assistants.js:58`  
**Description:** No authentication on `/assistants/*` routes. An `isAuthenticated` middleware exists in the codebase but is **not applied** to the assistant routes. Unauthenticated users can create or modify assistants with arbitrary instructions, controlling the system prompt.

---

### 9. kvadou/franchise-manager — **TP**

**Finding:** `generation.ts:449`  
**Description:** User-controlled `moduleContext.title` and `moduleContext.description` (from `request.json()`) are concatenated directly into the system prompt. Even with authentication, this is a prompt injection vector: a user can embed instructions like "Ignore all previous instructions" in the title/description fields, overriding the developer's intended system prompt behavior.

---

### 10. armando3069/AI-Inbox — **FP**

**Finding:** `ai-assistant.service.ts:121`  
**Description:** The system prompt tone is selected from a hardcoded `TONE_PROMPTS` map. User input selects which tone to use (e.g., "professional", "casual"), but the actual prompt text is developer-controlled. The false positive arose from CodeQL's array taint propagation — user-tainted content in a `{role:"user"}` message caused the entire messages array to appear tainted, including the `{role:"system"}` message with the hardcoded tone. **The `UserRoleMessageContentBarrier` now correctly blocks this.**

---

### 11. mckaywrigley/chatbot-ui — **FP**

**Finding:** `anthropic/route.ts:67`  
**Description:** Users authenticate via Supabase and provide their own Anthropic API key. The "system prompt" is a personal configuration set by the user for their own chatbot instance. The user is effectively the developer in this context — they are configuring their own model's behavior using their own API key. There is no multi-tenant risk; the system prompt only affects the user who set it.

---

## Verdict Summary

| # | Repository | Finding Location | Verdict | Key Factor |
|---|-----------|-----------------|---------|------------|
| 1 | Harsh5225/CodeBuddy | system prompt | **TP** | Direct injection |
| 2 | barnesy/momentum | ×6 locations | **TP** | Multiple injection paths |
| 3 | shane-reaume/TalkToDev | ×3 locations | **TP** | Multiple injection paths |
| 4 | huggingface/responses.js | `responses.ts:271` | **TP** | Open API, no auth |
| 5 | FlowiseAI/Flowise | `assistants/index.ts:107` | **TP** | `instructions` is developer API, not user API |
| 6 | sjinnovation/CollabAI | `openai.js` ×2 | **TP** | Missing `authenticateUser` middleware |
| 7 | theodi/chat2db | `openaiClient.js:49` | **TP** | No auth, accepts `role:"system"` |
| 8 | torarnehave1/mystmkra.io | `assistants.js:58` | **TP** | Auth exists but not applied to routes |
| 9 | kvadou/franchise-manager | `generation.ts:449` | **TP** | User content in system prompt position |
| 10 | armando3069/AI-Inbox | `ai-assistant.service.ts:121` | **FP** | Hardcoded prompts, array taint propagation |
| 11 | mckaywrigley/chatbot-ui | `anthropic/route.ts:67` | **FP** | User's own API key, self-configured |

**Precision: 9/11 (81.8%)**
