#!/bin/bash
# Functional-Ralph - Autonomous AI Development Loop
# Usage: functional-ralph <design-doc> <progress-file> [max-iterations] [--agent claude|kiro]
#
# Examples:
#   functional-ralph ./design.md ./tasks.md             # Runs with claude (default)
#   functional-ralph ./design.md ./tasks.md 20          # Max 20 iterations
#   functional-ralph ./design.md ./tasks.md --agent kiro  # Use kiro agent
#
# Exit conditions:
#   - "FUNCTIONAL_RALPH_DONE" appears in progress file
#   - Max iterations reached (if specified)
#   - Ctrl+C

set -euo pipefail

FUNCTIONAL_RALPH_DIR="$(cd "$(dirname "$0")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Validate config file syntax before sourcing
validate_config() {
    local config_file="$1"
    if [ -f "$config_file" ] && ! bash -n "$config_file" 2>/dev/null; then
        echo -e "${YELLOW}Warning: Syntax error in $config_file${NC}" >&2
        echo -e "${YELLOW}Run: bash -n $config_file to see details${NC}" >&2
        return 1
    fi
    return 0
}

# Load configuration
if [ -f "$HOME/.functional-ralph.env" ] && validate_config "$HOME/.functional-ralph.env"; then
    source "$HOME/.functional-ralph.env"
fi

VERSION="2.0.0"

# Auto-commit setting (default: true)
FUNCTIONAL_RALPH_AUTO_COMMIT="${FUNCTIONAL_RALPH_AUTO_COMMIT:-true}"

# Check if file contains DO_NOT_COMMIT directive
should_skip_commit() {
    local file="$1"
    [ ! -f "$file" ] && return 1
    awk '
        /^```/ { in_code = !in_code; next }
        !in_code && /^[[:space:]]*DO_NOT_COMMIT[[:space:]]*$/ { found=1; exit }
        END { exit !found }
    ' "$file"
}

usage() {
    echo -e "${GREEN}Functional-Ralph${NC} v${VERSION} - Autonomous AI Development Loop"
    echo ""
    echo -e "${YELLOW}Usage:${NC}"
    echo "  functional-ralph <design-doc> <progress-file> [max-iterations] [--agent claude|kiro]"
    echo "  functional-ralph config <setting>"
    echo "  functional-ralph --help | -h"
    echo "  functional-ralph --version | -v"
    echo ""
    echo -e "${YELLOW}Arguments:${NC}"
    echo "  design-doc      Path to your design/spec document (required)"
    echo "  progress-file   Path to your task list/progress file (required)"
    echo "  max-iterations  Maximum loop iterations (default: unlimited)"
    echo "  --agent         AI agent to use: claude (default) or kiro"
    echo ""
    echo -e "${YELLOW}Examples:${NC}"
    echo "  functional-ralph ./design.md ./tasks.md                # Build until done"
    echo "  functional-ralph ./design.md ./tasks.md 20             # Max 20 iterations"
    echo "  functional-ralph ./design.md ./tasks.md --agent kiro   # Use kiro agent"
    echo ""
    echo -e "${YELLOW}Exit Conditions:${NC}"
    echo "  - FUNCTIONAL_RALPH_DONE appears in progress file"
    echo "  - Max iterations reached (if specified)"
    echo "  - Ctrl+C"
    echo ""
    echo -e "${YELLOW}Configuration:${NC}"
    echo "  functional-ralph config commit on      Enable auto-commit (default)"
    echo "  functional-ralph config commit off     Disable auto-commit"
    echo "  functional-ralph config commit status  Show current setting"
    echo ""
    echo -e "${YELLOW}File Directives:${NC}"
    echo "  Add DO_NOT_COMMIT on its own line to disable commits"
    exit 0
}

version() {
    echo "Functional-Ralph v${VERSION}"
    exit 0
}

# Parse arguments
if [ $# -lt 1 ]; then
    usage
fi

# Handle help and version flags
if [ "$1" = "--help" ] || [ "$1" = "-h" ] || [ "$1" = "help" ]; then
    usage
fi

if [ "$1" = "--version" ] || [ "$1" = "-v" ]; then
    version
fi

# Handle config subcommand
if [ "$1" = "config" ]; then
    CONFIG_FILE="$HOME/.functional-ralph.env"

    set_config_value() {
        local key="$1"
        local value="$2"
        if [ -f "$CONFIG_FILE" ]; then
            if grep -qE "^(export )?${key}=" "$CONFIG_FILE" 2>/dev/null; then
                sed -i "s/^export ${key}=.*/export ${key}=\"${value}\"/" "$CONFIG_FILE"
                sed -i "s/^${key}=.*/export ${key}=\"${value}\"/" "$CONFIG_FILE"
            else
                echo "" >> "$CONFIG_FILE"
                echo "export ${key}=\"${value}\"" >> "$CONFIG_FILE"
            fi
        else
            echo '# Functional-Ralph Configuration' > "$CONFIG_FILE"
            echo "# Generated on $(date)" >> "$CONFIG_FILE"
            echo "" >> "$CONFIG_FILE"
            echo "export ${key}=\"${value}\"" >> "$CONFIG_FILE"
            chmod 600 "$CONFIG_FILE"
        fi
    }

    case "${2:-}" in
        commit)
            case "${3:-}" in
                on|true|yes|1)
                    set_config_value "FUNCTIONAL_RALPH_AUTO_COMMIT" "true"
                    echo -e "${GREEN}Auto-commit enabled${NC}"
                    ;;
                off|false|no|0)
                    set_config_value "FUNCTIONAL_RALPH_AUTO_COMMIT" "false"
                    echo -e "${YELLOW}Auto-commit disabled${NC}"
                    ;;
                status|"")
                    echo -e "${YELLOW}Auto-commit:${NC} $([ "$FUNCTIONAL_RALPH_AUTO_COMMIT" = "true" ] && echo -e "${GREEN}enabled${NC}" || echo -e "${YELLOW}disabled${NC}")"
                    ;;
                *)
                    echo -e "${RED}Unknown option: $3${NC}"
                    exit 1
                    ;;
            esac
            exit 0
            ;;
        "")
            echo -e "${YELLOW}Usage:${NC} functional-ralph config <setting>"
            echo "  commit <on|off|status>    Configure auto-commit behavior"
            exit 1
            ;;
        *)
            echo -e "${RED}Unknown config setting: $2${NC}"
            exit 1
            ;;
    esac
fi

# Require both design doc and progress file
if [ $# -lt 2 ]; then
    echo -e "${RED}Error: Both design-doc and progress-file are required${NC}"
    usage
fi

DESIGN_DOC="$1"
PROGRESS_FILE="$2"
MAX_ITERATIONS="0"
AGENT="claude"

# Parse remaining arguments
shift 2
while [ $# -gt 0 ]; do
    case "$1" in
        --agent)
            AGENT="${2:-claude}"
            if [ "$AGENT" != "claude" ] && [ "$AGENT" != "kiro" ]; then
                echo -e "${RED}Error: Agent must be 'claude' or 'kiro', got: $AGENT${NC}"
                exit 1
            fi
            shift 2
            ;;
        *)
            if [[ "$1" =~ ^[0-9]+$ ]]; then
                MAX_ITERATIONS="$1"
            fi
            shift
            ;;
    esac
done

# Validate files exist
if [ ! -f "$DESIGN_DOC" ]; then
    echo -e "${RED}Error: Design doc not found: $DESIGN_DOC${NC}"
    exit 1
fi

if [ ! -f "$PROGRESS_FILE" ]; then
    echo -e "${RED}Error: Progress file not found: $PROGRESS_FILE${NC}"
    exit 1
fi

DESIGN_DOC_ABS=$(realpath "$DESIGN_DOC")
PROGRESS_FILE_ABS=$(realpath "$PROGRESS_FILE")

PROMPT_TEMPLATE="$FUNCTIONAL_RALPH_DIR/PROMPT_build.md"

# Verify prompt template exists
if [ ! -f "$PROMPT_TEMPLATE" ]; then
    echo -e "${RED}Error: Prompt template not found: $PROMPT_TEMPLATE${NC}"
    exit 1
fi

# Compute commit setting
SHOULD_COMMIT="true"
COMMIT_DISABLED_REASON=""
if [ "$FUNCTIONAL_RALPH_AUTO_COMMIT" != "true" ]; then
    SHOULD_COMMIT="false"
    COMMIT_DISABLED_REASON="(disabled via config)"
elif should_skip_commit "$DESIGN_DOC" || should_skip_commit "$PROGRESS_FILE"; then
    SHOULD_COMMIT="false"
    COMMIT_DISABLED_REASON="(DO_NOT_COMMIT directive found)"
fi

# Print banner
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  FUNCTIONAL-RALPH - Autonomous AI Development Loop${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "  Design:    ${YELLOW}$DESIGN_DOC${NC}"
echo -e "  Progress:  ${YELLOW}$PROGRESS_FILE${NC}"
echo -e "  Agent:     ${YELLOW}$AGENT${NC}"
[ "$MAX_ITERATIONS" -gt 0 ] && echo -e "  Max Iter:  ${YELLOW}$MAX_ITERATIONS${NC}"
if [ "$SHOULD_COMMIT" = "true" ]; then
    echo -e "  Commit:    ${GREEN}enabled${NC}"
else
    echo -e "  Commit:    ${YELLOW}disabled${NC} ${COMMIT_DISABLED_REASON}"
fi
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}Exit conditions:${NC}"
echo "  - FUNCTIONAL_RALPH_DONE in $PROGRESS_FILE signals all tasks complete"
echo "  - Press Ctrl+C to stop manually"
echo ""

ITERATION=0

is_done() {
    if [ -f "$PROGRESS_FILE" ]; then
        grep -qx "FUNCTIONAL_RALPH_DONE" "$PROGRESS_FILE" 2>/dev/null && return 0
    fi
    return 1
}

# Main loop
while true; do
    if is_done; then
        echo ""
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${GREEN}  FUNCTIONAL_RALPH_DONE - Work complete!${NC}"
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        break
    fi

    if [ "$MAX_ITERATIONS" -gt 0 ] && [ "$ITERATION" -ge "$MAX_ITERATIONS" ]; then
        echo ""
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${YELLOW}  Max iterations reached: $MAX_ITERATIONS${NC}"
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        break
    fi

    ITERATION=$((ITERATION + 1))
    echo ""
    echo -e "${BLUE}══════════════════ ITERATION $ITERATION ══════════════════${NC}"
    echo -e "${BLUE}  (New context window - fresh AI session)${NC}"
    echo ""

    # Build the prompt with substitutions
    PROMPT=$(cat "$PROMPT_TEMPLATE" | \
        sed "s|\${DESIGN_DOC}|$DESIGN_DOC_ABS|g" | \
        sed "s|\${PROGRESS_FILE}|$PROGRESS_FILE_ABS|g" | \
        sed "s|\${AUTO_COMMIT}|$SHOULD_COMMIT|g")

    # Run AI agent
    if [ "$AGENT" = "kiro" ]; then
        echo "$PROMPT" | kiro-cli chat \
            --trust-all-tools \
            --verbose 2>&1 || {
                echo -e "${RED}Kiro exited with error, continuing...${NC}"
            }
    else
        echo "$PROMPT" | claude -p \
            --dangerously-skip-permissions \
            --model sonnet \
            --verbose 2>&1 || {
                echo -e "${RED}Claude exited with error, continuing...${NC}"
            }
    fi

    echo ""
    echo -e "${GREEN}Iteration $ITERATION complete${NC}"

    sleep 2
done

echo ""
echo "Total iterations: $ITERATION"
echo "Progress file: $PROGRESS_FILE"
