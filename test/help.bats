#!/usr/bin/env bats

# Test suite for git-sandbox help commands using BATS

# Load BATS assertion libraries from system path (installed via apt)
load '/usr/lib/bats/bats-support/load.bash'
load '/usr/lib/bats/bats-assert/load.bash'

# Assuming git-sandbox is in the PATH or adjust as needed
setup() {
  # Add the directory containing git-sandbox (one level up from test dir) to PATH
  # BATS_TEST_DIRNAME is the directory containing the .bats file
  local script_dir="${BATS_TEST_DIRNAME}/.."
  export PATH="${script_dir}:$PATH"

  # Optional: Check if the script is executable
  local script_path="${script_dir}/git-sandbox"
  if [ ! -x "$script_path" ]; then
      echo "Error: git-sandbox script not found or not executable at '$script_path'" >&2
      return 1 # Fail setup
  fi
}

@test "main command --help shows usage" {
  run git-sandbox --help
  assert_success
  assert_output --partial "Usage: git-sandbox <subcommand>"
}

@test "create subcommand --help shows usage" {
  run git-sandbox create --help
  assert_success
  assert_output --partial "Usage: git sandbox create"
}

@test "promote subcommand --help shows usage" {
  run git-sandbox promote --help
  assert_success
  assert_output --partial "Usage: git sandbox promote"
}

@test "rebase subcommand --help shows usage" {
  run git-sandbox rebase --help
  assert_success
  assert_output --partial "Usage: git sandbox rebase"
}

@test "tree subcommand --help shows usage" {
  run git-sandbox tree --help
  assert_success
  assert_output --partial "Usage: git sandbox tree"
}

# --- Tests for invalid options ---

@test "main command with invalid global option fails" {
  run git-sandbox --foo
  assert_failure # Expect non-zero exit status
  assert_output --partial "Unknown global option: --foo"
}

@test "create subcommand with invalid option fails" {
  run git-sandbox create mybranch --foo
  assert_failure
  assert_output --partial "Invalid option for 'git sandbox create': --foo"
}

@test "promote subcommand with invalid option fails" {
  run git-sandbox promote --foo
  assert_failure
  assert_output --partial "Invalid option for 'git sandbox promote': --foo"
}

@test "rebase subcommand with invalid option fails" {
  run git-sandbox rebase --foo
  assert_failure
  assert_output --partial "Invalid option for 'git sandbox rebase': --foo"
}

@test "tree subcommand with invalid option fails" {
  run git-sandbox tree --foo
  assert_failure
  assert_output --partial "Invalid option for 'git sandbox tree': --foo"
}
