#include 	<a_samp>
#include    <a_http>
#include    <sscanf2>
#include    <Pawn.CMD>
#include    <strlib>

#define     HTTP_IP_API_URL			"ip-api.com/csv"
#define     HTTP_IP_API_END         "?fields=country,countryCode,region,regionName,city,zip,lat,lon,timezone,isp,org,as,reverse,query,status,message"
#define     HTTP_VPN_API_URL        "check.getipintel.net/check.php?contact=baysidexx@gmail.com&ip="

enum dox_PlayerInfo
{
	Status[64],
	Country[64],
	CountryCode[64],
	Region[64],
	RegionName[64],
	City[64],
	Zip[64],
	Lat[64],
	Lon[64],
	TimeZone[64],
	Isp[64],
	Org[64],
	As[64],
	Reverse[64],
	IP[16],
};
new dPlayerInfo[MAX_PLAYERS][dox_PlayerInfo];
new targetID[MAX_PLAYERS];

public OnFilterScriptInit()
{
	printf("\n==========================================");
	printf("  	IP KONTROL y?klendi.");
	printf("==========================================\n");

	return 1;
}

public OnPlayerConnect(playerid)
{
	targetID[playerid] = INVALID_PLAYER_ID;

	return 0;
}

forward HttpVPNInfo(playerid, response_code, data[]);
public HttpVPNInfo(playerid, response_code, data[])
{
    new vpnMessage[64], sdialog[512];

    if(response_code == 200 || response_code == 400) {
    	new Float:isVPN = floatstr(data);

	 	if(isVPN < 0) {
	 	    new tmp = floatround(isVPN);

			switch(tmp) {
			    case -1: {
			        format(vpnMessage, sizeof(vpnMessage), "{F74222}HATA (Yaz? giri?i yapmad?n?z.)");
			    }
			    case -2: {
			        format(vpnMessage, sizeof(vpnMessage), "{F74222}HATA (Hatal? IP adresi)");
			    }
			    case -3: {
			        format(vpnMessage, sizeof(vpnMessage), "{F74222}HATA (Tan?mlanmayan adres / local adres.)");
			    }
			    case -4: {
			        format(vpnMessage, sizeof(vpnMessage), "{F74222}HATA (Databaseye ula??lam?yor.)");
			    }
			    case -5: {
			        format(vpnMessage, sizeof(vpnMessage), "{F74222}HATA (IP banl?.)");
			    }
			    case -6: {
			        format(vpnMessage, sizeof(vpnMessage), "{F74222}HATA (Hatal? kullan?c? bilgisi.)");
			    }
				default: {
				    format(vpnMessage, sizeof(vpnMessage), "{F74222}HATA (Code: %d) (Data: %d)", response_code, tmp);
				}
			}
	 	}
	 	else if(isVPN == 0) {
       		format(vpnMessage, sizeof(vpnMessage), "{00FF00}Almost impossible");
	 	}
	 	else if(isVPN > 0 && isVPN < 0.6) {
	 	    format(vpnMessage, sizeof(vpnMessage), "{209120}Very unlikely");
		}
		else if(isVPN >= 0.6 && isVPN < 0.8) {
		    format(vpnMessage, sizeof(vpnMessage), "{E8A42E}Likely");
		}
		else if(isVPN >= 0.8 && isVPN < 1) {
		    format(vpnMessage, sizeof(vpnMessage), "{F7752F}Highly Likely");
		}
		else if(isVPN >= 1) {
		    format(vpnMessage, sizeof(vpnMessage), "{FF0000}Certain");
		}
    }
    else {
        format(vpnMessage, sizeof(vpnMessage), "{F74222}HATA (%d)", response_code);
    }

	format(sdialog, sizeof(sdialog),
	"Index\tValue\n\
	Durum\t%s\n\
	IP\t%s\n\
	Reverse DNS\t%s\n\
	Internet ?smi\t%s\n\
	?ehir\t%s\n\
	?l?e\t%s\n\
	?l?e Kodu\t%s\n\
	ISP\t%s\n\
	Latitude\t%s\n\
	Longitude\t%s\n\
	Zaman Dilimi\t%s\n\
	Org\t%s\n\
	B?lge\t%s\n\
	B?lge ismi\t%s\n\
	Posta Kodu\t%s\n\
	VPN/Proxy\t%s",
	dPlayerInfo[targetID[playerid]][Status],
	dPlayerInfo[targetID[playerid]][IP],
	dPlayerInfo[targetID[playerid]][Reverse],
	dPlayerInfo[targetID[playerid]][As],
	dPlayerInfo[targetID[playerid]][City],
	dPlayerInfo[targetID[playerid]][Country],
	dPlayerInfo[targetID[playerid]][CountryCode],
	dPlayerInfo[targetID[playerid]][Isp],
	dPlayerInfo[targetID[playerid]][Lat],
	dPlayerInfo[targetID[playerid]][Lon],
	dPlayerInfo[targetID[playerid]][TimeZone],
	dPlayerInfo[targetID[playerid]][Org],
	dPlayerInfo[targetID[playerid]][Region],
	dPlayerInfo[targetID[playerid]][RegionName],
	dPlayerInfo[targetID[playerid]][Zip],
	vpnMessage);

	ShowPlayerDialog(playerid, 6156, DIALOG_STYLE_TABLIST_HEADERS, "{FFFF00}IPKONTROL", sdialog, "OK", "");

    return 1;
}


forward HttpIPInfo(playerid, response_code, data[]);
public HttpIPInfo(playerid, response_code, data[])
{
    if(response_code == 200) {
    	new output[14][64], string[160];

    	strexplode(output, data, ",");

		dPlayerInfo[targetID[playerid]][Status] = output[0];

		if(strfind(output[0], "sucess")) {
		    format(dPlayerInfo[targetID[playerid]][Status], 64, "{00FF00}Ba?ar?l?");
		}
		else {
		    format(dPlayerInfo[targetID[playerid]][Status], 64, "{F74222}Ba?ar?s?z");
		}

		dPlayerInfo[targetID[playerid]][Country] = output[1];
		dPlayerInfo[targetID[playerid]][CountryCode] = output[2];
		dPlayerInfo[targetID[playerid]][Region] = output[3];
		dPlayerInfo[targetID[playerid]][RegionName] = output[4];
		dPlayerInfo[targetID[playerid]][City] = output[5];
		dPlayerInfo[targetID[playerid]][Zip] = output[6];
		dPlayerInfo[targetID[playerid]][Lat] = output[7];
		dPlayerInfo[targetID[playerid]][Lon] = output[8];
		dPlayerInfo[targetID[playerid]][TimeZone] = output[9];
		dPlayerInfo[targetID[playerid]][Isp] = output[10];
		dPlayerInfo[targetID[playerid]][Org] = output[11];
		dPlayerInfo[targetID[playerid]][As] = output[12];
		dPlayerInfo[targetID[playerid]][Reverse] = output[13];

		RemoveChars(targetID[playerid]);

		format(string, sizeof(string), "%s%s", HTTP_VPN_API_URL, dPlayerInfo[targetID[playerid]][IP]);
		HTTP(playerid, HTTP_GET, string, "", "HttpVPNInfo");
    }
    else {
        new string[144];

  		format(string, sizeof(string), "[HATA] {FFFFFF}Bu IP ?zerinden bilgi al?nam?yor.. (Code: %d) (%s)", response_code, data);
  		SendClientMessage(playerid, 0xFF0000AA, string);
    }

    return 1;
}

stock RemoveChars(tID)
{
    strreplace(dPlayerInfo[tID][Country], "\"", "");
    strreplace(dPlayerInfo[tID][CountryCode], "\"", "");
    strreplace(dPlayerInfo[tID][Region], "\"", "");
    strreplace(dPlayerInfo[tID][RegionName], "\"", "");
    strreplace(dPlayerInfo[tID][City], "\"", "");
    strreplace(dPlayerInfo[tID][Zip], "\"", "");
    strreplace(dPlayerInfo[tID][Lat], "\"", "");
    strreplace(dPlayerInfo[tID][Lon], "\"", "");
    strreplace(dPlayerInfo[tID][TimeZone], "\"", "");
    strreplace(dPlayerInfo[tID][Isp], "\"", "");
    strreplace(dPlayerInfo[tID][Org], "\"", "");
    strreplace(dPlayerInfo[tID][As], "\"", "");
    strreplace(dPlayerInfo[tID][Reverse], "\"", "");

	return 1;
}

COMMAND:dox(playerid, params[])
{
	if(!IsPlayerAdmin(playerid))
		return 1;

	new targetid;

    if(sscanf(params, "d", targetid))
		return SendClientMessage(playerid, 0x0800FFAA, "[KULLANIM]: {FFFFFF}/dox <playerid>");

	if(!IsPlayerConnected(targetid))
		return SendClientMessage(playerid, 0xFF0000AA, "Kullan?c? oyunda de?il.");

	new string[160], playerIP[16], pName[MAX_PLAYER_NAME];

	targetID[playerid] = targetid;

	GetPlayerIp(targetid, playerIP, sizeof(playerIP));
    GetPlayerName(targetid, pName, sizeof(pName));

    format(dPlayerInfo[targetid][IP], 16, playerIP);

	format(string, sizeof(string), "%s/%s%s", HTTP_IP_API_URL, playerIP, HTTP_IP_API_END);
	HTTP(playerid, HTTP_GET, string, "", "HttpIPInfo");

	format(string, sizeof(string), "Ki?i hakk?nda bilgi al?n?yor %s [%s]", pName, playerIP);
	SendClientMessage(playerid, 0x00A6FFAA, string);

	return 1;
}
