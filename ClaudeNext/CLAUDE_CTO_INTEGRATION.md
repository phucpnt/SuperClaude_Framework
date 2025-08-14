# Integrating CTO Orchestrator as Default Handler

## 🎯 Recommended Integration Approach

Add this section to your CLAUDE.md to make the CTO orchestrator your default request handler:

```markdown
## 🤖 Autonomous Agent Orchestration

### Primary Request Handler
For ALL technical requests, use the CTO orchestrator for autonomous delegation:

When receiving any user request:
1. First, invoke the CTO orchestrator
2. Let it analyze and delegate to specialists
3. Only use direct agent invocation when explicitly requested

Example:
Task(
    subagent_type="cto-orchestrator",
    prompt=user_request,
    description="Autonomous orchestration"
)

### CTO Orchestrator Capabilities
The CTO will automatically:
- Analyze request complexity and domains
- Calculate confidence scores for agent selection
- Delegate to single or multiple specialists
- Orchestrate sequential/parallel/wave execution
- Monitor progress and compile results

### Confidence-Based Routing
- High (≥0.8): Single specialist, immediate execution
- Medium (0.5-0.79): Primary + supporting agents
- Low (<0.5): Full team coordination

### Override Syntax
Users can still request specific agents:
- "Use the security-auditor to..." → Direct to security-auditor
- "Ask the golang-pro to..." → Direct to golang-pro
- Default (no agent specified) → CTO orchestrator decides
```

## 🚀 Implementation Pattern

### Option 1: Modify Your Existing Workflow

In your current Claude Code workflow, replace agent selection logic with:

```python
def handle_user_request(request):
    # Check for explicit agent request
    if "use the" in request.lower() or "ask the" in request.lower():
        # Extract and use specific agent
        agent = extract_agent_name(request)
        return Task(subagent_type=agent, prompt=request)
    
    # Default: Let CTO orchestrate
    return Task(
        subagent_type="cto-orchestrator",
        prompt=request,
        description="Autonomous delegation and orchestration"
    )
```

### Option 2: Command Wrapper

Create a simple command wrapper:

```bash
# In CLAUDE.md commands section
/cto [request] - Routes through CTO orchestrator
/sc [request] - Alias for /cto (smart coordination)

# Implementation
When /cto or /sc is used:
Task(subagent_type="cto-orchestrator", prompt=request)
```

### Option 3: Auto-Detection Rules

```markdown
## Auto-Invoke CTO for:
- Requests without clear agent specification
- Multi-domain problems (security + performance + architecture)
- Complex requests (>50 words or multiple requirements)
- Ambiguous requests ("make it better", "fix issues")
- Project-level requests ("build X system")
```

## 📊 Example Flows

### Simple Request Flow
```
User: "Check for security vulnerabilities"
     ↓
CTO: Analyzes (Domain: Security, Confidence: 0.95)
     ↓
CTO: Delegates to security-auditor
     ↓
Result: Security audit report
```

### Complex Request Flow
```
User: "Build a real-time chat system with authentication"
     ↓
CTO: Analyzes (Complexity: 0.85, Multiple domains)
     ↓
CTO: Orchestrates:
     Wave 1: architect + workflow-orchestrator
     Wave 2: security-auditor (auth) + frontend-specialist (UI)
     Wave 3: golang-pro (backend) + performance-optimizer
     Wave 4: test-writer-fixer + docs-architect
     ↓
Result: Complete system with docs and tests
```

## 🎬 Quick Test

After integration, test with these requests:

```python
# Test 1: Security-focused (should route to security-auditor)
"Scan my API endpoints for vulnerabilities"

# Test 2: Go-specific (should route to golang-pro)
"Write concurrent Go code for data processing"

# Test 3: Complex multi-domain (should orchestrate team)
"Design and implement a scalable microservices architecture"

# Test 4: Ambiguous (CTO should analyze and decide)
"Improve my application's performance"

# Test 5: Explicit override (should use specified agent)
"Use the frontend-specialist to create a React dashboard"
```

## 💡 Benefits of CTO-First Approach

1. **No Manual Selection**: Users don't need to know which agent to use
2. **Optimal Routing**: CTO knows each specialist's strengths
3. **Automatic Coordination**: Complex tasks get multi-agent support
4. **Confidence Scoring**: Transparent decision-making
5. **Scalability**: Easy to add new specialists to the team

## 🔧 Customization

You can customize the CTO's behavior by modifying its prompt in `cto-orchestrator.md`:

- Adjust confidence thresholds
- Add new delegation patterns
- Modify orchestration strategies
- Update agent specializations
- Change communication style

## 📝 Remember

The CTO orchestrator transforms ClaudeNext from a collection of agents into an autonomous engineering team. Users simply describe what they need, and the CTO ensures the right specialists handle it.