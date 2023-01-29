package LibUI::Draw::Matrix 0.02 {
    use 5.008001;
    use strict;
    use warnings;
    use Affix;
    #
    typedef 'LibUI::Draw::Matrix' => Struct [
        M11 => Double,
        M12 => Double,
        M21 => Double,
        M22 => Double,
        M31 => Double,
        M32 => Double
    ];
    #
    affix(
        LibUI::lib(), 'uiDrawMatrixSetIdentity', [ Pointer [ LibUI::Draw::Matrix() ] ] => Void,
        'setIdentity'
    );
    affix(
        LibUI::lib(), 'uiDrawMatrixTranslate',
        [ Pointer [ LibUI::Draw::Matrix() ], Double, Double ] => Void,
        'translate'
    );
    affix(
        LibUI::lib(), 'uiDrawMatrixScale',
        [ Pointer [ LibUI::Draw::Matrix() ], Double, Double, Double, Double ] => Void,
        'scale'
    );
    affix(
        LibUI::lib(), 'uiDrawMatrixRotate',
        [ Pointer [ LibUI::Draw::Matrix() ], Double, Double, Double ] => Void,
        'rotate'
    );
    affix(
        LibUI::lib(), 'uiDrawMatrixSkew',
        [ Pointer [ LibUI::Draw::Matrix() ], Double, Double, Double, Double ] => Void,
        'skew'
    );
    affix(
        LibUI::lib(), 'uiDrawMatrixMultiply',
        [ Pointer [ LibUI::Draw::Matrix() ], Pointer [ LibUI::Draw::Matrix() ] ] => Void,
        'multiply'
    );
    affix(
        LibUI::lib(), 'uiDrawMatrixInvertible', [ Pointer [ LibUI::Draw::Matrix() ] ] => Int,
        'invertible'
    );
    affix(
        LibUI::lib(), 'uiDrawMatrixInvert', [ Pointer [ LibUI::Draw::Matrix() ] ] => Int,
        'invert'
    );
    affix(
        LibUI::lib(), 'uiDrawMatrixTransformPoint',
        [ Pointer [ LibUI::Draw::Matrix() ], Pointer [Double], Pointer [Double] ] => Void,
        'transformPoint'
    );
    affix(
        LibUI::lib(), 'uiDrawMatrixTransformSize',
        [ Pointer [ LibUI::Draw::Matrix() ], Pointer [Double], Pointer [Double] ] => Void,
        'transformSize'
    );
};
1;
#
__END__

=pod

=encoding utf-8

=head1 NAME

LibUI::Draw::Matrix - TODO

=head1 SYNOPSIS

    TODO

=head1 DESCRIPTION

A LibUI::Button object represents a control that visually represents a button
to be clicked by the user to trigger an action.

=head1 Functions

Not a lot here but... well, it's just a button.

=head2 C<new( ... )>

    my $btn = LibUI::Button->new( 'Click me!' );

Creates a new button.

=head2 C<onClicked( ... )>

    $btn->onClicked(
    sub {
        my ($ctrl, $data) = @_;
        ...;
    }, undef);

Registers a callback for when the button is clicked.

Expected parameters include:

=over

=item C<$callback> - CodeRef that should expect the following:

=over

=item C<$btn> - backreference to the instance that initiated the callback

=item C<$data> - user data registered with the sender instance

=back

=item C<$data> - user data to be passed to the callback

=back

=head2 C<setText( ... )>

    $btn->setText( 'Scan' );

Sets the button label text.

=head2 C<text( )>

    my $txt = $btn->text;

Sets the button label text.

=head1 LICENSE

Copyright (C) Sanko Robinson.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=head1 AUTHOR

Sanko Robinson E<lt>sanko@cpan.orgE<gt>

=for stopwords checkbox backreference

=cut

