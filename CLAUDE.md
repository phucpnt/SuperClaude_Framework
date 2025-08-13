# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Installation & Setup
```bash
# Standard installation with prompts
python3 -m SuperClaude install

# Installation options
python3 -m SuperClaude install --interactive  # Interactive mode with prompts
python3 -m SuperClaude install --minimal      # Minimal installation
python3 -m SuperClaude install --profile security  # Profile-based installation
python3 -m SuperClaude install --dry-run      # Preview without installing

# Alternative installation
uv add SuperClaude  # Using modern Python package manager
uv sync            # Sync dependencies
```

### Build & Package
```bash
python3 setup.py build          # Traditional build
python3 -m hatchling build      # Modern build system
```

### Testing & Validation
- Testing is integrated through SuperClaude framework commands:
  - `/sc:test` - Run framework tests
  - Component validation happens during installation
  - MCP server integration tested during setup

### Code Quality
- Quality management through SuperClaude commands:
  - `/sc:analyze` - Code analysis
  - `/sc:improve` - Suggest improvements
  - `/sc:cleanup` - Clean and optimize code

## Architecture Overview

SuperClaude is a modular, plugin-based framework that extends Claude Code with intelligent routing and specialized capabilities. The system operates in four integrated layers:

### Core Architecture Pattern
The framework uses **Intelligent Orchestration** - an auto-detection system that analyzes user requests and automatically routes them to the most appropriate persona or tool without manual specification. This is achieved through:

1. **Request Analysis** - Natural language processing to understand intent
2. **Confidence Scoring** - Evaluates which components best match the request
3. **Dynamic Routing** - Automatically invokes appropriate personas and tools
4. **Wave Orchestration** - Multi-stage execution for complex operations

### Key Components

**Framework Core (`SuperClaude/`):**
- 16 specialized slash commands (e.g., `/sc:build`, `/sc:optimize`, `/sc:security`)
- 11 AI personas with domain expertise (Security, Frontend, Backend, DevOps, etc.)
- Intelligent orchestrator that auto-routes requests

**MCP Integration Layer:**
- External service connections via Model Context Protocol
- Servers: Context7 (enhanced context), Sequential (workflow), Magic (advanced search), Playwright (browser automation)
- Located in `mcp_servers/` with individual server configurations

**Installation System (`SuperClaude/components/`):**
- Modular component architecture with dependency resolution
- Profile-based installation (minimal, security, webdev, fullstack)
- 8-step validation pipeline ensuring safe installation

**Configuration Management:**
- Feature flags and requirements in `SuperClaude/features/`
- Dynamic profile generation based on project analysis
- Settings persistence in `~/.claude/framework.json`

### Architectural Decisions

1. **Validation-First Design**: Every operation passes through quality gates before execution
2. **Evidence-Based Development**: All suggestions backed by confidence scores and context analysis
3. **Composable Architecture**: Clear component interfaces allowing mix-and-match functionality
4. **Progressive Enhancement**: Start with minimal setup, add components as needed
5. **Multi-Protocol Support**: Integrates with MCP, HTTP, and native Python APIs

### Request Flow

1. User input → Orchestrator analyzes intent
2. Orchestrator → Selects persona(s) and tools based on confidence scoring
3. Persona → Executes specialized logic with appropriate tools
4. Tools → Perform operations (file manipulation, MCP calls, analysis)
5. Results → Aggregated and returned with evidence/confidence scores

### Working with the Codebase

When modifying SuperClaude:
- Components in `SuperClaude/components/` are independent modules with defined interfaces
- Personas in framework files follow a consistent structure with `handle()` methods
- MCP servers require proper initialization and protocol compliance
- Installation changes must update dependency graphs in component definitions
- All user-facing operations should include validation and error handling