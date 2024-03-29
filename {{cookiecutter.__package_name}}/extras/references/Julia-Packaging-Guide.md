Julia Packaging Guide: Development, Registration, and Release Process
=====================================================================

__Authors__  
Kevin T. Chu `<kevin@velexi.com>`

--------------------------------------------------------------------------------------------

Table of Contents
-----------------

1. [Package Development][#1]

2. [Hosting Documentation on GitHub Pages][#2]

3. [Package Registration][#3]

4. [Package Release Process][#4]

5. [Additional Notes][#5]

6. [References][#6]

7. [Acknowledgements][#7]

--------------------------------------------------------------------------------------------

## 1. Package Development

The following steps set up Julia package configured for collaboration (via GitHub),
documentation generation, continuous integration (CI), and coverage reporting.

### Steps

* Use `cookiecutter` to create a new Julia package.

  ```shell
  $ cookiecutter https://github.com/velexi-research/VLXI-Cookiecutter-Julia.git
  ```

  _Note_: the cookiecutter uses the `PkgTemplates` package to automatically generate a new
  Julia package with the standard directory layout.

* Develop the package.

* Write documentation for the package in a format that is compatible with the `Documenter`
  package.

  * By convention, package documentation resides in the `docs/` directory.

  * Update the arguments to `makedocs()` in `docs/make.jl`.

    * Remove the `repo` keyword argument.

    * Add the `repolink` keyword argument to the `Documenter.HTML()` constructor to set the
      URL to the GitHub repository for the project.

    _Example_
    ```julia
    makedocs(;
        modules=[PackageName],
        authors="Your Name <your-name@example.com> and contributors",
        sitename="PackageName.jl",
        format=Documenter.HTML(;
            prettyurls=get(ENV, "CI", "false") == "true",
            canonical="https://your-name.github.io/PackageName.jl",
            repolink="https://github.com/your-name/PackageName.jl",
            edit_link="main",
            assets=String[],
        ),
        pages=[
            "Home" => "index.md",
        ],
    )
    ```

* Set up a GitHub repository for the package.

  * __Recommended Settings__

    * Default branch: `main`

    * Branch protection rules for `main`

      * Require a pull before merging: `yes`

        * Require approvals:

          * `yes` for projects that have enough active developers who can serve as reviewers

          * `no` for projects with a single developer or too few active developers who can
            serve as reviewers

      * Include administrators: `yes`

  * Set up continuous integration (CI).

    * Add a GitHub Action CI workflow to the GitHub repository.

      * __Recommendation__. Replace the default `CI.yml` generated by `PkgTemplates` with a
        version based on `CI.yml.template` (located in the `templates/` directory). The
        template version contains improvements for document generation, optimization of
        code coverage processing, etc.

    * (OPTIONAL) Configure Codecov.

      * _Prerequisites_
        * Sign up for a Codecov account.
        * Allow third-party application access in GitHub.

      * Set up a Codecov repository (from the Codecov website).

      * In the `codecov` task of the `test` job in `CI.yml`, set the Codecov upload token.

  * (OPTIONAL) Configure `TagBot.yml` to use GPG (so that GitHub releases generated by
    `TagBot` are marked as "verified").

    * Export the GPG key (Base64-encoded).

      ```shell
      $ gpg --export-secret-keys --armor <KEY_ID>
      ```

    * Add the GPG credentials to the GitHub secrets for the repository (or organization).

      * _Private Key_
        * Key: GPG_KEY
        * Value: Base64-encoded GPG secret key

      * _GPG Passphrase_
        * Key: GPG_PASSWORD
        * Value: GPG passphrase

    * Add the GPG configuration to `TagBot.yml`.

      <!-- {% raw %} -->
      ```
      with:
          gpg: ${{ secrets.GPG_KEY }}
          gpg_password: ${{ secrets.GPG_PASSWORD }}
      ```
      <!-- {% endraw %} -->

--------------------------------------------------------------------------------------------

## 2. Hosting Documentation on GitHub Pages

The following steps set up automatic build and deployment of package documentation as
part of the continuous integration and release processes.

### Prerequisite

* The GitHub repository for the package should have a GitHub Action job for generating
  documentation (e.g., `build-docs` in `CI.yml`) and a GitHub Action job for deploying
  site files to GitHub Pages (e.g., `deploy-docs` in `gh-pages.yml`).

### Steps

* Create a key pair that the `build-docs` job can use to make modifications to the GitHub
  repository. __Note__: the `build-docs` job in `CI.yml` will only modify the `gh-pages`
  branch of the Git repository.

  * Use `DocumenterTools` to generate a key pair (with private key Base64-encoded).

    ```julia
    julia> using DocumenterTools
    julia> DocumenterTools.genkeys()
    ```

  * Add the public key to the profile of your GitHub account.

  * Add the private key to the GitHub secrets for the repository (or organization).

    * Key: `DOCUMENTER_KEY`
    * Value: Base64-encoded private key

* Configure "GitHub Pages" for the GitHub repository.

  * _Prerequisite_. The `gh-pages` branch must exist. You may need to create it manually.
    __Note__: the `build-docs` job in `CI.yml` will create the `gh-pages` branch if it
    does not already exist.

  * In the GitHub repository, navigate to `Settings` > `Pages` (on the sidebar) > `Source`.

  * Set the source for "GitHub Pages" to `GitHub Actions`.

* (OPTIONAL) Enable creation of version-specific documentation.

  * Make sure that the `build-docs` GitHub Action job used to build and deploy documentation
    calls `deploydocs()` with the `versions` keyword set to an appropriate value (the
    default value is reasonable).

    If the package has a `make.jl` file calls `deploydocs()`, replace the `run` command in
    the default `CI.yml` generated by `PkgTemplates` with the following:

    ```
    run: julia --project=docs/ --compile=min -O0 docs/make.jl
    ```

    __Note__. The `make.jl.template` file in the `templates/docs/` directory includes a
    call to `deploydocs()`.

### Troubleshooting

* If documentation deployment fails, check for errors in the log of the GitHub Actions
  tasks that build and deploy documentation.

--------------------------------------------------------------------------------------------

## 3. Package Registration

The following steps register a new package with the General registry.

### Steps

* Set up GitHub Action workflows that support package registration and releases.

  * `TagBot`: automates creation of GitHub releases

  * `CompatHelper`: automates determination of appropriate `[compat]` settings in the
    `Project.toml` file

  __Note__. By default, `PkgTemplates` creates workflow files for `TagBot` and
  `CompatHelper` that use the same key pair that is used by the `docs` job in `CI.yml`.

* (OPTIONAL) Prepare the package artifacts.

    * Please refer to the [blog article][dobberschutz-tips] by Sören Dobberschütz and the
      [Artifacts][julia-artifacts] section of the documentation for the `Pkg` package.

* Prepare the package for the initial release.

  * Set the initial package version in `Project.toml`.

  * Check that the package meets the [automatic merging guidelines][auto-merge-guidelines].

* Install Julia's `Registrator` GitHub app to your GitHub account and grant the bot access
  to the GitHub repository for the package.

  * Select the "install app" button on the [`JuliaComputing/Registrator`][julia-registrator]
    GitHub page and allow the bot to access your package repository. Only allow access to
    select repositories.

  * Confirm that the `Registrator` app can access the repository for the package by
    checking that it appears in the list of installed GitHub apps for the repository
    under `Settings` > `GitHub apps` (`Integrations` section of the sidebar).

* Register the package.

  * From the package's GitHub repository, add a comment containing the line
    `@JuliaRegistrator register` to any Issue or Commit.

  * The `Registrator` bot will be notified of the comment and process the registration
    request.

    * If there are auto-merge errors, the `Registrator` will post a comment in the issue
      indicating the error and suggesting solutions.

    * After all auto-merge requirements have been met, the package will be scheduled to be
      automatically merged into the General registry (after the mandatory waiting period
      of 3 days).

* Publish a GitHub release associated with the package release.

  * When using the `TagBot` workflow file generated by `PkgTemplates` (or the variation in
    the `templates/github/workflows/` directory), the GitHub release is ___automatically___
    created and published after the package has been merged into the General registry.

  * __Recommendation__. If the `draft` parameter has been set to `true` in `TagBot.yml`, a
    GitHub release is created but _not_ published. Unfortunately, enabling `draft` mode may
    interfere with the automated documentation generation process. Instead, we recommend
    disabling `draft` mode (i.e., allow `TagBot` to publish the release) and making edits
    to the release notes, if needed, after the GitHub release has been published.

--------------------------------------------------------------------------------------------

## 4. Package Release Process

The following steps release a new version of Juila package that is already registered with
the General registry.

### Prerequisites

* The Julia `Registrator` GitHub app should be installed for your GitHub account.

* The Julia `Registrator` GitHub app should be granted access to the GitHub repository for
  the package.
See the [Package Registration][#3] section for details.

### Steps

* Prepare the package for the new release.

  * Bump the version number in `Project.toml`.

    * When incrementing version numbers, follow the [Semantic Versioning 2.0.0][semver]
      with the following adaptations (from [ColPrac][colprac]).

      * Post-1.0.0
        * For breaking changes, increment the major version number.
        * For non-breaking new features, increment the minor version number.
        * For bug-fixes, increment the patch number.

      * Pre-1.0.0
        * For breaking changes, increment the minor version number.
        * For non-breaking features or bug-fixes, increment the patch number.

  * Update `NEWS.md`.

* Release the new package version in the General registry.

  * From the package's GitHub repository, add a comment containing the line
    `@JuliaRegistrator register` to any Issue or Commit.

  * The `Registrator` bot will be notified of the comment and release a new version of the
    package to the General registry.

  __Note__. The procedure for releasing a new version of a package is essentially the same
  as for the procedure for registering a new package.

* Publish a GitHub release associated with the package release.

  * When using the `TagBot` workflow file generated by `PkgTemplates` (or the variation in
    the `templates/github/workflows/` directory), the GitHub release is ___automatically___
    created and published after the `Registrator` has completed the release checks and
    merged the release into the General registry (typically about 15 to 20 min).

  * __Recommendation__. If the `draft` parameter has been set to `true` in `TagBot.yml`, a
    GitHub release is created but _not_ published. Unfortunately, enabling `draft` mode may
    interfere with the automated documentation generation process. Instead, we recommend
    disabling `draft` mode (i.e., allow `TagBot` to publish the release) and making edits
    to the release notes, if needed, after the GitHub release has been published.

--------------------------------------------------------------------------------------------

## 5. Additional Notes

### Security Configurations for GitHub Actions

For the GitHub Actions workflows used for Julia CI, registration, and releases, the
following actions must be allowed. The GitHub Actions permissions settings are located
under: `Settings` > `Actions` (sidebar) > `General`.

* Basic GitHub Actions: allow actions created by GitHub

* Codecov Integration: `codecov/*`

* Julia Continuous Integration (CI): `julia-actions/*`

* Julia Registration and Releases: `juliaregistries/tagbot@*`

### Checking Distance to Existing Package Names

In Julia 1.7, the code snippet provided in the
["Automatic Merging Guidelines"][auto-merge-guidelines] for generating the current list of
all package names in the General registry does not work.

The following alternate code should work for Julia 1.7. __Note__: this code relies on the
internal implementation of the `Pkg` package, so it should not be considered stable.

```julia
julia> using Pkg
julia> all_pkg_names = [
    pkg.name for pkg
    in values(Pkg.Registry.reachable_registries()[1].pkgs)
]

julia> using RegistryCI.AutoMerge
julia> AutoMerge.meets_distance_check("MyPackage", all_pkg_names)
```

--------------------------------------------------------------------------------------------

## 6. References

* [ColPrac: Contributor's Guide on Collaborative Practices for Community Packages][colprac]
* [General Registry Automatic Merging Guidlines][auto-merge-guidelines]
* [Julia Artifacts][julia-artifacts]
* [Julia Registrator][julia-registrator]
* [Semantic Versioning 2.0.0][semver]
* [Tips and tricks to register your first Julia package][dobberschutz-tips]

--------------------------------------------------------------------------------------------

## 7. Acknowledgements

Many thanks to Sören Dobberschütz and his excellent [blog article][dobberschutz-tips]. In
many ways, this guide is a restructuring and expansion of his article.

--------------------------------------------------------------------------------------------

[----------------------------------- INTERNAL LINKS -----------------------------------]: #

[#1]: #1-package-development
[#2]: #2-hosting-documentation-on-github-pages
[#3]: #3-package-registration
[#4]: #4-package-release-process
[#5]: #5-additional-notes
[#6]: #6-references
[#7]: #7-acknowledgements

[------------------------------------- REFERENCES -------------------------------------]: #

[auto-merge-guidelines]: https://juliaregistries.github.io/RegistryCI.jl/stable/guidelines/
[dobberschutz-tips]: https://www.juliabloggers.com/tips-and-tricks-to-register-your-first-julia-package/
[colprac]: https://docs.sciml.ai/ColPrac/
[julia-registrator]: https://github.com/JuliaRegistries/Registrator.jl
[julia-artifacts]: https://pkgdocs.julialang.org/v1/artifacts/
[semver]: https://semver.org/
