#!/usr/bin/perl

use v5.10;
use strict;
use warnings;

use XML::XSLT;
use XML::DOM;

# File names
my $xml_file = 'api.xml';
my $xsl_file = 'apigen.xsl';
my $htm_file = 'api.html';

# Create instance of XSLT processor
my $xslt = XML::XSLT->new($xsl_file, warnings => 1, debug => 0);

# Load XML
$xslt->open_xml($xml_file);

# Process transformation
$xslt->process(debug => 0);

# Save result

open DOC, ">$htm_file";
print DOC $xslt->toString;
close DOC;

# Free memory
$xslt->dispose;
