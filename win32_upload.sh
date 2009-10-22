#!/bin/bash

cd "$(dirname "$0")"
distribdir="$(pwd)"

source functions.sh

upload_to_frs "$(get_olx_win32_fn)"
upload_to_frs "$(get_olx_win32patch_fn)"
#upload_to_frs "$(get_olx_win32debug_fn)"
