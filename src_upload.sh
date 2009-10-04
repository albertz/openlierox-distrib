#!/bin/bash

cd "$(dirname "$0")"
distribdir="$(pwd)"

source functions.sh

upload_to_frs "$(get_olx_src_fn)"
