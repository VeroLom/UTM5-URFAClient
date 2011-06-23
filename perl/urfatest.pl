#!/usr/bin/perl

use strict;
use warnings;

use lib 'UTM5-URFAClient/lib';
use UTM5::URFAClient;

use encoding 'utf-8';

use Data::Dumper;

my $client = new UTM5::URFAClient({
	url => 'http://stat.unisnet.ru:39238/RPC2'
});

my $uid = $client->whoami->{my_uid};
print "USER_ID: $uid\n";
my $list = $client->get_user_groups({ user_id => $uid });

#my $list = $client->get_houses_list;

#my $house = @{$list->{houses_size}}[1];

#print "HOUSE_ID : ".$house->{house_id}."\n";
#print "STREET   : ".$house->{street}.", ".$house->{number}."\n";

print Dumper($list);
