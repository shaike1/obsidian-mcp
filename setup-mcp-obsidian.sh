#!/bin/bash

###############################################################################
# MCP Obsidian Setup Script
# Installs and configures Obsidian MCP on a new machine
# Usage: ./setup-mcp-obsidian.sh [--api-key KEY] [--host HOST] [--port PORT]
###############################################################################

set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
OBSIDIAN_API_KEY="${OBSIDIAN_API_KEY:-}"
OBSIDIAN_HOST="${OBSIDIAN_HOST:-192.168.88.30}"
OBSIDIAN_PORT="${OBSIDIAN_PORT:-27124}"
CONFIG_DIR=""

###############################################################################
# Helper Functions
###############################################################################

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo ""
    echo "=============================================="
    echo "$1"
    echo "=============================================="
}

###############################################################################
# Parse Arguments
###############################################################################

while [[ $# -gt 0 ]]; do
    case $1 in
        --api-key)
            OBSIDIAN_API_KEY="$2"
            shift 2
            ;;
        --host)
            OBSIDIAN_HOST="$2"
            shift 2
            ;;
        --port)
            OBSIDIAN_PORT="$2"
            shift 2
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --api-key KEY     Obsidian API Key (required)"
            echo "  --host HOST       Obsidian host (default: 192.168.88.30)"
            echo "  --port PORT       Obsidian port (default: 27124)"
            echo "  --help            Show this help message"
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            exit 1
            ;;
    esac
done

###############################################################################
# Validation
###############################################################################

print_header "MCP Obsidian Setup"

if [ -z "$OBSIDIAN_API_KEY" ]; then
    log_error "OBSIDIAN_API_KEY is required"
    echo "Usage: $0 --api-key YOUR_API_KEY [--host HOST] [--port PORT]"
    exit 1
fi

log_info "Configuration:"
log_info "  API Key: ${OBSIDIAN_API_KEY:0:8}...${OBSIDIAN_API_KEY: -8}"
log_info "  Host: $OBSIDIAN_HOST"
log_info "  Port: $OBSIDIAN_PORT"

###############################################################################
# Detect Config Directory
###############################################################################

print_header "Detecting Configuration Directory"

# Check for common AI tool config locations
if [ -d "$HOME/.copilot" ]; then
    CONFIG_DIR="$HOME/.copilot"
    log_info "Found GitHub Copilot config: $CONFIG_DIR"
elif [ -d "$HOME/.codex" ]; then
    CONFIG_DIR="$HOME/.codex"
    log_info "Found Claude Codex config: $CONFIG_DIR"
elif [ -d "$HOME/.cline" ]; then
    CONFIG_DIR="$HOME/.cline"
    log_info "Found Cline config: $CONFIG_DIR"
else
    CONFIG_DIR="$HOME/.copilot"
    log_warn "No existing AI tool config found, creating: $CONFIG_DIR"
    mkdir -p "$CONFIG_DIR"
fi

###############################################################################
# Install MCP Obsidian Package
###############################################################################

print_header "Installing MCP Obsidian Package"

if command -v npm &> /dev/null; then
    log_info "Installing @mcp-server-obsidian globally..."
    npm install -g @mcp-server-obsidian 2>&1 | grep -E "added|up to date" || true
    log_info "MCP Obsidian package installed"
else
    log_error "npm is not installed. Please install Node.js and npm first."
    exit 1
fi

###############################################################################
# Create/Update MCP Configuration
###############################################################################

print_header "Creating MCP Configuration"

CONFIG_FILE="$CONFIG_DIR/mcp-config.json"

# Create backup if config exists
if [ -f "$CONFIG_FILE" ]; then
    BACKUP_FILE="$CONFIG_FILE.backup.$(date +%s)"
    cp "$CONFIG_FILE" "$BACKUP_FILE"
    log_info "Backed up existing config to: $BACKUP_FILE"
fi

# Create new config
cat > "$CONFIG_FILE" << EOF
{
  "mcpServers": {
    "obsidian": {
      "type": "local",
      "command": "mcp-obsidian",
      "args": [],
      "tools": ["*"],
      "env": {
        "OBSIDIAN_API_KEY": "$OBSIDIAN_API_KEY",
        "OBSIDIAN_HOST": "$OBSIDIAN_HOST",
        "OBSIDIAN_PORT": "$OBSIDIAN_PORT"
      }
    }
  }
}
EOF

log_info "MCP configuration created: $CONFIG_FILE"

###############################################################################
# Test Connection
###############################################################################

print_header "Testing MCP Connection"

if command -v mcp-obsidian &> /dev/null; then
    log_info "mcp-obsidian command is available"
    log_info "Attempting to connect to Obsidian..."
    
    # Try to list files as a test
    export OBSIDIAN_API_KEY
    export OBSIDIAN_HOST
    export OBSIDIAN_PORT
    
    if timeout 5 mcp-obsidian list-files 2>/dev/null; then
        log_info "Connection test successful!"
    else
        log_warn "Could not verify connection. Please check your API key and host settings."
    fi
else
    log_warn "mcp-obsidian command not found in PATH"
fi

###############################################################################
# Summary
###############################################################################

print_header "Setup Complete!"

echo ""
echo "Configuration Summary:"
echo "  Config File: $CONFIG_FILE"
echo "  Obsidian Host: $OBSIDIAN_HOST"
echo "  Obsidian Port: $OBSIDIAN_PORT"
echo ""
echo "Next Steps:"
echo "  1. Restart your AI assistant/editor"
echo "  2. The MCP Obsidian server should be available as a tool"
echo "  3. You can now access Obsidian notes through MCP"
echo ""
echo "Environment Variables:"
echo "  export OBSIDIAN_API_KEY=$OBSIDIAN_API_KEY"
echo "  export OBSIDIAN_HOST=$OBSIDIAN_HOST"
echo "  export OBSIDIAN_PORT=$OBSIDIAN_PORT"
echo ""

log_info "Setup completed successfully!"
