# ClaudeNext - Enhanced Sub-Agents for Claude Code

ClaudeNext is a collection of specialized sub-agents that extend Claude Code's capabilities with domain-specific expertise. It works seamlessly with Claude Code's native Task tool and sub-agent architecture.

## 🚀 Quick Start

```bash
# Clone or download ClaudeNext
cd ClaudeNext

# Run installation script
./install.sh

# Choose installation mode:
# 1) Full Installation (recommended)
# 2) Agents Only
# 3) CLAUDE.md Only
# 4) Custom Selection
```

## 📦 What's Included

### Specialized Sub-Agents

1. **security-auditor** - OWASP compliance and vulnerability scanning
2. **architect** - System design and scalability planning
3. **frontend-specialist** - React/Vue/Angular expert with performance focus
4. **performance-optimizer** - Sub-100ms response time specialist
5. **workflow-orchestrator** - PRD to implementation workflow generator
6. **ai-engineer** - AI/ML implementation, LLM integration, recommendation systems
7. **test-writer-fixer** - Intelligent test automation and maintenance
8. **experiment-tracker** - A/B testing, feature validation, metrics analysis

### Enhanced Instructions

- **CLAUDE.md** - Consolidated instructions with senior engineering principles
- **Command shortcuts** - Quick access to specialized agents

### MCP Server Integration

- **context7** - Official documentation and API references
- **sequential** - Complex analysis and multi-step reasoning
- **magic** - UI component generation and design systems
- **playwright** - Browser automation and E2E testing

## 🎯 Key Features

### Native Claude Code Integration
- Works with Claude Code's Task tool
- No custom frameworks or libraries needed
- Follows Claude Code's sub-agent specifications

### Intelligent Routing
- Auto-detects task complexity
- Routes to appropriate specialists
- Coordinates multi-agent workflows

### Wave Execution
- Breaks complex tasks into manageable waves
- Progressive enhancement strategy
- 30-50% better results on complex tasks

## 📖 Usage

### Command Line Shortcuts

```bash
# Auto-routing (recommended for most tasks)
/sc implement secure payment system

# Specific agent invocation
/sc:security audit my API endpoints
/sc:architect design microservices architecture
/sc:frontend create accessible React form
/sc:performance optimize database queries
/sc:workflow create plan from PRD
```

### Direct Agent Invocation

In Claude Code, you can directly invoke agents:

```python
# Using Task tool
Task(
    subagent_type="security-auditor",
    prompt="Scan for OWASP Top 10 vulnerabilities"
)

Task(
    subagent_type="architect",
    prompt="Design scalable chat architecture"
)
```

## 🏗️ Architecture

```
~/.claude/
├── CLAUDE.md                    # Main instructions with principles
├── agents/                      # Sub-agent definitions
│   ├── security-auditor.md
│   ├── architect.md
│   ├── frontend-specialist.md
│   ├── performance-optimizer.md
│   ├── workflow-orchestrator.md
│   ├── ai-engineer.md
│   ├── test-writer-fixer.md
│   └── experiment-tracker.md
├── claude_desktop_config.json   # MCP server configuration
├── test-claudenext.sh          # Agent verification script
└── test-mcp.sh                 # MCP verification script
```

## 🔧 How It Works

### Sub-Agents
1. **Markdown files** with YAML frontmatter define agent behavior
2. **Claude Code loads them** automatically from `~/.claude/agents/`
3. **Task tool invokes them** based on subagent_type
4. **Each agent has focused expertise** and specific tools

### MCP Servers
1. **External services** provide specialized capabilities
2. **Auto-activate** based on context patterns
3. **Enhance agents** with real-time documentation and tools
4. **Run on-demand** via npx for zero installation

## 🎯 When to Use Each Agent

| Agent | Best For |
|-------|----------|
| **security-auditor** | Security audits, OWASP compliance, vulnerability scanning |
| **architect** | System design, technology selection, scalability planning |
| **frontend-specialist** | UI/UX implementation, accessibility, performance |
| **performance-optimizer** | Speed optimization, caching, database tuning |
| **workflow-orchestrator** | Project planning, PRD analysis, task breakdown |
| **ai-engineer** | AI features, LLM integration, ML pipelines, computer vision |
| **test-writer-fixer** | Test creation, test repair, coverage analysis |
| **experiment-tracker** | A/B testing, feature flags, data-driven decisions |

## 🚦 Wave Execution Strategy

Complex tasks are automatically broken into waves:

```markdown
Wave 1: Foundation (20% effort, 80% learning)
Wave 2: Core Features (40% effort)
Wave 3: Enhancement (25% effort)
Wave 4: Polish (15% effort)
```

## 📊 Performance Benefits

- **30-50% better results** on complex tasks
- **Specialized expertise** for domain-specific problems
- **Automatic optimization** based on task complexity
- **Progressive enhancement** prevents over-engineering

## 🔍 Verification

After installation, verify with:

```bash
~/.claude/test-claudenext.sh
```

This will show:
- Installed agents and their descriptions
- CLAUDE.md installation status
- File statistics

## 🤝 Compatibility

- **Claude Code**: Fully compatible with native Task tool
- **MCP Servers**: Integrates with Model Context Protocol
- **Custom Agents**: Can coexist with other custom agents
- **Node.js**: Required for MCP server execution (npx)

## 📝 Creating Your Own Agents

To create a custom agent:

1. Create a markdown file in `~/.claude/agents/`
2. Add YAML frontmatter:
```yaml
---
name: my-agent
description: What this agent does
tools: Read, Write, Bash
---
```
3. Write detailed instructions in markdown
4. Agent is automatically available via Task tool

## 🐛 Troubleshooting

**Agents not working?**
- Verify installation: `~/.claude/test-claudenext.sh`
- Check agent files exist in `~/.claude/agents/`
- Ensure proper YAML frontmatter format

**Commands not recognized?**
- Commands are shortcuts, not built-in
- Use Task tool directly if shortcuts don't work
- Check CLAUDE.md is properly installed

## 📚 Learn More

- [Claude Code Sub-Agents Documentation](https://docs.anthropic.com/en/docs/claude-code/sub-agents)
- [Task Tool Documentation](https://docs.anthropic.com/en/docs/claude-code/tools)

## 🎉 Summary

ClaudeNext enhances Claude Code with:
- **8 specialized sub-agents** for comprehensive development coverage
- **Senior engineering principles** for thoughtful development
- **MCP server integration** for enhanced capabilities
- **Intelligent routing** for optimal task handling
- **Wave execution** for complex operations
- **Native integration** with Claude Code's architecture

Start with `/sc` for auto-routing, or use specific agents when you know exactly what you need!