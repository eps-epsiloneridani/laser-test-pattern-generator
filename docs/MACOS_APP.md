# macOS App Builds

macOS app builds are experimental. The primary supported way to run the Laser
Test Pattern Generator is still the cross-platform Python/Tkinter source
version.

The experimental macOS app package is built with PyInstaller through the manual
GitHub Actions workflow `Build macOS App`. It is intended as a convenience
artifact for testing the stable v1.x Python/Tkinter app, not as a signed or
notarized installer.

## Local Build

To produce the same `.app` on your own Mac without GitHub Actions:

```bash
scripts/build_macos_app_local.sh            # build into a temp folder
scripts/build_macos_app_local.sh --install  # build and copy to ~/Applications
```

The script uses the same PyInstaller flags as the workflow above, keeps
PyInstaller out of your system Python by building inside a throwaway virtual
environment, and refuses to run if the selected Python cannot import `tkinter`.
Use `--python /path/to/python3.11` to choose an interpreter explicitly.

Local builds are ad-hoc signed and not notarized, so they are for your own use
rather than for distribution.

## Package Contents

The GitHub Actions artifact contains a `.tar.gz` archive. The tar archive is
used so macOS executable permissions inside the `.app` bundle are preserved.
After extracting the archive, the package folder contains:

- `LaserTestPatternGenerator.app`
- `README.md`
- `LICENSE.txt`
- `CHANGELOG.md`
- `RELEASE_NOTES.txt`
- `docs/`
- `templates/`
- `presets/`

Keep `templates/` and `presets/` next to the `.app`. Makera Studio `.mks`
generation needs the template files, and the GUI preset manager reads and
writes presets from the visible package folder.

## Download and Start

1. Open the manual `Build macOS App` workflow run in GitHub Actions.
2. Download the macOS artifact.
3. Extract the downloaded artifact.
4. Extract the contained `.tar.gz` archive.
5. Open the extracted package folder.
6. Double-click `LaserTestPatternGenerator.app`.

You can also start the app from Terminal with:

```bash
open LaserTestPatternGenerator.app
```

or by running the bundled executable directly:

```bash
./LaserTestPatternGenerator.app/Contents/MacOS/LaserTestPatternGenerator
```

The app normalizes its startup working directory when launched from Finder,
`open`, or the bundled executable. The package still keeps user-facing
`templates/`, `presets/`, and `docs/` folders next to the `.app`, and the app
also includes bundled fallback copies for Finder/App Translocation startup
cases.

## Startup Diagnostics

If the experimental `.app` starts and exits immediately, check the startup log:

```text
~/Library/Logs/Laser Test Pattern Generator/startup.log
```

When startup fails inside the packaged app, the launcher writes traceback and
environment details to that file. Please include this log when reporting macOS
app launch problems.

## Gatekeeper Notes

The experimental `.app` is unsigned and not notarized. macOS Gatekeeper may warn
that the app is from an unidentified developer or may block it.

Only run artifacts that you downloaded from the official repository workflow or
release. If macOS blocks the `.app`, use the Python/source startup path instead:

```bash
python3 run_gui.py
```

or:

```bash
python3 makera_material_test_generator.py --gui
```

## Source Fallback

Python/source startup remains supported on macOS. It is the recommended fallback
if the app bundle is blocked, if the experimental package does not work on your
macOS version, or if you want to use the CLI/API commands directly.

Tkinter is required. It is included with many Python installations, but exact
availability can vary depending on how Python was installed.

## Safety

Always preview generated `.mks` files in Makera Studio after Recalculate, and
always verify generic `.nc` files against the target controller before running a
laser.
