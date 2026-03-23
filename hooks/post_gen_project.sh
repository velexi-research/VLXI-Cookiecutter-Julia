#!/usr/bin/env bash
#------------------------------------------------------------------------------
#   Copyright 2020 Velexi Corporation
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Cookiecutter post-generation script
#------------------------------------------------------------------------------

# --- License files

# license = Apache License: remove NOTICE file
if [[ "{{ cookiecutter.license }}" != "ASL" ]]; then
    rm NOTICE
fi

# license = Business Source License
if [[ "{{ cookiecutter.license }}" == "BSL" ]]; then
    mv LICENSE-BSL LICENSE
else
    rm LICENSE-BSL
fi

# license = None: force LICENSE file to be an empty file
if [[ "{{ cookiecutter.license }}" == "None" ]]; then
    rm LICENSE
    touch LICENSE
fi

# --- GitHub Actions files

# Replace default dependabot.yml
mv dot-github-dependabot.yml .github/dependabot.yml

# Replace default GitHub Actions workflows
mv dot-github-workflows-CI.yml .github/workflows/CI.yml

# --- Update basic package files

# Replace default README.md
mv README-template.md README.md

# Add Project.toml to test directory
mv test-Project.toml test/Project.toml

# Replace test/runtests.jl
mv test-runtests.jl test/runtests.jl

# Set up basic package structure
git checkout main
git add .
git reset dot-github-workflows-gh-pages.yml
git commit -m "Set up basic package structure."

# --- Set up deployment of package documentation to GitHub Pages

if [[ "{{ cookiecutter.enable_github_pages }}" == "yes" ]]; then

    # Create gh-pages branch
    git checkout --orphan gh-pages

    # Delete existing files from branch
    git rm -rf .

    # Add GitHub Actions workflow for deploying documentation to GitHub Pages
    mkdir -p .github/workflows
    mv dot-github-workflows-gh-pages.yml .github/workflows/gh-pages.yml
    git add .github/workflows/gh-pages.yml

    # Commit changes
    git commit -m "Add GitHub Actions workflow for GitHub Pages."

    # Change back to "main" branch
    git checkout main

else
    # Remove GitHub Actions workflow for GitHub Pages
    rm dot-github-workflows-gh-pages.yml
fi
