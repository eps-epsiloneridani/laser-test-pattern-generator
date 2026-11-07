# Laser Test Pattern Generator

Generate laser material test patterns for **Makera Studio (`.mks`)** and
**generic NC/G-code (`.nc`)**.

> Unofficial tool. Not affiliated with Makera. Always preview generated files
> before running a laser.

## Current Release

The current release is **v1.7.0**.

This is a cross-platform Python/Tkinter tool. The included `.bat` file,
experimental Windows `.exe` builds, and experimental macOS `.app` builds are
convenience launchers; the generator itself runs from Python on Windows, Linux,
and macOS.

For detailed installation and startup help, see
[docs/INSTALLATION.md](docs/INSTALLATION.md).

## Features

- Generate Makera Studio `.mks` project files.
- Generate generic `.nc` / G-code files.
- Experimental Makera Studio-style `.nc` output flavor.
- Output modes: `MKS`, `NC`, or `Both`.
- Configurable grid: rows, columns, tile size, gap, and stock size.
- Configurable test ranges: speed in mm/min and power in percent.
- Laser modes: Line, Fill, and Offset Fill.
- Generic NC power profiles for Makera, GRBL, 8-bit, and custom S-value scales.
- Metadata comments in generated generic `.nc` files for easier verification.
- JSON CLI backend API for future automation, tooling, and UI/frontend work:
  `--api app-info`, `--api default-settings`, `--api preview`,
  `--api generate`, `--api log-result`, and `--api preflight-checklist`.
- JSON config-file workflow for API preview/generate commands, with example
  configs under `examples/api/`.
- English GUI.
- Improved GUI layout with a right-side quick preview on wide windows.
- Modernized Tkinter/ttk visual theme with Light and Dark modes.
- Improved numeric controls for common grid, stock, speed, power, and laser
  settings while still allowing manual typing.
- Privacy-friendly GUI update check via GitHub Releases, with optional startup
  checks disabled by default plus snooze and ignore-version behavior.
- Generated labels selectable between English and German.
- Preset manager with JSON presets, metadata, import/export, and optional
  reference image paths.
- Auto filename generation and overwrite protection.
- Optional JSON job manifest next to generated output files for reproducibility.
- Local JSONL material result log foundation for recording real-world test
  observations.
- Read-only laser safety preflight checklist foundation for future UI/frontend
  integration.
- Approximate preview tab plus automatic preview refresh after generation,
  preset loading, tab changes, and key layout edits.
- In the GUI, the output filename extension follows the selected format where
  it is safe to update `.mks` / `.nc`.

## Quick Start

### Windows

Double-click:

```text
start_gui_windows.bat
```

### macOS

Double-click:

```text
start_gui_macos.command
```

It picks the first Python on your machine that has Tkinter, so it also works
when `python3` was built without it.

### Linux/macOS

```bash
python3 run_gui.py
```

or:

```bash
python3 makera_material_test_generator.py --gui
```

### Manual Python Start

```bash
python makera_material_test_generator.py --gui
```

Tkinter is required. It is part of the Python standard library on many installs;
on some Linux distributions it is packaged separately as `python3-tk`.

For platform-specific setup and troubleshooting, see
[docs/INSTALLATION.md](docs/INSTALLATION.md).

## Update Checks

The GUI can manually check GitHub Releases from **Help -> Check for updates**.
Startup update checks are optional, disabled by default, and run at most once per
day when enabled. The check never downloads or installs updates automatically.

## Windows Executable Builds

Windows executable builds are experimental and generated through GitHub Actions.
Python/Tkinter remains the primary supported version for now;
the package includes an `_internal` runtime folder that must stay next to the
`.exe`. A Windows ZIP may be available under GitHub Releases; see
[docs/WINDOWS_EXE.md](docs/WINDOWS_EXE.md).

## macOS App Builds

macOS app builds are experimental and generated through GitHub Actions. The app
is unsigned and not notarized, so Python/source startup remains the recommended
fallback; see [docs/MACOS_APP.md](docs/MACOS_APP.md).

## Recommended First Test

1. Start the GUI.
2. Open the **Presets** tab.
3. Load `Cork broad 8x8`.
4. Check the quick preview or open the **Preview** tab. Preview updates automatically.
5. Click `Generate`.
6. Open the generated `.mks` in Makera Studio.
7. Press **Recalculate**.
8. Check the Preview before exporting or running.

## Screenshots

### Grid and stock setup

![Grid and stock setup](docs/screenshots/01-grid-stock-setup.png?v=clean-v1-2)

### Laser and NC settings

![Laser and NC settings](docs/screenshots/02-laser-nc-settings.png?v=clean-v1-2)

### Built-in layout preview

![Built-in layout preview](docs/screenshots/03-layout-preview.png?v=clean-v1-2)

### Makera Studio preview after Recalculate

![Makera Studio preview after Recalculate](docs/screenshots/04-makera-studio-preview.png?v=clean-v1-2)

## Command Line Examples

Generate both `.mks` and `.nc`:

```bash
python makera_material_test_generator.py --format Both --auto-filename --material-name cork --rows 8 --cols 8 --speed-min 1800 --speed-max 2800 --power-min 20 --power-max 40
```

Generate only Makera Studio `.mks`:

```bash
python makera_material_test_generator.py --format MKS --output material_test.mks
```

Generate only generic `.nc`:

```bash
python makera_material_test_generator.py --format NC --output material_test.nc
```

Generate generic `.nc` for a GRBL-style controller:

```bash
python makera_material_test_generator.py --format NC --nc-power-profile "GRBL (0-1000)" --output material_test_grbl.nc
```

Generate German labels:

```bash
python makera_material_test_generator.py --format MKS --language Deutsch --output material_test_de.mks
```

Write an optional job manifest next to the generated output:

```bash
python makera_material_test_generator.py --format NC --output material_test.nc --write-manifest
```

The manifest is a JSON reproducibility aid for recording the app version,
generation settings, and generated output paths. It is optional and is not a
full material result log.

Append a simple material test result observation:

```bash
python makera_material_test_generator.py --log-result --material-name cork --result-rating good --result-notes "Clean result"
```

See [docs/MATERIAL_RESULTS.md](docs/MATERIAL_RESULTS.md) for the JSONL result
log format and API usage.

Get a read-only laser safety preflight checklist:

```bash
python makera_material_test_generator.py --api preflight-checklist
```

See [docs/PREFLIGHT_CHECKLIST.md](docs/PREFLIGHT_CHECKLIST.md) for the checklist
notes and safety reminders.

## Repository Layout

- `makera_material_test_generator.py` - backwards-compatible CLI/GUI entry point.
- `run_gui.py` - GUI launcher used by Python users and the Windows exe build.
- `laser_test_pattern_generator/` - Python package with CLI, GUI, and generator modules.
- `start_gui_windows.bat` - Windows convenience launcher.
- `start_gui_macos.command` - macOS convenience launcher; picks a Python that has Tkinter.
- `templates/` - Makera Studio template projects used by `.mks` generation.
- `presets/` - compatible JSON presets for the GUI.
- `docs/` - safety notes, API documentation, presets, and roadmap.

Generated scratch outputs should stay outside the repository or in ignored output
folders.

## Generic NC Power Scale

Generic `.nc` output is controller-dependent. Different controllers use
different laser power scales.

The default NC flavor is `generic`. An experimental `makera-studio` NC flavor
is also available for the newer Makera Studio-style `.nc` export. See
[docs/NC_OUTPUT_FLAVORS.md](docs/NC_OUTPUT_FLAVORS.md).

Generated `.nc` files include metadata comments at the top with the selected
NC power profile, S max, grid settings, speed and power ranges, and a reminder
to verify the S-value scale before running the file.

Since v1.1, the default generic NC profile is **Makera (0-1)**:

- `0%` power maps to `S0.0`
- `20%` power maps to `S0.2`
- `40%` power maps to `S0.4`
- `100%` power maps to `S1.0`

GRBL-style controllers often use **0-1000** instead:

- `20%` power maps to `S200`
- `40%` power maps to `S400`
- `100%` power maps to `S1000`

Available profiles:

- `Makera (0-1)`
- `GRBL (0-1000)`
- `8-bit (0-255)`
- `Custom`

Use `--nc-power-profile Custom --nc-s-max VALUE` for another controller scale.
Always verify the `S` scale for your machine.

## Safety

Read [docs/SAFETY.md](docs/SAFETY.md).

## Roadmap

See [docs/INSTALLATION.md](docs/INSTALLATION.md),
[docs/JSON_API.md](docs/JSON_API.md),
[docs/MATERIAL_RESULTS.md](docs/MATERIAL_RESULTS.md),
[docs/NC_OUTPUT_FLAVORS.md](docs/NC_OUTPUT_FLAVORS.md),
[docs/PRESETS.md](docs/PRESETS.md),
[docs/RELEASE_CHECKLIST.md](docs/RELEASE_CHECKLIST.md),
[docs/ROADMAP.md](docs/ROADMAP.md), and
[docs/VERSIONING.md](docs/VERSIONING.md).

## License

MIT License. See [LICENSE.txt](LICENSE.txt).
