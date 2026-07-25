# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

This is the first version with all of libui-ng's full widget set.

### Added

- New examples in `eg/`:
  - `timer.pl` - demonstrates `uiTimer` by printing timestamps every second
  - `hello_world.pl` - minimal "Hello, World!" window
  - `controlgallery.pl` - port of the upstream libui-ng control gallery showcasing basic controls, numbers, lists, and data choosers
  - `calculator.pl` - basic calculator with grid layout, menus, and a settings dialog
  - `clock.pl` - animated analog clock using `uiArea`, `uiTimer`, and draw matrix transforms
  - `datetime.pl` - demonstrates `uiDateTimePicker` with date, time, and combined pickers

### Changed

- `uiNewArea` and `uiNewScrollingArea` wrap callbacks (`Draw`, `MouseEvent`, `KeyEvent`). to tansparently handle casting opaque pointers to useful structs.

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
