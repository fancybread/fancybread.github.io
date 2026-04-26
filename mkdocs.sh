#!/bin/bash

set -e

VENV_DIR=".venv"
PID_FILE=".mkdocs.pid"
LOG_FILE="mkdocs.log"
PORT=8000

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_msg() {
    local color=$1
    shift
    echo -e "${color}$@${NC}"
}

check_venv() {
    if [ ! -d "$VENV_DIR" ]; then
        print_msg $YELLOW "Virtual environment not found. Creating..."
        python3 -m venv $VENV_DIR
        "$VENV_DIR/bin/pip" install --upgrade pip -q
        "$VENV_DIR/bin/pip" install -r requirements.txt -q
        print_msg $GREEN "Virtual environment created and dependencies installed."
    fi
}

activate_venv() {
    if [ -f "$VENV_DIR/bin/activate" ]; then
        source $VENV_DIR/bin/activate
    else
        print_msg $RED "Error: Virtual environment not found. Run './mkdocs.sh setup' first."
        exit 1
    fi
}

is_running() {
    if [ -f "$PID_FILE" ]; then
        local pid=$(cat $PID_FILE)
        if ps -p $pid > /dev/null 2>&1; then
            return 0
        else
            rm -f $PID_FILE
            return 1
        fi
    fi
    return 1
}

start_server() {
    if is_running; then
        print_msg $YELLOW "MkDocs is already running (PID: $(cat $PID_FILE))"
        print_msg $BLUE "Visit: http://127.0.0.1:$PORT"
        return 0
    fi

    check_venv
    activate_venv

    print_msg $BLUE "Starting MkDocs server..."
    nohup "$VENV_DIR/bin/mkdocs" serve --dev-addr 127.0.0.1:$PORT > $LOG_FILE 2>&1 &
    local pid=$!
    echo $pid > $PID_FILE

    sleep 2

    if is_running; then
        print_msg $GREEN "MkDocs server started (PID: $pid)"
        print_msg $BLUE "Visit: http://127.0.0.1:$PORT"
        print_msg $YELLOW "Logs: tail -f $LOG_FILE"
    else
        print_msg $RED "Failed to start MkDocs server"
        print_msg $YELLOW "Check logs: cat $LOG_FILE"
        rm -f $PID_FILE
        exit 1
    fi
}

stop_server() {
    if is_running; then
        local pid=$(cat $PID_FILE)
        print_msg $BLUE "Stopping MkDocs server (PID: $pid)..."
        kill $pid
        rm -f $PID_FILE
        print_msg $GREEN "MkDocs server stopped"
    else
        print_msg $YELLOW "MkDocs server is not running"
    fi
}

kill_server() {
    local pids
    pids=$(pgrep -f "mkdocs serve" 2>/dev/null || true)
    if [ -n "$pids" ]; then
        print_msg $BLUE "Killing MkDocs server process(es): $pids"
        echo "$pids" | xargs kill 2>/dev/null || true
        print_msg $GREEN "MkDocs server killed"
    else
        print_msg $YELLOW "No MkDocs serve process found"
    fi
    rm -f $PID_FILE
}

show_status() {
    if is_running; then
        local pid=$(cat $PID_FILE)
        print_msg $GREEN "MkDocs server is running (PID: $pid)"
        print_msg $BLUE "Visit: http://127.0.0.1:$PORT"
        print_msg $YELLOW "Logs: tail -f $LOG_FILE"
    else
        print_msg $YELLOW "MkDocs server is not running"
    fi
}

show_logs() {
    if [ -f "$LOG_FILE" ]; then
        tail -f $LOG_FILE
    else
        print_msg $YELLOW "No log file found. Server may not have been started yet."
    fi
}

restart_server() {
    print_msg $BLUE "Restarting MkDocs server..."
    stop_server
    sleep 1
    start_server
}

build_site() {
    check_venv
    activate_venv
    print_msg $BLUE "Building MkDocs site..."
    "$VENV_DIR/bin/mkdocs" build --strict
    print_msg $GREEN "Site built successfully"
    print_msg $YELLOW "Output in: site/"
}

clean() {
    print_msg $BLUE "Cleaning build artifacts..."
    stop_server
    rm -rf site/
    rm -f $LOG_FILE
    print_msg $GREEN "Cleaned"
}

setup() {
    print_msg $BLUE "Setting up development environment..."
    if [ ! -d "$VENV_DIR" ]; then
        print_msg $BLUE "Creating virtual environment..."
        python3 -m venv $VENV_DIR
    fi
    print_msg $BLUE "Installing dependencies..."
    "$VENV_DIR/bin/pip" install --upgrade pip -q
    "$VENV_DIR/bin/pip" install -r requirements.txt -q
    print_msg $GREEN "Setup complete"
    print_msg $YELLOW "Run 'make start' to start the server"
}

reset_env() {
    print_msg $BLUE "Resetting environment..."
    kill_server
    if [ -d "$VENV_DIR" ]; then
        print_msg $BLUE "Removing existing .venv..."
        rm -rf "$VENV_DIR"
    fi
    rm -f $LOG_FILE
    setup
    print_msg $GREEN "Reset complete. Run 'make start' to start the server"
}

usage() {
    cat << EOF
MkDocs Management Script

Usage: $0 [command]

Commands:
    start       Start MkDocs development server in background
    stop        Stop MkDocs development server (uses PID file)
    kill        Kill any mkdocs serve process (use if directory was renamed)
    restart     Restart MkDocs development server
    status      Show server status
    logs        Show and follow server logs (Ctrl+C to exit)
    build       Build the static site (strict mode)
    clean       Stop server and clean build artifacts
    setup       Set up virtual environment and install dependencies
    reset       Kill server, remove .venv and re-setup
    help        Show this help message

Server will be available at: http://127.0.0.1:$PORT
EOF
}

case "${1:-}" in
    start)   start_server ;;
    stop)    stop_server ;;
    kill)    kill_server ;;
    restart) restart_server ;;
    status)  show_status ;;
    logs)    show_logs ;;
    build)   build_site ;;
    clean)   clean ;;
    setup)   setup ;;
    reset)   reset_env ;;
    help|--help|-h) usage ;;
    *)
        print_msg $RED "Unknown command: ${1:-}"
        echo
        usage
        exit 1
        ;;
esac
