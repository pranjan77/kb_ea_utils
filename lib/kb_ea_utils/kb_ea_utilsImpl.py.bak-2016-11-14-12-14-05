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


class kb_ea_utils:
    '''
    Module Name:
    kb_ea_utils

    Module Description:
    Utilities for converting KBaseAssembly types to KBaseFile types
    '''

    ######## WARNING FOR GEVENT USERS #######
    # Since asynchronous IO can lead to methods - even the same method -
    # interrupting each other, you must be *very* careful when using global
    # state. A method could easily clobber the state set by another while
    # the latter method is running.
    #########################################
    VERSION = "0.0.1"
    GIT_URL = "git@github.com:pranjan77/kb_ea_utils.git"
    GIT_COMMIT_HASH = "93c2eab28a9267edee8bfbb8e95b1de39ff094e6"
    
    #BEGIN_CLASS_HEADER
    def log(self, target, message):
        if target is not None:
            target.append(message)
        print(message)
        sys.stdout.flush()


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


    def get_ea_utils_result (self,refid, callbackURL, input_params):
      ref = [refid] 
      DownloadReadsParams={'read_libraries':ref}
      dfUtil = ReadsUtils(callbackURL)
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
           "get_fastq_ea_utils_stats_params" (This module has methods to  get
           fastq statistics 2. KBaseAssembly.PairedEndLibrary to
           KBaseFile.PairedEndLibrary workspace_name    - the name of the
           workspace for input/output read_library_name - the name of the
           KBaseAssembly.SingleEndLibrary or KBaseAssembly.PairedEndLibrary
           or KBaseFile.SingleEndLibrary or KBaseFile.PairedEndLibrary) ->
           structure: parameter "workspace_name" of String, parameter
           "read_library_name" of String
        :returns: instance of String
        """
        # ctx is the context object
        # return variables are: ea_utils_stats
        #BEGIN get_fastq_ea_utils_stats
        token = ctx['token']
        wsClient = workspaceService(self.workspaceURL, token=token)
        headers = {'Authorization': 'OAuth '+token}
        provenance = [{}]
        if 'provenance' in ctx:
            provenance = ctx['provenance']
        # add additional info to provenance here, in this case the input data object reference
        workspace_name = input_params['workspace_name']
        provenance[0]['input_ws_objects']=[workspace_name+'/'+input_params['read_library_name']]

        info = None
        readLibrary = None
        try:
            readLibrary = wsClient.get_objects([{'name': input_params['read_library_name'],
                                                 'workspace' : input_params['workspace_name']}])[0]
            info = readLibrary['info']
            readLibrary = readLibrary['data']
        except Exception as e:
            raise ValueError('Unable to get read library object from workspace: (' + str(input_params['workspace_name'])+ '/' + str(input_params['read_library_name']) +')' + str(e))
        callbackURL = self.callbackURL
        input_reads_ref = str(input_params['workspace_name']) + '/' + str(input_params['read_library_name'])
        ea_utils_stats = ''
        ea_utils_stats = self.get_ea_utils_result (input_reads_ref, callbackURL, input_params)

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
           "run_app_fastq_ea_utils_stats_params" -> structure: parameter
           "workspace_name" of String, parameter "read_library_name" of String
        :returns: instance of type "Report" -> structure: parameter
           "report_name" of String, parameter "report_ref" of String
        """
        # ctx is the context object
        # return variables are: report
        #BEGIN run_app_fastq_ea_utils_stats
        print (input_params)

        token = ctx['token']
        wsClient = workspaceService(self.workspaceURL, token=token)
        headers = {'Authorization': 'OAuth '+token}
        provenance = [{}]
        if 'provenance' in ctx:
            provenance = ctx['provenance']
        # add additional info to provenance here, in this case the input data object reference
        workspace_name = input_params['workspace_name']
        provenance[0]['input_ws_objects']=[workspace_name+'/'+input_params['read_library_name']]

        info = None
        readLibrary = None
        try:
            readLibrary = wsClient.get_objects([{'name': input_params['read_library_name'],
                                                 'workspace' : input_params['workspace_name']}])[0]
            info = readLibrary['info']
            readLibrary = readLibrary['data']
        except Exception as e:
            raise ValueError('Unable to get read library object from workspace: (' + str(input_params['workspace_name'])+ '/' + str(input_params['read_library_name']) +')' + str(e))
#        ref=['11665/5/2', '11665/10/7', '11665/11/1' ]
        #ref=['11802/9/1']
        callbackURL = self.callbackURL
        input_reads_ref = str(input_params['workspace_name']) + '/' + str(input_params['read_library_name'])
        report = ''
        report = self.get_ea_utils_result (input_reads_ref, callbackURL, input_params)
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
        This function should be used for getting statistics on fastq files. Input is string of file path
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

    def status(self, ctx):
        #BEGIN_STATUS
        returnVal = {'state': "OK", 'message': "", 'version': self.VERSION, 
                     'git_url': self.GIT_URL, 'git_commit_hash': self.GIT_COMMIT_HASH}
        #END_STATUS
        return [returnVal]
