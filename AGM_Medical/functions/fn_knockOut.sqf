/*
 * By: KoffeinFlummi
 *
 * Knocks the given player out by ragdollizing him and stopping all movement, thereby making it impossible to differentiate between a dead and unconcious player.
 *
 * Arguments:
 * 0: Unit to be knocked out (Object)
 *
 * Return Values:
 * None
 */

private ["_unit", "_newGroup"];

_unit = _this select 0;
_duration = -1;
if (count _this > 1) then {
  _duration = _this select 1;
};
if !(isPlayer _unit or _unit getVariable ["AGM_AllowUnconscious", false]) exitWith {_unit setDamage 1;};

_unit setVariable ["AGM_Unconscious", true, true];
_unit setVariable ["AGM_CanTreat", false, true];

if (_unit == player) then {
  player setVariable ["tf_globalVolume", 0.4];
  player setVariable ["tf_voiceVolume", 0, true];
  player setVariable ["tf_unable_to_use_radio", true, true];

  player setVariable ["acre_sys_core_isDisabled", true, true];
  player setVariable ["acre_sys_core_globalVolume", 0.4];

  [true, true] call AGM_Core_fnc_disableUserInput;
};

_unit setCaptive 213;

_unit disableAI "MOVE";
_unit disableAI "ANIM";
_unit disableAI "TARGET";
_unit disableAI "AUTOTARGET";
_unit disableAI "FSM";

if (vehicle _unit != _unit && {animationState _unit != "Unconscious"}) then {   // don't lock into unconsciousness state after waking up
  _unit setVariable ["AGM_OriginalAnim", animationState _unit, true];
  [player, format ["{_this playMoveNow '%1'}", ((configfile >> 'CfgMovesMaleSdr' >> 'States' >> animationState _unit >> 'interpolateTo') call BIS_fnc_getCfgData) select 0], 2] call AGM_Core_fnc_execRemoteFnc;
} else {
  _unit setVariable ["AGM_OriginalAnim", "amovppnemstpsnonwnondnon", true];
  //_unit playMoveNow "Unconscious";
};

/*_unit spawn {
  sleep 3.8;
  if !(isTouchingGround _this) then {
    waitUntil {isTouchingGround _this};
    sleep 1;
  };
  _this enableSimulation false;
};*/

_unit spawn {
  waitUntil {isTouchingGround _this};
  waitUntil {!([_this] call AGM_Core_fnc_inTransitionAnim)};
  _this playMoveNow "Unconscious";
};

AGM_Medical_WakeUpTimer = [_unit, _duration] spawn {
  _unit = _this select 0;
  _duration = _this select 1;
  if (random 1 > 0.2 or _duration != -1) then {
    if (_duration != -1) then {
      sleep _duration;
    } else {
      sleep (60 * (1 + (random 8)) * ((damage _unit) max 0.3));
    };
    if (_unit getVariable "AGM_Unconscious") then {
      [_unit] call AGM_Medical_fnc_wakeUp;
    };
  };
};

/*
if (_unit == player) then {
  [0, "BLACK", 0.15, 1] call BIS_fnc_FadeEffect;
};

// Not possible to ragdollize on command, so we slam a 'vehicle' in his face.
_unit setCaptive 213;
_unit allowDamage false;

_unit disableAI "MOVE";
_unit disableAI "ANIM";
_unit disableAI "TARGET";
_unit disableAI "AUTOTARGET";
_unit disableAI "FSM";
//_eh = _unit addEventHandler ["EpeContactStart", {(_this select 0) setVariable ["AGM_Collision", (_this select 1)];}];


_helper = "AGM_CollisionHelper" createVehicle [0,0,0];
_helper setPosATL [(getPos _unit select 0), (getPos _unit select 1), 1.8];
_helper setVectorUp [0,0,1];

{
  if (_x != _unit) then {
    _helper disableCollisionWith _x;
  };
} foreach (_unit nearEntities 5);

sleep 0.7;

deleteVehicle _helper;

player globalChat "Helper deleted.";

_unit allowDamage true;

sleep 2;
_unit enableSimulation false;
_unit switchMove "unconscious";

player globalChat "done.";
*/
