package Affix::libui 0.01 {
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
    our %EXPORT_TAGS;
    $|++;
    #
    my ($path) = Alien::libui->dynamic_libs;

    #my $path = '/home/sanko/Downloads/libui-ng-master/build/meson-out/libui.so.0';
    my $lib = dlLoadLibrary($path);

    #my $init = dlSymsInit($path);
    #
    #CORE::say "Symbols in $path: " . dlSymsCount($init);
    #for my $i ( 0 .. dlSymsCount($init) - 1 ) {
    #    my $name = dlSymsName( $init, $i );
    #    CORE::say sprintf '  %4d %s', $i, $name if $name =~ m[^ui];
    #}
    #
    $EXPORT_TAGS{default} = [qw[uiInit uiMain uiQuit]];
    typedef InitOptions => Struct [ Size => Size_t ];
    typedef uiControl => Struct [
        Signature     => Long,
        OSSignature   => Long,
        TypeSignature => Long,
        Destroy       => CodeRef [ [ Pointer [Void] ] => Void ],
        Handle        => CodeRef [ [ Pointer [Void] ] => Pointer [Void] ],
        Parent        => CodeRef [ [ Pointer [Void] ] => Pointer [Void] ],
        SetParent     => CodeRef [ [ Pointer [Void] ] => Void ],
        Toplevel      => CodeRef [ [ Pointer [Void] ] => Int ],
        Visible       => CodeRef [ [ Pointer [Void] ] => Int ],
        Show          => CodeRef [ [ Pointer [Void] ] => Void ],
        Hide          => CodeRef [ [ Pointer [Void] ] => Void ],
        Enabled       => CodeRef [ [ Pointer [Void] ] => Int ],
        Enable        => CodeRef [ [ Pointer [Void] ] => Void ],
        Disable       => CodeRef [ [ Pointer [Void] ] => Void ]
    ];
    #
    package LibUI { }
    $EXPORT_TAGS{default} = [qw[uiInit uiMain uiQuit]];
    attach( $lib, 'uiInit', [ Pointer [ InitOptions() ] ] => Str );
    attach( $lib, 'uiMain', []                            => Void );
    attach( $lib, 'uiQuit', []                            => Void );
    #
    package LibUI::Control { }
    $EXPORT_TAGS{control} = [qw[uiControl uiControlShow]];
    attach( $lib, 'uiControl',     [ InstanceOf ['LibUI::Control'] ] => Void );
    attach( $lib, 'uiControlShow', [ InstanceOf ['LibUI::Control'] ] => Void );
    #
    @LibUI::Button::ISA = qw[LibUI::Control];
    $EXPORT_TAGS{button} = [
        qw[uiNewButton
            uiButtonText
            uiButtonSetText
            uiButtonOnClicked
        ]
    ];
    attach( $lib, 'uiNewButton',     [Str] => InstanceOf ['LibUI::Button'] );
    attach( $lib, 'uiButtonText',    [ InstanceOf ['LibUI::Button'] ]      => Str );
    attach( $lib, 'uiButtonSetText', [ InstanceOf ['LibUI::Button'], Str ] => Void );
    attach(
        $lib,
        'uiButtonOnClicked',
        [   InstanceOf ['LibUI::Button'],
            CodeRef [ [ InstanceOf ['LibUI::Button'], Any ] => Void ], Any
        ] => Void
    );
    #
    @LibUI::Box::ISA = qw[LibUI::Control];
    $EXPORT_TAGS{box} = [
        qw[uiBoxAppend
            uiBoxNumChildren
            uiBoxDelete uiBoxDelete
            uiBoxPadded
            uiBoxSetPadded
            uiNewHorizontalBox
            uiNewVerticalBox
        ]
    ];
    attach( $lib, 'uiBoxAppend',
        [ InstanceOf ['LibUI::Box'], InstanceOf ['LibUI::Control'], Int ] => Void );
    attach( $lib, 'uiBoxNumChildren',   [ InstanceOf ['LibUI::Box'] ]      => Int );
    attach( $lib, 'uiBoxDelete',        [ InstanceOf ['LibUI::Box'], Int ] => Void );
    attach( $lib, 'uiBoxPadded',        [ InstanceOf ['LibUI::Box'] ]      => Int );
    attach( $lib, 'uiBoxSetPadded',     [ InstanceOf ['LibUI::Box'], Int ] => Void );
    attach( $lib, 'uiNewHorizontalBox', [] => InstanceOf ['LibUI::Box'] );
    attach( $lib, 'uiNewVerticalBox',   [] => InstanceOf ['LibUI::Box'] );
    #
    @LibUI::Window::ISA = qw[LibUI::Control];
    $EXPORT_TAGS{window} = [
        qw[uiNewWindow uiWindowTitle
            uiWindowSetChild
            uiWindowSetMargined
            uiWindowOnClosing
        ]
    ];
    @LibUI::Window::ISA = qw[LibUI::Control];
    attach( $lib, 'uiNewWindow',   [ Str, Int, Int, Int ] => InstanceOf ['LibUI::Window'] );
    attach( $lib, 'uiWindowTitle', [ InstanceOf ['LibUI::Window'] ] => Str );
    attach( $lib, 'uiWindowSetChild',
        [ InstanceOf ['LibUI::Window'], InstanceOf ['LibUI::Control'] ] => Void );
    attach( $lib, 'uiWindowSetMargined', [ InstanceOf ['LibUI::Window'], Int ] => Void );
    attach(
        $lib,
        'uiWindowOnClosing',
        [   InstanceOf ['LibUI::Window'],
            CodeRef [ [ InstanceOf ['LibUI::Window'], Pointer [Void] ] => Int ],
            Pointer [Void]
        ] => Void
    );

#~ _UI_EXTERN char *uiWindowTitle(uiWindow *w);
#~ _UI_EXTERN void uiWindowSetTitle(uiWindow *w, const char *title);
#~ _UI_EXTERN void uiWindowContentSize(uiWindow *w, int *width, int *height);
#~ _UI_EXTERN void uiWindowSetContentSize(uiWindow *w, int width, int height);
#~ _UI_EXTERN int uiWindowFullscreen(uiWindow *w);
#~ _UI_EXTERN void uiWindowSetFullscreen(uiWindow *w, int fullscreen);
#~ _UI_EXTERN void uiWindowOnContentSizeChanged(uiWindow *w, void (*f)(uiWindow *, void *), void *data);
#~ _UI_EXTERN void uiWindowOnClosing(uiWindow *w, int (*f)(uiWindow *w, void *data), void *data);
#~ _UI_EXTERN int uiWindowBorderless(uiWindow *w);
#~ _UI_EXTERN void uiWindowSetBorderless(uiWindow *w, int borderless);
#~ _UI_EXTERN void uiWindowSetChild(uiWindow *w, uiControl *child);
#~ _UI_EXTERN int uiWindowMargined(uiWindow *w);
#~ _UI_EXTERN void uiWindowSetMargined(uiWindow *w, int margined);
#~ _UI_EXTERN int uiWindowResizeable(uiWindow *w);
#~ _UI_EXTERN void uiWindowSetResizeable(uiWindow *w, int resizeable);
#~ _UI_EXTERN uiWindow *uiNewWindow(const char *title, int width, int height, int hasMenubar);
    @LibUI::MultilineEntry::ISA = qw[LibUI::Control];
    $EXPORT_TAGS{multilineentry} = [
        qw[
            uiMultilineEntryText
            uiMultilineEntrySetText
            uiMultilineEntryAppend
            uiMultilineEntryReadOnly
            uiMultilineEntrySetReadOnly
            uiNewMultilineEntry
            uiNewNonWrappingMultilineEntry
        ]
    ];
    attach( $lib, 'uiMultilineEntryText', [ InstanceOf ['LibUI::MultilineEntry'] ] => Str );
    attach( $lib, 'uiMultilineEntrySetText',
        [ InstanceOf ['LibUI::MultilineEntry'], Str ] => Void );
    attach( $lib, 'uiMultilineEntryAppend', [ InstanceOf ['LibUI::MultilineEntry'], Str ] => Void );
    attach(
        $lib,
        'uiMultilineEntryOnChanged',
        [   InstanceOf ['LibUI::MultilineEntry'],
            CodeRef [ [ InstanceOf ['LibUI::MultilineEntry'], Any ] => Any ], Any
        ] => Int
    );
    attach( $lib, 'uiMultilineEntryReadOnly', [ InstanceOf ['LibUI::MultilineEntry'] ] => Void );
    attach( $lib, 'uiMultilineEntrySetReadOnly',
        [ InstanceOf ['LibUI::MultilineEntry'], Int ] => Void );
    attach( $lib, 'uiNewMultilineEntry',            [] => InstanceOf ['LibUI::MultilineEntry'] );
    attach( $lib, 'uiNewNonWrappingMultilineEntry', [] => InstanceOf ['LibUI::MultilineEntry'] );

    #_UI_EXTERN void uiWindowOnClosing(uiWindow *w, int (*f)(uiWindow *w, void *data), void *data);
#####warn Dyn::Call::getopts();
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

Affix::libui - It's new $module

=head1 SYNOPSIS

    use Affix::libui;

=head1 DESCRIPTION

Affix::libui is ...

=head1 LICENSE

Copyright (C) Sanko Robinson.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Sanko Robinson E<lt>sanko@cpan.orgE<gt>

=cut

