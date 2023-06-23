within MultiZoneOfficeSimpleAir.BaseClasses;
model ReadZone "Collection of zone measurements for BOPTEST"
  Buildings.Utilities.IO.SignalExchange.Read TZon(
    description="Zone air temperature measurement for zone " + zone,
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.AirZoneTemperature,
    y(unit="K"),
    zone=zone) "Zone air temperature measurement"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));

  Modelica.Blocks.Interfaces.RealInput TZon_in
    "Zone air temperature measurement"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  parameter String zone="1" "Zone designation, required if KPIs is AirZoneTemperature,
    RadiativeZoneTemperature, OperativeZoneTemperature, RelativeHumidity,
    or CO2Concentration";
  Buildings.Utilities.IO.SignalExchange.Read TSup(
    description="Discharge air temperature to zone measurement for zone " +
        zone,
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="K")) "Supply air temperature to zone measurement"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Utilities.IO.SignalExchange.Read V_flow(
    description="Discharge air flowrate to zone measurement for zone " + zone,
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="m3/s")) "Supply air flowrate to zone measurement"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Modelica.Blocks.Interfaces.RealInput TSup_in
    "Supply air temperature to zone measurement"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput V_flow_in
    "Supply air flowrate to zone measurement"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Fluid.Sensors.Conversions.To_VolumeFraction conMasVolFra(MMMea=
        Modelica.Media.IdealGases.Common.SingleGasesData.CO2.MM)
    "Conversion from mass fraction CO2 to volume fraction CO2"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Modelica.Blocks.Math.Gain gaiPPM(k=1e6) "Convert mass fraction to PPM"
    annotation (Placement(transformation(extent={{-30,-90},{-10,-70}})));
  Buildings.Utilities.IO.SignalExchange.Read CO2Zon(
    description="Zone air CO2 measurement for zone " + zone,
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.CO2Concentration,
    y(unit="ppm"),
    zone=zone) "Zone air CO2 concentration measurement"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));

  Modelica.Blocks.Interfaces.RealInput C_In "Mass fraction of CO2"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput yHea_in "Heating PID signal measurement"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Buildings.Utilities.IO.SignalExchange.Read yHea(
    description="Heating PID signal measurement for zone " + zone,
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="1"),
    zone=zone) "Heating PID signal measurement"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));

  Modelica.Blocks.Interfaces.RealInput yCoo_in "Cooling PID signal measurement"
    annotation (Placement(transformation(extent={{-140,100},{-100,140}})));
  Buildings.Utilities.IO.SignalExchange.Read yCoo(
    description="Cooling PID signal measurement for zone " + zone,
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="1"),
    zone=zone) "Cooling PID signal measurement"
    annotation (Placement(transformation(extent={{0,110},{20,130}})));

  Buildings.Utilities.IO.SignalExchange.Read yReheaVal(
    description="Reheat valve position measurement for zone " + zone,
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="1"),
    zone=zone) "Reheat valve position measurement"
    annotation (Placement(transformation(extent={{0,150},{20,170}})));

  Buildings.Utilities.IO.SignalExchange.Read yDam(
    description="Damper position measurement for zone " + zone,
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="1"),
    zone=zone) "Damper position measurement"
    annotation (Placement(transformation(extent={{0,190},{20,210}})));

  Modelica.Blocks.Interfaces.RealInput yReheaVal_in
    "Reheat valve position measurement"
    annotation (Placement(transformation(extent={{-140,140},{-100,180}})));
  Modelica.Blocks.Interfaces.RealInput yDam_in "Damper position measurement"
    annotation (Placement(transformation(extent={{-140,180},{-100,220}})));
  Buildings.Utilities.IO.SignalExchange.Read TRoo_Coo_set(
    description="Zone temperature cooling setpoint for zone" + zone,
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="K"),
    zone=zone) "Zone temperature cooling setpoint"
    annotation (Placement(transformation(extent={{0,-180},{20,-160}})));

  Buildings.Utilities.IO.SignalExchange.Read TRoo_Hea_set(
    description="Zone temperature heating setpoint for zone " + zone,
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="K"),
    zone=zone) "Zone temperature heating setpoint"
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));

  Modelica.Blocks.Interfaces.RealInput TRoo_Coo_set_in
    "Zone temperature cooling setpoint"
    annotation (Placement(transformation(extent={{-140,-190},{-100,-150}})));
  Modelica.Blocks.Interfaces.RealInput TRoo_Hea_set_in
    "Zone temperature heating setpoint"
    annotation (Placement(transformation(extent={{-140,-150},{-100,-110}})));
  Buildings.Utilities.IO.SignalExchange.Read V_flow_set(
    description="Airflow setpoint" + zone,
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="m3/s"),
    zone=zone) "Minimum airflow setpoint"
    annotation (Placement(transformation(extent={{0,-230},{20,-210}})));

  Modelica.Blocks.Interfaces.RealInput Vflow_set_in "Airflow setpoint"
    annotation (Placement(transformation(extent={{-140,-240},{-100,-200}})));
  Buildings.Utilities.IO.SignalExchange.Read yCO2(
    description="CO2 PID signal for zone " + zone,
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="1"),
    zone=zone) "CO2 PID signal"
    annotation (Placement(transformation(extent={{0,240},{20,260}})));

  Modelica.Blocks.Interfaces.RealInput yCO2_in "CO2 PID signal"
    annotation (Placement(transformation(extent={{-140,230},{-100,270}})));
  Modelica.Blocks.Interfaces.RealInput Cov_In "Mass fraction of Covid"
    annotation (Placement(transformation(extent={{-142,276},{-102,316}})));
  Buildings.Utilities.IO.SignalExchange.Read CovZon(
    description="Zone air Covid measurement for zone " + zone,
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="1"), zone=zone) "Zone air Covid concentration measurement"
    annotation (Placement(transformation(extent={{0,288},{20,308}})));
equation
  connect(TZon.u, TZon_in)
    annotation (Line(points={{-2,40},{-120,40}}, color={0,0,127}));
  connect(TSup.u, TSup_in)
    annotation (Line(points={{-2,0},{-120,0}},     color={0,0,127}));
  connect(V_flow.u, V_flow_in)
    annotation (Line(points={{-2,-40},{-120,-40}}, color={0,0,127}));
  connect(conMasVolFra.V,gaiPPM. u)
    annotation (Line(points={{-39,-80},{-32,-80}},
                                                 color={0,0,127}));
  connect(gaiPPM.y, CO2Zon.u)
    annotation (Line(points={{-9,-80},{-2,-80}},   color={0,0,127}));
  connect(conMasVolFra.m, C_In)
    annotation (Line(points={{-61,-80},{-120,-80}},   color={0,0,127}));
  connect(yHea_in, yHea.u)
    annotation (Line(points={{-120,80},{-2,80}}, color={0,0,127}));
  connect(yCoo_in, yCoo.u)
    annotation (Line(points={{-120,120},{-2,120}}, color={0,0,127}));
  connect(yReheaVal_in, yReheaVal.u)
    annotation (Line(points={{-120,160},{-2,160}}, color={0,0,127}));
  connect(yDam_in, yDam.u)
    annotation (Line(points={{-120,200},{-2,200}}, color={0,0,127}));
  connect(TRoo_Coo_set_in, TRoo_Coo_set.u)
    annotation (Line(points={{-120,-170},{-2,-170}}, color={0,0,127}));
  connect(TRoo_Hea_set_in, TRoo_Hea_set.u)
    annotation (Line(points={{-120,-130},{-2,-130}}, color={0,0,127}));
  connect(Vflow_set_in, V_flow_set.u)
    annotation (Line(points={{-120,-220},{-2,-220}}, color={0,0,127}));
  connect(yCO2_in, yCO2.u)
    annotation (Line(points={{-120,250},{-2,250}}, color={0,0,127}));
  connect(Cov_In, CovZon.u) annotation (Line(points={{-122,296},{-62,296},{-62,298},
          {-2,298}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-240},
            {100,320}}),                                        graphics={
          Rectangle(
          extent={{-100,80},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid), Text(
          extent={{-56,176},{52,142}},
          lineColor={28,108,200},
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Text(
          extent={{-28,24},{38,-16}},
          lineColor={0,0,0},
          textString="Read
Zone")}),                        Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-100,-240},{100,320}})));
end ReadZone;
