#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: tools/convert_to_webp.sh --input DIR [--quality 85] [--delete-source]

Converts all non-WebP images in DIR to WebP using cwebp.
EOF
}

input_dir=""
quality="85"
delete_source="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --input)
      input_dir="$2"
      shift 2
      ;;
    --quality)
      quality="$2"
      shift 2
      ;;
    --delete-source)
      delete_source="true"
      shift 1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
  done

if [[ -z "$input_dir" ]]; then
  echo "Missing --input" >&2
  usage
  exit 1
fi

if [[ ! -d "$input_dir" ]]; then
  echo "Input directory not found: $input_dir" >&2
  exit 1
fi

shopt -s nullglob
for src_path in "$input_dir"/*; do
  if [[ ! -f "$src_path" ]]; then
    continue
  fi

  if [[ "$src_path" == *.webp ]]; then
    continue
  fi

  base_name="${src_path%.*}"
  out_path="${base_name}.webp"

  cwebp -quiet -q "$quality" -m 6 "$src_path" -o "$out_path"

  if [[ "$delete_source" == "true" ]]; then
    rm -f "$src_path"
  fi
  done
