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
`uiQuit()` was called).

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

Expected parameters include:

- `$n`

    Size of the control (in bytes).

- `$OSsig`
- `$typesig`
- `$typename`

    Name of the type as a string.

This function is undocumented upstream.

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

## Box Functions

These functions wrap a boxlike container that holds a group of controls.

The contained controls are arranged to be displayed either horizontally or
vertically next to each other.

You may import these functions with the `:box` tag.

### `uiBoxAppend( ... )`

    uiBoxAppend( $box, $child, 1 );

Appends a control to the box.

Stretchy items expand to use the remaining space within the box. In the case of
multiple stretchy items the space is shared equally.

Expected parameters include:

- `$box`
- `$child`
- `$stretchy`

    True value to stretch the child, otherwise false.

### `uiBoxNumChildren( ... )`

    my $kids = uiBoxNumChildren( $box );

Returns the number of controls contained within the box.

### `uiBoxDelete( ... )`

    uiBoxDelete( $box, 3 );

Removes the control at a given index from the box.

### `uiBoxPadded( ... )`

    my $comfortable = uiBoxPadded( $box );

Returns whether or not controls within the box are padded.

Padding is defined as space between individual controls.

### `uiBoxSetPadded( ... )`

    uiBoxSetPadded( $box, 1 );

Sets whether or not controls within the box are padded.

Padding is defined as space between individual controls. The padding size is
determined by the OS defaults.

### `uiNewHorizontalBox( )`

    uiNewHorizontalBox( );

Creates a new horizontal box.

Controls within the box are placed next to each other horizontally.

### `uiNewVerticalBox( )`

    my $vbox = uiNewVerticalBox( );

Creates a new vertical box.

Controls within the box are placed next to each other vertically.

## Checkbox Functions

The functions wrap a control with a user checkable box accompanied by a text
label.

You may import them with the `:checkbox` tag.

### `uiCheckboxText( ... )`

    my $label = uiCheckboxText( $chk );

Returns the checkbox label text.

### `uiCheckboxSetText( ... )`

    uiCheckboxSetText( $chk, 'Show Small Files' );

Sets the checkbox label text.

### `uiCheckboxOnToggled( ... )`

    uiCheckboxOnToggled( $chk, sub { my ($check, $data) = @_; }, undef );

Registers a callback for when the checkbox is toggled by the user.

The callback is not triggered when calling `uiCheckboxSetChecked( ... )`.

### `uiCheckboxChecked( ... )`

    my $on = uiCheckboxChecked( $chk );

Returns whether or the checkbox is checked.

### `uiCheckboxChecked( ... )`

    uiCheckboxSetChecked( $chk, 1 );

Sets whether or not the checkbox is checked.

### `uiNewCheckbox( ... )`

    my $chk = uiNewCheckbox( 'Save automatically' );

Creates a new checkbox.

## Entry Functions

An entry is a control with a single line text entry field.

You may import these functions with the `:entry` tag.

### `uiEntryText( ... )`

    my $text = uiEntryText( $field );

Returns the entry's text.

### `uiEntrySetText( ... )`

    uiEntrySetText( $field, 'Once upon a time ' );

Sets the entry's text.

### `uiEntryOnChanged( ... )`

    uiEntryOnChanged( $field, sub { my ($txt, $data) = @_; }, undef );

Registers a callback for when the user changes the entry's text.

The callback is not triggered when calling `uiEntrySetText( ... )`.

### `uiEntryReadOnly( ... )`

    my $ro = uiEntryReadOnly( $field );

Returns whether or not the entry's text can be changed. A true value if
readonly, otherwise false.

### `uiEntrySetReadOnly( ... )`

    uiEntrySetReadOnly( $field, 1 );

Sets whether or not the entry's text is read only.

### `uiNewEntry( )`

    my $field = uiNewEntry( );

Creates a new entry.

### `uiNewPasswordEntry( ... )`

    my $pass = uiNewPasswordEntry( );

Creates a new entry suitable for sensitive inputs like passwords.

The entered text is NOT readable by the user but masked as `*******`.

### `uiNewSearchEntry( ... )`

    my $search = uiNewSearchEntry();

Creates a new entry suitable for search.

Some systems will deliberately delay the `uiEntryOnChanged( ... )` callback
for a more natural feel.

## Label Functions

A label is a control that displays non-interactive text.

You may import these functions with the `:label` tag.

### `uiLabelText( ... )`

    my $text = uiLabelText( $label );

Returns the label text.

### `uiLabelSetText( ... )`

    uiLabelSetText( $label, 'Status: Okay' );

Sets the label text.

### `uiNewLabel( ... )`

    my $label = uiNewLabel( 'Status: Init' );

Creates a new label.

## Tab Functions

A tab represents a multi-page control interface that displays one page at a
time.

Each page/tab has an associated label that can be selected to switch between
pages/tabs.

### `uiTabAppend( ... )`

    uiTabAppend( $container, 'Home', $box_1 );

Appends a control in form of a page/tab with label.

### `uiTabInsertAt( ... )`

    uiTabInsertAt( $container, 'Advanced', 5, $box_2 );

Inserts a control in as a page/tab with label at `$index`.

### `uiTabDelete( ... )`

    uiTabDelete( $container, 5 );

Removes the control at `$index`.

### `uiTabNumPages( ... )`

    my $tabs = uiTabNumPages( $container );

Returns the number of pages contained.

### `uiTabMargined( ... )`

    my $comfortable = uiTabMargined( $container, 3 );

Returns whether or not the page/tab at `$index` has a margin.

### `uiTabSetMargined( ... )`

    uiTabSetMargined( $container, 3, 0 ); # where 3 is the inded and 0 is false

Sets whether or not the page/tab at `$index` has a margin.

The margin size is determined by the OS defaults.

### `uiNewTab( )`

    my $container = uiNewTab( );

Creates a new tab container.

## Group Functions

A group is a control container that adds a label to the contained child
control.

This control is a great way of grouping related controls in combination with
uiBox. A visual box will or will not be drawn around the child control
dependent on the underlying OS implementation.

You may import these functions with the `:group` tag.

### `uiGroupTitle( ... )`

    my $title = uiGroupTitle( $group );

Returns the group title.

### `uiGroupSetTitle( ... )`

    uiGroupSetTitle( $group, 'Subscriptions' );

Sets the group title.

### `uiGroupSetChild( ... )`

    uiGroupSetChild( $group $box );

Sets the group's child.

### `uiGroupMargined( ... )`

    my $comfortable = uiGroupMargined( $group );

Returns whether or not the group has a margin.

### `uiGroupSetMargined( ... )`

    uiGroupSetMargined( $group, 1 );

Sets whether or not the group has a margin.

The margin size is determined by the OS defaults.

### `uiNewGroup( ... )`

    my $group = uiNewGroup( 'Introduction' );

Creates a new group.

## Spinbox Functions

A spinbox is a control to display and modify integer values via a text field or
\+/- buttons.

This is a convenient control for having the user enter integer values. Values
are guaranteed to be within the specified range.

The + button increases the held value by 1.

The - button decreased the held value by 1.

Entering a value out of range will clamp to the nearest value in range.

You may import these functions with the `:spinbox` tag.

### `uiSpinboxValue( ... )`

    my $value = uiSpinboxValue( $spinner );

Returns the spinbox value.

### `uiSpinboxSetValue( ... )`

    uiSpinboxSetValue( $spinner, 30 );

Sets the spinbox value.

Setting a value out of range will clamp to the nearest value in range.

### `uiSpinboxOnChanged( ... )`

    uiSpinboxOnChanged( $spinner, sub { my ($spin, $user_data) = @_; }, undef );

Registers a callback for when the spinbox value is changed by the user.

The callback is not triggered when calling `uiSpinboxSetValue( ... )`.

### `uiNewSpinbox( ... )`

    my $spinner = uiNewSpinbox( 1, 100 );

Creates a new spinbox.

The initial spinbox value equals the minimum value.

In the current implementation upstream, `$min` and `$max` are swapped if
`$min` is greater than `$max`. This may change in the future though.

## Slider Functions

A slider is a control to display and modify integer values via a user draggable
slider.

Values are guaranteed to be within the specified range.

Sliders by default display a tool tip showing the current value when being
dragged.

Sliders are horizontal only.

You may import these functions with the `:slider` tag.

### `uiSliderValue( ... )`

    my $value = uiSliderValue( $slider );

Returns the slider value.

### `uiSliderSetValue( ... )`

    uiSliderSetValue( $slider, 59 );

Sets the slider value.

### `uiSliderHasToolTip( ... )`

    my $enabled = uiSliderHasToolTip( $slider );

Returns whether or not the slider has a tool tip.

### `uiSliderSetHasToolTip( ... )`

    uiSliderSetHasToolTip( $slider, 1 );

Sets whether or not the slider has a tool tip.

### `uiSliderOnChanged( ... )`

    uiSliderOnChanged( $slider, sub { my ($sl, $user_data) = @_; }, undef );

Registers a callback for when the slider value is changed by the user.

The callback is not triggered when calling `uiSliderSetValue( ... )`.

### `uiSliderOnReleased( ... )`

    uiSliderOnReleased( $slider, sub { my ($sl, $user_data) = @_; }, undef );

Registers a callback for when the slider is released from dragging.

### `uiSliderSetRange( ... )`

    uiSliderSetRange( $slider, 1, 500 );

Sets the slider range.

Make sure to clamp the slider value to the nearest value in range - should it
be out of range. Manually call `uiSliderOnChanged( ... )`'s callback in such a
case.

### `uiNewSlider( ... )`

    my $slider = uiNewSlider( 1, 100 );

Creates a new slider.

The initial slider value equals the minimum value.

In the current implementation upstream, `$min` and `$max` are swapped if
`$min` is greater than `$max`. This may change in the future though.

## ProgressBar Functions

A ProgressBar is a control that visualizes the progress of a task via the fill
level of a horizontal bar.

Indeterminate values are supported via an animated bar.

### `uiProgressBarValue( ... )`

    my $value = uiProgressBarValue( $bar );

Returns the progress bar value.

### `uiProgressBarSetValue( ... )`

    uiProgressBarSetValue( $bar, 100 );

Sets the progress bar value.

Valid values are `[0 .. 100]` for displaying a solid bar imitating a percent
value.

Use a value of `-1` to render an animated bar to convey an indeterminate
value.

### `uiNewProgressBar( )`

Creates a new progress bar.

## Separator Functions

A separator is a control to visually separate controls, horizontally or
vertically.

Import these functions with the `:separator` tag.

### `uiNewHorizontalSeparator( )`

    my $hsplit = uiNewHorizontalSeparator( );

Creates a new horizontal separator.

### `uiNewVerticalSeparator( )`

    my $hsplit = uiNewVerticalSeparator( );

Creates a new vertical separator.

## Combobox Functions

A combobox is a control to select one item from a predefined list of items via
a drop down menu.

You may import these functions with the `:combobox` tag.

### `uiComboboxAppend( ... )`

    uiComboboxAppend( $combo, 'Candy' );

Appends an item to the combo box.

### `uiComboboxInsertAt( ... )`

    uiComboboxInsertAt( $combo, 4, 'Salty snacks' );

Inserts an item at `$index` to the combo box.

### `uiComboboxDelete( ... )`

    uiComboboxDelete( $combo, 4 );

Deletes an item at `$index` from the combo box.

Deleting the index of the item currently selected will move the selection to
the next item in the combo box or `-1` if no such item exists.

### `uiComboboxClear( ... )`

    uiComboboxClear( $combo );

Deletes all items from the combo box.

### `uiComboboxNumItems( ... )`

    my $options = uiComboboxNumItems( $combo );

Returns the number of items contained within the combo box.

### `uiComboboxSelected( ... )`

    my $current = uiComboboxSelected( $combo );

Returns the index of the item selected or `-1` on empty selection.

### `uiComboboxSetSelected( ... )`

    uiComboboxSetSelected( $combo, 2 );

Sets the item selected. `-1` to clear selection.

### `uiComboboxOnSelected( ... )`

    uiComboboxOnSelected( $combo, sub { my ($c, $user_data) = @_; }, undef );

Registers a callback for when a combo box item is selected.

The callback is not triggered when calling `uiComboboxSetSelected( ... )`,
`uiComboboxInsertAt( ... )`, `uiComboboxDelete( ... )`, or `uiComboboxClear(
... )`.

### `uiNewCombobox( )`

    my $combo = uiNewCombobox( );

Creates a new combo box.

## Editable Combobox Functions

An editable combobox is a control to select one item from a predefined list of
items or enter ones own.

Predefined items can be selected from a drop down menu.

A customary item can be entered by the user via an editable text field.

You may import these functions with the `:editablecombobox` tag.

### `uiEditableComboboxAppend( ... )`

    uiEditableComboboxAppend( $combo, 'Fire' );

Appends an item to the editable combo box.

### `uiEditableComboboxText( ... )`

    my $text = uiEditableComboboxText( $combo );

Returns the text of the editable combo box.

This text is either the text of one of the predefined list items or the text
manually entered by the user.

### `uiEditableComboboxSetText( ... )`

    uiEditableComboboxSetText( $combo, "Floating" );

Sets the editable combo box text.

### `uiEditableComboboxOnChanged( )`

    uiEditableComboboxOnChanged( $combo, sub { my ($cb, user_data) = @_; }, undef );

Registers a callback for when an editable combo box item is selected or user
text changed.

The callback is not triggered when calling `uiEditableComboboxSetText( ... )`.

### `uiNewEditableCombobox( )`

    my $combo = uiNewEditableCombobox( );

Creates a new editable combo box.

# Requirements

[Affix](https://metacpan.org/pod/Affix) and [Alien::libui](https://metacpan.org/pod/Alien%3A%3Alibui)

# See Also

`eg/demo.pl` - Very basic example

`eg/widgets.pl` - Demo of basic controls

# LICENSE

Copyright (C) Sanko Robinson.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

# AUTHOR

Sanko Robinson <sanko@cpan.org>
