#!/usr/bin/env perl
use strict;
use warnings;

use Crypt::Blowfish;
use MIME::Base64;
use Digest::SHA qw(sha256);

# Generate a strong, random 256-bit key
my $key_size = 32; # 256 bits
my $key = sha256(rand().rand().time());

# Alternatively, you can generate a key from a passphrase:
# my $passphrase = "my-secret-password";
# my $key = sha256($passphrase);

# Encode the key in Base64 for easy use in config files
my $base64_key = encode_base64($key, '');

# Print the key to standard output
print "$base64_key\n";

