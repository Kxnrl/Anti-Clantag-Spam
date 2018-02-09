char g_szLastTag[MAXPLAYERS+1][32];
int g_iSpamTag[MAXPLAYERS+1];
Handle g_tTimer[MAXPLAYERS+1];

public Plugin myinfo =
{
	name		= "Anti Clantag Spam",
	author		= "Kyle",
	description = "",
	version		= "1.0",
	url			= "http://steamcommunity.com/id/Kxnrl/"
};

public void OnClientConnected(int client)
{
    g_iSpamTag[client] = 0;
    g_szLastTag[client][0] = '\0';
}

public void OnClientCommandKeyValues_Post(int client, KeyValues kv)
{
    char szCommmand[32];
    if(KvGetSectionName(kv, szCommmand, 32) && StrEqual(szCommmand, "ClanTagChanged", false))
    {
        char tag[32];
        KvGetString(kv, "tag", tag, 32);

        if(strcmp(tag, g_szLastTag[client]) == 0)
            return;

        g_iSpamTag[client]++;
        strcopy(g_szLastTag[client], 32, tag);
        
        if(g_tTimer[client] == INVALID_HANDLE)
            CreateTimer(15.0, Timer_ClearSpam, client);
    }
}

public void OnClientDisconnect(int client)
{
    if(g_tTimer[client] != INVALID_HANDLE)
        KillTimer(g_tTimer[client]);
    g_tTimer[client] = INVALID_HANDLE;
}

public Action Timer_ClearSpam(Handle timer, int client)
{
    g_tTimer[client] = INVALID_HANDLE;
    
    if(g_iSpamTag[client] >= 5)
        KickClient(client, "请不要频繁更换组标或绑定键位快速切换组标");
    
    g_iSpamTag[client] = 0;
    
    return Plugin_Stop;
}