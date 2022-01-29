CMD:newb(playerid, params[])
{
    return cmd_newbie(playerid, params);
}

CMD:n(playerid, params[])
{
    return cmd_newbie(playerid, params);
}

CMD:newbie(playerid, params[])
{
    if(isnull(params)) {
        SendClientMessage(playerid, COLOR_GREY3, "[Usage]: /(n)ewbie [newbie chat]");
        return 1;
    }
    if(!enabledNewbie && PlayerInfo[playerid][pAdmin] < 2) {
        SendClientMessage(playerid, COLOR_GREY, "The newbie channel is disabled at the moment.");
        return 1;
    }
    if(PlayerInfo[playerid][pNewbieMuted]) {
        SendClientMessage(playerid, COLOR_GREY, "You are muted from speaking in this channel. /report for an unmute.");
        return 1;
    }
    if(gettime() - PlayerInfo[playerid][pLastNewbie] < 60) {
        SendClientMessageEx(playerid, COLOR_GREY, "You can only speak in this channel every 60 seconds. Please wait %i more seconds.", 60 - (gettime() - PlayerInfo[playerid][pLastNewbie]));
        return 1;
    }
    if(PlayerInfo[playerid][pToggleNewbie]) {
        SendClientMessage(playerid, COLOR_GREY, "You can't speak in the newbie chat as you have it toggled.");
        return 1;
    }

    SendNewbieChatMessage(playerid, params);
    return 1;
}

CMD:anewb(playerid, params[]) {
    if(isnull(params)) {
        SendClientMessage(playerid, COLOR_GREY3, "[Usage]: /(n)ewbie [newbie chat]");
        return 1;
    }
    if(!enabledNewbie && PlayerInfo[playerid][pAdmin] < 2) {
        SendClientMessage(playerid, COLOR_GREY, "The newbie channel is disabled at the moment.");
        return 1;
    }
    if(PlayerInfo[playerid][pNewbieMuted]) {
        SendClientMessage(playerid, COLOR_GREY, "You are muted from speaking in this channel. /report for an unmute.");
        return 1;
    }
    if(gettime() - PlayerInfo[playerid][pLastNewbie] < 60) {
        SendClientMessageEx(playerid, COLOR_GREY, "You can only speak in this channel every 60 seconds. Please wait %i more seconds.", 60 - (gettime() - PlayerInfo[playerid][pLastNewbie]));
        return 1;
    }
    if(PlayerInfo[playerid][pToggleNewbie]) {
        SendClientMessage(playerid, COLOR_GREY, "You can't speak in the newbie chat as you have it toggled.");
        return 1;
    }

    SendNewbieChatMessage(playerid, params, true);
    return 1;
}

SendNewbieChatMessage(playerid, text[], answering=false) {
    new
        message[64];
    
    if(PlayerInfo[playerid][pAdmin] > 1) {
        format(message, sizeof(message), "{FF6347}%s{7DAEFF} %s", GetColorARank(playerid), GetPlayerRPName(playerid));
    } else if(PlayerInfo[playerid][pHelper] > 0) {
        format(message, sizeof(message), "%s %s", GetHelperRank(playerid), GetPlayerRPName(playerid));
    } else if(PlayerInfo[playerid][pVIPPackage] > 0) {
        format(message, sizeof(message), "{A028AD}%s VIP{7DAEFF} %s", GetVIPRank(PlayerInfo[playerid][pVIPPackage]), GetPlayerRPName(playerid));
    } else if(PlayerInfo[playerid][pLevel] > 1) {
        format(message, sizeof(message), "Player (%d) %s", playerid, GetPlayerRPName(playerid));
    } else {
        format(message, sizeof(message), "Newbie (%d) %s", playerid, GetPlayerRPName(playerid));
    }

    foreach(new i : Player) {
        if(!PlayerInfo[i][pToggleNewbie]) {
            if(strlen(text) > MAX_SPLIT_LENGTH) {
                SendClientMessageEx(i, COLOR_NEWBIE, "** %s [%s]: %.*s...", message, (answering ? "Answer" : "Question"), MAX_SPLIT_LENGTH, text);
                SendClientMessageEx(i, COLOR_NEWBIE, "** %s [%s]: ...%s", message, (answering ? "Answer" : "Question"), text[MAX_SPLIT_LENGTH]);
            }
            else {
                SendClientMessageEx(i, COLOR_NEWBIE, "** %s [%s]: %s", message, (answering ? "Answer" : "Question"), text);
            }
        }
    }

    if(PlayerInfo[playerid][pAdmin] < 2 && PlayerInfo[playerid][pHelper] == 0) {
        PlayerInfo[playerid][pLastNewbie] = gettime();
    }
}