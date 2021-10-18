# -*- coding: utf-8 -*-
"""
This module is an example python-based testing interface.  It uses the
``requests`` package to make REST API calls to the test case container,
which must already be running.  A controller is tested, which is
imported from a different module.

"""

# GENERAL PACKAGE IMPORT
# ----------------------
import requests
import time
import numpy as np
from examples.python.custom_kpi.custom_kpi_calculator import CustomKPI
from examples.python.controllers.controller import Controller
import json
import collections
import pandas as pd


def control_test(control_module='', start_time=0, warmup_period=0, length=24*3600, scenario=None, step=300, customized_kpi_config=None, forecast_config=None):
    """Run test case.

    Parameters
    ----------

    control_module: str
        relative path to controller code without .py suffix (e.g., 'controllers.sup').
    start_time: int, optional
        Simulation start time in seconds from midnight January 1st.
        Not used if scenario defined.
        Default is 0.
    warmup_period: int, optional
        Simulation warmup-period in seconds before start_time.
        Not used if scenario defined.
        Default is 0.
    length: int, optional
        Simulation duration in seconds (e.g., 24*3600 is a 1 day simulation).
        Not used if scenario defined.
        Default is 24*3600 (1-day).
    scenario: dict, optional
        Dictionary defining the predefined test scenario.
        {'time_period': str, 'electricity_price': str}.
        If specified, start_time, warmup_period, and length not used.
        Default is None.
    step: int, optional
        Simulation step size in seconds.
        Default is 300.
    customized_kpi_config: str, optional
        relative path to custom KPI (e.g., 'custom_kpi.custom_kpis_example.config')
        Default is None.
    forecast_config: list of str, optional
        List of strings.  Each element is a point that needs to be passed from the /forecast API endpoint.
        Default is None.

    Returns
    -------
    kpi : dict
        Dictionary of core KPI names and values.
        {kpi_name : value}
    res : dict
        Dictionary of trajectories of inputs and outputs.
    custom_kpi_result: dict
        Dictionary of tracked custom KPI calculations.
        Empty if no customized KPI calculations defined.

    """

    # SETUP TEST CASE
    # ---------------
    # Set URL for testcase
    url = 'http://127.0.0.1:5000'
    # Instantiate controller
    controller = Controller(control_module, forecast_config)
    # Initialize storage structure for forecasts if needed
    forecasts_store = None
    if forecast_config is not None:
        forecasts_store = pd.DataFrame(columns=forecast_config)

    # GET TEST INFORMATION
    # --------------------
    print('\nTEST CASE INFORMATION\n---------------------')
    # Test case name
    name = requests.get('{0}/name'.format(url)).json()
    print('Name:\t\t\t\t{0}'.format(name))
    # Inputs available
    inputs = requests.get('{0}/inputs'.format(url)).json()
    print('Control Inputs:\t\t\t{0}'.format(inputs))
    # Measurements available
    measurements = requests.get('{0}/measurements'.format(url)).json()
    print('Measurements:\t\t\t{0}'.format(measurements))
    # Default simulation step
    step_def = requests.get('{0}/step'.format(url)).json()
    print('Default Simulation Step:\t{0}'.format(step_def))

    # DEFINE CUSTOM KPI CALCULATION STRUCTURES IF ANY
    # -----------------------------------------------
    custom_kpis = []  # Initialize customized kpi calculation list
    custom_kpi_result = {}  # Initialize tracking of customized kpi calculation results
    if customized_kpi_config is not None:
        with open(customized_kpi_config) as f:
            config = json.load(f, object_pairs_hook=collections.OrderedDict)
        for key in config.keys():
            custom_kpis.append(CustomKPI(config[key]))
            custom_kpi_result[CustomKPI(config[key]).name] = []
    custom_kpi_result['time'] = []
    # --------------------

    # RUN TEST CASE
    # -------------
    # Record real starting time
    start = time.time()
    # Initialize test case
    print('Initializing test case simulation.')
    if scenario is not None:
        res = requests.put('{0}/scenario'.format(url), data=scenario).json()['time_period']
        # Record test simulation start time
        start_time = res['time']
        final_time = np.inf
        total_time_steps = int((365 * 24 * 3600)/step)
    else:
        res = requests.put('{0}/initialize'.format(url), data={'start_time': start_time, 'warmup_period': warmup_period}).json()
        final_time = length
        total_time_steps = int(length / step)  # calculate number of timesteps
    if res:
        print('Successfully initialized the simulation')
    print('\nRunning test case...')
    # Set simulation step
    res = requests.put('{0}/step'.format(url), data={'step': step})
    # Initialize u
    u = controller.initialize()
    # Simulation Loop
    for t in range(total_time_steps):
        # Advance simulation with control input value(s)
        y = requests.post('{0}/advance'.format(url), data=u).json()
        # Compute customized KPIs if any
        for kpi in custom_kpis:
            kpi.processing_data(y)  # Process data as needed for custom KPI
            custom_kpi_value = kpi.calculation()  # Calculate custom KPI value
            custom_kpi_result[kpi.name].append(round(custom_kpi_value, 2))  # Track custom KPI value
            print('KPI:\t{0}:\t{1}'.format(kpi.name, round(custom_kpi_value, 2)))  # Print custom KPI value
        custom_kpi_result['time'].append(y['time'])  # Track custom KPI calculation time
        # If reach end of scenario, stop
        if not y:
            break
        # If controller needs a forecast, get the forecast data
        if controller.use_forecast:
            # Get forecast from BOPTEST
            forecast_data = requests.get('{0}/forecast'.format(url)).json()
            # Use BOPTEST forecast data to update controller-specific forecast data
            forecasts = controller.update_forecasts(forecast_config, forecast_data)
            # TODO Store forecast data used in controller
            if forecasts_store is not None:
                forecasts_store.loc[(t + 1) * step, forecasts_store.columns] = forecasts
        else:
            forecasts = []
        # Compute control signal for next step
        u = controller.compute_control(y, forecasts)
    print('\nTest case complete.')
    print('Elapsed time of test was {0} seconds.'.format(time.time()-start))
    # -------------

    # VIEW RESULTS
    # ------------
    # Report KPIs
    kpi = requests.get('{0}/kpi'.format(url)).json()
    print('\nKPI RESULTS \n-----------')
    for key in kpi.keys():
        if key == 'ener_tot':
            unit = 'kWh/m$^2$'
        elif key == 'tdis_tot':
            unit = 'Kh/zone'
        elif key == 'idis_tot':
            unit = 'ppmh/zone'
        elif key == 'cost_tot':
            unit = 'Euro or \$/m$^2$'
        elif key == 'emis_tot':
            unit = 'KgCO2/m$^2$'
        elif key == 'time_rat':
            unit = 's/s'
        else:
            unit = None
        print('{0}: {1} {2}'.format(key, kpi[key], unit))
    # ------------

    # POST PROCESS RESULTS
    # --------------------
    # Get result data
    points = list(measurements.keys()) + list(inputs.keys())
    df_res = pd.DataFrame()
    for point in points:
        res = requests.put('{0}/results'.format(url), data={'point_name': point, 'start_time': start_time, 'final_time': final_time}).json()
        df_res = pd.concat((df_res, pd.DataFrame(data=res[point], index=res['time'], columns=[point])), axis=1)
    df_res.index.name = 'time'

    return kpi, df_res, custom_kpi_result, forecasts_store
