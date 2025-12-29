#!/usr/bin/env bats

# Test suite for init.sh bootstrap script
# Uses BATS (Bash Automated Testing System)

bats_require_minimum_version 1.5.0

# Path to the script under test
SCRIPT_PATH="${BATS_TEST_DIRNAME}/../init.sh"

setup() {
    # Create temporary directories for testing
    TEST_DIR="$(mktemp -d)"
    export TEST_DIR
    export HOME="$TEST_DIR/home"
    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.local/bin"

    # Create a mock dotfiles directory
    export DOTS_DIR="$TEST_DIR/dotfiles"
    mkdir -p "$DOTS_DIR"

    # Create mock bin directory for fake commands
    export MOCK_BIN="$TEST_DIR/mock_bin"
    mkdir -p "$MOCK_BIN"

    # Directory to capture command invocations
    export CMD_LOG="$TEST_DIR/cmd_log"
    mkdir -p "$CMD_LOG"

    # Source init.sh functions without running main script
    export INIT_SH_SOURCED=1
    # shellcheck source=../init.sh
    . "$SCRIPT_PATH"
}

teardown() {
    rm -rf "$TEST_DIR"
}

# Helper: create a mock command that logs its invocation
create_mock_cmd() {
    local cmd_name="$1"
    local exit_code="${2:-0}"
    cat > "$MOCK_BIN/$cmd_name" << EOF
#!/bin/sh
echo "\$0 \$*" >> "$CMD_LOG/${cmd_name}.log"
exit $exit_code
EOF
    chmod +x "$MOCK_BIN/$cmd_name"
}

# Helper: get logged invocations for a mock command
get_mock_calls() {
    local cmd_name="$1"
    cat "$CMD_LOG/${cmd_name}.log" 2>/dev/null || true
}

# ============================================================================
# Logging function tests
# ============================================================================

@test "plog outputs INFO level message" {
    run plog "test message"
    [ "$status" -eq 0 ]
    [ "$output" = "[INFO]	test message" ]
}

@test "pwarn outputs WARN level message" {
    run pwarn "warning message"
    [ "$status" -eq 0 ]
    [ "$output" = "[WARN]	warning message" ]
}

@test "perror outputs FAIL level message to stderr" {
    run perror "error message"
    [ "$status" -eq 0 ]
    # perror writes to stderr, which bats captures in output
    [ "$output" = "[FAIL]	error message" ]
}

@test "plog handles multiple arguments" {
    run plog "arg1" "arg2" "arg3"
    [ "$status" -eq 0 ]
    [ "$output" = "[INFO]	arg1 arg2 arg3" ]
}

@test "plog handles empty message" {
    run plog ""
    [ "$status" -eq 0 ]
    [ "$output" = "[INFO]	" ]
}

@test "pwarn handles special characters" {
    run pwarn "path/to/file with spaces"
    [ "$status" -eq 0 ]
    [ "$output" = "[WARN]	path/to/file with spaces" ]
}

@test "perror handles special characters" {
    run perror "Error: file 'test.txt' not found!"
    [ "$status" -eq 0 ]
    [ "$output" = "[FAIL]	Error: file 'test.txt' not found!" ]
}

# ============================================================================
# import() function tests
# ============================================================================

@test "import creates symlink for existing file" {
    mkdir -p "$DOTS_DIR/config"
    echo "test content" > "$DOTS_DIR/config/testfile"
    mkdir -p "$TEST_DIR/dest"

    run import "$DOTS_DIR/config" "$TEST_DIR/dest" "testfile"
    [ "$status" -eq 0 ]
    [ -L "$TEST_DIR/dest/testfile" ]
}

@test "import creates symlink for existing directory" {
    mkdir -p "$DOTS_DIR/nvim/lua"
    echo "config" > "$DOTS_DIR/nvim/lua/init.lua"
    mkdir -p "$TEST_DIR/dest"

    run import "$DOTS_DIR" "$TEST_DIR/dest" "nvim"
    [ "$status" -eq 0 ]
    [ -L "$TEST_DIR/dest/nvim" ]
}

@test "import fails when destination is not a directory" {
    mkdir -p "$DOTS_DIR"
    echo "test" > "$DOTS_DIR/testfile"

    # Create a file instead of directory as destination
    echo "not a dir" > "$TEST_DIR/notadir"

    run import "$DOTS_DIR" "$TEST_DIR/notadir" "testfile"
    [ "$status" -eq 1 ]
}

@test "import fails when destination does not exist" {
    mkdir -p "$DOTS_DIR"
    echo "test" > "$DOTS_DIR/testfile"

    run import "$DOTS_DIR" "$TEST_DIR/nonexistent" "testfile"
    [ "$status" -eq 1 ]
}

@test "import reports error for non-existent source item" {
    mkdir -p "$DOTS_DIR"
    mkdir -p "$TEST_DIR/dest"

    run import "$DOTS_DIR" "$TEST_DIR/dest" "nonexistent"
    [ "$status" -eq 0 ]  # Function doesn't fail, just logs error
    [[ "$output" == *"does not exist"* ]]
}

@test "import handles multiple items" {
    mkdir -p "$DOTS_DIR"
    echo "file1" > "$DOTS_DIR/file1"
    echo "file2" > "$DOTS_DIR/file2"
    echo "file3" > "$DOTS_DIR/file3"
    mkdir -p "$TEST_DIR/dest"

    run import "$DOTS_DIR" "$TEST_DIR/dest" "file1" "file2" "file3"
    [ "$status" -eq 0 ]
    [ -L "$TEST_DIR/dest/file1" ]
    [ -L "$TEST_DIR/dest/file2" ]
    [ -L "$TEST_DIR/dest/file3" ]
}

@test "import handles mix of existing and non-existing items" {
    mkdir -p "$DOTS_DIR"
    echo "exists" > "$DOTS_DIR/exists"
    mkdir -p "$TEST_DIR/dest"

    run import "$DOTS_DIR" "$TEST_DIR/dest" "exists" "missing"
    [ "$status" -eq 0 ]
    [ -L "$TEST_DIR/dest/exists" ]
    [ ! -e "$TEST_DIR/dest/missing" ]
    [[ "$output" == *"does not exist"* ]]
}

@test "import skips existing symlinks gracefully" {
    mkdir -p "$DOTS_DIR"
    echo "content" > "$DOTS_DIR/testfile"
    mkdir -p "$TEST_DIR/dest"

    # Create existing symlink
    ln -s "$DOTS_DIR/testfile" "$TEST_DIR/dest/testfile"

    run import "$DOTS_DIR" "$TEST_DIR/dest" "testfile"
    [ "$status" -eq 0 ]
    [ -L "$TEST_DIR/dest/testfile" ]
}

@test "import warns about conflicting regular file" {
    mkdir -p "$DOTS_DIR"
    echo "new content" > "$DOTS_DIR/testfile"
    mkdir -p "$TEST_DIR/dest"

    # Create existing regular file (conflict)
    echo "old content" > "$TEST_DIR/dest/testfile"

    # Without FORCE_OVERWRITE, rm -rfI requires interaction
    run import "$DOTS_DIR" "$TEST_DIR/dest" "testfile"
    [[ "$output" == *"Found conflicting config"* ]]
}

@test "import replaces conflicting file when FORCE_OVERWRITE is set" {
    mkdir -p "$DOTS_DIR"
    echo "new content" > "$DOTS_DIR/testfile"
    mkdir -p "$TEST_DIR/dest"

    # Create existing regular file (conflict)
    echo "old content" > "$TEST_DIR/dest/testfile"

    export FORCE_OVERWRITE=1
    run import "$DOTS_DIR" "$TEST_DIR/dest" "testfile"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Found conflicting config"* ]]
    [ -L "$TEST_DIR/dest/testfile" ]
    # Verify symlink points to the new source
    target="$(readlink "$TEST_DIR/dest/testfile")"
    [ "$target" = "$DOTS_DIR/testfile" ]
}

@test "import replaces conflicting directory when FORCE_OVERWRITE is set" {
    mkdir -p "$DOTS_DIR/nvim"
    echo "new" > "$DOTS_DIR/nvim/init.lua"
    mkdir -p "$TEST_DIR/dest"

    # Create existing directory (conflict)
    mkdir -p "$TEST_DIR/dest/nvim"
    echo "old" > "$TEST_DIR/dest/nvim/old.lua"

    export FORCE_OVERWRITE=1
    run import "$DOTS_DIR" "$TEST_DIR/dest" "nvim"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Found conflicting config"* ]]
    [ -L "$TEST_DIR/dest/nvim" ]
}

@test "import warns about conflicting directory" {
    mkdir -p "$DOTS_DIR/nvim"
    echo "new" > "$DOTS_DIR/nvim/init.lua"
    mkdir -p "$TEST_DIR/dest"

    # Create existing directory (conflict)
    mkdir -p "$TEST_DIR/dest/nvim"
    echo "old" > "$TEST_DIR/dest/nvim/old.lua"

    run import "$DOTS_DIR" "$TEST_DIR/dest" "nvim"
    [[ "$output" == *"Found conflicting config"* ]]
}

@test "import handles hidden files (dotfiles)" {
    mkdir -p "$DOTS_DIR"
    echo "dotfile content" > "$DOTS_DIR/.hidden"
    mkdir -p "$TEST_DIR/dest"

    run import "$DOTS_DIR" "$TEST_DIR/dest" ".hidden"
    [ "$status" -eq 0 ]
    [ -L "$TEST_DIR/dest/.hidden" ]
}

@test "import handles nested path item (e.g., BIN/script)" {
    mkdir -p "$DOTS_DIR/BIN"
    echo "#!/bin/sh" > "$DOTS_DIR/BIN/myscript"
    mkdir -p "$TEST_DIR/dest"

    run import "$DOTS_DIR" "$TEST_DIR/dest" "BIN/myscript"
    [ "$status" -eq 0 ]
    [ -L "$TEST_DIR/dest/myscript" ]
}

@test "import preserves symlink target correctly" {
    mkdir -p "$DOTS_DIR/nvim"
    echo "init" > "$DOTS_DIR/nvim/init.lua"
    mkdir -p "$HOME/.config"

    import "$DOTS_DIR" "$HOME/.config" nvim

    # Verify symlink points to correct location
    target="$(readlink "$HOME/.config/nvim")"
    [ "$target" = "$DOTS_DIR/nvim" ]
}

@test "import handles files with spaces in names" {
    mkdir -p "$DOTS_DIR"
    echo "content" > "$DOTS_DIR/file with spaces"
    mkdir -p "$TEST_DIR/dest"

    run import "$DOTS_DIR" "$TEST_DIR/dest" "file with spaces"
    [ "$status" -eq 0 ]
    [ -L "$TEST_DIR/dest/file with spaces" ]
}

@test "import handles empty item list" {
    mkdir -p "$DOTS_DIR"
    mkdir -p "$TEST_DIR/dest"

    run import "$DOTS_DIR" "$TEST_DIR/dest"
    [ "$status" -eq 0 ]
    [ -z "$output" ]
}

@test "import does not follow symlinks in source" {
    mkdir -p "$DOTS_DIR"
    echo "real" > "$DOTS_DIR/realfile"
    ln -s realfile "$DOTS_DIR/linkfile"
    mkdir -p "$TEST_DIR/dest"

    run import "$DOTS_DIR" "$TEST_DIR/dest" "linkfile"
    [ "$status" -eq 0 ]
    [ -L "$TEST_DIR/dest/linkfile" ]
    # The created symlink should point to the symlink in source, not the real file
    target="$(readlink "$TEST_DIR/dest/linkfile")"
    [ "$target" = "$DOTS_DIR/linkfile" ]
}

# ============================================================================
# update() function tests
# ============================================================================

@test "update returns failure for unknown package manager" {
    mkdir -p "$TEST_DIR/PACKAGES"
    echo "" > "$TEST_DIR/PACKAGES/unknown_pm"

    run update "$TEST_DIR/PACKAGES/unknown_pm"
    [ "$status" -eq 1 ]
}

@test "update calls pacman with correct arguments" {
    create_mock_cmd "sudo"
    export PATH="$MOCK_BIN:$PATH"

    mkdir -p "$TEST_DIR/PACKAGES"
    echo "" > "$TEST_DIR/PACKAGES/pacman"

    run update "$TEST_DIR/PACKAGES/pacman"
    [ "$status" -eq 0 ]

    calls="$(get_mock_calls sudo)"
    [[ "$calls" == *"pacman -Syu --noconfirm"* ]]
}

@test "update calls yay with correct arguments" {
    create_mock_cmd "sudo"
    export PATH="$MOCK_BIN:$PATH"

    mkdir -p "$TEST_DIR/PACKAGES"
    echo "" > "$TEST_DIR/PACKAGES/yay"

    run update "$TEST_DIR/PACKAGES/yay"
    [ "$status" -eq 0 ]

    calls="$(get_mock_calls sudo)"
    [[ "$calls" == *"pacman -Syu --noconfirm"* ]]
}

@test "update calls dnf with correct arguments" {
    create_mock_cmd "sudo"
    export PATH="$MOCK_BIN:$PATH"

    mkdir -p "$TEST_DIR/PACKAGES"
    echo "" > "$TEST_DIR/PACKAGES/dnf"

    run update "$TEST_DIR/PACKAGES/dnf"
    [ "$status" -eq 0 ]

    calls="$(get_mock_calls sudo)"
    [[ "$calls" == *"dnf upgrade -y"* ]]
}

@test "update calls zypper with correct arguments" {
    create_mock_cmd "sudo"
    export PATH="$MOCK_BIN:$PATH"

    mkdir -p "$TEST_DIR/PACKAGES"
    echo "" > "$TEST_DIR/PACKAGES/zypper"

    run update "$TEST_DIR/PACKAGES/zypper"
    [ "$status" -eq 0 ]

    calls="$(get_mock_calls sudo)"
    [[ "$calls" == *"zypper dup -y"* ]]
}

@test "update calls apt-get with correct arguments" {
    create_mock_cmd "sudo"
    create_mock_cmd "apt-get"
    export PATH="$MOCK_BIN:$PATH"

    mkdir -p "$TEST_DIR/PACKAGES"
    echo "" > "$TEST_DIR/PACKAGES/apt-get"

    run update "$TEST_DIR/PACKAGES/apt-get"
    [ "$status" -eq 0 ]

    calls="$(get_mock_calls sudo)"
    [[ "$calls" == *"apt-get update -y"* ]]
}

@test "update propagates failure from package manager" {
    create_mock_cmd "sudo" 1  # Make sudo fail
    export PATH="$MOCK_BIN:$PATH"

    mkdir -p "$TEST_DIR/PACKAGES"
    echo "" > "$TEST_DIR/PACKAGES/dnf"

    run update "$TEST_DIR/PACKAGES/dnf"
    [ "$status" -eq 1 ]
}

# ============================================================================
# install() function tests
# ============================================================================

@test "install calls pacman with correct install command" {
    create_mock_cmd "sudo"
    create_mock_cmd "xargs"
    export PATH="$MOCK_BIN:$PATH"

    mkdir -p "$TEST_DIR/PACKAGES"
    printf "vim\ngit\n" > "$TEST_DIR/PACKAGES/pacman"

    run install "$TEST_DIR/PACKAGES/pacman"

    calls="$(get_mock_calls xargs)"
    [[ "$calls" == *"sudo pacman -S --needed"* ]]
}

@test "install calls yay with correct install command" {
    create_mock_cmd "sudo"
    create_mock_cmd "xargs"
    export PATH="$MOCK_BIN:$PATH"

    mkdir -p "$TEST_DIR/PACKAGES"
    printf "vim\ngit\n" > "$TEST_DIR/PACKAGES/yay"

    run install "$TEST_DIR/PACKAGES/yay"

    calls="$(get_mock_calls xargs)"
    [[ "$calls" == *"sudo yay -S --needed"* ]]
}

@test "install calls dnf with correct install command and weak deps flag" {
    create_mock_cmd "sudo"
    create_mock_cmd "xargs"
    export PATH="$MOCK_BIN:$PATH"

    mkdir -p "$TEST_DIR/PACKAGES"
    printf "vim\ngit\n" > "$TEST_DIR/PACKAGES/dnf"

    run install "$TEST_DIR/PACKAGES/dnf"

    calls="$(get_mock_calls xargs)"
    [[ "$calls" == *"sudo dnf install --setopt=install_weak_deps=False"* ]]
}

@test "install calls zypper with correct install command and weak deps flag" {
    create_mock_cmd "sudo"
    create_mock_cmd "xargs"
    export PATH="$MOCK_BIN:$PATH"

    mkdir -p "$TEST_DIR/PACKAGES"
    printf "vim\ngit\n" > "$TEST_DIR/PACKAGES/zypper"

    run install "$TEST_DIR/PACKAGES/zypper"

    calls="$(get_mock_calls xargs)"
    [[ "$calls" == *"sudo zypper install --no-recommends"* ]]
}

@test "install calls apt-get with correct install command and weak deps flag" {
    create_mock_cmd "sudo"
    create_mock_cmd "xargs"
    export PATH="$MOCK_BIN:$PATH"

    mkdir -p "$TEST_DIR/PACKAGES"
    printf "vim\ngit\n" > "$TEST_DIR/PACKAGES/apt-get"

    run install "$TEST_DIR/PACKAGES/apt-get"

    calls="$(get_mock_calls xargs)"
    [[ "$calls" == *"sudo apt-get install --no-install-recommends"* ]]
}

@test "install reads packages from config file" {
    # Create a wrapper that captures stdin
    cat > "$MOCK_BIN/xargs" << 'EOF'
#!/bin/sh
cat > "$CMD_LOG/xargs_stdin.log"
echo "$0 $*" >> "$CMD_LOG/xargs.log"
EOF
    chmod +x "$MOCK_BIN/xargs"
    create_mock_cmd "sudo"
    export PATH="$MOCK_BIN:$PATH"

    mkdir -p "$TEST_DIR/PACKAGES"
    printf "vim\ngit\ntmux\n" > "$TEST_DIR/PACKAGES/dnf"

    run install "$TEST_DIR/PACKAGES/dnf"

    stdin_content="$(cat "$CMD_LOG/xargs_stdin.log")"
    [[ "$stdin_content" == *"vim"* ]]
    [[ "$stdin_content" == *"git"* ]]
    [[ "$stdin_content" == *"tmux"* ]]
}

@test "install handles empty package file" {
    create_mock_cmd "sudo"
    create_mock_cmd "xargs"
    export PATH="$MOCK_BIN:$PATH"

    mkdir -p "$TEST_DIR/PACKAGES"
    : > "$TEST_DIR/PACKAGES/dnf"  # Create empty file

    run install "$TEST_DIR/PACKAGES/dnf"
    [ "$status" -eq 0 ]
}

@test "install propagates failure from xargs/package manager" {
    create_mock_cmd "sudo"
    create_mock_cmd "xargs" 1  # Make xargs fail
    export PATH="$MOCK_BIN:$PATH"

    mkdir -p "$TEST_DIR/PACKAGES"
    printf "vim\n" > "$TEST_DIR/PACKAGES/dnf"

    run install "$TEST_DIR/PACKAGES/dnf"
    [ "$status" -eq 1 ]
}

@test "install handles packages with special characters in names" {
    cat > "$MOCK_BIN/xargs" << 'EOF'
#!/bin/sh
cat > "$CMD_LOG/xargs_stdin.log"
echo "$0 $*" >> "$CMD_LOG/xargs.log"
EOF
    chmod +x "$MOCK_BIN/xargs"
    create_mock_cmd "sudo"
    export PATH="$MOCK_BIN:$PATH"

    mkdir -p "$TEST_DIR/PACKAGES"
    printf "gcc-c++\nlibstdc++-devel\npython3.11\n" > "$TEST_DIR/PACKAGES/dnf"

    run install "$TEST_DIR/PACKAGES/dnf"

    stdin_content="$(cat "$CMD_LOG/xargs_stdin.log")"
    [[ "$stdin_content" == *"gcc-c++"* ]]
    [[ "$stdin_content" == *"python3.11"* ]]
}

# ============================================================================
# Script structure and syntax tests
# ============================================================================

@test "init.sh has valid shell syntax" {
    run bash -n "$SCRIPT_PATH"
    [ "$status" -eq 0 ]
}

@test "init.sh uses strict mode (set -e -u)" {
    head -5 "$SCRIPT_PATH" | grep -q "set -e -u"
}

@test "init.sh can be sourced without executing main body" {
    export INIT_SH_SOURCED=1
    run bash -c '. "'"$SCRIPT_PATH"'"; echo "sourced ok"'
    [ "$status" -eq 0 ]
    [[ "$output" == *"sourced ok"* ]]
}

@test "functions are available after sourcing" {
    export INIT_SH_SOURCED=1
    run bash -c '. "'"$SCRIPT_PATH"'"; type plog'
    [ "$status" -eq 0 ]
    [[ "$output" == *"function"* ]]
}

# ============================================================================
# Integration tests
# ============================================================================

@test "full import workflow for config files" {
    # Setup a realistic dotfiles structure
    mkdir -p "$DOTS_DIR/nvim/lua"
    mkdir -p "$DOTS_DIR/tmux"
    mkdir -p "$DOTS_DIR/zsh"
    echo "nvim config" > "$DOTS_DIR/nvim/init.lua"
    echo "tmux config" > "$DOTS_DIR/tmux/tmux.conf"
    echo "zsh config" > "$DOTS_DIR/zsh/.zshrc"
    echo "p10k config" > "$DOTS_DIR/.p10k.zsh"

    # Run imports like the real script does
    import "$DOTS_DIR" "$HOME/.config" nvim tmux zsh
    import "$DOTS_DIR" "$HOME" .p10k.zsh

    # Verify all symlinks were created
    [ -L "$HOME/.config/nvim" ]
    [ -L "$HOME/.config/tmux" ]
    [ -L "$HOME/.config/zsh" ]
    [ -L "$HOME/.p10k.zsh" ]
}

@test "full import workflow handles missing items gracefully" {
    mkdir -p "$DOTS_DIR/nvim"
    echo "nvim config" > "$DOTS_DIR/nvim/init.lua"
    # Deliberately not creating tmux dir

    run bash -c '
        export INIT_SH_SOURCED=1
        . "'"$SCRIPT_PATH"'"
        import "'"$DOTS_DIR"'" "'"$HOME/.config"'" nvim tmux
    '

    [ -L "$HOME/.config/nvim" ]
    [ ! -e "$HOME/.config/tmux" ]
    [[ "$output" == *"does not exist"* ]]
}

@test "install and update work together for same package manager" {
    create_mock_cmd "sudo"
    create_mock_cmd "xargs"
    export PATH="$MOCK_BIN:$PATH"

    mkdir -p "$TEST_DIR/PACKAGES"
    printf "vim\ngit\n" > "$TEST_DIR/PACKAGES/dnf"

    # Simulate what the main script does
    update "$TEST_DIR/PACKAGES/dnf"
    install "$TEST_DIR/PACKAGES/dnf"

    sudo_calls="$(get_mock_calls sudo)"
    xargs_calls="$(get_mock_calls xargs)"

    # Verify update was called
    [[ "$sudo_calls" == *"dnf upgrade -y"* ]]
    # Verify install was called
    [[ "$xargs_calls" == *"sudo dnf install"* ]]
}
