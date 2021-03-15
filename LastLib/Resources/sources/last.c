// define class name and unique id
#define MODEL_IDENTIFIER Last
#define MODEL_GUID "{31D2AA2B-E012-46F6-9BD9-1B99F9AF38D1}"

// define model size
#define NUMBER_OF_REALS 3
#define NUMBER_OF_INTEGERS 0
#define NUMBER_OF_BOOLEANS 0
#define NUMBER_OF_STRINGS 0
#define NUMBER_OF_STATES 0
#define NUMBER_OF_EVENT_INDICATORS 0

// include fmu header files, typedefs and macros
#include "fmuTemplate.h"

// define all model variables and their value references
// conventions used here:
// - if x is a variable, then macro x_ is its variable reference
// - the vr of a variable is its index in array  r, i, b or s
// - if k is the vr of a real state, then k+1 is the vr of its derivative
#define y_start_ (0)
#define u_ (1)
#define y_ (2)
static const char* realVarNames[NUMBER_OF_REALS] = {"y_start", "u", "y"};

// called by fmiInstantiateModel
// Set values for all variables that define a start value
// Settings used unless changed by fmiSetX before fmiInitialize
void setStartValues(ModelInstance *comp) {
    r(y_start_) = 0.;
    r(u_) = 0.;
}

// called by fmiInitialize() after setting eventInfo to defaults
// Used to set the first time event, if any.
void initialize(ModelInstance* comp, fmiEventInfo* eventInfo) {
    r(u_) = r(y_start_);
    r(y_) = r(y_start_);
}

// called by fmiCompletedIntegratorStep()
void completedIntegratorStep(ModelInstance* comp) {
    r(y_) = r(u_);
}

// called by fmiGetReal, fmiGetContinuousStates and fmiGetDerivatives
fmiReal getReal(ModelInstance* comp, fmiValueReference vr) {
    switch (vr) {
        case y_start_:
            return r(y_start_);
        case u_:
            return r(u_);
        case y_:
            return r(y_);
        default: return 0;
    }
}

// Used to set the next time event, if any.
void eventUpdate(ModelInstance* comp, fmiEventInfo* eventInfo) {
}

// include code that implements the FMI based on the above definitions
#include "fmuTemplate.c"
