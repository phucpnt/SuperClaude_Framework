#!/bin/bash

# Test script for CTO Orchestrator functionality
# This demonstrates how the CTO handles different types of requests

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${PURPLE}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║     CTO Orchestrator Test & Demonstration         ║${NC}"
echo -e "${PURPLE}╚════════════════════════════════════════════════════╝${NC}"
echo ""

echo -e "${BLUE}Testing CTO Orchestrator delegation patterns...${NC}"
echo ""

# Test 1: High Confidence Single Agent
echo -e "${YELLOW}Test 1: Security-focused request${NC}"
echo "Request: 'Scan my API for OWASP vulnerabilities'"
echo -e "${GREEN}Expected:${NC} CTO → security-auditor (confidence: ~0.95)"
echo ""

# Test 2: Language-specific
echo -e "${YELLOW}Test 2: Language-specific request${NC}"
echo "Request: 'Write a concurrent worker pool in Go'"
echo -e "${GREEN}Expected:${NC} CTO → golang-pro (confidence: ~0.98)"
echo ""

# Test 3: Medium Confidence Multi-Agent
echo -e "${YELLOW}Test 3: Performance optimization${NC}"
echo "Request: 'Optimize my checkout process'"
echo -e "${GREEN}Expected:${NC} CTO → performance-optimizer + frontend-specialist"
echo ""

# Test 4: Complex Multi-Domain
echo -e "${YELLOW}Test 4: Complex system design${NC}"
echo "Request: 'Build a secure real-time chat system'"
echo -e "${GREEN}Expected:${NC} CTO → Wave orchestration:"
echo "  Wave 1: architect + workflow-orchestrator"
echo "  Wave 2: security-auditor + frontend-specialist + golang-pro"
echo "  Wave 3: test-writer-fixer + performance-optimizer"
echo "  Wave 4: docs-architect"
echo ""

# Test 5: Ambiguous Request
echo -e "${YELLOW}Test 5: Ambiguous request${NC}"
echo "Request: 'Make my application better'"
echo -e "${GREEN}Expected:${NC} CTO → Multi-agent analysis team"
echo ""

echo -e "${PURPLE}═══════════════════════════════════════════════════════${NC}"
echo ""

# Check if CTO is installed
if [ -f ~/.claude/agents/cto-orchestrator.md ]; then
    echo -e "${GREEN}✓${NC} CTO Orchestrator is installed"
    
    # Display CTO capabilities
    echo ""
    echo -e "${BLUE}CTO Orchestrator Capabilities:${NC}"
    echo "  • Analyzes request complexity (0.0 - 1.0)"
    echo "  • Calculates confidence scores"
    echo "  • Delegates to 12 specialist agents"
    echo "  • Orchestrates sequential/parallel/wave execution"
    echo "  • Monitors progress via TodoWrite"
    echo ""
    
    # Show available specialists
    echo -e "${BLUE}Available Specialists:${NC}"
    for agent in ~/.claude/agents/*.md; do
        if [ -f "$agent" ]; then
            name=$(grep "^name:" "$agent" | cut -d' ' -f2)
            if [ "$name" != "cto-orchestrator" ]; then
                echo "  • $name"
            fi
        fi
    done
else
    echo -e "${YELLOW}⚠${NC} CTO Orchestrator not installed"
    echo "  Run ./install.sh to install"
fi

echo ""
echo -e "${PURPLE}═══════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${BLUE}Example Claude Code Usage:${NC}"
echo ""
echo '```python'
echo '# Let the CTO handle everything'
echo 'Task('
echo '    subagent_type="cto-orchestrator",'
echo '    prompt="Build a secure payment processing system",'
echo '    description="Autonomous orchestration"'
echo ')'
echo ''
echo '# The CTO will:'
echo '# 1. Analyze: Complexity=0.85, Domains=[Security, Payment, Backend]'
echo '# 2. Delegate: architect → security-auditor → test-writer → code-reviewer'
echo '# 3. Execute: Sequential with checkpoints'
echo '# 4. Deliver: Complete implementation with tests and documentation'
echo '```'
echo ""

echo -e "${GREEN}CTO Orchestrator test complete!${NC}"
echo ""
echo "Documentation: ./CTO_ORCHESTRATOR_GUIDE.md"
echo "Integration: ./CLAUDE_CTO_INTEGRATION.md"