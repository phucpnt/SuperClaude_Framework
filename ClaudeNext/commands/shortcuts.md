# ClaudeNext Command Shortcuts

These shortcuts leverage Claude Code's native Task tool to invoke specialized sub-agents.

## Available Commands

### `/sc` - Smart Auto-Routing
Automatically analyzes your request and routes to the best agent.

```bash
/sc implement a secure user authentication system
# Auto-routes to: security-auditor + architect + implementer
```

### `/sc:security` - Security Audit
Performs comprehensive security analysis using the security-auditor agent.

```bash
/sc:security audit my API endpoints
# Invokes: Task(subagent_type="security-auditor", prompt="...")
```

### `/sc:architect` - System Design
Creates architecture designs and technical decisions.

```bash
/sc:architect design a scalable chat system
# Invokes: Task(subagent_type="architect", prompt="...")
```

### `/sc:frontend` - Frontend Development
Implements modern, accessible, performant UI components.

```bash
/sc:frontend create a responsive dashboard with React
# Invokes: Task(subagent_type="frontend-specialist", prompt="...")
```

### `/sc:performance` - Performance Optimization
Analyzes and optimizes for sub-100ms response times.

```bash
/sc:performance optimize database queries
# Invokes: Task(subagent_type="performance-optimizer", prompt="...")
```

### `/sc:workflow` - PRD to Implementation
Converts requirements into actionable workflows with wave execution.

```bash
/sc:workflow create implementation plan for user management system
# Invokes: Task(subagent_type="workflow-orchestrator", prompt="...")
```

## Command Implementation

Each command is a thin wrapper that:
1. Parses the user input
2. Determines complexity and context
3. Invokes the appropriate sub-agent via Task tool
4. May coordinate multiple agents for complex tasks

## Smart Routing Logic

The `/sc` command uses pattern matching to determine routing:

| Pattern Detected | Agents Invoked |
|-----------------|----------------|
| "security", "vulnerability", "OWASP" | security-auditor |
| "design", "architecture", "scale" | architect |
| "UI", "component", "React/Vue" | frontend-specialist |
| "slow", "optimize", "performance" | performance-optimizer |
| "PRD", "plan", "workflow" | workflow-orchestrator |
| Multiple patterns | Multiple agents in sequence |

## Wave Execution

For complex tasks, commands automatically enable wave execution:

```bash
/sc:workflow implement complete e-commerce platform

# Executes in waves:
# Wave 1: Architecture design (architect)
# Wave 2: Security planning (security-auditor)
# Wave 3: Implementation (frontend + backend)
# Wave 4: Optimization (performance-optimizer)
```

## Examples

### Simple Task
```bash
/sc:frontend create a login form
# Single agent, direct execution
```

### Complex Task
```bash
/sc build a real-time collaborative editor
# Multi-agent orchestration:
# 1. architect: WebSocket architecture
# 2. security-auditor: Security considerations
# 3. frontend-specialist: UI implementation
# 4. performance-optimizer: Latency optimization
```

### With Options
```bash
/sc:architect design microservices --scale=large --cloud=aws
# Passes context to architect agent
```

## Integration with Claude Code

These commands integrate seamlessly with Claude Code's native features:

- Uses TodoWrite for task tracking
- Leverages native Task tool for agent invocation
- Respects Claude Code's context limits
- Works with existing MCP servers
- Maintains conversation context

## Best Practices

1. **Start Simple**: Use `/sc` for auto-routing
2. **Be Specific**: Direct commands for known tasks
3. **Leverage Waves**: Complex tasks benefit from wave execution
4. **Chain Commands**: Combine agents for comprehensive solutions
5. **Review Outputs**: Each agent provides detailed analysis

## Under the Hood

```python
# Pseudo-code for command processing
def process_command(cmd, args):
    if cmd == "/sc":
        agents = analyze_and_route(args)
        for agent in agents:
            Task(subagent_type=agent, prompt=args)
    elif cmd == "/sc:security":
        Task(subagent_type="security-auditor", prompt=args)
    # ... other commands
```

Remember: These commands are shortcuts to powerful specialized agents. Use them to get expert-level assistance in specific domains.