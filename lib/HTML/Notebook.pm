package HTML::Notebook;

use utf8;

use Moose;
use Text::Template;
use namespace::autoclean;

# VERSION

=encoding utf-8

=head1 NAME

HTML::Notebook - Compose HTML documents using notebook style

=head1 SYNOPSIS

# EXAMPLE: examples/basic.pl
     
=head1 DESCRIPTION

Compose HTML documents using notebook style. Every notebook is composed of HTML::Notebook::Cell objects that you can add, update and remove.

=head1 METHODS

=cut

has 'cells' => (
	traits => ['Array'],
	is => 'rw',
	isa => 'ArrayRef[HTML::Notebook::Cell]',
	default => sub { [] },
	handles => {
		add_cell => 'push',
		get_cell => 'get',
		delete_cell => 'delete',
	}
);

=head2 render

Render object to HTML

=cut

sub render {
	my $self = shift();
    my $html_begin = <<'HTML_BEGIN';
<html>
<head>
<link href="https://maxcdn.bootstrapcdn.com/bootswatch/3.3.7/readable/bootstrap.min.css" rel="stylesheet" integrity="sha384-Li5uVfY2bSkD3WQyiHX8tJd0aMF91rMrQP5aAewFkHkVSTT2TmD2PehZeMmm7aiL" crossorigin="anonymous">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
<style>
body    {padding-top: 25px;}
.cell    {padding-left: 5%; padding-right: 5%; padding-top: 25px; padding-botton: 25px}
</style>
</head>
<body>
HTML_BEGIN

	my $cell_template = <<'CELL';
<div class="cell" id="{$cell_id}">
{$content}
</div>
CELL

	my $body = "";
	my $renderer = Text::Template->new(TYPE => 'STRING', SOURCE => $cell_template);
	my $numeric_id = 0;
	for my $cell (@{$self->cells}) {
		$body .= $renderer->fill_in(HASH => {cell_id => 'cell_' . $numeric_id++,
											 content => $cell->content});
	}

    my $html_end = <<'HTML_END';
</body>
</html>
HTML_END
    return $html_begin . $body . $html_end;
}

__PACKAGE__->meta->make_immutable();

1;

__END__

=head1 AUTHOR

Pablo Rodríguez González

=head1 BUGS

Please report any bugs or feature requests via github: L<https://github.com/pablrod/p5-HTML-Notebook/issues>

=head1 LICENSE AND COPYRIGHT

Copyright 2016 Pablo Rodríguez González.

The MIT License (MIT)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

=cut
