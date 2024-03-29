package LibUI 1.00 {
    use strict;
    use warnings;
    use Affix;
    use Alien::libui;
    my $lib = Alien::libui->dynamic_libs;
    use Exporter 'import';
    our %EXPORT_TAGS = (
        default => [
            'uiInit',      'uiUninit',   'uiFreeInitError', 'uiMain',
            'uiMainSteps', 'uiMainStep', 'uiQuit',          'uiQueueMain',
            'uiTimer',     'uiOnShouldQuit'
        ],
        control => [
            'uiControlDestroy',       'uiControlHandle',
            'uiControlParent',        'uiControlSetParent',
            'uiControlToplevel',      'uiControlVisible',
            'uiControlShow',          'uiControlHide',
            'uiControlEnabled',       'uiControlEnable',
            'uiControlDisable',       'uiAllocControl',
            'uiFreeControl',          'uiControlVerifySetParent',
            'uiControlEnabledToUser', 'uiUserBugCannotSetParentOnToplevel'
        ],
        window => [
            'uiWindowTitle',             'uiWindowSetTitle',
            'uiWindowPosition',          'uiWindowSetPosition',
            'uiWindowOnPositionChanged', 'uiWindowContentSize',
            'uiWindowSetContentSize',    'uiWindowFullscreen',
            'uiWindowSetFullscreen',     'uiWindowOnContentSizeChanged',
            'uiWindowOnClosing',         'uiWindowOnFocusChanged',
            'uiWindowFocused',           'uiWindowBorderless',
            'uiWindowSetBorderless',     'uiWindowSetChild',
            'uiWindowMargined',          'uiWindowSetMargined',
            'uiWindowResizeable',        'uiWindowSetResizeable',
            'uiNewWindow'
        ],
        button => [ 'uiButtonText', 'uiButtonSetText', 'uiButtonOnClicked', 'uiNewButton' ],
        box    => [
            'uiBoxAppend',    'uiBoxNumChildren',   'uiBoxDelete', 'uiBoxPadded',
            'uiBoxSetPadded', 'uiNewHorizontalBox', 'uiNewVerticalBox'
        ],
        checkbox => [
            'uiCheckboxText',       'uiCheckboxSetText',
            'uiCheckboxOnToggled',  'uiCheckboxChecked',
            'uiCheckboxSetChecked', 'uiNewCheckbox'
        ],
        entry => [
            'uiEntryText',        'uiEntrySetText', 'uiEntryOnChanged',   'uiEntryReadOnly',
            'uiEntrySetReadOnly', 'uiNewEntry',     'uiNewPasswordEntry', 'uiNewSearchEntry'
        ],
        label => [ 'uiLabelText', 'uiLabelSetText', 'uiNewLabel' ],
        tab   => [
            'uiTabAppend',   'uiTabInsertAt',    'uiTabDelete', 'uiTabNumPages',
            'uiTabMargined', 'uiTabSetMargined', 'uiNewTab'
        ],
        group => [
            'uiGroupTitle',       'uiGroupSetTitle', 'uiGroupSetChild', 'uiGroupMargined',
            'uiGroupSetMargined', 'uiNewGroup'
        ],
        spinbox => [ 'uiSpinboxValue', 'uiSpinboxSetValue', 'uiSpinboxOnChanged', 'uiNewSpinbox' ],
        slider  => [
            'uiSliderValue',             'uiSliderSetValue',
            'uiSliderHasToolTip',        'uiSliderSetHasToolTip',
            'uiSliderOnChangeduiSlider', 'uiSliderOnReleased',
            'uiSliderSetRange',          'uiNewSlider'
        ],
        progressbar => [ 'uiProgressBarValue', 'uiProgressBarSetValue', 'uiNewProgressBar' ],
        separator   => [ 'uiNewHorizontalSeparator', 'uiNewVerticalSeparator' ],
        combobox    => [
            'uiComboboxAppend',      'uiComboboxInsertAt',
            'uiComboboxDelete',      'uiComboboxClear',
            'uiComboboxNumItems',    'uiComboboxSelected',
            'uiComboboxSetSelected', 'uiComboboxOnSelected',
            'uiNewCombobox',
        ],
        editablecombobox => [
            'uiEditableComboboxAppend',  'uiEditableComboboxText',
            'uiEditableComboboxSetText', 'uiEditableComboboxOnChanged',
            'uiNewEditableCombobox'
        ]
    );
    {
        my %seen;
        push @{ $EXPORT_TAGS{control} }, grep { !$seen{$_}++ } @{ $EXPORT_TAGS{$_} }
            for 'window', 'button', 'box', 'checkbox', 'entry', 'label', 'tab', 'group', 'spinbox',
            'slider', 'progressbar', 'separator', 'combobox', 'editablecombobox';
    }
    {
        my %seen;
        push @{ $EXPORT_TAGS{all} }, grep { !$seen{$_}++ } @{ $EXPORT_TAGS{$_} }
            for keys %EXPORT_TAGS;
    }
    our @EXPORT_OK = @{ $EXPORT_TAGS{all} };

    #~ use Data::Dump;
    #~ ddx \@EXPORT_OK;
    #~ ddx \%EXPORT_TAGS;

=pod

=encoding utf-8

=head1 NAME

LibUI - Simple, Portable, Native GUI Library

=head1 SYNOPSIS

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

=begin html

<h2>Screenshots</h2> <div style="text-align: center"> <h3>Linux</h3><img
alt="Linux"
src="https://sankorobinson.com/LibUI.pm/screenshots/synopsis/linux.png" />
<h3>MacOS</h3><img alt="MacOS"
src="https://sankorobinson.com/LibUI.pm/screenshots/synopsis/macos.png" />
<h3>Windows</h3><img alt="Windows"
src="https://sankorobinson.com/LibUI.pm/screenshots/synopsis/windows.png" />
</div>

=end html

=head1 DESCRIPTION

LibUI is a simple and portable (but not inflexible) GUI library in C that uses
the native GUI technologies of each platform it supports.

This distribution is under construction. It works but is incomplete.

=head1 Functions

LibUI, keeping with the ethos of simplicity, is functional.

You may import any of them by name or with their given import tags.

=head2 Default Functions

These are basic functions to get the UI started and may be imported with the
C<:default> tag.

=head3 C<uiInit( ... )>

    my $err = uiInit({ Size => 0 });

Ask LibUI to do all the platform specific work to get up and running. If LibUI
fails to initialize itself, this will return a string. Weird upstream choice, I
know...

You B<must> call this before creating widgets.

=cut

    typedef 'LibUI::InitOptions' => Struct [ Size => Size_t ];
    affix $lib, 'uiInit', [ Pointer [ Type ['LibUI::InitOptions'] ] ] => Str;

=head3 C<uiUninit( )>

    uiUninit( );

Ask LibUI to break everything down before quitting.

=cut

    affix $lib, 'uiUninit', [] => Void;

=begin private

=head3 C<uiFreeInitError( ... )>

    uiFreeInitError( $err );

Frees the string returned when C<uiInit( ... )> fails.

=end private

=cut

    affix $lib, 'uiFreeInitError', [Char] => Void;

=head3 C<uiMain( )>

    uiMain( );

Let LibUI's event loop run until interrupted.

=cut

    affix $lib, 'uiMain', [] => Void;

=head3 C<uiMainSteps( )>

    uiMainSteps( );

You may call this instead of C<uiMain( )> if you want to run the main loop
yourself.

=cut

    affix $lib, 'uiMainSteps', [] => Void;

=head3 C<uiMainStep( ... )>

    my $ok = uiMainStep( 1 );

Runs one iteration of the main loop.

It takes a single boolean argument indicating whether to wait for an even to
occur or not.

It returns true if an event was processed (or if no even is available if you
don't wish to wait) and false if the event loop was told to stop (for instance,
C<uiQuit()> was called).

=cut

    affix $lib, 'uiMainStep', [Int] => Int;

=head3 C<uiQuit( )>

    uiQuit( );

Signals LibUI that you are ready to quit.

=cut

    affix $lib, 'uiQuit', [] => Void;

=head3 C<uiQueueMain( )>

    uiQueueMain( sub { }, $values );

Trigger a callback on the main thread from any other thread. This is likely
unstable. It's for sure untested as long as perl threads are garbage.

=cut

    affix $lib, 'uiQueueMain', [ CodeRef [ [ Pointer [SV] ] => Void ], Pointer [SV] ] => Void;

=head3 C<uiTimer( ... )>

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

=over

=item C<$time>

Time in milliseconds.

=item C<$func>

CodeRef that will be triggered when C<$time> runs out.

Return a true value from your C<$func> to make your timer repeating.

=item C<$data>

Any userdata you feel like passing. It'll be handed off to your function.

=back

=cut

    affix $lib, 'uiTimer', [ Int, CodeRef [ [ Pointer [SV] ] => Int ], Pointer [SV] ] => Void;

=head3 C<uiOnShouldQuit( ... )>

    uiOnShouldQuit( sub {}, undef );

Callback triggered when the GUI is prepared to quit.

Expected parameters include:

=over

=item C<$func>

CodeRef that will be triggered.

=item C<$user_data>

User data passed to the callback.

=back

=cut

    affix $lib, 'uiOnShouldQuit', [ CodeRef [ [ Pointer [SV] ] => Int ], Pointer [SV] ] => Void;

=head3 C<uiFreeText( ... )>

    uiFreeText( $title );

Free a string with LibUI.

=cut

    affix $lib, 'uiFreeText', [Str] => Void;

=head2 Control Functions

These functions may be used by all subclasses of the base control.

Import them with the C<:control> tag.

=cut

    # Base class for GUI controls providing common methods.
    typedef 'LibUI::Control' => Pointer [
        Void

            #~ Struct [
            #~ signature      => UInt,
            #~ os_signature   => UInt,
            #~ type_signature => UInt,
            #~ destroy        => Pointer [Void],
            #~ handle         => Pointer [Void],
            #~ parent         => Pointer [Void],
            #~ set_parent     => Pointer [Void],
            #~ top_level      => Int,
            #~ visible        => Int,
            #~ show           => Pointer [Void],
            #~ hide           => Pointer [Void],
            #~ enabled        => Int,
            #~ enable         => Pointer [Void],
            #~ disable        => Pointer [Void]
            #~ ]
    ];

=head3 C<uiControlDestroy( ... )>

    uiControlDestroy( $button );

Dispose and free all allocated resources related to a control.

=cut

    affix $lib, 'uiControlDestroy', [ Type ['LibUI::Control'] ] => Void;

=head3 C<uiControlHandle( ... )>

    my $ptr = uiControlHandle( $button );

Returns the control's OS-level handle.

=cut

    affix $lib, 'uiControlHandle', [ Type ['LibUI::Control'] ] => Pointer [Void];

=head3 C<uiControlParent( ... )>

    my $window = uiControlParent( $button );

Returns the parent control.

=cut

    affix $lib, 'uiControlParent', [ Type ['LibUI::Control'] ] => Type ['LibUI::Control'];

=head3 C<uiControlSetParent( ... )>

    my $ptr = uiControlSetParent( $button, $window );

Sets the control's parent.

=cut

    affix $lib, 'uiControlSetParent', [ Type ['LibUI::Control'], Type ['LibUI::Control'] ] => Void;

=head3 C<uiControlToplevel( ... )>

    my $top = uiControlToplevel( $window );

Returns whether or not the control is a top level control.

=cut

    affix $lib, 'uiControlToplevel', [ Type ['LibUI::Control'] ] => Bool;

=head3 C<uiControlVisible( ... )>

    my $visible = uiControlVisible( $label );

Returns whether or not the control is visible.

=cut

    affix $lib, 'uiControlVisible', [ Type ['LibUI::Control'] ] => Bool;

=head3 C<uiControlShow( ... )>

    uiControlShow( $window );

Shows the control.

=cut

    affix $lib, 'uiControlShow', [ Type ['LibUI::Control'] ] => Void;

=head3 C<uiControlHide( ... )>

    uiControlHide( $label );

Hides the control.

Hidden controls do not take up space within the layout.

=cut

    affix $lib, 'uiControlHide', [ Type ['LibUI::Control'] ] => Void;

=head3 C<uiControlEnabled( ... )>

    my $enabled = uiControlEnabled( $label );

Returns whether or not the control is enabled.

=cut

    affix $lib, 'uiControlEnabled', [ Type ['LibUI::Control'] ] => Bool;

=head3 C<uiControlEnable( ... )>

    uiControlEnable( $label );

Enables the control.

=cut

    affix $lib, 'uiControlEnable', [ Type ['LibUI::Control'] ] => Void;

=head3 C<uiControlDisable( ... )>

    uiControlDisable( $label );

Disables the control.

=cut

    affix $lib, 'uiControlDisable', [ Type ['LibUI::Control'] ] => Void;

=head3 C<uiAllocControl( ... )>

    uiAllocControl( $label );

Allocates a new custom C<uiControl>.

Expected parameters include:

=over

=item C<$n>

Size of the control (in bytes).

=item C<$OSsig>

=item C<$typesig>

=item C<$typename>

Name of the type as a string.

=back

This function is undocumented upstream.

=cut

    affix $lib, 'uiAllocControl', [ Size_t, UInt, UInt, Str ] => Type ['LibUI::Control'];

=head3 C<uiFreeControl( ... )>

    uiFreeControl( $button );

Frees a control.

=cut

    affix $lib, 'uiFreeControl', [ Type ['LibUI::Control'] ] => Void;

=head3 C<uiControlVerifySetParent( ... )>

    uiControlVerifySetParent( $button, $window );

Makes sure the control's parent can be set to parent.

=cut

    affix $lib, 'uiControlVerifySetParent',
        [ Type ['LibUI::Control'], Type ['LibUI::Control'] ] => Void;

=head3 C<uiControlEnabledToUser( ... )>

    my $enabled = uiControlEnabledToUser( $label );

Returns whether or not the control can be interacted with by the user.

Checks if the control and all its parents are enabled to make sure it can be
interacted with by the user.

=cut

    affix $lib, 'uiControlEnabledToUser', [ Type ['LibUI::Control'] ] => Bool;

=begin private

=head3 C<uiControlEnabledToUser( ... )>

    my $enabled = uiControlEnabledToUser( $label );

Returns whether or not the control can be interacted with by the user.

Checks if the control and all its parents are enabled to make sure it can be
interacted with by the user.

=end private

=cut

    affix $lib, 'uiUserBugCannotSetParentOnToplevel', [Str] => Void;

=head2 Window Functions

A window control that represents a top-level window.

A window contains exactly one child control that occupies the entire window and
cannot be a child of another control.

These functions may be imported with the C<:window> tag.

=cut

    typedef 'LibUI::Window' => Pointer [
        Struct [
            c         => Pointer [Void],
            w         => Pointer [Void],
            child     => Type ['LibUI::Control'],
            onClosing => Pointer [Void]
        ]
    ];

=head3 C<uiWindowTitle( ... )>

    my $title = uiWindowTitle( $window );

Returns the window title.

=cut

    affix $lib, 'uiWindowTitle', [ Type ['LibUI::Window'] ] => Str;

=head3 C<uiWindowSetTitle( ... )>

    uiWindowSetTitle( $window, 'Petris 1.0' );

Sets the window title.

=cut

    affix $lib, 'uiWindowSetTitle', [ Type ['LibUI::Window'], Str ] => Void;

=head3 C<uiWindowPosition( ... )>

    uiWindowPosition( $window, my $x, my $y );

Gets the window position.

Coordinates are measured from the top left corner of the screen. This method
may return inaccurate or dummy values on X11.


=cut

    affix $lib, 'uiWindowPosition',
        [ Type ['LibUI::Window'], Pointer [Int], Pointer [Int] ] => Void;

=head3 C<uiWindowSetPosition( ... )>

    uiWindowSetPosition( $window, 300, 50 );

Moves the window to the specified position.

Coordinates are measured from the top left corner of the screen. This method is
merely a hint and may be ignored on X11.

=cut

    affix $lib, 'uiWindowSetPosition', [ Type ['LibUI::Window'], Int, Int ] => Void;

=head3 C<uiWindowOnPositionChanged( ... )>

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

=over

=item C<$window>

The window to bind.

=item C<$code_ref>

Code reference that should expect a reference back to the instance that
triggered the callback and user data registered with the sender instance.

=item C<$user_data>

Whatever you feel like passing along.

=back

The callback is not triggered when calling C<uiWindowSetPosition( ... )>.

=cut

    affix $lib, 'uiWindowOnPositionChanged',
        [
        Type ['LibUI::Window'],
        CodeRef [ [ Type ['LibUI::Window'], Pointer [SV] ] => Void ],
        Pointer [SV]
        ] => Void;

=head3 C<uiWindowContentSize( ... )>

    uiWindowContentSize( $window, my $w, my $h );

Gets the window content size.

The content size does NOT include window decorations like menus or title bars.

=cut

    affix $lib, 'uiWindowContentSize',
        [ Type ['LibUI::Window'], Pointer [Int], Pointer [Int] ] => Void;

=head3 C<uiWindowSetContentSize( ... )>

    uiWindowSetContentSize( $window, 500, 100 );

Sets the window content size.

The content size does NOT include window decorations like menus or title bars.

This method is merely a hint and may be ignored by the system.

=cut

    affix $lib, 'uiWindowSetContentSize', [ Type ['LibUI::Window'], Int, Int ] => Void;

=head3 C<uiWindowFullscreen( ... )>

    my $full = uiWindowFullscreen( $window );

Returns whether or not the window is full screen.

=cut

    affix $lib, 'uiWindowFullscreen', [ Type ['LibUI::Window'] ] => Bool;

=head3 C<uiWindowSetFullscreen( ... )>

    uiWindowSetFullscreen( $window, 1 );

Sets whether or not the window is full screen.

This method is merely a hint and may be ignored by the system.

=cut

    affix $lib, 'uiWindowSetFullscreen', [ Type ['LibUI::Window'], Bool ] => Void;

=head3 C<uiWindowOnContentSizeChanged( ... )>

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

=over

=item C<$window>

The window to bind.

=item C<$code_ref>

Code reference that should expect a reference back to the instance that
triggered the callback and user data registered with the sender instance.

=item C<$user_data>

Whatever you feel like passing along.

=back

The callback is not triggered when calling C<uiWindowSetContentSize( ... )>.

=cut

    affix $lib, 'uiWindowOnContentSizeChanged',
        [
        Type ['LibUI::Window'],
        CodeRef [ [ Type ['LibUI::Window'], Pointer [SV] ] => Void ],
        Pointer [SV]
        ] => Void;

=head3 C<uiWindowOnClosing( ... )>

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

=over

=item C<$window>

The window to bind.

=item C<$code_ref>

Code reference that should expect a reference back to the instance that
triggered the callback and user data registered with the sender instance.

Return a true value to destroy the window. Return an untrue value to abort
closing and keep the window alive and visible.

=item C<$user_data>

Whatever you feel like passing along.

=back

The callback is not triggered when calling C<uiWindowSetContentSize( ... )>.

=cut

    affix $lib, 'uiWindowOnClosing',
        [
        Type ['LibUI::Window'],
        CodeRef [ [ Type ['LibUI::Window'], Pointer [SV] ] => Bool ],
        Pointer [SV]
        ] => Void;

=head3 C<uiWindowOnFocusChanged( ... )>

    uiWindowOnFocusChanged(
        $w,
        sub {
            say LibUI::uiWindowFocused($w) ? 'in focus' : 'lost focus';
        },
        undef
    );

Registers a callback for when the window focus changes.

Expected parameters include:

=over

=item C<$window>

The window to bind.

=item C<$code_ref>

Code reference that should expect a reference back to the instance that
triggered the callback and user data registered with the sender instance.

=item C<$user_data>

Whatever you feel like passing along.

=back

=cut

    affix $lib, 'uiWindowOnFocusChanged',
        [
        Type ['LibUI::Window'],
        CodeRef [ [ Type ['LibUI::Window'], Pointer [SV] ] => Void ],
        Pointer [SV]
        ] => Void;

=head3 C<uiWindowFocused( ... )>

    my $in_focus = uiWindowFocused( $w );

Returns whether or not the window is focused.

=cut

    affix $lib, 'uiWindowFocused', [ Type ['LibUI::Window'] ] => Bool;

=head3 C<uiWindowBorderless( ... )>

    my $no_border = uiWindowBorderless( $w );

Returns whether or not the window is borderless.

=cut

    affix $lib, 'uiWindowBorderless', [ Type ['LibUI::Window'] ] => Bool;

=head3 C<uiWindowSetBorderless( ... )>

    uiWindowSetBorderless( $w, 1 );

Sets whether or not the window is borderless.

This method is merely a hint and may be ignored by the system.

=cut

    affix $lib, 'uiWindowSetBorderless', [ Type ['LibUI::Window'], Bool ] => Void;

=head3 C<uiWindowSetChild( ... )>

    uiWindowSetChild( $w, $box );

Sets the window's child.

=cut

    affix $lib, 'uiWindowSetChild', [ Type ['LibUI::Window'], Type ['LibUI::Control'] ] => Void;

=head3 C<uiWindowMargined( ... )>

    my $comfortable = uiWindowMargined( $w );

Returns whether or not the window has a margin.

=cut

    affix $lib, 'uiWindowMargined', [ Type ['LibUI::Window'] ] => Bool;

=head3 C<uiWindowSetMargined( ... )>

    uiWindowSetMargined( $w, 1 );

Sets whether or not the window has a margin.

The margin size is determined by the OS defaults.

=cut

    affix $lib, 'uiWindowSetMargined', [ Type ['LibUI::Window'], Bool ] => Void;

=head3 C<uiWindowResizeable( ... )>

    my $resizable = uiWindowResizeable( $w );

Returns whether or not the window is user resizable.

=cut

    affix $lib, 'uiWindowResizeable', [ Type ['LibUI::Window'] ] => Bool;

=head3 C<uiWindowSetResizeable( ... )>

    uiWindowSetResizeable( $w, 1 );

Sets whether or not the window is user resizable.

The margin size is determined by the OS defaults.

=cut

    affix $lib, 'uiWindowSetResizeable', [ Type ['LibUI::Window'], Bool ] => Void;

=head3 C<uiNewWindow( ... )>

Creates a new uiWindow.

Expected parameters include:

=over

=item C<$title>

Window title.

=item C<$width>

Window width in pixels.

=item C<$height>

Window height in pixels.

=item C<$hasMenubar>

Whether or not the window should display a menu bar.

=back

=cut

    affix $lib, 'uiNewWindow', [ Str, Int, Int, Int ] => InstanceOf ['LibUI::Window'];

=head2 Button Functions

These functions create and wrap a control that visually represents a button to
be clicked by the user to trigger an action.

Import these functions with the C<:button> tag.

=cut

    typedef 'LibUI::Button' => Type ['LibUI::Control'];

=head3 C<uiButtonText( ... )>

    my $label = uiButtonText( $button );

Returns the button label text.

=cut

    affix $lib, 'uiButtonText', [ Type ['LibUI::Button'] ] => Str;

=head3 C<uiButtonSetText( ... )>

    uiButtonSetText( $button, 'Click again' );

Sets the button label text.

=cut

    affix $lib, 'uiButtonSetText', [ Type ['LibUI::Button'], Str ] => Void;

=head3 C<uiButtonOnClicked( ... )>

    uiButtonOnClicked( $button, sub { my ($btn, data) = @_; }, undef );

Registers a callback for when the button is clicked.

=cut

    affix $lib, 'uiButtonOnClicked',
        [
        Type ['LibUI::Button'],
        CodeRef [ [ Type ['LibUI::Button'], Pointer [SV] ] => Void ],
        Pointer [SV]
        ] => Void;

=head3 C<uiNewButton( ... )>

    my $button = uiNewButton( 'Click me' );

Creates a new button.

Expected parameters include:

=over

=item C<$label>

=back

=cut

    affix $lib, 'uiNewButton', [Str] => Type ['LibUI::Button'];

=head2 Box Functions

These functions wrap a boxlike container that holds a group of controls.

The contained controls are arranged to be displayed either horizontally or
vertically next to each other.

You may import these functions with the C<:box> tag.

=cut

    typedef 'LibUI::Box' => Type ['LibUI::Control'];

=head3 C<uiBoxAppend( ... )>

    uiBoxAppend( $box, $child, 1 );

Appends a control to the box.

Stretchy items expand to use the remaining space within the box. In the case of
multiple stretchy items the space is shared equally.

Expected parameters include:

=over

=item C<$box>

=item C<$child>

=item C<$stretchy>

True value to stretch the child, otherwise false.

=back

=cut

    affix $lib, 'uiBoxAppend', [ Type ['LibUI::Box'], Type ['LibUI::Control'], Bool ] => Void;

=head3 C<uiBoxNumChildren( ... )>

    my $kids = uiBoxNumChildren( $box );

Returns the number of controls contained within the box.

=cut

    affix $lib, 'uiBoxNumChildren', [ Type ['LibUI::Box'] ] => Int;

=head3 C<uiBoxDelete( ... )>

    uiBoxDelete( $box, 3 );

Removes the control at a given index from the box.

=cut

    affix $lib, 'uiBoxDelete', [ Type ['LibUI::Box'], Int ] => Void;

=head3 C<uiBoxPadded( ... )>

    my $comfortable = uiBoxPadded( $box );

Returns whether or not controls within the box are padded.

Padding is defined as space between individual controls.

=cut

    affix $lib, 'uiBoxPadded', [ Type ['LibUI::Box'] ] => Bool;

=head3 C<uiBoxSetPadded( ... )>

    uiBoxSetPadded( $box, 1 );

Sets whether or not controls within the box are padded.

Padding is defined as space between individual controls. The padding size is
determined by the OS defaults.

=cut

    affix $lib, 'uiBoxSetPadded', [ Type ['LibUI::Box'], Int ] => Void;

=head3 C<uiNewHorizontalBox( )>

    uiNewHorizontalBox( );

Creates a new horizontal box.

Controls within the box are placed next to each other horizontally.

=cut

    affix $lib, 'uiNewHorizontalBox', [] => Type ['LibUI::Box'];

=head3 C<uiNewVerticalBox( )>

    my $vbox = uiNewVerticalBox( );

Creates a new vertical box.

Controls within the box are placed next to each other vertically.

=cut

    affix $lib, 'uiNewVerticalBox', [] => Type ['LibUI::Box'];

=head2 Checkbox Functions

The functions wrap a control with a user checkable box accompanied by a text
label.

You may import them with the C<:checkbox> tag.

=cut

    typedef 'LibUI::Checkbox' => Type ['LibUI::Control'];

=head3 C<uiCheckboxText( ... )>

    my $label = uiCheckboxText( $chk );

Returns the checkbox label text.

=cut

    affix $lib, 'uiCheckboxText', [ Type ['LibUI::Checkbox'] ] => Str;

=head3 C<uiCheckboxSetText( ... )>

    uiCheckboxSetText( $chk, 'Show Small Files' );

Sets the checkbox label text.

=cut

    affix $lib, 'uiCheckboxSetText', [ Type ['LibUI::Checkbox'], Str ] => Void;

=head3 C<uiCheckboxOnToggled( ... )>

    uiCheckboxOnToggled( $chk, sub { my ($check, $data) = @_; }, undef );

Registers a callback for when the checkbox is toggled by the user.

The callback is not triggered when calling C<uiCheckboxSetChecked( ... )>.

=cut

    affix $lib, 'uiCheckboxOnToggled',
        [
        Type ['LibUI::Checkbox'],
        CodeRef [ [ Type ['LibUI::Checkbox'], Pointer [SV] ] => Void ],
        Pointer [SV]
        ] => Void;

=head3 C<uiCheckboxChecked( ... )>

    my $on = uiCheckboxChecked( $chk );

Returns whether or the checkbox is checked.

=cut

    affix $lib, 'uiCheckboxChecked', [ Type ['LibUI::Checkbox'] ] => Bool;

=head3 C<uiCheckboxChecked( ... )>

    uiCheckboxSetChecked( $chk, 1 );

Sets whether or not the checkbox is checked.

=cut

    affix $lib, 'uiCheckboxSetChecked', [ Type ['LibUI::Checkbox'], Bool ] => Void;

=head3 C<uiNewCheckbox( ... )>

    my $chk = uiNewCheckbox( 'Save automatically' );

Creates a new checkbox.

=cut

    affix $lib, 'uiNewCheckbox', [Str] => Type ['LibUI::Checkbox'];

=head2 Entry Functions

An entry is a control with a single line text entry field.

You may import these functions with the C<:entry> tag.

=cut

    typedef 'LibUI::Entry'         => Type ['LibUI::Control'];
    typedef 'LibUI::PasswordEntry' => Type ['LibUI::Entry'];
    typedef 'LibUI::SearchEntry'   => Type ['LibUI::Entry'];

=head3 C<uiEntryText( ... )>

    my $text = uiEntryText( $field );

Returns the entry's text.

=cut

    affix $lib, 'uiEntryText', [ Type ['LibUI::Entry'] ] => Str;

=head3 C<uiEntrySetText( ... )>

    uiEntrySetText( $field, 'Once upon a time ' );

Sets the entry's text.

=cut

    affix $lib, 'uiEntrySetText', [ Type ['LibUI::Entry'], Str ] => Void;

=head3 C<uiEntryOnChanged( ... )>

    uiEntryOnChanged( $field, sub { my ($txt, $data) = @_; }, undef );

Registers a callback for when the user changes the entry's text.

The callback is not triggered when calling C<uiEntrySetText( ... )>.

=cut

    affix $lib, 'uiEntryOnChanged',
        [
        Type ['LibUI::Entry'],
        CodeRef [ [ Type ['LibUI::Entry'], Pointer [SV] ] => Void ],
        Pointer [SV]
        ] => Void;

=head3 C<uiEntryReadOnly( ... )>

    my $ro = uiEntryReadOnly( $field );

Returns whether or not the entry's text can be changed. A true value if
readonly, otherwise false.

=cut

    affix $lib, 'uiEntryReadOnly', [ Type ['LibUI::Entry'] ] => Bool;

=head3 C<uiEntrySetReadOnly( ... )>

    uiEntrySetReadOnly( $field, 1 );

Sets whether or not the entry's text is read only.

=cut

    affix $lib, 'uiEntrySetReadOnly', [ Type ['LibUI::Entry'], Bool ] => Void;

=head3 C<uiNewEntry( )>

    my $field = uiNewEntry( );

Creates a new entry.

=cut

    affix $lib, 'uiNewEntry', [] => Type ['LibUI::Entry'];

=head3 C<uiNewPasswordEntry( ... )>

    my $pass = uiNewPasswordEntry( );

Creates a new entry suitable for sensitive inputs like passwords.

The entered text is NOT readable by the user but masked as C<*******>.

=cut

    affix $lib, 'uiNewPasswordEntry', [] => Type ['LibUI::PasswordEntry'];

=head3 C<uiNewSearchEntry( ... )>

    my $search = uiNewSearchEntry();

Creates a new entry suitable for search.

Some systems will deliberately delay the C<uiEntryOnChanged( ... )> callback
for a more natural feel.

=cut

    affix $lib, 'uiNewSearchEntry', [] => Type ['LibUI::SearchEntry'];

=head2 Label Functions

A label is a control that displays non-interactive text.

You may import these functions with the C<:label> tag.

=cut

    typedef 'LibUI::Label' => Type ['LibUI::Control'];

=head3 C<uiLabelText( ... )>

    my $text = uiLabelText( $label );

Returns the label text.

=cut

    affix $lib, 'uiLabelText', [ Type ['LibUI::Label'] ] => Str;

=head3 C<uiLabelSetText( ... )>

    uiLabelSetText( $label, 'Status: Okay' );

Sets the label text.

=cut

    affix $lib, 'uiLabelSetText', [ Type ['LibUI::Label'], Str ] => Void;

=head3 C<uiNewLabel( ... )>

    my $label = uiNewLabel( 'Status: Init' );

Creates a new label.

=cut

    affix $lib, 'uiNewLabel', [Str] => Type ['LibUI::Label'];

=head2 Tab Functions

A tab represents a multi-page control interface that displays one page at a
time.

Each page/tab has an associated label that can be selected to switch between
pages/tabs.

=cut

    typedef 'LibUI::Tab' => Type ['LibUI::Control'];

=head3 C<uiTabAppend( ... )>

    uiTabAppend( $container, 'Home', $box_1 );

Appends a control in form of a page/tab with label.

=cut

    affix $lib, 'uiTabAppend', [ Type ['LibUI::Tab'], Str, Type ['LibUI::Control'] ] => Void;

=head3 C<uiTabInsertAt( ... )>

    uiTabInsertAt( $container, 'Advanced', 5, $box_2 );

Inserts a control in as a page/tab with label at C<$index>.

=cut

    affix $lib, 'uiTabInsertAt', [ Type ['LibUI::Tab'], Str, Int, Type ['LibUI::Control'] ] => Void;

=head3 C<uiTabDelete( ... )>

    uiTabDelete( $container, 5 );

Removes the control at C<$index>.

=cut

    affix $lib, 'uiTabDelete', [ Type ['LibUI::Tab'], Int ] => Void;

=head3 C<uiTabNumPages( ... )>

    my $tabs = uiTabNumPages( $container );

Returns the number of pages contained.

=cut

    affix $lib, 'uiTabNumPages', [ Type ['LibUI::Tab'] ] => Int;

=head3 C<uiTabMargined( ... )>

    my $comfortable = uiTabMargined( $container, 3 );

Returns whether or not the page/tab at C<$index> has a margin.

=cut

    affix $lib, 'uiTabMargined', [ Type ['LibUI::Tab'], Int ] => Int;

=head3 C<uiTabSetMargined( ... )>

    uiTabSetMargined( $container, 3, 0 ); # where 3 is the inded and 0 is false

Sets whether or not the page/tab at C<$index> has a margin.

The margin size is determined by the OS defaults.

=cut

    affix $lib, 'uiTabSetMargined', [ Type ['LibUI::Tab'], Int, Int ] => Void;

=head3 C<uiNewTab( )>

    my $container = uiNewTab( );

Creates a new tab container.

=cut

    affix $lib, 'uiNewTab', [] => Type ['LibUI::Tab'];

=head2 Group Functions

A group is a control container that adds a label to the contained child
control.

This control is a great way of grouping related controls in combination with
uiBox. A visual box will or will not be drawn around the child control
dependent on the underlying OS implementation.

You may import these functions with the C<:group> tag.

=cut

    typedef 'LibUI::Group' => Type ['LibUI::Control'];

=head3 C<uiGroupTitle( ... )>

    my $title = uiGroupTitle( $group );

Returns the group title.

=cut

    affix $lib, 'uiGroupTitle', [ Type ['LibUI::Group'] ] => Str;

=head3 C<uiGroupSetTitle( ... )>

    uiGroupSetTitle( $group, 'Subscriptions' );

Sets the group title.

=cut

    affix $lib, 'uiGroupSetTitle', [ Type ['LibUI::Group'], Str ] => Void;

=head3 C<uiGroupSetChild( ... )>

    uiGroupSetChild( $group $box );

Sets the group's child.

=cut

    affix $lib, 'uiGroupSetChild', [ Type ['LibUI::Group'], Type ['LibUI::Control'] ] => Void;

=head3 C<uiGroupMargined( ... )>

    my $comfortable = uiGroupMargined( $group );

Returns whether or not the group has a margin.

=cut

    affix $lib, 'uiGroupMargined', [ Type ['LibUI::Group'] ] => Bool;

=head3 C<uiGroupSetMargined( ... )>

    uiGroupSetMargined( $group, 1 );

Sets whether or not the group has a margin.

The margin size is determined by the OS defaults.

=cut

    affix $lib, 'uiGroupSetMargined', [ Type ['LibUI::Group'], Bool ] => Void;

=head3 C<uiNewGroup( ... )>

    my $group = uiNewGroup( 'Introduction' );

Creates a new group.

=cut

    affix $lib, 'uiNewGroup', [Str] => Type ['LibUI::Group'];

=head2 Spinbox Functions

A spinbox is a control to display and modify integer values via a text field or
+/- buttons.

This is a convenient control for having the user enter integer values. Values
are guaranteed to be within the specified range.

The + button increases the held value by 1.

The - button decreased the held value by 1.

Entering a value out of range will clamp to the nearest value in range.

You may import these functions with the C<:spinbox> tag.

=cut

    typedef 'LibUI::Spinbox' => Type ['LibUI::Control'];

=head3 C<uiSpinboxValue( ... )>

    my $value = uiSpinboxValue( $spinner );

Returns the spinbox value.

=cut

    affix $lib, 'uiSpinboxValue', [ Type ['LibUI::Spinbox'] ] => Int;

=head3 C<uiSpinboxSetValue( ... )>

    uiSpinboxSetValue( $spinner, 30 );

Sets the spinbox value.

Setting a value out of range will clamp to the nearest value in range.

=cut

    affix $lib, 'uiSpinboxSetValue', [ Type ['LibUI::Spinbox'], Int ] => Void;

=head3 C<uiSpinboxOnChanged( ... )>

    uiSpinboxOnChanged( $spinner, sub { my ($spin, $user_data) = @_; }, undef );

Registers a callback for when the spinbox value is changed by the user.

The callback is not triggered when calling C<uiSpinboxSetValue( ... )>.

=cut

    affix $lib, 'uiSpinboxOnChanged',
        [
        Type ['LibUI::Spinbox'],
        CodeRef [ [ Type ['LibUI::Spinbox'], Pointer [SV] ] => Void ],
        Pointer [SV]
        ] => Void;

=head3 C<uiNewSpinbox( ... )>

    my $spinner = uiNewSpinbox( 1, 100 );

Creates a new spinbox.

The initial spinbox value equals the minimum value.

In the current implementation upstream, C<$min> and C<$max> are swapped if
C<$min> is greater than C<$max>. This may change in the future though.

=cut

    affix $lib, 'uiNewSpinbox', [ Int, Int ] => Type ['LibUI::Spinbox'];

=head2 Slider Functions

A slider is a control to display and modify integer values via a user draggable
slider.

Values are guaranteed to be within the specified range.

Sliders by default display a tool tip showing the current value when being
dragged.

Sliders are horizontal only.

You may import these functions with the C<:slider> tag.

=cut

    typedef 'LibUI::Slider' => Type ['LibUI::Control'];

=head3 C<uiSliderValue( ... )>

    my $value = uiSliderValue( $slider );

Returns the slider value.

=cut

    affix $lib, 'uiSliderValue', [ Type ['LibUI::Slider'] ] => Int;

=head3 C<uiSliderSetValue( ... )>

    uiSliderSetValue( $slider, 59 );

Sets the slider value.

=cut

    affix $lib, 'uiSliderSetValue', [ Type ['LibUI::Slider'], Int ] => Void;

=head3 C<uiSliderHasToolTip( ... )>

    my $enabled = uiSliderHasToolTip( $slider );

Returns whether or not the slider has a tool tip.

=cut

    affix $lib, 'uiSliderHasToolTip', [ Type ['LibUI::Slider'] ] => Bool;

=head3 C<uiSliderSetHasToolTip( ... )>

    uiSliderSetHasToolTip( $slider, 1 );

Sets whether or not the slider has a tool tip.

=cut

    affix $lib, 'uiSliderSetHasToolTip', [ Type ['LibUI::Slider'], Bool ] => Void;

=head3 C<uiSliderOnChanged( ... )>

    uiSliderOnChanged( $slider, sub { my ($sl, $user_data) = @_; }, undef );

Registers a callback for when the slider value is changed by the user.

The callback is not triggered when calling C<uiSliderSetValue( ... )>.

=cut

    affix $lib, 'uiSliderOnChanged',
        [
        Type ['LibUI::Slider'],
        CodeRef [ [ Type ['LibUI::Slider'], Pointer [SV] ] => Void ],
        Pointer [SV]
        ] => Void;

=head3 C<uiSliderOnReleased( ... )>

    uiSliderOnReleased( $slider, sub { my ($sl, $user_data) = @_; }, undef );

Registers a callback for when the slider is released from dragging.

=cut

    affix $lib, 'uiSliderOnReleased',
        [
        Type ['LibUI::Slider'],
        CodeRef [ [ Type ['LibUI::Slider'], Pointer [SV] ] => Void ],
        Pointer [SV]
        ] => Void;

=head3 C<uiSliderSetRange( ... )>

    uiSliderSetRange( $slider, 1, 500 );

Sets the slider range.

Make sure to clamp the slider value to the nearest value in range - should it
be out of range. Manually call C<uiSliderOnChanged( ... )>'s callback in such a
case.

=cut

    affix $lib, 'uiSliderSetRange', [ Type ['LibUI::Slider'], Int, Int ] => Void;

=head3 C<uiNewSlider( ... )>

    my $slider = uiNewSlider( 1, 100 );

Creates a new slider.

The initial slider value equals the minimum value.

In the current implementation upstream, C<$min> and C<$max> are swapped if
C<$min> is greater than C<$max>. This may change in the future though.

=cut

    affix $lib, 'uiNewSlider', [ Int, Int ] => Type ['LibUI::Slider'];

=head2 ProgressBar Functions

A ProgressBar is a control that visualizes the progress of a task via the fill
level of a horizontal bar.

Indeterminate values are supported via an animated bar.

=cut

    typedef 'LibUI::ProgressBar' => Type ['LibUI::Control'];

=head3 C<uiProgressBarValue( ... )>

    my $value = uiProgressBarValue( $bar );

Returns the progress bar value.

=cut

    affix $lib, 'uiProgressBarValue', [ Type ['LibUI::ProgressBar'] ] => Int;

=head3 C<uiProgressBarSetValue( ... )>

    uiProgressBarSetValue( $bar, 100 );

Sets the progress bar value.

Valid values are C<[0 .. 100]> for displaying a solid bar imitating a percent
value.

Use a value of C<-1> to render an animated bar to convey an indeterminate
value.

=cut

    affix $lib, 'uiProgressBarSetValue', [ Type ['LibUI::ProgressBar'], Int ] => Void;

=head3 C<uiNewProgressBar( )>

Creates a new progress bar.

=cut

    affix $lib, 'uiNewProgressBar', [] => Type ['LibUI::ProgressBar'];

=head2 Separator Functions

A separator is a control to visually separate controls, horizontally or
vertically.

Import these functions with the C<:separator> tag.

=cut

    typedef 'LibUI::HSeparator' => Type ['LibUI::Control'];
    typedef 'LibUI::VSeparator' => Type ['LibUI::Control'];

=head3 C<uiNewHorizontalSeparator( )>

    my $hsplit = uiNewHorizontalSeparator( );

Creates a new horizontal separator.

=cut

    affix $lib, 'uiNewHorizontalSeparator', [] => Type ['LibUI::HSeparator'];

=head3 C<uiNewVerticalSeparator( )>

    my $hsplit = uiNewVerticalSeparator( );

Creates a new vertical separator.

=cut

    affix $lib, 'uiNewVerticalSeparator', [] => Type ['LibUI::VSeparator'];

=head2 Combobox Functions

A combobox is a control to select one item from a predefined list of items via
a drop down menu.

You may import these functions with the C<:combobox> tag.

=cut

    typedef 'LibUI::Combobox' => Type ['LibUI::Control'];

=head3 C<uiComboboxAppend( ... )>

    uiComboboxAppend( $combo, 'Candy' );

Appends an item to the combo box.

=cut

    affix $lib, 'uiComboboxAppend', [ Type ['LibUI::Combobox'], Str ] => Void;

=head3 C<uiComboboxInsertAt( ... )>

    uiComboboxInsertAt( $combo, 4, 'Salty snacks' );

Inserts an item at C<$index> to the combo box.

=cut

    affix $lib, 'uiComboboxInsertAt', [ Type ['LibUI::Combobox'], Int, Str ] => Void;

=head3 C<uiComboboxDelete( ... )>

    uiComboboxDelete( $combo, 4 );

Deletes an item at C<$index> from the combo box.

Deleting the index of the item currently selected will move the selection to
the next item in the combo box or C<-1> if no such item exists.

=cut

    affix $lib, 'uiComboboxDelete', [ Type ['LibUI::Combobox'], Int ] => Void;

=head3 C<uiComboboxClear( ... )>

    uiComboboxClear( $combo );

Deletes all items from the combo box.

=cut

    affix $lib, 'uiComboboxClear', [ Type ['LibUI::Combobox'] ] => Void;

=head3 C<uiComboboxNumItems( ... )>

    my $options = uiComboboxNumItems( $combo );

Returns the number of items contained within the combo box.

=cut

    affix $lib, 'uiComboboxNumItems', [ Type ['LibUI::Combobox'] ] => Int;

=head3 C<uiComboboxSelected( ... )>

    my $current = uiComboboxSelected( $combo );

Returns the index of the item selected or C<-1> on empty selection.

=cut

    affix $lib, 'uiComboboxSelected', [ Type ['LibUI::Combobox'] ] => Int;

=head3 C<uiComboboxSetSelected( ... )>

    uiComboboxSetSelected( $combo, 2 );

Sets the item selected. C<-1> to clear selection.

=cut

    affix $lib, 'uiComboboxSetSelected', [ Type ['LibUI::Combobox'], Int ] => Void;

=head3 C<uiComboboxOnSelected( ... )>

    uiComboboxOnSelected( $combo, sub { my ($c, $user_data) = @_; }, undef );

Registers a callback for when a combo box item is selected.

The callback is not triggered when calling C<uiComboboxSetSelected( ... )>,
C<uiComboboxInsertAt( ... )>, C<uiComboboxDelete( ... )>, or C<uiComboboxClear(
... )>.

=cut

    affix $lib, 'uiComboboxOnSelected',
        [
        Type ['LibUI::Combobox'],
        CodeRef [ [ Type ['LibUI::Combobox'], Pointer [SV] ] => Void ],
        Pointer [SV]
        ] => Void;

=head3 C<uiNewCombobox( )>

    my $combo = uiNewCombobox( );

Creates a new combo box.

=cut

    affix $lib, 'uiNewCombobox', [] => Type ['LibUI::Combobox'];

=head2 Editable Combobox Functions

An editable combobox is a control to select one item from a predefined list of
items or enter ones own.

Predefined items can be selected from a drop down menu.

A customary item can be entered by the user via an editable text field.

You may import these functions with the C<:editablecombobox> tag.

=cut

    typedef 'LibUI::EditableCombobox' => Type ['LibUI::Control'];

=head3 C<uiEditableComboboxAppend( ... )>

    uiEditableComboboxAppend( $combo, 'Fire' );

Appends an item to the editable combo box.

=cut

    affix $lib, 'uiEditableComboboxAppend', [ Type ['LibUI::EditableCombobox'], Str ] => Void;

=head3 C<uiEditableComboboxText( ... )>

    my $text = uiEditableComboboxText( $combo );

Returns the text of the editable combo box.

This text is either the text of one of the predefined list items or the text
manually entered by the user.

=cut

    affix $lib, 'uiEditableComboboxText', [ Type ['LibUI::EditableCombobox'] ] => Str;

=head3 C<uiEditableComboboxSetText( ... )>

    uiEditableComboboxSetText( $combo, "Floating" );

Sets the editable combo box text.

=cut

    affix $lib, 'uiEditableComboboxSetText', [ Type ['LibUI::EditableCombobox'], Str ] => Void;

=head3 C<uiEditableComboboxOnChanged( )>

    uiEditableComboboxOnChanged( $combo, sub { my ($cb, user_data) = @_; }, undef );

Registers a callback for when an editable combo box item is selected or user
text changed.

The callback is not triggered when calling C<uiEditableComboboxSetText( ... )>.

=cut

    affix $lib, 'uiEditableComboboxOnChanged',
        [
        Type ['LibUI::EditableCombobox'],
        CodeRef [ [ Type ['LibUI::EditableCombobox'], Pointer [SV] ] => Void ],
        Pointer [SV]
        ] => Void;

=head3 C<uiNewEditableCombobox( )>

    my $combo = uiNewEditableCombobox( );

Creates a new editable combo box.

=cut

    affix $lib, 'uiNewEditableCombobox', [] => Type ['LibUI::EditableCombobox'];

    #
    typedef 'LibUI::Menu'           => Type ['LibUI::Control'];
    typedef 'LibUI::MenuItem'       => Type ['LibUI::Control'];
    typedef 'LibUI::Separator'      => Type ['LibUI::Control'];
    typedef 'LibUI::DatePicker'     => Type ['LibUI::Control'];
    typedef 'LibUI::TimePicker'     => Type ['LibUI::Control'];
    typedef 'LibUI::DateTimePicker' => Type ['LibUI::Control'];
    typedef 'LibUI::FontButton'     => Type ['LibUI::Control'];
    typedef 'LibUI::ColorButton'    => Type ['LibUI::Control'];
    typedef 'LibUI::Combobox'       => Type ['LibUI::Control'];
    typedef 'LibUI::Radiobuttons'   => Type ['LibUI::Control'];
    typedef 'LibUI::Area'           => Type ['LibUI::Control'];
    typedef 'LibUI::DrawPath'       => Type ['LibUI::Control'];
    typedef 'LibUI::TextFont'       => Type ['LibUI::Control'];
    typedef 'LibUI::TextLayout'     => Type ['LibUI::Control'];
    #
    typedef 'LibUI::AreaDrawParams' => Struct [
        draw_context => Pointer [Void],
        width        => Double,
        height       => Double,
        clip_x       => Double,
        clip_y       => Double,
        clip_width   => Double,
        clip_height  => Double
    ];
    #
    typedef 'LibUI::AreaHandler' => Struct [
        draw_event    => CodeRef [ [ Pointer [Void], Pointer [Void], Pointer [Void] ] => Void ],
        mouse_event   => CodeRef [ [ Pointer [Void], Pointer [Void], Pointer [Void] ] => Void ],
        mouse_crossed => CodeRef [ [ Pointer [Void], Pointer [Void], Int ]            => Void ],
        drag_broken   => CodeRef [ [ Pointer [Void], Pointer [Void] ]                 => Void ],
        key_event     => CodeRef [ [ Pointer [Void], Pointer [Void], Pointer [Void] ] => Int ]
    ];

=begin todo

    KEY_MODIFIERS = enum(:ctrl, 1 << 0, :alt, 1 << 1, :shift, 1 << 2, :super, 1 << 3)
    LINE_CAPS  = enum(:flat, :round, :square)
    LINE_JOINS = enum(:miter, :round, :bevel)
    TEXT_WEIGHTS = enum(:thin,
      :ultra_light,
      :light, :book,
      :normal,
      :medium,
      :semi_bold,
      :bold,
      :ultra_bold,
      :heavy,
      :ultra_heavy
    )

    TEXT_ITALIC = enum(:normal, :oblique, :italic)
    TEXT_STRETCH = enum(:ultra_condensed,
      :extra_condensed,
      :condensed,
      :semi_condensed,
      :normal,
      :semi_expanded,
      :expanded,
      :extra_expanded,
      :ultra_expanded
    )

    class AreaMouseEvent < FFI::Struct
      layout :x,      :double,
        :y,           :double,
        :area_width,  :double,
        :area_height, :double,
        :down,        :uintmax_t,
        :up,          :uintmax_t,
        :count,       :uintmax_t,
        :modifiers,   KEY_MODIFIERS,
        :held1to64,   :uint64_t
    end

    class FontFamilies < FFI::Struct
      layout :ff, :pointer
    end

    class FontDescriptor < FFI::Struct
      layout :family, :string,
        :size, :double,
        :weight, TEXT_WEIGHTS,
        :italic, TEXT_ITALIC,
        :stretch, TEXT_STRETCH
    end

    class FontMetrics < FFI::Struct
      layout :ascent, :double,
        :descent, :double,
        :leading, :double,
        :underline_pos, :double,
        :underline_thickness, :double
    end

    class DrawStrokeParams < FFI::Struct
      layout :cap, LINE_CAPS,
        :join, LINE_JOINS,
        :thickness, :double,
        :miter_limit, :double,
        :dashes, :pointer, #double?
        :num_dashes, :size_t,
        :dash_phase, :double
    end

    BRUSH_TYPES = enum(:solid, :linear_gradient, :radial_gradient, :image)
    FILL_MODES  = enum(:winding, :alternate)

    class DrawBrush < FFI::Struct
      layout :type,  BRUSH_TYPES,
             :red,   :double,
             :green, :double,
             :blue,  :double,
             :alpha, :double,

             :x0, :double, # linear: start X, radial: start X
             :y0, :double, # linear: start Y, radial: start Y
             :x1, :double, # linear: end X, radial: outer circle center X
             :y1, :double, # linear: end Y, radial: outer circle center Y
             :outer_radius, :double, # radial gradients only
             :stops, :pointer, # pointer to uiDrawBrushGradientStop
             :num_stops, :size_t
    end

    class DrawMatrix < FFI::Struct
      layout :m11, :double,
        :m12, :double,
        :m21, :double,
        :m22, :double,
        :m31, :double,
        :m32, :double
    end

=end todo

=cut

    #

    #
    #
    #
    #~ callback :menu_item_clicked, [:pointer], :int
    #~ attach_function :uiNewMenu,                   [:string],       Menu
    #~ attach_function :uiMenuAppendItem,            [Menu, :string], MenuItem
    #~ attach_function :uiMenuAppendPreferencesItem, [Menu],          MenuItem
    #~ attach_function :uiMenuAppendAboutItem,       [Menu],          MenuItem
    #~ attach_function :uiMenuItemDisable,           [MenuItem],      :void
    #~ attach_function :uiMenuAppendQuitItem,        [Menu],          :void
    #~ attach_function :uiMenuAppendCheckItem,       [Menu, :string], :void
    #~ attach_function :uiMenuAppendSeparator,       [Menu],          :void
    #~ attach_function :uiMenuItemOnClicked,
    #~ [Menu,
    #~ :menu_item_clicked,
    #~ :pointer],
    #~ :void
    #
    affix $lib, 'uiNewDatePicker',     []    => InstanceOf ['LibUI::DatePicker'];
    affix $lib, 'uiNewTimePicker',     [Str] => InstanceOf ['LibUI::TimePicker'];
    affix $lib, 'uiNewDateTimePicker', []    => InstanceOf ['LibUI::DateTimePicker'];
    affix $lib, 'uiNewFontButton',     []    => InstanceOf ['LibUI::FontButton'];
    #
    affix $lib, 'uiMsgBox',      [ InstanceOf ['LibUI::Window'], Str, Str ] => Void;
    affix $lib, 'uiMsgBoxError', [ InstanceOf ['LibUI::Window'], Str, Str ] => Void;
    #
    affix $lib, 'uiNewArea',
        [ Pointer [ Type ['LibUI::AreaHandler'] ] ] => InstanceOf ['LibUI::Area'];
    #

=head1 Requirements

L<Affix> and L<Alien::libui>

=head1 See Also

F<eg/demo.pl> - Very basic example

F<eg/widgets.pl> - Demo of basic controls

=head1 LICENSE

Copyright (C) Sanko Robinson.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=head1 AUTHOR

Sanko Robinson E<lt>sanko@cpan.orgE<gt>

=begin stopwords

draggable gotta userdata borderless uiWindow uiBox resizable checkbox readonly
spinbox combobox

=end stopwords

=cut

}
1;
