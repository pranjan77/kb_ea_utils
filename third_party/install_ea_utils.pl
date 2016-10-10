use strict;

sub install_func {
my $cmd = "git clone https://github.com/earonesty/ea-utils\n";
   $cmd .= "cd ea-utils/clipper\n";
   $cmd .= "make\n";
   $cmd .= "cp fastq-stats /usr/local/bin\n";
   $cmd .= "which fastq-stats\n";
   system ($cmd);
}


eval { install_func(); };
print "Error captured : $@\n";
