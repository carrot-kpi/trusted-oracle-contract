# Contributing

The contract is developed using Foundry, so in order to contribute you need to
first install Foundry locally. Check out [this link](https://getfoundry.sh/) to
easily install Foundry on your machine. Make sure you periodically update
Foundry to the latest version.

Foundry manages dependencies using git submodules, so it's advised to use
`git clone --recurse-submodules` when cloning the repo in order to have a
ready-to-go environment. If `git clone` was used without the
`--recurse-submodules` flag, you can just run
`git submodule update --init --recursive` in the cloned repo in order to easily
install the dependencies.

After having done the above, the environment should be ready to work with.

## Testing

Tests are written in Solidity and you can find them in the `test` folder. Both
property-based fuzzing and standard unit tests are easily supported through the
use of Foundry.

In order to launch tests you can both use Forge commands directly or pnpm
scripts. For example, these are the available pnpm scripts:

- `test`: self explanatory, simply runs the tests.
- `test:gasreport`: runs the tests giving out a gas consumption report at the
  end.
- `test:coverage`: runs the tests giving out a coverage report at the end.

## Github Actions

The repository uses GH actions to setup CI to automatically run all the
available tests on each push.

## Pre-commit hooks

In order to reduce the ability to make mistakes to the minimum, pre-commit hooks
are enabled to both run all the available tests (through the same command used
in the GH actions) and to lint the commit message through `husky` and
`@commitlint/config-conventional`. Please have a look at the supported formats
by checking
[this](https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-conventional)
out.
