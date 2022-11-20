package LibUI 0.01 {
    use 5.008001;
    use strict;
    use warnings;
    use lib '../lib', '../blib/arch', '../blib/lib';
    use Affix;
    use Dyn       qw[:dl];
    use Dyn::Load qw[:all];
    use Dyn::Call qw[:all];
    use Alien::libui;
    use Exporter 'import';    # gives you Exporter's import() method directly
    use Config;
    our %EXPORT_TAGS;
    $|++;
    #
    my ($path) = Alien::libui->dynamic_libs;

    #my $path = '/home/sanko/Downloads/libui-ng-master/build/meson-out/libui.so.0';
    my $lib = dlLoadLibrary($path);
    sub lib () {$lib}
    #
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
        warn sprintf '%30s => %-50s', $func, $name;
        attach( $lib, $func, $params, $ret, DC_SIGCHAR_CC_DEFAULT, $name );
    }
    #
    #my $init = dlSymsInit($path);
    #
    #CORE::say "Symbols in $path: " . dlSymsCount($init);
    #for my $i ( 0 .. dlSymsCount($init) - 1 ) {
    #    my $name = dlSymsName( $init, $i );
    #    CORE::say sprintf '  %4d %s', $i, $name if $name =~ m[^ui];
    #}
    #
    #push @{ $EXPORT_TAGS{types} }, 'InitOptions';
    #typedef InitOptions => Struct [ Size => Size_t ];
    #sub InitOptions {
    #    InitOptions->new(@_);
    #}
    typedef uiForEach => Enum [qw[uiForEachContinue uiForEachStop]];
    {
        typedef 'InitOptions' => Struct [ Size => Size_t ];

        #@InitOptions::ISA = qw[Dyn::Call::Pointer];
        #
        export default => qw[uiInit uiUninit uiFreeInitError
            uiMain uiMainSteps uiMainStep uiQuit
            uiQueueMain
            uiTimer
            uiFreeText
        ];
        func( 'uiInit',          [ Pointer [ InitOptions() ] ] => Str );
        func( 'uiUninit',        []                            => Void );
        func( 'uiFreeInitError', [Str]                         => Void );
        #
        func( 'uiMain',      []    => Void );
        func( 'uiMainSteps', []    => Void );
        func( 'uiMainStep',  [Int] => Int );
        func( 'uiQuit',      []    => Void );
        #
        func( 'uiQueueMain', [ CodeRef [ [ Pointer [Void] ] => Void ], Any ] => Void );
        #
        func( 'uiTimer', [ Int, CodeRef [ [Any] => Int ], Any ] => Void );
        attach(
            lib(), 'uiOnShouldQuit', [ CodeRef [ [Any] => Int ], Any ] => Void,
            DC_SIGCHAR_CC_DEFAULT, 'LibUI::onShouldQuit'
        );
        func( 'uiFreeText', [Str] => Void );
    }
    #
    {
        @LibUI::Button::ISA = qw[LibUI::Control];
        export button => qw[
            uiButtonText
            uiButtonSetText
            uiButtonOnClicked
            uiNewButton ];
        func( 'uiButtonText',    [ InstanceOf ['LibUI::Button'] ]      => Str );
        func( 'uiButtonSetText', [ InstanceOf ['LibUI::Button'], Str ] => Void );
        func(
            'uiButtonOnClicked',
            [   InstanceOf ['LibUI::Button'],
                CodeRef [ [ InstanceOf ['LibUI::Button'], Any ] => Void ], Any
            ] => Void
        );
        func( 'uiNewButton', [Str] => InstanceOf ['LibUI::Button'] );
    }
    #
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

=head1 DESCRIPTION

LibUI is a simple and portable (but not inflexible) GUI library in C that uses
the native GUI technologies of each platform it supports.

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

=item L<LibUI::HorizontalSeparator> - a control to visually separate controls horizontally

=item L<LibUI::VerticalSeparator> - a control to visually separate controls vertically



=back


=head2 Buttons

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

=head2 LibUI::Control

=head3 C<uiControlDestroy( ... )>

    uiControlDestroy( $c );

Dispose and free all allocated resources.

=head3 C<uiControlHandle( ... )>

    my $handle = uiControlHandle( $c );

Returns the control's OS-level handle.

=head3 C<uiControlParent( ... )>

    my $parent = uiControlParent( $c );

Returns the parent control or C<undef> if detached.

=head3 C<uiControlSetParent( ... )>

    uiControlSetParent( $c, $parent );

Sets the control's parent. Pass C<undef> to detach.

=head3 C<uiControlToplevel( ... )>

    if ( uiControlToplevel( $c ) ) {
        ...;
    }

Returns whether or not the control is a top level control.


=head3 C<uiControlVisible( ... )>

    if ( uiControlVisible( $c ) ) {
        ...;
    }

Returns whether or not the control is visible.

=head3 C<uiControlShow( ... )>

    uiControlShow( $c );

Shows the control.

=head3 C<uiControlHide( ... )>

    uiControlHide( $c );

Hides the control. Hidden controls do not take up space within the layout.

=head3 C<uiControlEnabled( ... )>

    if ( uiControlEnabled( $c ) ) {
        ...;
    }

Returns whether or not the control is enabled.

=head3 C<uiControlEnable( ... )>

    uiControlEnable( $c );

Enables the control.

=head3 C<uiControlDisable( ... )>

    uiControlDisable( $c );

Disables the control.

=head3 C<uiAllocControl( ... )>

    my $control = uiAllocControl( $size, $OSsig, $type, $typename );

Helper to allocate new controls.

=head3 C<uiFreeControl( ... )>

    uiFreeControl( $c );

Frees the control.

=head3 C<uiControlVerifySetParent( ... )>

    uiControlVerifySetParent( $c, $parent );

Makes sure the control's parent can be set to C<$parent> and crashes the
application on failure.

=head1 Requirements

See L<Alien::libui>

=head1 LICENSE

Copyright (C) Sanko Robinson.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=head1 AUTHOR

Sanko Robinson E<lt>sanko@cpan.orgE<gt>

=for stopwords draggable

=cut

