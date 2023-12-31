# -*- coding: utf-8 -*-
"""
This module implements a supervisory controller for room temperature set points
specifically for testcase2.

"""


def compute_control(y, forecasts=None):
    """Compute the control input from the measurement.

    Parameters
    ----------
    y : dict
        Contains the current values of the measurements.
        {<measurement_name>:<measurement_value>}
    forecasts : structure depends on controller, optional
        Forecasts used to calculate control.
        Default is None.

    Returns
    -------
    u : dict
        Defines the control input to be used for the next step.
        {<input_name> : <input_value>}

    """

    # Compute control
    u = {
        'hvac_oveZonSupEas_TZonHeaSet_u': 22 + 273.15,
        'hvac_oveZonSupEas_TZonHeaSet_activate': 1,
        'hvac_oveZonSupEas_TZonCooSet_u': 23 + 273.15,
        'hvac_oveZonSupEas_TZonCooSet_u': 1
    }

    return u


def initialize():
    """Initialize the control input u.

    Parameters
    ----------
    None

    Returns
    -------
    u : dict
        Defines the control input to be used for the next step.
        {<input_name> : <input_value>}

    """
    u = {
        'hvac_oveZonSupEas_TZonHeaSet_u': 22 + 273.15,
        'hvac_oveZonSupEas_TZonHeaSet_activate': 1,
        'hvac_oveZonSupEas_TZonCooSet_u': 23 + 273.15,
        'hvac_oveZonSupEas_TZonCooSet_u': 1
    }

    return u
