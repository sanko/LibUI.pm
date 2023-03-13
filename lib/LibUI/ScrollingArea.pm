package LibUI::ScrollingArea 0.03 {
    use 5.008001;
    use strict;
    use warnings;
    use Affix;
    use parent 'LibUI::Area';
    #
    affix(
        LibUI::lib(),
        [ 'uiAreaSetSize', 'setSize' ],
        [ InstanceOf ['LibUI::Area'], Int, Int ] => Void
    );
    affix(
        LibUI::lib(),
        [ 'uiAreaScrollTo', 'scrollTo' ],
        [ InstanceOf ['LibUI::Area'], Double, Double, Double, Double ] => Void
    );
};
1;
#
__END__

=pod

=encoding utf-8

=head1 NAME

LibUI::ScrollingArea - Control Representing a Canvas You May Draw On but with
Scrollbars Now

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


=head1 LICENSE

Copyright (C) Sanko Robinson.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=head1 AUTHOR

Sanko Robinson E<lt>sanko@cpan.orgE<gt>

=for stopwords scrollbars

=cut

