# Obsidian MCP Setup

Automated setup scripts and documentation for adding Obsidian MCP to new machines.

## What is Obsidian MCP?

**Obsidian MCP** is a Model Context Protocol server that lets AI assistants (Claude, GitHub Copilot, etc.) interact with your Obsidian vault through the Local REST API plugin.

## Quick Start

### Prerequisites
- **Python 3.7+** (or uv)
- **Obsidian** with **Local REST API Community Plugin** installed
- **API Key** from the plugin

### Installation

#### 1. Install Obsidian Local REST API Plugin

In Obsidian:
1. Settings → Community plugins → Browse
2. Search for **"Local REST API"** by `coddingtonbear`
3. Install and enable
4. Copy your **API Key** from plugin settings
5. Note your **Host** and **Port** (default: 127.0.0.1:27124)

#### 2. Install MCP Obsidian Server

```bash
pip install mcp-obsidian
```

Or with uvx:
```bash
# uvx will handle installation automatically
uvx mcp-obsidian
```

#### 3. Run Setup Script

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/shaike1/obsidian-mcp/main/setup-mcp-obsidian.sh) \
  --api-key YOUR_API_KEY \
  --host 192.168.88.30 \
  --port 27124
```

Or locally:
```bash
git clone https://github.com/shaike1/obsidian-mcp.git
cd obsidian-mcp
chmod +x setup-mcp-obsidian.sh
./setup-mcp-obsidian.sh --api-key YOUR_API_KEY --host 192.168.88.30 --port 27124
```

## Configuration

### Manual Configuration for GitHub Copilot

```bash
mkdir -p ~/.copilot
cat > ~/.copilot/mcp-config.json << 'EOFCONFIG'
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
EOFCONFIG
```

### Manual Configuration for Claude (with uvx)

```bash
mkdir -p ~/.claude
cat > ~/.claude/claude_desktop_config.json << 'EOFCONFIG'
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
EOFCONFIG
```

## Available Tools

- `list_files_in_vault` - List all vault files
- `list_files_in_dir` - List files in directory
- `get_file_contents` - Read file content
- `batch_get_file_contents` - Read multiple files
- `simple_search` - Text search
- `complex_search` - Advanced search
- `put_content` - Create/update files
- `append_content` - Append to files
- `patch_content` - Patch sections
- `delete_file` - Delete files
- `get_periodic_note` - Get current periodic note
- `get_recent_periodic_notes` - Get recent notes
- `get_recent_changes` - Get recently modified files

## Troubleshooting

### "mcp-obsidian: command not found"
```bash
pip install --upgrade mcp-obsidian
```

### "Connection refused"
- Ensure Obsidian is running
- Check Local REST API plugin is enabled
- Verify host and port are correct

### "Unauthorized" (401)
- Verify your API key is correct
- Regenerate key in plugin settings if needed

### Network Issues
```bash
# Test connectivity
ping 192.168.88.30
nc -zv 192.168.88.30 27124
```

## Files in This Repo

- `setup-mcp-obsidian.sh` - Automated setup script
- `MCP-Obsidian-Setup-Guide.md` - Complete documentation
- `README.md` - This file

## Documentation

For complete documentation, see [MCP-Obsidian-Setup-Guide.md](MCP-Obsidian-Setup-Guide.md)

## References

- [Obsidian Local REST API Plugin](https://github.com/coddingtonbear/obsidian-local-rest-api)
- [MCP Obsidian Server](https://github.com/calclavia/mcp-obsidian)
- [Model Context Protocol](https://spec.modelcontextprotocol.io/)

## Security

⚠️ Never commit API keys to public repositories. Store them securely using environment variables or password managers.

---

Made with ❤️
