[![Actions Status](https://github.com/sanko/affix-libui/actions/workflows/linux.yaml/badge.svg)](https://github.com/sanko/affix-libui/actions) [![Actions Status](https://github.com/sanko/affix-libui/actions/workflows/windows.yaml/badge.svg)](https://github.com/sanko/affix-libui/actions) [![Actions Status](https://github.com/sanko/affix-libui/actions/workflows/osx.yaml/badge.svg)](https://github.com/sanko/affix-libui/actions) [![Actions Status](https://github.com/sanko/affix-libui/actions/workflows/freebsd.yaml/badge.svg)](https://github.com/sanko/affix-libui/actions) [![MetaCPAN Release](https://badge.fury.io/pl/LibUI.svg)](https://metacpan.org/release/LibUI)
# NAME

LibUI - Simple, Portable, Native GUI Library

# SYNOPSIS

    use LibUI ':all';
    use LibUI::Window;
    use LibUI::Label;
    Init( { Size => 1024 } ) && die;
    my $window = LibUI::Window->new( 'Hi', 320, 100, 0 );
    $window->setChild( LibUI::Label->new('Hello, World!') );
    $window->onClosing(
        sub {
            Quit();
            return 1;
        },
        undef
    );
    $window->show;
    Main();

# DESCRIPTION

LibUI is a simple and portable (but not inflexible) GUI library in C that uses
the native GUI technologies of each platform it supports.

# Container controls

- [LibUI::Window](https://metacpan.org/pod/LibUI%3A%3AWindow) - a top-level window
- [LibUI::HBox](https://metacpan.org/pod/LibUI%3A%3AHBox) - a horizontally aligned, boxlike container that holds a group of controls
- [LibUI::VBox](https://metacpan.org/pod/LibUI%3A%3AVBox) - a vertically aligned, boxlike container that holds a group of controls
- [LibUI::Tab](https://metacpan.org/pod/LibUI%3A%3ATab) - a multi-page control interface that displays one page at a time
- [LibUI::Group](https://metacpan.org/pod/LibUI%3A%3AGroup) - a container that adds a label to the child
- [LibUI::Form](https://metacpan.org/pod/LibUI%3A%3AForm) - a container to organize controls as labeled fields
- [LibUI::Grid](https://metacpan.org/pod/LibUI%3A%3AGrid) - a container to arrange controls in a grid

# Data entry controls

- [LibUI::Checkbox](https://metacpan.org/pod/LibUI%3A%3ACheckbox) - a user checkable box accompanied by a text label
- [LibUI::Entry](https://metacpan.org/pod/LibUI%3A%3AEntry) - a single line text entry field
- [LibUI::PasswordEntry](https://metacpan.org/pod/LibUI%3A%3APasswordEntry) - a single line, obscured text entry field
- [LibUI::SearchEntry](https://metacpan.org/pod/LibUI%3A%3ASearchEntry) - a single line search query field
- [LibUI::Spinbox](https://metacpan.org/pod/LibUI%3A%3ASpinbox) - display and modify integer values via a text field or +/- buttons
- [LibUI::Slider](https://metacpan.org/pod/LibUI%3A%3ASlider) - display and modify integer values via a draggable slider
- [LibUI::Combobox](https://metacpan.org/pod/LibUI%3A%3ACombobox) - a drop down menu to select one of a predefined list of items
- [LibUI::EditableCombobox](https://metacpan.org/pod/LibUI%3A%3AEditableCombobox) - a drop down menu to select one of a predefined list of items or enter you own

## Static controls

## Buttons

## Dialog windows

## Menus

## Tables

## LibUI::Control

### `uiControlDestroy( ... )`

    uiControlDestroy( $c );

Dispose and free all allocated resources.

### `uiControlHandle( ... )`

    my $handle = uiControlHandle( $c );

Returns the control's OS-level handle.

### `uiControlParent( ... )`

    my $parent = uiControlParent( $c );

Returns the parent control or `undef` if detached.

### `uiControlSetParent( ... )`

    uiControlSetParent( $c, $parent );

Sets the control's parent. Pass `undef` to detach.

### `uiControlToplevel( ... )`

    if ( uiControlToplevel( $c ) ) {
        ...;
    }

Returns whether or not the control is a top level control.

### `uiControlVisible( ... )`

    if ( uiControlVisible( $c ) ) {
        ...;
    }

Returns whether or not the control is visible.

### `uiControlShow( ... )`

    uiControlShow( $c );

Shows the control.

### `uiControlHide( ... )`

    uiControlHide( $c );

Hides the control. Hidden controls do not take up space within the layout.

### `uiControlEnabled( ... )`

    if ( uiControlEnabled( $c ) ) {
        ...;
    }

Returns whether or not the control is enabled.

### `uiControlEnable( ... )`

    uiControlEnable( $c );

Enables the control.

### `uiControlDisable( ... )`

    uiControlDisable( $c );

Disables the control.

### `uiAllocControl( ... )`

    my $control = uiAllocControl( $size, $OSsig, $type, $typename );

Helper to allocate new controls.

### `uiFreeControl( ... )`

    uiFreeControl( $c );

Frees the control.

### `uiControlVerifySetParent( ... )`

    uiControlVerifySetParent( $c, $parent );

Makes sure the control's parent can be set to `$parent` and crashes the
application on failure.

# Requirements

See [Alien::libui](https://metacpan.org/pod/Alien%3A%3Alibui)

# LICENSE

Copyright (C) Sanko Robinson.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

# AUTHOR

Sanko Robinson <sanko@cpan.org>
