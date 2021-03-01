within LastLib;

model Last_dymola_windows "Last for Dymola on Windows"
  extends LastBase(u(start = _u_start));
  final parameter Real _u_start = 0. annotation(Dialog(group="Start values for inputs"));
  parameter String fmi_instanceName="Last_fmu" annotation(Dialog(tab="FMI", group="Instance name"));
  parameter Boolean fmi_loggingOn=false annotation(Dialog(tab="FMI", group="Enable logging"));
  constant Integer fmi_NumberOfContinuousStates = 0;
  constant Integer fmi_NumberOfEventIndicators = 0;
protected
  Real dummyState;
  fmi_Functions.fmiModel fmi;
  parameter Real fmi_Initialized(fixed=false);
  Real myTime;
  Boolean fmi_StepEvent;
  Boolean fmi_NewStates;
  Real fmi_TNext(start=fmi_TNext_Start,fixed=true);
  parameter Real fmi_TNext_Start(fixed=false);
package fmi_Functions
  class fmiModel
  extends ExternalObject;
    function constructor "Initialize FMI model"
      extends Modelica.Icons.Function;
      input String instanceName;
      input Boolean loggingOn;
      output fmiModel fmi;
      external"C" fmi = Last_fmiInstantiateModel2(instanceName, loggingOn)
      annotation(Header="
#ifndef Last_Instantiate_C
#define Last_Instantiate_C 1
#include <stdlib.h>
#include \"FMI/fmiImport.h\"
#ifndef Last_MYSTRCMP_C
#define Last_MYSTRCMP_C 1
int Lastmystrcmp(const void *_a, const void *_b) {
  char *a = _a;
  char *const *b = _b;
  return strcmp(a, *b);
}
#endif
void LastLogger(fmiComponent c, fmiString instanceName, fmiStatus status,
         fmiString category, fmiString message, ...) {
  char msg[4096];
  char buf[4096];
  int len;
  va_list ap;
  va_start(ap,message);
#if defined(_MSC_VER) && _MSC_VER>=1200
  len = _snprintf(msg, sizeof(msg)/sizeof(*msg), \"%s: %s\", instanceName, message);
  if (len < 0) goto fail;
  len = _vsnprintf(buf, sizeof(buf)/sizeof(*buf) - 2, msg, ap);
  if (len < 0) goto fail;
#else
  len = snprintf(msg, sizeof(msg)/sizeof(*msg), \"%s: %s\", instanceName, message);
  if (len < 0) goto fail;
  len = vsnprintf(buf, sizeof(buf)/sizeof(*buf) - 2, msg, ap);
  if (len < 0) goto fail;
#endif
  if( len>0 && len <4096 && buf[len - 1]!='\\n'){
    buf[len] = '\\n';
    buf[len + 1] = 0;
  }
  va_end(ap);
  switch (status) {
    case fmiFatal:
      ModelicaMessage(\"[fmiFatal]: \");
      break;
    case fmiError:
      ModelicaMessage(\"[fmiError]: \");
      break;
    case fmiDiscard:
      ModelicaMessage(\"[fmiDiscard]: \");
      break;
    case fmiWarning:
      ModelicaMessage(\"[fmiWarning]: \");
      break;
    case fmiOK:
      ModelicaMessage(\"[fmiOK]: \");
      break;
  }
  ModelicaMessage(buf);
  return;
fail:
  ModelicaMessage(\"Logger failed, message too long?\");
}
void * Last_fmiInstantiateModel2(const char*instanceName, fmiBoolean loggingOn) {
  static fmiMECallbackFunctions funcs = {&LastLogger, &calloc, &free};
  struct dy_Extended* res;

  res = calloc(1, sizeof(struct dy_Extended));
  if (res!=0) {
    if (!(res->hInst=LoadLibraryW(L\"Last.dll\"))) {
      ModelicaError(\"Loading of FMU dynamic link library (Last.dll) failed!\");
      return 0;
    }
    if (!(res->dyFmiInstantiateModel=(fmiInstantiateModelFunc)GetProcAddress(res->hInst,\"Last_fmiInstantiateModel\"))) {
      ModelicaError(\"GetProcAddress failed for fmiInstantiateModel!\\n The model was imported as a model exchange FMU but could not load the ME specific function fmiInstantiateModel\\n Verify that the FMU supports Model Exchange\");
      return 0;
    }
    if (!(res->dyFmiFreeModelInstance=(fmiFreeModelInstanceFunc)GetProcAddress(res->hInst,\"Last_fmiFreeModelInstance\"))) {
      ModelicaError(\"GetProcAddress failed for fmiFreeModelInstance!\\n The model was imported as a model exchange FMU but could not load the ME specific function fmiFreeModelInstance\\n Verify that the FMU supports Model Exchange\");
      return 0;
    }
    if (!(res->dyFmiSetTime=(fmiSetTimeFunc)GetProcAddress(res->hInst,\"Last_fmiSetTime\"))) {
      ModelicaError(\"GetProcAddress failed for fmiSetTime!\\n The model was imported as a model exchange FMU but could not load the ME specific function fmiSetTime\\n Verify that the FMU supports Model Exchange\");
      return 0;
    }
    if (!(res->dyFmiSetContinuousStates=(fmiSetContinuousStatesFunc)GetProcAddress(res->hInst,\"Last_fmiSetContinuousStates\"))) {
      ModelicaError(\"GetProcAddress failed for fmiSetContinuousStates!\\n The model was imported as a model exchange FMU but could not load the ME specific function fmiSetContinuousStates\\n Verify that the FMU supports Model Exchange\");
      return 0;
    }
    if (!(res->dyFmiGetContinuousStates=(fmiGetContinuousStatesFunc)GetProcAddress(res->hInst,\"Last_fmiGetContinuousStates\"))) {
      ModelicaError(\"GetProcAddress failed for fmiGetContinuousStates!\\n The model was imported as a model exchange FMU but could not load the ME specific function fmiGetContinuousStates\\n Verify that the FMU supports Model Exchange\");
      return 0;
    }
    if (!(res->dyFmiCompletedIntegratorStep=(fmiCompletedIntegratorStepFunc)GetProcAddress(res->hInst,\"Last_fmiCompletedIntegratorStep\"))) {
      ModelicaError(\"GetProcAddress failed for fmiCompletedIntegratorStep!\\n The model was imported as a model exchange FMU but could not load the ME specific function fmiCompletedIntegratorStep\\n Verify that the FMU supports Model Exchange\");
      return 0;
    }
    if (!(res->dyFmiEventUpdate=(fmiEventUpdateFunc)GetProcAddress(res->hInst,\"Last_fmiEventUpdate\"))) {
      ModelicaError(\"GetProcAddress failed for fmiEventUpdate!\\n The model was imported as a model exchange FMU but could not load the ME specific function fmiEventUpdate\\n Verify that the FMU supports Model Exchange\");
      return 0;
    }
    if (!(res->dyFmiInitialize=(fmiInitializeFunc)GetProcAddress(res->hInst,\"Last_fmiInitialize\"))) {
      ModelicaError(\"GetProcAddress failed for fmiInitialize!\\n The model was imported as a model exchange FMU but could not load the ME specific function fmiInitialize\\n Verify that the FMU supports Model Exchange\");
      return 0;
    }
    if (!(res->dyFmiGetDerivatives=(fmiGetDerivativesFunc)GetProcAddress(res->hInst,\"Last_fmiGetDerivatives\"))) {
      ModelicaError(\"GetProcAddress failed for fmiGetDerivatives!\\n The model was imported as a model exchange FMU but could not load the ME specific function fmiGetDerivatives\\n Verify that the FMU supports Model Exchange\");
      return 0;
    }
    if (!(res->dyFmiGetEventIndicators=(fmiGetEventIndicatorsFunc)GetProcAddress(res->hInst,\"Last_fmiGetEventIndicators\"))) {
      ModelicaError(\"GetProcAddress failed for fmiGetEventIndicators!\\n The model was imported as a model exchange FMU but could not load the ME specific function fmiGetEventIndicators\\n Verify that the FMU supports Model Exchange\");
      return 0;
    }
    if (!(res->dyFmiTerminate=(fmiTerminateFunc)GetProcAddress(res->hInst,\"Last_fmiTerminate\"))) {
      ModelicaError(\"GetProcAddress failed for fmiTerminate!\\n The model was imported as a model exchange FMU but could not load the ME specific function fmiTerminate\\n Verify that the FMU supports Model Exchange\");
      return 0;
    }
    if (!(res->dyFmiSetReal=(fmiSetRealFunc)GetProcAddress(res->hInst,\"Last_fmiSetReal\"))) {
      ModelicaError(\"GetProcAddress failed for fmiSetReal!\");
      return 0;
    }
    if (!(res->dyFmiGetReal=(fmiGetRealFunc)GetProcAddress(res->hInst,\"Last_fmiGetReal\"))) {
      ModelicaError(\"GetProcAddress failed for fmiGetReal!\");
      return 0;
    }
    if (!(res->dyFmiSetInteger=(fmiSetIntegerFunc)GetProcAddress(res->hInst,\"Last_fmiSetInteger\"))) {
      ModelicaError(\"GetProcAddress failed for fmiSetInteger!\");
      return 0;
    }
    if (!(res->dyFmiGetInteger=(fmiGetIntegerFunc)GetProcAddress(res->hInst,\"Last_fmiGetInteger\"))) {
      ModelicaError(\"GetProcAddress failed for fmiGetInteger!\");
      return 0;
    }
    if (!(res->dyFmiSetBoolean=(fmiSetBooleanFunc)GetProcAddress(res->hInst,\"Last_fmiSetBoolean\"))) {
      ModelicaError(\"GetProcAddress failed for fmiSetBoolean!\");
      return 0;
    }
    if (!(res->dyFmiGetBoolean=(fmiGetBooleanFunc)GetProcAddress(res->hInst,\"Last_fmiGetBoolean\"))) {
      ModelicaError(\"GetProcAddress failed for fmiGetBoolean!\");
      return 0;
    }
    if (!(res->dyFmiSetString=(fmiSetStringFunc)GetProcAddress(res->hInst,\"Last_fmiSetString\"))) {
      ModelicaError(\"GetProcAddress failed for fmiSetString!\");
      return 0;
    }
    if (!(res->dyFmiGetString=(fmiGetStringFunc)GetProcAddress(res->hInst,\"Last_fmiGetString\"))) {
      ModelicaError(\"GetProcAddress failed for fmiGetString!\");
      return 0;
    }
    if (!(res->dyFmiSetDebugLogging=(fmiSetDebugLoggingFunc)GetProcAddress(res->hInst,\"Last_fmiSetDebugLogging\"))) {
      ModelicaError(\"GetProcAddress failed for fmiSetDebugLogging!\");
      return 0;
    }
    res->m=res->dyFmiInstantiateModel(instanceName, \"{31D2AA2B-E012-46F6-9BD9-1B99F9AF38D1}\", funcs, loggingOn);
    if (0==res->m) {free(res);res=0;ModelicaError(\"InstantiateModel failed\");}
    else {res->dyTriggered=0;res->dyTime=res->dyLastTime=-1e37;res->dyFirstTimeEvent=1e37;res->currentMode=dyInstantiationMode;}
  }
  return res;
}
#endif", Library="Last", LibraryDirectory="modelica://LastLib/Resources/binaries", __Dymola_CriticalRegion="Last");
    end constructor;

    function destructor "Release storage of FMI model"
      extends Modelica.Icons.Function;
      input fmiModel fmi;
      external"C"Last_fmiFreeModelInstance2(fmi);
      annotation (Header="
#ifndef Last_Free_C
#define Last_Free_C 1
#include <stdlib.h>
#include \"FMI/fmiImport.h\"
void Last_fmiFreeModelInstance2(void*m) {
  struct dy_Extended*a=m;
  if (a) {
    a->dyFmiTerminate(a->m);
    a->dyFmiFreeModelInstance(a->m);
    FreeLibrary(a->hInst);
    free(a);
  }
}
#endif", Library="Last", LibraryDirectory="modelica://LastLib/Resources/binaries", __Dymola_CriticalRegion="Last");
    end destructor;
  end fmiModel;

    function fmiSetTime
      input fmiModel fmi;
      input Real ti;
      external"C" Last_fmiSetTime2(fmi, ti);
      annotation (Header="
#ifndef Last_SetTime_C
#define Last_SetTime_C 1
#include <stdlib.h>
#include \"FMI/fmiImport.h\"
void Last_fmiSetTime2(void*m, double ti) {
  struct dy_Extended*a=m;
  fmiStatus status=fmiFatal;
  if (a) {
    if(a->currentMode==dyInstantiationMode){
      a->dyTime=ti;
      status=a->dyFmiSetTime(a->m, ti);
    }else if(ti>a->dyTime || (a->currentMode==dyEventMode && ti==a->dyTime && !isModelicaEvent())){
      a->currentMode=dyContinuousTimeMode;
      a->dyTime=ti;
      status=a->dyFmiSetTime(a->m, ti);
    }else if(ti <= a->dyTime && a->currentMode == dyContinuousTimeMode){
      a->dyTime=ti;
      status=a->dyFmiSetTime(a->m, ti);
    }else{
      status=fmiOK;
    }
  }
  if (status!=fmiOK ) ModelicaError(\"SetTime failed\");
}
#endif", Library="Last", LibraryDirectory="modelica://LastLib/Resources/binaries", __Dymola_CriticalRegion="Last");
    end fmiSetTime;

    function fmiSetContinuousStates
      input fmiModel fmi;
      input Real x[:];
      external"C" Last_fmiSetContinuousStates2(
        fmi,
        x,
        size(x, 1));
      annotation (Header="
#ifndef Last_SetContinuousStates_C
#define Last_SetContinuousStates_C 1
#include <stdlib.h>
#include \"FMI/fmiImport.h\"
void Last_fmiSetContinuousStates2(void*m, const double*x, size_t nx) {
  struct dy_Extended*a=m;
  fmiStatus status=fmiFatal;
  if (a) {
    if(a->currentMode==dyContinuousTimeMode){
      status=a->dyFmiSetContinuousStates(a->m, x, nx);
    }else{
      status=fmiOK;
    }
  }
  if (status!=fmiOK && status!=fmiWarning) ModelicaError(\"SetContinuousStates failed\");
}
#endif", Library="Last", LibraryDirectory="modelica://LastLib/Resources/binaries", __Dymola_CriticalRegion="Last");
    end fmiSetContinuousStates;

    function fmiGetContinuousStates
      input fmiModel fmi;
      input Integer nx;
      output Real x[nx];
      external"C" Last_fmiGetContinuousStates2(
        fmi,
        x,
        nx);
      annotation (Header="
#ifndef Last_GetContinuousStates_C
#define Last_GetContinuousStates_C 1
#include <stdlib.h>
#include \"FMI/fmiImport.h\"
void Last_fmiGetContinuousStates2(void*m, double*x, int nx) {
  struct dy_Extended*a=m;
  fmiStatus status=fmiFatal;
  if (a) {
    status=a->dyFmiGetContinuousStates(a->m, x, nx);
  }
  if (status!=fmiOK && status!=fmiWarning) ModelicaError(\"GetContinuousStates failed\");
}
#endif", Library="Last", LibraryDirectory="modelica://LastLib/Resources/binaries", __Dymola_CriticalRegion="Last");
    end fmiGetContinuousStates;

    function fmiCompletedStep
      input fmiModel fmi;
      output Real crossing;
      external"C" crossing = Last_fmiCompletedStep2(fmi);
      annotation (Header="
#ifndef Last_CompletedStep_C
#define Last_CompletedStep_C 1
#include <stdlib.h>
#include \"FMI/fmiImport.h\"
double Last_fmiCompletedStep2(void*m) {
  struct dy_Extended*a=m;
  fmiStatus status=fmiFatal;
  if (a) {
    if (a->dyTime>a->dyLastTime) {
      fmiBoolean b=0;
      status=a->dyFmiCompletedIntegratorStep(a->m, &b);
      a->dyLastTime=a->dyTime;
      if (b) a->dyTriggered=1;
    } else status=fmiOK;
  }
  if (status!=fmiOK && status!=fmiWarning) ModelicaError(\"CompletedIntegratorStep failed\");
  return a->dyTriggered && a->dyTime>=a->dyLastTime;
}
#endif", Library="Last", LibraryDirectory="modelica://LastLib/Resources/binaries", __Dymola_CriticalRegion="Last");
    end fmiCompletedStep;

    function CompletedStep
      input fmiModel fmi;
      output Real crossing;
      input Real dummyTime;
      input Real realInputs[:];
      input Integer integerInputs[:];
      input Boolean booleanInputs[:];
      input Integer realInputValueReferences[:];
      input Integer integerInputValueReferences[:];
      input Integer booleanInputValueReferences[:];
    algorithm
      fmiSetReal(fmi,realInputValueReferences,realInputs);
      fmiSetBoolean(fmi,booleanInputValueReferences,booleanInputs);
      fmiSetInteger(fmi,integerInputValueReferences,integerInputs);
      crossing := fmiCompletedStep(fmi);
      annotation(LateInline=true);
    end CompletedStep;

    function fmiEventUpdate
      input fmiModel fmi;
      output Real tnext;
      output Boolean stateReset;
      external"C" stateReset = Last_fmiEventUpdate2(fmi, tnext);
      annotation(Header="
#ifndef Last_EventUpdate_C
#define Last_EventUpdate_C 1
#include <stdlib.h>
#include \"FMI/fmiImport.h\"
int Last_fmiEventUpdate2(void*m, double*tnext){
  struct dy_Extended*a=m;
  fmiEventInfo ev;
  fmiStatus status=fmiFatal;
  ev.nextEventTime=1e37;
  if (a) {
    if(a->currentMode==dyContinuousTimeMode){
      fmiBoolean b;
      status=a->dyFmiCompletedIntegratorStep(a->m, &b);
      a->currentMode=dyEventMode;
    }
    status=a->dyFmiEventUpdate(a->m, 0, &ev);
    a->dyTriggered=0;
    a->dyLastTime=a->dyTime;
  }
  if (ev.terminateSimulation) terminate(\"Terminate signaled by FMU\");
  if (status!=fmiOK && status!=fmiWarning) ModelicaError(\"EventUpdate failed\");
  *tnext=ev.nextEventTime;
  return ev.stateValuesChanged;
}
#endif", Library="Last", LibraryDirectory="modelica://LastLib/Resources/binaries", __Dymola_CriticalRegion="Last");
    end fmiEventUpdate;

    function EventUpdate
      input fmiModel fmi;
      output Real tnext;
      output Boolean stateReset;
      input Real dummyTime;
      input Real realInputs[:];
      input Integer integerInputs[:];
      input Boolean booleanInputs[:];
      input Integer realInputValueReferences[:];
      input Integer integerInputValueReferences[:];
      input Integer booleanInputValueReferences[:];
    algorithm
      fmiSetReal(fmi,realInputValueReferences,realInputs);
      fmiSetBoolean(fmi,booleanInputValueReferences,booleanInputs);
      fmiSetInteger(fmi,integerInputValueReferences,integerInputs);
      (tnext, stateReset) := fmiEventUpdate(fmi);
      annotation(LateInline=true);
    end EventUpdate;

    function fmiInitialize
      input fmiModel fmi;
      output Real tnext;
      output Real initialized=1;
      external"C" tnext = Last_fmiInitialize2(fmi);
      annotation (Header="
#ifndef Last_Initialize_C
#define Last_Initialize_C 1
#include <stdlib.h>
#include \"FMI/fmiImport.h\"
double Last_fmiInitialize2(void*m) {
  struct dy_Extended*a=m;
  fmiStatus status=fmiFatal;
  fmiBoolean toleranceControlled=fmiFalse;
  fmiReal tolerance=0;
  fmiEventInfo ev;
  ev.nextEventTime=1e37;
  if (a) {
    if(a->currentMode == dyInstantiationMode){
      status=a->dyFmiInitialize(a->m, toleranceControlled, tolerance, &ev);
      a->currentMode=dyEventMode;
      a->dyTriggered=0;
      a->dyLastTime=a->dyTime;
      a->dyFirstTimeEvent=ev.nextEventTime;
    }else{
      status=fmiOK;
    }
  }
  if (status!=fmiOK && status!=fmiWarning) ModelicaError(\"Initialize failed\");
  return a->dyFirstTimeEvent;
}
#endif", Library="Last", LibraryDirectory="modelica://LastLib/Resources/binaries", __Dymola_CriticalRegion="Last");
    end fmiInitialize;

    function fmiGetDerivatives
    input fmiModel fmi;
    input Integer nx;
    output Real dx[nx];
    external"C" Last_fmiGetDerivatives2(
      fmi,
      dx,
      nx);
      annotation (Header="
#ifndef Last_GetDerivatives_C
#define Last_GetDerivatives_C 1
#include <stdlib.h>
#include \"FMI/fmiImport.h\"
void Last_fmiGetDerivatives2(void*m,double*dx,int nx) {
  struct dy_Extended*a=m;
  fmiStatus status=fmiFatal;
  if (a) {
    status=a->dyFmiGetDerivatives(a->m, dx, nx);
  }
  if (status!=fmiOK && status!=fmiWarning) ModelicaError(\"GetDerivatives failed\");
}
#endif", Library="Last", LibraryDirectory="modelica://LastLib/Resources/binaries", __Dymola_CriticalRegion="Last");
    end fmiGetDerivatives;

    function GetDerivatives
      input fmiModel fmi;
      input Integer nx;
      output Real dx[nx];
      input Real dummyTime;
      input Real realInputs[:];
      input Integer integerInputs[:];
      input Boolean booleanInputs[:];
      input Integer realInputValueReferences[:];
      input Integer integerInputValueReferences[:];
      input Integer booleanInputValueReferences[:];
    algorithm
      fmiSetReal(fmi,realInputValueReferences,realInputs);
      fmiSetBoolean(fmi,booleanInputValueReferences,booleanInputs);
      fmiSetInteger(fmi,integerInputValueReferences,integerInputs);
      dx := fmiGetDerivatives(fmi, nx);
      annotation(LateInline=true);
    end GetDerivatives;

    function fmiGetEventIndicators
      input fmiModel fmi;
      input Integer nz;
      output Real z[nz];
      external"C" Last_fmiGetEventIndicators2(
        fmi,
        z,
        nz);
      annotation (Header="
#ifndef Last_GetEventIndicators_C
#define Last_GetEventIndicators_C 1
#include <stdlib.h>
#include \"FMI/fmiImport.h\"
void Last_fmiGetEventIndicators2(void*m,double*z,int nz) {
  struct dy_Extended*a=m;
  fmiStatus status=fmiFatal;
  if (a) {
    status=a->dyFmiGetEventIndicators(a->m, z, nz);
  }
  if (status!=fmiOK && status!=fmiWarning) ModelicaError(\"GetEventIndicators failed\");
}
#endif", Library="Last", LibraryDirectory="modelica://LastLib/Resources/binaries", __Dymola_CriticalRegion="Last");
    end fmiGetEventIndicators;

    function GetEventIndicators
      input fmiModel fmi;
      input Integer nz;
      output Real z[nz];
      input Real dummyTime;
      input Real realInputs[:];
      input Integer integerInputs[:];
      input Boolean booleanInputs[:];
      input Integer realInputValueReferences[:];
      input Integer integerInputValueReferences[:];
      input Integer booleanInputValueReferences[:];
    algorithm
      fmiSetReal(fmi,realInputValueReferences,realInputs);
      fmiSetBoolean(fmi,booleanInputValueReferences,booleanInputs);
      fmiSetInteger(fmi,integerInputValueReferences,integerInputs);
      z := fmiGetEventIndicators(fmi, nz);
      annotation(LateInline=true);
    end GetEventIndicators;

    function GetOutput
      input fmiModel fmi;
      input Real Time;
      input Integer outputValueReference[1];
      output Real outputVariable;
      input Real realInputs[:];
      input Integer integerInputs[:];
      input Boolean booleanInputs[:];
      input Integer realInputValueReferences[:];
      input Integer integerInputValueReferences[:];
      input Integer booleanInputValueReferences[:];
    algorithm
      fmiSetReal(fmi,realInputValueReferences,realInputs);
      fmiSetBoolean(fmi,booleanInputValueReferences,booleanInputs);
      fmiSetInteger(fmi,integerInputValueReferences,integerInputs);
      outputVariable:=fmiGetRealScalar(fmi,outputValueReference[1],1);
      annotation(LateInline=true);
    end GetOutput;

    function fmiSetReal
      input fmiModel fmi;
      input Integer refs[:];
      input Real vals[size(refs, 1)];
      output Real dummy= 1;
      external"C"Last_fmiSetReal2(
        fmi,
        refs,
        size(refs, 1),
        vals);
        annotation (Header="
#ifndef Last_SetReal_C
#define Last_SetReal_C 1
#include <stdlib.h>
#include \"FMI/fmiImport.h\"
void Last_fmiSetReal2(void*m, const int*refs, size_t nrefs, const double*vals) {
  struct dy_Extended*a=m;
  fmiStatus status=fmiFatal;
  if(!nrefs){return;}
  if (a) {
    status=a->dyFmiSetReal(a->m, refs, nrefs, vals);
  }
  if (status!=fmiOK && status!=fmiWarning) ModelicaError(\"SetReal failed\");
}
#endif", Library="Last", LibraryDirectory="modelica://LastLib/Resources/binaries", __Dymola_CriticalRegion="Last",__Dymola_IdemPotent=true, __Dymola_VectorizedExceptFirst=true);
    end fmiSetReal;

    function fmiSetRealParam
      input fmiModel fmi;
      input Integer refs[:];
      input Real vals[size(refs, 1)];
    protected
      Real oldVals[size(refs, 1)];
      external"C"Last_fmiSetRealParam2(
        fmi,
        refs,
        size(refs, 1),
        vals,
        oldVals);
        annotation (Header="
#ifndef Last_SetRealParam_C
#define Last_SetRealParam_C 1
#include <stdlib.h>
#include \"FMI/fmiImport.h\"
void Last_fmiSetRealParam2(void*m, const int*refs, size_t nrefs, const double*vals, double*oldVals) {
  struct dy_Extended*a=m;
  fmiStatus status=fmiFatal;
  int i = 0;
  if(!nrefs){return;}
  if (a) {
    if(a->currentMode == dyInstantiationMode){
                status=a->dyFmiSetReal(a->m, refs, nrefs, vals);
    }else{
      status=a->dyFmiGetReal(a->m, refs, nrefs, oldVals);
      for(i=0; i<nrefs;++i){
        if( abs(vals[i]-oldVals[i])> 5e-16){
          ModelicaError(\"SetRealParameter: new parameters with diferent values are being set after initialization, this is not allowed\");
        }
      }
    }
  }
  if (status!=fmiOK && status!=fmiWarning) ModelicaError(\"SetReal failed\");
}
#endif", Library="Last", LibraryDirectory="modelica://LastLib/Resources/binaries", __Dymola_CriticalRegion="Last",__Dymola_IdemPotent=true, __Dymola_VectorizedExceptFirst=true);
    end fmiSetRealParam;

    function fmiGetRealScalar
      input fmiModel fmi;
      input Integer ref;
      input Real dummy;
      output Real val;
    algorithm
        val := scalar(fmiGetReal(fmi, {ref}, dummy));
    end fmiGetRealScalar;

    function fmiGetReal
      input fmiModel fmi;
      input Integer refs[:];
      output Real vals[size(refs, 1)];
      input Real preAvailable;
      external"C" Last_fmiGetReal2(
        fmi,
        refs,
        size(refs, 1),
        vals);
      annotation (Header="
#ifndef Last_GetReal_C
#define Last_GetReal_C 1
#include <stdlib.h>
#include \"FMI/fmiImport.h\"
void Last_fmiGetReal2(void*m, const int*refs, size_t nrefs, double*vals) {
  struct dy_Extended*a=m;
  fmiStatus status=fmiFatal;
  if (a) {
    status=a->dyFmiGetReal(a->m, refs, nrefs, vals);
  }
  if (status!=fmiOK && status!=fmiWarning) ModelicaError(\"GetReal failed\");
}
#endif", Library="Last", LibraryDirectory="modelica://LastLib/Resources/binaries", __Dymola_CriticalRegion="Last");
    end fmiGetReal;

    function fmiGetIntegerScalar
      input fmiModel fmi;
      input Integer ref;
      input Integer dummy;
      output Integer val;
    algorithm
        val := scalar(fmiGetInteger(fmi, {ref}, dummy));
    end fmiGetIntegerScalar;

    function fmiGetInteger
      input fmiModel fmi;
      input Integer refs[:];
      output Integer vals[size(refs, 1)];
      input Integer preAvailable;
      external"C" Last_fmiGetInteger2(
        fmi,
        refs,
        size(refs, 1),
        vals);
      annotation (Header="
#ifndef Last_GetInteger_C
#define Last_GetInteger_C 1
#include <stdlib.h>
#include \"FMI/fmiImport.h\"
void Last_fmiGetInteger2(void*m, const int*refs, size_t nrefs, int*vals) {
  struct dy_Extended*a=m;
  fmiStatus status=fmiFatal;
  if (a) {
    status=a->dyFmiGetInteger(a->m, refs, nrefs, vals);
  }
  if (status!=fmiOK && status!=fmiWarning) ModelicaError(\"GetInteger failed\");
}
#endif", Library="Last", LibraryDirectory="modelica://LastLib/Resources/binaries", __Dymola_CriticalRegion="Last");
    end fmiGetInteger;

    function fmiSetInteger
    input fmiModel fmi;
      input Integer refs[:];
      input Integer vals[size(refs, 1)];
      output Real dummy= 1;
      external"C" Last_fmiSetInteger2(
        fmi,
        refs,
        size(refs, 1),
        vals);
        annotation (Header="
#ifndef Last_SetInteger_C
#define Last_SetInteger_C 1
#include <stdlib.h>
#include \"FMI/fmiImport.h\"
void Last_fmiSetInteger2(void*m, const int*refs, size_t nrefs, int*vals) {
  struct dy_Extended*a=m;
  fmiStatus status=fmiFatal;
  if(!nrefs){return;}
  if (a) {
    status=a->dyFmiSetInteger(a->m, refs, nrefs, vals);
  }
  if (status!=fmiOK && status!=fmiWarning) ModelicaError(\"SetInteger failed\");
}
#endif", Library="Last", LibraryDirectory="modelica://LastLib/Resources/binaries", __Dymola_CriticalRegion="Last",__Dymola_IdemPotent=true, __Dymola_VectorizedExceptFirst=true);
    end fmiSetInteger;

    function fmiSetIntegerParam
    input fmiModel fmi;
      input Integer refs[:];
      input Integer vals[size(refs, 1)];
    protected
      Integer oldVals[size(refs, 1)];
      external"C" Last_fmiSetIntegerParam2(
        fmi,
        refs,
        size(refs, 1),
        vals,
        oldVals);
        annotation (Header="
#ifndef Last_SetIntegerParam_C
#define Last_SetIntegerParam_C 1
#include <stdlib.h>
#include \"FMI/fmiImport.h\"
void Last_fmiSetIntegerParam2(void*m, const int*refs, size_t nrefs, int*vals, int*oldVals) {
  struct dy_Extended*a=m;
  fmiStatus status=fmiFatal;
  int i=0;
  if(!nrefs){return;}
  if (a) {
    if(a->currentMode == dyInstantiationMode){
      status=a->dyFmiSetInteger(a->m, refs, nrefs, vals);
    }else{
      status=a->dyFmiGetInteger(a->m, refs, nrefs, oldVals);
      for(i = 0; i< nrefs; ++i){
        if(vals[i]!=oldVals[i]){
          ModelicaError(\"SetIntegerParameter: new parameters with diferent values are being set after initialization, this is not allowed\");
        }
      }
    }
  }
  if (status!=fmiOK && status!=fmiWarning) ModelicaError(\"SetInteger failed\");
}
#endif", Library="Last", LibraryDirectory="modelica://LastLib/Resources/binaries", __Dymola_CriticalRegion="Last",__Dymola_IdemPotent=true, __Dymola_VectorizedExceptFirst=true);
    end fmiSetIntegerParam;

    function fmiGetBooleanScalar
      input fmiModel fmi;
      input Integer ref;
      input Integer dummy;
      output Boolean val;
    algorithm
        val := scalar(fmiGetBoolean(fmi, {ref}, dummy));
    end fmiGetBooleanScalar;

    function fmiGetBoolean
      input fmiModel fmi;
      input Integer refs[:];
      output Boolean vals[size(refs, 1)];
      input Integer preAvailable;
      external"C" Last_fmiGetBoolean2(
        fmi,
        refs,
        size(refs, 1),
        vals);
        annotation (Header="
#ifndef Last_GetBoolean_C
#define Last_GetBoolean_C 1
#include \"FMI/fmiImport.h\"
void Last_fmiGetBoolean2(void*m, const int* refs, size_t nr, int* vals) {
  int i;
  struct dy_Extended*a=m;
  fmiStatus status=fmiFatal;
  if (a) {
    status=a->dyFmiGetBoolean(a->m, refs, nr, (fmiBoolean*)(vals));
  }
  if (status!=fmiOK && status!=fmiWarning) ModelicaError(\"GetBoolean failed\");
  for(i=nr-1;i>=0;i--) vals[i]=((fmiBoolean*)(vals))[i];
}
#endif", Library="Last", LibraryDirectory="modelica://LastLib/Resources/binaries", __Dymola_CriticalRegion="Last");
    end fmiGetBoolean;

    function fmiSetBoolean
      input fmiModel fmi;
      input Integer refs[:];
      input Boolean vals[size(refs, 1)];
      output Real dummy2= 1;
    protected
      Boolean dummy[size(refs, 1)];
      external"C" Last_fmiSetBoolean2(
        fmi,
        refs,
        size(refs, 1),
        vals,
        dummy);
        annotation (Header="
#ifndef Last_SetBoolean_C
#define Last_SetBoolean_C 1
#include \"FMI/fmiImport.h\"
void Last_fmiSetBoolean2(void*m, const int* refs, size_t nr, const int* vals,int*dummy) {
  int i;
  struct dy_Extended*a=m;
  fmiStatus status=fmiFatal;
  if(!nr){return;}
  for(i=0;i<nr;++i) ((fmiBoolean*)(dummy))[i]=vals[i];
  if (a) {
    status=a->dyFmiSetBoolean(a->m, refs, nr, (fmiBoolean*)(dummy));
  }
  if (status!=fmiOK && status!=fmiWarning) ModelicaError(\"SetBoolean failed\");
}
#endif", Library="Last", LibraryDirectory="modelica://LastLib/Resources/binaries", __Dymola_CriticalRegion="Last",__Dymola_IdemPotent=true, __Dymola_VectorizedExceptFirst=true);
    end fmiSetBoolean;

    function fmiSetBooleanParam
      input fmiModel fmi;
      input Integer refs[:];
      input Boolean vals[size(refs, 1)];
    protected
      Boolean dummy[size(refs, 1)];
      Boolean oldVals[size(refs, 1)];
      external"C" Last_fmiSetBooleanParam2(
      fmi,
        refs,
        size(refs, 1),
        vals,
        dummy,
        oldVals);
        annotation (Header="
#ifndef Last_SetBooleanParam_C
#define Last_SetBooleanParam_C 1
#include \"FMI/fmiImport.h\"
void Last_fmiSetBooleanParam2(void*m, const int* refs, size_t nr, const int* vals,int*dummy,int*oldVals) {
  int i;
  struct dy_Extended*a=m;
  fmiStatus status=fmiFatal;
  if(!nr){return;}
  for(i=0;i<nr;++i) ((fmiBoolean*)(dummy))[i]=vals[i];
  if (a) {
    if(a->currentMode == dyInstantiationMode){
      status=a->dyFmiSetBoolean(a->m, refs, nr, (fmiBoolean*)(dummy));
    }else{
      status=a->dyFmiGetBoolean(a->m, refs, nr, (fmiBoolean*)(oldVals));
      for(i=nr-1;i>=0;i--){
        oldVals[i]=((fmiBoolean*)(oldVals))[i];
        if(oldVals[i]!=dummy[i]){
          ModelicaError(\"SetIntegerParameter: new parameters with diferent values are being set after initialization, this is not allowed\");
        }
      }
    }
  }
  if (status!=fmiOK && status!=fmiWarning) ModelicaError(\"SetBoolean failed\");
}
#endif", Library="Last", LibraryDirectory="modelica://LastLib/Resources/binaries", __Dymola_CriticalRegion="Last",__Dymola_IdemPotent=true, __Dymola_VectorizedExceptFirst=true);
    end fmiSetBooleanParam;

    function fmiGetString
      input fmiModel fmi;
      input Integer refs[:];
      output String vals[size(refs, 1)];
      input Integer preAvailable;
      external"C" Last_fmiGetString2(
        fmi,
        refs,
        size(refs, 1),
        vals);
      annotation (Header="
#ifndef Last_GetString_C
#define Last_GetString_C 1
#include <stdlib.h>
#include \"FMI/fmiImport.h\"
void Last_fmiGetString2(void*m, const int*refs, size_t nrefs, fmiString* vals) {
  struct dy_Extended*a=m;
  fmiStatus status=fmiFatal;
  if (a) {
    status=a->dyFmiGetString(a->m, refs, nrefs, vals);
  }
  if (status!=fmiOK && status!=fmiWarning) ModelicaError(\"StringInteger failed\");
}
#endif", Library="Last", LibraryDirectory="modelica://LastLib/Resources/binaries", __Dymola_CriticalRegion="Last");
    end fmiGetString;

    function fmiSetString
    input fmiModel fmi;
      input Integer refs[:];
      input String vals[size(refs, 1)];
      external"C" Last_fmiSetString2(
        fmi,
        refs,
        size(refs, 1),
        vals);
        annotation (Header="
#ifndef Last_SetString_C
#define Last_SetString_C 1
#include \"FMI/fmiImport.h\"
#include <stdlib.h>
void Last_fmiSetString2(void*m, const int*refs, size_t nrefs, const fmiString vals[]) {
  struct dy_Extended*a=m;
  fmiStatus status=fmiFatal;
  if(!nrefs){return;}
  if (a) {
    status=a->dyFmiSetString(a->m, refs, nrefs, vals);
  }
  if (status!=fmiOK && status!=fmiWarning) ModelicaError(\"SetString failed\");
}
#endif", Library="Last", LibraryDirectory="modelica://LastLib/Resources/binaries", __Dymola_CriticalRegion="Last",__Dymola_IdemPotent=true, __Dymola_VectorizedExceptFirst=true);
    end fmiSetString;

    function fmiSetStringParam
    input fmiModel fmi;
      input Integer refs[:];
      input String vals[size(refs, 1)];
      external"C" Last_fmiSetStringParam2(
        fmi,
        refs,
        size(refs, 1),
        vals);
        annotation (Header="
#ifndef Last_SetStringParam_C
#define Last_SetStringParam_C 1
#include \"FMI/fmiImport.h\"
#include <stdlib.h>
void Last_fmiSetStringParam2(void*m, const int*refs, size_t nrefs, const fmiString vals[]) {
  struct dy_Extended*a=m;
  fmiStatus status=fmiFatal;
  if(!nrefs){return;}
  if (a) {
    if(a->currentMode == dyInstantiationMode){
                status=a->dyFmiSetString(a->m, refs, nrefs, vals);
    }else{
      status=fmiOK;
    }
  }
  if (status!=fmiOK && status!=fmiWarning) ModelicaError(\"SetString failed\");
}
#endif", Library="Last", LibraryDirectory="modelica://LastLib/Resources/binaries", __Dymola_CriticalRegion="Last",__Dymola_IdemPotent=true, __Dymola_VectorizedExceptFirst=true);
    end fmiSetStringParam;

    function noHysteresis
      input Real x;
      output Real y;
    algorithm
      y:=x+(if (x < 0) then -1 else 1);
    end noHysteresis;
end fmi_Functions;
equation
  when initial() then
    fmi = fmi_Functions.fmiModel(fmi_instanceName, fmi_loggingOn);
  end when;
  fmi_StepEvent = fmi_Functions.CompletedStep(fmi, myTime, {u}, fill(0,0), fill(false,0), {536870912}, fill(0,0), fill(0,0))>0.5;
  when {time>=pre(fmi_TNext), fmi_StepEvent, not initial()} then
    (fmi_TNext, fmi_NewStates) =  fmi_Functions.EventUpdate(fmi, myTime, {u}, fill(0,0), fill(false,0), {536870912}, fill(0,0), fill(0,0));
  end when;
algorithm
  fmi_Functions.fmiSetTime(fmi, time);
  myTime := time;
  dummyState :=fmi_Initialized;
initial algorithm
 // 1 Real parameters
  fmi_Functions.fmiSetRealParam(fmi, {1073741824}, {y_start});
 // 0 Real start values
 // 0 Integer parameters
 // 0 Integer start values
 // 0 Boolean parameters
 // 0 Boolean start values
 // 0 Enumeration parameters
 // 0 Enumeration start values
 // 0 String parameters
 // Set InitalInputs
  fmi_Functions.fmiSetReal(fmi, {536870912}, {_u_start});
  fmi_Functions.fmiSetTime(fmi, time);
  (fmi_TNext_Start,fmi_Initialized) :=fmi_Functions.fmiInitialize(fmi);
equation
  y =  fmi_Functions.GetOutput(fmi,myTime,{805306368}, {u},fill(0,0), fill(false,0), {536870912}, fill(0,0), fill(0,0));
  annotation(defaultComponentName="last", experiment(StartTime=0, StopTime=1, Tolerance=1e-005),
    Icon(graphics={
      Rectangle(
        extent={{-100,100},{100,-100}},
        lineColor={95,95,95},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        lineThickness=0.5),
      Text(
        extent={{-70,20},{70,-20}},
        lineColor={0,0,255},
        textString="%name"),
      Text(
        extent={{-70,-72},{70,-94}},
        lineColor={95,95,95},
        textString="FMI 1.0 ME")}),
Documentation(info="<html>
<h4>ModelDescription Attributes</h4>
<ul>
<li>fmiVersion = 1.0</li>
<li>modelName = Last</li>
<li>generationTool = SimulationX 3.6.5.34033 (02/26/15) x64</li>
<li>generationDateAndTime = 2017-10-15T14:09:53</li>
</ul>
</html>"));
end Last_dymola_windows;
