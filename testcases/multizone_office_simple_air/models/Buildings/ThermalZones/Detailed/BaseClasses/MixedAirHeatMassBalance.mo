within Buildings.ThermalZones.Detailed.BaseClasses;
model MixedAirHeatMassBalance
  "Heat and mass balance of the air, assuming completely mixed air"
  extends Buildings.ThermalZones.Detailed.BaseClasses.PartialAirHeatMassBalance;
  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations;

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal(min=0)
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));

  parameter Buildings.HeatTransfer.Types.InteriorConvection conMod
    "Convective heat transfer model for opaque constructions"
    annotation (Dialog(group="Convective heat transfer"));
  parameter Modelica.SIunits.CoefficientOfHeatTransfer hFixed
    "Constant convection coefficient for opaque constructions"
    annotation (Dialog(group="Convective heat transfer",
                       enable=(conMod == Buildings.HeatTransfer.Types.InteriorConvection.Fixed)));

  parameter Boolean use_C_flow
    "Set to true to enable input connector for trace substance"
    annotation (Dialog(group="Ports"));

  parameter Real frad(min=0, max=1) = 0.2
    "Fraction of irradiated space";

  parameter Real Eavg(min=0, max=1) = 50e-6
    "Fraction of irradiated space";

  parameter Real krad(min=0) = 2.93e3
    "Fraction of irradiated space";

  Modelica.Blocks.Interfaces.RealInput C_flow[Medium.nC] if use_C_flow
    "Trace substance mass flow rate added to the room air. Enable if use_C_flow = true"
    annotation (Placement(transformation(extent={{-280,-240},{-240,-200}})));

  // Mixing volume
  Fluid.MixingVolumes.MixingVolumeMoistAir vol(
    redeclare package Medium = Medium,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final V=V,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final mSenFac=mSenFac,
    final m_flow_nominal = m_flow_nominal,
    final prescribedHeatFlowRate = true,
    final nPorts=nPorts,
    m_flow_small=1E-4*abs(m_flow_nominal),
    allowFlowReversal=true,
    final use_C_flow=use_C_flow)  "Room air volume"
    annotation (Placement(transformation(extent={{10,-210},{-10,-190}})));

  // Convection models
  HeatTransfer.Convection.Interior convConExt[NConExt](
    final A=AConExt,
    final til = datConExt.til,
    each conMod=conMod,
    each hFixed=hFixed,
    each final homotopyInitialization=homotopyInitialization)
    if haveConExt "Convective heat transfer"
    annotation (Placement(transformation(extent={{120,210},{100,230}})));

  HeatTransfer.Convection.Interior convConExtWin[NConExtWin](
    final A=AConExtWinOpa,
    final til = datConExtWin.til,
    each conMod=conMod,
    each hFixed=hFixed,
    each final homotopyInitialization=homotopyInitialization)
    if haveConExtWin "Convective heat transfer"
    annotation (Placement(transformation(extent={{120,170},{100,190}})));

  HeatTransfer.Windows.InteriorHeatTransferConvective convConWin[NConExtWin](
    final fFra=datConExtWin.fFra,
    final haveExteriorShade={datConExtWin[i].glaSys.haveExteriorShade for i in 1:NConExtWin},
    final haveInteriorShade={datConExtWin[i].glaSys.haveInteriorShade for i in 1:NConExtWin},
    final til=datConExtWin.til,
    each conMod=conMod,
    each hFixed=hFixed,
    final A=AConExtWinGla + AConExtWinFra)
    if haveConExtWin "Model for convective heat transfer at window"
    annotation (Placement(transformation(extent={{98,110},{118,130}})));

  HeatTransfer.Convection.Interior convConPar_a[nConPar](
    final A=AConPar,
    final til=Modelica.Constants.pi .- datConPar.til,
    each conMod=conMod,
    each hFixed=hFixed,
    each final homotopyInitialization=homotopyInitialization)
    if haveConPar "Convective heat transfer"
    annotation (Placement(transformation(extent={{120,-70},{100,-50}})));

  HeatTransfer.Convection.Interior convConPar_b[nConPar](
    final A=AConPar,
    final til = datConPar.til,
    each conMod=conMod,
    each hFixed=hFixed,
    each final homotopyInitialization=homotopyInitialization)
    if haveConPar "Convective heat transfer"
    annotation (Placement(transformation(extent={{120,-110},{100,-90}})));

  HeatTransfer.Convection.Interior convConBou[nConBou](
    final A=AConBou,
    final til = datConBou.til,
    each conMod=conMod,
    each hFixed=hFixed,
    each final homotopyInitialization=homotopyInitialization)
    if haveConBou "Convective heat transfer"
    annotation (Placement(transformation(extent={{120,-170},{100,-150}})));

  HeatTransfer.Convection.Interior convSurBou[nSurBou](
    final A=ASurBou,
    final til = surBou.til,
    each conMod=conMod,
    each hFixed=hFixed,
    each final homotopyInitialization=homotopyInitialization)
    if haveSurBou "Convective heat transfer"
    annotation (Placement(transformation(extent={{122,-230},{102,-210}})));

  // Latent and convective sensible heat gains
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-104,-58},{-84,-38}})));
  Modelica.Blocks.Sources.RealExpression covConc(y=vol.C[2])
    annotation (Placement(transformation(extent={{-212,-52},{-192,-32}})));
  Modelica.Blocks.Math.Add add1
    annotation (Placement(transformation(extent={{-40,-72},{-20,-52}})));
  Modelica.Blocks.Continuous.Integrator E_GUV(use_reset=false)
    annotation (Placement(transformation(extent={{-136,122},{-116,142}})));
  Modelica.Blocks.Sources.Constant GUV_P(k=120) "Power of GUV"
    annotation (Placement(transformation(extent={{-182,122},{-162,142}})));
  GUV gUV(frad=frad, V=V)
    annotation (Placement(transformation(extent={{-132,32},{-112,52}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant
    annotation (Placement(transformation(extent={{-200,32},{-180,52}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(period=3600)
    annotation (Placement(transformation(extent={{-176,64},{-156,84}})));
  PAC pAC annotation (Placement(transformation(extent={{-102,10},{-82,30}})));
  Modelica.Blocks.Math.Add add2
    annotation (Placement(transformation(extent={{-60,18},{-40,38}})));
protected
  constant Modelica.SIunits.SpecificEnergy h_fg=
    Buildings.Media.Air.enthalpyOfCondensingGas(273.15+37) "Latent heat of water vapor";

  Modelica.Blocks.Math.Gain mWat_flow(
    final k(unit="kg/J")=1/h_fg,
    u(final unit="W"),
    y(final unit="kg/s")) "Water flow rate due to latent heat gain"
    annotation (Placement(transformation(extent={{-220,-170},{-200,-150}})));

  HeatTransfer.Sources.PrescribedHeatFlow conQCon_flow
    "Converter for convective heat flow rate"
    annotation (Placement(transformation(extent={{-220,-110},{-200,-90}})));

  HeatTransfer.Sources.PrescribedHeatFlow conQLat_flow
    "Converter for latent heat flow rate"
    annotation (Placement(transformation(extent={{-220,-90},{-200,-70}})));

  // Thermal collectors
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theConConExt(final m=nConExt)
    if haveConExt
    "Thermal collector to convert from vector to scalar connector"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={48,220})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theConConExtWin(final m=nConExtWin)
    if haveConExtWin
    "Thermal collector to convert from vector to scalar connector"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={48,180})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theConConWin(final m=nConExtWin)
    if haveConExtWin
    "Thermal collector to convert from vector to scalar connector"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,120})));

  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theConConPar_a(final m=nConPar)
    if haveConPar
    "Thermal collector to convert from vector to scalar connector"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={52,-60})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theConConPar_b(final m=nConPar)
    if haveConPar
    "Thermal collector to convert from vector to scalar connector"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,-100})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theConConBou(final m=nConBou)
    if haveConBou
    "Thermal collector to convert from vector to scalar connector"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,-160})));
  Modelica.Thermal.HeatTransfer.Components.ThermalCollector theConSurBou(final m=nSurBou)
    if haveSurBou
    "Thermal collector to convert from vector to scalar connector"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={52,-220})));
  Modelica.Blocks.Math.Gain kDecay(final k=-0.48*1.2*V/3600) "Viral decay rate"
    annotation (Placement(transformation(extent={{-158,-52},{-138,-32}})));
initial equation
  assert(homotopyInitialization, "In " + getInstanceName() +
    ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
    level = AssertionLevel.warning);

equation
  connect(convConPar_a.fluid,theConConPar_a.port_a) annotation (Line(
      points={{100,-60},{62,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConPar_b.fluid,theConConPar_b.port_a) annotation (Line(
      points={{100,-100},{60,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConBou.fluid,theConConBou.port_a) annotation (Line(
      points={{100,-160},{60,-160}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convSurBou.fluid,theConSurBou.port_a) annotation (Line(
      points={{102,-220},{62,-220}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theConConPar_a.port_b,vol.heatPort) annotation (Line(
      points={{42,-60},{20,-60},{20,-200},{10,-200}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theConConPar_b.port_b,vol.heatPort) annotation (Line(
      points={{40,-100},{20,-100},{20,-200},{10,-200}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theConConBou.port_b,vol.heatPort) annotation (Line(
      points={{40,-160},{20,-160},{20,-200},{10,-200}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theConSurBou.port_b,vol.heatPort) annotation (Line(
      points={{42,-220},{20,-220},{20,-200},{10,-200}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conExtWinFra,convConWin.frame) annotation (Line(
      points={{242,4.44089e-16},{160,4.44089e-16},{160,100},{115,100},{115,110}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConExt.solid, conExt) annotation (Line(
      points={{120,220},{240,220}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConExt.fluid,theConConExt.port_a) annotation (Line(
      points={{100,220},{58,220}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theConConExt.port_b,vol.heatPort) annotation (Line(
      points={{38,220},{20,220},{20,-200},{10,-200}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theConConExtWin.port_b,vol.heatPort) annotation (Line(
      points={{38,180},{20,180},{20,-200},{10,-200}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConExtWin.fluid,theConConExtWin.port_a) annotation (Line(
      points={{100,180},{58,180}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConExtWin.solid, conExtWin) annotation (Line(
      points={{120,180},{240,180}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theConConWin.port_b,vol.heatPort) annotation (Line(
      points={{40,120},{20,120},{20,-200},{10,-200}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConWin.air,theConConWin.port_a) annotation (Line(
      points={{98,120},{60,120}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConWin.glaSha, glaSha) annotation (Line(
      points={{118,118},{166,118},{166,80},{240,80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConWin.glaUns, glaUns) annotation (Line(
      points={{118,122},{180,122},{180,120},{240,120}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConPar_a.solid, conPar_a) annotation (Line(
      points={{120,-60},{242,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConPar_b.solid, conPar_b) annotation (Line(
      points={{120,-100},{242,-100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convConBou.solid, conBou) annotation (Line(
      points={{120,-160},{242,-160}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(convSurBou.solid, conSurBou) annotation (Line(
      points={{122,-220},{241,-220}},
      color={191,0,0},
      smooth=Smooth.None));
  for i in 1:nPorts loop
    connect(vol.ports[i], ports[i]) annotation (Line(
      points={{0,-210},{0,-238}},
      color={0,127,255},
      smooth=Smooth.None));
  end for;
  connect(heaPorAir, vol.heatPort) annotation (Line(
      points={{-240,0},{20,0},{20,-200},{10,-200}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(uSha, convConWin.uSha) annotation (Line(
      points={{-260,200},{0,200},{0,150},{82,150},{82,128},{97.2,128}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(convConWin.QRadAbs_flow, QRadAbs_flow) annotation (Line(
      points={{102,109},{102,90},{-260,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(convConWin.TSha, TSha) annotation (Line(
      points={{108,109},{108,60},{-250,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conQCon_flow.port, vol.heatPort) annotation (Line(points={{-200,-100},
          {-118,-100},{20,-100},{20,-200},{10,-200}},           color={191,0,0}));
  connect(QCon_flow, conQCon_flow.Q_flow) annotation (Line(points={{-260,-100},{
          -240,-100},{-220,-100}}, color={0,0,127}));
  connect(QLat_flow, mWat_flow.u)
    annotation (Line(points={{-260,-160},{-222,-160}}, color={0,0,127}));
  connect(mWat_flow.y, vol.mWat_flow) annotation (Line(points={{-199,-160},{-168,
          -160},{-168,-212},{-30,-212},{-30,-180},{16,-180},{16,-192},{12,-192}},
        color={0,0,127}));
  connect(conQLat_flow.Q_flow, QLat_flow) annotation (Line(points={{-220,-80},{-230,
          -80},{-230,-160},{-260,-160}}, color={0,0,127}));
  connect(conQLat_flow.port, vol.heatPort) annotation (Line(points={{-200,-80},{
          -96,-80},{20,-80},{20,-200},{10,-200}}, color={191,0,0}));
  connect(C_flow[1], vol.C_flow[1]) annotation (Line(points={{-260,-220},{18,-220},
          {18,-206},{12,-206}}, color={0,0,127}));
  connect(covConc.y, kDecay.u)
    annotation (Line(points={{-191,-42},{-160,-42}}, color={0,0,127}));
  connect(kDecay.y, add.u1)
    annotation (Line(points={{-137,-42},{-106,-42}}, color={0,0,127}));
  connect(C_flow[2], add.u2) annotation (Line(points={{-260,-220},{-108,-220},{-108,
          -64},{-114,-64},{-114,-54},{-106,-54}}, color={0,0,127}));
  connect(add.y, add1.u2) annotation (Line(points={{-83,-48},{-52,-48},{-52,-68},
          {-42,-68}}, color={0,0,127}));
  connect(add1.y, vol.C_flow[2]) annotation (Line(points={{-19,-62},{-10,-62},{-10,
          -184},{-20,-184},{-20,-220},{18,-220},{18,-206},{12,-206}}, color={0,0,
          127}));
  connect(GUV_P.y, E_GUV.u)
    annotation (Line(points={{-161,132},{-138,132}}, color={0,0,127}));
  connect(covConc.y, gUV.C) annotation (Line(points={{-191,-42},{-168,-42},{
          -168,24},{-142,24},{-142,46},{-134,46}}, color={0,0,127}));
  connect(booleanConstant.y, gUV.u) annotation (Line(points={{-179,42},{-144,42},
          {-144,40},{-134,40}}, color={255,0,255}));
  connect(booleanConstant.y, pAC.u) annotation (Line(points={{-179,42},{-144,42},
          {-144,18},{-104,18}}, color={255,0,255}));
  connect(gUV.yC_flow, add2.u1) annotation (Line(points={{-111,46},{-70,46},{
          -70,34},{-62,34}}, color={0,0,127}));
  connect(pAC.yC_flow, add2.u2) annotation (Line(points={{-81,24},{-70,24},{-70,
          22},{-62,22}}, color={0,0,127}));
  connect(covConc.y, pAC.C) annotation (Line(points={{-191,-42},{-168,-42},{
          -168,24},{-104,24}}, color={0,0,127}));
  connect(add2.y, add1.u1) annotation (Line(points={{-39,28},{-32,28},{-32,-46},
          {-50,-46},{-50,-56},{-42,-56}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-240,-240},{240,
            240}})),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-240,-240},{240,240}}),
                    graphics={
          Rectangle(
          extent={{-144,184},{148,-200}},
          pattern=LinePattern.None,
          lineColor={0,0,0},
          fillColor={170,213,255},
          fillPattern=FillPattern.Sphere),
        Text(
          extent={{-228,-244},{-178,-194}},
          lineColor={0,0,127},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          textString="C_flow",
          visible = use_C_flow)}),
    Documentation(info="<html>
<p>
This model computes the heat and mass balance of the air.
The model assumes a completely mixed air volume.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 14, 2020, by Michael Wetter:<br/>
Changed <code>homotopyInitialization</code> to a constant.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1341\">IBPSA, #1341</a>.
</li>
<li>
April 8, 2019, by Michael Wetter:<br/>
Propagated parameter <code>mSenFac</code>.<br/>
This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1405\">Buildings #1405</a>.
</li>
<li>
December 14, 2018, by Michael Wetter:<br/>
Replaced call to <code>Medium.enthalpyOfCondensingGas</code> with
<code>Buildings.Media.Air.enthalpyOfCondensingGas</code>.<br/>
This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1285\">Buildings #1285</a>.
</li>
<li>
April 12, 2017, by Michael Wetter:<br/>
Removed temperature connection that is no longer needed.<br/>
This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/704\">Buildings #704</a>.
</li>
<li>
May 2, 2016, by Michael Wetter:<br/>
Refactored implementation of latent heat gain.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/515\">issue 515</a>.
</li>
<li>
March 2, 2015, by Michael Wetter:<br/>
Refactored model to allow a temperature dependent convective heat transfer
on the room side.
This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/52\">52</a>.
</li>
<li>
July 17, 2013, by Michael Wetter:<br/>
Separated the model into a partial base class and a model that uses the mixed air assumption.
</li>
<li>
July 12, 2013, by Michael Wetter:<br/>
First implementation to facilitate the implementation of non-uniform room air models.
</li>
</ul>
</html>"));
end MixedAirHeatMassBalance;
