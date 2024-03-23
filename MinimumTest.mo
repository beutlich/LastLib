package MinimumTest
  extends Modelica.Icons.Package;

  block Minimum "Calculate the minimum of a signal"
    extends Modelica.Blocks.Interfaces.SISO;
    parameter Real y_start=Modelica.Constants.inf "Initialization of minimum";
    replaceable model Last = LastLib.LastBase(y_start=y_start) "Last FMU"
      annotation(choices(
       choice(redeclare model Last = LastLib.Last_dymola_linux "Last for Dymola (Linux)"),
       choice(redeclare model Last = LastLib.Last_dymola_windows "Last for Dymola (Windows)"),
       choice(redeclare model Last = LastLib.Last_omc "Last for OpenModelica (C runtime)"),
       choice(redeclare model Last = LastLib.Last_simx "Last for SimulationX")));
    Last last(y_start=y_start) "Last FMU" annotation(Placement(transformation(extent={{30,30},{10,50}})));
    Modelica.Blocks.Math.Min min annotation(Placement(transformation(extent={{10,-10},{30,10}})));
  equation
    connect(u, min.u2) annotation(Line(points={{-120,0},{0,0},{0,-6},{8,-6}}, color={0,0,127}));
    connect(min.y, y) annotation(Line(points={{31,0},{110,0}}, color={0,0,127}));
    connect(last.y, min.u1) annotation(Line(points={{9,40},{0,40},{0,6},{8,6}}, color={0,0,127}));
    connect(last.u, min.y) annotation(Line(points={{32,40},{40,40},{40,0},{31,0}}, color={0,0,127}));
    annotation(defaultComponentName="min", preferredView="diagram",
      Icon(graphics={
        Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,0},{68,0}}, color={192,192,192}),
        Polygon(
          points={{90,0},{68,8},{68,-8},{90,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,0},{-75.2,32.3},{-72,50.3},{-68.7,64.5},{-65.5,74.2},{-62.3,79.3},{-59.1,79.6},{-55.9,75.3},{-52.7,67.1},{-48.6,52.2},{-43,25.8},{-35,-13.9},{-30.2,-33.7},{-26.1,-45.9},{-22.1,-53.2},{-18,-56},{-14.1,-52.5},{-10.1,-45.3},{-5.23,-32.1},{8.44,13.7},{13.3,26.4},{18.1,34.8},{22.1,38},{26.9,37.2},{31.8,31.8},{38.2,19.4},{51.1,-10.5},{57.5,-21.2},{63.1,-25.9},{68.7,-25.9},{75.2,-20.5},{80,-13.8}},
          smooth=Smooth.Bezier,
          color={192,192,192}),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255}),
        Text(extent={{60,-50},{92,-70}},
          lineColor={0,0,0},
          textString="min"),
        Line(
          points={{-18,-56},{50,-56}},
          color={0,0,0},
          pattern=LinePattern.Dash)}),
      Documentation(info="<html>
<p>
This block calculates the minimum of the input signal <code>u</code>.
It neither uses a sampled input value nor derivatives to calculate the extrema,
instead an FMI-based approach using <a href=\"modelica://LastLib\">LastLib</a> is utilized.
</p></html>"));
  end Minimum;

  model Test "Example to demonstrate the minimum calculation"
    extends Modelica.Icons.Example;
    Real x(start=3, fixed=true) "State variable";
    Real v(start=-1, fixed=true) "Derivative of state variable";
    Modelica.Blocks.Sources.RealExpression realExpression(y=x) annotation(Placement(transformation(extent={{-28,-10},{-8,10}})));
    Minimum min(y_start=2) annotation(Placement(transformation(extent={{12,-10},{32,10}})));
  equation
    connect(realExpression.y, min.u) annotation(Line(points={{-7,0},{10,0}}, color={0,0,127}));
    der(x) = v;
    der(v) = -x + 1 - time/10;
    annotation(experiment(StopTime=20),
      Diagram(coordinateSystem(extent={{-80,-40},{80,40}}), graphics={
        Text(
          extent={{4,-12},{62,-36}},
          textColor={0,140,72},
          textStyle={TextStyle.Bold},
          textString="Before simulation:
Redeclare the min.Last FMU
according to the Modelica tool!",
          horizontalAlignment=TextAlignment.Left)}),
      Icon(coordinateSystem(extent={{-80,-40},{80,40}})));
  end Test;
  annotation(uses(Modelica(version="4.0.0"), LastLib(version="2.0.0")));
end MinimumTest;
