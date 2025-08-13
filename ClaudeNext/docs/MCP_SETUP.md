# MCP (Model Context Protocol) Setup for ClaudeNext

MCP servers extend Claude Code with specialized capabilities for documentation, analysis, UI generation, and testing.

## 🚀 Quick Setup

```bash
# Run the automated setup script
./setup-mcp.sh

# Choose installation option:
# 1) All servers (Recommended)
# 2-5) Individual servers
# 6) Custom selection
```

## 📦 Available MCP Servers

### 1. **context7** - Documentation & API References
- **Purpose**: Access official library documentation, API references, and framework guides
- **Auto-activates**: When importing libraries, requiring packages, or asking about documentation
- **Example triggers**: `import React`, `require('express')`, "how to use useState"

### 2. **sequential** - Complex Analysis & Reasoning
- **Purpose**: Multi-step problem solving, system design, debugging complex issues
- **Auto-activates**: For complex analysis, architecture design, or deep debugging
- **Example triggers**: "debug this complex issue", "design system architecture"

### 3. **magic** - UI Component Generation
- **Purpose**: Generate UI components, design systems, and frontend patterns
- **Auto-activates**: When creating UI components or working with frontend frameworks
- **Example triggers**: "create React component", "build responsive layout"

### 4. **playwright** - Browser Automation & Testing
- **Purpose**: E2E testing, browser automation, screenshot capture, performance testing
- **Auto-activates**: When writing tests or automating browser tasks
- **Example triggers**: "write E2E test", "automate browser task"

## 🔧 Manual Configuration

If you prefer manual setup, create or edit the Claude config file:

### macOS
```bash
~/Library/Application Support/Claude/claude_desktop_config.json
```

### Linux
```bash
~/.config/Claude/claude_desktop_config.json
```

### Configuration Format
```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@context7/mcp-server"],
      "description": "Documentation and API references"
    },
    "sequential": {
      "command": "npx",
      "args": ["-y", "@sequential/thinking-server"],
      "description": "Complex analysis and reasoning"
    },
    "magic": {
      "command": "npx",
      "args": ["-y", "@magic/ui-server"],
      "description": "UI component generation"
    },
    "playwright": {
      "command": "npx",
      "args": ["-y", "@playwright/mcp-server"],
      "description": "Browser automation and testing"
    }
  }
}
```

## 🎯 How MCP Servers Work with ClaudeNext

### Automatic Activation
ClaudeNext's CLAUDE.md includes patterns that automatically activate appropriate MCP servers:

```markdown
| Pattern | MCP Server | Use Case |
|---------|------------|----------|
| External libraries | context7 | Get accurate documentation |
| Complex debugging | sequential | Multi-step analysis |
| UI/Component work | magic | Generate components |
| Testing mentioned | playwright | Automate testing |
```

### Manual Invocation
You can explicitly request MCP server usage:

```bash
# Use context7 for documentation
"Check React hooks documentation using context7"

# Use sequential for complex analysis
"Analyze this architecture with sequential thinking"

# Use magic for UI generation
"Generate a card component with magic"

# Use playwright for testing
"Create E2E tests with playwright"
```

## 🔍 Verification

After setup, verify MCP configuration:

```bash
# Run test script
~/.claude/test-mcp.sh

# Should show:
# ✓ Config file found
# ✓ Configured MCP servers
# ✓ Node.js installed
```

## 🎨 Integration with Sub-Agents

MCP servers enhance ClaudeNext sub-agents:

| Sub-Agent | MCP Servers Used | Purpose |
|-----------|-----------------|---------|
| security-auditor | sequential | Deep vulnerability analysis |
| architect | sequential, context7 | System design with documentation |
| frontend-specialist | magic, context7 | Component generation with best practices |
| performance-optimizer | sequential | Complex performance analysis |
| workflow-orchestrator | sequential | Multi-step planning |

## ⚙️ Requirements

- **Node.js**: Required for npx command (install from nodejs.org)
- **Claude Code**: Desktop application must be installed
- **Internet**: MCP servers are fetched on-demand

## 🐛 Troubleshooting

### MCP servers not activating?
1. Restart Claude Code after configuration
2. Check Node.js is installed: `node --version`
3. Verify config file exists: `~/.claude/test-mcp.sh`

### Server errors?
- Some MCP servers may be private/paid
- Claude Code will show connection errors in logs
- Basic functionality works without MCP servers

### Performance issues?
- MCP servers run on-demand, first run may be slower
- Subsequent runs are cached
- Disable unused servers in config

## 📚 Advanced Configuration

### Server Priority
When multiple servers could handle a task, ClaudeNext uses priority:

```json
{
  "serverPriority": {
    "documentation": ["context7", "sequential"],
    "debugging": ["sequential", "context7"],
    "ui": ["magic", "context7"],
    "testing": ["playwright", "sequential"]
  }
}
```

### Timeout and Retry
Configure server behavior:

```json
{
  "configuration": {
    "timeout": 30000,
    "retryAttempts": 2,
    "parallelExecution": true
  }
}
```

## 🎉 Summary

MCP servers supercharge ClaudeNext with:
- **Real-time documentation** access
- **Complex reasoning** capabilities
- **UI generation** tools
- **Testing automation** support

Combined with ClaudeNext's sub-agents and principles, you get a complete AI-powered development environment!