#!/bin/bash
# Build a local, unsigned macOS .app for the Laser Test Pattern Generator.
#
# This mirrors the flags used by .github/workflows/build-macos-app.yml, so the
# local bundle matches what the GitHub Actions artifact produces. The build runs
# inside a throwaway virtual environment, so it never installs anything into your
# system Python.
#
# Usage:
#   scripts/build_macos_app_local.sh                 # build into a temp folder
#   scripts/build_macos_app_local.sh --install       # build and copy to ~/Applications
#   scripts/build_macos_app_local.sh --python /opt/homebrew/bin/python3.11
#
# Notes:
#   * Tkinter is required. Interpreters without it (some uv and Homebrew builds
#     of very new Python versions) are rejected up front instead of failing
#     halfway through the build.
#   * The bundle is ad-hoc signed by PyInstaller, not notarized. It is meant for
#     local use, not distribution.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

APP_NAME="LaserTestPatternGenerator"
PACKAGE_DIR_NAME="Laser_Test_Pattern_Generator_macos"
BUNDLE_ID="com.github.wdani.lasertestpatterngenerator"
BUILD_DIR="${TMPDIR:-/tmp}"
BUILD_DIR="${BUILD_DIR%/}/laser_macos_build"
PYTHON_PATH=""
INSTALL=false

usage() {
  sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'
}

fail() {
  echo "ERROR: $*" >&2
  echo "RESULT: FAIL" >&2
  exit 1
}

while [ $# -gt 0 ]; do
  case "$1" in
    --install) INSTALL=true ;;
    --build-dir) shift; [ $# -gt 0 ] || fail "--build-dir needs a value"; BUILD_DIR="$1" ;;
    --python) shift; [ $# -gt 0 ] || fail "--python needs a value"; PYTHON_PATH="$1" ;;
    -h|--help) usage; exit 0 ;;
    *) fail "unknown argument: $1 (try --help)" ;;
  esac
  shift
done

# --- environment checks ------------------------------------------------------

[ "$(uname -s)" = "Darwin" ] || fail "this script builds a macOS app and only runs on macOS"

find_python_with_tkinter() {
  local candidate
  for candidate in "$@"; do
    if command -v "$candidate" >/dev/null 2>&1 && "$candidate" -c 'import tkinter' >/dev/null 2>&1; then
      command -v "$candidate"
      return 0
    fi
  done
  return 1
}

if [ -z "$PYTHON_PATH" ]; then
  PYTHON_PATH="$(find_python_with_tkinter python3.11 python3.12 python3.13 python3.10 /opt/homebrew/bin/python3 /usr/local/bin/python3 /usr/bin/python3 python3)" || PYTHON_PATH=""
  [ -n "$PYTHON_PATH" ] || fail "no Python 3 with Tkinter found. Install one, e.g.: brew install python@3.11 tcl-tk"
else
  command -v "$PYTHON_PATH" >/dev/null 2>&1 || fail "Python not found: $PYTHON_PATH"
  "$PYTHON_PATH" -c 'import tkinter' >/dev/null 2>&1 || fail "that Python cannot import tkinter, so the GUI cannot be bundled: $PYTHON_PATH"
fi

for required in run_gui.py templates presets docs README.md LICENSE.txt CHANGELOG.md RELEASE_NOTES.txt; do
  [ -e "$REPO_ROOT/$required" ] || fail "missing required path in repo: $required"
done

echo "repo:   $REPO_ROOT"
echo "python: $PYTHON_PATH ($("$PYTHON_PATH" -c 'import platform,sys;print(platform.python_version())'))"
echo "build:  $BUILD_DIR"

# --- build -------------------------------------------------------------------

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

echo "==> creating build virtualenv"
"$PYTHON_PATH" -m venv "$BUILD_DIR/venv"

echo "==> installing PyInstaller"
"$BUILD_DIR/venv/bin/python" -m pip install --quiet --upgrade pip pyinstaller \
  || fail "could not install PyInstaller (network or pip problem)"

echo "==> running PyInstaller"
cd "$REPO_ROOT"
"$BUILD_DIR/venv/bin/python" -m PyInstaller \
  --noconfirm \
  --clean \
  --name "$APP_NAME" \
  --windowed \
  --onedir \
  --osx-bundle-identifier "$BUNDLE_ID" \
  --add-data "$REPO_ROOT/templates:templates" \
  --add-data "$REPO_ROOT/presets:presets" \
  --add-data "$REPO_ROOT/docs:docs" \
  --distpath "$BUILD_DIR/dist" \
  --workpath "$BUILD_DIR/work" \
  --specpath "$BUILD_DIR" \
  run_gui.py \
  || fail "PyInstaller build failed"

# --- stage the package folder ------------------------------------------------

echo "==> staging package folder"
STAGE_PATH="$BUILD_DIR/package/$PACKAGE_DIR_NAME"
rm -rf "$BUILD_DIR/package"
mkdir -p "$STAGE_PATH"

cp -R "$BUILD_DIR/dist/$APP_NAME.app" "$STAGE_PATH/"
cp README.md LICENSE.txt CHANGELOG.md RELEASE_NOTES.txt "$STAGE_PATH/"
cp -R docs templates presets "$STAGE_PATH/"

REQUIRED_OUTPUTS=(
  "$STAGE_PATH/$APP_NAME.app"
  "$STAGE_PATH/$APP_NAME.app/Contents/MacOS/$APP_NAME"
  "$STAGE_PATH/templates"
  "$STAGE_PATH/presets"
  "$STAGE_PATH/docs"
  "$STAGE_PATH/README.md"
  "$STAGE_PATH/LICENSE.txt"
  "$STAGE_PATH/CHANGELOG.md"
  "$STAGE_PATH/RELEASE_NOTES.txt"
)

for output in "${REQUIRED_OUTPUTS[@]}"; do
  [ -e "$output" ] || fail "staged package is missing: $output"
done

APP_EXECUTABLE="$STAGE_PATH/$APP_NAME.app/Contents/MacOS/$APP_NAME"
[ -x "$APP_EXECUTABLE" ] || fail "app executable is not executable: $APP_EXECUTABLE"

ARCH="$(file -b "$APP_EXECUTABLE" | tr -s ' ')"
echo "arch:   $ARCH"

# --- optional install --------------------------------------------------------

INSTALLED_PATH="$HOME/Applications/$PACKAGE_DIR_NAME"
if [ "$INSTALL" = true ]; then
  echo "==> installing to $INSTALLED_PATH"
  rm -rf "$INSTALLED_PATH"
  mkdir -p "$HOME/Applications"
  cp -R "$STAGE_PATH" "$INSTALLED_PATH"
  [ -x "$INSTALLED_PATH/$APP_NAME.app/Contents/MacOS/$APP_NAME" ] \
    || fail "installed app executable is not executable"
fi

echo
echo "build dir: $BUILD_DIR"
echo "package:   $STAGE_PATH"
[ "$INSTALL" = true ] && echo "installed: $INSTALLED_PATH/$APP_NAME.app"
echo "RESULT: PASS"
