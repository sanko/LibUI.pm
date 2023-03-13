package LibUI::Area 0.03 {
    use 5.008001;
    use strict;
    use warnings;
    use Affix;
    use LibUI::Window::ResizeEdge;
    use LibUI::Area::DrawParams;
    use LibUI::Area::MouseEvent;
    use LibUI::Area::KeyEvent;
    use parent 'LibUI::Control';
    #
    sub new {
        my ( $class, $h ) = @_;
        CORE::state $new;
        my $func = $class;    # A little work to make it auto-wrap sublcasses
        $func =~ s[LibUI::][uiNew];
        $new->{$class} //= wrap(
            LibUI::lib(),
            $func,
            [   Pointer [
                    Struct [
                        draw => CodeRef [
                            [   Pointer [ InstanceOf ['LibUI::Area::Handler'] ],
                                Pointer [ InstanceOf ['LibUI::Area'] ],
                                Pointer [ InstanceOf ['LibUI::Area::DrawParams'] ]
                            ] => Void
                        ],
                        mouseEvent => CodeRef [
                            [   Pointer [ InstanceOf ['LibUI::Area::Handler'] ],
                                Pointer [ InstanceOf ['LibUI::Area'] ],
                                Pointer [ InstanceOf ['LibUI::Area::MouseEvent'] ]
                            ] => Void
                        ],
                        mouseCrossed => CodeRef [
                            [   Pointer [ InstanceOf ['LibUI::Area::Handler'] ],
                                Pointer [ InstanceOf ['LibUI::Area'] ],
                                Int
                            ] => Void
                        ],
                        dragBroken => CodeRef [
                            [   Pointer [ InstanceOf ['LibUI::Area::Handler'] ],
                                Pointer [ InstanceOf ['LibUI::Area'] ]
                            ] => Void
                        ],
                        keyEvent => CodeRef [
                            [   Pointer [ InstanceOf ['LibUI::Area::Handler'] ],
                                Pointer [ InstanceOf ['LibUI::Area'] ],
                                Pointer [ InstanceOf ['LibUI::Area::KeyEvent'] ]
                            ] => Int
                        ]
                    ]
                ]
            ] => InstanceOf [$class]
        );

        # wrap handler methods to auto-dereference pointers
        $new->{$class}->(
            {   draw => defined $h->{draw} ?
                    sub {
                    my ( $handler, $area, $drawParams ) = @_;
                    $h->{draw}->(
                        $area,
                        Affix::ptr2sv(
                            $drawParams, Pointer [ InstanceOf ['LibUI::Area::DrawParams'] ]
                        )
                    );
                    } :
                    sub { },
                dragBroken => defined $h->{dragBroken} ?
                    sub {
                    my ( $handler, $area ) = @_;
                    $h->{dragBroken}->($area);
                    } :
                    sub { },
                keyEvent => defined $h->{keyEvent} ?
                    sub {
                    my ( $handler, $area, $event ) = @_;
                    $h->{keyEvent}->(
                        $area,
                        Affix::ptr2sv( $event, Pointer [ InstanceOf ['LibUI::Area::KeyEvent'] ] )
                    );
                    } :
                    sub { },
                mouseCrossed => defined $h->{mouseCrossed} ?
                    sub {
                    my ( $handler, $area, $left ) = @_;
                    $h->{mouseCrossed}->( $area, $left );
                    } :
                    sub { },
                mouseEvent => defined $h->{mouseEvent} ?
                    sub {
                    my ( $handler, $area, $event ) = @_;
                    $h->{mouseEvent}->(
                        $area,
                        Affix::ptr2sv( $event, Pointer [ InstanceOf ['LibUI::Area::MouseEvent'] ] )
                    );
                    } :
                    sub { }
            }
        );
    }
    affix(
        LibUI::lib(),
        [ 'uiAreaQueueRedrawAll', 'queueRedrawAll' ],
        [ InstanceOf ['LibUI::Area'] ] => Void
    );
    affix(
        LibUI::lib(),
        [ 'uiAreaBeginUserWindowMove', 'beginUserWindowMove' ],
        [ InstanceOf ['LibUI::Area'] ] => Void
    );
    affix(
        LibUI::lib(),
        [ 'uiAreaBeginUserWindowResize', 'beginUserWindowResize' ],
        [ InstanceOf ['LibUI::Area'],    LibUI::Window::ResizeEdge() ] => Void
    );
};
1;
#
__END__

=pod

=encoding utf-8

=head1 NAME

LibUI::Area - Control Representing a Canvas You May Draw On

=head1 SYNOPSIS

    TODO

=head1 DESCRIPTION

A LibUI::Area object represents a control you may draw on. It receives keyboard
and mouse events, supports scrolling, is DPI aware, and has several other
useful features. The control consists of the drawing area itself and horizontal
and vertical scrollbars.

A LibUI::Area is driven by an L<area handler|LibUI::Area::Handler>.

=head1 Functions

Not a lot here but... well, it's just a, interactive box.

=head2 C<new( ... )>

    my $area = LibUI::Area->new( );

Creates a new form.

A LibUI::Area may accept several methods that are called to handle certain
tasks.

To create an area handler, pass a hash reference which contains the following
keys (all are optional):

=over

=item C<draw>

Provide a code reference which should expect...

=over

=item C<$area> - pointer to the LibUI::Area object

=item C<$drawParams> - pointer to the LibUI::Area::DrawParams structure

=back

...and return void.


=item C<mouseEvent>

Provide a code reference which should expect...

=over

=item C<$area> - pointer to the LibUI::Area object

=item C<$event> - pointer to the LibUI::Area::MouseEvent structure

=back

...and return void.

=item C<mouseCrossed>

Provide a code reference which should expect...

=over

=item C<$area> - pointer to the LibUI::Area object

=back

...and return void.

=item C<dragBroken>

Provide a code reference which should expect...

=over

=item C<$area> - pointer to the LibUI::Area object

=back

...and return void.

Note that there is no support for this event on GTK+ or MacOS.

=item C<keyEvent>

Provide a code reference which should expect...

=over

=item C<$area> - pointer to the LibUI::Area object

=item C<$event> - pointer to the LibUI::Area::KeyEvent structure

=back

...and return an integer.

=back

=head1 LICENSE

Copyright (C) Sanko Robinson.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=head1 AUTHOR

Sanko Robinson E<lt>sanko@cpan.orgE<gt>

=for stopwords MacOS scrollbars

=cut

