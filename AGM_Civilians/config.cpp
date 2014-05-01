class CfgPatches {
  class AGM_Civilians {
    units[] = {};
    weapons[] = {};
    requiredVersion = 0.60;
    requiredAddons[] = {A3_Characters_F_Civil, AGM_Core, AGM_Interaction};
    version = 1.0;
    author[] = {"KoffeinFlummi"};
    authorUrl = "https://github.com/KoffeinFlummi/";
  };
};

class CfgFunctions {
  class AGM_Civilians {
    class AGM_Civilians {
      file = "AGM_Civilians\functions";
      class sendAway {};
      class getDown {};
      class setCaptive {};
    };
  };
};

class CfgVehicles {
  class CAManBase;

  class Civilian: CAManBase {
    class AGM_Actions {
      class AGM_SendAway {
        displayName = "Go Away!";
        distance = 4;
        condition = "alive cursorTarget and cursorTarget != player and (count (weapons cursorTarget)) == 0";
        statement = "[cursorTarget] call AGM_Civilians_fnc_sendAway";
        showDisabled = 0;
        priority = -2.5;
      };
      class AGM_GetDown {
        displayName = "Get Down!";
        distance = 4;
        condition = "alive cursorTarget and cursorTarget != player and (count (weapons cursorTarget)) == 0";
        statement = "[cursorTarget] call AGM_Civilians_fnc_getDown";
        showDisabled = 0;
        priority = -2.6;
      };
      class AGM_SetCaptive {
        displayName = "Take Prisoner";
        distance = 4;
        condition = "alive cursorTarget and cursorTarget != player and (count (weapons cursorTarget)) == 0";
        statement = "[[cursorTarget, [0.5, 0.8] select (count weapons player > 0)], AGM_Civilians_fnc_setCaptive] call AGM_Core_fnc_execRemoteFnc";
        showDisabled = 0;
        priority = -2.7;
      };
    };
  };
};