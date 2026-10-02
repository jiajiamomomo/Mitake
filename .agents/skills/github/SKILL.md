---
name: github
description: GitHub and Git version control workflow manager. Guides git initialization, commit messaging, branching strategies, .gitignore management, and GitHub repository synchronization.
---

# GitHub & Git Version Control Skill

This skill provides rules, commands, and best practices for managing version control using Git and GitHub in this project.

## 1. Version Control Guidelines

### Git Repository Setup
- Initialize repository with `git init -b main`.
- Always maintain a clean `.gitignore` file to avoid tracking runtime logs, exports, or secret configs.

### Commit Conventions (Conventional Commits)
Write clean, explicit commit messages following these prefixes:
- `feat:` New features or functionality (e.g., `feat: add screen resolution check module`)
- `fix:` Bug fixes (e.g., `fix: resolve window title matching issue`)
- `docs:` Documentation updates (e.g., `docs: update AGENTS.md workflow`)
- `test:` Unit tests or test runner updates (e.g., `test: add window_control unit tests`)
- `refactor:` Code restructuring without functional changes
- `style:` Formatting or whitespace changes
- `chore:` Maintenance, build, or configuration updates

### Branch Strategy
- `main` / `master`: Production-ready code.
- `feature/<feature-name>`: Development of new capabilities.
- `fix/<bug-name>`: Bug fixes.

## 2. GitHub Remote Workflow

### Setting up Remote
```bash
# Link local repository to remote GitHub repository
git remote add origin https://github.com/<username>/<repository-name>.git
git branch -M main
git push -u origin main
```

### Daily Workflow
1. Check repository status: `git status`
2. View changed files: `git diff`
3. Stage changes: `git add .` (or specific files)
4. Commit with descriptive message: `git commit -m "feat: description"`
5. Sync with remote: `git pull --rebase origin main` and `git push`

## 3. Recommended Exclusions (.gitignore)
Ensure the following patterns are excluded:
- Logs: `logs/*.log`
- Generated Exports: `熱門排行/*`, `盤後排行/*` (except `.gitkeep` if directory preservation is desired)
- Local Environment / Temporary files: `*.tmp`, `*.bak`, `.vs/`, `.vscode/`
