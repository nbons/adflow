from __future__ import print_function
import unittest
import numpy
from baseclasses import BaseRegTest

class RegTest5(unittest.TestCase):
    '''
    Test 5: MDO tutorial -- Viscous -- Scalar JST
    '''
    N_PROCS = 4

    def setUp(self):
        self.ref_file = 'reg_tests/ref/test5.ref'

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
        gridFile = 'input_files/mdo_tutorial_viscous_scalar_jst.cgns'

        options = copy.copy(adflowDefOpts)
        options.update({
            'gridfile': gridFile,
            'mgcycle':'2w',
            'equationtype':'Laminar NS',
            'cfl':1.5,
            'cflcoarse':1.25,
            'ncyclescoarse':250,
            'ncycles':10000,
            'monitorvariables':['cpu', 'resrho','resturb','cl','cd','totalr'],
            'usenksolver':True,
            'l2convergence':1e-14,
            'l2Convergencecoarse':1e-2,
            'nkswitchtol':1e-2,
            'adjointl2convergence': 1e-14,
        })

        # Setup aeroproblem, cfdsolver, mesh and geometry.
        ap = AeroProblem(name='mdo_tutorial', alpha=1.8, beta=0.0, mach=0.50,
                 P=137.0, T=293.15, R=287.87,
                 areaRef=45.5, chordRef=3.25, xRef=0.0, yRef=0.0, zRef=0.0,
                 evalFuncs=defaultFuncList)

        if not solve:
            options['restartfile'] = gridFile

        # Create the solver
        CFDSolver = ADFLOW(options=options, debug=False)
        standard_test(handler, CFDSolver, ap, solve)
