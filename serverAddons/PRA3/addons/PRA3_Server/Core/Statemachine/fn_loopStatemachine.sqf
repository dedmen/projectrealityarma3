#include "macros.hpp"
/*
    Project Reality ArmA 3

    Author: joko // Jonas

    Description:
    Loop for 1 Statemachine.

    Parameter(s):
    PFH Arguments

    Returns:
    None
*/
params ["_stateMachine", "_idPFH"];

private _currentState = _stateMachine getVariable SMVAR(nextStateData);
// check if current state exist in Namespace.
if (isNil "_currentState") exitWith {
    LOG("Error Next State is Nil")
    _idPFH call CFUNC(removePerFrameHandler);
};

private _stateData = if (_currentState isEqualType "") then {
    _stateMachine getVariable _currentState;
} else {
    _stateMachine getVariable (_currentState select 0);
};

// check if state data exist.
if (isNil "_stateData") exitWith {
    LOG("Error Next State is Unknown: " + _currentState)
    _idPFH call CFUNC(removePerFrameHandler);
};

_stateData params ["_code", "_args"];
/* TODO: this would require changes in the Event system.
if (_code isEqualType "") then {
    private _nextState = [_code, _args] call CFUNC(localEvent);
} else {
    private _nextState = _args call _code;
};
*/

private _nextState = if (_currentState isEqualType "") then {
    [_args, []] call _code;
} else {
    [_args, _currentState select 1] call _code;
};
private _nextStateName = if (_nextState isEqualType "") then {
    _nextState
} else {
    _nextState select 0;
};

if (_nextStateName in EGVAR(Statemachine,exitStateNames)) exitWith {
    [_stateMachine] call FUNC(killStatemachine);
};
_stateMachine setVariable [ SMVAR(nextStateData), _nextState];
