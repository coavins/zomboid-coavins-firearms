# How to contribute

Thank you for your interest in contributing to this project. Everyone is invited to propose changes, fixes, and new features through pull requests in this repository. The following guidelines are intended to enforce good standards and keep the commit history clean and readable.

## Testing

We use [luacheck](https://github.com/lunarmodules/luacheck) for linting. GitHub automatically runs this check when you open a pull request.
If you wish, you can lint your changes yourself before pushing by running `luacheck src` in the repository root.

## Creating a Pull Request

Please create a pull request targeting the `develop` branch with a clear explanation of what you've done (read more about pull requests [here](http://help.github.com/pull-requests/).)

You should create a new branch for each pull request, and rebase/squash it into as few logical commits as possible.

This repository generally follows the [Chris Beams standards](https://cbea.ms/git-commit/) for commit messages:

    Separate subject from body with a blank line
    Limit the subject line to 50 characters
    Capitalize the subject line
    Use the imperative mood in the subject line
    Do not end the subject line with a period
    Use the body to explain what and why vs. how
    Wrap the body at 72 characters

Your commits will be expected to meet these standards before your PR will be merged.
