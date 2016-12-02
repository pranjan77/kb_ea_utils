# -*- coding: utf-8 -*-
#BEGIN_HEADER
import sys
import traceback
from biokbase.workspace.client import Workspace as workspaceService
import requests
requests.packages.urllib3.disable_warnings()
import subprocess
import os
import re
from pprint import pprint, pformat
import uuid
from ReadsUtils.ReadsUtilsClient import ReadsUtils as ReadsUtils

#END_HEADER


class kb_ea_utils_dev:
    '''
    Module Name:
    kb_ea_utils_dev

    Module Description:
    Utilities for converting KBaseAssembly types to KBaseFile types
    '''

    ######## WARNING FOR GEVENT USERS ####### noqa
    # Since asynchronous IO can lead to methods - even the same method -
    # interrupting each other, you must be *very* careful when using global
    # state. A method could easily clobber the state set by another while
    # the latter method is running.
    ######################################### noqa
    VERSION = "0.0.1"
    GIT_URL = "https://github.com/dcchivian/kb_ea_utils_dev"
    GIT_COMMIT_HASH = "48fa9860efe955d9519051ef558104a81dd48e3c"

    FASTQ_MULTX     = "/usr/local/bin/fastq-multx"
    FASTQ_JOIN      = "/usr/local/bin/fastq-join"
    DETERMINE_PHRED = "/usr/local/bin/determine-phred"

    #BEGIN_CLASS_HEADER
    def log(self, target, message):
        if target is not None:
            target.append(message)
        print(message)
        sys.stdout.flush()

    def get_reads_ref_from_params(self, params):
        if 'read_library_ref' in params:
            return params['read_library_ref']

        if 'workspace_name' not in params and 'read_library_name' not in params:
            raise ValueError('Either "read_library_ref" or "workspace_name" with ' +
                             '"read_library_name" fields are required.')

        return str(params['workspace_name']) + '/' + str(params['read_library_name'])


    def get_report_string (self, fastq_file):
      cmd_string = " ".join (("fastq-stats", fastq_file));
      try:
          cmd_process = subprocess.Popen(cmd_string, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, shell=True)
          outputlines = []
          console = []
          while True:
             line = cmd_process.stdout.readline()
             outputlines.append(line)
             if not line: break
             #self.log(console, line.replace('\n', ''))

          report = '====' + fastq_file + '====' + "\n"
          report += "".join(outputlines)
      except:
          report = "Error in processing " +  fastq_file
      return report


    def get_ea_utils_result (self,refid, input_params):
      ref = [refid] 
      DownloadReadsParams={'read_libraries':ref}
      dfUtil = ReadsUtils(self.callbackURL)
      x=dfUtil.download_reads(DownloadReadsParams)
      report = ''
      fwd_file = None 
      rev_file = None 

      fwd_file    =  x['files'][ref[0]]['files']['fwd']
      otype =  x['files'][ref[0]]['files']['otype']

      #case of interleaved
      if (otype == 'interleaved'):
          report += self.get_report_string (fwd_file)
          
      #case of separate pair 
      if (otype == 'paired'):
         report += self.get_report_string (fwd_file)

         rev_file    =  x['files'][ref[0]]['files']['rev']
         report += self.get_report_string (rev_file)

      #case of single end 
      if (otype == 'single'):
         report += self.get_report_string (fwd_file)
      #print report
      return report

    #END_CLASS_HEADER

    # config contains contents of config file in a hash or None if it couldn't
    # be found
    def __init__(self, config):
        #BEGIN_CONSTRUCTOR
        self.workspaceURL = config['workspace-url']
        self.shockURL = config['shock-url']
        self.scratch = os.path.abspath(config['scratch'])
        self.handleURL = config['handle-service-url']

        self.callbackURL = os.environ.get('SDK_CALLBACK_URL')
        if self.callbackURL == None:
            raise ValueError ("SDK_CALLBACK_URL not set in environment")

        if not os.path.exists(self.scratch):
            os.makedirs(self.scratch)
        #END_CONSTRUCTOR
        pass


    def get_fastq_ea_utils_stats(self, ctx, input_params):
        """
        This function should be used for getting statistics on read library object types 
        The results are returned as a string.
        :param input_params: instance of type
           "get_fastq_ea_utils_stats_params" (if read_library_ref is set,
           then workspace_name and read_library_name are ignored) ->
           structure: parameter "workspace_name" of String, parameter
           "read_library_name" of String, parameter "read_library_ref" of
           String
        :returns: instance of String
        """
        # ctx is the context object
        # return variables are: ea_utils_stats
        #BEGIN get_fastq_ea_utils_stats
        token = ctx['token']
        wsClient = workspaceService(self.workspaceURL)
        # add additional info to provenance here, in this case the input data object reference
        input_reads_ref = self.get_reads_ref_from_params(input_params)

        info = None
        readLibrary = None
        try:
            readLibrary = wsClient.get_objects2({'objects':[{'ref': input_reads_ref}]})['data'][0]
            info = readLibrary['info']
            readLibrary = readLibrary['data']
        except Exception as e:
            raise ValueError('Unable to get read library object from workspace: (' + input_reads_ref + ')' + str(e))

        ea_utils_stats = ''
        ea_utils_stats = self.get_ea_utils_result(input_reads_ref, input_params)

        #END get_fastq_ea_utils_stats

        # At some point might do deeper type checking...
        if not isinstance(ea_utils_stats, basestring):
            raise ValueError('Method get_fastq_ea_utils_stats return value ' +
                             'ea_utils_stats is not type basestring as required.')
        # return the results
        return [ea_utils_stats]

    def run_app_fastq_ea_utils_stats(self, ctx, input_params):
        """
        This function should be used for getting statistics on read library object type.
        The results are returned as a report type object.
        :param input_params: instance of type
           "run_app_fastq_ea_utils_stats_params" (if read_library_ref is set,
           then workspace_name and read_library_name are ignored) ->
           structure: parameter "workspace_name" of String, parameter
           "read_library_name" of String, parameter "read_library_ref" of
           String
        :returns: instance of type "Report" -> structure: parameter
           "report_name" of String, parameter "report_ref" of String
        """
        # ctx is the context object
        # return variables are: report
        #BEGIN run_app_fastq_ea_utils_stats
        print (input_params)

        wsClient = workspaceService(self.workspaceURL)
        provenance = [{}]
        if 'provenance' in ctx:
            provenance = ctx['provenance']
        # add additional info to provenance here, in this case the input data object reference
        input_reads_ref = self.get_reads_ref_from_params(input_params)
        if 'workspace_name' not in input_params:
            raise ValueError('"workspace_name" field is required to run this App"')
        workspace_name = input_params['workspace_name']
        provenance[0]['input_ws_objects'] = [input_reads_ref]

        info = None
        readLibrary = None
        try:
            readLibrary = wsClient.get_objects([{'ref': input_reads_ref}])[0]
            info = readLibrary['info']
            readLibrary = readLibrary['data']
        except Exception as e:
            raise ValueError('Unable to get read library object from workspace: (' + input_reads_ref + ')' + str(e))
#        ref=['11665/5/2', '11665/10/7', '11665/11/1' ]
        #ref=['11802/9/1']
        report = self.get_ea_utils_result(input_reads_ref, input_params)
        reportObj = {
            'objects_created':[],
            'text_message':report
        }

        reportName = 'run_fastq_stats_'+str(uuid.uuid4())
        report_info = wsClient.save_objects({
            'workspace':workspace_name,
            'objects':[
                 {
                  'type':'KBaseReport.Report',
                  'data':reportObj,
                  'name':reportName,
                  'meta':{},
                  'hidden':1, # important!  make sure the report is hidden
                  'provenance':provenance
                 }
            ] })[0]  
        print('saved Report: '+pformat(report_info))
        
        report = { "report_name" : reportName,"report_ref" : str(report_info[6]) + '/' + str(report_info[0]) + '/' + str(report_info[4]) }

        #print (report)
        #END run_app_fastq_ea_utils_stats

        # At some point might do deeper type checking...
        if not isinstance(report, dict):
            raise ValueError('Method run_app_fastq_ea_utils_stats return value ' +
                             'report is not type dict as required.')
        # return the results
        return [report]

    def get_ea_utils_stats(self, ctx, input_params):
        """
        This function should be used for getting statistics on fastq files. Input is string of file path.
        Output is a report string.
        :param input_params: instance of type "ea_utils_params"
           (read_library_path : absolute path of fastq files) -> structure:
           parameter "read_library_path" of String
        :returns: instance of String
        """
        # ctx is the context object
        # return variables are: report
        #BEGIN get_ea_utils_stats
        read_library_path = input_params['read_library_path']
        report = self.get_report_string (read_library_path)
        #END get_ea_utils_stats

        # At some point might do deeper type checking...
        if not isinstance(report, basestring):
            raise ValueError('Method get_ea_utils_stats return value ' +
                             'report is not type basestring as required.')
        # return the results
        return [report]

    def calculate_fastq_stats(self, ctx, input_params):
        """
        This function should be used for getting statistics on fastq files. Input is string of file path.
        Output is a data structure with different fields.
        :param input_params: instance of type "ea_utils_params"
           (read_library_path : absolute path of fastq files) -> structure:
           parameter "read_library_path" of String
        :returns: instance of type "ea_report" (read_count - the number of
           reads in the this dataset total_bases - the total number of bases
           for all the the reads in this library. gc_content - the GC content
           of the reads. read_length_mean - The average read length size
           read_length_stdev - The standard deviation read lengths phred_type
           - The scale of phred scores number_of_duplicates - The number of
           reads that are duplicates qual_min - min quality scores qual_max -
           max quality scores qual_mean - mean quality scores qual_stdev -
           stdev of quality scores base_percentages - The per base percentage
           breakdown) -> structure: parameter "read_count" of Long, parameter
           "total_bases" of Long, parameter "gc_content" of Double, parameter
           "read_length_mean" of Double, parameter "read_length_stdev" of
           Double, parameter "phred_type" of String, parameter
           "number_of_duplicates" of Long, parameter "qual_min" of Double,
           parameter "qual_max" of Double, parameter "qual_mean" of Double,
           parameter "qual_stdev" of Double, parameter "base_percentages" of
           mapping from String to Double
        """
        # ctx is the context object
        # return variables are: ea_stats
        #BEGIN calculate_fastq_stats
        read_library_path = input_params['read_library_path']
        ea_report = self.get_report_string (read_library_path)
        ea_stats = {}
        report_lines = ea_report.splitlines()
        report_to_object_mappings = {'reads': 'read_count',
                                     'total bases': 'total_bases',
                                     'len mean': 'read_length_mean',
                                     'len stdev': 'read_length_stdev',
                                     'phred': 'phred_type',
                                     'dups': 'number_of_duplicates',
                                     'qual min': 'qual_min',
                                     'qual max': 'qual_max',
                                     'qual mean': 'qual_mean',
                                     'qual stdev': 'qual_stdev'}
        integer_fields = ['read_count', 'total_bases', 'number_of_duplicates']
        for line in report_lines:
            line_elements = line.split()
            line_value = line_elements.pop()
            line_key = " ".join(line_elements)
            line_key = line_key.strip()
            if line_key in report_to_object_mappings:
                # print ":{}: = :{}:".format(report_to_object_mappings[line_key],line_value)
                value_to_use = None
                if line_key == 'phred':
                    value_to_use = line_value.strip()
                elif report_to_object_mappings[line_key] in integer_fields:
                    value_to_use = int(line_value.strip())
                else:
                    value_to_use = float(line_value.strip())
                ea_stats[report_to_object_mappings[line_key]] = value_to_use
            elif line_key.startswith("%") and not line_key.startswith("%dup"):
                if 'base_percentages' not in ea_stats:
                    ea_stats['base_percentages'] = dict()
                dict_key = line_key.strip("%")
                ea_stats['base_percentages'][dict_key] = float(line_value.strip())
        # populate the GC content (as a value betwwen 0 and 1)
        if 'base_percentages' in ea_stats:
            gc_content = 0
            if "G" in ea_stats['base_percentages']:
                gc_content += ea_stats['base_percentages']["G"]
            if "C" in ea_stats['base_percentages']:
                gc_content += ea_stats['base_percentages']["C"]
            ea_stats["gc_content"] = gc_content / 100
        # set number of dups if no dups, but read_count
        if 'read_count' in ea_stats and 'number_of_duplicates' not in ea_stats:
            ea_stats["number_of_duplicates"] = 0
        #END calculate_fastq_stats

        # At some point might do deeper type checking...
        if not isinstance(ea_stats, dict):
            raise ValueError('Method calculate_fastq_stats return value ' +
                             'ea_stats is not type dict as required.')
        # return the results
        return [ea_stats]

    def run_Fastq_Multx(self, ctx, params):
        """
        :param params: instance of type "run_Fastq_Multx_Input"
           (run_Fastq_Multx() ** ** demultiplex read libraries to readsSet)
           -> structure: parameter "workspace_name" of type "workspace_name"
           (** Common types), parameter "index_info" of type "textarea_str",
           parameter "index_mode" of String, parameter "input_reads_ref" of
           type "data_obj_ref", parameter "input_index_ref" of type
           "data_obj_ref", parameter "output_reads_name" of type
           "data_obj_name"
        :returns: instance of type "run_Fastq_Multx_Output" -> structure:
           parameter "report_name" of String, parameter "report_ref" of String
        """
        # ctx is the context object
        # return variables are: returnVal
        #BEGIN run_Fastq_Multx
        console = []
        report = ''
        self.log(console, 'Running run_Fastq_Multx() with parameters: ')
        self.log(console, "\n"+pformat(params))
        
        token = ctx['token']
        wsClient = workspaceService(self.workspaceURL, token=token)
        headers = {'Authorization': 'OAuth '+token}
        env = os.environ.copy()
        env['KB_AUTH_TOKEN'] = token
        
        SERVICE_VER = 'dev'  # DEBUG

        # param checks
        required_params = ['workspace_name',
                           'input_reads_ref',
                           'index_mode',
                           'output_reads_name'
                           ]
        for required_param in required_params:
            if required_param not in params or params[required_param] == None:
                raise ValueError ("Must define required param: '"+required_param+"'")
            
        # combined param requirements
        if params['index_mode'] == 'auto-detect' || params['index_mode'] == 'manual':
            if 'index_info' not in params or params['index_info'] == None or params['index_info'] == '':
                raise ValueError ("Must have index_info if index_mode is 'auto-detect' or 'manual'")
        elsif params['index_mode'] == 'index-lane':
            if 'input_index_ref' not in params or params['input_index_ref'] == None or params['input_index_ref'] == '':
                raise ValueError ("Must have input_index_ref if index_mode is 'index-lane'")

        # and param defaults
        defaults = { 'use_header_barcode': 0,
                     'force_beg': 0,
                     'force_end': 0,
                     'trim_barcode': 1,
                     'suggest_barcodes': 0,
                     'mismatch_max': 1,
                     'edit_dist_min': 2,
                     'barcode_base_qual_score_min': 0
                   }
        for arg in defaults.keys():
            if arg not in params or params[arg] == None or params[arg] == '':
                params[arg] = defaults[arg]


        # Set path to default barcodes
        #
        master_barcodes_path = "/kb/modules/kb_ea_utils_dev/data/master-barcodes.txt"


        # load provenance
        provenance = [{}]
        if 'provenance' in ctx:
            provenance = ctx['provenance']
        provenance[0]['input_ws_objects']=[str(params['input_reads_ref'])]

        # Determine whether read library is of correct type
        #
        try:
            # object_info tuple
            [OBJID_I, NAME_I, TYPE_I, SAVE_DATE_I, VERSION_I, SAVED_BY_I, WSID_I, WORKSPACE_I, CHSUM_I, SIZE_I, META_I] = range(11)
            
            input_reads_ref = params['input_reads_ref']
            input_reads_obj_info = wsClient.get_object_info_new ({'objects':[{'ref':input_reads_ref}]})[0]
            input_reads_obj_type = input_reads_obj_info[TYPE_I]
            input_reads_obj_type = re.sub ('-[0-9]+\.[0-9]+$', "", input_reads_obj_type)  # remove trailing version
            #input_reads_obj_version = input_reads_obj_info[VERSION_I]  # this is object version, not type version

        except Exception as e:
            raise ValueError('Unable to get read library object info from workspace: (' + str(input_reads_ref) +')' + str(e))


        acceptable_types = ["KBaseFile.PairedEndLibrary", "KBaseFile.SingleEndLibrary"]
        if input_reads_obj_type not in acceptable_types:
            raise ValueError ("Input reads of type: '"+input_reads_obj_type+"'.  Must be one of "+", ".join(acceptable_types))


        # Download Reads
        #
        self.log (console, "DOWNLOADING READS")  # DEBUG
        try:
            readsUtils_Client = ReadsUtils (url=self.callbackURL, token=ctx['token'])  # SDK local
        except Exception as e:
            raise ValueError('Unable to get ReadsUtils Client' +"\n" + str(e))
        try:
            readsLibrary = readsUtils_Client.download_reads ({'read_libraries': [input_reads_ref],
                                                             'interleaved': 'false'
                                                             })
        except Exception as e:
            raise ValueError('Unable to download read library sequences from workspace: (' + str(input_reads_ref) +")\n" + str(e))

        input_fwd_file_path = readsLibrary['files'][input_reads_ref]['files']['fwd']
#        input_fwd_path = re.sub ("\.fq$", "", input_fwd_file_path)
#        input_fwd_path = re.sub ("\.FQ$", "", input_fwd_path)
#        input_fwd_path = re.sub ("\.fastq$", "", input_fwd_path)
#        input_fwd_path = re.sub ("\.FASTQ$", "", input_fwd_path)

        if input_reads_obj_type == "KBaseFile.PairedEndLibrary":
            input_rev_file_path = readsLibrary['files'][input_reads_ref]['files']['rev']
#            input_rev_path = re.sub ("\.fq$", "", input_rev_file_path)
#            input_rev_path = re.sub ("\.FQ$", "", input_rev_path)
#            input_rev_path = re.sub ("\.fastq$", "", input_rev_path)
#            input_rev_path = re.sub ("\.FASTQ$", "", input_rev_path)

        sequencing_tech = 'N/A'
        if 'sequencing_tech' in readsLibrary['files'][input_reads_ref]:
            sequencing_tech = readsLibrary['files'][input_reads_ref]['sequencing_tech']


        # don't need phred_type after all
#        phred_type = None
#        if 'phred_type' in readsLibrary['files'][input_reads_ref]:
#            phred_type = readsLibrary['files'][input_reads_ref]['phred_type']
#        else:
#            phred_type = self.exec_Determine_Phred (ctx, {'input_reads_file':input_fwd_file_path})['phred_type']


        # Download index reads
        #
        if input_index_ref in params and params['input_index_ref'] != None and params['input_index_ref'] != '':
            try:
                indexLibrary = readsUtils_Client.download_reads ({'read_libraries': [input_index_ref],
                                                                  'interleaved': 'false'
                                                                  })
            except Exception as e:
                raise ValueError('Unable to download index read library sequences from workspace: (' + str(input_index_ref) +")\n" + str(e))
        input_index_fwd_file_path = indexLibrary['files'][input_index_ref]['files']['fwd']
        input_index_rev_file_path = indexLibrary['files'][input_index_ref]['files']['rev']


        # Set the output dir
        timestamp = int((datetime.utcnow() - datetime.utcfromtimestamp(0)).total_seconds()*1000)
        output_dir = os.path.join(self.scratch,'output.'+str(timestamp))


        # clean up index_info
        #
        group_id_order = []
        index_info_path = None
        if 'index_info' in params and params['index_info'] != None and params['index_info'] != '':
            
            index_info_path = os.path.join(output_dir, 'index_info.txt')
            index_info_buf = []
            
            for line in params['index_info'].split("\n"):
                line = line.strip()
                if line == '':
                    continue
                row = line.split()
                if row[0] == "id" or row[0] == "ID" or row[0].startswith("#"): 
                    continue
                group_id_order.append(row[0])
                row_str = "\t".join(row)+"\n"
                index_info_buf.append(row_str)
            index_info_handle = open(index_info_path, 'w', 0)
            index_info_handle.writelines(index_info_buf)
            index_info_handle.close()


        # Prep vars
        #
        multx_cmd = []
        multx_cmd.append(self.FASTQ_MULTX])
        
        if params['index_mode'] == 'auto-detect':
            multx_cmd.append('-l')
            multx_cmd.append(master_barcodes_path)
        elif params['index_mode'] == 'manual':
            multx_cmd.append('-B')
            multx_cmd.append(index_info_path)
        elif params['index_mode'] == 'index-lane':
            multx_cmd.append('-g')
            multx_cmd.append(index_index_fwd_file_path)
            # what about reverse barcode lane?

        if 'use_header_barcode' in params and params['use_header_barcode'] == 1:
            multx_cmd.append('-H')
        if 'force_beg' in params and params['force_beg'] == 1:
            multx_cmd.append('-b')
        if 'force_end' in params and params['force_end'] == 1:
            multx_cmd.append('-e')

        if 'trim_barcode' in params and params['trim_barcode'] == 0:
            multx_cmd.append('-x')
        if 'suggest_barcodes' in params and params['suggest_barcodes'] == 1:
            multx_cmd.append('-n')

        if 'mismatch_max' in params and params['mismatch_max'] != None and parmas['mimatch_max'] != '':
            multx_cmd.append('-m')
            multx_cmd.append(int(params['mismatch_max']))
        if 'edit_dist_min' in params and params['edit_dist_min'] != None and parmas['mimatch_max'] != '':
            multx_cmd.append('-d')
            multx_cmd.append(int(params['edit_dist_min']))
        if 'barcode_base_qual_score_min' in params and params['barcode_base_qual_score_min'] != None and parmas['mimatch_max'] != '':
            multx_cmd.append('-q')
            multx_cmd.append(int(params['barcode_base_qual_score_min']))

        # add input and output files
        out_pattern = output_dir+'/'+'fwd.%.fq'
        multx_cmd.append(input_fwd_file_path)
        multx_cmd.append('-o')
        multx_cmd.append(out_pattern)
        if input_reads_obj_type == "KBaseFile.PairedEndLibrary":
           out_pattern = output_dir+'/'+'rev.%.fq'
           multx_cmd.append(input_rev_file_path)
           multx_cmd.append('-o')
           multx_cmd.append(out_pattern)


        # Run
        #
        print('running fastq-multx:')
        print('    '+' '.join(multx_cmd))
        outputlines = []
        p = subprocess.Popen(multx_cmd, cwd=self.scratch, shell=False)
        while True:
            line = p.stdout.readline()
            outputlines.append(line)
            if not line: break
            self.log(console, line.replace('\n', ''))

        p.stdout.close()
        retcode = p.wait()
        print('Return code: ' + str(retcode))
        if p.returncode != 0:
            raise ValueError('Error running fastq-multx, return code: ' +
                             str(retcode) + '\n')        

        report += "\n".outputlines


        # Collect output files and upload



        #END run_Fastq_Multx

        # At some point might do deeper type checking...
        if not isinstance(returnVal, dict):
            raise ValueError('Method run_Fastq_Multx return value ' +
                             'returnVal is not type dict as required.')
        # return the results
        return [returnVal]

    def run_Fastq_Join(self, ctx, params):
        """
        :param params: instance of type "run_Fastq_Join_Input"
           (run_Fastq_Join() ** ** merge overlapping mate pairs into
           SingleEnd Lib.  This sub interacts with Narrative) -> structure:
           parameter "workspace_name" of type "workspace_name" (** Common
           types), parameter "input_reads_ref" of type "data_obj_ref",
           parameter "output_reads_name" of type "data_obj_name"
        :returns: instance of type "run_Fastq_Join_Output" -> structure:
           parameter "report_name" of String, parameter "report_ref" of String
        """
        # ctx is the context object
        # return variables are: returnVal
        #BEGIN run_Fastq_Join
        #END run_Fastq_Join

        # At some point might do deeper type checking...
        if not isinstance(returnVal, dict):
            raise ValueError('Method run_Fastq_Join return value ' +
                             'returnVal is not type dict as required.')
        # return the results
        return [returnVal]

    def exec_Fastq_Join(self, ctx, params):
        """
        :param params: instance of type "exec_Fastq_Join_Input"
           (exec_Fastq_Join() ** ** merge overlapping mate pairs into
           SingleEnd Lib.  This routine creates readsSets) -> structure:
           parameter "workspace_name" of type "workspace_name" (** Common
           types), parameter "input_reads_ref" of type "data_obj_ref",
           parameter "output_reads_name" of type "data_obj_name"
        :returns: instance of type "exec_Fastq_Join_Output" -> structure:
           parameter "output_reads_ref" of type "data_obj_ref"
        """
        # ctx is the context object
        # return variables are: returnVal
        #BEGIN exec_Fastq_Join
        #END exec_Fastq_Join

        # At some point might do deeper type checking...
        if not isinstance(returnVal, dict):
            raise ValueError('Method exec_Fastq_Join return value ' +
                             'returnVal is not type dict as required.')
        # return the results
        return [returnVal]

    def exec_Fastq_Join_OneLibrary(self, ctx, params):
        """
        :param params: instance of type "exec_Fastq_Join_Input"
           (exec_Fastq_Join() ** ** merge overlapping mate pairs into
           SingleEnd Lib.  This routine creates readsSets) -> structure:
           parameter "workspace_name" of type "workspace_name" (** Common
           types), parameter "input_reads_ref" of type "data_obj_ref",
           parameter "output_reads_name" of type "data_obj_name"
        :returns: instance of type "exec_Fastq_Join_Output" -> structure:
           parameter "output_reads_ref" of type "data_obj_ref"
        """
        # ctx is the context object
        # return variables are: returnVal
        #BEGIN exec_Fastq_Join_OneLibrary
        #END exec_Fastq_Join_OneLibrary

        # At some point might do deeper type checking...
        if not isinstance(returnVal, dict):
            raise ValueError('Method exec_Fastq_Join_OneLibrary return value ' +
                             'returnVal is not type dict as required.')
        # return the results
        return [returnVal]

    def exec_Determine_Phred(self, ctx, params):
        """
        :param params: instance of type "exec_Determine_Phred_Input"
           (exec_Determine_Phred() ** ** determine qual score regime.  Either
           "phred33" or "phred64") -> structure: parameter "workspace_name"
           of type "workspace_name" (** Common types), parameter
           "input_reads_ref" of type "data_obj_ref"
        :returns: instance of type "exec_Determine_Phred_Output" ->
           structure: parameter "qual_regime" of String
        """
        # ctx is the context object
        # return variables are: returnVal
        #BEGIN exec_Determine_Phred
        console = []
        report = ''
        self.log(console, 'Running KButil_Determine_Phred() with parameters: ')
        self.log(console, "\n"+pformat(params))
        
        token = ctx['token']
        wsClient = workspaceService(self.workspaceURL, token=token)
        headers = {'Authorization': 'OAuth '+token}
        env = os.environ.copy()
        env['KB_AUTH_TOKEN'] = token
        
        SERVICE_VER = 'dev'  # DEBUG

        # param checks
        if 'input_reads_ref' not in params and 'input_reads_file' not in params:
            raise ValueError ("Must define either param: 'input_reads_ref' or 'input_reads_file'")
            
        # get file
        if 'input_reads_file' in params:
            this_input_fwd_path = params['input_reads_file']
        else:
            # Determine whether read library is of correct type
            try:
                # object_info tuple
                [OBJID_I, NAME_I, TYPE_I, SAVE_DATE_I, VERSION_I, SAVED_BY_I, WSID_I, WORKSPACE_I, CHSUM_I, SIZE_I, META_I] = range(11)
                
                input_reads_ref = params['input_reads_ref']
                input_reads_obj_info = wsClient.get_object_info_new ({'objects':[{'ref':input_reads_ref}]})[0]
                input_reads_obj_type = input_reads_obj_info[TYPE_I]
                input_reads_obj_type = re.sub ('-[0-9]+\.[0-9]+$', "", input_reads_obj_type)  # remove trailing version
            #input_reads_obj_version = input_reads_obj_info[VERSION_I]  # this is object version, not type version
                
            except Exception as e:
                raise ValueError('Unable to get read library object info from workspace: (' + str(input_reads_ref) +')' + str(e))
            
            acceptable_types = ["KBaseFile.PairedEndLibrary", "KBaseFile.SingleEndLibrary"]
            if input_reads_obj_type not in acceptable_types:
                raise ValueError ("Input reads of type: '"+input_reads_obj_type+"'.  Must be one of "+", ".join(acceptable_types))


            # Download Reads
            self.log (console, "DOWNLOADING READS")  # DEBUG
            try:
                readsUtils_Client = ReadsUtils (url=self.callbackURL, token=ctx['token'])  # SDK local
            except Exception as e:
                raise ValueError('Unable to get ReadsUtils Client' +"\n" + str(e))
            try:
                readsLibrary = readsUtils_Client.download_reads ({'read_libraries': [input_reads_ref],
                                                                  'interleaved': 'false'
                                                                  })
            except Exception as e:
                raise ValueError('Unable to download read library sequences from workspace: (' + str(input_reads_ref) +")\n" + str(e))
            
            this_input_fwd_path = readsLibrary['files'][this_input_reads_ref]['files']['fwd']

        
        # Run determine-phred
        determine_phred_cmd = []
        determine_phred_cmd.append(self.DETERMINE_PHRED)
        determine_phred_cmd.append(this_input_fwd_path)
        print('running determine-phred:')
        print('    '+' '.join(determine_phred_cmd))
        p = subprocess.Popen(determine_phred_cmd, cwd=self.scratch, shell=False)
        phred_regime = p.stdout.readline()
        phred_regime.replace('\n', ''))
        p.stdout.close()

        retcode = p.wait()
        print('Return code: ' + str(retcode))
        if p.returncode != 0:
            raise ValueError('Error running Determine_Phred(), return code: ' +
                             str(retcode) + '\n')        

        returnVal = { 'phred_type': phred_regime }
        #END exec_Determine_Phred

        # At some point might do deeper type checking...
        if not isinstance(returnVal, dict):
            raise ValueError('Method exec_Determine_Phred return value ' +
                             'returnVal is not type dict as required.')
        # return the results
        return [returnVal]
    def status(self, ctx):
        #BEGIN_STATUS
        returnVal = {'state': "OK", 'message': "", 'version': self.VERSION, 
                     'git_url': self.GIT_URL, 'git_commit_hash': self.GIT_COMMIT_HASH}
        #END_STATUS
        return [returnVal]
