# Installation and Startup

This guide explains how to download, install, and start the Laser Test Pattern Generator on Windows, macOS, and Linux.

> Unofficial tool. Not affiliated with Makera. Always preview generated `.mks` files in Makera Studio after **Recalculate**, and always verify generic `.nc` files for your controller before running a laser.

## Which option should I use?

### Normal Windows users

Use the Windows release ZIP from GitHub Releases when it is available. This is the easiest option because it includes a packaged Windows executable.

### Python/source users

Use the source version if you want to run the tool with Python, inspect the code, use the CLI, or run it on macOS/Linux.

### macOS users

Use the Python/source startup path. Experimental macOS `.app` artifacts may be
available from GitHub Actions, but they are unsigned, not notarized, and not yet
the primary supported startup path.

### Linux users

Use the Python/source startup path. On some Linux distributions, Tkinter must be installed separately.

## Windows: release ZIP / executable

1. Open the latest GitHub Release.
2. Download the Windows ZIP asset if one is attached.
3. Extract the ZIP first. Do not run the app from inside the compressed ZIP viewer.
4. Open the extracted folder.
5. Double-click:

```text
LaserTestPatternGenerator.exe
```

Keep the folders next to the executable. Do not delete or move `_internal`, `templates`, or `presets` out of the extracted package.

### Windows SmartScreen or antivirus warning

Windows may show a SmartScreen warning because the experimental executable is not code-signed. This does not automatically mean the file is malicious, but you should only run files downloaded from the official GitHub Release.

If you are unsure, use the Python/source startup path instead.

## Windows: Python/source startup

Use this if you downloaded the source ZIP or cloned the repository.

1. Install Python 3.
2. Extract the source ZIP or clone the repository.
3. Open the project folder.
4. Double-click:

```text
start_gui_windows.bat
```

If double-clicking does not work, open PowerShell or Command Prompt in the project folder and run:

```powershell
python run_gui.py
```

or:

```powershell
python makera_material_test_generator.py --gui
```

## macOS: Python/source startup

Use Python if no macOS app artifact is available, if macOS blocks the
experimental app bundle, or if you want the most reliable startup path.

1. Install Python 3 if it is not already installed.
2. Download and extract the source ZIP, or clone the repository.
3. Double-click `start_gui_macos.command` in the project folder. It picks the
   first Python on your machine that actually has Tkinter and starts the GUI
   with it.

Or open Terminal in the project folder and run:

```bash
./start_gui_macos.command
```

If you prefer to start the GUI by hand, run:

```bash
python3 run_gui.py
```

or:

```bash
python3 makera_material_test_generator.py --gui
```

If macOS blocks files downloaded from the internet, make sure you extracted the ZIP into a normal user folder such as Downloads or Documents and run the Python command from Terminal.

### macOS: `No module named '_tkinter'`

Some Python installations are built without Tkinter, for example uv-managed
builds and Homebrew builds of very new versions such as 3.14 or 3.15. In that
case `python3 run_gui.py` fails with:

```text
ModuleNotFoundError: No module named '_tkinter'
```

This is a missing standard library component, not a missing package, so
`pip install` cannot fix it. Either start the app with
`./start_gui_macos.command`, which skips interpreters without Tkinter, or
install a Tk-enabled Python:

```bash
brew install python@3.11 tcl-tk
```

## macOS: experimental app artifact

Experimental macOS app artifacts may be produced by GitHub Actions. They are
unsigned and not notarized, so macOS Gatekeeper may warn or block them.

See [MACOS_APP.md](MACOS_APP.md) for details and fallback instructions.

## Linux / Ubuntu: Python/source startup

1. Install Python 3.
2. Install Tkinter if your distribution does not include it by default.
3. Download and extract the source ZIP, or clone the repository.
4. Open a terminal in the project folder.
5. Run:

```bash
python3 run_gui.py
```

or:

```bash
python3 makera_material_test_generator.py --gui
```

On Ubuntu/Debian, Tkinter is usually installed with:

```bash
sudo apt install python3-tk
```

## Command line usage

The GUI is the easiest way to start. Advanced users can also generate files from the command line:

```bash
python3 makera_material_test_generator.py --format Both --auto-filename --material-name cork
```

On Windows, use `python` instead of `python3` if that is how Python is installed.

## Troubleshooting

### Python is not found

Install Python 3 and make sure it is available in your terminal as `python` or `python3`.

On Windows, the Python installer has an option named **Add python.exe to PATH**. Enable it during installation, or reinstall Python with that option enabled.

### Tkinter is missing

The GUI uses Tkinter. It is part of Python on many installations, but some Linux distributions package it separately.

Ubuntu/Debian:

```bash
sudo apt install python3-tk
```

### Double-click does not start the source version

Open a terminal in the project folder and run:

Windows:

```powershell
python run_gui.py
```

macOS/Linux:

```bash
python3 run_gui.py
```

### The app is inside a ZIP and does not start correctly

Extract the ZIP first. Then run the executable or Python command from the extracted folder.

### Windows SmartScreen appears

Windows may warn about unsigned experimental executable builds. Only run downloads from the official GitHub Release. If you do not want to run the executable, use the Python/source startup path.

### Output files cannot be written

Choose an output folder where your user account has write permission, such as Documents or a dedicated project folder. Avoid protected system folders.

### Generated files look wrong in Makera Studio or an NC sender

Always preview the generated file before running it. In Makera Studio, open the generated `.mks`, press **Recalculate**, and check the preview. For generic `.nc`, verify the controller power scale and motion commands for your specific machine.

## Related documentation

- [Windows executable builds](WINDOWS_EXE.md)
- [macOS app builds](MACOS_APP.md)
- [Safety notes](SAFETY.md)
- [Presets](PRESETS.md)
- [JSON API](JSON_API.md)
