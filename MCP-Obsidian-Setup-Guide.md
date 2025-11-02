# MCP Obsidian Setup Guide

> Setup script and documentation for adding Obsidian MCP to new machines

**Last Updated:** 2025-11-02

---

## Quick Setup

### One-Liner (with API key)
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/shaike1/obsidian-mcp/main/setup-mcp-obsidian.sh) \
  --api-key YOUR_API_KEY \
  --host 192.168.88.30 \
  --port 27124
```

### Or Using Local Script
```bash
git clone https://github.com/shaike1/obsidian-mcp.git
cd obsidian-mcp
chmod +x setup-mcp-obsidian.sh
./setup-mcp-obsidian.sh --api-key YOUR_API_KEY
```

---

## Prerequisites

- **Node.js & npm** (v14+)
- **Obsidian** with Remote API enabled
- **API Key** from Obsidian
- **Host & Port** where Obsidian is running

---

## Getting Your Obsidian Credentials

### 1. Enable Remote API
In Obsidian:
- Settings → Developer
- Enable **"Custom protocol"** or **"Remote API"**
- Note the connection details shown

### 2. Get API Key
```bash
# On your Obsidian machine:
# Settings → Developer → Remote API → Copy API Key
# API Key looks like: ca86c3af30488bb26a63a7448235c78ed10ab7465cb3e51a83ff016cfb98c375
```

### 3. Find Host and Port
- **Host**: IP address of machine running Obsidian (e.g., 192.168.88.30)
- **Port**: Remote API port (default: 27124)

---

## Installation Steps

### Step 1: Prerequisites Check
```bash
# Verify Node.js is installed
node --version  # Should be v14+
npm --version
```

### Step 2: Run Setup Script
```bash
./setup-mcp-obsidian.sh \
  --api-key "ca86c3af30488bb26a63a7448235c78ed10ab7465cb3e51a83ff016cfb98c375" \
  --host "192.168.88.30" \
  --port "27124"
```

### Step 3: Verify Installation
```bash
# Check if mcp-obsidian is installed
which mcp-obsidian

# View the config
cat ~/.copilot/mcp-config.json
```

### Step 4: Restart Your AI Assistant
- GitHub Copilot CLI
- Claude (Codex)
- Cline
- Your editor/IDE

---

## Configuration Locations

The setup script checks for config directories in this order:

| Tool | Config Directory |
|------|------------------|
| GitHub Copilot | `~/.copilot/mcp-config.json` |
| Claude Codex | `~/.codex/mcp-config.json` |
| Cline | `~/.cline/mcp-config.json` |

---

## Manual Configuration

If automatic setup doesn't work, manually create the config:

### For GitHub Copilot
```bash
mkdir -p ~/.copilot
cat > ~/.copilot/mcp-config.json << 'EOF'
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
EOF
```

### For Claude Codex
```bash
mkdir -p ~/.codex
# Copy the same JSON structure as above to ~/.codex/mcp-config.json
```

---

## Environment Variables

You can also set these as environment variables:

```bash
export OBSIDIAN_API_KEY="ca86c3af30488bb26a63a7448235c78ed10ab7465cb3e51a83ff016cfb98c375"
export OBSIDIAN_HOST="192.168.88.30"
export OBSIDIAN_PORT="27124"
```

Then verify:
```bash
echo $OBSIDIAN_API_KEY
```

---

## Available MCP Tools

Once configured, you'll have access to these Obsidian tools:

### File Operations
- `obsidian-list_files_in_dir` - List files in directory
- `obsidian-list_files_in_vault` - List all vault files
- `obsidian-get_file_contents` - Read file content
- `obsidian-batch_get_file_contents` - Read multiple files

### Search
- `obsidian-simple_search` - Simple text search
- `obsidian-complex_search` - Advanced search with filters

### Editing
- `obsidian-put_content` - Create/update files
- `obsidian-append_content` - Append to files
- `obsidian-patch_content` - Patch specific sections
- `obsidian-delete_file` - Delete files

### Periodic Notes
- `obsidian-get_periodic_note` - Get current periodic note
- `obsidian-get_recent_periodic_notes` - Get recent notes

### Daily Operations
- `obsidian-get_recent_changes` - Get recently modified files

---

## Troubleshooting

### Issue: "npm: command not found"
**Solution:** Install Node.js
```bash
# On macOS
brew install node

# On Ubuntu/Debian
sudo apt install nodejs npm

# On Windows
# Download from https://nodejs.org/
```

### Issue: "mcp-obsidian: command not found"
**Solution:** Reinstall the package
```bash
npm install -g @mcp-server-obsidian --force
```

### Issue: Connection Failed
**Check:**
1. API Key is correct
2. Obsidian is running and Remote API is enabled
3. Host/Port are correct
4. Network connectivity between machines

```bash
# Test connection
ping 192.168.88.30
telnet 192.168.88.30 27124
```

### Issue: Config File Not Found
**Solution:** Manually create it
```bash
mkdir -p ~/.copilot
# Then add the config from "Manual Configuration" section above
```

### Issue: Wrong Config Directory
**Solution:** Check all possible locations
```bash
ls -la ~/.copilot/mcp-config.json
ls -la ~/.codex/mcp-config.json
ls -la ~/.cline/mcp-config.json
```

---

## Backing Up Configuration

The script automatically backs up existing configs:
```bash
~/.copilot/mcp-config.json.backup.1728120000
```

To restore:
```bash
cp ~/.copilot/mcp-config.json.backup.1728120000 ~/.copilot/mcp-config.json
```

---

## Uninstalling

To remove MCP Obsidian:

```bash
# Uninstall package
npm uninstall -g @mcp-server-obsidian

# Remove configuration
rm ~/.copilot/mcp-config.json

# Optionally remove backups
rm ~/.copilot/mcp-config.json.backup.*
```

---

## Example Usage in Prompts

Once installed, you can use it in your AI assistant:

```
"Search my Obsidian vault for notes about TypeScript and show me the recent ones"

"List all files in the MISC folder of my vault"

"Create a new note in my vault about MCP setup"

"Get my daily note from today"
```

---

## Multi-Machine Setup

For multiple machines:

1. **Machine 1 (Obsidian Host):**
   - Enable Remote API in Obsidian
   - Note: API Key, Host IP, Port

2. **Machine 2 (Obsidian Client):**
   ```bash
   ./setup-mcp-obsidian.sh \
     --api-key "from-machine-1" \
     --host "192.168.88.30" \
     --port "27124"
   ```

3. **Machine 3 (Another Client):**
   ```bash
   ./setup-mcp-obsidian.sh \
     --api-key "from-machine-1" \
     --host "192.168.88.30" \
     --port "27124"
   ```

---

## Security Notes

⚠️ **Important:**
- Never commit `mcp-config.json` with your API key to public repositories
- Store API keys securely (use password managers)
- Only share API keys with trusted machines
- Restrict network access to Obsidian Remote API port if possible

---

## References

- [Obsidian Remote API Docs](https://docs.obsidian.md/Obsidian+Web/Web+Clipper)
- [MCP Protocol](https://spec.modelcontextprotocol.io/)
- [@mcp-server-obsidian NPM Package](https://www.npmjs.com/package/@mcp-server-obsidian)

---

Made with ❤️ by shaike1
