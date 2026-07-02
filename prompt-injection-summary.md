# Prompt Injection Alert Validation Summary

Validation of the DCA alert-comparison report for the Python queries
`py/system-prompt-injection` (`SystemPromptInjection.ql`) and
`py/user-prompt-injection` (`UserPromptInjection.ql`).

Source report:
`github/codeql-dca-main` @ `data/prompt-injection-llm-sdks-single` → `reports/alert-comparison.md`

## Methodology

Each alert was validated by fetching and reading the actual source code of the target
repository (at the exact commit referenced in the report), inspecting both the reported
**source** (the "user-provided value") and the reported **sink** (the prompt construction),
and confirming the flow.

Classification rules applied:

- **TP (true positive):** the source is genuinely untrusted/remote input and the flow really
  reaches a prompt of the claimed role (user-role message for `user-prompt-injection`;
  system/developer/tool-description for `system-prompt-injection`). By-design / admin flows into a
  system prompt count as TP. If only a *convention* (not code) prevents injection, it is a TP.
- **Concern:** the flow is real, but there **is** input validation/sanitization that CodeQL does
  not model. Reported as a concern rather than an FP (it is still essentially a true flow).
- **FP (false positive):** static analysis was imprecise — either the flagged flow is implausible
  to ever carry attacker input (spurious path / not-really-untrusted source), or, for system-prompt
  alerts, the taint did not actually end in a system prompt (sink mis-attribution).

## Headline metrics

| Metric | Value |
| --- | --- |
| Total detections | **86** |
| True positives (TP) | **84** |
| Concerns (real flow, unmodeled sanitizer) | **1** |
| False positives (FP) | **1** |
| Precision (TP+Concern treated as real) = 85/86 | **98.8%** |
| False-positive rate = 1/86 | **1.2%** |

### By query

| Query | Total | TP | Concern | FP | Precision* |
| --- | :---: | :---: | :---: | :---: | :---: |
| `py/system-prompt-injection` | 3 | 2 | 1 | 0 | 100% |
| `py/user-prompt-injection` | 83 | 82 | 0 | 1 | 98.8% |
| **Total** | **86** | **84** | **1** | **1** | **98.8%** |

\* Precision counts genuine flows (TP + Concern) as correct; the single Concern is a real flow whose
only mitigation (a Pydantic validator + allowlist) is not modeled by CodeQL.

### Overall assessment

Both queries are **highly precise** on this corpus. The `user-prompt-injection` query is marked
`@precision low` in its metadata, yet on real-world LLM-SDK apps essentially every flow it reports is
a genuine, unmediated path from untrusted input (Flask/FastAPI/Django request bodies, webhook
payloads, Gradio/Streamlit widgets) into a user-role LLM message. The `system-prompt-injection`
query (`@precision high`) had no false positives. The only true FP was caused by inter-procedural
conflation of two identically-named `GPT` classes.

---

## System prompt injection (3)

| # | Sink | Source | Verdict |
| --- | --- | --- | --- |
| S1 | FireBird-Technologies/blog2video `template_studio_llm.py:70` (`system=`) | `template_studio.py:2030,2187` | **Concern** |
| S2 | samuelclay/NewsBlur `utils/ai_functions.py:116` (`system=`) | `apps/analyzer/views.py:377` | **TP** |
| S3 | samuelclay/NewsBlur `utils/ai_functions.py:365` (`system=`) | `apps/analyzer/views.py:377` | **TP** |

- **S1 — Concern.** The sink is genuinely the Anthropic `system=` parameter. The only user-derived
  content reaching it is `layout_id`, embedded as a markdown heading `f"## {layout_id}\n"`. That value
  comes from request models where it is either validated by a Pydantic regex `^[a-z][a-z0-9_]*$` or
  checked against an allowlist of known layouts (`meta.json`). The free-form `design_doc` / `instruction`
  fields do **not** reach `system=` (they flow only to `user=`). The flow is real and correctly points
  at a system prompt, but the character-class/allowlist restriction on `layout_id` (which makes practical
  injection implausible) is not modeled by CodeQL — hence a **Concern**, not an FP.
- **S2 / S3 — TP.** `prompt = request.POST.get("prompt", "").strip()` (a raw Django POST field) is
  interpolated into `system_message = f"""...classification criteria is: {prompt_classifier.prompt}..."""`
  and passed as `system=` to `client.messages.create(...)` (text classifier at line 116, vision classifier
  at line 365). Only a 500-character length check is applied — no content sanitization. Arbitrary
  instructions land directly in the Anthropic system prompt.

---

## User prompt injection (83)

### FireBird-Technologies/blog2video (2) — both TP

| # | Sink | Source | Verdict |
| --- | --- | --- | --- |
| U1 | `services/image_gen.py:36` (`images.generate(prompt=…)`) | `routers/projects.py:3392` | **TP** |
| U2 | `services/template_studio_llm.py:71` (`{"role":"user","content":user}`) | `routers/template_studio.py:1048,1111,2030,2187,2679,2738` | **TP** |

- **U1 — TP.** User-supplied scene-description text flows into the OpenAI image-generation `prompt=`
  argument with no content-level sanitization.
- **U2 — TP.** Free-form request-body fields (`instruction` min 5 / max 6000 chars, `design_doc` max
  40000 chars, etc.) flow through helper functions into the Anthropic user-role message. Length caps
  only; no content validation.

### LearningCircuit/local-deep-research (17) — all TP

All 17 share source `web/api.py:11` col 39–46 = the Flask **`request`** object. Every authenticated POST
endpoint does `query = request.json.get("query")` (only a `isinstance(str)` type-check — no content
sanitization) and passes `query` unchanged through the research pipeline into LLM prompts.

| # | Sink | Verdict |
| --- | --- | --- |
| U3 | `filters/cross_engine_filter.py:167` — `Query: "{query}"` → `model.invoke(prompt)` | **TP** |
| U4 | `filters/followup_relevance_filter.py:160` — `Follow-up question: "{query}"` | **TP** |
| U5 | `questions/atomic_fact_question.py:79` — `Query: {query}` | **TP** |
| U6 | `questions/atomic_fact_question.py:149` — `Original Query: {original_query}` | **TP** |
| U7 | `questions/browsecomp_question.py:96` — `Query: {query}` | **TP** |
| U8 | `questions/browsecomp_question.py:282` — `Original Query: {query}` | **TP** |
| U9 | `questions/flexible_browsecomp_question.py:61` — `…for: {query}` | **TP** |
| U10 | `questions/standard_question.py:41` — `…answer: {query}` | **TP** |
| U11 | `strategies/langgraph_agent_strategy.py:1146` — `{"role":"user","content":query}` (explicit user role) | **TP** |
| U12 | `strategies/topic_organization_strategy.py:274` — `For the research query: "{query}"` | **TP** |
| U13 | `strategies/topic_organization_strategy.py:909` — refinement prompt w/ original query | **TP** |
| U14 | `strategies/topic_organization_strategy.py:1658` — `RESEARCH QUESTION TO ANSWER: {query}` | **TP** |
| U15 | `strategies/topic_organization_strategy.py:1706` — same `topic_prompt` loop | **TP** |
| U16 | `citation_handlers/base_citation_handler.py:41` — `self.llm.stream(prompt)` | **TP** |
| U17 | `citation_handlers/base_citation_handler.py:83` — `self.llm.invoke(prompt)` | **TP** |
| U18 | `citation_handlers/base_citation_handler.py:91` — `self.llm.invoke(prompt)` | **TP** |
| U19 | `report_generator.py:166` — `Analyze this research content about: {query}` | **TP** |

### PostHog/posthog (2) — both TP

| # | Sink | Source | Verdict |
| --- | --- | --- | --- |
| U20 | `user_interviews/backend/max_tools.py:61` | `presentation/webhooks.py:363` | **TP** |
| U21 | `user_interviews/backend/max_tools.py:71` | `presentation/webhooks.py:363` | **TP** |

Untrusted Vapi `end-of-call-report` webhook fields (`transcript` / `summary`, i.e. the interviewee's
speech) are stored via the ORM and later joined into `interview_summaries_text`, which is placed in the
user-role message of a `gpt-4.1-mini` call. DB-mediated but a genuine indirect-injection vector.

### Significant-Gravitas/AutoGPT (1) — TP

| # | Sink | Source | Verdict |
| --- | --- | --- | --- |
| U22 | `backend/data/tally.py:411` — `{"role":"user","content":f"{_EXTRACTION_PROMPT}{formatted_text}…"}` | `api/features/v1.py:388` (`OnboardingProfileRequest`) | **TP** |

User-controlled onboarding-profile fields (`user_name`, `user_role`, `pain_points`) from a FastAPI POST
body are formatted verbatim into the user-role extraction prompt.

### SocialAI-tianji/Tianji (1) — TP

| # | Sink | Source | Verdict |
| --- | --- | --- | --- |
| U23 | `agents/metagpt_agents/utils/agent_llm.py:106` — `{"role":"user","content":prompt}` | `run/demo_agent_metagpt.py:100` (`st.chat_input()`) | **TP** |

### aliasrobotics/cai (1) — TP

| # | Sink | Source | Verdict |
| --- | --- | --- | --- |
| U24 | `sdk/agents/items.py:220` — `[{"content":input,"role":"user"}]` | `api/app.py:567,655,709,830` (FastAPI `payload.input`/`payload.prompt`) | **TP** |

### egolife-ai/Ego-R1 (6) — 5 TP, 1 FP

| # | Sink | Source | Verdict |
| --- | --- | --- | --- |
| U25 | `api/rag/r1rag/utils.py:49` (`"content"` user array) | 8 FastAPI `/query` endpoints (`request.keywords`) | **TP** |
| U26 | `api/rag/r1rag/utils.py:52` (`"text": prompt`) | same 8 endpoints | **TP** |
| U27 | `api/visual_tools/egor1_vlm/utils.py:61` (`{"role":"user","content":message}`) | 3 `/vlm` endpoints (`request.question`) | **TP** |
| U28 | `api/visual_tools/egoschema_vlm/utils.py:92` | same 3 `/vlm` endpoints | **TP** |
| U29 | `api/visual_tools/videomme_vlm/utils.py:62` | same 3 `/vlm` endpoints | **TP** |
| U30 | `cott_gen/utils.py:100` | 3 `visual_tools` `/vlm` endpoints | **FP** |

- **U30 — FP (the only false positive).** The reported taint path is spurious. The `visual_tools` API
  handlers only ever instantiate their *own* local `GPT` class (in `api/visual_tools/*/utils.py`).
  `cott_gen/` is a separate offline chain-of-thought pipeline with an independently-defined `GPT` class
  that is never imported or invoked by any API endpoint. CodeQL conflated the two identically-named
  `GPT` classes with matching `chat(self, message, …)` signatures (duck-typed dispatch), producing an
  inter-procedural path that has no concrete call chain. **Imprecision — sink not actually reachable
  from the source.**

### ezgisubasi/youtube-rag-assistant (3) — all TP

Source for all three: `app.py:224` `st.chat_input("Ask about leadership or business...")`.

| # | Sink | Verdict |
| --- | --- | --- |
| U31 | `src/services/rag_service.py:213` — user query in eval prompt → `llm.invoke` | **TP** |
| U32 | `src/services/rag_service.py:307` — `.format(..., question=question)` → `llm.invoke` | **TP** |
| U33 | `src/services/rag_service.py:323` — web-fallback prompt → `llm.invoke` | **TP** |

### llnl/open-ai-co-scientist (1) — TP

| # | Sink | Source | Verdict |
| --- | --- | --- | --- |
| U34 | `app/utils.py:57` — `{"role":"user","content":prompt}` | `app.py:492-496,508-511` (Gradio `gr.Textbox` "Research Goal") | **TP** |

### openai/openai-agents-python (1) — TP

| # | Sink | Source | Verdict |
| --- | --- | --- | --- |
| U35 | `examples/mcp/manager_example/app.py:107` — `Runner.run(..., input=req.input)` | same file:93 (FastAPI `RunRequest.input`) | **TP** |

Example/demo code, but the flow (HTTP body → agent user turn) is technically a valid injection path.

### samuelclay/NewsBlur — archive_extension (1) — TP

| # | Sink | Source | Verdict |
| --- | --- | --- | --- |
| U36 | `apps/archive_extension/views.py:1134` — `{"role":"user","content":prompt}` | same file:1063 (`request.POST.get("category")`) | **TP** |

The `category` POST field (only `.strip()` applied) is interpolated into the user-role Claude message.

### showlab/computer_use_ootb (2) — both TP

Sources: Gradio inputs `app.py:248` / `app.py:598`.

| # | Sink | Verdict |
| --- | --- | --- |
| U37 | `computer_use_demo/gui_agent/actor/uitars_agent.py:59` — `{"type":"text","text":task}` in user role | **TP** |
| U38 | `computer_use_demo/gui_agent/actor/uitars_agent.py:60` — same user-role content array | **TP** |

### suki0dayo/AI_film_studio (3) — all TP

Source for all three: `app.py:6` (`from flask import ... request`) — the standard CodeQL Flask taint
origin node; the concrete untrusted value is `request.json['user_prompt']` in the `/api/llm` POST
handler. (Line 6 is the request import node, **not** a constant — not an FP.)

| # | Sink | Verdict |
| --- | --- | --- |
| U39 | `app.py:488` — `{'role':'user','parts':[{'text':user_prompt}]}` (Gemini) | **TP** |
| U40 | `app.py:540` — `{'role':'user','content':user_prompt}` (OpenAI-compat) | **TP** |
| U41 | `app.py:546` — outbound `/chat/completions` POST carrying that user-role message | **TP** |

### truera/trulens (1) — TP

| # | Sink | Source | Verdict |
| --- | --- | --- | --- |
| U42 | `examples/.../openai_agent_sdk_snowflake_tools/src/agent/app.py:155` — `Runner.run_sync(support_agent, question)` | `.../server.py:78` (FastAPI `ChatRequest.message`) | **TP** |

Example/expositional code, but the HTTP-body → agent user-turn flow is a valid injection path.

### xusenlinzy/api-for-open-llm (2) — both TP

Source for both: `streamlit_app.py:36` `st.chat_input("What is up?")`.

| # | Sink | Verdict |
| --- | --- | --- |
| U43 | `streamlit-demo/.../multimodal_chat/streamlit_app.py:44` — `{"role":"user","content":[{"type":"text","text":prompt}]}` | **TP** |
| U44 | `streamlit-demo/.../multimodal_chat/streamlit_app.py:47` — `"text": prompt` in same user-role array | **TP** |

### mdbabumiamssm/LLMs-Universal-Life-Science-and-Clinical-Skills- (38) — all TP

Vendored `awesome-llm-apps` demos under
`Skills/External_Collections/awesome-llm-apps/`. Every alert is a Streamlit widget
(`st.text_input` / `st.text_area` / `st.chat_input`) flowing unmodified into a user-role LLM message
(`{"role":"user",...}`, `HumanMessage(...)`, `('human', ...)`, or `Runner.run(agent, user_input)`).
No sanitization or allowlisting exists in any of these files.

| # | Sink file:line | Source | Verdict |
| --- | --- | --- | --- |
| U45 | `.../ai_3dpygame_r1/ai_3dpygame_r1.py:91` | `st.text_area` :58 | **TP** |
| U46 | `.../ai_customer_support_agent/customer_support_agent.py:67` | `st.chat_input` :192 | **TP** |
| U47 | `.../ai_deep_research_agent/deep_research_openai.py:140` | `st.text_input` :57 | **TP** |
| U48 | `.../ai_deep_research_agent/deep_research_openai.py:159` | `st.text_input` :57 | **TP** |
| U49 | `.../ai_system_architect_r1/ai_system_architect_r1.py:201` | `st.chat_input` :302 | **TP** |
| U50 | `.../ai_travel_agent_memory/travel_agent_memory.py:95` | `st.chat_input` :71 | **TP** |
| U51 | `.../llm_app_personalized_memory/llm_app_memory.py:61` | `st.text_input` :42 | **TP** |
| U52 | `.../multi_llm_memory/multi_llm_memory.py:75` | `st.text_input` :57 | **TP** |
| U53 | `.../1_starter_agent/app.py:110` | `st.chat_input` :99 | **TP** |
| U54 | `.../1_starter_agent/app.py:117` | `st.chat_input` :99 | **TP** |
| U55 | `.../1_starter_agent/app.py:129` | `st.chat_input` :99 | **TP** |
| U56 | `.../4_running_agents/agent_runner.py:173` | `st.text_input` :165 | **TP** |
| U57 | `.../4_running_agents/agent_runner.py:196` | `st.text_input` :188 | **TP** |
| U58 | `.../4_running_agents/agent_runner.py:227` | `st.text_input` :211 | **TP** |
| U59 | `.../4_running_agents/agent_runner.py:266` | `st.text_input` :256 | **TP** |
| U60 | `.../4_running_agents/agent_runner.py:309` | `st.text_input` :298 | **TP** |
| U61 | `.../4_running_agents/agent_runner.py:378` | `st.text_input` :361 | **TP** |
| U62 | `.../4_running_agents/agent_runner.py:427` | `st.text_input` :407 | **TP** |
| U63 | `.../4_running_agents/agent_runner.py:480` | `st.text_input` :459 | **TP** |
| U64 | `.../4_running_agents/agent_runner.py:536` | `st.text_input` :512 | **TP** |
| U65 | `.../4_running_agents/agent_runner.py:613` | `st.text_input` :604 | **TP** |
| U66 | `.../4_running_agents/agent_runner.py:635` | `st.text_input` :629 | **TP** |
| U67 | `.../7_sessions/streamlit_sessions_app.py:158` | `st.text_input` :152 | **TP** |
| U68 | `.../7_sessions/streamlit_sessions_app.py:187` | `st.text_input` :181 | **TP** |
| U69 | `.../7_sessions/streamlit_sessions_app.py:219` | `st.text_input` :213 | **TP** |
| U70 | `.../7_sessions/streamlit_sessions_app.py:307` | `st.text_input` :301 | **TP** |
| U71 | `.../7_sessions/streamlit_sessions_app.py:327` | `st.text_input` :321 | **TP** |
| U72 | `.../7_sessions/streamlit_sessions_app.py:352` | `st.text_input` :346 | **TP** |
| U73 | `.../7_sessions/streamlit_sessions_app.py:366` | `st.text_input` :360 | **TP** |
| U74 | `.../7_sessions/streamlit_sessions_app.py:391` | `st.text_input` :385 | **TP** |
| U75 | `.../hybrid_search_rag/main.py:123` | `st.chat_input` :190 | **TP** |
| U76 | `.../llama3.1_local_rag/llama3.1_local_rag.py:53` | `st.text_input` :85 | **TP** |
| U77 | `.../rag_agent_cohere/rag_agent_cohere.py:237` | `st.chat_input` :279 | **TP** |
| U78 | `.../rag_database_routing/rag_database_routing.py:292` | `st.text_input` :376 | **TP** |
| U79 | `.../rag-as-a-service/rag_app.py:102` | `st.text_input` :185 | **TP** |
| U80 | `.../opeani_research_agent/research_agent.py:196` | `st.text_input` :143 | **TP** |
| U81 | `.../customer_support_voice_agent/customer_support_voice_agent.py:290` | `st.text_input` :349 | **TP** |
| U82 | `.../voice_rag_openaisdk/rag_voice.py:248` | `st.text_input` :359 | **TP** |

---

## Concerns (unmodeled mitigations)

- **S1 (FireBird blog2video, `system=` at `template_studio_llm.py:70`).** Real flow into a system
  prompt, but the only user-derived component (`layout_id`) is constrained by a Pydantic regex
  `^[a-z][a-z0-9_]*$` and/or an allowlist of known layout ids, which CodeQL does not model. Practical
  injection is unlikely, but the query is technically correct to flag the flow. If desired, such regex
  allowlist validators could be added as barriers to the `SystemPromptInjection` sanitizer set.

Additional observations that are **not** downgraded (still TP):

- Several NewsBlur / AutoGPT flows apply only a *length* check (e.g. `len(prompt) > 500`) — this is not
  content sanitization and does not neutralize injection.
- PostHog (U20/U21) is a DB-mediated indirect-injection flow (voice transcript persisted, then re-read
  into a prompt) — a legitimate, if less obvious, injection vector.
- `openai/openai-agents-python` (U35) and `truera/trulens` (U42) are example/demo apps; classification
  reflects the technical validity of the flow, independent of the code's demo status.

## False positives (1)

- **U30 (egolife-ai/Ego-R1, `cott_gen/utils.py:100`).** Spurious inter-procedural path caused by
  conflating two distinct classes both named `GPT` with identical `chat(self, message, …)` signatures.
  The `visual_tools` API endpoints never call the `cott_gen` `GPT`; no concrete call chain exists, so
  the sink is not actually reachable from the reported source. This is a genuine static-analysis
  precision issue (duck-typed method-name/signature conflation).
