// -2136.8792,-250.9526,35.3203,270.6960 // strawman 1
// 868.6023,-24.6082,64.0391,155.7329 // strawman 2
// -2292.4988,2288.8606,4.9298,173.9172 // strawman 3
// 870.4653,-24.9508,63.9805,338.2396 // Drug Den (Underground)

#include <YSI_Coding\y_hooks>

forward StrawManTimer(randloc);
forward OnPlayerOpenPackage(playerid, packagetype);

#define DRUG_PACKAGE_PRICE              "2500"

#define WEAPON_PACKAGE_1_PRICE          "5000"   // Weapon Package - Tier 1 - SilencedPistol, Deagle.
#define WEAPON_PACKAGE_2_PRICE          "25000"  // Weapon Pacakge - Tier 2 - PumpShotgun, Sawnoff.
#define WEAPON_PACKAGE_3_PRICE          "50000"  // Weapon Package - Tier 3 - Tec-9, Micro Uzi.
#define WEAPON_PACKAGE_4_PRICE          "100000" // Weapon Package - Tier 4 - MP5, AK47, Rifle.
#define WEAPON_PACKAGE_5_PRICE          "200000" // Weapon Package - Tier 5 - SniperRifle, M4A1, Combat Shotgun.

new
    StrawmanActor,
    STREAMER_TAG_3D_TEXT_LABEL:StrawmanText,
    DealerDrugPackages,
    DealerWeaponPackages;

hook OnGameModeInit() {
    SetTimerEx("StrawManTimer", 100, false, "i", Random(1, 3));

    DealerDrugPackages = 10;
    DealerWeaponPackages = 10;
    return 1;
}

hook OnPlayerConnect(playerid) {
    return 1;
}

public StrawManTimer(randloc) {
    switch(randloc) {
        case 1: {
            DestroyDynamicActor(StrawmanActor);
            DestroyDynamic3DTextLabel(StrawmanText);
            StrawmanActor = CreateDynamicActor(185, -2136.8792, -250.9526, 35.3203, 270.0, .worldid = 0, .interiorid = 0);
            StrawmanText = CreateDynamic3DTextLabel("Press '~k~~CONVERSATION_YES~' to interact", COLOR_YELLOW, -2136.8792, -250.9526, 35.3203, 20.0);
        }
        case 2: {
            DestroyDynamicActor(StrawmanActor);
            DestroyDynamic3DTextLabel(StrawmanText);
            StrawmanActor = CreateDynamicActor(185, 868.6023, -24.6082, 64.0391, 155.7329, .worldid = 0, .interiorid = 0);
            StrawmanText = CreateDynamic3DTextLabel("Press '~k~~CONVERSATION_YES~' to interact", COLOR_YELLOW, 868.6023, -24.6082, 64.0391, 20.0);
        }
        case 3: {
            DestroyDynamicActor(StrawmanActor);
            DestroyDynamic3DTextLabel(StrawmanText);
            StrawmanActor = CreateDynamicActor(185, -2292.4988, 2288.8606, 4.9298, 170.0, .worldid = 0, .interiorid = 0);
            StrawmanText = CreateDynamic3DTextLabel("Press '~k~~CONVERSATION_YES~' to interact", COLOR_YELLOW, -2292.4988, 2288.8606, 4.9298, 20.0);
        }
    }
    SetTimerEx("StrawManTimer", (((12 * 60) * 60) * 1000), true, "i", Random(1, 3));
}

bool:IsPlayerNearStrawMan(playerid) {
    if(IsPlayerInRangeOfPoint(playerid, 5.0, -2136.8792, -250.9526, 35.3203)) return true;
    if(IsPlayerInRangeOfPoint(playerid, 5.0, 868.6023, -24.6082, 64.0391)) return true;
    if(IsPlayerInRangeOfPoint(playerid, 5.0, -2292.4988, 2288.8606, 4.9298)) return true;
    return false;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if(newkeys == KEY_YES) {
        if(IsPlayerNearStrawMan(playerid)) {
            ShowDialogToPlayer(playerid, DIALOG_STRAWMAN);
        }
    }
    return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    if(dialogid == DIALOG_STRAWMAN) {
        if(response) {    
            if(listitem == 0) {
                ShowPlayerDialog(playerid, DIALOG_DRUG_PACKAGES, DIALOG_STYLE_INPUT, "Buy Drug Packages", "Enter the amount of packages you want to buy", "Buy", "Back");
            } else if(listitem == 1) {
                ShowPlayerDialog(playerid, DIALOG_WEAPON_PACKAGES, DIALOG_STYLE_INPUT, "Buy Weapon Packages", "Enter the amount of packages you want to buy", "Buy", "Back");
            }
        }
    }

    if(dialogid == DIALOG_DRUG_PACKAGES) {
        if(response) {
            if(!IsNumeric(inputtext)) {
                SendClientMessage(playerid, COLOR_RED, "[ERROR]: {FFFFFF}Invalid input!");
                return 1;
            }

            if(strval(inputtext) > DealerDrugPackages) {
                SendClientMessage(playerid, COLOR_RED, "[ERROR]: {FFFFFF}The dealer has no available drug packages anymore, come back next week!");
                return 1;
            }

            if(PlayerInfo[playerid][pCash] < strval(DRUG_PACKAGE_PRICE)) {
                SendClientMessageEx(playerid, COLOR_RED, "[ERROR]: {FFFFFF}You can not afford the drug package%s.", (strval(inputtext) > 1 ? "s" : ""));
                return 1;
            }

            DealerDrugPackages -= strval(inputtext);

            mysql_format(SQL_Connection, SQL_Buffer, sizeof(SQL_Buffer), "UPDATE users SET drugpackages = drugpackages + %d WHERE uid = %d", strval(inputtext), PlayerInfo[playerid][pID]);
            mysql_tquery(SQL_Connection, SQL_Buffer);

            PlayerInfo[playerid][pCash] -= strval(DRUG_PACKAGE_PRICE);
            
            SendClientMessageEx(playerid, COLOR_LIGHTGREEN, "[SUCCESS]: {FFFFFF}You have bought %d drug packages from the dealer!", strval(inputtext));
        } else {
            ShowDialogToPlayer(playerid, DIALOG_STRAWMAN);
        }
    }

    if(dialogid == DIALOG_WEAPON_PACKAGES) {
        if(response) {
            if(!IsNumeric(inputtext)) {
                SendClientMessage(playerid, COLOR_RED, "[ERROR]: {FFFFFF}Invalid input!");
                return 1;
            }

            if(strval(inputtext) > DealerWeaponPackages) {
                SendClientMessage(playerid, COLOR_RED, "[ERROR]: {FFFFFF}The dealer has no available weapon packages anymore, come back next week!");
                return 1;
            }

            if(PlayerInfo[playerid][pCash] < strval(WEAPON_PACKAGE_1_PRICE)) {
                SendClientMessageEx(playerid, COLOR_RED, "[ERROR]: {FFFFFF}You can not afford the weapon package%s.", (strval(inputtext) > 1 ? "s" : ""));
                return 1;
            }

            DealerWeaponPackages -= strval(inputtext);

            mysql_format(SQL_Connection, SQL_Buffer, sizeof(SQL_Buffer), "UPDATE users SET weaponpackages = weaponpackages + %d WHERE uid = %d", strval(inputtext), PlayerInfo[playerid][pID]);
            mysql_tquery(SQL_Connection, SQL_Buffer);

            PlayerInfo[playerid][pCash] -= strval(WEAPON_PACKAGE_1_PRICE);

            SendClientMessageEx(playerid, COLOR_LIGHTGREEN, "[SUCCESS]: {FFFFFF}You have bought %d weapon packages from the dealer!", strval(inputtext));
        } else {
            ShowDialogToPlayer(playerid, DIALOG_STRAWMAN);
        }
    }
    return 1;
}

hook function ShowDialogToPlayer(playerid, dialogid) {
    switch(dialogid) {
        case DIALOG_STRAWMAN: {
            static
                string[256];
            
            format(string, 256, "Product\tPackages\tPrice\nDrugs\t%d\t$"DRUG_PACKAGE_PRICE"/package\nWeapons\t%d\t$"WEAPON_PACKAGE_1_PRICE" - "WEAPON_PACKAGE_3_PRICE"/package", DealerDrugPackages, DealerWeaponPackages);
            ShowPlayerDialog(playerid, DIALOG_STRAWMAN, DIALOG_STYLE_TABLIST_HEADERS, "Buy packages from the arms and drug dealer", string, "Next", "Cancel");
        }
    }
    return continue(playerid, dialogid);
}

CMD:openpackage(playerid, params[]) {
    new
        packagetype[16];

    if(sscanf(params, "s[16]", packagetype)) {
        SendClientMessage(playerid, COLOR_YELLOW, "[USAGE]: {FFFFFF}/openpackage [drug/weapon]");
        return 1;
    }

    if(!strcmp(packagetype, "drug", true)) {
        mysql_format(SQL_Connection, SQL_Buffer, sizeof(SQL_Buffer), "SELECT drugpackages FROM users WHERE uid = %d", PlayerInfo[playerid][pID]);
        mysql_tquery(SQL_Connection, SQL_Buffer, "OnPlayerOpenPackage", "ii", playerid, 1);
    } else if(!strcmp(packagetype, "weapon", true)) {
        mysql_format(SQL_Connection, SQL_Buffer, sizeof(SQL_Buffer), "SELECT weaponpackages FROM users WHERE uid = %d", PlayerInfo[playerid][pID]);
        mysql_tquery(SQL_Connection, SQL_Buffer, "OnPlayerOpenPackage", "ii", playerid, 2);

        GivePlayerWeaponEx(playerid, WEAPON_DEAGLE);
        GivePlayerWeaponEx(playerid, WEAPON_M4);
        GivePlayerWeaponEx(playerid, WEAPON_SNIPER);
// GivePlayerWeaponEx(playerid, weaponid, bool:temp = false)
    }
    return 1;
}

public OnPlayerOpenPackage(playerid, packagetype) {
    if(packagetype == 1) {
        if(!cache_get_field_content_int(0, "drugpackages")) {
            SendClientMessage(playerid, COLOR_RED, "[ERROR]: {FFFFFF}You do not have any drug packages in your inventory!");
            return 1;
        }

        mysql_format(SQL_Connection, SQL_Buffer, sizeof(SQL_Buffer), "UPDATE users SET drugpackages = drugpackages - 1 WHERE uid = %d", PlayerInfo[playerid][pID]);
        mysql_tquery(SQL_Connection, SQL_Buffer);

        SendClientMessage(playerid, COLOR_LIGHTGREEN, "[SUCCESS]: {FFFFFF}You have opened your drug package!");
    } else if(packagetype == 2) {
        if(!cache_get_field_content_int(0, "weaponpackages")) {
            SendClientMessage(playerid, COLOR_RED, "[ERROR]: {FFFFFF}You do not have any weapon packages in your inventory!");
            return 1;
        }

        mysql_format(SQL_Connection, SQL_Buffer, sizeof(SQL_Buffer), "UPDATE users SET weaponpackages = weaponpackages - 1 WHERE uid = %d", PlayerInfo[playerid][pID]);
        mysql_tquery(SQL_Connection, SQL_Buffer);

        SendClientMessage(playerid, COLOR_LIGHTGREEN, "[SUCCESS]: {FFFFFF}You have opened your weapon package!");
    }
    return 1;
}