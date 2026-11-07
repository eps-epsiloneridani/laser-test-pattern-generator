#!/bin/bash
# macOS convenience launcher for the Laser Test Pattern Generator.
#
# Double-click this file in Finder, or run it from Terminal:
#
#   ./start_gui_macos.command
#
# Tkinter is required by the GUI. Some Python installations ship without it
# (for example uv-managed builds, or Homebrew builds of very new versions such
# as 3.14/3.15), so this launcher probes for the first interpreter that can
# actually import Tkinter instead of assuming `python3` works.

set -u

cd "$(dirname "$0")" || exit 1

# Ordered by preference: the version CI tests against first, then newer, then
# whatever `python3` happens to mean on this machine.
CANDIDATES=(
  python3.11
  python3.12
  python3.13
  python3.10
  /opt/homebrew/bin/python3
  /usr/local/bin/python3
  /usr/bin/python3
  python3
)

find_python_with_tkinter() {
  local candidate
  for candidate in "${CANDIDATES[@]}"; do
    if command -v "$candidate" >/dev/null 2>&1; then
      if "$candidate" -c 'import tkinter' >/dev/null 2>&1; then
        command -v "$candidate"
        return 0
      fi
    fi
  done
  return 1
}

python_path="$(find_python_with_tkinter)" || python_path=""

if [ -z "$python_path" ]; then
  cat <<'MESSAGE'
Could not find a Python 3 interpreter with Tkinter support.

The GUI needs Tkinter. It ships with most Python installations but is missing
from some, for example uv-managed builds and Homebrew builds of very new
Python versions.

Fix:
  1. Install a Tk-enabled Python, for example:
       brew install python@3.11 tcl-tk
  2. Run this launcher again.

The command line interface does not need Tkinter:
  python3 makera_material_test_generator.py --help
MESSAGE
  echo
  read -r -p "Press Return to close this window." _
  exit 1
fi

echo "Starting Laser Test Pattern Generator with: $python_path"
exec "$python_path" run_gui.py "$@"
