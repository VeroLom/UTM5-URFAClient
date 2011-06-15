package UTM5::URFAClient;

use strict;
use warnings;

use Net::SSH::Perl;
use XML::Twig;

our $VERSION = "1.0";

sub new {
	my ($class, $self) = @_;

	bless $self, $class;

	#warn " * Initializing SSH connection to $self->{host}...";
	$self->{ssh} = Net::SSH::Perl->new($self->{host}, { debug => 1 });
	#warn "DONE\n";
	#warn " * Logging in, user: $self->{login}...";
	$self->{ssh}->login($self->{login}) || die "ssh: $!";
	#print "DONE\n";

	return $self;
}

sub ssh {
	my $self = shift;

	return $self->{ssh} if $self->{ssh};
	die "Errors while connecting via SSH";
}

sub _parse_array {
	my ($data, $t, $array) = @_;
	my $name = $array->prev_sibling('integer')->att('name');
	$data->{$name} = [];

	foreach my $item ($array->children('item')) {
		my $item_data = {};

		foreach my $child ($item->children) {
			_parse_field($item_data, $child, 1);
		}

		push @{$data->{$name}}, $item_data;
	}
}

sub _parse_field {
	my ($data, $element, $isArray) = @_;

	if($element->parent->tag ne 'item' || $isArray) {
		$data->{$element->att('name')} = $element->att('value');
	}
}

sub _parse {
	my ($self, $data) = @_;
	my $result = {};

	my $t = XML::Twig->new(twig_handlers => {
		'integer'		=> sub { _parse_field($result, $_) },
		'string'		=> sub { _parse_field($result, $_) },
		'ip_address'	=> sub { _parse_field($result, $_) },
		'array'			=> sub { _parse_array($result, @_) },
	})->parse($data);

	return $result;
}

sub _exec {
	my $self = shift;
	my $cmd = shift;

	#print " * Executing SSH command: $cmd";
	my ($stdout, $stderr, $exit) = $self->ssh->cmd("$self->{exec} -l '$self->{user}' -P '$self->{password}' -a $cmd");
	#print "DONE\n\n";

	my $result = _parse($self, $stdout);

	return $result;
}

# = = = = = = = = = = = =   URFAClient Functions   = = = = = = = = = = = = #



1;
