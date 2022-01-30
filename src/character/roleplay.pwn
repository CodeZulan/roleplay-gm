
CMD:b(playerid, params[])
{
    new
        string[144];

    if(isnull(params))
    {
        return SendClientMessage(playerid, COLOR_GREY3, "[Usage]: /b [local OOC]");
    }

    format(string, sizeof(string), "%s: (( %s ))", GetPlayerRPName(playerid), params);
    SendProximityFadeMessage(playerid, 20.0, string, COLOR_GREY1, COLOR_GREY2, COLOR_GREY3, COLOR_GREY4, COLOR_GREY5);
    return 1;
}

CMD:s(playerid, params[])
{
    return cmd_shout(playerid, params);
}

CMD:shout(playerid, params[])
{
    new
        string[144];

    if(isnull(params))
    {
        return SendClientMessage(playerid, COLOR_GREY3, "[Usage]: /(s)hout [message]");
    }

    SetPlayerBubbleText(playerid, 20.0, COLOR_WHITE, "shouts: %s!", params);

    format(string, sizeof(string), "%s shouts: %s!", GetPlayerRPName(playerid), params);
    SendProximityFadeMessage(playerid, 20.0, string, COLOR_GREY1, COLOR_GREY2, COLOR_GREY3, COLOR_GREY4, COLOR_GREY5);
    return 1;
}

CMD:me(playerid, params[])
{
    if(isnull(params))
    {
        return SendClientMessage(playerid, COLOR_GREY3, "[Usage]: /me [action]");
    }

    if(strlen(params) > MAX_SPLIT_LENGTH)
    {
        SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s %.*s...", GetPlayerRPName(playerid), MAX_SPLIT_LENGTH, params);
        SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** ...%s", params[MAX_SPLIT_LENGTH]);
    }
    else
    {
        SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s %s", GetPlayerRPName(playerid), params);
    }
    return 1;
}

CMD:do(playerid, params[])
{
    if(isnull(params))
    {
        return SendClientMessage(playerid, COLOR_GREY3, "[Usage]: /do [describe]");
    }

    if(strlen(params) > MAX_SPLIT_LENGTH)
    {
        SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %.*s...", MAX_SPLIT_LENGTH, params);
        SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** ...%s (( %s ))", params[MAX_SPLIT_LENGTH], GetPlayerRPName(playerid));
    }
    else
    {
        SendProximityMessage(playerid, 20.0, COLOR_PURPLE, "** %s (( %s ))", params, GetPlayerRPName(playerid));
    }
    return 1;
}

CMD:stats(playerid, params[])
{
    DisplayStats(playerid);
    return 1;
}

CMD:l(playerid, params[])
{
    return cmd_low(playerid, params);
}

CMD:low(playerid, params[]) {
    new
        string[144];

    if(isnull(params)) {
        SendClientMessage(playerid, COLOR_GREY3, "[Usage]: /(l)ow [message]");
        return 1;
    }

    SetPlayerBubbleText(playerid, 5.0, COLOR_WHITE, "[low]: %s", params);

    format(string, sizeof(string), "%s says [low]: %s", GetPlayerRPName(playerid), params);
    SendProximityFadeMessage(playerid, 5.0, string, COLOR_GREY1, COLOR_GREY2, COLOR_GREY3, COLOR_GREY4, COLOR_GREY5);
    return 1;
}

CMD:w(playerid, params[]) {
    return cmd_whisper(playerid, params);
}

CMD:whisper(playerid, params[]) {
    new
        targetid,
        message[128];

    if(sscanf(params, "us[128]", targetid, message)) {
        SendClientMessage(playerid, COLOR_GREY3, "[Usage]: /(w)hisper [playerid] [message]");
        return 1;
    }
    if(!IsPlayerConnected(targetid)) {
        SendClientMessage(playerid, COLOR_GREY, "The player specified is disconnected.");
        return 1;
    }
    if(!IsPlayerInRangeOfPlayer(playerid, targetid, 5.0) && (!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 6)) {
        SendClientMessage(playerid, COLOR_GREY, "You must be near that player to whisper them.");
        return 1;
    }
    if(targetid == playerid) {
        SendClientMessage(playerid, COLOR_GREY, "You can't whisper to yourself.");
        return 1;
    }

    SendClientMessageEx(targetid, COLOR_YELLOW, "** Whisper from %s: %s **", GetPlayerRPName(playerid), message);
    SendClientMessageEx(playerid, COLOR_YELLOW, "** Whisper to %s: %s **", GetPlayerRPName(targetid), message);
    
    if(PlayerInfo[targetid][pWhisperFrom] == INVALID_PLAYER_ID) {
        SendClientMessage(targetid, COLOR_WHITE, "** You can use '/rw [message]' to reply to this whisper.");
    }

    PlayerInfo[targetid][pWhisperFrom] = playerid;
    return 1;
}

CMD:rw(playerid, params[]) {
    if(isnull(params)) {
        return SendClientMessage(playerid, COLOR_GREY3, "[Usage]: /rw [message]");
    }
    if(PlayerInfo[playerid][pWhisperFrom] == INVALID_PLAYER_ID) {
        return SendClientMessage(playerid, COLOR_GREY, "You haven't been whispered by anyone since you joined the server.");
    }
    if(!IsPlayerInRangeOfPlayer(playerid, PlayerInfo[playerid][pWhisperFrom], 5.0) && (!PlayerInfo[playerid][pAdminDuty] && PlayerInfo[playerid][pAdmin] < 6)) {
        return SendClientMessage(playerid, COLOR_GREY, "You must be near that player to whisper them.");
    }
    
    SendClientMessageEx(PlayerInfo[playerid][pWhisperFrom], COLOR_YELLOW, "** Whisper from %s: %s **", GetPlayerRPName(playerid), params);
    SendClientMessageEx(playerid, COLOR_YELLOW, "** Whisper to %s: %s **", GetPlayerRPName(PlayerInfo[playerid][pWhisperFrom]), params);
    return 1;
}