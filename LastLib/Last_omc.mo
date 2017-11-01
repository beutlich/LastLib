within LastLib;

model Last_omc "Last for OpenModelica (C runtime)"
  constant String fmuWorkingDir = Modelica.Utilities.Files.loadResource("modelica://LastLib/Resources");
  parameter Integer logLevel = 3 "log level used during the loading of FMU" annotation(Dialog(tab = "FMI", group = "Enable logging"));
  parameter Boolean debugLogging = false "enables the FMU simulation logging" annotation(Dialog(tab = "FMI", group = "Enable logging"));
  extends LastBase;
protected
  FMI1ModelExchange fmi1me = FMI1ModelExchange(logLevel, fmuWorkingDir, "Last", debugLogging);
  constant Integer numberOfContinuousStates = 0;
  Real fmi_x[numberOfContinuousStates] "States";
  Real fmi_x_new[numberOfContinuousStates](each fixed = true) "New States";
  constant Integer numberOfEventIndicators = 0;
  Real fmi_z[numberOfEventIndicators] "Events Indicators";
  Boolean fmi_z_positive[numberOfEventIndicators](each fixed = true);
  parameter Real flowStartTime(fixed = false);
  Real flowTime;
  parameter Real flowInitialized(fixed = false);
  parameter Real flowParamsStart(fixed = false);
  parameter Real flowInitInputs(fixed = false);
  Real flowStatesInputs;
  Real fmi_input_u;
  Boolean callEventUpdate;
  constant Boolean intermediateResults = false;
  Boolean newStatesAvailable(fixed = true);
  Real triggerDSSEvent;
  Real nextEventTime;

  class FMI1ModelExchange
    extends ExternalObject;

    function constructor
      input Integer logLevel;
      input String workingDirectory;
      input String instanceName;
      input Boolean debugLogging;
      output FMI1ModelExchange fmi1me;
    
      external "C" fmi1me = FMI1ModelExchangeConstructor_OMC(logLevel, workingDirectory, instanceName, debugLogging) annotation(
        Library = {"OpenModelicaFMIRuntimeC", "fmilib"});
    end constructor;

    function destructor
      input FMI1ModelExchange fmi1me;
    
      external "C" FMI1ModelExchangeDestructor_OMC(fmi1me) annotation(
        Library = {"OpenModelicaFMIRuntimeC", "fmilib"});
    end destructor;
  end FMI1ModelExchange;

  package fmi1Functions
    function fmi1Initialize
      input FMI1ModelExchange fmi1me;
      input Real preInitialized;
      output Real postInitialized = preInitialized;
    
      external "C" fmi1Initialize_OMC(fmi1me) annotation(
        Library = {"OpenModelicaFMIRuntimeC", "fmilib"});
    end fmi1Initialize;

    function fmi1SetTime
      input FMI1ModelExchange fmi1me;
      input Real inTime;
      input Real inFlow;
      output Real outFlow = inFlow;
    
      external "C" fmi1SetTime_OMC(fmi1me, inTime) annotation(
        Library = {"OpenModelicaFMIRuntimeC", "fmilib"});
    end fmi1SetTime;

    function fmi1GetContinuousStates
      input FMI1ModelExchange fmi1me;
      input Integer numberOfContinuousStates;
      input Real inFlowParams;
      output Real fmi_x[numberOfContinuousStates];
    
      external "C" fmi1GetContinuousStates_OMC(fmi1me, numberOfContinuousStates, inFlowParams, fmi_x) annotation(
        Library = {"OpenModelicaFMIRuntimeC", "fmilib"});
    end fmi1GetContinuousStates;

    function fmi1SetContinuousStates
      input FMI1ModelExchange fmi1me;
      input Real fmi_x[:];
      input Real inFlowParams;
      output Real outFlowStates;
    
      external "C" outFlowStates = fmi1SetContinuousStates_OMC(fmi1me, size(fmi_x, 1), inFlowParams, fmi_x) annotation(
        Library = {"OpenModelicaFMIRuntimeC", "fmilib"});
    end fmi1SetContinuousStates;

    function fmi1GetDerivatives
      input FMI1ModelExchange fmi1me;
      input Integer numberOfContinuousStates;
      input Real inFlowStates;
      output Real fmi_x[numberOfContinuousStates];
    
      external "C" fmi1GetDerivatives_OMC(fmi1me, numberOfContinuousStates, inFlowStates, fmi_x) annotation(
        Library = {"OpenModelicaFMIRuntimeC", "fmilib"});
    end fmi1GetDerivatives;

    function fmi1GetEventIndicators
      input FMI1ModelExchange fmi1me;
      input Integer numberOfEventIndicators;
      input Real inFlowStates;
      output Real fmi_z[numberOfEventIndicators];
    
      external "C" fmi1GetEventIndicators_OMC(fmi1me, numberOfEventIndicators, inFlowStates, fmi_z) annotation(
        Library = {"OpenModelicaFMIRuntimeC", "fmilib"});
    end fmi1GetEventIndicators;

    function fmi1GetReal
      input FMI1ModelExchange fmi1me;
      input Real realValuesReferences[:];
      input Real inFlowStatesInput;
      output Real realValues[size(realValuesReferences, 1)];
    
      external "C" fmi1GetReal_OMC(fmi1me, size(realValuesReferences, 1), realValuesReferences, inFlowStatesInput, realValues, 1) annotation(
        Library = {"OpenModelicaFMIRuntimeC", "fmilib"});
    end fmi1GetReal;

    function fmi1SetReal
      input FMI1ModelExchange fmi1me;
      input Real realValueReferences[:];
      input Real realValues[size(realValueReferences, 1)];
      output Real outValues[size(realValueReferences, 1)] = realValues;
    
      external "C" fmi1SetReal_OMC(fmi1me, size(realValueReferences, 1), realValueReferences, realValues, 1) annotation(
        Library = {"OpenModelicaFMIRuntimeC", "fmilib"});
    end fmi1SetReal;

    function fmi1SetRealParameter
      input FMI1ModelExchange fmi1me;
      input Real realValueReferences[:];
      input Real realValues[size(realValueReferences, 1)];
      output Real out_Value = 1;
    
      external "C" fmi1SetReal_OMC(fmi1me, size(realValueReferences, 1), realValueReferences, realValues, 1) annotation(
        Library = {"OpenModelicaFMIRuntimeC", "fmilib"});
    end fmi1SetRealParameter;

    function fmi1GetInteger
      input FMI1ModelExchange fmi1me;
      input Real integerValueReferences[:];
      input Real inFlowStatesInput;
      output Integer integerValues[size(integerValueReferences, 1)];
    
      external "C" fmi1GetInteger_OMC(fmi1me, size(integerValueReferences, 1), integerValueReferences, inFlowStatesInput, integerValues, 1) annotation(
        Library = {"OpenModelicaFMIRuntimeC", "fmilib"});
    end fmi1GetInteger;

    function fmi1SetInteger
      input FMI1ModelExchange fmi1me;
      input Real integerValuesReferences[:];
      input Integer integerValues[size(integerValuesReferences, 1)];
      output Integer outValues[size(integerValuesReferences, 1)] = integerValues;
    
      external "C" fmi1SetInteger_OMC(fmi1me, size(integerValuesReferences, 1), integerValuesReferences, integerValues, 1) annotation(
        Library = {"OpenModelicaFMIRuntimeC", "fmilib"});
    end fmi1SetInteger;

    function fmi1SetIntegerParameter
      input FMI1ModelExchange fmi1me;
      input Real integerValuesReferences[:];
      input Integer integerValues[size(integerValuesReferences, 1)];
      output Real out_Value = 1;
    
      external "C" fmi1SetInteger_OMC(fmi1me, size(integerValuesReferences, 1), integerValuesReferences, integerValues, 1) annotation(
        Library = {"OpenModelicaFMIRuntimeC", "fmilib"});
    end fmi1SetIntegerParameter;

    function fmi1GetBoolean
      input FMI1ModelExchange fmi1me;
      input Real booleanValuesReferences[:];
      input Real inFlowStatesInput;
      output Boolean booleanValues[size(booleanValuesReferences, 1)];
    
      external "C" fmi1GetBoolean_OMC(fmi1me, size(booleanValuesReferences, 1), booleanValuesReferences, inFlowStatesInput, booleanValues, 1) annotation(
        Library = {"OpenModelicaFMIRuntimeC", "fmilib"});
    end fmi1GetBoolean;

    function fmi1SetBoolean
      input FMI1ModelExchange fmi1me;
      input Real booleanValueReferences[:];
      input Boolean booleanValues[size(booleanValueReferences, 1)];
      output Boolean outValues[size(booleanValueReferences, 1)] = booleanValues;
    
      external "C" fmi1SetBoolean_OMC(fmi1me, size(booleanValueReferences, 1), booleanValueReferences, booleanValues, 1) annotation(
        Library = {"OpenModelicaFMIRuntimeC", "fmilib"});
    end fmi1SetBoolean;

    function fmi1SetBooleanParameter
      input FMI1ModelExchange fmi1me;
      input Real booleanValueReferences[:];
      input Boolean booleanValues[size(booleanValueReferences, 1)];
      output Real out_Value = 1;
    
      external "C" fmi1SetBoolean_OMC(fmi1me, size(booleanValueReferences, 1), booleanValueReferences, booleanValues, 1) annotation(
        Library = {"OpenModelicaFMIRuntimeC", "fmilib"});
    end fmi1SetBooleanParameter;

    function fmi1GetString
      input FMI1ModelExchange fmi1me;
      input Real stringValuesReferences[:];
      input Real inFlowStatesInput;
      output String stringValues[size(stringValuesReferences, 1)];
    
      external "C" fmi1GetString_OMC(fmi1me, size(stringValuesReferences, 1), stringValuesReferences, inFlowStatesInput, stringValues, 1) annotation(
        Library = {"OpenModelicaFMIRuntimeC", "fmilib"});
    end fmi1GetString;

    function fmi1SetString
      input FMI1ModelExchange fmi1me;
      input Real stringValueReferences[:];
      input String stringValues[size(stringValueReferences, 1)];
      output String outValues[size(stringValueReferences, 1)] = stringValues;
    
      external "C" fmi1SetString_OMC(fmi1me, size(stringValueReferences, 1), stringValueReferences, stringValues, 1) annotation(
        Library = {"OpenModelicaFMIRuntimeC", "fmilib"});
    end fmi1SetString;

    function fmi1SetStringParameter
      input FMI1ModelExchange fmi1me;
      input Real stringValueReferences[:];
      input String stringValues[size(stringValueReferences, 1)];
      output Real out_Value = 1;
    
      external "C" fmi1SetString_OMC(fmi1me, size(stringValueReferences, 1), stringValueReferences, stringValues, 1) annotation(
        Library = {"OpenModelicaFMIRuntimeC", "fmilib"});
    end fmi1SetStringParameter;

    function fmi1EventUpdate
      input FMI1ModelExchange fmi1me;
      input Boolean intermediateResults;
      output Boolean outNewStatesAvailable;
    
      external "C" outNewStatesAvailable = fmi1EventUpdate_OMC(fmi1me, intermediateResults) annotation(
        Library = {"OpenModelicaFMIRuntimeC", "fmilib"});
    end fmi1EventUpdate;

    function fmi1nextEventTime
      input FMI1ModelExchange fmi1me;
      input Real inFlowStates;
      output Real outNewnextTime;
    
      external "C" outNewnextTime = fmi1nextEventTime_OMC(fmi1me, inFlowStates) annotation(
        Library = {"OpenModelicaFMIRuntimeC", "fmilib"});
    end fmi1nextEventTime;

    function fmi1CompletedIntegratorStep
      input FMI1ModelExchange fmi1me;
      input Real inFlowStates;
      output Boolean outCallEventUpdate;
    
      external "C" outCallEventUpdate = fmi1CompletedIntegratorStep_OMC(fmi1me, inFlowStates) annotation(
        Library = {"OpenModelicaFMIRuntimeC", "fmilib"});
    end fmi1CompletedIntegratorStep;
  end fmi1Functions;
initial equation
  flowStartTime = fmi1Functions.fmi1SetTime(fmi1me, time, 1);
  flowInitialized = fmi1Functions.fmi1Initialize(fmi1me, flowParamsStart + flowInitInputs + flowStartTime);
initial algorithm
  flowParamsStart := 1;
  flowParamsStart := fmi1Functions.fmi1SetRealParameter(fmi1me, {1073741824.0}, {y_start});
  flowInitInputs := 1;
initial equation

equation
  flowTime = fmi1Functions.fmi1SetTime(fmi1me, time, flowInitialized);
  {fmi_input_u} = fmi1Functions.fmi1SetReal(fmi1me, {536870912.0}, {u});
  flowStatesInputs = fmi1Functions.fmi1SetContinuousStates(fmi1me, fmi_x, flowParamsStart + flowTime);
  der(fmi_x) = fmi1Functions.fmi1GetDerivatives(fmi1me, numberOfContinuousStates, flowStatesInputs);
  fmi_z = fmi1Functions.fmi1GetEventIndicators(fmi1me, numberOfEventIndicators, flowStatesInputs);
  for i in 1:size(fmi_z, 1) loop
    fmi_z_positive[i] = if not terminal() then fmi_z[i] > 0 else pre(fmi_z_positive[i]);
  end for;
  callEventUpdate = fmi1Functions.fmi1CompletedIntegratorStep(fmi1me, flowStatesInputs);
  triggerDSSEvent = noEvent(if callEventUpdate then flowStatesInputs + 1.0 else flowStatesInputs - 1.0);
  nextEventTime = fmi1Functions.fmi1nextEventTime(fmi1me, flowStatesInputs);
  {y} = fmi1Functions.fmi1GetReal(fmi1me, {805306368.0}, flowStatesInputs);
algorithm
  when {triggerDSSEvent > flowStatesInputs, nextEventTime < time, terminal()} then
    newStatesAvailable := fmi1Functions.fmi1EventUpdate(fmi1me, intermediateResults);
  end when;
  annotation(defaultComponentName="last",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}, lineColor = {0, 0, 0}, fillColor = {240, 240, 240}, fillPattern = FillPattern.Solid, lineThickness = 0.5), Text(extent = {{-100, 40}, {100, 0}}, lineColor = {0, 0, 0}, textString = "%name"), Text(extent = {{-100, -50}, {100, -90}}, lineColor = {0, 0, 0}, textString = "V1.0")}));
end Last_omc;
