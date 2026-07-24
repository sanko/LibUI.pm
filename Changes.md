# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- New example: `eg/form.pl` — demonstrates `uiForm` with labeled fields, separators, spinbox, slider, color/font buttons
- New example: `eg/separators.pl` — demonstrates `uiNewHorizontalSeparator` and `uiNewVerticalSeparator`
- New example: `eg/image.pl` — demonstrates `uiNewImage`/`uiImageAppend` with generated pixel data (gradient, checkerboard, circles) displayed in a `uiTable` image column
- New example: `eg/matrix.pl` — demonstrates `uiDrawMatrix` transforms (translate, scale, rotate, skew) with animated combined transform

### Changed

- `uiNewArea` and `uiNewScrollingArea` now automatically wrap area callbacks (`Draw`, `MouseEvent`, `KeyEvent`) — opaque pointer casting is handled transparently so users receive typed struct hashrefs directly instead of raw `Pointer[Void]`
- Example scripts no longer need `use Affix` or manual `Affix::cast` calls for area callbacks

### Fixed

- `DrawMatrix` typedef: changed from `'LibUI::DrawMatrix'` (quoted full name) to bare `DrawMatrix` to match convention and avoid undefined subroutine errors
- `uiDrawMatrix*` bindings: changed `Pointer [Void]` to `Pointer [DrawMatrix()]` for proper type-safe struct pointers
- `uiDrawTransform` binding: second parameter changed from `Pointer [Void]` to `Pointer [DrawMatrix()]`

### Changed

- Updated `eg/bittorrent.pl`: 50ms UI timer, O(1) hash-based display lookup, peer refresh every ~2s

### Added

- Sugary use statement

## [0.02] - 2023-03-11

### Added

- New widgets:
    - `LibUI::Area` (very rough)
    - `LibUI::ScrollingArea`
- New example scripts:
    - `eg/demo.pl`: very basic, "Hello, World!" type of example
    - `eg/widgets.pl`: demo of (nearly all) basic controls
    - `eg/histogram.pl`: demo of `LibUI::Area` and related functions
- New enum and structs: `LibUI::Area::Handler`, `::KeyEvent`, `::MouseEvent`, `::Modifiers`

### Changed

- Renamed widgets to fit existing pattern:
    - `LibUI::HorizontalSeparator` => `LibUI::HSeparator`
    - `LibUI::VerticalSeparator` => `LibUI::VSeparator`

## [0.01] - 2022-12-07

### Added

- Original version
