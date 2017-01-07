package kb_ea_utils_dev::kb_ea_utils_devClient;

use JSON::RPC::Client;
use POSIX;
use strict;
use Data::Dumper;
use URI;
use Bio::KBase::Exceptions;
my $get_time = sub { time, 0 };
eval {
    require Time::HiRes;
    $get_time = sub { Time::HiRes::gettimeofday() };
};

use Bio::KBase::AuthToken;

# Client version should match Impl version
# This is a Semantic Version number,
# http://semver.org
our $VERSION = "0.1.0";

=head1 NAME

kb_ea_utils_dev::kb_ea_utils_devClient

=head1 DESCRIPTION


Utilities for converting KBaseAssembly types to KBaseFile types


=cut

sub new
{
    my($class, $url, @args) = @_;
    

    my $self = {
	client => kb_ea_utils_dev::kb_ea_utils_devClient::RpcClient->new,
	url => $url,
	headers => [],
    };

    chomp($self->{hostname} = `hostname`);
    $self->{hostname} ||= 'unknown-host';

    #
    # Set up for propagating KBRPC_TAG and KBRPC_METADATA environment variables through
    # to invoked services. If these values are not set, we create a new tag
    # and a metadata field with basic information about the invoking script.
    #
    if ($ENV{KBRPC_TAG})
    {
	$self->{kbrpc_tag} = $ENV{KBRPC_TAG};
    }
    else
    {
	my ($t, $us) = &$get_time();
	$us = sprintf("%06d", $us);
	my $ts = strftime("%Y-%m-%dT%H:%M:%S.${us}Z", gmtime $t);
	$self->{kbrpc_tag} = "C:$0:$self->{hostname}:$$:$ts";
    }
    push(@{$self->{headers}}, 'Kbrpc-Tag', $self->{kbrpc_tag});

    if ($ENV{KBRPC_METADATA})
    {
	$self->{kbrpc_metadata} = $ENV{KBRPC_METADATA};
	push(@{$self->{headers}}, 'Kbrpc-Metadata', $self->{kbrpc_metadata});
    }

    if ($ENV{KBRPC_ERROR_DEST})
    {
	$self->{kbrpc_error_dest} = $ENV{KBRPC_ERROR_DEST};
	push(@{$self->{headers}}, 'Kbrpc-Errordest', $self->{kbrpc_error_dest});
    }

    #
    # This module requires authentication.
    #
    # We create an auth token, passing through the arguments that we were (hopefully) given.

    {
	my $token = Bio::KBase::AuthToken->new(@args);
	
	if (!$token->error_message)
	{
	    $self->{token} = $token->token;
	    $self->{client}->{token} = $token->token;
	}
        else
        {
	    #
	    # All methods in this module require authentication. In this case, if we
	    # don't have a token, we can't continue.
	    #
	    die "Authentication failed: " . $token->error_message;
	}
    }

    my $ua = $self->{client}->ua;	 
    my $timeout = $ENV{CDMI_TIMEOUT} || (30 * 60);	 
    $ua->timeout($timeout);
    bless $self, $class;
    #    $self->_validate_version();
    return $self;
}




=head2 get_fastq_ea_utils_stats

  $ea_utils_stats = $obj->get_fastq_ea_utils_stats($input_params)

=over 4

=item Parameter and return types

=begin html

<pre>
$input_params is a kb_ea_utils_dev.get_fastq_ea_utils_stats_params
$ea_utils_stats is a string
get_fastq_ea_utils_stats_params is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a string
	read_library_name has a value which is a string
	read_library_ref has a value which is a string

</pre>

=end html

=begin text

$input_params is a kb_ea_utils_dev.get_fastq_ea_utils_stats_params
$ea_utils_stats is a string
get_fastq_ea_utils_stats_params is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a string
	read_library_name has a value which is a string
	read_library_ref has a value which is a string


=end text

=item Description

This function should be used for getting statistics on read library object types 
The results are returned as a string.

=back

=cut

 sub get_fastq_ea_utils_stats
{
    my($self, @args) = @_;

# Authentication: required

    if ((my $n = @args) != 1)
    {
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error =>
							       "Invalid argument count for function get_fastq_ea_utils_stats (received $n, expecting 1)");
    }
    {
	my($input_params) = @args;

	my @_bad_arguments;
        (ref($input_params) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument 1 \"input_params\" (value was \"$input_params\")");
        if (@_bad_arguments) {
	    my $msg = "Invalid arguments passed to get_fastq_ea_utils_stats:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	    Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
								   method_name => 'get_fastq_ea_utils_stats');
	}
    }

    my $url = $self->{url};
    my $result = $self->{client}->call($url, $self->{headers}, {
	    method => "kb_ea_utils_dev.get_fastq_ea_utils_stats",
	    params => \@args,
    });
    if ($result) {
	if ($result->is_error) {
	    Bio::KBase::Exceptions::JSONRPC->throw(error => $result->error_message,
					       code => $result->content->{error}->{code},
					       method_name => 'get_fastq_ea_utils_stats',
					       data => $result->content->{error}->{error} # JSON::RPC::ReturnObject only supports JSONRPC 1.1 or 1.O
					      );
	} else {
	    return wantarray ? @{$result->result} : $result->result->[0];
	}
    } else {
        Bio::KBase::Exceptions::HTTP->throw(error => "Error invoking method get_fastq_ea_utils_stats",
					    status_line => $self->{client}->status_line,
					    method_name => 'get_fastq_ea_utils_stats',
				       );
    }
}
 


=head2 run_app_fastq_ea_utils_stats

  $report = $obj->run_app_fastq_ea_utils_stats($input_params)

=over 4

=item Parameter and return types

=begin html

<pre>
$input_params is a kb_ea_utils_dev.run_app_fastq_ea_utils_stats_params
$report is a kb_ea_utils_dev.Report
run_app_fastq_ea_utils_stats_params is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a string
	read_library_name has a value which is a string
	read_library_ref has a value which is a string
Report is a reference to a hash where the following keys are defined:
	report_name has a value which is a string
	report_ref has a value which is a string

</pre>

=end html

=begin text

$input_params is a kb_ea_utils_dev.run_app_fastq_ea_utils_stats_params
$report is a kb_ea_utils_dev.Report
run_app_fastq_ea_utils_stats_params is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a string
	read_library_name has a value which is a string
	read_library_ref has a value which is a string
Report is a reference to a hash where the following keys are defined:
	report_name has a value which is a string
	report_ref has a value which is a string


=end text

=item Description

This function should be used for getting statistics on read library object type.
The results are returned as a report type object.

=back

=cut

 sub run_app_fastq_ea_utils_stats
{
    my($self, @args) = @_;

# Authentication: required

    if ((my $n = @args) != 1)
    {
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error =>
							       "Invalid argument count for function run_app_fastq_ea_utils_stats (received $n, expecting 1)");
    }
    {
	my($input_params) = @args;

	my @_bad_arguments;
        (ref($input_params) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument 1 \"input_params\" (value was \"$input_params\")");
        if (@_bad_arguments) {
	    my $msg = "Invalid arguments passed to run_app_fastq_ea_utils_stats:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	    Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
								   method_name => 'run_app_fastq_ea_utils_stats');
	}
    }

    my $url = $self->{url};
    my $result = $self->{client}->call($url, $self->{headers}, {
	    method => "kb_ea_utils_dev.run_app_fastq_ea_utils_stats",
	    params => \@args,
    });
    if ($result) {
	if ($result->is_error) {
	    Bio::KBase::Exceptions::JSONRPC->throw(error => $result->error_message,
					       code => $result->content->{error}->{code},
					       method_name => 'run_app_fastq_ea_utils_stats',
					       data => $result->content->{error}->{error} # JSON::RPC::ReturnObject only supports JSONRPC 1.1 or 1.O
					      );
	} else {
	    return wantarray ? @{$result->result} : $result->result->[0];
	}
    } else {
        Bio::KBase::Exceptions::HTTP->throw(error => "Error invoking method run_app_fastq_ea_utils_stats",
					    status_line => $self->{client}->status_line,
					    method_name => 'run_app_fastq_ea_utils_stats',
				       );
    }
}
 


=head2 get_ea_utils_stats

  $report = $obj->get_ea_utils_stats($input_params)

=over 4

=item Parameter and return types

=begin html

<pre>
$input_params is a kb_ea_utils_dev.ea_utils_params
$report is a string
ea_utils_params is a reference to a hash where the following keys are defined:
	read_library_path has a value which is a string

</pre>

=end html

=begin text

$input_params is a kb_ea_utils_dev.ea_utils_params
$report is a string
ea_utils_params is a reference to a hash where the following keys are defined:
	read_library_path has a value which is a string


=end text

=item Description

This function should be used for getting statistics on fastq files. Input is string of file path.
Output is a report string.

=back

=cut

 sub get_ea_utils_stats
{
    my($self, @args) = @_;

# Authentication: required

    if ((my $n = @args) != 1)
    {
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error =>
							       "Invalid argument count for function get_ea_utils_stats (received $n, expecting 1)");
    }
    {
	my($input_params) = @args;

	my @_bad_arguments;
        (ref($input_params) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument 1 \"input_params\" (value was \"$input_params\")");
        if (@_bad_arguments) {
	    my $msg = "Invalid arguments passed to get_ea_utils_stats:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	    Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
								   method_name => 'get_ea_utils_stats');
	}
    }

    my $url = $self->{url};
    my $result = $self->{client}->call($url, $self->{headers}, {
	    method => "kb_ea_utils_dev.get_ea_utils_stats",
	    params => \@args,
    });
    if ($result) {
	if ($result->is_error) {
	    Bio::KBase::Exceptions::JSONRPC->throw(error => $result->error_message,
					       code => $result->content->{error}->{code},
					       method_name => 'get_ea_utils_stats',
					       data => $result->content->{error}->{error} # JSON::RPC::ReturnObject only supports JSONRPC 1.1 or 1.O
					      );
	} else {
	    return wantarray ? @{$result->result} : $result->result->[0];
	}
    } else {
        Bio::KBase::Exceptions::HTTP->throw(error => "Error invoking method get_ea_utils_stats",
					    status_line => $self->{client}->status_line,
					    method_name => 'get_ea_utils_stats',
				       );
    }
}
 


=head2 calculate_fastq_stats

  $ea_stats = $obj->calculate_fastq_stats($input_params)

=over 4

=item Parameter and return types

=begin html

<pre>
$input_params is a kb_ea_utils_dev.ea_utils_params
$ea_stats is a kb_ea_utils_dev.ea_report
ea_utils_params is a reference to a hash where the following keys are defined:
	read_library_path has a value which is a string
ea_report is a reference to a hash where the following keys are defined:
	read_count has a value which is an int
	total_bases has a value which is an int
	gc_content has a value which is a float
	read_length_mean has a value which is a float
	read_length_stdev has a value which is a float
	phred_type has a value which is a string
	number_of_duplicates has a value which is an int
	qual_min has a value which is a float
	qual_max has a value which is a float
	qual_mean has a value which is a float
	qual_stdev has a value which is a float
	base_percentages has a value which is a reference to a hash where the key is a string and the value is a float

</pre>

=end html

=begin text

$input_params is a kb_ea_utils_dev.ea_utils_params
$ea_stats is a kb_ea_utils_dev.ea_report
ea_utils_params is a reference to a hash where the following keys are defined:
	read_library_path has a value which is a string
ea_report is a reference to a hash where the following keys are defined:
	read_count has a value which is an int
	total_bases has a value which is an int
	gc_content has a value which is a float
	read_length_mean has a value which is a float
	read_length_stdev has a value which is a float
	phred_type has a value which is a string
	number_of_duplicates has a value which is an int
	qual_min has a value which is a float
	qual_max has a value which is a float
	qual_mean has a value which is a float
	qual_stdev has a value which is a float
	base_percentages has a value which is a reference to a hash where the key is a string and the value is a float


=end text

=item Description

This function should be used for getting statistics on fastq files. Input is string of file path.
Output is a data structure with different fields.

=back

=cut

 sub calculate_fastq_stats
{
    my($self, @args) = @_;

# Authentication: required

    if ((my $n = @args) != 1)
    {
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error =>
							       "Invalid argument count for function calculate_fastq_stats (received $n, expecting 1)");
    }
    {
	my($input_params) = @args;

	my @_bad_arguments;
        (ref($input_params) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument 1 \"input_params\" (value was \"$input_params\")");
        if (@_bad_arguments) {
	    my $msg = "Invalid arguments passed to calculate_fastq_stats:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	    Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
								   method_name => 'calculate_fastq_stats');
	}
    }

    my $url = $self->{url};
    my $result = $self->{client}->call($url, $self->{headers}, {
	    method => "kb_ea_utils_dev.calculate_fastq_stats",
	    params => \@args,
    });
    if ($result) {
	if ($result->is_error) {
	    Bio::KBase::Exceptions::JSONRPC->throw(error => $result->error_message,
					       code => $result->content->{error}->{code},
					       method_name => 'calculate_fastq_stats',
					       data => $result->content->{error}->{error} # JSON::RPC::ReturnObject only supports JSONRPC 1.1 or 1.O
					      );
	} else {
	    return wantarray ? @{$result->result} : $result->result->[0];
	}
    } else {
        Bio::KBase::Exceptions::HTTP->throw(error => "Error invoking method calculate_fastq_stats",
					    status_line => $self->{client}->status_line,
					    method_name => 'calculate_fastq_stats',
				       );
    }
}
 


=head2 run_Fastq_Multx

  $returnVal = $obj->run_Fastq_Multx($params)

=over 4

=item Parameter and return types

=begin html

<pre>
$params is a kb_ea_utils_dev.run_Fastq_Multx_Input
$returnVal is a kb_ea_utils_dev.run_Fastq_Multx_Output
run_Fastq_Multx_Input is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a kb_ea_utils_dev.workspace_name
	index_info has a value which is a kb_ea_utils_dev.textarea_str
	desc has a value which is a string
	index_mode has a value which is a string
	input_reads_ref has a value which is a kb_ea_utils_dev.data_obj_ref
	input_index_ref has a value which is a kb_ea_utils_dev.data_obj_ref
	output_reads_name has a value which is a kb_ea_utils_dev.data_obj_name
	barcode_options has a value which is a kb_ea_utils_dev.Barcode_Options
	force_edge_options has a value which is a kb_ea_utils_dev.ForceEdge_Options
	dist_and_qual_params has a value which is a kb_ea_utils_dev.DistAndQual_Params
workspace_name is a string
textarea_str is a string
data_obj_ref is a string
data_obj_name is a string
Barcode_Options is a reference to a hash where the following keys are defined:
	use_header_barcode has a value which is a kb_ea_utils_dev.bool
	trim_barcode has a value which is a kb_ea_utils_dev.bool
	suggest_barcodes has a value which is a kb_ea_utils_dev.bool
bool is an int
ForceEdge_Options is a reference to a hash where the following keys are defined:
	force_beg has a value which is a kb_ea_utils_dev.bool
	force_end has a value which is a kb_ea_utils_dev.bool
DistAndQual_Params is a reference to a hash where the following keys are defined:
	mismatch_max has a value which is an int
	edit_dist_min has a value which is an int
	barcode_base_qual_score_min has a value which is an int
run_Fastq_Multx_Output is a reference to a hash where the following keys are defined:
	report_name has a value which is a string
	report_ref has a value which is a string

</pre>

=end html

=begin text

$params is a kb_ea_utils_dev.run_Fastq_Multx_Input
$returnVal is a kb_ea_utils_dev.run_Fastq_Multx_Output
run_Fastq_Multx_Input is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a kb_ea_utils_dev.workspace_name
	index_info has a value which is a kb_ea_utils_dev.textarea_str
	desc has a value which is a string
	index_mode has a value which is a string
	input_reads_ref has a value which is a kb_ea_utils_dev.data_obj_ref
	input_index_ref has a value which is a kb_ea_utils_dev.data_obj_ref
	output_reads_name has a value which is a kb_ea_utils_dev.data_obj_name
	barcode_options has a value which is a kb_ea_utils_dev.Barcode_Options
	force_edge_options has a value which is a kb_ea_utils_dev.ForceEdge_Options
	dist_and_qual_params has a value which is a kb_ea_utils_dev.DistAndQual_Params
workspace_name is a string
textarea_str is a string
data_obj_ref is a string
data_obj_name is a string
Barcode_Options is a reference to a hash where the following keys are defined:
	use_header_barcode has a value which is a kb_ea_utils_dev.bool
	trim_barcode has a value which is a kb_ea_utils_dev.bool
	suggest_barcodes has a value which is a kb_ea_utils_dev.bool
bool is an int
ForceEdge_Options is a reference to a hash where the following keys are defined:
	force_beg has a value which is a kb_ea_utils_dev.bool
	force_end has a value which is a kb_ea_utils_dev.bool
DistAndQual_Params is a reference to a hash where the following keys are defined:
	mismatch_max has a value which is an int
	edit_dist_min has a value which is an int
	barcode_base_qual_score_min has a value which is an int
run_Fastq_Multx_Output is a reference to a hash where the following keys are defined:
	report_name has a value which is a string
	report_ref has a value which is a string


=end text

=item Description



=back

=cut

 sub run_Fastq_Multx
{
    my($self, @args) = @_;

# Authentication: required

    if ((my $n = @args) != 1)
    {
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error =>
							       "Invalid argument count for function run_Fastq_Multx (received $n, expecting 1)");
    }
    {
	my($params) = @args;

	my @_bad_arguments;
        (ref($params) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument 1 \"params\" (value was \"$params\")");
        if (@_bad_arguments) {
	    my $msg = "Invalid arguments passed to run_Fastq_Multx:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	    Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
								   method_name => 'run_Fastq_Multx');
	}
    }

    my $url = $self->{url};
    my $result = $self->{client}->call($url, $self->{headers}, {
	    method => "kb_ea_utils_dev.run_Fastq_Multx",
	    params => \@args,
    });
    if ($result) {
	if ($result->is_error) {
	    Bio::KBase::Exceptions::JSONRPC->throw(error => $result->error_message,
					       code => $result->content->{error}->{code},
					       method_name => 'run_Fastq_Multx',
					       data => $result->content->{error}->{error} # JSON::RPC::ReturnObject only supports JSONRPC 1.1 or 1.O
					      );
	} else {
	    return wantarray ? @{$result->result} : $result->result->[0];
	}
    } else {
        Bio::KBase::Exceptions::HTTP->throw(error => "Error invoking method run_Fastq_Multx",
					    status_line => $self->{client}->status_line,
					    method_name => 'run_Fastq_Multx',
				       );
    }
}
 


=head2 run_Fastq_Join

  $returnVal = $obj->run_Fastq_Join($params)

=over 4

=item Parameter and return types

=begin html

<pre>
$params is a kb_ea_utils_dev.run_Fastq_Join_Input
$returnVal is a kb_ea_utils_dev.run_Fastq_Join_Output
run_Fastq_Join_Input is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a kb_ea_utils_dev.workspace_name
	input_reads_ref has a value which is a kb_ea_utils_dev.data_obj_ref
	output_reads_name has a value which is a kb_ea_utils_dev.data_obj_name
	verbose has a value which is a kb_ea_utils_dev.bool
	reverse_complement has a value which is a kb_ea_utils_dev.bool
	max_perc_dist has a value which is an int
	min_base_overlap has a value which is an int
workspace_name is a string
data_obj_ref is a string
data_obj_name is a string
bool is an int
run_Fastq_Join_Output is a reference to a hash where the following keys are defined:
	report_name has a value which is a string
	report_ref has a value which is a string

</pre>

=end html

=begin text

$params is a kb_ea_utils_dev.run_Fastq_Join_Input
$returnVal is a kb_ea_utils_dev.run_Fastq_Join_Output
run_Fastq_Join_Input is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a kb_ea_utils_dev.workspace_name
	input_reads_ref has a value which is a kb_ea_utils_dev.data_obj_ref
	output_reads_name has a value which is a kb_ea_utils_dev.data_obj_name
	verbose has a value which is a kb_ea_utils_dev.bool
	reverse_complement has a value which is a kb_ea_utils_dev.bool
	max_perc_dist has a value which is an int
	min_base_overlap has a value which is an int
workspace_name is a string
data_obj_ref is a string
data_obj_name is a string
bool is an int
run_Fastq_Join_Output is a reference to a hash where the following keys are defined:
	report_name has a value which is a string
	report_ref has a value which is a string


=end text

=item Description



=back

=cut

 sub run_Fastq_Join
{
    my($self, @args) = @_;

# Authentication: required

    if ((my $n = @args) != 1)
    {
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error =>
							       "Invalid argument count for function run_Fastq_Join (received $n, expecting 1)");
    }
    {
	my($params) = @args;

	my @_bad_arguments;
        (ref($params) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument 1 \"params\" (value was \"$params\")");
        if (@_bad_arguments) {
	    my $msg = "Invalid arguments passed to run_Fastq_Join:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	    Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
								   method_name => 'run_Fastq_Join');
	}
    }

    my $url = $self->{url};
    my $result = $self->{client}->call($url, $self->{headers}, {
	    method => "kb_ea_utils_dev.run_Fastq_Join",
	    params => \@args,
    });
    if ($result) {
	if ($result->is_error) {
	    Bio::KBase::Exceptions::JSONRPC->throw(error => $result->error_message,
					       code => $result->content->{error}->{code},
					       method_name => 'run_Fastq_Join',
					       data => $result->content->{error}->{error} # JSON::RPC::ReturnObject only supports JSONRPC 1.1 or 1.O
					      );
	} else {
	    return wantarray ? @{$result->result} : $result->result->[0];
	}
    } else {
        Bio::KBase::Exceptions::HTTP->throw(error => "Error invoking method run_Fastq_Join",
					    status_line => $self->{client}->status_line,
					    method_name => 'run_Fastq_Join',
				       );
    }
}
 


=head2 exec_Fastq_Join

  $returnVal = $obj->exec_Fastq_Join($params)

=over 4

=item Parameter and return types

=begin html

<pre>
$params is a kb_ea_utils_dev.run_Fastq_Join_Input
$returnVal is a kb_ea_utils_dev.exec_Fastq_Join_Output
run_Fastq_Join_Input is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a kb_ea_utils_dev.workspace_name
	input_reads_ref has a value which is a kb_ea_utils_dev.data_obj_ref
	output_reads_name has a value which is a kb_ea_utils_dev.data_obj_name
	verbose has a value which is a kb_ea_utils_dev.bool
	reverse_complement has a value which is a kb_ea_utils_dev.bool
	max_perc_dist has a value which is an int
	min_base_overlap has a value which is an int
workspace_name is a string
data_obj_ref is a string
data_obj_name is a string
bool is an int
exec_Fastq_Join_Output is a reference to a hash where the following keys are defined:
	output_reads_ref has a value which is a kb_ea_utils_dev.data_obj_ref

</pre>

=end html

=begin text

$params is a kb_ea_utils_dev.run_Fastq_Join_Input
$returnVal is a kb_ea_utils_dev.exec_Fastq_Join_Output
run_Fastq_Join_Input is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a kb_ea_utils_dev.workspace_name
	input_reads_ref has a value which is a kb_ea_utils_dev.data_obj_ref
	output_reads_name has a value which is a kb_ea_utils_dev.data_obj_name
	verbose has a value which is a kb_ea_utils_dev.bool
	reverse_complement has a value which is a kb_ea_utils_dev.bool
	max_perc_dist has a value which is an int
	min_base_overlap has a value which is an int
workspace_name is a string
data_obj_ref is a string
data_obj_name is a string
bool is an int
exec_Fastq_Join_Output is a reference to a hash where the following keys are defined:
	output_reads_ref has a value which is a kb_ea_utils_dev.data_obj_ref


=end text

=item Description



=back

=cut

 sub exec_Fastq_Join
{
    my($self, @args) = @_;

# Authentication: required

    if ((my $n = @args) != 1)
    {
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error =>
							       "Invalid argument count for function exec_Fastq_Join (received $n, expecting 1)");
    }
    {
	my($params) = @args;

	my @_bad_arguments;
        (ref($params) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument 1 \"params\" (value was \"$params\")");
        if (@_bad_arguments) {
	    my $msg = "Invalid arguments passed to exec_Fastq_Join:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	    Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
								   method_name => 'exec_Fastq_Join');
	}
    }

    my $url = $self->{url};
    my $result = $self->{client}->call($url, $self->{headers}, {
	    method => "kb_ea_utils_dev.exec_Fastq_Join",
	    params => \@args,
    });
    if ($result) {
	if ($result->is_error) {
	    Bio::KBase::Exceptions::JSONRPC->throw(error => $result->error_message,
					       code => $result->content->{error}->{code},
					       method_name => 'exec_Fastq_Join',
					       data => $result->content->{error}->{error} # JSON::RPC::ReturnObject only supports JSONRPC 1.1 or 1.O
					      );
	} else {
	    return wantarray ? @{$result->result} : $result->result->[0];
	}
    } else {
        Bio::KBase::Exceptions::HTTP->throw(error => "Error invoking method exec_Fastq_Join",
					    status_line => $self->{client}->status_line,
					    method_name => 'exec_Fastq_Join',
				       );
    }
}
 


=head2 exec_Fastq_Join_OneLibrary

  $returnVal = $obj->exec_Fastq_Join_OneLibrary($params)

=over 4

=item Parameter and return types

=begin html

<pre>
$params is a kb_ea_utils_dev.run_Fastq_Join_Input
$returnVal is a kb_ea_utils_dev.exec_Fastq_Join_Output
run_Fastq_Join_Input is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a kb_ea_utils_dev.workspace_name
	input_reads_ref has a value which is a kb_ea_utils_dev.data_obj_ref
	output_reads_name has a value which is a kb_ea_utils_dev.data_obj_name
	verbose has a value which is a kb_ea_utils_dev.bool
	reverse_complement has a value which is a kb_ea_utils_dev.bool
	max_perc_dist has a value which is an int
	min_base_overlap has a value which is an int
workspace_name is a string
data_obj_ref is a string
data_obj_name is a string
bool is an int
exec_Fastq_Join_Output is a reference to a hash where the following keys are defined:
	output_reads_ref has a value which is a kb_ea_utils_dev.data_obj_ref

</pre>

=end html

=begin text

$params is a kb_ea_utils_dev.run_Fastq_Join_Input
$returnVal is a kb_ea_utils_dev.exec_Fastq_Join_Output
run_Fastq_Join_Input is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a kb_ea_utils_dev.workspace_name
	input_reads_ref has a value which is a kb_ea_utils_dev.data_obj_ref
	output_reads_name has a value which is a kb_ea_utils_dev.data_obj_name
	verbose has a value which is a kb_ea_utils_dev.bool
	reverse_complement has a value which is a kb_ea_utils_dev.bool
	max_perc_dist has a value which is an int
	min_base_overlap has a value which is an int
workspace_name is a string
data_obj_ref is a string
data_obj_name is a string
bool is an int
exec_Fastq_Join_Output is a reference to a hash where the following keys are defined:
	output_reads_ref has a value which is a kb_ea_utils_dev.data_obj_ref


=end text

=item Description



=back

=cut

 sub exec_Fastq_Join_OneLibrary
{
    my($self, @args) = @_;

# Authentication: required

    if ((my $n = @args) != 1)
    {
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error =>
							       "Invalid argument count for function exec_Fastq_Join_OneLibrary (received $n, expecting 1)");
    }
    {
	my($params) = @args;

	my @_bad_arguments;
        (ref($params) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument 1 \"params\" (value was \"$params\")");
        if (@_bad_arguments) {
	    my $msg = "Invalid arguments passed to exec_Fastq_Join_OneLibrary:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	    Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
								   method_name => 'exec_Fastq_Join_OneLibrary');
	}
    }

    my $url = $self->{url};
    my $result = $self->{client}->call($url, $self->{headers}, {
	    method => "kb_ea_utils_dev.exec_Fastq_Join_OneLibrary",
	    params => \@args,
    });
    if ($result) {
	if ($result->is_error) {
	    Bio::KBase::Exceptions::JSONRPC->throw(error => $result->error_message,
					       code => $result->content->{error}->{code},
					       method_name => 'exec_Fastq_Join_OneLibrary',
					       data => $result->content->{error}->{error} # JSON::RPC::ReturnObject only supports JSONRPC 1.1 or 1.O
					      );
	} else {
	    return wantarray ? @{$result->result} : $result->result->[0];
	}
    } else {
        Bio::KBase::Exceptions::HTTP->throw(error => "Error invoking method exec_Fastq_Join_OneLibrary",
					    status_line => $self->{client}->status_line,
					    method_name => 'exec_Fastq_Join_OneLibrary',
				       );
    }
}
 


=head2 exec_Determine_Phred

  $returnVal = $obj->exec_Determine_Phred($params)

=over 4

=item Parameter and return types

=begin html

<pre>
$params is a kb_ea_utils_dev.exec_Determine_Phred_Input
$returnVal is a kb_ea_utils_dev.exec_Determine_Phred_Output
exec_Determine_Phred_Input is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a kb_ea_utils_dev.workspace_name
	input_reads_ref has a value which is a kb_ea_utils_dev.data_obj_ref
	input_reads_file has a value which is a kb_ea_utils_dev.file_path
workspace_name is a string
data_obj_ref is a string
file_path is a string
exec_Determine_Phred_Output is a reference to a hash where the following keys are defined:
	phred_type has a value which is a string

</pre>

=end html

=begin text

$params is a kb_ea_utils_dev.exec_Determine_Phred_Input
$returnVal is a kb_ea_utils_dev.exec_Determine_Phred_Output
exec_Determine_Phred_Input is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a kb_ea_utils_dev.workspace_name
	input_reads_ref has a value which is a kb_ea_utils_dev.data_obj_ref
	input_reads_file has a value which is a kb_ea_utils_dev.file_path
workspace_name is a string
data_obj_ref is a string
file_path is a string
exec_Determine_Phred_Output is a reference to a hash where the following keys are defined:
	phred_type has a value which is a string


=end text

=item Description



=back

=cut

 sub exec_Determine_Phred
{
    my($self, @args) = @_;

# Authentication: required

    if ((my $n = @args) != 1)
    {
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error =>
							       "Invalid argument count for function exec_Determine_Phred (received $n, expecting 1)");
    }
    {
	my($params) = @args;

	my @_bad_arguments;
        (ref($params) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument 1 \"params\" (value was \"$params\")");
        if (@_bad_arguments) {
	    my $msg = "Invalid arguments passed to exec_Determine_Phred:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	    Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
								   method_name => 'exec_Determine_Phred');
	}
    }

    my $url = $self->{url};
    my $result = $self->{client}->call($url, $self->{headers}, {
	    method => "kb_ea_utils_dev.exec_Determine_Phred",
	    params => \@args,
    });
    if ($result) {
	if ($result->is_error) {
	    Bio::KBase::Exceptions::JSONRPC->throw(error => $result->error_message,
					       code => $result->content->{error}->{code},
					       method_name => 'exec_Determine_Phred',
					       data => $result->content->{error}->{error} # JSON::RPC::ReturnObject only supports JSONRPC 1.1 or 1.O
					      );
	} else {
	    return wantarray ? @{$result->result} : $result->result->[0];
	}
    } else {
        Bio::KBase::Exceptions::HTTP->throw(error => "Error invoking method exec_Determine_Phred",
					    status_line => $self->{client}->status_line,
					    method_name => 'exec_Determine_Phred',
				       );
    }
}
 
  
sub status
{
    my($self, @args) = @_;
    if ((my $n = @args) != 0) {
        Bio::KBase::Exceptions::ArgumentValidationError->throw(error =>
                                   "Invalid argument count for function status (received $n, expecting 0)");
    }
    my $url = $self->{url};
    my $result = $self->{client}->call($url, $self->{headers}, {
        method => "kb_ea_utils_dev.status",
        params => \@args,
    });
    if ($result) {
        if ($result->is_error) {
            Bio::KBase::Exceptions::JSONRPC->throw(error => $result->error_message,
                           code => $result->content->{error}->{code},
                           method_name => 'status',
                           data => $result->content->{error}->{error} # JSON::RPC::ReturnObject only supports JSONRPC 1.1 or 1.O
                          );
        } else {
            return wantarray ? @{$result->result} : $result->result->[0];
        }
    } else {
        Bio::KBase::Exceptions::HTTP->throw(error => "Error invoking method status",
                        status_line => $self->{client}->status_line,
                        method_name => 'status',
                       );
    }
}
   

sub version {
    my ($self) = @_;
    my $result = $self->{client}->call($self->{url}, $self->{headers}, {
        method => "kb_ea_utils_dev.version",
        params => [],
    });
    if ($result) {
        if ($result->is_error) {
            Bio::KBase::Exceptions::JSONRPC->throw(
                error => $result->error_message,
                code => $result->content->{code},
                method_name => 'exec_Determine_Phred',
            );
        } else {
            return wantarray ? @{$result->result} : $result->result->[0];
        }
    } else {
        Bio::KBase::Exceptions::HTTP->throw(
            error => "Error invoking method exec_Determine_Phred",
            status_line => $self->{client}->status_line,
            method_name => 'exec_Determine_Phred',
        );
    }
}

sub _validate_version {
    my ($self) = @_;
    my $svr_version = $self->version();
    my $client_version = $VERSION;
    my ($cMajor, $cMinor) = split(/\./, $client_version);
    my ($sMajor, $sMinor) = split(/\./, $svr_version);
    if ($sMajor != $cMajor) {
        Bio::KBase::Exceptions::ClientServerIncompatible->throw(
            error => "Major version numbers differ.",
            server_version => $svr_version,
            client_version => $client_version
        );
    }
    if ($sMinor < $cMinor) {
        Bio::KBase::Exceptions::ClientServerIncompatible->throw(
            error => "Client minor version greater than Server minor version.",
            server_version => $svr_version,
            client_version => $client_version
        );
    }
    if ($sMinor > $cMinor) {
        warn "New client version available for kb_ea_utils_dev::kb_ea_utils_devClient\n";
    }
    if ($sMajor == 0) {
        warn "kb_ea_utils_dev::kb_ea_utils_devClient version is $svr_version. API subject to change.\n";
    }
}

=head1 TYPES



=head2 workspace_name

=over 4



=item Description

** Common types


=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 data_obj_ref

=over 4



=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 data_obj_name

=over 4



=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 textarea_str

=over 4



=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 file_path

=over 4



=item Definition

=begin html

<pre>
a string
</pre>

=end html

=begin text

a string

=end text

=back



=head2 bool

=over 4



=item Definition

=begin html

<pre>
an int
</pre>

=end html

=begin text

an int

=end text

=back



=head2 get_fastq_ea_utils_stats_params

=over 4



=item Description

if read_library_ref is set, then workspace_name and read_library_name are ignored


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
workspace_name has a value which is a string
read_library_name has a value which is a string
read_library_ref has a value which is a string

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
workspace_name has a value which is a string
read_library_name has a value which is a string
read_library_ref has a value which is a string


=end text

=back



=head2 Report

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
report_name has a value which is a string
report_ref has a value which is a string

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
report_name has a value which is a string
report_ref has a value which is a string


=end text

=back



=head2 run_app_fastq_ea_utils_stats_params

=over 4



=item Description

if read_library_ref is set, then workspace_name and read_library_name are ignored


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
workspace_name has a value which is a string
read_library_name has a value which is a string
read_library_ref has a value which is a string

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
workspace_name has a value which is a string
read_library_name has a value which is a string
read_library_ref has a value which is a string


=end text

=back



=head2 ea_utils_params

=over 4



=item Description

read_library_path : absolute path of fastq files


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
read_library_path has a value which is a string

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
read_library_path has a value which is a string


=end text

=back



=head2 ea_report

=over 4



=item Description

read_count - the number of reads in the this dataset
   total_bases - the total number of bases for all the the reads in this library.
   gc_content - the GC content of the reads.
   read_length_mean - The average read length size
   read_length_stdev - The standard deviation read lengths
   phred_type - The scale of phred scores
   number_of_duplicates - The number of reads that are duplicates
   qual_min - min quality scores
   qual_max - max quality scores
   qual_mean - mean quality scores
   qual_stdev - stdev of quality scores
   base_percentages - The per base percentage breakdown


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
read_count has a value which is an int
total_bases has a value which is an int
gc_content has a value which is a float
read_length_mean has a value which is a float
read_length_stdev has a value which is a float
phred_type has a value which is a string
number_of_duplicates has a value which is an int
qual_min has a value which is a float
qual_max has a value which is a float
qual_mean has a value which is a float
qual_stdev has a value which is a float
base_percentages has a value which is a reference to a hash where the key is a string and the value is a float

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
read_count has a value which is an int
total_bases has a value which is an int
gc_content has a value which is a float
read_length_mean has a value which is a float
read_length_stdev has a value which is a float
phred_type has a value which is a string
number_of_duplicates has a value which is an int
qual_min has a value which is a float
qual_max has a value which is a float
qual_mean has a value which is a float
qual_stdev has a value which is a float
base_percentages has a value which is a reference to a hash where the key is a string and the value is a float


=end text

=back



=head2 Barcode_Options

=over 4



=item Description

Parameter groups


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
use_header_barcode has a value which is a kb_ea_utils_dev.bool
trim_barcode has a value which is a kb_ea_utils_dev.bool
suggest_barcodes has a value which is a kb_ea_utils_dev.bool

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
use_header_barcode has a value which is a kb_ea_utils_dev.bool
trim_barcode has a value which is a kb_ea_utils_dev.bool
suggest_barcodes has a value which is a kb_ea_utils_dev.bool


=end text

=back



=head2 ForceEdge_Options

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
force_beg has a value which is a kb_ea_utils_dev.bool
force_end has a value which is a kb_ea_utils_dev.bool

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
force_beg has a value which is a kb_ea_utils_dev.bool
force_end has a value which is a kb_ea_utils_dev.bool


=end text

=back



=head2 DistAndQual_Params

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
mismatch_max has a value which is an int
edit_dist_min has a value which is an int
barcode_base_qual_score_min has a value which is an int

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
mismatch_max has a value which is an int
edit_dist_min has a value which is an int
barcode_base_qual_score_min has a value which is an int


=end text

=back



=head2 run_Fastq_Multx_Input

=over 4



=item Description

run_Fastq_Multx()
**
** demultiplex read libraries to readsSet


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
workspace_name has a value which is a kb_ea_utils_dev.workspace_name
index_info has a value which is a kb_ea_utils_dev.textarea_str
desc has a value which is a string
index_mode has a value which is a string
input_reads_ref has a value which is a kb_ea_utils_dev.data_obj_ref
input_index_ref has a value which is a kb_ea_utils_dev.data_obj_ref
output_reads_name has a value which is a kb_ea_utils_dev.data_obj_name
barcode_options has a value which is a kb_ea_utils_dev.Barcode_Options
force_edge_options has a value which is a kb_ea_utils_dev.ForceEdge_Options
dist_and_qual_params has a value which is a kb_ea_utils_dev.DistAndQual_Params

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
workspace_name has a value which is a kb_ea_utils_dev.workspace_name
index_info has a value which is a kb_ea_utils_dev.textarea_str
desc has a value which is a string
index_mode has a value which is a string
input_reads_ref has a value which is a kb_ea_utils_dev.data_obj_ref
input_index_ref has a value which is a kb_ea_utils_dev.data_obj_ref
output_reads_name has a value which is a kb_ea_utils_dev.data_obj_name
barcode_options has a value which is a kb_ea_utils_dev.Barcode_Options
force_edge_options has a value which is a kb_ea_utils_dev.ForceEdge_Options
dist_and_qual_params has a value which is a kb_ea_utils_dev.DistAndQual_Params


=end text

=back



=head2 run_Fastq_Multx_Output

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
report_name has a value which is a string
report_ref has a value which is a string

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
report_name has a value which is a string
report_ref has a value which is a string


=end text

=back



=head2 run_Fastq_Join_Input

=over 4



=item Description

run_Fastq_Join()
**
** merge overlapping mate pairs into SingleEnd Lib.  This sub interacts with Narrative


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
workspace_name has a value which is a kb_ea_utils_dev.workspace_name
input_reads_ref has a value which is a kb_ea_utils_dev.data_obj_ref
output_reads_name has a value which is a kb_ea_utils_dev.data_obj_name
verbose has a value which is a kb_ea_utils_dev.bool
reverse_complement has a value which is a kb_ea_utils_dev.bool
max_perc_dist has a value which is an int
min_base_overlap has a value which is an int

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
workspace_name has a value which is a kb_ea_utils_dev.workspace_name
input_reads_ref has a value which is a kb_ea_utils_dev.data_obj_ref
output_reads_name has a value which is a kb_ea_utils_dev.data_obj_name
verbose has a value which is a kb_ea_utils_dev.bool
reverse_complement has a value which is a kb_ea_utils_dev.bool
max_perc_dist has a value which is an int
min_base_overlap has a value which is an int


=end text

=back



=head2 run_Fastq_Join_Output

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
report_name has a value which is a string
report_ref has a value which is a string

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
report_name has a value which is a string
report_ref has a value which is a string


=end text

=back



=head2 exec_Fastq_Join_Output

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
output_reads_ref has a value which is a kb_ea_utils_dev.data_obj_ref

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
output_reads_ref has a value which is a kb_ea_utils_dev.data_obj_ref


=end text

=back



=head2 exec_Determine_Phred_Input

=over 4



=item Description

exec_Determine_Phred()
**
** determine qual score regime.  Either "phred33" or "phred64"


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
workspace_name has a value which is a kb_ea_utils_dev.workspace_name
input_reads_ref has a value which is a kb_ea_utils_dev.data_obj_ref
input_reads_file has a value which is a kb_ea_utils_dev.file_path

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
workspace_name has a value which is a kb_ea_utils_dev.workspace_name
input_reads_ref has a value which is a kb_ea_utils_dev.data_obj_ref
input_reads_file has a value which is a kb_ea_utils_dev.file_path


=end text

=back



=head2 exec_Determine_Phred_Output

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
phred_type has a value which is a string

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
phred_type has a value which is a string


=end text

=back



=cut

package kb_ea_utils_dev::kb_ea_utils_devClient::RpcClient;
use base 'JSON::RPC::Client';
use POSIX;
use strict;

#
# Override JSON::RPC::Client::call because it doesn't handle error returns properly.
#

sub call {
    my ($self, $uri, $headers, $obj) = @_;
    my $result;


    {
	if ($uri =~ /\?/) {
	    $result = $self->_get($uri);
	}
	else {
	    Carp::croak "not hashref." unless (ref $obj eq 'HASH');
	    $result = $self->_post($uri, $headers, $obj);
	}

    }

    my $service = $obj->{method} =~ /^system\./ if ( $obj );

    $self->status_line($result->status_line);

    if ($result->is_success) {

        return unless($result->content); # notification?

        if ($service) {
            return JSON::RPC::ServiceObject->new($result, $self->json);
        }

        return JSON::RPC::ReturnObject->new($result, $self->json);
    }
    elsif ($result->content_type eq 'application/json')
    {
        return JSON::RPC::ReturnObject->new($result, $self->json);
    }
    else {
        return;
    }
}


sub _post {
    my ($self, $uri, $headers, $obj) = @_;
    my $json = $self->json;

    $obj->{version} ||= $self->{version} || '1.1';

    if ($obj->{version} eq '1.0') {
        delete $obj->{version};
        if (exists $obj->{id}) {
            $self->id($obj->{id}) if ($obj->{id}); # if undef, it is notification.
        }
        else {
            $obj->{id} = $self->id || ($self->id('JSON::RPC::Client'));
        }
    }
    else {
        # $obj->{id} = $self->id if (defined $self->id);
	# Assign a random number to the id if one hasn't been set
	$obj->{id} = (defined $self->id) ? $self->id : substr(rand(),2);
    }

    my $content = $json->encode($obj);

    $self->ua->post(
        $uri,
        Content_Type   => $self->{content_type},
        Content        => $content,
        Accept         => 'application/json',
	@$headers,
	($self->{token} ? (Authorization => $self->{token}) : ()),
    );
}



1;
