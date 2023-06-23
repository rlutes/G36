within MultiZoneOfficeSimpleAir.BaseClasses;
model ReadAhu "Collection of AHU measurements for BOPTEST"
  Buildings.Utilities.IO.SignalExchange.Read TSup(
    description="Supply air temperature measurement for AHU",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="K")) "Supply air temperature measurement"
    annotation (Placement(transformation(extent={{0,190},{20,210}})));
  Buildings.Utilities.IO.SignalExchange.Read TMix(
    description="Mixed air temperature measurement for AHU",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="K"))  "Mixed air temperature measurement"
    annotation (Placement(transformation(extent={{0,160},{20,180}})));
  Buildings.Utilities.IO.SignalExchange.Read TRet(
    description="Return air temperature measurement for AHU",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="K")) "Return air temperature measurement"
    annotation (Placement(transformation(extent={{0,130},{20,150}})));
  Buildings.Utilities.IO.SignalExchange.Read V_flow_sup(
    description="Supply air flowrate measurement for AHU",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="m3/s")) "Supply air flowrate measurement"
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  Buildings.Utilities.IO.SignalExchange.Read V_flow_ret(
    description="Return air flowrate measurement for AHU",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="m3/s"))  "Return air flowrate measurement"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Modelica.Blocks.Interfaces.RealInput TSup_in
    "Supply air temperature measurement"
    annotation (Placement(transformation(extent={{-140,180},{-100,220}})));
  Modelica.Blocks.Interfaces.RealInput TMix_in
    "Mixed air temperature measurement"
    annotation (Placement(transformation(extent={{-140,150},{-100,190}})));
  Modelica.Blocks.Interfaces.RealInput TRet_in
    "Return air temperature measurement"
    annotation (Placement(transformation(extent={{-140,120},{-100,160}})));
  Modelica.Blocks.Interfaces.RealInput V_flow_sup_in
    "Supply air flowrate measurement"
    annotation (Placement(transformation(extent={{-140,90},{-100,130}})));
  Modelica.Blocks.Interfaces.RealInput V_flow_ret_in
    "Return air flowrate measurement"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput dp_in "Discharge pressure of supply fan"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
  Buildings.Utilities.IO.SignalExchange.Read dp_sup(
    description="Discharge pressure of supply fan for AHU",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="Pa"))  "Discharge pressure of supply fan"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));

  Buildings.Utilities.IO.SignalExchange.Read PFanSup(
    description="Electrical power measurement of supply fan for AHU",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.ElectricPower,
    y(unit="W")) "Electrical power of supply fan"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));

  Modelica.Blocks.Interfaces.RealInput PFanSup_in
    "Electrical power of supply fan"
    annotation (Placement(transformation(extent={{-140,-30},{-100,10}})));

  Buildings.Utilities.IO.SignalExchange.Read PPumCoo(
    description="Electrical power measurement of cooling coil pump for AHU",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.ElectricPower,
    y(unit="W")) "Electrical power of cooling coil pump"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));

  Modelica.Blocks.Interfaces.RealInput PPumCoo_in
    "Electrical power of cooling coil pump"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Utilities.IO.SignalExchange.Read PPumHea(
    description="Electrical power measurement of heating coil pump for AHU",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.ElectricPower,
    y(unit="W")) "Electrical power of heating coil pump"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));

  Modelica.Blocks.Interfaces.RealInput PPumHea_in
    "Electrical power of heating coil pump"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Utilities.IO.SignalExchange.Read TCooCoiSup(
    description="Cooling coil supply water temperature measurement for AHU",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="K")) "Cooling coil water supply temperature measurement"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));

  Modelica.Blocks.Interfaces.RealInput TCooCoiSup_in
    "Cooling coil water supply temperature measurement"
    annotation (Placement(transformation(extent={{-140,-120},{-100,-80}})));
  Modelica.Blocks.Interfaces.RealInput TCooCoiRet_in
    "Cooling coil water return temperature measurement"
    annotation (Placement(transformation(extent={{-140,-150},{-100,-110}})));
  Modelica.Blocks.Interfaces.RealInput THeaCoiSup_in
    "Heating coil water supply temperature measurement"
    annotation (Placement(transformation(extent={{-140,-180},{-100,-140}})));
  Modelica.Blocks.Interfaces.RealInput THeaCoiRet_in
    "Heating coil water return temperature measurement"
    annotation (Placement(transformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Utilities.IO.SignalExchange.Read TCooCoiRet(
    description="Cooling coil return water temperature measurement for AHU",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="K")) "Cooling coil water return temperature measurement"
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));

  Buildings.Utilities.IO.SignalExchange.Read THeaCoiSup(
    description="Heating coil supply water temperature measurement for AHU",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="K")) "Heating coil water supply temperature measurement"
    annotation (Placement(transformation(extent={{0,-170},{20,-150}})));

  Buildings.Utilities.IO.SignalExchange.Read THeaCoiRet(
    description="Heating coil return water temperature measurement for AHU",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="K")) "Heating coil water return temperature measurement"
    annotation (Placement(transformation(extent={{0,-200},{20,-180}})));

  Modelica.Blocks.Interfaces.RealInput yHeaCoi_in
    "AHU heating coil valve signal"
    annotation (Placement(transformation(extent={{-140,-260},{-100,-220}})));
  Buildings.Utilities.IO.SignalExchange.Read yHeaCoi(
    description="Heating coil valve signal measurement for AHU",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None, y(unit="1")) "AHU heating coil valve signal measurement"
    annotation (Placement(transformation(extent={{0,-250},{20,-230}})));

  Modelica.Blocks.Interfaces.RealInput yCooCoi_in
    "AHU cooling coil valve signal"
    annotation (Placement(transformation(extent={{-140,-290},{-100,-250}})));
  Buildings.Utilities.IO.SignalExchange.Read yCooCoi(
    description="Cooling coil valve signal measurement for AHU",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None, y(unit="1")) "AHU cooling coil valve signal measurement"
    annotation (Placement(transformation(extent={{0,-280},{20,-260}})));

  Buildings.Utilities.IO.SignalExchange.Read yHeaVal(
    description="AHU heating coil valve position measurement",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None, y(unit="1")) "AHU heating coil valve position measurement"
    annotation (Placement(transformation(extent={{-2,-310},{18,-290}})));

  Buildings.Utilities.IO.SignalExchange.Read yCooVal(
    description="AHU cooling coil valve position measurement",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None, y(unit="1"))
    "AHU cooling coil valve position measurement"
    annotation (Placement(transformation(extent={{-2,-340},{18,-320}})));

  Modelica.Blocks.Interfaces.RealInput yHeaVal_in
    "AHU heating coil valve position measurement"
    annotation (Placement(transformation(extent={{-142,-320},{-102,-280}})));
  Modelica.Blocks.Interfaces.RealInput yCooVal_in
    "AHU cooling coil valve position measurement"
    annotation (Placement(transformation(extent={{-142,-350},{-102,-310}})));
  Buildings.Utilities.IO.SignalExchange.Read TSup_set(
    description="Supply air temperature setpoint measurement for AHU",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="K")) "Supply air temperature setpoint measurement"
    annotation (Placement(transformation(extent={{-4,250},{16,270}})));

  Modelica.Blocks.Interfaces.RealInput TSup_set_in
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-144,240},{-104,280}})));
  Modelica.Blocks.Interfaces.BooleanInput occ_in "Occupancy status "
    annotation (Placement(transformation(extent={{-146,274},{-106,314}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal
    annotation (Placement(transformation(extent={{-68,276},{-48,296}})));
  Buildings.Utilities.IO.SignalExchange.Read occ(
    description="Occupancy status (1 occupied, 0 unoccupied)",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None, y(unit="1")) "Occupancy status (1 occupied, 0 unoccupied)"
    annotation (Placement(transformation(extent={{-2,278},{18,298}})));
  Buildings.Utilities.IO.SignalExchange.Read yOA(
    description="AHU cooling coil valve position measurement",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,
    y(unit="1")) "AHU OA damper position measurement"
    annotation (Placement(transformation(extent={{2,42},{22,62}})));

  Modelica.Blocks.Interfaces.RealInput yOA_in
    "AHU OA damper position measurement"
    annotation (Placement(transformation(extent={{-138,32},{-98,72}})));
  Buildings.Utilities.IO.SignalExchange.Read V_flow_OA(
    description="Supply outdoor airflow rate measurement for AHU",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,

    y(unit="m3/s")) "Supply outdoor airflow rate measurement"
    annotation (Placement(transformation(extent={{2,-370},{22,-350}})));
  Modelica.Blocks.Interfaces.RealInput V_flow_OA_in
    "Supply outdoor airflow rate measurement"
    annotation (Placement(transformation(extent={{-138,-380},{-98,-340}})));
equation
  connect(TSup.u, TSup_in)
    annotation (Line(points={{-2,200},{-120,200}}, color={0,0,127}));
  connect(TMix_in, TMix.u)
    annotation (Line(points={{-120,170},{-2,170}}, color={0,0,127}));
  connect(TRet_in, TRet.u)
    annotation (Line(points={{-120,140},{-2,140}}, color={0,0,127}));
  connect(V_flow_sup_in, V_flow_sup.u)
    annotation (Line(points={{-120,110},{-2,110}},
                                                 color={0,0,127}));
  connect(V_flow_ret_in, V_flow_ret.u)
    annotation (Line(points={{-120,80},{-2,80}}, color={0,0,127}));
  connect(dp_sup.u, dp_in)
    annotation (Line(points={{-2,20},{-120,20}},
                                               color={0,0,127}));
  connect(PFanSup_in, PFanSup.u) annotation (Line(
      points={{-120,-10},{-62,-10},{-2,-10}},
      color={0,0,127},
      smooth=Smooth.Bezier));
  connect(PPumCoo_in, PPumCoo.u) annotation (Line(
      points={{-120,-40},{-62,-40},{-2,-40}},
      color={0,0,127},
      smooth=Smooth.Bezier));
  connect(PPumHea_in, PPumHea.u) annotation (Line(
      points={{-120,-70},{-62,-70},{-2,-70}},
      color={0,0,127},
      smooth=Smooth.Bezier));
  connect(THeaCoiRet_in, THeaCoiRet.u)
    annotation (Line(points={{-120,-190},{-2,-190}}, color={0,0,127}));
  connect(THeaCoiSup_in, THeaCoiSup.u)
    annotation (Line(points={{-120,-160},{-2,-160}}, color={0,0,127}));
  connect(TCooCoiRet_in, TCooCoiRet.u)
    annotation (Line(points={{-120,-130},{-2,-130}}, color={0,0,127}));
  connect(TCooCoiSup_in, TCooCoiSup.u) annotation (Line(points={{-120,-100},{
          -62,-100},{-62,-100},{-2,-100}}, color={0,0,127}));
  connect(yHeaCoi_in, yHeaCoi.u)
    annotation (Line(points={{-120,-240},{-2,-240}}, color={0,0,127}));
  connect(yCooCoi_in, yCooCoi.u)
    annotation (Line(points={{-120,-270},{-2,-270}}, color={0,0,127}));
  connect(yHeaVal_in, yHeaVal.u)
    annotation (Line(points={{-122,-300},{-4,-300}}, color={0,0,127}));
  connect(yCooVal_in, yCooVal.u)
    annotation (Line(points={{-122,-330},{-4,-330}}, color={0,0,127}));
  connect(TSup_set.u, TSup_set_in)
    annotation (Line(points={{-6,260},{-124,260}}, color={0,0,127}));
  connect(occ_in, booleanToReal.u) annotation (Line(points={{-126,294},{-98,294},
          {-98,286},{-70,286}}, color={255,0,255}));
  connect(occ.u, booleanToReal.y) annotation (Line(points={{-4,288},{-40,288},{-40,
          286},{-47,286}}, color={0,0,127}));
  connect(yOA_in, yOA.u)
    annotation (Line(points={{-118,52},{0,52}}, color={0,0,127}));
  connect(V_flow_OA_in, V_flow_OA.u)
    annotation (Line(points={{-118,-360},{0,-360}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -360},{100,300}}), graphics={Rectangle(
          extent={{-100,238},{100,-360}},
          lineColor={0,0,0},
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid), Text(
          extent={{-56,274},{52,240}},
          lineColor={28,108,200},
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Text(
          extent={{-32,24},{34,-16}},
          lineColor={0,0,0},
          textString="Read
AHU")}),                         Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-100,-360},{100,300}})));
end ReadAhu;
