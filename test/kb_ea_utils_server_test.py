# -*- coding: utf-8 -*-
import unittest
import os
import json
import time
import requests

from os import environ
try:
    from ConfigParser import ConfigParser  # py2
except:
    from configparser import ConfigParser  # py3

from pprint import pprint

from biokbase.workspace.client import Workspace as workspaceService
from kb_ea_utils.kb_ea_utilsImpl import kb_ea_utils
from kb_ea_utils.kb_ea_utilsServer import MethodContext


class kb_ea_utilsTest(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        token = environ.get('KB_AUTH_TOKEN', None)
        user_id = requests.post(
            'https://kbase.us/services/authorization/Sessions/Login',
            data='token={}&fields=user_id'.format(token)).json()['user_id']
        # WARNING: don't call any logging methods on the context object,
        # it'll result in a NoneType error
        cls.ctx = MethodContext(None)
        cls.ctx.update({'token': token,
                        'user_id': user_id,
                        'provenance': [
                            {'service': 'kb_ea_utils',
                             'method': 'please_never_use_it_in_production',
                             'method_params': []
                             }],
                        'authenticated': 1})
        config_file = environ.get('KB_DEPLOYMENT_CONFIG', None)
        cls.cfg = {}
        config = ConfigParser()
        config.read(config_file)
        for nameval in config.items('kb_ea_utils'):
            cls.cfg[nameval[0]] = nameval[1]
        cls.wsURL = cls.cfg['workspace-url']
        cls.wsClient = workspaceService(cls.wsURL, token=token)
        cls.serviceImpl = kb_ea_utils(cls.cfg)

    @classmethod
    def tearDownClass(cls):
        if hasattr(cls, 'wsName'):
            cls.wsClient.delete_workspace({'workspace': cls.wsName})
            print('Test workspace was deleted')

    def getWsClient(self):
        return self.__class__.wsClient

    def getWsName(self):
        if hasattr(self.__class__, 'wsName'):
            return self.__class__.wsName
        suffix = int(time.time() * 1000)
        wsName = "test_kb_ea_utils_" + str(suffix)
        ret = self.getWsClient().create_workspace({'workspace': wsName})
        self.__class__.wsName = wsName
        return wsName

    def getImpl(self):
        return self.__class__.serviceImpl

    def getContext(self):
        return self.__class__.ctx

    # NOTE: According to Python unittest naming rules test method names should start from 'test'.
    def test_ea_utils(self):
        # Prepare test objects in workspace if needed using 
        # self.getWsClient().save_objects({'workspace': self.getWsName(), 'objects': []})
        #13139/22/6

        # TODO: preload this test data to the WS before running tests
        ws_id = "pranjan77:1475663060070"
        ws_obj_id = "rhodobacter.art.q10.PE.reads"
        #input_params={'workspace_name': ws_id, 'read_library_name': ws_obj_id}
        #ret = self.getImpl().run_app_fastq_ea_utils_stats(self.getContext(), input_params)
        #print(ret)

        #ws_obj_ref = ws_id + '/' + ws_obj_id
        #input_params={'workspace_name': ws_id, 'read_library_ref': ws_obj_ref}
        #ret = self.getImpl().run_app_fastq_ea_utils_stats(self.getContext(), input_params)
        #print(ret)

        # Run your method by
        # ret = self.getImpl().your_method(self.getContext(), parameters...)
        #
        # Check returned data with
        # self.assertEqual(ret[...], ...) or other unittest methods
        pass

    def test_ea_utils2(self):
        fastq_file = "/kb/module/data/6e9a3750-db21-49d9-a199-6df094e6b953.fwd.fastq";
        input_params={'read_library_path': fastq_file}

        report = self.getImpl().get_ea_utils_stats(self.getContext(), input_params)
        print len (report)
        

        # Run your method by
        # ret = self.getImpl().your_method(self.getContext(), parameters...)
        #
        # Check returned data with
        # self.assertEqual(ret[...], ...) or other unittest methods
        pass

    def test_calculate_fastq_stats(self):
        fastq_file = "/kb/module/data/6e9a3750-db21-49d9-a199-6df094e6b953.fwd.fastq";
        input_params={'read_library_path': fastq_file}

        ea_stats = self.getImpl().calculate_fastq_stats(self.getContext(), input_params)
        self.assertEqual(ea_stats[0]['total_bases'], 38610800)
        # Run your method by
        # ret = self.getImpl().your_method(self.getContext(), parameters...)
        #
        # Check returned data with
        # self.assertEqual(ret[...], ...) or other unittest methods
        pass
        
