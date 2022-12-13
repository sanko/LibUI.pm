requires 'perl', '5.014000';
requires 'Alien::libui';
requires 'Time::Local', '1.30';
requires 'Time::Piece';
requires 'Affix', '0.05';
on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Test::NeedsDisplay';
};
