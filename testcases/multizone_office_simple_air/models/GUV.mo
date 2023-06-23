within ;
model GUV

  parameter Real frad(min=0, max=1) = 0.2
    "Fraction of irradiated space";

  parameter Real Eavg(min=0, max=1) = 50e-6
    "Effluence rate";

  parameter Real krad(min=0) = 2.93e3
    "Inactivation constant";

  parameter Real kpow(min=0) = 120
    "Rated power";

  parameter Real V(min=0) = 120
    "Zone volume";


  Modelica.Blocks.Interfaces.RealInput C "Zone concentration"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealOutput yC_flow "Concentration outflow"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.BooleanInput u "on/off"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
  Modelica.Blocks.Interfaces.RealOutput yP_GUV "Power output"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput yE_GUV "Energy output"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Modelica.Blocks.Continuous.Integrator E_GUV(use_reset=false)
    annotation (Placement(transformation(extent={{58,-50},{78,-30}})));
  Modelica.Blocks.Math.MultiProduct multiProduct(nu=2)
    annotation (Placement(transformation(extent={{-82,48},{-70,60}})));
protected
  Modelica.Blocks.Math.Gain pow(final k=kpow)
                                             "power of GUV"
    annotation (Placement(transformation(extent={{-6,-30},{14,-10}})));
  Modelica.Blocks.Math.Gain UV_calc(final k=-1.2*V*frad*Eavg*krad)
    "death of virus from UV"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
equation


  connect(u, booleanToReal.u)
    annotation (Line(points={{-120,-20},{-62,-20}}, color={255,0,255}));
  connect(booleanToReal.y, pow.u)
    annotation (Line(points={{-39,-20},{-8,-20}}, color={0,0,127}));
  connect(pow.y, yP_GUV) annotation (Line(points={{15,-20},{96,-20},{96,0},{110,
          0}}, color={0,0,127}));
  connect(pow.y, E_GUV.u) annotation (Line(points={{15,-20},{50,-20},{50,-40},{56,
          -40}}, color={0,0,127}));
  connect(E_GUV.y, yE_GUV)
    annotation (Line(points={{79,-40},{110,-40}}, color={0,0,127}));
  connect(C, multiProduct.u[1]) annotation (Line(points={{-120,40},{-88,40},{-88,
          56.1},{-82,56.1}}, color={0,0,127}));
  connect(booleanToReal.y, multiProduct.u[2]) annotation (Line(points={{-39,-20},
          {-34,-20},{-34,26},{-88,26},{-88,51.9},{-82,51.9}}, color={0,0,127}));
  connect(UV_calc.y, yC_flow)
    annotation (Line(points={{61,40},{110,40}}, color={0,0,127}));
  connect(multiProduct.y, UV_calc.u) annotation (Line(points={{-68.98,54},{30,
          54},{30,40},{38,40}}, color={0,0,127}));
  annotation (uses(Modelica(version="3.2.3")), Icon(graphics={
        Polygon(
          points={{-80,60},{-80,-62},{-60,-62},{-60,60},{-80,60}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Line(points={{-56,50},{22,50}}, color={28,108,200}),
        Line(points={{-56,28},{22,28}}, color={28,108,200}),
        Line(points={{-56,10},{22,10}}, color={28,108,200}),
        Line(points={{-56,-30},{22,-30}}, color={28,108,200}),
        Line(points={{-56,-50},{22,-50}}, color={28,108,200}),
        Line(points={{-56,-10},{22,-10}}, color={28,108,200})}));
end GUV;
