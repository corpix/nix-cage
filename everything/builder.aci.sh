#!/usr/bin/env bash
set -e

find "$(git rev-parse --show-toplevel)"         \
     -maxdepth 2 -type f -name 'builder.aci.sh' \
    | grep -v /base/                            \
    | grep -v /everything/                      \
    |                                           \
    {
        while read builder
        do
            source $builder
        done
    }
