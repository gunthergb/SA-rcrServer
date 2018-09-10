/*
          _____  __  ____     ______  ______ _________          ______
    /\   |  __ \|  \/  \ \   / / __ \|  ____|__   __\ \        / / __ \
   /  \  | |__) | \  / |\ \_/ / |  | | |__     | |   \ \  /\  / / |  | |
  / /\ \ |  _  /| |\/| | \   /| |  | |  __|    | |    \ \/  \/ /| |  | |
 / ____ \| | \ \| |  | |  | | | |__| | |       | |     \  /\  / | |__| |
/_/    \_\_|  \_\_|  |_|  |_|  \____/|_|       |_|      \/  \/   \____/

Multi Language system by ArmyOfTwo v0.1

*/
#include <xml>

#define MAX_LANGUAGE_NAME 30

stock SetPlayerLanguage(playerid, language[])
{
      SetPVarString(playerid, "Language", language);
}

stock GetPlayerLanguage(playerid)
{
      new Language[MAX_LANGUAGE_NAME];
      GetPVarString(playerid, "Language", Language, MAX_LANGUAGE_NAME);
      return Language;
}

stock InsertText(playerid, LINEID[])
{
    new File[48];
    new MyLanguage[MAX_LANGUAGE_NAME];
    new Message[128];
    new LINEID2[40];
    GetPVarString(playerid,  "Language", MyLanguage, 24);
    format(File, sizeof(File), "Languages/%s.xml", MyLanguage);
    format(LINEID2, 40, "%s/%s",MyLanguage, LINEID);
    new XML:xml = xml_open(File);
    if(xml) {
        xml_get_string(xml, LINEID2, Message, 128);
        xml_close(xml);
    }
    LINEID2 = "";
    return Message;
}
