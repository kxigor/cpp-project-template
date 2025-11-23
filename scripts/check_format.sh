#!/usr/bin/env bash

set -euo pipefail

usage() {
  echo "Usage: $0 --config <path_to_clang_format> --files <file_list>"
  exit 1
}

CONFIG_FORMAT_CMD="clang-format-19"
CONFIG_FILE=""
FILES=""

while [[ $# -gt 0 ]]; do
done