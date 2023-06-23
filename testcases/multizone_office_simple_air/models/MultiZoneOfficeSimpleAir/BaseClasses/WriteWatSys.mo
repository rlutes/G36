within MultiZoneOfficeSimpleAir.BaseClasses;
model WriteWatSys "Collection of Water System overwrite points for BOPTEST"
  Modelica.Blocks.Interfaces.RealInput TW_set_in
    "Supply chilled/hot water setpoint"
    annotation (Placement(transformation(extent={{-150,38},{-110,78}})));
  Modelica.Blocks.Interfaces.RealInput dp_set_in
    "differential pressure setpoint"
    annotation (Placement(transformation(extent={{-150,-62},{-110,-22}})));
  Buildings.Utilities.IO.SignalExchange.Overwrite TW_set(description=
        "Chilled/hot water supply setpoint", u(
      unit="K")) "Chilled/hot water supply setpoint"
    annotation (Placement(transformation(extent={{-10,48},{10,68}})));
  Buildings.Utilities.IO.SignalExchange.Overwrite dp_set(description=
        "Differential pressure setpoint", u(
      unit="Pa")) "Differential pressure setpoint"
    annotation (Placement(transformation(extent={{-10,-52},{10,-32}})));
  Modelica.Blocks.Interfaces.RealOutput TW_set_out
    "Chilled/hot water supply setpoint"
    annotation (Placement(transformation(extent={{90,48},{110,68}})));
  Modelica.Blocks.Interfaces.RealOutput dp_set_out
    "differential pressure setpoint"
    annotation (Placement(transformation(extent={{90,-52},{110,-32}})));
equation
  connect(TW_set_in, TW_set.u) annotation (Line(
      points={{-130,58},{-12,58}},
      color={0,0,127},
      smooth=Smooth.Bezier));
  connect(dp_set_in, dp_set.u) annotation (Line(
      points={{-130,-42},{-71,-42},{-12,-42}},
      color={0,0,127},
      smooth=Smooth.Bezier));
  connect(TW_set.y, TW_set_out) annotation (Line(
      points={{11,58},{100,58}},
      color={0,0,127},
      smooth=Smooth.Bezier));
  connect(dp_set.y, dp_set_out) annotation (Line(
      points={{11,-42},{100,-42}},
      color={0,0,127},
      smooth=Smooth.Bezier));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,120}}),                                  graphics={
          Rectangle(
          extent={{-100,120},{102,-100}},
          lineColor={0,0,0},
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid), Text(
          extent={{-56,174},{52,140}},
          lineColor={28,108,200},
          fillColor={255,170,170},
          fillPattern=FillPattern.Solid,
          textString="%name"),
        Text(
          extent={{-36,22},{30,-18}},
          lineColor={0,0,0},
          textString="Write
Wat")}),                         Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,120}})));
end WriteWatSys;
