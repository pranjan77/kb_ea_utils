/*
Utilities for converting KBaseAssembly types to KBaseFile types
*/

module kb_ea_utils {

/*

		This module has methods to convert legacy KBaseAssembly types to 
		KBaseFile types.
		1. KBaseAssembly.SingleEndLibrary to KBaseFile.SingleEndLibrary
		2. KBaseAssembly.PairedEndLibrary to KBaseFile.PairedEndLibrary

		workspace_name    - the name of the workspace for input/output
		read_library_name - the name of the KBaseAssembly.SingleEndLibrary or 
                        KBaseAssembly.PairedEndLibrary

*/


typedef structure {
		string workspace_name;
		string read_library_name;
} get_fastq_ea_utils_stats_params;


/*
 This function should be used for getting statistics on fastq files.
 The results are returned as a string.
*/

funcdef get_fastq_ea_utils_stats (get_fastq_ea_utils_stats_params input_params)
        returns (string ea_utils_stats)
authentication required; 


typedef structure {
		string report_name;
		string report_ref;
} Report;


typedef structure {
		string workspace_name;
		string read_library_name;
} run_app_fastq_ea_utils_stats_params;

/*
 This function should be used for getting statistics on fastq files.
 The results are returned as a report type object.
*/


funcdef run_app_fastq_ea_utils_stats (run_app_fastq_ea_utils_stats_params input_params)
        returns (Report report)
authentication required; 

};
