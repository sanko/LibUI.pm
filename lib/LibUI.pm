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
        controls => [
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
        label => ['uiNewLabel']
    );
    {
        my %seen;
        push @{ $EXPORT_TAGS{controls} }, grep { !$seen{$_}++ } @{ $EXPORT_TAGS{$_} }
            for qw[window button box checkbox label];
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
L<<C<uiQuit()>|C<uiQuit( )>>> was called).

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

    typedef 'LibUI::Entry' => Type ['LibUI::Control'];

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

    affix $lib, 'uiNewPasswordEntry', [] => Type ['LibUI::Entry'];

=head3 C<uiNewSearchEntry( ... )>

    my $search = uiNewSearchEntry();

Creates a new entry suitable for search.

Some systems will deliberately delay the C<uiEntryOnChanged( ... )> callback
for a more natural feel.

=cut

    affix $lib, 'uiNewSearchEntry', [] => Type ['LibUI::Entry'];

    #
    typedef 'LibUI::Menu'             => Type ['LibUI::Control'];
    typedef 'LibUI::MenuItem'         => Type ['LibUI::Control'];
    typedef 'LibUI::Group'            => Type ['LibUI::Control'];
    typedef 'LibUI::Label'            => Type ['LibUI::Control'];
    typedef 'LibUI::Separator'        => Type ['LibUI::Control'];
    typedef 'LibUI::DatePicker'       => Type ['LibUI::Control'];
    typedef 'LibUI::TimePicker'       => Type ['LibUI::Control'];
    typedef 'LibUI::DateTimePicker'   => Type ['LibUI::Control'];
    typedef 'LibUI::FontButton'       => Type ['LibUI::Control'];
    typedef 'LibUI::ColorButton'      => Type ['LibUI::Control'];
    typedef 'LibUI::SpinBox'          => Type ['LibUI::Control'];
    typedef 'LibUI::Slider'           => Type ['LibUI::Control'];
    typedef 'LibUI::ProgressBar'      => Type ['LibUI::Control'];
    typedef 'LibUI::Combobox'         => Type ['LibUI::Control'];
    typedef 'LibUI::EditableCombobox' => Type ['LibUI::Control'];
    typedef 'LibUI::Radiobuttons'     => Type ['LibUI::Control'];
    typedef 'LibUI::Tab'              => Type ['LibUI::Control'];
    typedef 'LibUI::Area'             => Type ['LibUI::Control'];
    typedef 'LibUI::DrawPath'         => Type ['LibUI::Control'];
    typedef 'LibUI::TextFont'         => Type ['LibUI::Control'];
    typedef 'LibUI::TextLayout'       => Type ['LibUI::Control'];
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
    affix $lib, 'uiNewGroup',         [Str] => InstanceOf ['LibUI::Group'];
    affix $lib, 'uiGroupSetMargined', [ InstanceOf ['LibUI::Group'], Int ] => Void;
    affix $lib, 'uiGroupMargined',    [ InstanceOf ['LibUI::Group'] ]      => Int;
    affix $lib, 'uiGroupSetChild',
        [ InstanceOf ['LibUI::Group'], InstanceOf ['LibUI::Group'] ] => Void;
    affix $lib, 'uiGroupSetTitle', [ InstanceOf ['LibUI::Group'], Str ] => Void;
    #
    affix $lib, 'uiNewDatePicker',          []    => InstanceOf ['LibUI::DatePicker'];
    affix $lib, 'uiNewTimePicker',          [Str] => InstanceOf ['LibUI::TimePicker'];
    affix $lib, 'uiNewDateTimePicker',      []    => InstanceOf ['LibUI::DateTimePicker'];
    affix $lib, 'uiNewFontButton',          []    => InstanceOf ['LibUI::FontButton'];
    affix $lib, 'uiNewHorizontalSeparator', []    => InstanceOf ['LibUI::Separator'];
    affix $lib, 'uiNewProgressBar',         []    => InstanceOf ['LibUI::ProgressBar'];
    affix $lib, 'uiProgressBarValue',       [ InstanceOf ['LibUI::ProgressBar'] ]      => Int;
    affix $lib, 'uiProgressBarSetValue',    [ InstanceOf ['LibUI::ProgressBar'], Int ] => Void;
    #
    affix $lib, 'uiMsgBox',      [ InstanceOf ['LibUI::Window'], Str, Str ] => Void;
    affix $lib, 'uiMsgBoxError', [ InstanceOf ['LibUI::Window'], Str, Str ] => Void;
    #
    affix $lib, 'uiNewArea',
        [ Pointer [ Type ['LibUI::AreaHandler'] ] ] => InstanceOf ['LibUI::Area'];
    #
    affix $lib, 'uiNewLabel', [Str] => InstanceOf ['LibUI::Label'];

=head1 Requirements

See L<Alien::libui>

=head1 See Also

F<eg/demo.pl> - Very basic example

F<eg/widgets.pl> - Demo of basic controls

=head1 LICENSE

Copyright (C) Sanko Robinson.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=head1 AUTHOR

Sanko Robinson E<lt>sanko@cpan.orgE<gt>

=for stopwords draggable gotta userdata borderless uiWindow resizable checkbox readonly

=cut

    #
    $|++;
    if (0) {
        uiInit( {} ) && die;
        #
        my $win      = uiNewWindow( 'Hi', 320, 30, 0 );
        my $quitting = 0;
        uiWindowOnClosing( $win, sub { warn 'closing'; uiQuit(); $quitting++; return 1; }, undef );
        my $box = uiNewVerticalBox();
        warn ref $box;
        uiWindowSetChild( $win, $box );
        uiBoxSetPadded( $box, 1 );

        #~ my $check = uiNewCheckbox('Check');
        #~ uiCheckboxOnToggled(
        #~ $check,
        #~ sub {
        #~ warn uiCheckboxChecked(shift);
        #~ },
        #~ undef
        #~ );
        #~ uiBoxAppend( $box, $check, 1 );
        my $progress = uiNewProgressBar();
        uiProgressBarSetValue( $progress, 19 );
        uiBoxAppend( $box, $progress, 1 );

        #~ my $check = uiNewArea(
        #~ {   draw_event    => sub { warn 'draw' },
        #~ mouse_event   => sub { warn 'mouse' },
        #~ mouse_crossed => sub { warn 'crossed' },
        #~ drag_broken   => sub { warn 'broken' },
        #~ key_event     => sub { warn 'key' },
        #~ }
        #~ );
        uiControlShow($win);
        warn ref $win;

        #~ my $value = 0;
        uiTimer(
            10,
            sub {
                #~ use Data::Dump; ddx \@_;
                return 0 if $quitting;

                #~ my $value = uiProgressBarValue($progress);
                $_[0] = 0 if ++$_[0] >= 100;
                uiProgressBarSetValue( $progress, $_[0] );
                1;
            },
            my $value = 50
        );
        uiTimer(
            100,
            sub {
                return 0 if $quitting;
                print '.';
                warn 'tick';
                1;
            },
            undef
        );

        #~ uiMsgBox($win, 'Hi', 'Oh, well, that is something else...');
        #~ ddx $win;
        uiMain();
        uiUninit();
    }
}
1;
__DATA__
use strict;
use warnings;
use lib '../lib';
use LibUI qw[:all ::Window ::Label];
#
Init() && die;
my $window = LibUI::Window->new( 'Hi', 320, 30, 0 );
$window->setMargined(1);
$window->setChild( LibUI::Label->new('Hello, World!') );
$window->onClosing(
    sub {
        Quit();
        return 1;
    },
    undef
);
$window->setMargined(1);
$window->show;
Main();
Uninit();



__END__
use 5.008001;

package LibUI 0.03 {
    use strict;
    use warnings;
    use lib '../lib', '../blib/arch', '../blib/lib';
    use Affix qw[:default :types typedef];
    use Alien::libui;
    use parent 'Exporter';    # gives you Exporter's import() method directly
    use Config;
    use Carp;
    our %EXPORT_TAGS;
    $|++;
    #
    #my $path = '/home/sanko/Downloads/libui-ng-master/build/meson-out/libui.so.0';
    our $lib;

#~ $lib = '/home/s/Desktop/Projects/alien-libui/_alien/build_M08j/libui-ng-master/build/meson-out/libui.so.0';
    sub lib () { $lib //= Alien::libui->dynamic_libs; $lib }
    #
    my @exports;

    sub import {
        my ( $pkg, @args ) = @_;
        my $callpkg = caller(0);
        for my $arg (@args) {
            if ( $arg =~ m[^::(.+)$] ) {
                my $widget = 'LibUI' . $arg;
                eval qq{use $widget};
                croak $@ if $@;
                {
                    my $hash = $widget::{EXPORT_TAGS};
                    for my $key ( keys %$hash ) {
                        warn $key;
                        if ( exists $EXPORT_TAGS{$key} ) {
                            push @{ $EXPORT_TAGS{$key} }, $hash->{$key};
                        }
                        else {
                            $EXPORT_TAGS{$key} = $hash->{$key};
                        }
                    }
                }
            }
            elsif ( $arg =~ m[^:(.+)$] ) {
                push @exports, @{ $EXPORT_TAGS{$1} };
            }
        }
        no strict 'refs';
        *{"$callpkg\::$_"} = \&{"$pkg\::$_"} for @exports;
    }

    # TODO: unimport
    sub export {
        my ( $tag, @funcs ) = @_;
        push @{ $EXPORT_TAGS{$tag} }, map { m[^ui]; $'; } @funcs;
    }

    sub func {
        my ( $func, $params, $ret ) = @_;
        my $name = $func;
        $name =~ s[^ui][LibUI::];
        $name
            =~ s[LibUI::(Box|Button|Combobox|Control|Menu|NonWrappingMultilineEntry|RadioButtons|Slider|Window)][LibUI::$1::];
        $name =~ s[::New(.+)$][::$1::new];

        #warn sprintf '%30s => %-50s', $func, $name;
        affix( lib, [ $func, $name ], $params, $ret );
    }
    #
    sub Init {
        my $aggs = @_ ? shift : { Size => 1024 };
        CORE::state $func
            //= Affix::wrap( lib(), 'uiInit', [ Pointer [ Struct [ Size => Size_t ] ] ], Str );
        $func->($aggs);
    }

    sub Timer($&;$) {
        my ( $timeout, $coderef, $agg ) = @_;
        CORE::state $func //= Affix::wrap( lib(), 'uiTimer',
            [ Int, CodeRef [ [ Pointer [SV] ] => Int ], Pointer [SV] ] => Void );
        $func->( $timeout, $coderef, $agg // undef );
    }
    typedef uiForEach => Enum [qw[uiForEachContinue uiForEachStop]];
    {
        export default => qw[uiInit uiUninit uiFreeInitError
            uiMain uiMainSteps uiMainStep uiQuit
            uiQueueMain
            uiTimer
            uiFreeText
        ];
        func( 'uiUninit', [] => Void );
        func( 'uiMain',   [] => Void );
        func( 'uiQuit',   [] => Void );

        # Undocumented
        func( 'uiFreeInitError', [Str] => Void );
        #
        func( 'uiMainSteps', []    => Void );
        func( 'uiMainStep',  [Int] => Int );
        #
        func( 'uiQueueMain', [ CodeRef [ [ Pointer [SV] ] => Void ], Pointer [SV] ] => Void );
        #
        affix(
            lib(),
            [ 'uiOnShouldQuit',                    'LibUI::onShouldQuit' ],
            [ CodeRef [ [ Pointer [SV] ] => Int ], Pointer [SV] ] => Void
        );
        func( 'uiFreeText', [Str] => Void );
    }
    ##############################################################################################
    #
    {
        my %seen;
        push @{ $EXPORT_TAGS{all} }, grep { !$seen{$_}++ } @{ $EXPORT_TAGS{$_} }
            for keys %EXPORT_TAGS;
        our @EXPORT_OK = @{ $EXPORT_TAGS{all} };
    }
};
1;
#
__END__

=pod

=encoding utf-8

=head1 NAME

LibUI - Simple, Portable, Native GUI Library

=head1 SYNOPSIS

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

=head1 Container controls

=over

=item L<LibUI::Window> - a top-level window

=item L<LibUI::HBox> - a horizontally aligned, boxlike container that holds a group of controls

=item L<LibUI::VBox> - a vertically aligned, boxlike container that holds a group of controls

=item L<LibUI::Tab> - a multi-page control interface that displays one page at a time

=item L<LibUI::Group> - a container that adds a label to the child

=item L<LibUI::Form> - a container to organize controls as labeled fields

=item L<LibUI::Grid> - a container to arrange controls in a grid

=back

=head1 Data entry controls

=over

=item L<LibUI::Button> - a button control that triggers a callback when clicked

=item L<LibUI::Checkbox> - a user checkable box accompanied by a text label

=item L<LibUI::Entry> - a single line text entry field

=item L<LibUI::PasswordEntry> - a single line, obscured text entry field

=item L<LibUI::SearchEntry> - a single line search query field

=item L<LibUI::Spinbox> - display and modify integer values via a text field or +/- buttons

=item L<LibUI::Slider> - display and modify integer values via a draggable slider

=item L<LibUI::Combobox> - a drop down menu to select one of a predefined list of items

=item L<LibUI::EditableCombobox> - a drop down menu to select one of a predefined list of items or enter you own

=item L<LibUI::RadioButtons> - a multiple choice control of check buttons from which only one can be selected at a time

=item L<LibUI::DateTimePicker> - a control to enter a date and/or time

=item L<LibUI::DatePicker> - a control to enter a date

=item L<LibUI::TimePicker> - a control to enter a time

=item L<LibUI::MultilineEntry> - a multi line entry that visually wraps text when lines overflow

=item L<LibUI::NonWrappingMultilineEntry> - a multi line entry that scrolls text horizontally when lines overflow

=item L<LibUI::FontButton> - a control that opens a font picker when clicked

=back

=head2 Static controls

=over

=item L<LibUI::Label> - a control to display non-interactive text

=item L<LibUI::ProgressBar> - a control that visualizes the progress of a task via the fill level of a horizontal bar

=item L<LibUI::HSeparator> - a control to visually separate controls horizontally

=item L<LibUI::VSeparator> - a control to visually separate controls vertically

=back

=head2 Dialog windows

=over

=item C<openFile( )> - File chooser to select a single file

=item C<openFolder( )> - File chooser to select a single folder

=item C<saveFile( )> - Save file dialog

=item C<msgBox( ... )> - Message box dialog

=item C<msgBoxError( ... )> - Error message box dialog

=back

See L<LibUI::Window/Dialog windows> for more.

=head2 Menus

=over

=item C<LibUI::Menu> - application-level menu bar

=item C<LibUI::MenuItem> - menu items used in conjunction with L<LibUI::Menu>

=back

=head2 Tables

The upstream API is a mess so I'm still plotting around this.

=head1 GUI Functions

Some basics you gotta use just to keep a modern GUI running.

This is incomplete but... well, I'm working on it.

=head3 C<Init( [...] )>

    Init( );

Ask LibUI to do all the platform specific work to get up and running. If LibUI
fails to initialize itself, this will return a true value. Weird upstream
choice, I know...

You B<must> call this before creating widgets.

=head3 C<Main( ... )>

    Main( );

Let LibUI's event loop run until interrupted.

=head3 C<Uninit( ... )>

    Uninit( );

Ask LibUI to break everything down before quitting.

=head3 C<Quit( ... )>

    Quit( );

Quit.


=head3 C<Timer( ... )>

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

=over

=item C<$time>

Time in milliseconds.

=item C<$func>

CodeRef that will be triggered when C<$time> runs out.

Return a true value from your C<$func> to make your timer repeating.

=item C<$data>

Any userdata you feel like passing. It'll be handed off to your function.

=back

=head1 Importing Widgets

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

=head1 Requirements

See L<Alien::libui>

=head1 See Also

F<eg/demo.pl> - Very basic example

F<eg/widgets.pl> - Demo of basic controls

=head1 LICENSE

Copyright (C) Sanko Robinson.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=head1 AUTHOR

Sanko Robinson E<lt>sanko@cpan.orgE<gt>

=for stopwords draggable gotta userdata

=cut

