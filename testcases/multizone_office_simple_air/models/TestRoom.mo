within ;
model TestRoom

  parameter Real hRoo = 10;
  parameter Real hWin = 5;
  parameter Real winWalRat = 0.3;
  package MediumA = Buildings.Media.Air(extraPropertiesNames={"CO2", "COVID"}) "Medium model for air";
  Modelica.Blocks.Sources.Constant const(k=1.2*3e5/3600)
    annotation (Placement(transformation(extent={{-74,8},{-54,28}})));
  Buildings.Fluid.Sources.MassFlowSource_T boundary(
    redeclare package Medium = MediumA,
    m_flow=500*1.2/3600,
    nPorts=1)
    annotation (Placement(transformation(extent={{-80,-44},{-60,-24}})));
  Buildings.Fluid.Sources.Outside out(redeclare package Medium = MediumA,
                             nPorts=1)
    annotation (Placement(transformation(extent={{-42,-34},{-22,-14}})));
  Buildings.ThermalZones.Detailed.MixedAir sou(
    use_C_flow=true,
    frad=0,
    C_start=fill(400e-6*Modelica.Media.IdealGases.Common.SingleGasesData.CO2.MM/
        Modelica.Media.IdealGases.Common.SingleGasesData.Air.MM, MediumA.nC),
    redeclare package Medium = MediumA,
    lat=0,
    AFlo=50,
    hRoo=10,
    nConExt=0,
    nConExtWin=1,
    datConExtWin(
      layers={conExtWal},
      A={49.91*hRoo},
      glaSys={glaSys},
      wWin={winWalRat/hWin*49.91*hRoo},
      each hWin=hWin,
      fFra={0.1},
      til={Buildings.Types.Tilt.Wall},
      azi={Buildings.Types.Azimuth.S}),
    nConPar=2,
    datConPar(
      layers={conFlo,conFur},
      A={50,414.68},
      til={Buildings.Types.Tilt.Floor,Buildings.Types.Tilt.Wall}),
    nConBou=3,
    datConBou(
      layers={conIntWal,conIntWal,conIntWal},
      A={6.47,40.76,6.47}*hRoo,
      til={Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall}),
    nSurBou=0,
    nPorts=2,
    intConMod=Buildings.HeatTransfer.Types.InteriorConvection.Temperature,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final sampleModel=false) "South zone"
    annotation (Placement(transformation(extent={{-20,-4},{20,36}})));

  parameter Buildings.HeatTransfer.Data.Solids.Plywood
                                             matFur(x=0.15, nStaRef=5)
    "Material for furniture"
    annotation (Placement(transformation(extent={{36,74},{56,94}})));
  parameter Buildings.HeatTransfer.Data.Resistances.Carpet
                                                 matCar "Carpet"
    annotation (Placement(transformation(extent={{76,74},{96,94}})));
  parameter Buildings.HeatTransfer.Data.Solids.Concrete
                                              matCon(
    x=0.1,
    k=1.311,
    c=836,
    nStaRef=5) "Concrete"
    annotation (Placement(transformation(extent={{36,44},{56,64}})));
  parameter Buildings.HeatTransfer.Data.Solids.Plywood
                                             matWoo(
    x=0.01,
    k=0.11,
    d=544,
    nStaRef=1) "Wood for exterior construction"
    annotation (Placement(transformation(extent={{36,14},{56,34}})));
  parameter Buildings.HeatTransfer.Data.Solids.Generic
                                             matIns(
    x=0.087,
    k=0.049,
    c=836.8,
    d=265,
    nStaRef=5) "Steelframe construction with insulation"
    annotation (Placement(transformation(extent={{76,14},{96,34}})));
  parameter Buildings.HeatTransfer.Data.Solids.GypsumBoard
                                                 matGyp(
    x=0.0127,
    k=0.16,
    c=830,
    d=784,
    nStaRef=2) "Gypsum board"
    annotation (Placement(transformation(extent={{34,-14},{54,6}})));
  parameter Buildings.HeatTransfer.Data.Solids.GypsumBoard
                                                 matGyp2(
    x=0.025,
    k=0.16,
    c=830,
    d=784,
    nStaRef=2) "Gypsum board"
    annotation (Placement(transformation(extent={{74,-14},{94,6}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic
                                                          conExtWal(final nLay=3,
      material={matWoo,matIns,matGyp}) "Exterior construction"
    annotation (Placement(transformation(extent={{72,-44},{92,-24}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic
                                                          conIntWal(final nLay=1,
      material={matGyp2}) "Interior wall construction"
    annotation (Placement(transformation(extent={{70,-76},{90,-56}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic
                                                          conFlo(final nLay=1,
      material={matCon})
                 "Floor construction (opa_a is carpet)"
    annotation (Placement(transformation(extent={{34,-76},{54,-56}})));
  parameter Buildings.HeatTransfer.Data.OpaqueConstructions.Generic
                                                          conFur(final nLay=1,
      material={matFur})
                 "Construction for internal mass of furniture"
    annotation (Placement(transformation(extent={{12,-76},{32,-56}})));
  parameter Buildings.HeatTransfer.Data.Solids.Plywood
                                             matCarTra(
    k=0.11,
    d=544,
    nStaRef=1,
    x=0.215/0.11) "Wood for floor"
    annotation (Placement(transformation(extent={{-2,74},{18,94}})));
  parameter Buildings.HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear
                                                                   glaSys(
    UFra=2,
    shade=Buildings.HeatTransfer.Data.Shades.Gray(),
    haveInteriorShade=false,
    haveExteriorShade=false) "Data record for the glazing system"
    annotation (Placement(transformation(extent={{34,-48},{54,-28}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
      computeWetBulbTemperature=true, filNam=
        Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
                                       "Weather data reader"
    annotation (Placement(transformation(extent={{-72,-82},{-52,-62}})));
  Modelica.Blocks.Math.MatrixGain gai(K=20*[0.4; 0.4; 0.2])
    "Matrix gain to split up heat gain in radiant, convective and latent gain"
    annotation (Placement(transformation(extent={{-62,34},{-42,54}})));
  Modelica.Blocks.Sources.CombiTimeTable intGaiFra(
    table=[0,0.05; 8,0.05; 9,0.9; 12,0.9; 12,0.8; 13,0.8; 13,1; 17,1; 19,0.1;
        24,0.05],
    timeScale=3600,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Fraction of internal heat gain"
    annotation (Placement(transformation(extent={{-98,38},{-78,58}})));
equation
  connect(const.y, sou.C_flow[2])
    annotation (Line(points={{-53,18},{-21.6,18.8}}, color={0,0,127}));
  connect(boundary.ports[1], sou.ports[1]) annotation (Line(points={{-60,-34},{-50,
          -34},{-50,4},{-15,4}}, color={0,127,255}));
  connect(out.ports[1], sou.ports[2]) annotation (Line(points={{-22,-24},{-14,-24},
          {-14,-8},{-24,-8},{-24,8},{-15,8}}, color={0,127,255}));
  connect(weaDat.weaBus, out.weaBus) annotation (Line(
      points={{-52,-72},{-46,-72},{-46,-28},{-48,-28},{-48,-23.8},{-42,-23.8}},

      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, sou.weaBus) annotation (Line(
      points={{-52,-72},{-46,-72},{-46,-38},{24,-38},{24,33.9},{17.9,33.9}},
      color={255,204,51},
      thickness=0.5));
  connect(intGaiFra.y,gai. u) annotation (Line(
      points={{-77,48},{-72,48},{-72,44},{-64,44}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(gai.y, sou.qGai_flow) annotation (Line(points={{-41,44},{-26,44},{-26,
          24},{-21.6,24}}, color={0,0,127}));
  connect(const.y, sou.C_flow[1])
    annotation (Line(points={{-53,18},{-21.6,18.8}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    uses(Buildings(version="8.0.0"), Modelica(version="3.2.3")),
    experiment(
      StopTime=36000,
      Interval=1,
      Tolerance=1e-07,
      __Dymola_Algorithm="Cvode"));
end TestRoom;
