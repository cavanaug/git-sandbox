# git-sandbox

A Git command-line extension to facilitate managing temporary local "sandbox" branches for isolated experimentation and development tasks, inspired by workflows like GitHub Flow.

## Problem Solved

Often during development, you might want to:
*   Try out a quick idea or fix without committing directly to your main feature branch.
*   Experiment with code that you might discard later.
*   Keep your feature branches clean from exploratory commits.

`git-sandbox` helps by providing a simple workflow for creating, managing, and integrating these temporary sandbox branches.

## Features

*   **Start Sandbox Branches:** Easily start `sandbox/<name>` branches based on your current branch or a specified base.
*   **Isolate Changes:** Work within a sandbox without affecting your main feature branches.
*   **Publish Changes:** Squash-merge your sandbox work into its base branch (or another target branch) when ready.
*   **Keep Sandboxes Updated:** Rebase sandboxes easily from their base branch.
*   **Visualize:** View a tree structure of your local branches, clearly showing sandbox relationships.
*   **Clean Up:** Sandbox branches can be automatically deleted after publishing using `publish --complete`.
*   **Bash Completion:** Includes support for bash command-line completion.

## Installation

1.  **Download:** Get the `git-sandbox` script.
2.  **Place in PATH:** Copy the `git-sandbox` script to a directory included in your system's `PATH` (e.g., `~/bin`, `/usr/local/bin`).
3.  **Make Executable:** Ensure the script has execute permissions:
    ```bash
    chmod +x /path/to/your/bin/git-sandbox
    ```

Now you can run the tool using `git sandbox <subcommand>`.

## Usage

### Global Options

These options must be placed *before* the subcommand:

*   `--dry-run`: Show what commands would be run without executing them.
*   `--quiet`: Suppress informational output.
*   `--no-color`: Disable colored output.
*   `--yes` / `--force`: Assume 'yes' to any prompts (useful for scripting).
*   `-v` / `--verbose`: Show verbose output (currently used by `tree`).

### Commands

#### `start <branch> [<base>]`

Starts a new sandbox branch named `sandbox/<branch>`.

*   `<branch>`: The name for your sandbox (e.g., `try-new-widget`).
*   `<base>` (Optional): The branch to base the sandbox on. Defaults to the current branch, or the primary branch (`main`) if on a detached HEAD or another sandbox.

```bash
# Start sandbox 'try-fix' based on the current branch
git sandbox start try-fix

# Start sandbox 'experiment' based on the 'develop' branch
git sandbox start experiment develop
```

The base branch is stored in the git config `branch.sandbox/<branch>.sandbox-base`.

#### `publish [<dst>] [-c|--complete]`

Squash-merges the *current* sandbox branch into a destination branch, effectively "publishing" the sandbox changes.

*   `<dst>` (Optional): The destination branch to merge into. Defaults to the sandbox's configured base branch.
*   `-c`, `--complete`: Deletes the sandbox branch after a successful publish.

**Workflow:**
1.  Checks if the sandbox is behind its base (requires `rebase` first if it is).
2.  Performs a `git reset --soft` on the sandbox branch back to its base (or last merge from base).
3.  Creates a single squash commit on the sandbox branch (prompts for message if in a TTY).
4.  Checks out the destination branch.
5.  Merges the (now squashed) sandbox branch into the destination using `--no-ff`.
6.  If `--complete` is used, deletes the sandbox branch.
7.  If `--complete` is *not* used, checks back out the sandbox branch and rebases it from its base.

```bash
# Assuming currently on sandbox/try-fix
# Publish changes to its base branch
git sandbox publish

# Publish changes to the 'staging' branch and delete sandbox/try-fix afterwards
git sandbox publish staging --complete
```

#### `rebase`

Updates the *current* sandbox branch by rebasing it onto its configured base branch.

```bash
# Assuming currently on sandbox/try-fix
git sandbox rebase
```

#### `tree [--simple]`

Displays a tree view of your local branches, highlighting sandbox relationships and the current branch (`*`). By default, it shows ahead/behind commit counts relative to the parent/upstream branch.

*   `--simple`: Shows a simplified tree without the ahead/behind commit counts.

```bash
# Show verbose tree (default)
git sandbox tree

# Show simplified tree
git sandbox tree --simple
```

Example Output (default verbose `tree`):

```
* main [⇡1, 0 behind] <-> origin/main
  ├── feature/new-login [⇡2, 0 behind] <-> origin/feature/new-login
  │   └── sandbox/refactor-auth [⇡1, 0 behind]
  └── sandbox/quick-test [current]
```

#### `completion`

Prints the bash completion script. To enable completion:

```bash
source <(git sandbox completion)
# Or add it to your .bashrc or .bash_profile
# git sandbox completion >> ~/.bash_completion
# source ~/.bash_completion
```

#### `--help`

Shows the main help message summarizing commands and global options. You can also use `--help` after a subcommand (e.g., `git sandbox start --help`) for specific help.

## Configuration

`git-sandbox` uses Git configuration to store the relationship between a sandbox branch and its base:

*   `branch.sandbox/<branch-name>.sandbox-base`: Stores the name of the base branch.

This is set automatically when using `git sandbox start` and used by `publish` and `rebase`.

## Contributing

Contributions are welcome! Please feel free to open an issue or submit a pull request.

## License

This project is licensed under the terms of the [LICENSE](LICENSE) file.
