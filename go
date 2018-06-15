#!/usr/bin/env bash

function run_rake() {
    [ -n "$GO_DEBUG" ] && set -x
    set -e

    project_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    verbose="no"
    skip_checks="no"
    skip_pre_flight="no"
    offline="no"

    missing_dependency="no"

    [ -n "$GO_DEBUG" ] && verbose="yes"
    [ -n "$GO_SKIP_CHECKS" ] && skip_checks="yes"
    [ -n "$GO_SKIP_PRE_FLIGHT" ] && skip_pre_flight="yes"
    [ -n "$GO_OFFLINE" ] && offline="yes"

    if [[ "$skip_checks" = "no" ]]; then
        echo "Checking for system dependencies."
        ruby_version="$(ruby -v | perl -pe 's/ruby ([\d+]+).*/\1/')"
        if [ ${ruby_version} != "2" ] ; then
            echo "This codebase requires ruby 2.x"
            missing_dependency="yes"
        fi

        if ! type bundler >/dev/null 2>&1; then
            echo "This codebase requires Bundler."
            missing_dependency="yes"
        fi

        if [[ "$missing_dependency" = "yes" ]]; then
            echo "Please install missing dependencies to continue."
            exit 1
        fi

        echo "All system dependencies present. Continuing."
    fi

    if [[ "$skip_pre_flight" = "no" ]]; then
        echo "Installing git hooks."
        [ -f ./scripts/git/prepare-commit-msg ] && cp -f scripts/git/prepare-commit-msg .git/hooks/

        if [[ "$offline" = "no" ]]; then
            echo "Installing bundler."
            if [[ "$verbose" = "yes" ]]; then
                gem install --user-install --no-document --no-ri bundler
            else
                gem install --user-install --no-document --no-ri bundler > /dev/null
            fi

            echo "Installing ruby dependencies."
            if [[ "$verbose" = "yes" ]]; then
                bundle install
            else
                bundle install > /dev/null
            fi
        fi
    fi

    echo "Starting rake."
    if [[ "$verbose" = "yes" ]]; then
        time bundle exec rake --verbose "$@"
    else
        time bundle exec rake "$@"
    fi
}

usage=" USAGE: go <rake command>"

COMMAND="$@"

bold=`tput bold`
green=`tput setaf 2`
reset=`tput sgr0`

echo
echo ${bold}${green}">>> Running command: [ go $COMMAND ]"${reset}
echo

run_rake $COMMAND
