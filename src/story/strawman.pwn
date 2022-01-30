// -2136.8792,-250.9526,35.3203,270.6960 // strawman 1
// 868.6023,-24.6082,64.0391,155.7329 // strawman 2
// -2292.4988,2288.8606,4.9298,173.9172 // strawman 3
// 870.4653,-24.9508,63.9805,338.2396 // Drug Den (Underground)

#include <YSI_Coding\y_hooks>

forward StrawManTimer(randloc);
forward OnPlayerOpenDrugPackage(playerid);
forward OnPlayerOpenWeaponPackage(playerid, packagetype);
forward OnPlayerSellWeapon(playerid);

#define DRUG_PACKAGE_PRICE              "2500"

#define WEAPON_PACKAGE_1_PRICE          "5000"   // Weapon Package - Tier 1 - SilencedPistol, Deagle.
#define WEAPON_PACKAGE_2_PRICE          "25000"  // Weapon Pacakge - Tier 2 - PumpShotgun, Sawnoff.
#define WEAPON_PACKAGE_3_PRICE          "50000"  // Weapon Package - Tier 3 - Tec-9, Micro Uzi.
#define WEAPON_PACKAGE_4_PRICE          "100000" // Weapon Package - Tier 4 - MP5, AK47, Rifle.
#define WEAPON_PACKAGE_5_PRICE          "200000" // Weapon Package - Tier 5 - SniperRifle, M4A1, Combat Shotgun.

static
    StrawmanActor,
    STREAMER_TAG_3D_TEXT_LABEL:StrawmanText,
    DealerDrugPackages,
    DealerWeaponPackages,
    bool:WeaponPackages[MAX_PLAYERS][5],
    WeaponPackageType[MAX_PLAYERS],
    PlayerSellingWeapon[MAX_PLAYERS],
    PlayerSellingWeaponPrice[MAX_PLAYERS],
    PlayerTarget[MAX_PLAYERS],
    PlayerSeller[MAX_PLAYERS],
    bool:IsPlayerOffered[MAX_PLAYERS];

hook OnGameModeInit() {
    SetTimerEx("StrawManTimer", 100, false, "i", Random(1, 3));

    DealerDrugPackages = 10;
    DealerWeaponPackages = 10;
    return 1;
}

hook OnPlayerConnect(playerid) {
    for(new i; i < 5; i++) {
        WeaponPackages[playerid][i] = false;
    }
    WeaponPackageType[playerid] = -1;
    PlayerSellingWeapon[playerid] = -1;
    PlayerSellingWeaponPrice[playerid] = 0;
    PlayerTarget[playerid] = INVALID_PLAYER_ID;
    PlayerSeller[playerid] = INVALID_PLAYER_ID;
    IsPlayerOffered[playerid] = false;
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
                ShowPlayerDialog(playerid, DIALOG_WEAPON_PACKAGES, DIALOG_STYLE_TABLIST_HEADERS, "Select a Weapon Package Tier", "Tier\tIncludes\nTier 1\t(10) SD Pistol, (5) Deagle\nTier 2\t(5) Shotgun, (5) Sawn-Off\nTier 3\t(5) Tec-9, (5) Uzi\nTier 4\t(10) MP5, (5) AK-47, (10) Rifle\nTier 5\t(1) Sniper Rifle, (10) M4A1, (10) Combat Shotgun", "Select", "Exit");
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

            PlayerInfo[playerid][pCash] -= strval(DRUG_PACKAGE_PRICE) * strval(inputtext);
            
            SendClientMessageEx(playerid, COLOR_LIGHTGREEN, "[SUCCESS]: {FFFFFF}You have bought %d drug packages from the dealer!", strval(inputtext));
        } else {
            ShowDialogToPlayer(playerid, DIALOG_STRAWMAN);
        }
    }

    if(dialogid == DIALOG_WEAPON_PACKAGES) {
        if(response) {
            ShowPlayerDialog(playerid, DIALOG_WEAPON_PACKAGES2, DIALOG_STYLE_INPUT, "Buy Weapon Packages", "Enter the amount of packages you want to buy", "Buy", "Back");
            WeaponPackageType[playerid] = listitem;
        } else {
            ShowDialogToPlayer(playerid, DIALOG_STRAWMAN);
        }
    }

    if(dialogid == DIALOG_WEAPON_PACKAGES2) {
        if(response) {
            if(!IsNumeric(inputtext)) {
                SendClientMessage(playerid, COLOR_RED, "[ERROR]: {FFFFFF}Invalid input!");
                return 1;
            }

            if(strval(inputtext) > DealerWeaponPackages) {
                SendClientMessage(playerid, COLOR_RED, "[ERROR]: {FFFFFF}The dealer has no available weapon packages anymore, come back next week!");
                return 1;
            }

            DealerWeaponPackages -= strval(inputtext);

            switch(WeaponPackageType[playerid]) {
                case 0: {
                    if(PlayerInfo[playerid][pCash] < strval(WEAPON_PACKAGE_1_PRICE) * strval(inputtext)) {
                        SendClientMessageEx(playerid, COLOR_RED, "[ERROR]: {FFFFFF}You can not afford the weapon package%s.", (strval(inputtext) > 1 ? "s" : ""));
                        return 1;
                    }

                    mysql_format(SQL_Connection, SQL_Buffer, sizeof(SQL_Buffer), "UPDATE users SET weaponpack1 = weaponpack1 + %d WHERE uid = %d", strval(inputtext), PlayerInfo[playerid][pID]);
                    mysql_tquery(SQL_Connection, SQL_Buffer);

                    PlayerInfo[playerid][pCash] -= strval(WEAPON_PACKAGE_1_PRICE) * strval(inputtext);
                }
                case 1: {
                    if(PlayerInfo[playerid][pCash] < strval(WEAPON_PACKAGE_2_PRICE) * strval(inputtext)) {
                        SendClientMessageEx(playerid, COLOR_RED, "[ERROR]: {FFFFFF}You can not afford the weapon package%s.", (strval(inputtext) > 1 ? "s" : ""));
                        return 1;
                    }

                    mysql_format(SQL_Connection, SQL_Buffer, sizeof(SQL_Buffer), "UPDATE users SET weaponpack2 = weaponpack2 + %d WHERE uid = %d", strval(inputtext), PlayerInfo[playerid][pID]);
                    mysql_tquery(SQL_Connection, SQL_Buffer);

                    PlayerInfo[playerid][pCash] -= strval(WEAPON_PACKAGE_2_PRICE) * strval(inputtext);
                }
                case 2: {
                    if(PlayerInfo[playerid][pCash] < strval(WEAPON_PACKAGE_3_PRICE) * strval(inputtext)) {
                        SendClientMessageEx(playerid, COLOR_RED, "[ERROR]: {FFFFFF}You can not afford the weapon package%s.", (strval(inputtext) > 1 ? "s" : ""));
                        return 1;
                    }

                    mysql_format(SQL_Connection, SQL_Buffer, sizeof(SQL_Buffer), "UPDATE users SET weaponpack3 = weaponpack3 + %d WHERE uid = %d", strval(inputtext), PlayerInfo[playerid][pID]);
                    mysql_tquery(SQL_Connection, SQL_Buffer);

                    PlayerInfo[playerid][pCash] -= strval(WEAPON_PACKAGE_3_PRICE) * strval(inputtext);
                }
                case 3: {
                    if(PlayerInfo[playerid][pCash] < strval(WEAPON_PACKAGE_4_PRICE) * strval(inputtext)) {
                        SendClientMessageEx(playerid, COLOR_RED, "[ERROR]: {FFFFFF}You can not afford the weapon package%s.", (strval(inputtext) > 1 ? "s" : ""));
                        return 1;
                    }

                    mysql_format(SQL_Connection, SQL_Buffer, sizeof(SQL_Buffer), "UPDATE users SET weaponpack4 = weaponpack4 + %d WHERE uid = %d", strval(inputtext), PlayerInfo[playerid][pID]);
                    mysql_tquery(SQL_Connection, SQL_Buffer);

                    PlayerInfo[playerid][pCash] -= strval(WEAPON_PACKAGE_4_PRICE) * strval(inputtext);
                }
                case 4: {
                    if(PlayerInfo[playerid][pCash] < strval(WEAPON_PACKAGE_5_PRICE) * strval(inputtext)) {
                        SendClientMessageEx(playerid, COLOR_RED, "[ERROR]: {FFFFFF}You can not afford the weapon package%s.", (strval(inputtext) > 1 ? "s" : ""));
                        return 1;
                    }

                    mysql_format(SQL_Connection, SQL_Buffer, sizeof(SQL_Buffer), "UPDATE users SET weaponpack5 = weaponpack5 + %d WHERE uid = %d", strval(inputtext), PlayerInfo[playerid][pID]);
                    mysql_tquery(SQL_Connection, SQL_Buffer);

                    PlayerInfo[playerid][pCash] -= strval(WEAPON_PACKAGE_5_PRICE) * strval(inputtext);
                }
            }

            SendClientMessageEx(playerid, COLOR_LIGHTGREEN, "[SUCCESS]: {FFFFFF}You have bought %d weapon packages from the dealer!", strval(inputtext));
        } else {
            ShowDialogToPlayer(playerid, DIALOG_STRAWMAN);
        }
    }

    if(dialogid == DIALOG_CHOOSE_WEAPON_TIER) {
        if(response) {
            mysql_format(SQL_Connection, SQL_Buffer, sizeof(SQL_Buffer), "SELECT weaponpack1, weaponpack2, weaponpack3, weaponpack4, weaponpack5 FROM users WHERE uid = %d", PlayerInfo[playerid][pID]);
            mysql_tquery(SQL_Connection, SQL_Buffer, "OnPlayerOpenWeaponPackage2", "ii", playerid, listitem+1);
        }
    }

    if(dialogid == DIALOG_SELL_WEAPON) {
        if(response) {
            ShowPlayerDialog(playerid, DIALOG_SELL_WEAPON2, DIALOG_STYLE_INPUT, "Sell Weapon", "Enter the price of the weapon", "Proceed", "Back");
            PlayerSellingWeapon[playerid] = listitem;
        }
    }

    if(dialogid == DIALOG_SELL_WEAPON2) {
        if(response) {
            if(!IsNumeric(inputtext)) {
                SendClientMessage(playerid, COLOR_RED, "[ERROR]: {FFFFFF}Invalid input!");
                return 1;
            }

            if(strval(inputtext) < 0 && strval(inputtext) > 999999) {
                SendClientMessage(playerid, COLOR_RED, "[ERROR]: {FFFFFF}Invalid input!");
                return 1;
            }

            ShowPlayerDialog(playerid, DIALOG_SELL_WEAPON3, DIALOG_STYLE_INPUT, "Sell Weapon", "Enter the ID of the player you like to sell the weapon to.", "Proceed", "Back");
            PlayerSellingWeaponPrice[playerid] = strval(inputtext);
        } else {
            ShowDialogToPlayer(playerid, DIALOG_STRAWMAN2);
        }
    }

    if(dialogid == DIALOG_SELL_WEAPON3) {
        if(response) {
            if(strval(inputtext) == playerid) {
                SendClientMessage(playerid, COLOR_RED, "[ERROR]: {FFFFFF}You can not sell to yourself!");
                return 1;
            }
            if(!IsPlayerConnected(strval(inputtext))) {
                SendClientMessage(playerid, COLOR_RED, "[ERROR]: {FFFFFF}The target player is not connected!");
                return 1;
            }
            
            if(!IsPlayerInRangeOfPlayer(playerid, strval(inputtext), 5.0)) {
                SendClientMessage(playerid, COLOR_RED, "[ERROR]: {FFFFFF}The target player is out of range!");
                return 1;
            }

            SendClientMessageEx(strval(inputtext), COLOR_AQUA, "[INFO]: {FFFFFF}Player (%d) %s offers to sell you a %s for $%d", playerid, GetPlayerRPName(playerid), GetSellingWeaponName(PlayerSellingWeapon[playerid]), PlayerSellingWeaponPrice[playerid]);
            SendClientMessage(strval(inputtext), COLOR_AQUA, "[TIP]: {FFFFFF}Type the command /buyweapon to accept the offer (or just ignore to not).");
            PlayerSeller[strval(inputtext)] = playerid;

            SendClientMessageEx(playerid, COLOR_AQUA, "[INFO]: {FFFFFF}You have offered %s a %s for $%d", GetPlayerRPName(strval(inputtext)), GetSellingWeaponName(PlayerSellingWeapon[playerid]), PlayerSellingWeaponPrice[playerid]);
        } else {
            ShowPlayerDialog(playerid, DIALOG_SELL_WEAPON2, DIALOG_STYLE_INPUT, "Sell Weapon", "Enter the price of the weapon", "Proceed", "Exit");
        }
    }
    return 1;
}

GetSellingWeaponName(weaponid) {
    new
        weaponname[16];
    
    switch(weaponid) {
        case 0: format(weaponname, 16, "Silenced Pistol");
        case 1: format(weaponname, 16, "Deagle");
        case 2: format(weaponname, 16, "Shotgun");
        case 3: format(weaponname, 16, "Sawn-Off");
        case 4: format(weaponname, 16, "Tec-9");
        case 5: format(weaponname, 16, "UZI");
        case 6: format(weaponname, 16, "MP5");
        case 7: format(weaponname, 16, "AK-47");
        case 8: format(weaponname, 16, "Rifle");
        case 9: format(weaponname, 16, "Sniper Rifle");
        case 10: format(weaponname, 16, "M4");
        case 11: format(weaponname, 16, "SPAS");
    }
    return weaponname;
}

hook function ShowDialogToPlayer(playerid, dialogid) {
    switch(dialogid) {
        case DIALOG_STRAWMAN: {
            static
                string[256];
            
            format(string, 256, "Product\tPackages\tPrice\nDrugs\t%d\t$"DRUG_PACKAGE_PRICE"/package\nWeapons\t%d\t$"WEAPON_PACKAGE_1_PRICE" - "WEAPON_PACKAGE_3_PRICE"/package", DealerDrugPackages, DealerWeaponPackages);
            ShowPlayerDialog(playerid, DIALOG_STRAWMAN, DIALOG_STYLE_TABLIST_HEADERS, "Buy packages from the arms and drug dealer", string, "Next", "Cancel");
        }

        case DIALOG_STRAWMAN2: {
            mysql_format(SQL_Connection, SQL_Buffer, sizeof(SQL_Buffer), "SELECT wpack_sdpistol, wpack_deagle, wpack_shotgun, wpack_sawnoff, wpack_tec9, wpack_uzi, wpack_mp5, wpack_ak47, wpack_rifle, wpack_sniper, wpack_m4, wpack_spas FROM users WHERE uid = %d", PlayerInfo[playerid][pID]);
            mysql_tquery(SQL_Connection, SQL_Buffer, "OnPlayerSellWeapon", "i", playerid);
        }
    }
    return continue(playerid, dialogid);
}

public OnPlayerSellWeapon(playerid) {
    new
        WeaponOptions[256];

    format(WeaponOptions, 256, "Weapon\tAmount\nSilenced Pistol\t%d\nDeagle\t%d\nShotgun\t%d\nSawn-off\t%d\nTec9\t%d\nUZI\t%d\nMP5\t%d\nAK-47\t%d\nRifle\t%d\nSniper Rifle\t%d\nM4\t%d\nSPAS\t%d", cache_get_field_content_int(0, "wpack_sdpistol"), cache_get_field_content_int(0, "wpack_deagle"), cache_get_field_content_int(0, "wpack_shotgun"), cache_get_field_content_int(0, "wpack_sawnoff"), cache_get_field_content_int(0, "wpack_tec9"), cache_get_field_content_int(0, "wpack_uzi"), cache_get_field_content_int(0, "wpack_mp5"), cache_get_field_content_int(0, "wpack_ak47"), cache_get_field_content_int(0, "wpack_rifle"), cache_get_field_content_int(0, "wpack_sniper"), cache_get_field_content_int(0, "wpack_m4"), cache_get_field_content_int(0, "wpack_spas"));
    ShowPlayerDialog(playerid, DIALOG_SELL_WEAPON, DIALOG_STYLE_TABLIST_HEADERS, "Choose a weapon to sell", WeaponOptions, "Select", "Exit");
    return 1;
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
        mysql_tquery(SQL_Connection, SQL_Buffer, "OnPlayerOpenDrugPackage", "i", playerid);
    } else if(!strcmp(packagetype, "weapon", true)) {
        mysql_format(SQL_Connection, SQL_Buffer, sizeof(SQL_Buffer), "SELECT weaponpack1, weaponpack2, weaponpack3, weaponpack4, weaponpack5 FROM users WHERE uid = %d", PlayerInfo[playerid][pID]);
        mysql_tquery(SQL_Connection, SQL_Buffer, "OnPlayerOpenWeaponPackage", "i", playerid);
    }
    return 1;
}

public OnPlayerOpenWeaponPackage(playerid, packagetype) {
    new
        WeaponTiers[64];
    
    for(new i = 1; i <= 5; i++) {
        new
            FieldName[16];
        format(FieldName, 16, "weaponpack%d", i);

        new
            TierName[16];

        if(cache_get_field_content_int(0, FieldName)) {
            format(TierName, 16, "Tier %d%s", i, i != 5 ? "\n" : "");
            strcat(WeaponTiers, TierName);
        } else {
            format(TierName, 16, "Empty%s", i != 5 ? "\n" : "");
            strcat(WeaponTiers, TierName);
        }
    }

    ShowPlayerDialog(playerid, DIALOG_CHOOSE_WEAPON_TIER, DIALOG_STYLE_LIST, "Choose a tier", WeaponTiers, "Select", "Exit");
    return 1;
}

forward OnPlayerOpenWeaponPackage2(playerid, packagetype);
public OnPlayerOpenWeaponPackage2(playerid, packagetype) {
    new
        FieldName[16];
    
    format(FieldName, 16, "weaponpack%d", packagetype);
    if(cache_get_field_content_int(0, FieldName)) {
        switch(packagetype) {
            case 1: {
                mysql_format(SQL_Connection, SQL_Buffer, sizeof(SQL_Buffer), "UPDATE users SET wpack_sdpistol = wpack_sdpistol + 10, wpack_deagle = wpack_deagle + 5 WHERE uid = %d", PlayerInfo[playerid][pID]);
                mysql_tquery(SQL_Connection, SQL_Buffer);

                SendClientMessage(playerid, COLOR_LIGHTGREEN, "[SUCCESS]: {FFFFFF}You have unpacked your tier 1 package!");
            }
        }
    } else {
        SendClientMessage(playerid, COLOR_RED, "[ERROR]: {FFFFFF}You do not have any weapon packages of that tier!");
    }
    return 1;
}

public OnPlayerOpenDrugPackage(playerid) {
    if(!cache_get_field_content_int(0, "drugpackages")) {
        SendClientMessage(playerid, COLOR_RED, "[ERROR]: {FFFFFF}You do not have any drug packages in your inventory!");
        return 1;
    }

    mysql_format(SQL_Connection, SQL_Buffer, sizeof(SQL_Buffer), "UPDATE users SET drugpackages = drugpackages - 1 WHERE uid = %d", PlayerInfo[playerid][pID]);
    mysql_tquery(SQL_Connection, SQL_Buffer);

    SendClientMessage(playerid, COLOR_LIGHTGREEN, "[SUCCESS]: {FFFFFF}You have opened your drug package!");
    return 1;
}

CMD:strawman(playerid, params[]) {
    new
        option[16];

    if(sscanf(params, "s[16]", option)) {
        SendClientMessage(playerid, COLOR_YELLOW, "[USAGE]: {FFFFFF}/strawman [sell]");
        return 1;
    }

    if(!strcmp(option, "sell", true)) {
        ShowDialogToPlayer(playerid, DIALOG_STRAWMAN2);
    }
    return 1;
}

CMD:buyweapon(playerid, params[]) {
    if(!IsPlayerOffered[playerid]) {
        SendClientMessage(playerid, COLOR_RED, "[ERROR]: {FFFFFF}No one even offered you to sell weapons.");
        return 1;
    }

    if(!IsPlayerInRangeOfPlayer(playerid, PlayerSeller[playerid], 5.0)) {
        SendClientMessage(playerid, COLOR_RED, "[ERROR]: {FFFFFF}The seller is out of range or disconnected!");
        return 1;
    }

    if(PlayerInfo[playerid][pCash] < PlayerSellingWeaponPrice[PlayerSeller[playerid]]) {
        SendClientMessage(playerid, COLOR_RED, "[ERROR]: {FFFFFF}You do not have enough money to buy that weapon!");
        return 1;
    }

    PlayerInfo[playerid][pCash] -= PlayerSellingWeaponPrice[PlayerSeller[playerid]];
    PlayerInfo[PlayerSeller[playerid]][pCash] += PlayerSellingWeaponPrice[PlayerSeller[playerid]];

    switch(PlayerSellingWeapon[PlayerSeller[playerid]]) {
        case 0: GivePlayerWeaponEx(playerid, WEAPON_SILENCED);
        case 1: GivePlayerWeaponEx(playerid, WEAPON_DEAGLE);
        case 2: GivePlayerWeaponEx(playerid, WEAPON_SHOTGUN);
        case 3: GivePlayerWeaponEx(playerid, WEAPON_SAWEDOFF);
        case 4: GivePlayerWeaponEx(playerid, WEAPON_TEC9);
        case 5: GivePlayerWeaponEx(playerid, WEAPON_UZI);
        case 6: GivePlayerWeaponEx(playerid, WEAPON_MP5);
        case 7: GivePlayerWeaponEx(playerid, WEAPON_AK47);
        case 8: GivePlayerWeaponEx(playerid, WEAPON_RIFLE);
        case 9: GivePlayerWeaponEx(playerid, WEAPON_SNIPER);
        case 10: GivePlayerWeaponEx(playerid, WEAPON_M4);
        case 11: GivePlayerWeaponEx(playerid, WEAPON_SHOTGSPA);
    }

    SendClientMessageEx(playerid, COLOR_LIGHTGREEN, "[SUCCESS]: {FFFFFF}You have bought %s's weapon for $%d!", GetPlayerRPName(PlayerSeller[playerid]), PlayerSellingWeaponPrice[PlayerSeller[playerid]]);
    SendClientMessageEx(playerid, COLOR_LIGHTGREEN, "[SUCCESS]: {FFFFFF}%s bought your weapon for $%d!", GetPlayerRPName(playerid), PlayerSellingWeaponPrice[PlayerSeller[playerid]]);

    IsPlayerOffered[playerid] = false;
    return 1;
}