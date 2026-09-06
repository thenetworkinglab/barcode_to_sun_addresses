# Changelog

All notable changes to this project will be documented in this file.

## [0.3.0] - 2026-09-06

### Added
- Input validation: the barcode must be exactly 4 letters/digits and the
  machine type must be 2 hex digits. Previously, invalid input was silently
  parsed as far as possible, producing wrong results with no warning.
- A warning is printed when the barcode converts to a negative serial
  number, which almost always means a mistyped barcode.

### Changed
- The MAC address now prints in standard notation with leading zeroes
  (`08:00:20:...` instead of `8:0:20:...`).

### Removed
- A redundant conditional around the `oct()` machine-type conversion.

## [0.2.0] - 2026-09-06

Merged [PR #2](https://github.com/thenetworkinglab/barcode_to_sun_addresses/pull/2),
contributed by [@queernix](https://github.com/queernix).

### Fixed
- Wrong vendor ID (OUI) in the MAC address: the first octet was `80` but
  should be `8`
  ([#1](https://github.com/thenetworkinglab/barcode_to_sun_addresses/issues/1)).

### Changed
- Enabled `use strict;` and declared `@mac_address` properly.
- Improved option handling: the script now exits and prints the synopsis
  when the required arguments are missing.

## [0.1.0] - 2021-02-28

Initial release.
