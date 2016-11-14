/*
Utilities for converting KBaseAssembly types to KBaseFile types
*/

module kb_ea_utils {

/*

		This module has methods to  get fastq statistics
		workspace_name    - the name of the workspace for input/output
		read_library_name - the name of  KBaseFile.SingleEndLibrary or
                        KBaseFile.PairedEndLibrary

*/


typedef structure {
		string workspace_name;
		string read_library_name;
} get_fastq_ea_utils_stats_params;

typedef structure {
		string report_name;
		string report_ref;
} Report;


typedef structure {
		string workspace_name;
		string read_library_name;
} run_app_fastq_ea_utils_stats_params;


/*
    read_library_path : absolute path of fastq files
*/

typedef structure {
		string read_library_path;
} ea_utils_params;

/*

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

*/

typedef structure {

  int read_count;
  int total_bases;
  float gc_content;
  float read_length_mean;
  float read_length_stdev;
  string phred_type;
  int number_of_duplicates;
  float qual_min;
  float qual_max;
  float qual_mean;
  float qual_stdev;
  mapping<string, float> base_percentages;
} ea_report;



/*
 This function should be used for getting statistics on read library object types 
 The results are returned as a string.
*/

funcdef get_fastq_ea_utils_stats (get_fastq_ea_utils_stats_params input_params)
        returns (string ea_utils_stats)
authentication required; 


/*
 This function should be used for getting statistics on read library object type.
 The results are returned as a report type object.
*/

funcdef run_app_fastq_ea_utils_stats (run_app_fastq_ea_utils_stats_params input_params)
        returns (Report report)
authentication required; 



/*
 This function should be used for getting statistics on fastq files. Input is string of file path.
 Output is a report string.
*/

funcdef get_ea_utils_stats (ea_utils_params input_params)
        returns (string report)
authentication required; 



/*
 This function should be used for getting statistics on fastq files. Input is string of file path.
 Output is a data structure with different fields.
*/

funcdef calculate_fastq_stats (ea_utils_params input_params)
        returns (ea_report ea_stats)
authentication required;



};
