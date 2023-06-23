within MultiZoneOfficeSimpleAir.BaseClasses;
model ReadWatSys "Collection of Water System measurements for BOPTEST"
  Buildings.Utilities.IO.SignalExchange.Read dp(
    description="Differential pressure of chilled/hot water measurement",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,

    y(unit="K")) "Differential pressure of chilled/hot water measurement"
    annotation (Placement(transformation(extent={{-10,52},{10,72}})));
  Buildings.Utilities.IO.SignalExchange.Read TW(
    description="Chilled water temperature measurement",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None,

    y(unit="K")) "Chilled/hot water temperature measurement"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Modelica.Blocks.Interfaces.RealInput dp_in
    "Differential pressure of chilled/hot water measurement"
    annotation (Placement(transformation(extent={{-150,42},{-110,82}})));
  Modelica.Blocks.Interfaces.RealInput TW_in "CHW/HW temperature measurement"
    annotation (Placement(transformation(extent={{-150,-80},{-110,-40}})));

equation
  connect(dp.u, dp_in)
    annotation (Line(points={{-12,62},{-130,62}}, color={0,0,127}));
  connect(TW_in, TW.u)
    annotation (Line(points={{-130,-60},{-12,-60}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,120}}), graphics={Rectangle(
          extent={{-100,120},{102,-102}},
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
Wat")}),                         Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-100,-100},{100,120}})));
end ReadWatSys;
