# MCP Configuration Examples

This file contains configuration templates for different AI tools.

## Claude (Desktop)

**File:** `~/.claude/claude_desktop_config.json`

```json
{
  "mcpServers": {
    "obsidian": {
      "command": "uvx",
      "args": ["mcp-obsidian"],
      "env": {
        "OBSIDIAN_API_KEY": "YOUR_API_KEY_HERE",
        "OBSIDIAN_HOST": "192.168.88.30",
        "OBSIDIAN_PORT": "27124"
      }
    }
  }
}
```

**Notes:**
- Uses `uvx` to automatically manage the mcp-obsidian package
- No need to pre-install mcp-obsidian if you have `uv` installed
- Requires: `uv` package manager

---

## GitHub Copilot CLI

**File:** `~/.copilot/mcp-config.json`

```json
{
  "mcpServers": {
    "obsidian": {
      "type": "local",
      "command": "mcp-obsidian",
      "args": [],
      "tools": ["*"],
      "env": {
        "OBSIDIAN_API_KEY": "YOUR_API_KEY_HERE",
        "OBSIDIAN_HOST": "192.168.88.30",
        "OBSIDIAN_PORT": "27124"
      }
    }
  }
}
```

**Notes:**
- Requires: `mcp-obsidian` installed via `pip install mcp-obsidian`
- Direct command execution

---

## Claude Codex (Codeium)

**File:** `~/.codex/mcp.json`

```json
{
  "mcpServers": {
    "obsidian": {
      "type": "local",
      "command": "mcp-obsidian",
      "args": [],
      "tools": ["*"],
      "env": {
        "OBSIDIAN_API_KEY": "YOUR_API_KEY_HERE",
        "OBSIDIAN_HOST": "192.168.88.30",
        "OBSIDIAN_PORT": "27124"
      }
    }
  }
}
```

**Notes:**
- Requires: `mcp-obsidian` installed via `pip install mcp-obsidian`
- Direct command execution

---

## Cline (VS Code Extension)

**File:** `~/.cline/cline_mcp_config.json`

```json
{
  "mcpServers": {
    "obsidian": {
      "type": "local",
      "command": "mcp-obsidian",
      "args": [],
      "tools": ["*"],
      "env": {
        "OBSIDIAN_API_KEY": "YOUR_API_KEY_HERE",
        "OBSIDIAN_HOST": "192.168.88.30",
        "OBSIDIAN_PORT": "27124"
      }
    }
  }
}
```

**Notes:**
- Requires: `mcp-obsidian` installed via `pip install mcp-obsidian`
- Direct command execution

---

## Installation Summary

### Prerequisites for All Tools
1. **Obsidian** with **Local REST API plugin** enabled
2. **API Key** from the plugin settings

### Option A: Using pip (for all except Claude with uvx)
```bash
pip install mcp-obsidian
```

### Option B: Using uvx (Claude only)
```bash
# No installation needed, uvx manages it
# But you need to have `uv` installed
brew install uv  # macOS
# or
apt install uv   # Ubuntu/Debian
```

---

## Setup Steps by Tool

### For Claude Desktop
1. Install `uv`: `brew install uv` (macOS) or `apt install uv` (Linux)
2. Create `~/.claude/claude_desktop_config.json`
3. Restart Claude

### For GitHub Copilot CLI
1. Install: `pip install mcp-obsidian`
2. Create `~/.copilot/mcp-config.json`
3. Restart GitHub Copilot

### For Claude Codex
1. Install: `pip install mcp-obsidian`
2. Create `~/.codex/mcp.json`
3. Restart Codeium

### For Cline
1. Install: `pip install mcp-obsidian`
2. Create `~/.cline/cline_mcp_config.json`
3. Reload VS Code

---

## Testing Your Configuration

### Test 1: Verify mcp-obsidian is available
```bash
which mcp-obsidian
# or
uvx mcp-obsidian --help  # for Claude with uvx
```

### Test 2: Check environment variables
```bash
export OBSIDIAN_API_KEY="your_key_here"
export OBSIDIAN_HOST="192.168.88.30"
export OBSIDIAN_PORT="27124"
mcp-obsidian
```

### Test 3: Verify Obsidian connectivity
```bash
curl -H "Authorization: Bearer YOUR_API_KEY" \
  http://192.168.88.30:27124/vault/
```

---

## Troubleshooting

### "uvx: command not found"
Install uv: `brew install uv` or `apt install uv`

### "mcp-obsidian: command not found"
Install: `pip install mcp-obsidian`

### "Connection refused"
- Check Obsidian is running
- Verify Local REST API plugin is enabled
- Check host and port are correct

### "Unauthorized" (401)
- Verify your API key is correct
- Regenerate in plugin settings if needed

---

## References

- [mcp-obsidian Package](https://github.com/calclavia/mcp-obsidian)
- [Claude Desktop Documentation](https://claude.ai/docs)
- [GitHub Copilot CLI](https://github.com/github/gh-copilot)
- [Codeium Documentation](https://codeium.com/)
- [Cline Documentation](https://github.com/cline/cline)

