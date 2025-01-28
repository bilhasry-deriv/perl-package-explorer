#!/usr/bin/env perl
use strict;
use warnings;
use JSON;
use File::Find;
use File::Spec;
use Getopt::Long;
use Cwd 'abs_path';

# Initialize variables
my $target_dir;
my $output_file = 'package_map.json';
my $help;

# Parse command line options
GetOptions(
    "dir=s"     => \$target_dir,    # string
    "output=s"  => \$output_file,   # string
    "help"      => \$help           # flag
) or die usage();

# Show help if requested or if no directory specified
if ($help || !$target_dir) {
    print usage();
    exit;
}

# Verify directory exists
die "Directory '$target_dir' does not exist!\n" unless -d $target_dir;

# Convert to absolute path
$target_dir = abs_path($target_dir);

my %package_map;

# Function to process each .pm file
sub process_file {
    return unless -f && /\.pm$/;  # Only process .pm files
    
    my $file = $File::Find::name;
    my $relative_path = File::Spec->abs2rel($file, $target_dir);
    
    # Read the file content
    open(my $fh, '<', $file) or die "Cannot open file $file: $!";
    my $content = do { local $/; <$fh> };
    close $fh;
    
    # Look for package declaration
    if ($content =~ /^\s*package\s+([^;]+?)\s*;/m) {
        my $package_name = $1;
        # Convert Windows path separators to forward slashes if needed
        $relative_path =~ s/\\/\//g;
        $package_map{$package_name} = $relative_path;
    }
}

# Find all .pm files
find(\&process_file, $target_dir);

# Create JSON output
my $json = JSON->new->pretty(1);
my $json_output = $json->encode(\%package_map);

# Write to file
open(my $out_fh, '>', $output_file) or die "Cannot open output file: $!";
print $out_fh $json_output;
close $out_fh;

print "Package mapping has been written to $output_file\n";

sub usage {
    return <<END_USAGE;
Usage: $0 --dir=<directory> [--output=<output_file>] [--help]

Options:
    --dir     Directory to scan for Perl modules (required)
    --output  Output JSON file (default: package_map.json)
    --help    Show this help message

Example:
    $0 --dir=/path/to/perl/modules
    $0 --dir=./lib --output=modules.json
END_USAGE
}