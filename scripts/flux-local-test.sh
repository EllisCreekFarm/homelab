#!/usr/bin/env bash

set -o errexit

function validate() {
    local cluster_dir="$1"
    shift 1

    local flux_local_args=(
        "test"
        "--enable-helm"
        "--all-namespaces"
        "--path"
        "${cluster_dir}/flux"
        "-v"
        "$@"
    )

    echo "=== Validating ${cluster_dir}/flux ==="
    if ! flux-local "${flux_local_args[@]}"; then
        exit 1
    fi
}

function run() {
    if [[ "${DEVBOX_SHELL_ENABLED:-0}" != "1" ]]; then
        devbox run flux-local-test "$@"
        return $?
    fi

    validate "$DEVBOX_PROJECT_ROOT/kubernetes"
}

run "$@"
