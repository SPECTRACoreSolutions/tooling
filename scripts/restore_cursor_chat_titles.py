#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Restore Cursor Chat Titles from SpecStory Files

This script:
1. Extracts session IDs and first messages from SpecStory files
2. Queries Cursor's state.vscdb SQLite database
3. Matches session IDs to chat entries
4. Updates chat titles based on first user message

WARNING: Close Cursor completely before running this script!
"""

import sqlite3
import json
import re
from pathlib import Path
from datetime import datetime
import sys
import os

# Fix Windows console encoding
if sys.platform == 'win32':
    import io
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
    sys.stderr = io.TextIOWrapper(sys.stderr.buffer, encoding='utf-8', errors='replace')

# Paths
SPECSTORY_DIR = Path(".specstory/history")
CURSOR_DB = Path.home() / "AppData/Roaming/Cursor/User/globalStorage/state.vscdb"
BACKUP_DB = Path.home() / "AppData/Roaming/Cursor/User/globalStorage/state.vscdb.backup"

def extract_specstory_info():
    """Extract session IDs and titles from SpecStory files."""
    if not SPECSTORY_DIR.exists():
        print(f"[ERROR] SpecStory directory not found: {SPECSTORY_DIR}")
        return []

    untitled_files = list(SPECSTORY_DIR.glob("*-untitled.md"))
    print(f"[INFO] Found {len(untitled_files)} untitled SpecStory files")

    sessions = []
    for file in untitled_files:
        content = file.read_text(encoding='utf-8')

        # Extract session ID
        session_match = re.search(r'cursor Session ([a-f0-9-]+)', content)
        if not session_match:
            continue

        session_id = session_match.group(1)

        # Extract first user message (potential title)
        first_user_match = re.search(r'\*\*User.*?\)\*\*\s*\n\n(.+?)(?:\n\n|$)', content, re.DOTALL)
        if first_user_match:
            first_message = first_user_match.group(1).strip()
            # Generate title from first message (max 60 chars)
            title = first_message[:60] + "..." if len(first_message) > 60 else first_message
        else:
            # Fallback: use filename timestamp
            title = file.stem.replace("-untitled", "").replace("_", " ").replace("Z", "")

        sessions.append({
            'session_id': session_id,
            'title': title,
            'file': file.name,
            'timestamp': file.stat().st_mtime
        })

    return sessions

def backup_database():
    """Create backup of Cursor database."""
    if not CURSOR_DB.exists():
        print(f"[ERROR] Cursor database not found: {CURSOR_DB}")
        return False

    print(f"[INFO] Backing up database...")
    import shutil
    shutil.copy2(CURSOR_DB, BACKUP_DB)
    print(f"[OK] Backup created: {BACKUP_DB}")
    return True

def query_database_schema():
    """Query database schema to understand structure."""
    if not CURSOR_DB.exists():
        print(f"[ERROR] Cursor database not found: {CURSOR_DB}")
        return None

    try:
        conn = sqlite3.connect(str(CURSOR_DB))
        cursor = conn.cursor()

        # Get all table names
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
        tables = cursor.fetchall()

        print(f"[INFO] Found {len(tables)} tables in database")

        # Look for chat-related tables
        chat_tables = [t[0] for t in tables if 'chat' in t[0].lower() or 'session' in t[0].lower()]
        if chat_tables:
            print(f"[INFO] Chat-related tables: {chat_tables}")
            for table in chat_tables:
                cursor.execute(f"PRAGMA table_info({table})")
                columns = cursor.fetchall()
                print(f"  {table}: {[c[1] for c in columns]}")

        # Look for Item table (VS Code/Cursor often uses this)
        if 'Item' in [t[0] for t in tables]:
            cursor.execute("PRAGMA table_info(Item)")
            columns = cursor.fetchall()
            print(f"  Item table: {[c[1] for c in columns]}")

        # Check for key-value storage (common in VS Code/Cursor)
        kv_tables = [t[0] for t in tables if 'item' in t[0].lower() or 'keyvalue' in t[0].lower()]
        if kv_tables:
            print(f"[INFO] Key-value tables: {kv_tables}")
            for table in kv_tables[:3]:  # Limit to first 3
                cursor.execute(f"SELECT COUNT(*) FROM {table}")
                count = cursor.fetchone()[0]
                print(f"  {table}: {count} rows")
                # Sample a few rows to understand structure
                cursor.execute(f"SELECT * FROM {table} LIMIT 2")
                samples = cursor.fetchall()
                if samples:
                    print(f"    Sample keys: {[str(s[0])[:50] for s in samples]}")

                # Search for chat-related keys
                cursor.execute(f"SELECT key FROM {table} WHERE key LIKE '%chat%' OR key LIKE '%session%' OR key LIKE '%conversation%' LIMIT 10")
                chat_keys = cursor.fetchall()
                if chat_keys:
                    print(f"    Chat-related keys found: {len(chat_keys)}")
                    for key in chat_keys[:5]:
                        print(f"      - {key[0]}")

                # Inspect interactive.sessions structure
                cursor.execute(f"SELECT value FROM {table} WHERE key = 'interactive.sessions'")
                sessions_data = cursor.fetchone()
                if sessions_data:
                    try:
                        sessions_json = json.loads(sessions_data[0])
                        print(f"\n[INFO] interactive.sessions structure:")
                        if isinstance(sessions_json, dict):
                            print(f"  Type: dict with {len(sessions_json)} keys")
                            print(f"  Top-level keys: {list(sessions_json.keys())[:5]}")
                            # Check if it's a list of sessions
                            if len(sessions_json) > 0:
                                first_key = list(sessions_json.keys())[0]
                                first_value = sessions_json[first_key]
                                if isinstance(first_value, dict):
                                    print(f"  Sample session keys: {list(first_value.keys())[:10]}")
                        elif isinstance(sessions_json, list):
                            print(f"  Type: list with {len(sessions_json)} items")
                            if len(sessions_json) > 0:
                                print(f"  Sample item keys: {list(sessions_json[0].keys())[:10] if isinstance(sessions_json[0], dict) else 'Not a dict'}")
                    except json.JSONDecodeError:
                        print(f"  [WARNING] Value is not valid JSON")
                        print(f"  First 200 chars: {sessions_data[0][:200]}")

        conn.close()
        return True
    except sqlite3.OperationalError as e:
        if "database is locked" in str(e):
            print("[ERROR] Database is locked! Close Cursor completely and try again.")
        else:
            print(f"[ERROR] Database error: {e}")
        return False

def restore_titles(sessions):
    """Restore chat titles in Cursor database."""
    if not CURSOR_DB.exists():
        print(f"[ERROR] Cursor database not found: {CURSOR_DB}")
        return False

    try:
        conn = sqlite3.connect(str(CURSOR_DB))
        cursor = conn.cursor()

        # This is a placeholder - we need to understand the actual schema first
        # The schema query above will help us understand the structure

        print("[WARNING] Schema exploration needed before restore")
        print("   Run with --explore flag to see database structure")

        conn.close()
        return True
    except sqlite3.OperationalError as e:
        if "database is locked" in str(e):
            print("[ERROR] Database is locked! Close Cursor completely and try again.")
        else:
            print(f"[ERROR] Database error: {e}")
        return False

def main():
    print("=" * 60)
    print("Cursor Chat Title Restore Tool")
    print("=" * 60)
    print()

    # Check if Cursor is running (optional - requires psutil)
    skip_check = '--force' in sys.argv
    if not skip_check:
        try:
            import psutil
            cursor_running = any('cursor' in p.name().lower() for p in psutil.process_iter(['name']))
            if cursor_running:
                print("[WARNING] Cursor appears to be running!")
                print("   Close Cursor completely before running this script.")
                print("   Use --force flag to skip this check")
                return
        except ImportError:
            print("[INFO] psutil not available - skipping process check")
            print("[WARNING] Make sure Cursor is closed before proceeding!")

    # Extract SpecStory info
    sessions = extract_specstory_info()
    if not sessions:
        print("[ERROR] No untitled SpecStory files found")
        return

    print(f"\n[INFO] Found {len(sessions)} sessions to restore:")
    for session in sessions:
        print(f"  - {session['session_id'][:8]}... -> {session['title']}")

    # Explore database schema
    if '--explore' in sys.argv:
        print("\n[INFO] Exploring database schema...")
        query_database_schema()
        return

    # Backup database
    if not backup_database():
        return

    # Restore titles (placeholder - needs schema understanding)
    print("\n[WARNING] Restore functionality requires schema understanding")
    print("   Run with --explore flag first to see database structure")
    print("   Then we can implement the actual restore logic")

if __name__ == "__main__":
    main()
