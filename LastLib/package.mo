within ;

package LastLib
  extends Modelica.Icons.Package;

  partial model LastBase
    parameter Real y_start = 0. "Signal output initialization";
    extends Modelica.Blocks.Interfaces.SISO;
  end LastBase;
  annotation(uses(Modelica(version="3.2.3")), version="2.0.0");
end LastLib;
