from __future__ import print_function
import unittest
import numpy
from baseclasses import BaseRegTest

class RegTest1(unittest.TestCase):
    '''
    Test 1: MDO tutorial -- Euler -- Scalar JST
    '''
    N_PROCS = 4

    def setUp(self):
        self.ref_file = 'reg_tests/ref/test1.ref'

    def train(self):
        with BaseRegTest(self.ref_file, train=True) as handler:
            self.regression_test(handler)

    def test(self):
        with BaseRegTest(self.ref_file, train=False) as handler:
            self.regression_test(handler)

    def regression_test(self, handler, solve=False):
        '''
        This is where the actual testing happens.
        '''
        import copy
        from baseclasses import AeroProblem
        from commonUtils import standard_test, adflowDefOpts, defaultFuncList
        from ... import ADFLOW
        gridFile = 'input_files/mdo_tutorial_euler_scalar_jst.cgns'

        options = copy.copy(adflowDefOpts)
        options.update({
            'gridfile': gridFile,
            'mgcycle':'2w',
            'ncyclescoarse':250,
            'ncycles':500,
            'monitorvariables':['cpu', 'resrho','cl','cd','cmz','totalr'],
            'usenksolver':True,
            'l2convergence':1e-14,
            'l2convergencecoarse':1e-2,
            'nkswitchtol':1e-2,
            'adjointl2convergence': 1e-14,
            'solutionprecision':'double',
            'gridprecision':'double',
        })

        # Setup aeroproblem, cfdsolver, mesh and geometry.
        ap = AeroProblem(name='mdo_tutorial', alpha=1.8, mach=0.80, P=20000.0, T=220.0,
                        areaRef=45.5, chordRef=3.25, beta=0.0, R=287.87,
                        xRef=0.0, yRef=0.0, zRef=0.0, evalFuncs=defaultFuncList)

        if not solve:
            options['restartfile'] = gridFile

        # Create the solver
        CFDSolver = ADFLOW(options=options, debug=True)
        standard_test(handler, CFDSolver, ap, solve)