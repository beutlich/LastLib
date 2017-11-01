within ;

package LastLib
  extends Modelica.Icons.Package;

  partial model LastBase
    parameter Real y_start = 0. "Signal output initialization";
    Modelica.Blocks.Interfaces.RealInput u "Signal input" annotation(Placement(transformation(extent={{-124,-20},{-84,20}})));
    Modelica.Blocks.Interfaces.RealOutput y "Signal output" annotation(Placement(transformation(extent={{100,-20},{140,20}})));
  end LastBase;
  annotation(uses(Modelica(version="3.2.2")), version="1.0.0");
end LastLib;
