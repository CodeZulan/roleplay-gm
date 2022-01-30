SendClientMessageEx(playerid, color, const text[], {Float,_}:...)
{
    static
        args,
        str[192];

    if((args = numargs()) <= 3)
    {
        SendClientMessage(playerid, color, text);
    }
    else
    {
        while(--args >= 3)
        {
            #emit LCTRL 	5
            #emit LOAD.alt 	args
            #emit SHL.C.alt 2
            #emit ADD.C 	12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S 	text
        #emit PUSH.C 	192
        #emit PUSH.C 	str
        #emit PUSH.S	8
        #emit SYSREQ.C 	format
        #emit LCTRL 	5
        #emit SCTRL 	4

        SendClientMessage(playerid, color, str);

        #emit RETN
    }
    return 1;
}

SendClientMessageToAllEx(color, const text[], {Float,_}:...)
{
    static
        args,
        str[192];

    if((args = numargs()) <= 2)
    {
        foreach(new i : Player)
        {
            if(PlayerInfo[i][pLogged])
            {
                SendClientMessage(i, color, text);
            }
        }
    }
    else
    {
        while(--args >= 2)
        {
            #emit LCTRL 	5
            #emit LOAD.alt 	args
            #emit SHL.C.alt 2
            #emit ADD.C 	12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S 		text
        #emit PUSH.C 		192
        #emit PUSH.C 		str
        #emit LOAD.S.pri 	8
        #emit ADD.C 		4
        #emit PUSH.pri
        #emit SYSREQ.C 		format
        #emit LCTRL 		5
        #emit SCTRL 		4

        foreach(new i : Player)
        {
            if(PlayerInfo[i][pLogged])
            {
                SendClientMessage(i, color, str);
            }
        }

        #emit RETN
    }
    return 1;
}

Log_Write(table[], const text[], {Float,_}:...)
{
    static
        args,
        str[1024];

    if((args = numargs()) <= 2)
    {
        mysql_format(SQL_Connection, SQL_Buffer, sizeof(SQL_Buffer), "INSERT INTO %e VALUES(null, NOW(), '%e')", table, text);
        mysql_tquery(SQL_Connection, SQL_Buffer);
    }
    else
    {
        while(--args >= 2)
        {
            #emit LCTRL 	5
            #emit LOAD.alt 	args
            #emit SHL.C.alt 2
            #emit ADD.C 	12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S 		text
        #emit PUSH.C 		192
        #emit PUSH.C 		str
        #emit LOAD.S.pri 	8
        #emit ADD.C 		4
        #emit PUSH.pri
        #emit SYSREQ.C 		format
        #emit LCTRL 		5
        #emit SCTRL 		4

        mysql_format(SQL_Connection, SQL_Buffer, sizeof(SQL_Buffer), "INSERT INTO %e VALUES(null, NOW(), '%e')", table, str);
        mysql_tquery(SQL_Connection, SQL_Buffer);

        #emit RETN
    }
    return 1;
}

SendFactionMessage(factionid, color, const text[], {Float,_}:...)
{
    static
        args,
        str[192];

    if((args = numargs()) <= 3)
    {
        foreach(new i : Player)
        {
            if(PlayerInfo[i][pLogged] && PlayerInfo[i][pFaction] == factionid)
            {
                SendClientMessage(i, color, text);
            }
        }
    }
    else
    {
        while(--args >= 3)
        {
            #emit LCTRL 	5
            #emit LOAD.alt 	args
            #emit SHL.C.alt 2
            #emit ADD.C 	12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S 	text
        #emit PUSH.C 	192
        #emit PUSH.C 	str
        #emit PUSH.S	8
        #emit SYSREQ.C 	format
        #emit LCTRL 	5
        #emit SCTRL 	4

        foreach(new i : Player)
        {
            if(PlayerInfo[i][pLogged] && PlayerInfo[i][pFaction] == factionid)
            {
                SendClientMessage(i, color, str);
            }
        }

        #emit RETN
    }
    return 1;
}

SendGangMessage(gangid, color, const text[], {Float,_}:...)
{
    static
        args,
        str[192];

    if((args = numargs()) <= 3)
    {
        foreach(new i : Player)
        {
            if(PlayerInfo[i][pLogged] && PlayerInfo[i][pGang] == gangid)
            {
                SendClientMessage(i, color, text);
            }
        }
    }
    else
    {
        while(--args >= 3)
        {
            #emit LCTRL 	5
            #emit LOAD.alt 	args
            #emit SHL.C.alt 2
            #emit ADD.C 	12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S 	text
        #emit PUSH.C 	192
        #emit PUSH.C 	str
        #emit PUSH.S	8
        #emit SYSREQ.C 	format
        #emit LCTRL 	5
        #emit SCTRL 	4

        foreach(new i : Player)
        {
            if(PlayerInfo[i][pLogged] && PlayerInfo[i][pGang] == gangid)
            {
                SendClientMessage(i, color, str);
            }
        }

        #emit RETN
    }
    return 1;
}

SendAdminMessage(color, const text[], {Float,_}:...)
{
    static
        args,
        str[192];

    if((args = numargs()) <= 2)
    {
        foreach(new i : Player)
        {
            if(PlayerInfo[i][pLogged] && PlayerInfo[i][pAdmin] > 0)
            {
                SendClientMessage(i, color, text);
            }
        }

        print(text);
    }
    else
    {
        while(--args >= 2)
        {
            #emit LCTRL 	5
            #emit LOAD.alt 	args
            #emit SHL.C.alt 2
            #emit ADD.C 	12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S 		text
        #emit PUSH.C 		192
        #emit PUSH.C 		str
        #emit LOAD.S.pri 	8
        #emit ADD.C 		4
        #emit PUSH.pri
        #emit SYSREQ.C 		format
        #emit LCTRL 		5
        #emit SCTRL 		4

        foreach(new i : Player)
        {
            if(PlayerInfo[i][pLogged] && PlayerInfo[i][pAdmin] > 0)
            {
                SendClientMessage(i, color, str);
            }
        }

        print(str);

        #emit RETN
    }
    return 1;
}

SendHelperMessage(color, const text[], {Float,_}:...)
{
    static
        args,
        str[192];

    if((args = numargs()) <= 2)
    {
        foreach(new i : Player)
        {
            if(PlayerInfo[i][pLogged] && PlayerInfo[i][pHelper] > 0)
            {
                SendClientMessage(i, color, text);
            }
        }

        print(text);
    }
    else
    {
        while(--args >= 2)
        {
            #emit LCTRL 	5
            #emit LOAD.alt 	args
            #emit SHL.C.alt 2
            #emit ADD.C 	12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S 		text
        #emit PUSH.C 		192
        #emit PUSH.C 		str
        #emit LOAD.S.pri 	8
        #emit ADD.C 		4
        #emit PUSH.pri
        #emit SYSREQ.C 		format
        #emit LCTRL 		5
        #emit SCTRL 		4

        foreach(new i : Player)
        {
            if(PlayerInfo[i][pLogged] && PlayerInfo[i][pHelper] > 0)
            {
                SendClientMessage(i, color, str);
            }
        }

        print(str);

        #emit RETN
    }
    return 1;
}

SendTurfMessage(turfid, color, const text[], {Float,_}:...)
{
    static
        args,
        str[192];

    if((args = numargs()) <= 3)
    {
        foreach(new i : Player)
        {
            if(PlayerInfo[i][pLogged] && GetNearbyTurf(i) == turfid)
            {
                SendClientMessage(i, color, text);
            }
        }
    }
    else
    {
        while(--args >= 3)
        {
            #emit LCTRL 	5
            #emit LOAD.alt 	args
            #emit SHL.C.alt 2
            #emit ADD.C 	12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S 	text
        #emit PUSH.C 	192
        #emit PUSH.C 	str
        #emit PUSH.S	8
        #emit SYSREQ.C 	format
        #emit LCTRL 	5
        #emit SCTRL 	4

        foreach(new i : Player)
        {
            if(PlayerInfo[i][pLogged] && GetNearbyTurf(i) == turfid)
            {
                SendClientMessage(i, color, str);
            }
        }

        #emit RETN
    }
    return 1;
}

SendStaffMessage(color, const text[], {Float,_}:...)
{
    static
        args,
        str[192];

    if((args = numargs()) <= 2)
    {
        foreach(new i : Player)
        {
            if(PlayerInfo[i][pLogged] && (PlayerInfo[i][pAdmin] > 0 || PlayerInfo[i][pHelper] > 0))
            {
                SendClientMessage(i, color, text);
            }
        }

        print(text);
    }
    else
    {
        while(--args >= 2)
        {
            #emit LCTRL 	5
            #emit LOAD.alt 	args
            #emit SHL.C.alt 2
            #emit ADD.C 	12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S 		text
        #emit PUSH.C 		192
        #emit PUSH.C 		str
        #emit LOAD.S.pri 	8
        #emit ADD.C 		4
        #emit PUSH.pri
        #emit SYSREQ.C 		format
        #emit LCTRL 		5
        #emit SCTRL 		4

        foreach(new i : Player)
        {
            if(PlayerInfo[i][pLogged] && (PlayerInfo[i][pAdmin] > 0 || PlayerInfo[i][pHelper] > 0))
            {
                SendClientMessage(i, color, str);
            }
        }

        print(str);

        #emit RETN
    }
    return 1;
}

SetPlayerBubbleText(playerid, Float:drawdistance, color, text[], {Float,_}:...)
{
    static
        args,
        str[192];

    if((args = numargs()) <= 4)
    {
        SetPlayerChatBubble(playerid, text, color, drawdistance, 8000);
    }
    else
    {
        while(--args >= 4)
        {
            #emit LCTRL 	5
            #emit LOAD.alt 	args
            #emit SHL.C.alt 2
            #emit ADD.C 	12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S 		text
        #emit PUSH.C 		192
        #emit PUSH.C 		str
        #emit LOAD.S.pri    8
        #emit CONST.alt     4
        #emit SUB
        #emit PUSH.pri
        #emit SYSREQ.C 		format
        #emit LCTRL 		5
        #emit SCTRL 		4

        SetPlayerChatBubble(playerid, str, color, drawdistance, 8000);

        #emit RETN
    }
    return 1;
}


SendProximityMessage(playerid, Float:radius, color, const text[], {Float,_}:...)
{
    static
        args,
        str[192];

    if((args = numargs()) <= 4)
    {
        foreach(new i : Player)
        {
            if(IsPlayerInRangeOfPlayer(i, playerid, radius) || PlayerInfo[i][pListen])
            {
                SendClientMessage(i, color, text);
            }
        }
    }
    else
    {
        while(--args >= 4)
        {
            #emit LCTRL 	5
            #emit LOAD.alt 	args
            #emit SHL.C.alt 2
            #emit ADD.C 	12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S 		text
        #emit PUSH.C 		192
        #emit PUSH.C 		str
        #emit LOAD.S.pri    8
        #emit CONST.alt     4
        #emit SUB
        #emit PUSH.pri
        #emit SYSREQ.C 		format
        #emit LCTRL 		5
        #emit SCTRL 		4

        foreach(new i : Player)
        {
            if(IsPlayerInRangeOfPlayer(i, playerid, radius) || PlayerInfo[i][pListen])
            {
                SendClientMessage(i, color, str);
            }
        }

        #emit RETN
    }
    return 1;
}

SendProximityFadeMessage(playerid, Float:radius, const text[], color1, color2, color3, color4, color5)
{
    foreach(new i : Player)
    {
        if(IsPlayerInRangeOfPlayer(i, playerid, radius / 16))
        {
            SendClientMessage(i, color1, text);
        }
        else if(IsPlayerInRangeOfPlayer(i, playerid, radius / 8))
        {
            SendClientMessage(i, color2, text);
        }
        else if(IsPlayerInRangeOfPlayer(i, playerid, radius / 4))
        {
            SendClientMessage(i, color3, text);
        }
        else if(IsPlayerInRangeOfPlayer(i, playerid, radius / 2))
        {
            SendClientMessage(i, color4, text);
        }
        else if(IsPlayerInRangeOfPlayer(i, playerid, radius))
        {
            SendClientMessage(i, color5, text);
        }
        else if(PlayerInfo[i][pListen])
        {
            SendClientMessage(i, color5, text);
        }
    }
}
