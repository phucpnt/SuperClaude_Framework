#!/bin/bash

# ClaudeNext Complete Installation Script v2.0
# Installs CTO orchestrator, specialists, CLAUDE.md, and MCP configuration

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Version and paths
VERSION="2.0.0"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
CLAUDE_DIR="$HOME/.claude"
AGENTS_DIR="$CLAUDE_DIR/agents"
BACKUP_DIR="$HOME/.claude-backup-$VERSION-$TIMESTAMP"
CLAUDENEXT_SOURCE="$(cd "$(dirname "$0")" && pwd)"

# ClaudeNext installation paths

echo -e "${PURPLE}╔═══════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║   ClaudeNext v$VERSION - AI Engineering Team      ║${NC}"
echo -e "${PURPLE}║   CTO Orchestrator + 15 Specialist Agents        ║${NC}"
echo -e "${PURPLE}╚═══════════════════════════════════════════════════╝${NC}"
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

# Create backup directory for existing files
create_backup() {
    if [ -d "$CLAUDE_DIR" ] && [ "$(ls -A $CLAUDE_DIR 2>/dev/null)" ]; then
        print_info "Creating backup at $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR"
        
        # Backup existing files
        if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
            cp "$CLAUDE_DIR/CLAUDE.md" "$BACKUP_DIR/"
            print_status "Backed up CLAUDE.md"
        fi
        
        if [ -d "$AGENTS_DIR" ]; then
            cp -r "$AGENTS_DIR" "$BACKUP_DIR/agents"
            print_status "Backed up existing agents"
        fi
    fi
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

# MCP config directory is same as CLAUDE_DIR, already created above

# Installation configuration - always install everything
echo -e "${YELLOW}🚀 ClaudeNext Installation Overview${NC}"
echo ""
echo -e "${BLUE}What will be installed:${NC}"
echo -e "  ${PURPLE}►${NC} CTO Orchestrator (Primary request handler)"
echo -e "  ${PURPLE}►${NC} 15 Specialist Agents:"
echo "     • Security: security-auditor, architect-reviewer, code-reviewer"
echo "     • Development: golang-pro, frontend-specialist"
echo "     • Performance: performance-optimizer"
echo "     • Quality: test-automation-engineer, service-qa-engineer, ux-qa-engineer"
echo "     • Innovation: ai-engineer, docs-architect, experiment-tracker"
echo "     • Data: data-engineer"
echo "     • Planning: workflow-orchestrator (TPM), architect"
echo -e "  ${PURPLE}►${NC} CLAUDE.md with engineering principles"
echo -e "  ${PURPLE}►${NC} MCP servers via Claude CLI (up to 4 servers)"
echo -e "  ${PURPLE}►${NC} Documentation and guides"
echo ""

if [ -d "$CLAUDE_DIR" ] && [ "$(ls -A $CLAUDE_DIR 2>/dev/null)" ]; then
    echo -e "${YELLOW}⚠️  Existing installation detected${NC}"
    echo "  Backup will be created at: $BACKUP_DIR"
    echo ""
fi

read -p "Continue with installation? (y/n): " confirm

if [ "$confirm" != "y" ]; then
    print_error "Installation cancelled."
    exit 0
fi

# Create backup if needed
create_backup

echo ""
echo -e "${BLUE}Starting installation...${NC}"
echo ""

# Install CLAUDE.md
echo -e "${BLUE}Installing CLAUDE.md...${NC}"
if [ -f "$CLAUDENEXT_SOURCE/CLAUDE.md" ]; then
    cp "$CLAUDENEXT_SOURCE/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
    print_status "CLAUDE.md installed with engineering principles"
else
    print_error "CLAUDE.md not found in source directory"
    exit 1
fi

# Install agents
echo ""
echo -e "${BLUE}Installing AI Engineering Team...${NC}"

# Function to install an agent
install_agent() {
    local agent_file="$1"
    local agent_name=$(basename "$agent_file" .md)
    local agent_desc="$2"
    
    cp "$agent_file" "$AGENTS_DIR/"
    
    # Special highlighting for CTO
    if [ "$agent_name" = "cto" ] || [ "$agent_name" = "cto-orchestrator" ]; then
        print_status "${PURPLE}[PRIMARY]${NC} $agent_name - $agent_desc"
    else
        print_status "$agent_name - $agent_desc"
    fi
}

# Install all agents with descriptions
agent_count=0
echo -e "${YELLOW}Installing CTO Orchestrator:${NC}"
if [ -f "$CLAUDENEXT_SOURCE/agents/cto-orchestrator.md" ]; then
    install_agent "$CLAUDENEXT_SOURCE/agents/cto-orchestrator.md" "Primary orchestrator"
    agent_count=$((agent_count + 1))
fi

echo ""
echo -e "${YELLOW}Installing Specialist Agents:${NC}"

# Define agent descriptions
declare -A agent_descriptions=(
    ["workflow-orchestrator"]="TPM for project planning"
    ["security-auditor"]="OWASP compliance & vulnerabilities"
    ["architect"]="System design & scalability"
    ["architect-reviewer"]="SOLID principles & patterns"
    ["frontend-specialist"]="React/Vue/Angular expert"
    ["golang-pro"]="Go concurrency & idioms"
    ["code-reviewer"]="Configuration safety & reliability"
    ["performance-optimizer"]="Sub-100ms optimization"
    ["test-automation-engineer"]="Test design patterns & reliability"
    ["service-qa-engineer"]="Backend/distributed testing"
    ["ux-qa-engineer"]="Frontend/UX testing & accessibility"
    ["ai-engineer"]="AI/ML implementation"
    ["docs-architect"]="Technical documentation"
    ["experiment-tracker"]="A/B testing & metrics"
)

# Install remaining agents
for agent_file in "$CLAUDENEXT_SOURCE"/agents/*.md; do
    if [ -f "$agent_file" ]; then
        agent_name=$(basename "$agent_file" .md)
        if [ "$agent_name" != "cto-orchestrator" ] && [ "$agent_name" != "cto" ]; then
            desc="${agent_descriptions[$agent_name]:-Specialist agent}"
            install_agent "$agent_file" "$desc"
            agent_count=$((agent_count + 1))
        fi
    fi
done

echo ""
print_info "Total agents installed: $agent_count (1 CTO + $(($agent_count-1)) specialists)"

# Install MCP servers using Claude CLI
echo ""
echo -e "${BLUE}Configuring MCP servers...${NC}"

# Initialize MCP counters
mcp_installed=0
mcp_failed=0

# Check prerequisites
MCP_SKIP=false

# Check for Node.js
if ! command -v node &> /dev/null; then
    print_warning "Node.js is not installed. MCP servers require Node.js."
    echo "  Install from: https://nodejs.org/"
    echo "  Skipping MCP server installation"
    MCP_SKIP=true
else
    print_status "Node.js detected: $(node --version)"
fi

# Check for Claude CLI
if ! command -v claude &> /dev/null; then
    print_warning "Claude CLI is not installed. MCP servers require Claude CLI."
    echo "  Visit: https://docs.anthropic.com/en/docs/claude-code"
    echo "  Skipping MCP server installation"
    MCP_SKIP=true
else
    print_status "Claude CLI detected"
fi

# Function to check if MCP server is installed
check_mcp_server() {
    local server_name=$1
    claude mcp list 2>/dev/null | grep -q "$server_name"
}

# Function to install MCP server
install_mcp_server() {
    local server_name=$1
    local npm_package=$2
    local description=$3
    
    if check_mcp_server "$server_name"; then
        print_info "$server_name already installed"
        return 0
    fi
    
    echo "  Installing $server_name: $description"
    if claude mcp add -s user -- "$server_name" npx -y "$npm_package" 2>/dev/null; then
        print_status "$server_name installed successfully"
        return 0
    else
        print_warning "Failed to install $server_name"
        return 1
    fi
}

# Install MCP servers if prerequisites are met
if [ "$MCP_SKIP" = false ]; then
    echo ""
    echo -e "${YELLOW}Installing MCP servers:${NC}"
    
    # Define servers with correct npm packages
    install_mcp_server "sequential-thinking" "@modelcontextprotocol/server-sequential-thinking" "Multi-step problem solving" && mcp_installed=$((mcp_installed+1)) || mcp_failed=$((mcp_failed+1))
        install_mcp_server "context7" "@upstash/context7-mcp" "Official library documentation" && mcp_installed=$((mcp_installed+1)) || mcp_failed=$((mcp_failed+1))
    
        # Magic server requires API key
        if [ -n "$TWENTYFIRST_API_KEY" ]; then
            install_mcp_server "magic" "@21st-dev/magic" "UI component generation" && mcp_installed=$((mcp_installed+1)) || mcp_failed=$((mcp_failed+1))
        else
            print_info "Skipping magic server (requires TWENTYFIRST_API_KEY environment variable)"
        fi
    
        install_mcp_server "playwright" "@playwright/mcp@latest" "Browser automation & E2E testing" && mcp_installed=$((mcp_installed+1)) || mcp_failed=$((mcp_failed+1))
    
    echo ""
    if [ $mcp_installed -gt 0 ]; then
        print_status "MCP servers configured: $mcp_installed installed successfully"
    fi
    
    if [ $mcp_failed -gt 0 ]; then
        print_warning "Some MCP servers failed to install: $mcp_failed failed"
    fi
    
    # Verify installation
    echo ""
    echo -e "${BLUE}Verifying MCP installation:${NC}"
    if claude mcp list &>/dev/null; then
        echo "Installed MCP servers:"
        claude mcp list 2>/dev/null | grep -E "^\s+[a-z]" | while read -r line; do
            echo "  • $line"
        done
    else
        print_warning "Could not verify MCP installation"
    fi
else
    print_warning "MCP server installation skipped due to missing prerequisites"
fi

# Create MCP test script
cat > "$CLAUDE_DIR/test-mcp.sh" <<'EOF'
#!/bin/bash

echo "MCP Configuration Status:"
echo ""

# Check if Claude CLI is available
if ! command -v claude &> /dev/null; then
    echo "✗ Claude CLI not installed"
    echo "  Visit: https://docs.anthropic.com/en/docs/claude-code"
else
    echo "✓ Claude CLI detected"
    
    # List installed MCP servers
    echo ""
    echo "Installed MCP servers:"
    if claude mcp list 2>/dev/null | grep -q "No MCP servers"; then
        echo "  ✗ No MCP servers installed"
    else
        claude mcp list 2>/dev/null | grep -E "^\s+[a-z]" | while read -r line; do
            echo "  • $line"
        done
    fi
fi

echo ""
echo "System Requirements:"
echo "Node.js: $(node --version 2>/dev/null || echo 'Not installed')"
echo "NPM: $(npm --version 2>/dev/null || echo 'Not installed')"
echo "Claude CLI: $(claude --version 2>/dev/null || echo 'Not installed')"
EOF
    chmod +x "$CLAUDE_DIR/test-mcp.sh"

# Create test script
echo ""
echo -e "${BLUE}Creating test script...${NC}"

# Create comprehensive test script
cat > "$CLAUDE_DIR/test-claudenext.sh" << 'EOF'
#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
NC='\033[0m'

echo -e "${PURPLE}╔════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║     ClaudeNext Installation Test       ║${NC}"
echo -e "${PURPLE}╚════════════════════════════════════════╝${NC}"
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
# Check MCP servers via Claude CLI
if command -v claude &> /dev/null; then
    mcp_count=$(claude mcp list 2>/dev/null | grep -cE "^\s+[a-z]" || echo "0")
    if [ "$mcp_count" -gt 0 ]; then
        echo -e "  ${GREEN}✓${NC} $mcp_count MCP servers installed"
        claude mcp list 2>/dev/null | grep -E "^\s+[a-z]" | head -4 | while read -r line; do
            echo -e "    • $line"
        done
    else
        echo -e "  ${YELLOW}⚠${NC} No MCP servers installed"
    fi
else
    echo -e "  ${RED}✗${NC} Claude CLI not found - cannot check MCP servers"
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
echo "  ${PURPLE}• PRIMARY: Task(subagent_type=\"cto\", prompt=\"Build secure API\")${NC}"
echo "  • Direct: Task(subagent_type=\"golang-pro\", prompt=\"Write concurrent code\")"
echo "  • Data: Task(subagent_type=\"data-engineer\", prompt=\"Design real-time pipeline\")"
echo "  • Planning: Task(subagent_type=\"workflow-orchestrator\", prompt=\"Plan e-commerce platform\")"
echo ""
echo -e "${YELLOW}CTO Orchestrator Status:${NC}"
if [ -f ~/.claude/agents/cto-orchestrator.md ] || [ -f ~/.claude/agents/cto.md ]; then
    echo -e "  ${GREEN}✓${NC} CTO installed - Ready to handle ALL requests"
    echo "  ${BLUE}ℹ${NC} The CTO will automatically:"
    echo "     • Analyze complexity and delegate to TPM if needed"
    echo "     • Route to specialists based on confidence"
    echo "     • Enforce quality gates before delivery"
else
    echo -e "  ${RED}✗${NC} CTO not found - Primary orchestrator missing!"
fi
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

echo -e "  ${GREEN}✓${NC} AI Engineering Team in $AGENTS_DIR"
echo "      ${PURPLE}→ CTO Orchestrator${NC} (Primary handler for ALL requests)"
echo "      → 14 Specialist Agents:"
echo "        • Planning: workflow-orchestrator (TPM), architect"
echo "        • Security: security-auditor, architect-reviewer, code-reviewer"
echo "        • Development: frontend-specialist, golang-pro"
echo "        • Performance: performance-optimizer"
echo "        • Quality: test-automation-engineer, service-qa-engineer, ux-qa-engineer"
echo "        • Innovation: ai-engineer, docs-architect, experiment-tracker"
echo "        • Data: data-engineer"

if [ "$MCP_SKIP" = false ] && [ $mcp_installed -gt 0 ]; then
    echo -e "  ${GREEN}✓${NC} MCP servers installed: $mcp_installed servers"
    echo "      → sequential-thinking, context7, playwright"
    if [ -n "$TWENTYFIRST_API_KEY" ]; then
        echo "      → magic (with API key)"
    fi
fi

echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo ""
echo "1. ${BLUE}Restart Claude Code${NC} for changes to take effect"
echo ""
echo "2. ${BLUE}Test installation:${NC}"
echo "   $CLAUDE_DIR/test-claudenext.sh"
echo ""
echo "3. ${PURPLE}PRIMARY USAGE - Let CTO handle everything:${NC}"
echo "   ${GREEN}Task(subagent_type=\"cto\", prompt=\"your request\")${NC}"
echo ""
echo "   The CTO will:"
echo "   • Analyze complexity and risk"
echo "   • Delegate to workflow-orchestrator for complex projects"
echo "   • Route to specialists based on confidence"
echo "   • Enforce quality gates before delivery"
echo ""
echo "4. ${BLUE}Alternative usage patterns:${NC}"
echo "   • Direct specialist: ${GREEN}Task(subagent_type=\"golang-pro\", ...)${NC}"
echo "   • Force planning: ${GREEN}Task(subagent_type=\"workflow-orchestrator\", ...)${NC}"
echo ""

echo "5. ${BLUE}MCP servers activate automatically:${NC}"
echo "   • 'import React' → context7"
echo "   • Complex analysis → sequential-thinking"
echo "   • UI generation → magic (requires API key)"
echo "   • E2E testing → playwright"
echo ""

echo -e "${PURPLE}═══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}ClaudeNext v$VERSION installed successfully!${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════════════${NC}"
echo ""
if [ -d "$BACKUP_DIR" ]; then
    echo "Previous installation backed up to: $BACKUP_DIR"
    echo ""
fi
echo "Installed components:"
echo "  • CLAUDE.md: Enhanced instructions"
echo "  • CTO Agent: Primary orchestrator"
echo "  • 14 Specialists: Development team"
if [ $mcp_installed -gt 0 ]; then
    echo "  • MCP Servers: $mcp_installed installed"
fi