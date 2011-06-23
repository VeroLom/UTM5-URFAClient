package UTM5::URFAClient;

use v5.10;
use strict;
use warnings;

=head1 NAME

UTM5::URFAClient - Perl wrapper for Netup URFA Client

=head1 VERSION


Version 0.4

=cut

our $VERSION = '0.4';

=head1 SYNOPSIS

	use UTM5::Client;
	my $client = new UTM5::URFAClient({
		url			=> 'http://example.com/RPC2',
	});
	print $client->whoami->{login};

=cut

use Frontier::Client;
use XML::Twig;

use Carp;
use Data::Dumper;

=head1 SUBROUTINES/METHODS

=head2 new

Creates connection

	UTM5::URFAClient->new({<options>})


=item * url

	Remote host and port with UTM5::URFAClient::Daemon daemon

=back

=cut

sub new {
	my ($class, $self) = @_;

	bless $self, $class;

	# TODO: Check remote/local
	if(not $self->{url}) {
		croak "Daemon URL not specified";
	}

	$self->{_server} = Frontier::Client->new(url => $self->{url});

	return $self;
}

# XML array parsing callback
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

# XML field parsing callback
sub _parse_field {
	my ($data, $element, $isArray) = @_;

	if($element->parent->tag ne 'item' || $isArray) {
		$data->{$element->att('name')} = $element->att('value');
	}
}

# Parse XML response
sub _parse {
	my ($self, $data2, $data) = @_;
	my $result = {};

	if(not $data =~ /^\<\?xml/) {
		$data = '<?xml version="1.0" encoding="utf-8"?>' . $data;
	}

	my $t = XML::Twig->new(twig_handlers => {
		'integer'		=> sub { _parse_field($result, $_) },
		'long'			=> sub { _parse_field($result, $_) },
		'double'		=> sub { _parse_field($result, $_) },
		'string'		=> sub { _parse_field($result, $_) },
		'ip_address'	=> sub { _parse_field($result, $_) },
		'array'			=> sub { _parse_array($result, @_) },
	})->parse($data);

	return $result;
}

sub _exec {
	my ($self, $cmd, $params) = @_;

	# TODO: Remote/local request
	my $call = $self->{_server}->call('query', $cmd, $params);
	#warn "\nCALL: $call\n\n";

	my $result = $self->_parse($self, $call);

	return $result;
}

# = = = = = = = = = = = =   URFAClient Functions   = = = = = = = = = = = = #

=head2 whoami

	Returns current user info

=cut

sub whoami {
	my ($self, $params) = @_;

	return $self->_exec('rpcf_whoami');
}

### USERS ###

=head2 user_list

	Returns user list

=cut

sub user_list {
	my ($self, $params) = @_;

	my $criteria_id = {
		'LIKE'		=> 1,
		'='			=> 3,
		'<>'		=> 4,
		'>'			=> 7,
		'<'			=> 8,
		'>='		=> 9,
		'<='		=> 10,
		'NOT LIKE'	=> 11
	};

	my $what_id = {
		'User ID'				=> 1,
		'User login'			=> 2,
		'Basic account'			=> 3,
		'Accounting perion id'	=> 4,
		'Full name'				=> 5,
		'Create date'			=> 6,
		'Last change date'		=> 7,
		'Who create'			=> 8,
		'who change'			=> 9,
		'Is legal'				=> 10,
		'Juridical address'		=> 11,
		'Actual address'		=> 12,
		'Work phone'			=> 13,
		'Home phone'			=> 14,
		'Mobile phone'			=> 15,
		'Web page'				=> 16,
		'ICQ number'			=> 17,
		'Tax number'			=> 18,
		'KPP number'			=> 19,
		'House id'				=> 21,
		'Flat number'			=> 22,
		'Entrance'				=> 23,
		'Floor'					=> 24,
		'Email'					=> 25,
		'Passport'				=> 26,
		'IP'					=> 28,
		'Group ID'				=> 30,
		'Balance'				=> 31,
		'Personal manager'		=> 32,
		'Connect date'			=> 33,
		'Comments'				=> 34,
		'Internet status'		=> 35,
		'Tariff ID'				=> 36,
		'Service ID'			=> 37,
		'Slink ID'				=> 38,
		'TPLink ID'				=> 39,
		'District'				=> 40,
		'Building'				=> 41,
		'MAC'					=> 42,
		'Login in service link'	=> 43,
		'External ID'			=> 44
	};


}

=head2 get_user_groups

	Return users groups array

=cut

sub get_user_groups {
	my ($self, $params) = @_;

	#return () if not $params->{user_id};

	return $self->_exec('rpcf_get_groups_list', { user_id => $params->{user_id} });
}

### HOUSES ###

=head2 get_houses_list

	Return houses list

=cut

sub get_houses_list {
	my ($self, $params) = @_;

	return $self->_exec('rpcf_get_houses_list');
}


=head2 get_house

	Return house data

=cut

sub get_house {
	my ($self, $params) = @_;

	return {} if not int($params->{house_id});

	return $self->_exec('rpcf_get_house', { house_id => $params->{house_id} });
}


### IPZONES ###

=head2 get_ipzones_list

	Return ip-zones list

=cut

sub get_ipzones_list {
	my ($self, $params) = @_;

	return $self->_exec('rpcf_get_ipzones_list');
}


=head1 AUTHOR

Nikita Melikhov, C<< <ver at 0xff.su> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-utm5-urfaclient at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=UTM5-URFAClient>.
I will be notified, and then you'll automatically be notified of progress on your bug as I make changes.



=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc UTM5::URFAClient


You can also look for information at:

=over 4

=item * Netup official site

L<http://www.netup.ru/>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=UTM5-URFAClient>

=back


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Nikita Melikhov.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of UTM5::URFAClient
