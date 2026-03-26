# Restore Cursor Chat Titles - Guide

**Status:** 🔍 Exploration Phase
**Created:** 2026-01-11
**Purpose:** Restore chat titles that were lost during Cursor crash

---

## Problem

During a Cursor crash on 2026-01-10, several chat sessions lost their titles and were saved as "untitled" in SpecStory. The chat content is preserved in SpecStory files, but Cursor's internal chat history shows them as "Untitled".

---

## What We Have

### SpecStory Files (5 untitled chats)
- `2026-01-08_00-57Z-untitled.md` - Session ID: `8ef2343d...`
- `2026-01-10_14-25Z-untitled.md` - Session ID: `90621081...`
- `2026-01-10_15-18Z-untitled.md` - Session ID: `afdb645b-d7bb-4bb8-906f-c2bbadb3522e`
- `2026-01-10_17-52Z-untitled.md` - Session ID: `bed01373...`
- `2026-01-10_23-47Z-untitled.md` - Session ID: `8a65439a...`

**Each SpecStory file contains:**
- Session ID (UUID format)
- First user message (can be used to generate title)
- Full chat content
- Timestamp

### Cursor Database Structure

**Location:** `%APPDATA%\Cursor\User\globalStorage\state.vscdb`
**Size:** 3.8 GB
**Type:** SQLite database

**Tables Found:**
- `ItemTable` - Key-value storage (238 rows)

**Chat-Related Keys Found:**
- `interactive.sessions` - Empty list (likely because Cursor is running)
- `chat.workspaceTransfer`
- `conversationClassificationScoredConversations`

---

## Current Status

### ✅ Completed
1. Created restore script: `Core/tooling/scripts/restore_cursor_chat_titles.py`
2. Extracted session IDs and titles from SpecStory files
3. Explored database schema
4. Identified `interactive.sessions` as potential storage location

### ⚠️ Blockers
1. **Database is locked when Cursor is running** - Must close Cursor completely
2. **Schema unknown** - Need to understand how chat sessions are stored
3. **Session matching** - Need to match SpecStory session IDs to Cursor's internal IDs

---

## How to Restore (Manual Process)

### Option 1: Manual Rename in Cursor UI (Easiest)

1. **Open Cursor**
2. **Open Chat History** (usually in sidebar or `Ctrl+Shift+P` → "Chat History")
3. **Find "Untitled" chats** from the dates:
   - 2026-01-08 00:57Z
   - 2026-01-10 14:25Z
   - 2026-01-10 15:18Z
   - 2026-01-10 17:52Z
   - 2026-01-10 23:47Z
4. **For each untitled chat:**
   - Open the chat
   - Read the first user message
   - Right-click → Rename (or use rename option)
   - Enter a descriptive title based on the first message

**Suggested Titles:**
- `2026-01-10_15-18Z`: "standardise registries. lets pick up the idea from the queue and run it through the orchestrator"
- `2026-01-10_14-25Z`: Check first message in SpecStory file
- `2026-01-10_17-52Z`: Check first message in SpecStory file
- `2026-01-10_23-47Z`: Check first message in SpecStory file
- `2026-01-08_00-57Z`: Check first message in SpecStory file

### Option 2: Automated Restore (Requires Schema Understanding)

**Prerequisites:**
1. Close Cursor completely
2. Backup `state.vscdb` first
3. Understand database schema

**Steps:**
1. Run exploration:
   ```bash
   python Core/tooling/scripts/restore_cursor_chat_titles.py --explore --force
   ```

2. Once schema is understood, implement restore logic in script

3. Run restore:
   ```bash
   python Core/tooling/scripts/restore_cursor_chat_titles.py --force
   ```

**⚠️ WARNING:** Direct database modification is risky and could corrupt Cursor state. Always backup first!

---

## Next Steps

### Immediate (Manual)
1. Use Option 1 (Manual Rename) to restore titles quickly
2. Document the process for future reference

### Future (Automated - Part of Archive Service)
1. Build restore capability into `archive` service
2. Understand Cursor's database schema fully
3. Create safe restore API that:
   - Backs up database automatically
   - Validates session IDs
   - Updates titles safely
   - Provides rollback capability

---

## Script Usage

### Explore Database Schema
```bash
python Core/tooling/scripts/restore_cursor_chat_titles.py --explore --force
```

### Extract Session Info
```bash
python Core/tooling/scripts/restore_cursor_chat_titles.py --force
```

### Restore Titles (Not yet implemented)
```bash
# Close Cursor first!
python Core/tooling/scripts/restore_cursor_chat_titles.py --force
```

---

## Related

- **Archive Service Idea:** `Core/labs/queue/ideas.json` (id: `archive-service-001`)
- **SpecStory Files:** `.specstory/history/`
- **Cursor Database:** `%APPDATA%\Cursor\User\globalStorage\state.vscdb`

---

## Notes

- Cursor's chat history is stored in SQLite database
- Session IDs in SpecStory match Cursor's internal session IDs
- Database is locked when Cursor is running (must close first)
- Manual rename is safest option until automated restore is fully tested
