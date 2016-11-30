use strict;

sub install_func {
my $cmd = "git clone https://github.com/earonesty/ea-utils\n";
   $cmd .= "cd ea-utils/clipper\n";
   $cmd .= "make\n";
   $cmd .= "cp fastq-stats /usr/local/bin\n";
   $cmd .= "which fastq-stats\n";
   $cmd .= "cp fastq-multx /usr/local/bin\n";
   $cmd .= "which fastq-multx\n";
   $cmd .= "cp fastq-join /usr/local/bin\n";
   $cmd .= "which fastq-join\n";
   $cmd .= "cp determine-phred /usr/local/bin\n";
   $cmd .= "which determine-phred\n";
   system ($cmd);
}


eval { install_func(); };
print "Error captured : $@\n";
