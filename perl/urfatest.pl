#!/usr/bin/perl

use strict;
use warnings;

use lib 'UTM5-URFAClient/lib';
use UTM5::URFAClient;

use Data::Dumper;

my $client = new UTM5::URFAClient({
	host		=> 'stat.unisnet.ru',
	login		=> 'root',
	exec		=> '/netup/utm5/bin/utm5_urfaclient',
	user		=> 'nmelikhov',
	password	=> 'nmelikhov789'
});

#print $client->_exec("whoami");

#my $r = $client->whoami;
my $r = $client->_exec('search_users');


print Dumper($r);
