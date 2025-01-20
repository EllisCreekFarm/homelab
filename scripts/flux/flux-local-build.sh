#!/usr/bin/env bash

set -o errexit

function validate() {
    local cluster_dir="$1"
    shift 1

    local flux_local_args=(
        "build"
        "all"
        "${cluster_dir}/flux"
        "$@"
    )

    echo "=== Validating ${cluster_dir}/flux ==="
    if ! flux-local "${flux_local_args[@]}"; then
        exit 1
    fi
}

function run() {
    local root_dir
    if ! root_dir="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"; then
        echo "Failed to determine root dir"
        exit 1
    fi
    if [[ "${DEVBOX_SHELL_ENABLED:-0}" != "1" || "$DEVBOX_PROJECT_ROOT" != "$root_dir" ]]; then
        devbox run --config "${root_dir}" flux-local-build "$@"
        return $?
    fi

    validate "$(dirname "$(dirname "$root_dir")")/kubernetes"
}

run "$@"
