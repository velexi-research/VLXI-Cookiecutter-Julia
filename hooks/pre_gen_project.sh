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
# Cookiecutter pre-generation script
#------------------------------------------------------------------------------

# --- Preparations

# Get Julia package name
if [[ "{{ cookiecutter.package_name }}" == .jl* ]]; then
    echo 'Error: `package_name` cannot start with ".jl"'
    exit 1
fi

# --- Create Julia package directory

# License
if [[ "{{ cookiecutter.license }}" == "Apache-2.0" ]]; then
    LICENSE='License(; name="ASL"),'
elif [[ "{{ cookiecutter.license }}" == "BSD 3-Clause" ]]; then
    LICENSE='License(; name="BSD3"),'
elif [[ "{{ cookiecutter.license }}" == "Business Source License 1.1" ]]; then
    LICENSE=""
elif [[ "{{ cookiecutter.license }}" == "MIT" ]]; then
    LICENSE='License(; name="MIT"),'
elif [[ "{{ cookiecutter.license }}" == "Mozilla Public License 2.0" ]]; then
    LICENSE='License(; name="MPL-2.0"),'
else
    LICENSE=""
fi

# TagBot parameters
if [[ "{{ cookiecutter.tagbot_use_gpg_signing }}" == "yes" ]]; then
    TAG_BOT='TagBot(; gpg=Secret("GPG_KEY"), gpg_password=Secret("GPG_PASSWORD")),'
fi

# Define Julia expression to use PkgTemplates to generate a Julia package
JULIA_EXPR="
using Pkg;

Pkg.add(\"PkgTemplates\");
using PkgTemplates;

plugins = [
    $LICENSE
    Git(; ssh=true),
    GitHubActions(),
    Documenter{GitHubActions}(),
    $TAG_BOT
];

dir = \".\";
package_name = \"{{ cookiecutter.__package_name }}\";
template=Template(;
                  julia=VersionNumber(\"{{ cookiecutter.julia_version }}\"),
                  dir=dir,
                  user=\"{{ cookiecutter.github_repo_owner }}\",
                  plugins=plugins);
template(package_name);
Pkg.activate(joinpath(dir, package_name));
try
    Pkg.upgrade_manifest();
catch error
    if !(error isa Pkg.Types.PkgError) ||
        !contains(error.msg, \"Manifest.toml\` already up to date: \")

        rethrow(error)
    end
end
"

# Display Julia expression to generate Julia package
echo
echo "Running Julia expression:"
echo
echo $JULIA_EXPR
echo

# Run Julia expression to generate Julia package
julia --startup-file=no -q --compile=min -O0 -e "${JULIA_EXPR}"

# --- Move files to cookiecutter directory

mv {{ cookiecutter.__package_name }}/* .
mv {{ cookiecutter.__package_name }}/.[!.]* .
rmdir {{ cookiecutter.__package_name }}
