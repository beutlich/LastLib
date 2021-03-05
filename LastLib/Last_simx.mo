within LastLib;

model Last_simx "Last for SimulationX"
  parameter String FMUFile=Modelica.Utilities.Files.loadResource("modelica://LastLib/Resources/Last.fmu") "FMU File" annotation(
    __iti_specialFormat=2,
    Dialog(tab="FMI Settings"));
  parameter Boolean keep=false "Keep unzipped FMU" annotation(Dialog(tab="FMI Settings"));
  parameter String FMUUnzipFolder="C:\\temp" "Folder for unzipped FMU" annotation(
    __iti_specialFormat=1,
    Dialog(
      tab="FMI Settings",
      enable=keep));
  parameter Boolean loggingOn=false "Logging of FMU" annotation(Dialog(tab="FMI Settings"));
  protected
    record fmiEventInfo
      Boolean a_iterationConverged;
      Boolean b_stateValueReferenceChanged;
      Boolean c_stateValuesChanged;
      Boolean d_terminateSimulation;
      Boolean e_upComingTimeEvent;
      Real f_nextEventTime;
    end fmiEventInfo;
    record fmiEventInfo_i
      parameter Boolean a_iterationConverged(fixed=false);
      parameter Boolean b_stateValueReferenceChanged(fixed=false);
      parameter Boolean c_stateValuesChanged(fixed=false);
      parameter Boolean d_terminateSimulation(fixed=false);
      parameter Boolean e_upComingTimeEvent(fixed=false);
      parameter Real f_nextEventTime(fixed=false);
    end fmiEventInfo_i;
    package fmiStatus
      constant Integer fmiOK=0;
      constant Integer fmiWarning=1;
      constant Integer fmiDiscard=2;
      constant Integer fmiError=3;
      constant Integer fmiFatal=4;
      constant Integer fmiPending=5;
    end fmiStatus;
    type FMU10Object
      extends ExternalObject;
      function constructor
        input String strInstName;
        input Integer ifmuType;
        input String strGUID;
        input String mimetype;
        input Real timeout;
        input Boolean visible;
        input Boolean interactive;
        input Boolean loggingOn;
        input Boolean once;
        input String strFMUFile;
        input String strFMUName;
        input Boolean keep;
        input Boolean strict;
        input String strUnzipPath;
        output FMU10Object pFMU;
        external "C" pFMU=ITI_InstantiateFMU10(strInstName,ifmuType,strGUID,mimetype,timeout,visible,interactive,loggingOn,once,strFMUFile,strFMUName,keep,strUnzipPath,strict)
          annotation(Library="ITI_FMUImportWrapper",__iti_dllNoExport=true,__iti_AdditionalFiles="FMUImportWrapper.fls");
      end constructor;
      function destructor
        input FMU10Object pFMU;
        external "C" ITI_FreeFMU10(pFMU)
          annotation(Library="ITI_FMUImportWrapper",__iti_dllNoExport=true,__iti_AdditionalFiles="FMUImportWrapper.fls");
      end destructor;
    end FMU10Object;
    function IsInitialized
      input FMU10Object pFMU;
      output Real ret;
      external "C" ret=ITI_IsInitialized10(pFMU)
        annotation(Library="ITI_FMUImportWrapper",__iti_dllNoExport=true,__iti_AdditionalFiles="FMUImportWrapper.fls");
    end IsInitialized;
    function SetReal
      input FMU10Object pFMU;
      input Integer vr[:];
      input Real value[size(vr,1)];
      input Integer dependencies;
      output Integer ret;
      external "C" ret=ITI_SetReal10(pFMU,vr,size(vr,1),value)
        annotation(Library="ITI_FMUImportWrapper",__iti_dllNoExport=true,__iti_AdditionalFiles="FMUImportWrapper.fls");
    end SetReal;
    function SetInteger
      input FMU10Object pFMU;
      input Integer vr[:];
      input Integer value[size(vr,1)];
      input Integer dependencies;
      output Integer ret;
      external "C" ret=ITI_SetInteger10(pFMU,vr,size(vr,1),value)
        annotation(Library="ITI_FMUImportWrapper",__iti_dllNoExport=true,__iti_AdditionalFiles="FMUImportWrapper.fls");
    end SetInteger;
    function SetBoolean
      input FMU10Object pFMU;
      input Integer vr[:];
      input Boolean value[size(vr,1)];
      input Integer dependencies;
      output Integer ret;
      external "C" ret=ITI_SetBoolean10(pFMU,vr,size(vr,1),value)
        annotation(Library="ITI_FMUImportWrapper",__iti_dllNoExport=true,__iti_AdditionalFiles="FMUImportWrapper.fls");
    end SetBoolean;
    function SetString
      input FMU10Object pFMU;
      input Integer vr[:];
      input String value[size(vr,1)];
      input Integer dependencies;
      output Integer ret;
      external "C" ret=ITI_SetString10(pFMU,vr,size(vr,1),value)
        annotation(Library="ITI_FMUImportWrapper",__iti_dllNoExport=true,__iti_AdditionalFiles="FMUImportWrapper.fls");
    end SetString;
    function GetRealSett
      input FMU10Object pFMU;
      input Integer vr[:];
      input Real t;
      input Boolean isEvent;
      input Integer dependencies;
      output Integer ret;
      output Real value[size(vr,1)];
      external "C" ret=ITI_GetRealSett10(pFMU,vr,size(vr,1),t,value,isEvent)
        annotation(Library="ITI_FMUImportWrapper",__iti_dllNoExport=true,__iti_AdditionalFiles="FMUImportWrapper.fls");
    end GetRealSett;
    function GetReal
      input FMU10Object pFMU;
      input Integer vr[:];
      input Integer dependencies;
      output Integer ret;
      output Real value[size(vr,1)];
      external "C" ret=ITI_GetReal10(pFMU,vr,size(vr,1),value)
        annotation(Library="ITI_FMUImportWrapper",__iti_dllNoExport=true,__iti_AdditionalFiles="FMUImportWrapper.fls");
    end GetReal;
    function GetInteger
      input FMU10Object pFMU;
      input Integer vr[:];
      input Integer dependencies;
      output Integer ret;
      output Integer value[size(vr,1)];
      external "C" ret=ITI_GetInteger10(pFMU,vr,size(vr,1),value)
        annotation(Library="ITI_FMUImportWrapper",__iti_dllNoExport=true,__iti_AdditionalFiles="FMUImportWrapper.fls");
    end GetInteger;
    function GetBoolean
      input FMU10Object pFMU;
      input Integer vr[:];
      input Integer dependencies;
      output Integer ret;
      output Boolean value[size(vr,1)];
      external "C" ret=ITI_GetBoolean10(pFMU,vr,size(vr,1),value)
        annotation(Library="ITI_FMUImportWrapper",__iti_dllNoExport=true,__iti_AdditionalFiles="FMUImportWrapper.fls");
    end GetBoolean;
    function GetString
      input FMU10Object pFMU;
      input Integer vr[:];
      input Integer dependencies;
      output Integer ret;
      output Boolean value[size(vr,1)];
      external "C" ret=ITI_GetString10(pFMU,vr,size(vr,1),value)
        annotation(Library="ITI_FMUImportWrapper",__iti_dllNoExport=true,__iti_AdditionalFiles="FMUImportWrapper.fls");
    end GetString;
    function GetRealSetRXt
      input ExternalObject pFMU;
      input Integer vr[:];
      input Integer vru[:];
      input Integer nvru;
      input Real ruvalue[size(vru,1)];
      input Integer nx;
      input Real xvalue[:];
      input Real t;
      input Boolean isInitial;
      input Boolean isEvent;
      input Boolean setStatesAllowed;
      input Integer dependencies;
      output Integer ret;
      output Real value[size(vr,1)];
      external "C" ret=ITI_GetRealSetRXt10(pFMU,vr,size(vr,1),value,vru,nvru,ruvalue,nx,xvalue,t,isInitial,isEvent,setStatesAllowed)
        annotation(Library="ITI_FMUImportWrapper",__iti_dllNoExport=true,__iti_AdditionalFiles="FMUImportWrapper.fls");
    end GetRealSetRXt;
    function GetRealSetRt
      input ExternalObject pFMU;
      input Integer vr[:];
      input Integer vru[:];
      input Integer nvru;
      input Real ruvalue[size(vru,1)];
      input Real t;
      input Boolean isEvent;
      input Integer dependencies;
      output Integer ret;
      output Real value[size(vr,1)];
      external "C" ret=ITI_GetRealSetRt10(pFMU,vr,size(vr,1),value,vru,nvru,ruvalue,isEvent)
        annotation(Library="ITI_FMUImportWrapper",__iti_dllNoExport=true,__iti_AdditionalFiles="FMUImportWrapper.fls");
    end GetRealSetRt;
    function GetDXSetRXt
      input ExternalObject pFMU;
      input Integer nx;
      input Integer vru[:];
      input Integer nvru;
      input Real ruvalue[size(vru,1)];
      input Real x[nx];
      input Real t;
      input Boolean isInitial;
      input Boolean isEvent;
      input Boolean setStatesAllowed;
      input Integer dependencies;
      output Integer ret;
      output Real dx[nx];
      external "C" ret=ITI_GetDXSetRXt10(pFMU,nx,dx,vru,nvru,ruvalue,x,t,isInitial,isEvent,setStatesAllowed)
        annotation(Library="ITI_FMUImportWrapper",__iti_dllNoExport=true,__iti_AdditionalFiles="FMUImportWrapper.fls");
    end GetDXSetRXt;
    function InitializeModel
      input FMU10Object pFMU;
      input Boolean toleranceControlled;
      input Real relativeTolerance;
      input Real t;
      input Integer dependencies;
      output Integer ret;
      output fmiEventInfo_i eventInfo;
      external "C" ret=ITI_InitializeModel(pFMU,toleranceControlled,relativeTolerance,eventInfo,t)
        annotation(Library="ITI_FMUImportWrapper",__iti_dllNoExport=true,__iti_AdditionalFiles="FMUImportWrapper.fls");
    end InitializeModel;
    function EventUpdate
      input FMU10Object pFMU;
      input Boolean intermediateResults;
      input Real t;
      input Integer dependencies;
      output Integer ret;
      output fmiEventInfo eventInfo;
      external "C" ret=ITI_EventUpdate10(pFMU,intermediateResults,t,eventInfo)
        annotation(Library="ITI_FMUImportWrapper",__iti_dllNoExport=true,__iti_AdditionalFiles="FMUImportWrapper.fls");
    end EventUpdate;
    function CompletedIntegratorStep
      input FMU10Object pFMU;
      input Real t;
      input Integer dependencies;
      output Integer ret;
      output Boolean callEventUpdate;
      external "C" ret=ITI_CompletedIntegratorStep10(pFMU,t,callEventUpdate)
        annotation(Library="ITI_FMUImportWrapper",__iti_dllNoExport=true,__iti_AdditionalFiles="FMUImportWrapper.fls");
    end CompletedIntegratorStep;
    function InitializeSlave
      input FMU10Object pFMU;
      input Real startTime;
      input Boolean stopTimeDefined;
      input Real tStop;
      input Integer dependencies;
      output Integer ret;
      external "C" ret=ITI_InitializeSlave(pFMU,startTime,stopTimeDefined,tStop)
        annotation(Library="ITI_FMUImportWrapper",__iti_dllNoExport=true,__iti_AdditionalFiles="FMUImportWrapper.fls");
    end InitializeSlave;
    function DoStep
      input FMU10Object pFMU;
      input Real currentCommunicationPoint;
      input Real communicationStepSize;
      input Boolean newStep;
      input Integer dependencies;
      output Integer status;
      external "C" status=ITI_DoStep10(pFMU,currentCommunicationPoint,communicationStepSize,newStep)
        annotation(Library="ITI_FMUImportWrapper",__iti_dllNoExport=true,__iti_AdditionalFiles="FMUImportWrapper.fls");
    end DoStep;
    function GetEventIndicatorsSetRt
      input FMU10Object pFMU;
      input Integer n;
      input Integer vru[:];
      input Integer nvru;
      input Real ruvalue[size(vru,1)];
      input Real t;
      input Boolean isEvent;
      input Integer dependencies;
      output Integer ret;
      output Real evi[n];
      external "C" ret=ITI_GetEventIndicatorsSetRt10(pFMU,n,evi,vru,nvru,ruvalue,t,isEvent)
        annotation(Library="ITI_FMUImportWrapper",__iti_dllNoExport=true,__iti_AdditionalFiles="FMUImportWrapper.fls");
    end GetEventIndicatorsSetRt;
    function GetEventIndicators
      input FMU10Object pFMU;
      input Integer n;
      input Real t;
      input Boolean isEvent;
      input Integer dependencies;
      output Integer ret;
      output Real evi[n];
      external "C" ret=ITI_GetEventIndicators10(pFMU,n,t,evi,isEvent)
        annotation(Library="ITI_FMUImportWrapper",__iti_dllNoExport=true,__iti_AdditionalFiles="FMUImportWrapper.fls");
    end GetEventIndicators;
    function GetContinuousStates
      input FMU10Object pFMU;
      input Integer n;
      input Integer dependencies;
      output Integer ret;
      output Real x0[n];
      external "C" ret=ITI_GetContinuousStates10(pFMU,x0,n)
        annotation(Library="ITI_FMUImportWrapper",__iti_dllNoExport=true,__iti_AdditionalFiles="FMUImportWrapper.fls");
    end GetContinuousStates;
    function SetRealInputCS
      input FMU10Object pFMU;
      input Integer vr[:];
      input Real value[size(vr,1)];
      input Real t;
      input Integer dependencies;
      output Integer ret;
      external "C" ret=ITI_SetRealInputCS10(pFMU,vr,size(vr,1),value,t)
        annotation(Library="ITI_FMUImportWrapper",__iti_dllNoExport=true,__iti_AdditionalFiles="FMUImportWrapper.fls");
    end SetRealInputCS;
    function SetIntegerInputCS
      input FMU10Object pFMU;
      input Integer vr[:];
      input Integer value[size(vr,1)];
      input Real t;
      input Integer dependencies;
      output Integer ret;
      external "C" ret=ITI_SetIntegerInputCS10(pFMU,vr,size(vr,1),value,t)
        annotation(Library="ITI_FMUImportWrapper",__iti_dllNoExport=true,__iti_AdditionalFiles="FMUImportWrapper.fls");
    end SetIntegerInputCS;
    function SetBooleanInputCS
      input FMU10Object pFMU;
      input Integer vr[:];
      input Boolean value[size(vr,1)];
      input Real t;
      input Integer dependencies;
      output Integer ret;
      external "C" ret=ITI_SetBooleanInputCS10(pFMU,vr,size(vr,1),value,t)
        annotation(Library="ITI_FMUImportWrapper",__iti_dllNoExport=true,__iti_AdditionalFiles="FMUImportWrapper.fls");
    end SetBooleanInputCS;
    function SetStringInputCS
      input FMU10Object pFMU;
      input Integer vr[:];
      input String value[size(vr,1)];
      input Real t;
      input Integer dependencies;
      output Integer ret;
      external "C" ret=ITI_SetStringInputCS10(pFMU,vr,size(vr,1),value,t)
        annotation(Library="ITI_FMUImportWrapper",__iti_dllNoExport=true,__iti_AdditionalFiles="FMUImportWrapper.fls");
    end SetStringInputCS;
    parameter String FMUName="Last";
    parameter String GUID="{31D2AA2B-E012-46F6-9BD9-1B99F9AF38D1}";
    Real realOutputs[1];
  public
    parameter Boolean toleranceDefined=false "Is Tolerance defined?" annotation(Dialog(tab="FMI Settings"));
    parameter Real tol=1e-5 "Tolerance" annotation(Dialog(
      tab="FMI Settings",
      enable=toleranceDefined));
    parameter Boolean strict=false "Strict FMI 1.0 Compatibility Mode" annotation(Dialog(tab="FMI Settings"));
  protected
    parameter ExternalObject FMU=FMU10Object(getInstanceName(),0,GUID,"",0.0, false, false,loggingOn,false,FMUFile,FMUName,keep,strict,FMUUnzipFolder);
    /*nondiscrete*/ Boolean enterEventMode;
    /*nondiscrete*/ Boolean terminateSimulation;
    /*nondiscrete*/ Integer retI1;
    /*nondiscrete*/ Integer retI2;
    /*nondiscrete*/ Integer retI3;
    /*nondiscrete*/ Integer retI4;
    /*nondiscrete*/ Integer retI5;
    /*nondiscrete*/ Integer retI6;
    /*nondiscrete*/ Integer retI7;
    parameter Integer retI(
      start=0,
      fixed=false);
    /*nondiscrete*/ Integer retI9;
    parameter Integer retI10(
      start=0,
      fixed=false);
    parameter Integer retI11(
      start=0,
      fixed=false);
    /*nondiscrete*/ Integer retI12;
    /*nondiscrete*/ Integer retI13;
    /*nondiscrete*/ Integer retI14;
    /*nondiscrete*/ Integer retI15;
    /*nondiscrete*/ Integer retI16;
    Integer retM(
      start=1,
      fixed=true) annotation(__iti_NoAlgorithmInitialization=true);
    /*nondiscrete*/ Integer ret1;
    /*nondiscrete*/ Integer ret2;
    /*nondiscrete*/ Integer ret3;
    /*nondiscrete*/ Integer ret4;
    /*nondiscrete*/ Integer ret5;
    /*nondiscrete*/ Integer ret6;
    /*nondiscrete*/ Integer ret7;
    /*nondiscrete*/ Integer ret8;
    /*nondiscrete*/ Integer ret9;
    /*nondiscrete*/ Integer ret10;
    Integer ret11(
      start=0,
      fixed=true);
    /*nondiscrete*/ Integer ret12;
    Integer ret13;
    Integer ret14;
    /*nondiscrete*/ Integer ret15;
    fmiEventInfo eventInfo annotation(__iti_NoAlgorithmInitialization=true);
    fmiEventInfo_i eventInfo_i annotation(__iti_NoAlgorithmInitialization=true);
    Boolean bTimeEvent(start=false);
    Boolean bDoReinit(
      start=false,
      fixed=true);
    Boolean bSetStatesAllowed(
      start=false,
      fixed=true);
    Boolean bContinueEventIteration(start=false);
    /*nondiscrete*/ Boolean callEventUpdate(start=false);
  public
    extends LastBase;
  initial algorithm
    if noEvent(IsInitialized(FMU)==0) then
      retI1:=SetReal(FMU, {0}, {y_start}, 1);
      assert(retI1<>fmiStatus.fmiError, "The FMI function fmiSetReal for a parameter returned fmiError.");
      assert(retI1<>fmiStatus.fmiDiscard, "The FMI function fmiSetReal for a parameter returned fmiDiscard.");
      retI2:=1;
      assert(retI2<>fmiStatus.fmiError, "The FMI function fmiSetInteger for a parameter returned fmiError.");
      assert(retI2<>fmiStatus.fmiDiscard, "The FMI function fmiSetInteger for a parameter returned fmiDiscard.");
      retI3:=1;
      assert(retI3<>fmiStatus.fmiError, "The FMI function fmiSetBoolean for a parameter returned fmiError.");
      assert(retI3<>fmiStatus.fmiDiscard, "The FMI function fmiSetBoolean for a parameter returned fmiDiscard.");
      retI4:=1;
      assert(retI4<>fmiStatus.fmiError, "The FMI function fmiSetString for a parameter returned fmiError.");
      assert(retI4<>fmiStatus.fmiDiscard, "The FMI function fmiSetString for a parameter returned fmiDiscard.");
      retI5:=SetReal(FMU, {1}, {u}, retI4);
      assert(retI5<>fmiStatus.fmiError, "The FMI function fmiSetReal for an input returned fmiError.");
      assert(retI5<>fmiStatus.fmiDiscard, "The FMI function fmiSetReal for an input returned fmiDiscard.");
      retI6:=1;
      assert(retI6<>fmiStatus.fmiError, "The FMI function fmiSetInteger for an input returned fmiError.");
      assert(retI6<>fmiStatus.fmiDiscard, "The FMI function fmiSetInteger for an input returned fmiDiscard.");
      retI7:=1;
      assert(retI7<>fmiStatus.fmiError, "The FMI function fmiSetBoolean for an input returned fmiError.");
      assert(retI7<>fmiStatus.fmiDiscard, "The FMI function fmiSetBoolean for an input returned fmiDiscard.");
      (retI, eventInfo_i):=InitializeModel(FMU,toleranceDefined,tol,time,retI1+retI2+retI3+retI4+retI5+retI6+retI7);
      assert(retI<>fmiStatus.fmiError, "The FMI function fmiInitialize returned fmiError.");
      if(retI==fmiStatus.fmiError) or (retI==fmiStatus.fmiFatal) then
        terminate("Terminating: fmiInitialize returned an error");
      end if;
      if(retI==fmiStatus.fmiWarning) then
        trace("fmiInitialize returned a warning");
      end if;
      if(eventInfo_i.d_terminateSimulation)then
        terminate("FMU requested termination of simulation run during initialization.");
      end if;


    end if;
  equation
      (ret1, realOutputs) = GetRealSetRXt(FMU,
        {2},
        {1},
        1,
        {u},
        0,
        {0},
        time,
        initial(),
        (analysisTypeDetail() == "event"),
        pre(bSetStatesAllowed)==bSetStatesAllowed,
        retM+retI);
      assert(ret1<>fmiStatus.fmiError, "An FMI function (fmiGetReal for outputs or fmiSetXXX for real inputs or continuous states) returned fmiError.");
      assert(ret1<>fmiStatus.fmiDiscard, "An FMI function (fmiGetReal for outputs or fmiSetXXX for real inputs or continuous states) returned fmiDiscard.");

    ret2 = 1;
    ret3=1;
    ret12=1;

      {y}=realOutputs;

    when(eventInfo.e_upComingTimeEvent and time>=eventInfo.f_nextEventTime) then
        //trace("FMU %1: Time Event at %2", FMUName, time);
      bTimeEvent=not(pre(bTimeEvent));
    elsewhen(eventInfo_i.e_upComingTimeEvent and time>=eventInfo_i.f_nextEventTime) then
        //trace("FMU %1: Time Event at %2", FMUName, time);
      bTimeEvent=not(pre(bTimeEvent));
    end when;
    bSetStatesAllowed = false;
  algorithm
    if (not(initial()) and (analysisTypeDetail() == "event")) then
      ret4:=SetReal(FMU, {1}, {u}, 1);
      assert(ret4<>fmiStatus.fmiError, "The FMI function fmiSetReal for an input returned fmiError.");
      assert(ret4<>fmiStatus.fmiDiscard, "The FMI function fmiSetReal for an input returned fmiDiscard.");
      ret5:=1;
      assert(ret5<>fmiStatus.fmiError, "The FMI function fmiSetInteger for an input returned fmiError.");
      assert(ret5<>fmiStatus.fmiDiscard, "The FMI function fmiSetInteger for an input returned fmiDiscard.");
      ret6:=1;
      assert(ret6<>fmiStatus.fmiError, "The FMI function fmiSetBoolean for an input returned fmiError.");
      assert(ret6<>fmiStatus.fmiDiscard, "The FMI function fmiSetBoolean for an input returned fmiDiscard.");
      (retM, eventInfo):=EventUpdate(FMU, true, time, 1);
      assert(retM<>fmiStatus.fmiError, "The FMI function fmiEventUpdate returned fmiError.");
      assert(retM<>fmiStatus.fmiDiscard, "The FMI function fmiEventUpdate returned fmifmiDiscard.");


      if(eventInfo.d_terminateSimulation)then
        terminate("FMU requested termination of simulation run.");
      end if;
      if(eventInfo.a_iterationConverged==false)then
        bContinueEventIteration:=not(pre(bContinueEventIteration));
      end if;

    end if;
  algorithm
    if(analysisTypeDetail() == "validStep")then
      callEventUpdate:=false;
      (ret15, callEventUpdate):=CompletedIntegratorStep(FMU, time, ret1+ret2+ret3+ret12+retM);
      assert(ret15<>fmiStatus.fmiError, "The FMI function fmiCompletedIntegratorStep returned an error.");
      assert(ret15<>fmiStatus.fmiFatal, "The FMI function fmiCompletedIntegratorStep returned a fatal error.");
      if (ret15==fmiStatus.fmiWarning) then
        trace("The FMI function fmiCompletedIntegratorStep a warning");
      end if;
      if(callEventUpdate) then
        triggerEvent();
      end if;
    end if;
  annotation(defaultComponentName="last", Icon(
    coordinateSystem(extent={{-100,-100},{100,100}}),
    graphics={
      Rectangle(
        fillPattern=FillPattern.None,
        extent={{-100,-100},{100,100}})}));
end Last_simx;
