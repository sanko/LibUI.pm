[![Actions Status](https://github.com/sanko/LibUI.pm/actions/workflows/linux.yaml/badge.svg)](https://github.com/sanko/LibUI.pm/actions) [![Actions Status](https://github.com/sanko/LibUI.pm/actions/workflows/windows.yaml/badge.svg)](https://github.com/sanko/LibUI.pm/actions) [![Actions Status](https://github.com/sanko/LibUI.pm/actions/workflows/osx.yaml/badge.svg)](https://github.com/sanko/LibUI.pm/actions) [![Actions Status](https://github.com/sanko/LibUI.pm/actions/workflows/freebsd.yaml/badge.svg)](https://github.com/sanko/LibUI.pm/actions) [![MetaCPAN Release](https://badge.fury.io/pl/LibUI.svg)](https://metacpan.org/release/LibUI)
# NAME

LibUI - Simple, Portable, Native GUI Library

# SYNOPSIS

    use LibUI;

    sub onClosing ( $window, $data ) {
        uiQuit();
        return 1;
    }

    my $err = uiInit( { Size => 0 } );
    if ( defined $err ) {
        printf "Error initializing libui-ng: %s\n", $err;
        uiFreeInitError($err);
        return 1;
    }

    # Create a new window
    my $w = uiNewWindow( "Hello, World!", 320, 120, 0 );
    uiWindowOnClosing( $w, \&onClosing, undef );
    uiWindowSetMargined( $w, 1 );

    #
    my $l = uiNewLabel("Hello, World!");
    uiWindowSetChild( $w, $l );

    #
    uiControlShow($w);
    uiMain();
    uiUninit();

<div>
    <h2>Screenshots</h2> <div style="text-align: center"> <h3>Linux</h3><img
    alt="Linux"
    src="https://sankorobinson.com/LibUI.pm/screenshots/synopsis/linux.png" />
    <h3>MacOS</h3><img alt="MacOS"
    src="https://sankorobinson.com/LibUI.pm/screenshots/synopsis/macos.png" />
    <h3>Windows</h3><img alt="Windows"
    src="https://sankorobinson.com/LibUI.pm/screenshots/synopsis/windows.png" />
    </div>
</div>

# DESCRIPTION

LibUI is a simple and portable (but not inflexible) GUI library in C that uses
the native GUI technologies of each platform it supports.

This distribution is under construction. It works but is incomplete.

# Functions

LibUI, keeping with the ethos of simplicity, is functional.

You may import any of them by name or with their given import tags.

## Default Functions

These are basic functions to get the UI started and may be imported with the
`:default` tag.

### `uiInit( ... )`

    my $err = uiInit({ Size => 0 });

Ask LibUI to do all the platform specific work to get up and running. If LibUI
fails to initialize itself, this will return a string. Weird upstream choice, I
know...

You **must** call this before creating widgets.

### `uiUninit( )`

    uiUninit( );

Ask LibUI to break everything down before quitting.

### `uiFreeInitError( ... )`

    uiFreeInitError( $err );

Frees the string returned when [&lt;uiInit( ... )](https://metacpan.org/pod/uiInit%28%20...%20%29)> fails.

### `uiMain( )`

    uiMain( );

Let LibUI's event loop run until interrupted.

### `uiMainSteps( )`

    uiMainSteps( );

You may call this instead of `uiMain( )` if you want to run the main loop
yourself.

### `uiMainStep( ... )`

    my $ok = uiMainStep( 1 );

Runs one iteration of the main loop.

It takes a single boolean argument indicating whether to wait for an even to
occur or not.

It returns true if an event was processed (or if no even is available if you
don't wish to wait) and false if the event loop was told to stop (for instance,
[<`uiQuit()`](https://metacpan.org/pod/uiQuit%28%20%29)> was called).

### `uiQuit( )`

    uiQuit( );

Signals LibUI that you are ready to quit.

### `uiQueueMain( )`

    uiQueueMain( sub { }, $values );

Trigger a callback on the main thread from any other thread. This is likely
unstable. It's for sure untested as long as perl threads are garbage.

### `uiTimer( ... )`

    uiTimer( 1000, sub { die 'do not do this here' }, undef);

    uiTime(
        1000,
        sub {
            my $data = shift;
            return 1 unless ++$data->{ticks} == 5;
            0;
        },
        { ticks => 0 }
    );

Expected parameters include:

- `$time`

    Time in milliseconds.

- `$func`

    CodeRef that will be triggered when `$time` runs out.

    Return a true value from your `$func` to make your timer repeating.

- `$data`

    Any userdata you feel like passing. It'll be handed off to your function.

### `uiOnShouldQuit( ... )`

    uiOnShouldQuit( sub {}, undef );

Callback triggered when the GUI is prepared to quit.

Expected parameters include:

- `$func`

    CodeRef that will be triggered.

- `$user_data`

    User data passed to the callback.

### `uiFreeText( ... )`

    uiFreeText( $title );

Free a string with LibUI.

## Control Functions

These functions may be used by all subclasses of the base control.

Import them with the `:control` tag.

### `uiControlDestroy( ... )`

    uiControlDestroy( $button );

Dispose and free all allocated resources related to a control.

### `uiControlHandle( ... )`

    my $ptr = uiControlHandle( $button );

Returns the control's OS-level handle.

### `uiControlParent( ... )`

    my $window = uiControlParent( $button );

Returns the parent control.

### `uiControlSetParent( ... )`

    my $ptr = uiControlSetParent( $button, $window );

Sets the control's parent.

### `uiControlToplevel( ... )`

    my $top = uiControlToplevel( $window );

Returns whether or not the control is a top level control.

### `uiControlVisible( ... )`

    my $visible = uiControlVisible( $label );

Returns whether or not the control is visible.

### `uiControlShow( ... )`

    uiControlShow( $window );

Shows the control.

### `uiControlHide( ... )`

    uiControlHide( $label );

Hides the control.

Hidden controls do not take up space within the layout.

### `uiControlEnabled( ... )`

    my $enabled = uiControlEnabled( $label );

Returns whether or not the control is enabled.

### `uiControlEnable( ... )`

    uiControlEnable( $label );

Enables the control.

### `uiControlDisable( ... )`

    uiControlDisable( $label );

Disables the control.

### `uiAllocControl( ... )`

    uiAllocControl( $label );

Allocates a new custom `uiControl`.

This function is undocumented upstream. Expected parameters include:

- `$n`

    Size of the control (in bytes).

- `$OSsig`
- `$typesig`
- `$typename`

    Name of the type as a string.

### `uiFreeControl( ... )`

    uiFreeControl( $button );

Frees a control.

### `uiControlVerifySetParent( ... )`

    uiControlVerifySetParent( $button, $window );

Makes sure the control's parent can be set to parent.

### `uiControlEnabledToUser( ... )`

    my $enabled = uiControlEnabledToUser( $label );

Returns whether or not the control can be interacted with by the user.

Checks if the control and all its parents are enabled to make sure it can be
interacted with by the user.

## Window Functions

A window control that represents a top-level window.

A window contains exactly one child control that occupies the entire window and
cannot be a child of another control.

These functions may be imported with the `:window` tag.

### `uiWindowTitle( ... )`

    my $title = uiWindowTitle( $window );

Returns the window title.

### `uiWindowSetTitle( ... )`

    uiWindowSetTitle( $window, 'Petris 1.0' );

Sets the window title.

### `uiWindowPosition( ... )`

    uiWindowPosition( $window, my $x, my $y );

Gets the window position.

Coordinates are measured from the top left corner of the screen. This method
may return inaccurate or dummy values on X11.

### `uiWindowSetPosition( ... )`

    uiWindowSetPosition( $window, 300, 50 );

Moves the window to the specified position.

Coordinates are measured from the top left corner of the screen. This method is
merely a hint and may be ignored on X11.

### `uiWindowOnPositionChanged( ... )`

    uiWindowOnPositionChanged(
        $window,
        sub {
            my ($w, $data) = @_;
            uiWindowPosition( $w, my $x, my $y );
            warn sprintf 'x: %d, y: %d', $x, $y;
        },
        undef
    );

Registers a callback for when the window moved.

Expected parameters include:

- `$window`

    The window to bind.

- `$code_ref`

    Code reference that should expect a reference back to the instance that
    triggered the callback and user data registered with the sender instance.

- `$user_data`

    Whatever you feel like passing along.

The callback is not triggered when calling `uiWindowSetPosition( ... )`.

### `uiWindowContentSize( ... )`

    uiWindowContentSize( $window, my $w, my $h );

Gets the window content size.

The content size does NOT include window decorations like menus or title bars.

### `uiWindowSetContentSize( ... )`

    uiWindowSetContentSize( $window, 500, 100 );

Sets the window content size.

The content size does NOT include window decorations like menus or title bars.

This method is merely a hint and may be ignored by the system.

### `uiWindowFullscreen( ... )`

    my $full = uiWindowFullscreen( $window );

Returns whether or not the window is full screen.

### `uiWindowSetFullscreen( ... )`

    uiWindowSetFullscreen( $window, 1 );

Sets whether or not the window is full screen.

This method is merely a hint and may be ignored by the system.

### `uiWindowOnContentSizeChanged( ... )`

    uiWindowOnContentSizeChanged(
        $w,
        sub {
            uiWindowContentSize( $w, my $w, my $h );
            say "w: $w, h: $h";
        },
        undef
    );

Registers a callback for when the window content size is changed.

Expected parameters include:

- `$window`

    The window to bind.

- `$code_ref`

    Code reference that should expect a reference back to the instance that
    triggered the callback and user data registered with the sender instance.

- `$user_data`

    Whatever you feel like passing along.

The callback is not triggered when calling `uiWindowSetContentSize( ... )`.

### `uiWindowOnClosing( ... )`

    uiWindowOnClosing(
        $w,
        sub {
            say 'Goodbye...';
            return 1;
        },
        undef
    );

Registers a callback for when the window is to be closed.

Expected parameters include:

- `$window`

    The window to bind.

- `$code_ref`

    Code reference that should expect a reference back to the instance that
    triggered the callback and user data registered with the sender instance.

    Return a true value to destroy the window. Return an untrue value to abort
    closing and keep the window alive and visible.

- `$user_data`

    Whatever you feel like passing along.

The callback is not triggered when calling `uiWindowSetContentSize( ... )`.

### `uiWindowOnFocusChanged( ... )`

    uiWindowOnFocusChanged(
        $w,
        sub {
            say LibUI::uiWindowFocused($w) ? 'in focus' : 'lost focus';
        },
        undef
    );

Registers a callback for when the window focus changes.

Expected parameters include:

- `$window`

    The window to bind.

- `$code_ref`

    Code reference that should expect a reference back to the instance that
    triggered the callback and user data registered with the sender instance.

- `$user_data`

    Whatever you feel like passing along.

### `uiWindowFocused( ... )`

    my $in_focus = uiWindowFocused( $w );

Returns whether or not the window is focused.

### `uiWindowBorderless( ... )`

    my $no_border = uiWindowBorderless( $w );

Returns whether or not the window is borderless.

### `uiWindowSetBorderless( ... )`

    uiWindowSetBorderless( $w, 1 );

Sets whether or not the window is borderless.

This method is merely a hint and may be ignored by the system.

### `uiWindowSetChild( ... )`

    uiWindowSetChild( $w, $box );

Sets the window's child.

### `uiWindowMargined( ... )`

    my $comfortable = uiWindowMargined( $w );

Returns whether or not the window has a margin.

### `uiWindowSetMargined( ... )`

    uiWindowSetMargined( $w, 1 );

Sets whether or not the window has a margin.

The margin size is determined by the OS defaults.

### `uiWindowResizeable( ... )`

    my $resizable = uiWindowResizeable( $w );

Returns whether or not the window is user resizable.

### `uiWindowSetResizeable( ... )`

    uiWindowSetResizeable( $w, 1 );

Sets whether or not the window is user resizable.

The margin size is determined by the OS defaults.

### `uiNewWindow( ... )`

Creates a new uiWindow.

Expected parameters include:

- `$title`

    Window title.

- `$width`

    Window width in pixels.

- `$height`

    Window height in pixels.

- `$hasMenubar`

    Whether or not the window should display a menu bar.

## Button Functions

These functions create and wrap a control that visually represents a button to
be clicked by the user to trigger an action.

Import these functions with the `:button` tag.

### `uiButtonText( ... )`

    my $label = uiButtonText( $button );

Returns the button label text.

### `uiButtonSetText( ... )`

    uiButtonSetText( $button, 'Click again' );

Sets the button label text.

### `uiButtonOnClicked( ... )`

    uiButtonOnClicked( $button, sub { my ($btn, data) = @_; }, undef );

Registers a callback for when the button is clicked.

### `uiNewButton( ... )`

    my $button = uiNewButton( 'Click me' );

Creates a new button.

Expected parameters include:

- `$label`

# Requirements

See [Alien::libui](https://metacpan.org/pod/Alien%3A%3Alibui)

# See Also

`eg/demo.pl` - Very basic example

`eg/widgets.pl` - Demo of basic controls

# LICENSE

Copyright (C) Sanko Robinson.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

# AUTHOR

Sanko Robinson <sanko@cpan.org>

# NAME

LibUI - Simple, Portable, Native GUI Library

# SYNOPSIS

    use LibUI qw[:all ::Window ::Label];
    Init( ) && die;
    my $window = LibUI::Window->new( 'Hi', 320, 100, 0 );
    $window->setMargined( 1 );
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

<div>
    <h2>Screenshots</h2> <div style="text-align: center"> <h3>Linux</h3><img
    alt="Linux"
    src="https://sankorobinson.com/LibUI.pm/screenshots/synopsis/linux.png" />
    <h3>MacOS</h3><img alt="MacOS"
    src="https://sankorobinson.com/LibUI.pm/screenshots/synopsis/macos.png" />
    <h3>Windows</h3><img alt="Windows"
    src="https://sankorobinson.com/LibUI.pm/screenshots/synopsis/windows.png" />
    </div>
</div>

# DESCRIPTION

LibUI is a simple and portable (but not inflexible) GUI library in C that uses
the native GUI technologies of each platform it supports.

This distribution is under construction. It works but is incomplete.

# Container controls

- [LibUI::Window](https://metacpan.org/pod/LibUI%3A%3AWindow) - a top-level window
- [LibUI::HBox](https://metacpan.org/pod/LibUI%3A%3AHBox) - a horizontally aligned, boxlike container that holds a group of controls
- [LibUI::VBox](https://metacpan.org/pod/LibUI%3A%3AVBox) - a vertically aligned, boxlike container that holds a group of controls
- [LibUI::Tab](https://metacpan.org/pod/LibUI%3A%3ATab) - a multi-page control interface that displays one page at a time
- [LibUI::Group](https://metacpan.org/pod/LibUI%3A%3AGroup) - a container that adds a label to the child
- [LibUI::Form](https://metacpan.org/pod/LibUI%3A%3AForm) - a container to organize controls as labeled fields
- [LibUI::Grid](https://metacpan.org/pod/LibUI%3A%3AGrid) - a container to arrange controls in a grid

# Data entry controls

- [LibUI::Button](https://metacpan.org/pod/LibUI%3A%3AButton) - a button control that triggers a callback when clicked
- [LibUI::Checkbox](https://metacpan.org/pod/LibUI%3A%3ACheckbox) - a user checkable box accompanied by a text label
- [LibUI::Entry](https://metacpan.org/pod/LibUI%3A%3AEntry) - a single line text entry field
- [LibUI::PasswordEntry](https://metacpan.org/pod/LibUI%3A%3APasswordEntry) - a single line, obscured text entry field
- [LibUI::SearchEntry](https://metacpan.org/pod/LibUI%3A%3ASearchEntry) - a single line search query field
- [LibUI::Spinbox](https://metacpan.org/pod/LibUI%3A%3ASpinbox) - display and modify integer values via a text field or +/- buttons
- [LibUI::Slider](https://metacpan.org/pod/LibUI%3A%3ASlider) - display and modify integer values via a draggable slider
- [LibUI::Combobox](https://metacpan.org/pod/LibUI%3A%3ACombobox) - a drop down menu to select one of a predefined list of items
- [LibUI::EditableCombobox](https://metacpan.org/pod/LibUI%3A%3AEditableCombobox) - a drop down menu to select one of a predefined list of items or enter you own
- [LibUI::RadioButtons](https://metacpan.org/pod/LibUI%3A%3ARadioButtons) - a multiple choice control of check buttons from which only one can be selected at a time
- [LibUI::DateTimePicker](https://metacpan.org/pod/LibUI%3A%3ADateTimePicker) - a control to enter a date and/or time
- [LibUI::DatePicker](https://metacpan.org/pod/LibUI%3A%3ADatePicker) - a control to enter a date
- [LibUI::TimePicker](https://metacpan.org/pod/LibUI%3A%3ATimePicker) - a control to enter a time
- [LibUI::MultilineEntry](https://metacpan.org/pod/LibUI%3A%3AMultilineEntry) - a multi line entry that visually wraps text when lines overflow
- [LibUI::NonWrappingMultilineEntry](https://metacpan.org/pod/LibUI%3A%3ANonWrappingMultilineEntry) - a multi line entry that scrolls text horizontally when lines overflow
- [LibUI::FontButton](https://metacpan.org/pod/LibUI%3A%3AFontButton) - a control that opens a font picker when clicked

## Static controls

- [LibUI::Label](https://metacpan.org/pod/LibUI%3A%3ALabel) - a control to display non-interactive text
- [LibUI::ProgressBar](https://metacpan.org/pod/LibUI%3A%3AProgressBar) - a control that visualizes the progress of a task via the fill level of a horizontal bar
- [LibUI::HSeparator](https://metacpan.org/pod/LibUI%3A%3AHSeparator) - a control to visually separate controls horizontally
- [LibUI::VSeparator](https://metacpan.org/pod/LibUI%3A%3AVSeparator) - a control to visually separate controls vertically

## Dialog windows

- `openFile( )` - File chooser to select a single file
- `openFolder( )` - File chooser to select a single folder
- `saveFile( )` - Save file dialog
- `msgBox( ... )` - Message box dialog
- `msgBoxError( ... )` - Error message box dialog

See ["Dialog windows" in LibUI::Window](https://metacpan.org/pod/LibUI%3A%3AWindow#Dialog-windows) for more.

## Menus

- `LibUI::Menu` - application-level menu bar
- `LibUI::MenuItem` - menu items used in conjunction with [LibUI::Menu](https://metacpan.org/pod/LibUI%3A%3AMenu)

## Tables

The upstream API is a mess so I'm still plotting around this.

# GUI Functions

Some basics you gotta use just to keep a modern GUI running.

This is incomplete but... well, I'm working on it.

### `Init( [...] )`

    Init( );

Ask LibUI to do all the platform specific work to get up and running. If LibUI
fails to initialize itself, this will return a true value. Weird upstream
choice, I know...

You **must** call this before creating widgets.

### `Main( ... )`

    Main( );

Let LibUI's event loop run until interrupted.

### `Uninit( ... )`

    Uninit( );

Ask LibUI to break everything down before quitting.

### `Quit( ... )`

    Quit( );

Quit.

### `Timer( ... )`

    Timer( 1000, sub { die 'do not do this here' }, undef);

    Timer(
        1000,
        sub {
            my $data = shift;
            return 1 unless ++$data->{ticks} == 5;
            0;
        },
        { ticks => 0 }
    );

Expected parameters include:

- `$time`

    Time in milliseconds.

- `$func`

    CodeRef that will be triggered when `$time` runs out.

    Return a true value from your `$func` to make your timer repeating.

- `$data`

    Any userdata you feel like passing. It'll be handed off to your function.

# Importing Widgets

You're free to import widgets manually...

    use LibUI;
    use LibUI::Window;
    use LibUI::Button;
    use LibUI::VBox;
    use LibUI::Area;
    use LibUI::Entry;

...or, you can let LibUI take care of it:

    use LibUI qw[::Window ::Button ::VBox ::Area ::Entry];

Note the

# Requirements

See [Alien::libui](https://metacpan.org/pod/Alien%3A%3Alibui)

# See Also

`eg/demo.pl` - Very basic example

`eg/widgets.pl` - Demo of basic controls

# LICENSE

Copyright (C) Sanko Robinson.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

# AUTHOR

Sanko Robinson <sanko@cpan.org>
