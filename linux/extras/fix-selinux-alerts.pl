#!/usr/bin/perl
use strict;
use warnings;

# todo - arrange for proper handling of "nothing to do" output from ausearch 

our @outerloop;
our @innerloop;
our @results;

our $event;
our $action;
our $output;

our $status = 0;

our $alert;
our $query;
our $solution;
our $result;

# $command gets a list of selinux alerts
my $command=qq%grep sealert /var/log/messages|awk -F'sealert -l' '{ print \$2 }' | sort -u%;

# list of selinux alerts stored in @outerloop
@outerloop = `$command`;

# check each event from @outerloop 
foreach (@outerloop) {
  $event = $_;
# is alert valid? return code from sealert -l #id will be 0 if valid
  $action=qq%sealert -l $event%;
  $output = `$action`;
# perl oddity - have to shift the return code right 8 places to get "normal" result
  $status = $? >> 8;
# if alert is valid, save it in the array @innerloop
  if ( $status == 0 ) {
    print  "adding valid alert $_\n";
    push @innerloop, $_;
  }
}

foreach $alert (@innerloop) {
  chomp $alert;
  $query=qq%sealert -l $alert | grep '^#' | awk -F# '{ print \$2 }' | grep 'ausearch -c'%;

  $solution = `$query`;

  @results = `$solution`;

  # extract the line of interest from the results
  foreach (@results) {
    if (/semodule/) {
      $result = $_;
      print "semodule instruction: ", $result
    }
  }
 
  if ($result ne "") {

    print "result: ", $result;

    print "updating selinux policy for $event...\n";
    print "About to run:\n", $result;
    #  `$result`;
    system($result);
   } else {
    print "Nothing to do";
   }
}

