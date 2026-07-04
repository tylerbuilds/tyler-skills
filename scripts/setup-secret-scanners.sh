#!/usr/bin/env bash
set -euo pipefail

root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$root"

bin_dir="${SECRET_SCANNER_BIN_DIR:-$root/.tools/bin}"
tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

gitleaks_version="${GITLEAKS_VERSION:-8.30.1}"
trufflehog_version="${TRUFFLEHOG_VERSION:-3.95.8}"

mkdir -p "$bin_dir"

os="$(uname -s | tr '[:upper:]' '[:lower:]')"
arch="$(uname -m)"

case "$os" in
  darwin|linux) ;;
  *)
    echo "Unsupported OS: $os" >&2
    exit 1
    ;;
esac

case "$arch" in
  x86_64|amd64)
    gitleaks_arch="x64"
    trufflehog_arch="amd64"
    ;;
  arm64|aarch64)
    gitleaks_arch="arm64"
    trufflehog_arch="arm64"
    ;;
  *)
    echo "Unsupported architecture: $arch" >&2
    exit 1
    ;;
esac

sha256_file() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
    return
  fi

  if command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$1" | awk '{print $1}'
    return
  fi

  echo "No sha256 tool found. Install sha256sum or shasum." >&2
  exit 1
}

download_and_verify() {
  local name="$1"
  local version="$2"
  local repo="$3"
  local asset="$4"
  local checksums="$5"
  local url="https://github.com/${repo}/releases/download/v${version}/${asset}"
  local checksums_url="https://github.com/${repo}/releases/download/v${version}/${checksums}"
  local archive="$tmp_dir/$asset"
  local checksums_file="$tmp_dir/$checksums"
  local expected actual

  echo "Downloading $name $version for $os/$arch"
  curl -fsSL "$checksums_url" -o "$checksums_file"
  curl -fsSL "$url" -o "$archive"

  expected="$(grep "  ${asset}$" "$checksums_file" | awk '{print $1}')"
  if [[ -z "$expected" ]]; then
    echo "Checksum for $asset not found in $checksums." >&2
    exit 1
  fi

  actual="$(sha256_file "$archive")"
  if [[ "$actual" != "$expected" ]]; then
    echo "Checksum mismatch for $asset." >&2
    echo "Expected: $expected" >&2
    echo "Actual:   $actual" >&2
    exit 1
  fi

  mkdir -p "$tmp_dir/$name"
  tar -xzf "$archive" -C "$tmp_dir/$name"
}

gitleaks_asset="gitleaks_${gitleaks_version}_${os}_${gitleaks_arch}.tar.gz"
gitleaks_checksums="gitleaks_${gitleaks_version}_checksums.txt"
download_and_verify "gitleaks" "$gitleaks_version" "gitleaks/gitleaks" "$gitleaks_asset" "$gitleaks_checksums"
install "$tmp_dir/gitleaks/gitleaks" "$bin_dir/gitleaks"

trufflehog_asset="trufflehog_${trufflehog_version}_${os}_${trufflehog_arch}.tar.gz"
trufflehog_checksums="trufflehog_${trufflehog_version}_checksums.txt"
download_and_verify "trufflehog" "$trufflehog_version" "trufflesecurity/trufflehog" "$trufflehog_asset" "$trufflehog_checksums"
install "$tmp_dir/trufflehog/trufflehog" "$bin_dir/trufflehog"

echo
echo "Installed scanners:"
"$bin_dir/gitleaks" version
"$bin_dir/trufflehog" --version
echo
echo "Add to PATH for this shell:"
echo "export PATH=\"$bin_dir:\$PATH\""
