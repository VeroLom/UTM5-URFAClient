#!/usr/bin/perl

use strict;
use warnings;

use lib 'lib';
use UTM5::URFAClient;

use Data::Dumper;

my $client = new UTM5::URFAClient({
	path		=> '/netup/utm5',
	user		=> 'nmelikhov',
	password	=> 'nmelikhov789'
});

my $uid = $client->whoami->{my_uid};
my $groups = $client->get_user_groups({ user_id => $uid });

print Dumper($groups);
