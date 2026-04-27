# Agent Execution Guide

This file tells future coding agents how to execute one large step from
`refrence_files/master-plan.md` without losing progress across context windows.

The repo source of truth is the master plan. The epub.js/WKWebView technical
source of truth is `refrence_files/epubjs-wkwebview-knowledge-base.md`.

## Standard User Prompt

Use this prompt when you want one large master-plan step executed end to end:

```text
Read agents.md, refrence_files/master-plan.md, and refrence_files/epubjs-wkwebview-knowledge-base.md.
Execute exactly NEXT_TASK from the master plan as one large step.
Work step by step, validate each slice, update the master plan only after verification passes,
and leave a resumable handoff if context gets tight.
```

Use this prompt to continue in a new context window:

```text
Read agents.md, refrence_files/master-plan.md, refrence_files/epubjs-wkwebview-knowledge-base.md,
and refrence_files/agent-handoff.md if it exists.
Continue the in-progress master-plan task from the handoff.
Do not restart completed slices. Validate before marking the task complete.
```

## Required Start Protocol

At the start of every execution turn:

1. Read `refrence_files/master-plan.md`.
2. Read `refrence_files/epubjs-wkwebview-knowledge-base.md`.
3. If present, read `refrence_files/agent-handoff.md`.
4. Identify `LAST_COMPLETED`, `NEXT_TASK`, the target task block, and its `TARGET`, `IMPL`, and `VERIFY` lines.
5. Inspect the current code before planning edits.
6. Check `git status --short` and do not revert unrelated user changes.

Do not advance beyond the requested task unless the user explicitly asks.

## Execution Model

Treat a large master-plan task as a sequence of small slices.

For each slice:

1. Define the behavioral outcome.
2. Identify the files to read and edit.
3. Make the smallest coherent implementation change.
4. Run the narrowest validation for that slice.
5. Fix failures before moving to the next slice.
6. Update `refrence_files/agent-handoff.md` with completed slices and remaining work.

Do not mark the master-plan checkbox complete until the task-level `VERIFY` condition passes.

## Handoff File

If the task is larger than one context window, create or update:

`refrence_files/agent-handoff.md`

Use this format:

```md
# Agent Handoff

Task: 2c.5 Go-to-location and footnote intercept
Started: YYYY-MM-DD

## Goal
One-sentence goal copied from the master-plan task.

## Completed Slices
- [x] Slice name, files changed, validation run.

## In Progress
- Current slice and exact next command or file to inspect.

## Remaining Slices
- [ ] Slice name.

## Important Decisions
- Decision and reason.

## Validation Status
- JS syntax: pass/fail/not run.
- Xcode build: pass/fail/not run.
- Simulator smoke: pass/fail/not run.

## Known Risks
- Anything the next agent must not forget.
```

The handoff must be factual and resumable. Do not use it as a diary.

## Validation Commands

Run the JavaScript host parse check after editing `EpubReader/Resources/reader.html`:

```sh
ruby -e 'html = File.read("EpubReader/Resources/reader.html"); script = html[/<script>([\s\S]*)<\/script>/, 1]; abort("script not found") unless script; ok = system("/usr/bin/osascript", "-l", "JavaScript", "-e", "new Function(#{script.dump}); true;"); exit(ok ? 0 : 1)'
```

Run the Xcode CLI build before marking any task complete:

```sh
xcodebuild -project EpubReader.xcodeproj -scheme EpubReader -destination 'generic/platform=iOS Simulator' -derivedDataPath /tmp/EpubReaderDerivedData CODE_SIGNING_ALLOWED=NO build
```

If the task affects reader behavior, run or request a simulator smoke check:

- Open a known EPUB.
- Confirm readable text appears.
- Confirm `bookReady` appears in logs.
- Confirm `relocated` updates CFI and percentage.
- Confirm page curl, tap zones, TOC, scrubber, go-to-location, footnotes, and appearance changes still work when relevant to the task.

Known non-blocking build warning:

```text
Metadata extraction skipped. No AppIntents.framework dependency found.
```

Do not treat that warning as a task failure unless the task is about AppIntents.

## Current Reader Invariants

These apply to all EPUB reader tasks:

- Swift 6, iOS 17+.
- No new third-party libraries unless the master plan explicitly says so.
- EPUB rendering uses vendored epub.js in `EpubReader/Resources/`, not a CDN.
- WKWebView count is capped at three for page curl.
- WKWebViews share one `WKProcessPool`.
- JS bridge uses `LeakAvoider`.
- Script message handlers are removed on teardown.
- WebContent process termination is handled.
- Current visible slot is the only source allowed to update reader progress.
- Adjacent page-curl slots must be synced from canonical CFI, not blindly advanced from stale state.
- Appearance changes must reflow text and preserve CFI.
- Location generation/cache must support meaningful percentages.

## Master Plan Update Rules

Only update `refrence_files/master-plan.md` after validation passes.

When a task is complete:

1. Change its checkbox from `[ ]` to `[x]`.
2. Update `LAST_COMPLETED`.
3. Update `NEXT_TASK` to the next unchecked task.
4. Increment `TASKS_DONE` if the plan uses that counter.
5. Do not reformat unrelated sections.
6. Do not edit `INVARIANTS` or `ARCH` unless the user explicitly asks.

If validation fails and cannot be fixed in the current context, leave the task unchecked and update `refrence_files/agent-handoff.md`.

## Codebase Work Rules

- Prefer existing project patterns over new abstractions.
- Use `rg` and `rg --files` for search.
- Use `apply_patch` for manual edits.
- Do not use destructive git commands.
- Do not revert unrelated dirty worktree changes.
- Keep changes scoped to the task.
- Swift comments should be doc comments only unless a complex block needs a short explanation.
- No force unwraps unless construction guarantees the value and the reason is documented.

## Final Response Format

When done, report:

```text
Completed [task ID]: [task title].

Changed:
- File and behavior summary.

Validation:
- JS syntax: pass/not applicable.
- Xcode build: pass.
- Simulator smoke: pass/manual check needed.

Next: [next task ID and title].
```

If not done, report:

```text
Paused [task ID]: [task title].

Completed:
- Slice summaries.

Blocked/Remaining:
- Exact issue or next slice.

Handoff:
- refrence_files/agent-handoff.md updated.
```
