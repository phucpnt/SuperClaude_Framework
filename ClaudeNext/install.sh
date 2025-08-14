#!/bin/bash

# ClaudeNext Complete Installation Script
# Installs sub-agents, CLAUDE.md, and MCP configuration for Claude Code

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Installation paths
CLAUDE_DIR="$HOME/.claude"
AGENTS_DIR="$CLAUDE_DIR/agents"
CLAUDENEXT_SOURCE="$(dirname "$0")"

# Detect OS for MCP config location
if [[ "$OSTYPE" == "darwin"* ]]; then
    MCP_CONFIG_DIR="$HOME/Library/Application Support/Claude"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    MCP_CONFIG_DIR="$HOME/.config/Claude"
else
    echo -e "${RED}✗${NC} Unsupported OS: $OSTYPE"
    exit 1
fi
MCP_CONFIG_FILE="$MCP_CONFIG_DIR/claude_desktop_config.json"

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   ClaudeNext Complete Installation     ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Function to print status
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Check if Claude Code directory exists
if [ ! -d "$CLAUDE_DIR" ]; then
    print_info "Creating Claude Code directory at $CLAUDE_DIR"
    mkdir -p "$CLAUDE_DIR"
fi

# Create agents directory if it doesn't exist
if [ ! -d "$AGENTS_DIR" ]; then
    print_info "Creating agents directory at $AGENTS_DIR"
    mkdir -p "$AGENTS_DIR"
fi

# Create MCP config directory if it doesn't exist
if [ ! -d "$MCP_CONFIG_DIR" ]; then
    print_info "Creating MCP config directory at $MCP_CONFIG_DIR"
    mkdir -p "$MCP_CONFIG_DIR"
fi

# Installation configuration - always install everything
echo -e "${YELLOW}🚀 Starting Complete ClaudeNext Installation${NC}"
echo ""
echo "This will install:"
echo "  • CLAUDE.md with engineering principles"
echo "  • CTO Orchestrator for autonomous delegation"
echo "  • All 13 sub-agents (CTO + 12 specialists)"
echo "  • MCP server configuration"
echo ""
read -p "Continue with installation? (y/n): " confirm

if [ "$confirm" != "y" ]; then
    print_error "Installation cancelled."
    exit 0
fi

# Always install everything
INSTALL_AGENTS=true
INSTALL_CLAUDE_MD=true
INSTALL_MCP=true
SELECTED_AGENTS="all"
SELECTED_MCP="all"

echo ""
echo -e "${BLUE}Starting installation...${NC}"
echo ""

# Install CLAUDE.md
if [ "$INSTALL_CLAUDE_MD" = true ]; then
    echo -e "${BLUE}Installing CLAUDE.md...${NC}"
    
    # Backup existing CLAUDE.md if it exists
    if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
        backup_file="$CLAUDE_DIR/CLAUDE.md.backup.$(date +%Y%m%d_%H%M%S)"
        print_info "Backing up existing CLAUDE.md to $(basename $backup_file)"
        cp "$CLAUDE_DIR/CLAUDE.md" "$backup_file"
    fi
    
    # Copy new CLAUDE.md
    cp "$CLAUDENEXT_SOURCE/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
    print_status "CLAUDE.md installed with engineering principles"
fi

# Install agents
if [ "$INSTALL_AGENTS" = true ]; then
    echo ""
    echo -e "${BLUE}Installing sub-agents...${NC}"
    
    # Function to install an agent
    install_agent() {
        local agent_file="$1"
        local agent_name=$(basename "$agent_file" .md)
        
        if [ -f "$AGENTS_DIR/$agent_name.md" ]; then
            backup_file="$AGENTS_DIR/$agent_name.md.backup.$(date +%Y%m%d_%H%M%S)"
            print_info "Backing up existing $agent_name"
            cp "$AGENTS_DIR/$agent_name.md" "$backup_file"
        fi
        
        cp "$agent_file" "$AGENTS_DIR/"
        print_status "$agent_name installed"
    }
    
    # Install all agents
    agent_count=0
    for agent_file in "$CLAUDENEXT_SOURCE"/agents/*.md; do
        if [ -f "$agent_file" ]; then
            install_agent "$agent_file"
            ((agent_count++))
        fi
    done
    print_info "Total agents installed: $agent_count"
fi

# Install MCP configuration
if [ "$INSTALL_MCP" = true ]; then
    echo ""
    echo -e "${BLUE}Configuring MCP servers...${NC}"
    
    # Check for Node.js
    if ! command -v node &> /dev/null; then
        print_warning "Node.js is not installed. MCP servers require Node.js."
        echo "  Install from: https://nodejs.org/"
        echo "  MCP configuration will be created but servers won't run without Node.js"
    else
        print_status "Node.js detected: $(node --version)"
    fi
    
    # Backup existing MCP config if it exists
    if [ -f "$MCP_CONFIG_FILE" ]; then
        backup_file="$MCP_CONFIG_FILE.backup.$(date +%Y%m%d_%H%M%S)"
        print_info "Backing up existing MCP config"
        cp "$MCP_CONFIG_FILE" "$backup_file"
    fi
    
    # Function to generate server config
    generate_server_config() {
        local server=$1
        local first=$2
        
        if [ "$first" != "true" ]; then
            echo ","
        fi
        
        case $server in
            context7)
                cat <<EOF
    "context7": {
      "command": "npx",
      "args": ["-y", "@context7/mcp-server"],
      "description": "Official library documentation and API references"
    }
EOF
                ;;
            sequential)
                cat <<EOF
    "sequential": {
      "command": "npx",
      "args": ["-y", "@sequential/thinking-server"],
      "description": "Complex analysis and multi-step reasoning"
    }
EOF
                ;;
            magic)
                cat <<EOF
    "magic": {
      "command": "npx",
      "args": ["-y", "@magic/ui-server"],
      "description": "UI component generation and design systems"
    }
EOF
                ;;
            playwright)
                cat <<EOF
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp-server"],
      "description": "Browser automation and E2E testing"
    }
EOF
                ;;
        esac
    }
    
    # Generate MCP config file
    {
        echo "{"
        echo "  \"mcpServers\": {"
        
        # Add selected servers
        if [ "$SELECTED_MCP" = "all" ]; then
            generate_server_config "context7" true
            generate_server_config "sequential" false
            generate_server_config "magic" false
            generate_server_config "playwright" false
        else
            IFS=',' read -ra MCP_ARRAY <<< "$SELECTED_MCP"
            FIRST=true
            for server in "${MCP_ARRAY[@]}"; do
                server=$(echo "$server" | xargs) # Trim whitespace
                generate_server_config "$server" "$FIRST"
                FIRST=false
            done
        fi
        
        echo ""
        echo "  }"
        echo "}"
    } > "$MCP_CONFIG_FILE"
    
    print_status "MCP servers configured in $(basename $MCP_CONFIG_DIR)"
    
    # Create MCP test script
    cat > "$CLAUDE_DIR/test-mcp.sh" <<'EOF'
#!/bin/bash

echo "MCP Configuration Status:"
echo ""

# Find config file
if [[ "$OSTYPE" == "darwin"* ]]; then
    CONFIG_FILE="$HOME/Library/Application Support/Claude/claude_desktop_config.json"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    CONFIG_FILE="$HOME/.config/Claude/claude_desktop_config.json"
fi

if [ -f "$CONFIG_FILE" ]; then
    echo "✓ Config file found"
    echo ""
    echo "Configured MCP servers:"
    grep -o '"[^"]*"[[:space:]]*:[[:space:]]*{' "$CONFIG_FILE" | grep -v mcpServers | sed 's/[": {]//g' | while read server; do
        echo "  • $server"
    done
else
    echo "✗ Config file not found"
fi

echo ""
echo "Node.js: $(node --version 2>/dev/null || echo 'Not installed')"
echo "NPM: $(npm --version 2>/dev/null || echo 'Not installed')"
EOF
    chmod +x "$CLAUDE_DIR/test-mcp.sh"
fi

# Create comprehensive test script
echo ""
echo -e "${BLUE}Creating test scripts...${NC}"
cat > "$CLAUDE_DIR/test-claudenext.sh" << 'EOF'
#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     ClaudeNext Installation Test       ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Check CLAUDE.md
echo -e "${YELLOW}CLAUDE.md Status:${NC}"
if [ -f ~/.claude/CLAUDE.md ]; then
    echo -e "  ${GREEN}✓${NC} CLAUDE.md installed"
    # Check for key principles
    if grep -q "Evidence > Assumptions" ~/.claude/CLAUDE.md 2>/dev/null; then
        echo -e "  ${GREEN}✓${NC} Engineering principles integrated"
    fi
    lines=$(wc -l < ~/.claude/CLAUDE.md)
    echo -e "  ${BLUE}ℹ${NC} File contains $lines lines"
else
    echo -e "  ${RED}✗${NC} CLAUDE.md not found"
fi

echo ""
echo -e "${YELLOW}Installed Sub-Agents:${NC}"
if [ -d ~/.claude/agents ]; then
    agent_count=0
    for agent in ~/.claude/agents/*.md; do
        if [ -f "$agent" ]; then
            name=$(grep "^name:" "$agent" | cut -d' ' -f2)
            desc=$(grep "^description:" "$agent" | cut -d' ' -f2-)
            echo -e "  ${GREEN}✓${NC} $name"
            echo "    $desc"
            ((agent_count++))
        fi
    done
    if [ $agent_count -eq 0 ]; then
        echo -e "  ${RED}✗${NC} No agents found"
    else
        echo -e "  ${BLUE}ℹ${NC} Total: $agent_count agents"
    fi
else
    echo -e "  ${RED}✗${NC} Agents directory not found"
fi

echo ""
echo -e "${YELLOW}MCP Configuration:${NC}"
# Find config file
if [[ "$OSTYPE" == "darwin"* ]]; then
    CONFIG_FILE="$HOME/Library/Application Support/Claude/claude_desktop_config.json"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    CONFIG_FILE="$HOME/.config/Claude/claude_desktop_config.json"
fi

if [ -f "$CONFIG_FILE" ]; then
    echo -e "  ${GREEN}✓${NC} MCP config found"
    mcp_count=$(grep -o '"[^"]*"[[:space:]]*:[[:space:]]*{' "$CONFIG_FILE" 2>/dev/null | grep -v mcpServers | wc -l)
    echo -e "  ${BLUE}ℹ${NC} $mcp_count MCP servers configured"
else
    echo -e "  ${YELLOW}⚠${NC} MCP config not found"
fi

echo ""
echo -e "${YELLOW}System Requirements:${NC}"
if command -v node &> /dev/null; then
    echo -e "  ${GREEN}✓${NC} Node.js: $(node --version)"
else
    echo -e "  ${RED}✗${NC} Node.js not installed (required for MCP)"
fi

echo ""
echo -e "${GREEN}Test Complete!${NC}"
echo ""
echo "Quick test commands:"
echo "  • Test agents: Task(subagent_type=\"architect\", prompt=\"Design a chat system\")"
echo "  • Test routing: /sc implement secure authentication"
echo "  • Test MCP: Type 'import React' to trigger context7"
EOF

chmod +x "$CLAUDE_DIR/test-claudenext.sh"
print_status "Test script created"

# Display summary
echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     Installation Complete! 🎉          ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""

# Summary of what was installed
echo -e "${BLUE}Installed Components:${NC}"

if [ "$INSTALL_CLAUDE_MD" = true ]; then
    echo -e "  ${GREEN}✓${NC} CLAUDE.md with engineering principles"
fi

if [ "$INSTALL_AGENTS" = true ]; then
    echo -e "  ${GREEN}✓${NC} Sub-agents in $AGENTS_DIR"
    echo "      → All 13 agents installed:"
    echo "        • Executive: cto-orchestrator (autonomous delegation)"
    echo "        • Security & Architecture: security-auditor, architect, architect-reviewer"
    echo "        • Development: frontend-specialist, golang-pro, code-reviewer"
    echo "        • Performance & Testing: performance-optimizer, test-writer-fixer"
    echo "        • AI & Documentation: ai-engineer, docs-architect"
    echo "        • Workflow: workflow-orchestrator, experiment-tracker"
fi

if [ "$INSTALL_MCP" = true ]; then
    echo -e "  ${GREEN}✓${NC} MCP servers configured"
    if [ "$SELECTED_MCP" = "all" ]; then
        echo "      → All 4 servers: context7, sequential, magic, playwright"
    else
        echo "      → Selected servers: $SELECTED_MCP"
    fi
fi

echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo ""
echo "1. ${BLUE}Restart Claude Code${NC} for changes to take effect"
echo ""
echo "2. ${BLUE}Verify installation:${NC}"
echo "   $CLAUDE_DIR/test-claudenext.sh"
echo ""
echo "3. ${BLUE}Start using ClaudeNext:${NC}"
echo "   • Auto-routing: ${GREEN}/sc implement user authentication${NC}"
echo "   • Specific agent: ${GREEN}/sc:security audit my code${NC}"
echo "   • Direct invocation: ${GREEN}Task(subagent_type=\"architect\", prompt=\"...\")${NC}"
echo ""

if [ "$INSTALL_MCP" = true ]; then
    echo "4. ${BLUE}MCP servers will activate automatically:${NC}"
    echo "   • Type 'import React' → context7 activates"
    echo "   • Type 'debug complex' → sequential activates"
    echo "   • Type 'create component' → magic activates"
    echo "   • Type 'run e2e test' → playwright activates"
    echo ""
fi

echo -e "${GREEN}ClaudeNext is ready to enhance your development!${NC}"
echo ""
echo "Documentation: $CLAUDENEXT_SOURCE/README.md"
echo "MCP Guide: $CLAUDENEXT_SOURCE/docs/MCP_SETUP.md"