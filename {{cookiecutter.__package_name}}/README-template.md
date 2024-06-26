{{ cookiecutter.package_name }}
============================================================================================

[------------------------------------ BADGES: BEGIN ------------------------------------]: #

<table>{% if cookiecutter.enable_github_pages == "yes" %}
  <tr>
    <td>Documentation</td>
    <td>
      <a href="https://{{ cookiecutter.github_repo_owner }}.github.io/{{ cookiecutter.__package_name }}.jl/dev/"><img style="vertical-align: bottom;" src="https://img.shields.io/badge/docs-dev-blue.svg"/></a>
      <a href="https://{{ cookiecutter.github_repo_owner }}.github.io/{{ cookiecutter.__package_name }}.jl/stable/"><img style="vertical-align: bottom;" src="https://img.shields.io/badge/docs-stable-blue.svg"/></a>
    </td>
  </tr>
{% endif %}
  <tr>
    <td>Build Status</td>
    <td>
      <a href="https://github.com/{{ cookiecutter.github_repo_owner }}/{{ cookiecutter.__package_name }}.jl/actions/workflows/CI.yml"><img style="vertical-align: bottom;" src="https://github.com/{{ cookiecutter.github_repo_owner }}/{{ cookiecutter.__package_name }}.jl/actions/workflows/CI.yml/badge.svg"/></a>{% if cookiecutter.ci_include_codecov == "yes" %}
      <a href="https://codecov.io/gh/{{ cookiecutter.github_repo_owner }}/{{ cookiecutter.__package_name }}.jl">
        <img style="vertical-align: bottom;" src="https://codecov.io/gh/{{ cookiecutter.github_repo_owner }}/{{ cookiecutter.__package_name }}.jl/graph/badge.svg"/></a>{% endif %}
    </td>
  </tr>

  <!-- Miscellaneous Badges -->
  <tr>
    <td colspan=2 align="center">
      <a href="https://github.com/{{ cookiecutter.github_repo_owner }}/{{ cookiecutter.__package_name }}.jl/issues"><img style="vertical-align: bottom;" src="https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat"/></a>
      <a href="https://github.com/invenia/BlueStyle"><img style="vertical-align: bottom;" src="https://img.shields.io/badge/code%20style-blue-4495d1.svg"/></a>
    </td>
  </tr>
</table>

[------------------------------------- BADGES: END -------------------------------------]: #

--------------------------------------------------------------------------------------------

A brief description of the package.

The {{ cookiecutter.package_name }} package features:

* a list of the core features of the package.

--------------------------------------------------------------------------------------------

Table of Contents
-----------------

1. [Overview][#1]

2. [Getting Started][#2]

   2.1. [Installation][#2.1]

   2.2. [Examples][#2.2]

3. [Known Issues][#3]

4. [Contributor Notes][#4]

   4.1. [License][#4.1]

   4.2. [Package Contents][#4.2]

   4.3. [Setting Up a Development Environment][#4.3]

   4.4. [Running Automated Tests][#4.4]

   4.5. [Cleaning the Development Directory][#4.5]

--------------------------------------------------------------------------------------------

## 1. Overview

A more detailed description of the package.

--------------------------------------------------------------------------------------------

## 2. Getting Started

### 2.1. Installation

Instructions for adding a local registry that the Julia package is registered with

* Add the XYZ Julia package registry.

  ```julia
  julia>  # Press ']' to enter the Pkg REPL mode.
  pkg> registry add https://github.com/{{ cookiecutter.github_repo_owner }}/JuliaRegistry.git
  ```

  ___Notes___

  * `{{ cookiecutter.__package_name }}` is registered with the XYZ Julia package registry
    (not the General Julia package registry), so the Pkg REPL will be able to find
    `{{ cookiecutter.__package_name }}` only if the XYZ Julia package registry has been
    added to your Julia installation. For more information about local registries for Julia
    packages, [LocalRegistry.jl](https://github.com/GunnarFarneback/LocalRegistry.jl).


  * This step only needs to be performed once per Julia installation.

* Install the `{{ cookiecutter.__package_name }}` package via the Pkg REPL. That's it!

  ```julia
  julia>  # Press ']' to enter the Pkg REPL mode.
  pkg> add {{ cookiecutter.__package_name }}
  ```

### 2.2. Examples

Some examples of code that uses the package.

--------------------------------------------------------------------------------------------

## 3. Known Issues

Known issues for the package.

--------------------------------------------------------------------------------------------

## 4. Contributor Notes

### 4.1. License
{% if cookiecutter.license == "ASL" %}
The contents of this package are covered under the Apache License 2.0 (included
in the `LICENSE` file). The copyright for this package is contained in the
`NOTICE` file.
{% else %}
The contents of this package are covered under the license contained in the
`LICENSE` file.
{% endif %}
### 4.2. Package Contents

```
├── README.md          <- this file
├── NEWS.md            <- package release notes
├── LICENSE            <- package license
├{% if cookiecutter.license == "ASL" %}── NOTICE             <- package copyright notice
├{% endif %}── Makefile           <- Makefile containing useful shortcuts (`make` rules).
│                         Use `make help` to show the list of available rules.
├── Project.toml       <- Julia package metadata file
├── Manifest.toml      <- Julia environment manifest file
├── pyproject.toml     <- Python dependency and configuration file
├── poetry.lock        <- Poetry lockfile
├── docs/              <- package documentation
├── extras/            <- additional files and references that may be useful
│                         for package development
├── spikes/            <- experimental code snippets, etc.
├── src/               <- package source code
└── tests/             <- package test code
```

### 4.3. Setting Up a Development Environment

___Note___: this project uses `poetry` to manage Python package dependencies.

1. Prerequisites

   * Install [Git][git].

   * Install [Python][python] 3.8 (or greater).

   * Install [Poetry][poetry] 1.2 (or greater).

   * _Optional_. Install [direnv][direnv].

2. ___Recommended___. Set up a dedicated virtual environment for the package
   development using `direnv` (because manages the environment for both the
   shell and Python).

   * Prerequisite. Install `direnv`.

   * Copy `extras/dot-envrc` to the package root directory, and rename it to
     `.envrc`.

     ```shell
     $ cd $PROJECT_ROOT_DIR
     $ cp extras/dot-envrc .envrc
     ```

   * Grant permission to direnv to execute the .envrc file.

     ```shell
     $ direnv allow
     ```

3. Install the Python package dependencies required for development.

   ```shell
   $ poetry install --no-root
   ```

4. Install the Git pre-commit hooks.

   ```shell
   $ pre-commit install
   ```

### 4.4. Running Automated Tests

This package is configured to support (1) automated testing of code located in
the `src` directory and (2) analysis of how well the tests cover of the source
code (i.e., coverage analysis).

* Run all of the tests.

  ```shell
  $ make test
  ```

* Run all of the tests in fail-fast mode (i.e., stop after the first failing
  test).

  ```shell
  $ make fast-test
  ```

### 4.5. Cleaning the Development Directory

* Use `make clean` to automatically remove temporary files and directories
  generated during testing (e.g., temporary directories, coverage files).

  ```shell
  $ make clean
  ```

--------------------------------------------------------------------------------------------

[------------------------------------ INTERNAL LINKS -----------------------------------]: #

[#1]: #1-overview

[#2]: #2-getting-started
[#2.1]: #21-installation
[#2.2]: #22-examples

[#3]: #3-known-issues

[#4]: #4-contributor-notes
[#4.1]: #41-license
[#4.2]: #42-package-contents
[#4.3]: #43-setting-up-a-development-environment
[#4.4]: #44-running-automated-tests
[#4.5]: #45-cleaning-the-development-directory

[----------------------------------- REPOSITORY LINKS ----------------------------------]: #

[------------------------------------ EXTERNAL LINKS -----------------------------------]: #

[direnv]: https://direnv.net/

[git]: https://git-scm.com/

[python]: https://www.python.org/

[poetry]: https://python-poetry.org/
