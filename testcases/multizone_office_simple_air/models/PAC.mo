within ;
model PAC

  parameter Real eff(min=0, max=1) = 0.9997
    "Virus removal efficiency";

  parameter Integer nPACs(min=0) = 1
    "Number of PACs";

  parameter Real flowPAC(min=0) = 0.094
    "PAC flow rate";

  parameter Real kpow(min=0) = 120
    "Rated power";

  Modelica.Blocks.Interfaces.RealInput C "Zone concentration"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealOutput yC_flow "Concentration outflow"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.BooleanInput u "on/off"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
  Modelica.Blocks.Interfaces.RealOutput yP_PAC "Power output"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput yE_PAC "Energy output"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Math.BooleanToReal booleanToReal
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Modelica.Blocks.Continuous.Integrator E_PAC(use_reset=false)
    annotation (Placement(transformation(extent={{58,-50},{78,-30}})));
  Modelica.Blocks.Math.MultiProduct multiProduct(nu=2)
    annotation (Placement(transformation(extent={{-82,48},{-70,60}})));
protected
  Modelica.Blocks.Math.Gain pow(final k=kpow)
                                             "power of GUV"
    annotation (Placement(transformation(extent={{-6,-30},{14,-10}})));
  Modelica.Blocks.Math.Gain PAC_calc(final k=-1*flowPAC*eff*nPACs)
    "removal of virus from PAC"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
equation

  connect(u, booleanToReal.u)
    annotation (Line(points={{-120,-20},{-62,-20}}, color={255,0,255}));
  connect(booleanToReal.y, pow.u)
    annotation (Line(points={{-39,-20},{-8,-20}}, color={0,0,127}));
  connect(pow.y,yP_PAC)  annotation (Line(points={{15,-20},{96,-20},{96,0},{110,
          0}}, color={0,0,127}));
  connect(pow.y,E_PAC. u) annotation (Line(points={{15,-20},{50,-20},{50,-40},{56,
          -40}}, color={0,0,127}));
  connect(E_PAC.y,yE_PAC)
    annotation (Line(points={{79,-40},{110,-40}}, color={0,0,127}));
  connect(C, multiProduct.u[1]) annotation (Line(points={{-120,40},{-88,40},{-88,
          56.1},{-82,56.1}}, color={0,0,127}));
  connect(booleanToReal.y, multiProduct.u[2]) annotation (Line(points={{-39,-20},
          {-34,-20},{-34,26},{-88,26},{-88,51.9},{-82,51.9}}, color={0,0,127}));
  connect(PAC_calc.y, yC_flow)
    annotation (Line(points={{21,40},{110,40}}, color={0,0,127}));
  connect(multiProduct.y, PAC_calc.u) annotation (Line(points={{-68.98,54},{-10,
          54},{-10,40},{-2,40}}, color={0,0,127}));
  annotation (uses(Modelica(version="3.2.3")), Icon(graphics={
        Ellipse(
          extent={{-30,68},{32,50}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.None),
        Ellipse(
          extent={{-30,-42},{32,-60}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.None),
        Line(points={{-30,60},{-30,-50}}, color={28,108,200}),
        Line(points={{32,60},{32,-50}}, color={28,108,200})}));
end PAC;
