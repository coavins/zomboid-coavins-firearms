# How to contribute

Thank you for your interest in contributing to this project. Everyone is invited to propose changes, fixes, and new features through pull requests in this repository. The following guidelines are intended to enforce good standards and keep the commit history clean and readable.

## Testing

We use [luacheck](https://github.com/lunarmodules/luacheck) for linting. GitHub automatically runs this check when you open a pull request.
If you wish, you can lint your changes yourself before pushing by running `luacheck src` in the repository root.

## Creating a Pull Request

Please create a pull request targeting the `develop` branch with a clear explanation of what you've done (read more about pull requests [here](http://help.github.com/pull-requests/).)

You should create a new branch for each pull request, and rebase/squash it into as few logical commits as possible.

## Commit guidelines

This repository generally adheres to the "[Conventional Commit](https://gist.github.com/qoomon/5dfcdf8eec66a051ecd85625518cfd13)" standards for commit messages to automate various steps i the build process:

- Format: `<type>(<scope>): <description>`
- Examples:
  - **New Model:** `feat(model): implement password recovery`
  - **Bug Fix:** `fix(validation): address input validation edge case`
  - **Chore:** `chore(docs): update contribution guidelines`


Your commits will be expected to meet these standards before your PR will be merged.
