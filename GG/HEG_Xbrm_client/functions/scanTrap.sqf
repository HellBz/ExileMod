/*
scanTrap.sqf
*/


private ["_object","_isTrappedObject","_getLucky","_origin"];
_object = _this;
_isTrappedObject = _object getvariable ["HegIsTrapped",1] isEqualTo -1;
_getLucky = floor(random 100);
_origin = getPosATL player;

if !(Xbrm_trap_defuser in items player) exitWith {
	["ErrorTitleOnly",[Xbrm_no_defuser]] call ExileClient_gui_toaster_addTemplateToast;
};

if(Xbrm_defusing) exitWith {
	["ErrorTitleOnly", ["You are already defusing!"],5] call ExileClient_gui_toaster_addTemplateToast;
};
player removeItem Xbrm_trap_defuser;
Xbrm_defusing = true;
["SuccessTitleOnly", ["Scanning safe!"]] call ExileClient_gui_toaster_addTemplateToast;
player playActionNow "Crouch";
sleep 1;
player enableSimulation false;
sleep 2;

if (_isTrappedObject) then {
	_result = ["This safe is rigged! Attempt defusal?", "Defuse?", "Yes", "Nah"] call BIS_fnc_guiMessage;
	waitUntil { !isNil "_result" };
	if (!_result) then {
		player enableSimulation true;
		player addItem Xbrm_trap_defuser;
		Xbrm_defusing = false;
	};
	if (_result) then {
		execVM "GG\HEG_Xbrm_client\functions\defuseTrap.sqf";
	};
} else {
	["SuccessTitleOnly", ["No explosives found!"]] call ExileClient_gui_toaster_addTemplateToast;
	player enableSimulation true;
	player addItem Xbrm_trap_defuser;
	Xbrm_defusing = false;
};