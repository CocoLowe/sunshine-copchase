	//	1 Ocak 2021 - Marvellous and Martin


#pragma warning disable 239
#pragma warning disable 214
#pragma warning disable 234
#pragma warning disable 217  //Kodlarýn sýralamasý yüzünden hata verir ve bu onu kapatýr.

//Libraries
#include 	<a_samp>
#include    <crashdetect>
#include 	<a_mysql>
#include 	<sscanf2>
#include 	<Pawn.CMD>
#include 	<streamer>
#include    <Anti_cheat_pack>
#include 	<foreach>
#include 	<zones>
#include    <selection>
//#include    <nex-ac>

#if !defined IsValidVehicle
	native IsValidVehicle(vehicleid);
#endif

/////// eski MySQL ayarlarý
#define		MYSQL_HOST 				"localhost"
#define		MYSQL_HESAP 			"marvellous"
#define		MYSQL_SIFRE 			"aeQTHyNw8INjesJ2"
#define		MYSQL_VERITABANI 		"copchase_database"

/*#define		MYSQL_HOST 				"localhost"
#define		MYSQL_HESAP 			"root"
#define		MYSQL_SIFRE 			""
#define		MYSQL_VERITABANI 		"copchase"*/
	new 	MySQL: CopSQL;

/////// Renkler
#define 	SUNUCU_RENK 			0x8B0000FF
#define 	SUNUCU_RENK2 			"{8B0000}"
#define     SIYAH                   0x000000FF
#define     SIYAH2                  "{000000}"
#define     GRÝ                     "{212121}"
#define     KOYUKIRMIZI             0x950000FF
#define     KOYUKIRMIZI2            "{800000}"
#define     KIRMIZI             	0xD01717FF
#define     KIRMIZI2            	"{D01717}"
#define 	DONATOR_RENK			0xE15DC1FF
#define 	DONATOR_RENK2			"{E15DC1}"
#define     MAVI 	            	0x05B3FFFF
#define     MAVI2	            	"{05B3FF}"
#define     GRI             		0x8F8F8FFF
#define     GRI2             		"{8F8F8F}"
#define     BEYAZ              		0xFFFFFFFF
#define     BEYAZ2					"{FFFFFF}"
#define     BEYAZ3              	0xFFFFFF00
#define 	YESIL 					0x449C2DFF
#define     YESIL2					"{449C2D}"
#define     TURUNCU                 0xF96500FF
#define     TURUNCU2            	"{F96500}"
#define     YONETIM_RENK            0xD8AB3FFF
#define     YONETIM_RENK2           "{D8AB3F}"
#define     SUSPECT_RENK            0xEE1616FF
#define     SUSPECT_RENK2           0xEE161600
#define     POLIS_RENK          	0x767BA5FF
#define     POLIS_RENK2           	0x767BA500
#define     SARI                	0xF0D21DFF
#define     SARI2               	"{F0D21D}"
#define     RENK_SARI3              0xF0D21D00
#define     KAPI_RENK             	0x647DA1FF
#define     KAPI_RENK2        		"{647DA1}"
#define		EMOTE_RENK          	0xC2A2DAFF
#define		EMOTE_RENK2          	"{C2A2DA}"
#define 	COLOR_ORANGE 			0xFF9500FF
#define     DUEL_RENK               0x647DA1FF
#define     DUEL2               	"{647DA1}"
#define 	TELSIZ 					0x767BA5FF
#define 	COLOR_GREY 				0xAFAFAFAA
#define     GREY2                   "{757575}"
#define     COLOR_GREEN            (0x33AA33AA)
#define     GREEN2                  "{006400}"
#define     RENK_YARALI             0xFF6347FF
#define     YARALI                  "{FF6347}"
#define     RENK_BRHELP             0x919FAFFF
#define     COLOR_LIGHTRED          0xFF6347FF
#define     COLOR_MODERATOR         0xEB9F14FF
#define     COLOR_SUPPORTER         0xe9de98ff
#define     COLOR_BREEZEADMIN       0x62869dFF

//MODÜLER
//#include "functions/animasyonlar.pwn"

/////// Pawno kýsayollarý
new 		fmesaj[400];
#define 	YollaIpucuMesaj(%0,%1) 			format(fmesaj, sizeof(fmesaj), %1) && 	IpucuMesajDefine(%0, fmesaj)
#define 	YollaKullanMesaj(%0,%1) 		format(fmesaj, sizeof(fmesaj), %1) && 	KullanMesajDefine(%0, fmesaj)
#define 	YollaHataMesaj(%0,%1)			format(fmesaj, sizeof(fmesaj), %1) && 	HataMesajDefine(%0, fmesaj)
#define 	YollaYoneticiMesaj(%0,%1,%2)	format(fmesaj, sizeof(fmesaj), %2) && 	YoneticiMesajDefine(%0, %1, fmesaj)
#define 	YollaHelperMesaj(%0,%1)			format(fmesaj, sizeof(fmesaj), %1) &&	HelperMesajDefine(%0, fmesaj)
#define 	YollaSoruMesaj(%0,%1)			format(fmesaj, sizeof(fmesaj), %1) &&	SoruMesajDefine(%0, fmesaj)
#define 	YollaFormatMesaj(%0,%1,%2) 		format(fmesaj, sizeof(fmesaj), %2) && 	SendClientMessage(%0, %1, fmesaj)
#define 	YollaHerkeseMesaj(%0,%1) 		format(fmesaj, sizeof(fmesaj), %1) && 	SendClientMessageToAll(%0, fmesaj)
#define 	PRESSED(%0) (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

/////// Pawno kýsayollarý acmds ve scmds
// acmds - scmds komutlarý için özel ayarlandý. //

#define AdminLevelMesaji(%0,%1) \
    SendClientMessage(%0, COLOR_LIGHTRED, ""%1)

#define ModeratorLevelMesaji(%0,%1) \
    SendClientMessage(%0, COLOR_MODERATOR, ""%1)

#define GelistiriciMesaji(%0,%1) \
    SendClientMessage(%0, COLOR_BREEZEADMIN, ""%1)

#define SupporterMesaji(%0,%1) \
	SendClientMessage(%0, COLOR_SUPPORTER, ""%1)

/////// Timer Süreleri
#define 	TIMER_SANIYE(%1)		(%1 * 1000)
#define 	TIMER_SANIYE_BUCUK(%1)	(%1 * 1500)
#define 	TIMER_DAKIKA(%1)		(%1 * 60000)

/////// Oyun modu ayarlarý
#define	 	SUNUCUADI				"[0.3.DL] ~ Sunshine Police Pursuits ~"
#define	 	SUNUCUSIFRE    			""
#define	 	SUNUCUDIL	    		"Turkish/Turkey"
#define	 	SUNUCUWEB	    		"https://discord.gg/guutUUKm3F"
#define	 	MODADI	    			"S-PP v1.2"
#undef 		MAX_PLAYERS
#define 	MAX_PLAYERS             55
#define     BASLANGIC_POSX          246.375991
#define     BASLANGIC_POSY          109.245994
#define     BASLANGIC_POSZ          1003.218750
#define     BASLANGIC_POSA          0.0
#define 	MAX_ENGEL				100
#define 	OYUN_SANIYE				20 // oyunun baþlamasý için max. saniye
#define 	OYUN_DAKIKA				8 // oyunun bitmesi için max. dakika
#define 	OYUN_DAKIKASANIYE		59 // oyunun bitmesi için max. saniye
#define 	LOBI_INTERIOR			18
#define     MAX_REQUESTS_FOR_PLAYER         (1)

//Menu Selection
#define KIYAFET (1)
#define PDKIYAFET (2)
#define SUSPECTKIYAFET (3)
#define ARACDEGISTIR (4)
#define SILAHDEGISTIR (4)

//// Hasar Sistemi
#define 	INVALID_WEAPON_ID		-1
#define 	MAX_DAMAGES				(MAX_PLAYERS * 10)

#define 	BODY_PART_CHEST			3
#define		BODY_PART_TORSO			4
#define		BODY_PART_LEFT_ARM		5
#define 	BODY_PART_RIGHT_ARM		6
#define		BODY_PART_LEFT_LEG		7
#define		BODY_PART_RIGHT_LEG		8
#define		BODY_PART_HEAD			9

//Anti Cheat

#define AC_AIRBREAK_CODE 				(0)
#define AC_INVISIBLE_CODE 				(1)
#define AC_ARMOUR_CODE 					(2)
#define AC_COMMAND_CODE 				(3)
#define AC_HEALTH_CODE 					(4)
#define AC_VEHICLEREPAIR_CODE 			(5)
#define AC_JETPACK_CODE 				(6)
#define AC_SPAWNEDGUNS_CODE 			(7)
#define AC_CRASHER_CODE 				(8)
#define AC_CARHACK_CODE 				(9)
#define AC_SILENTAIM_CODE 				(10)
#define AC_AMMO_CODE                    (11)
#define AC_TELEPORT_CODE                (12)

#define MAX_CHEAT_CODES                 (13)

//Anti Cheat Manuel
#define bMAX_SIZE       (200)

// (pskin, suspectskin ve skin)
#define TOTAL_M_SKIN 285
#define TOTAL_PD_SKIN 34
#define TOTAL_SUSPECT_SKIN 7

// (/aracdegistir)
#define TOTAL_ARACDEGISTIR 10

//Skin system
new Male[TOTAL_M_SKIN] = { // erkek ve kadýn skinleri ekle daha sonra!!
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22,
    23, 24, 25, 26, 27, 28, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43,
    44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63,
    64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84,
    85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103,
    104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119,
    120, 121, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136,
    137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152,
    153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168,
    169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184,
    185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200,
    201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216,
    217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232,
    233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248,
    249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264,
    268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 288, 289, 290, 291,
		292, 293, 294, 295, 296, 297, 298, 299
};

new PDSkin[TOTAL_PD_SKIN] = {
    265, 266, 267, 280, 281, 282, 283, 284, 285, 286, 288, 300, 301, 302, 303, 304,
		305, 306, 307, 308, 309, 310, 311, 21010, 21011, 21012, 21013, 21014, 21015, 21016,
		21017, 21018, 21019, 21020
};

/*new SuspectSkin[TOTAL_SUSPECT_SKIN] = {
    21030, 21031, 21032, 21033, 21034, 21035, 21036,
};*/ // Normal skinlere tanýþanacak en son sayfa olarak.

//Vehicle Change system
new AracDegistir[TOTAL_ARACDEGISTIR] = {
    596, 597, 598, 599, 523, 528, 426, 541, 402, 560,
};

//Natives
native MapAndreas_FindZ_For2DCoord(Float:X, Float:Y, &Float:Z);

enum DAMAGE_DATA
{
	DamagePlayerID,
	DamageReason[25],
	DamageWeapon,
	DamageBodyPart,
	Float:DamageAmount
}
new DamageData[MAX_DAMAGES][DAMAGE_DATA], totalDamages = 0;

new bool: Dmizin;
enum Oyuncular
{
	SQLID,
    Cache: CacheID,
	OyuncuAdi[MAX_PLAYER_NAME],
	Yonetici,
	pAdminAlert,
	bool: Helper,
	Skor,
	Kiyafet,
	pKiyafet,
	sKiyafet,
	Sifre[65],
	IP[16],
	SSakla[17],
	PolisArac,
	bool: SuspectSari,
	bool: Suspect,
	bool: Polis,
	bool: PolisGPS,
	SusturDakika,
	SusturTimer,
	SuspectTimer,
	SuspectTimer2,
	SuspectTimer3,
	Olum,
	Oldurme,
	bool: AFK,
	bool: Oyunda,
	bool: Soru,
	bool: AracTamir,
	Sorusu[120],
	bool: Rapor,
	Raporu[120],
	bool: Silah[7],
	bool: OyunSilah,
	SkorTimer,
	EngelHak,
	EngelSec,
	bool: TaserMermiDegis,
	bool: HedefKomut,
	bool: DM,

	brutallyWounded,

	DMLobi,
    //pKisayol, // Aktif deðil henüz.
	bool: PMizin,
	bool: apm,
	bool: Taser,
	bool: Taserlendi,
	bool: Beanbag,
	bool: Beanbaglendi,
	DuzenleEngelID,
	bool: DuzenleEngel,
	bool: ElmDurum,
	bool: aduty,
	bool: aktifduel,
	bool: dueldavet,
	VW,
	Int,
	bool: Cbug,
	CbugSilah,
	CbugTimer,
	bool: Anim,
	HapisDakika,
	HapisTimer,
	SuspectKazanma,
	OyunModTimer,
	bool: Hud,
	bool: dmyetki,
	bool: dmizin,
	DmCount,
	bool: OyunModu,
	bool: Donator,
	bool: ZirhHak,
	bool: FreezeDurumu,
	bool: IsimHak,
	Float: Pos[4],
	bool: GirisYapti,
	GirisDenemeleri,
	Text3D: AdutyLabel,
	Text3D: ShotFired,
	SquadIstek,
	Squad[3],
	OyunAracID,
	OyunAracIDKoltuk,
	bool: YaraliDurum,
	Text3D: YaraliTag,
	Text3D: YardimEdiyor,
	pCheatWarnings[MAX_CHEAT_CODES],
	pCheatNotified,
	PlayerText:pTextdraws[4],
	bool:pBoxShowed,
	pOyunKalan,
	pRequestCount,
	pTmpText,
	pClickedTick,
	Tackle,
	bool:TackleMode
};
new Oyuncu[MAX_PLAYERS][Oyuncular];

enum Yasaklar
{
	Yasaklanan[MAX_PLAYER_NAME],
	Yasaklayan[MAX_PLAYER_NAME],
	Sebep[MAX_PLAYER_NAME],
	Bitis,
	IslemTarih,
	YasakIP[16]
}
new Yasakla[MAX_PLAYERS][Yasaklar];

enum Engeller
{
	ID,
	AreaID,
	bool: Olusturuldu,
	SahipID,
	Tip,
	bool: Duzenleniyor,
	Model,
	Float: Pos[3],
	Text3D: Engel3D
}
new Engel[MAX_ENGEL][Engeller];

new Text:KalanSure[2]; // Oyun kalan dakika textdraw
new PlayerText:swimTexdraw[MAX_PLAYERS];

// Dialog verileri
enum
{
	DIALOG_X,
	DIALOG_GIRIS,
	DIALOG_KAYIT,
	DIALOG_ARACDEGISTIR,
	DIALOG_DISIMDEGISTIR,
	DIALOG_DISIMDEGISTIR2,
	DIALOG_BSILAHAL,
	DIALOG_OYUNMODU,
	DIALOG_MP3,
 	DIALOG_DMLOBI,
	RadioURL,
	ASILAHAL,
	TANITIM,
	TANITIM2,
	SKORYARDIM,
	GIRIS2,
	DIALOG_HASARLAR,
	DIALOG_SQUAD_ONAY
};

new engine2, alarm2, doors2, lights2, bonnet2, boot2, objective2;
new SuspectArac[3]; // [3] yapýnca 3 araç þeklinde ayrýlýr.
new CopArac[23];
new OyunArac[15];
new bool: Fdurum;
new OyunKontrolTimer;
new FlasorTimer[MAX_VEHICLES];
new FlasorDurum[MAX_VEHICLES];
new Flasor[MAX_VEHICLES];
new AracKontrolTimer;
new AracSiren[MAX_VEHICLES];
new bool: AracSirenDurumu[MAX_VEHICLES];
new bool: AracHasar[MAX_VEHICLES];
new bool: AracYaratildi[MAX_VEHICLES];
new AracKilitSahip[MAX_VEHICLES];
new bool: EventModu;
new bool: EventModu2;
new OyunTimer;
new bool: OyunSayac;
new bool: SuspectAtes;
new bool: HerkesFreeze;
new OyunModuTip;
new OyunSebep[150];
new OyunKalanTimer;
new SuspectSaklaTimer;
new OyunDakika;
new OyunDakikaSaniye;
new bool: OyunBasladi;
new OyunSaniye;
new BankaOnKapi[2];
new BankaArkaKapi[2];
new Text3D: BankaOnKapiText[2];
new Text3D: BankaArkaKapiText[2];
new g_MysqlRaceCheck[MAX_PLAYERS];

enum Kapilar
{
	Int,
	VW,
	Float: cposx,
	Float: cposy,
	Float: cposz,
	Float: gposx,
	Float: gposy,
	Float: gposz,
}
new Kapi[][Kapilar] =
{
	{5, 1, 372.3422, -133.5223, 1001.4922, 2104.3586, -1806.4221, 13.5547}, // The Well Stacked Pizza(Ýdlewood)
	{15, 2, 2215.454833, -1147.475585, 1025.796875, 2178.0627, -1770.5101, 13.5457}, // Ýdlewood Motel
	{15, 3, 2215.454833, -1147.475585, 1025.796875, 2231.8093, -1159.6012, 25.8906}, // Jefferson Motel
	{15, 4, 2192.9565,-1151.7876, 33.5240, 358.1136, 2239.2959, -1192.7228}, // Jefferson Motel(Çatý Giriþi)
	{3, 5, 384.808624, 173.804992, 1008.382812, 1481.0155, -1771.8982, 18.7958}, // Los Santos City Hall
	{7, 6, 314.820983, -141.431991, 999.601562, 1368.2881, -1279.6880, 13.5469}, // Los Santos Main St. Ammunation
	{6, 7, -26.691598, -55.714897, 1003.546875, 1929.0497, -1776.4384, 13.5469}, // Ýdlewood Benzinlik
	{6, 8, -2240.468505, 137.060440, 1035.414062, 1582.9523, -1200.2081, 19.7937}, // Fountain Avenue arka sokaðý
	{6, 9, -2240.468505, 137.060440, 1035.414062, 1847.8811, -1871.6932, 13.5781}, // Unity Station Likör Marketi
	{1, 10, -794.806396, 497.738037, 1376.195312, 1567.9717, -1897.3474, 13.5607}, // LS City Hall arkasý Chinatown Restorant
	{1, 11, -794.806396, 497.738037, 1376.195312, 1780.2300, -1258.6663, 14.9141}, // Gleen Park tarafýndaki Restorant
	{17, 12, 493.390991, -22.722799, 1000.679687, 1024.2321, -983.6055, 42.6486}, // Temple P'N'S
	{5, 13, 1267.663208, -781.323242, 1091.906250, 1259.2246, -785.3951, 92.0302}, // Wander House(Vendettarpg - ayný yerde)
	{17, 14, 493.390991, -22.722799, 1000.679687, 561.5770, -1506.7097, 14.5485}, // Los Santos Rodeo Bar
	{2, 15, 2541.8479, -1304.0476, 1025.0703, 1341.3834, -1669.5746, 17.7173}, // Los Santos Main Street Arka Sokaðý Evler
	{11, 16, 501.9143, -68.2477, 998.7578, 2310.0283, -1643.5135, 14.8270}, // Ganton bar
	{6, 17, 774.213989, -48.924297, 1000.585937, 2229.6711, -1721.4154, 13.5627}, // Grove Street GYM
	{3, 18, 288.745971, 169.350997, 1007.171875, 2412.9851, 1123.8563, 10.8203}, // Las Venturas City Planning Department
	{3, 19, 100.3280, -24.6182, 1000.7188, 2420.3442, 2064.9199, 10.8203}, // Las Venturas Live Nude Girls
	{7, 20, 314.820983, -141.431991, 999.601562, 2539.2656, 2083.9585, 10.8203}, // Las Venturas Ammunation 1
	{6, 21, -26.691598, -55.714897 ,1003.546875, 2194.6580, 1990.9716, 12.2969}, // Las Venturas Starfish Casino Market
	{17, 22, 493.390991, -22.722799, 1000.679687, 2581.4202, 1060.5471, 11.7827}, // Las Venturas Church 1(Klise)
	{0, 23, 1059.895996, 2081.685791, 10.820312, 2076.6196, -2020.0573, 13.5469}, // Los Santos Havaalaný - Ýnterior: Las Venturas Depo
	{1, 24, -794.9706, 489.8174, 1376.1953, 2537.8018, 1178.8934, 10.8222}, // Las Venturas Restorant - Ýnterior: Liberty City
	{10, 25, 2009.4140, 1017.8990, 994.4680, 2020.6305,1007.7593,10.8203}, // Las Venturas For Dragons - Ýnterior: For Dragons
	{0, 26, 1548.6888, -1364.1636, 326.2183, 1570.8468, -1336.9652, 16.4844}, // Los Santos San Tower - Ýnterior: Tepeye çýkarýyor
	{3, 27, 2495.8997, -1692.6843, 1014.7422, 2495.3855, -1691.1404, 14.7656}, // Los Santos CJ House - Ýnterior: CJ evi
	{15, 28, 207.7126, -110.1469, 1005.1328, 2244.3892, -1665.5632, 15.4766}, // Jefferson Motel
	{15, 29, 2215.454833, -1147.475585, 1025.796875, -89.7943, 1229.7397, 19.7422}, // Fort Carson Motel
	// Bu kýsýmdan sonra benim eklediðim interiorlar var. - Marvellous
	{0,  30,  1402.7301, -26.5916, 1000.8640, 1172.7078, -1323.3954, 15.4018} // Los Santos General Hospital - Ýnterior: Hospital
};

new RandomMSG[][] =
{
    ""YESIL2"[SUNSHINE] "BEYAZ2"Oyun sýrasýnda ölünce vakit geçirmek için /dm veya /duel komutunu kullanabilirsin!",
    ""YESIL2"[SUNSHINE] "BEYAZ2"/hesap komutu ile kullanýcý verilerini görebilirsin!",
    ""YESIL2"[SUNSHINE] "BEYAZ2"Bilmediðin veya unuttuðun sunucu içerisindeki tüm komutlar için /yardim komutunu kullanabilirsin.",
    ""YESIL2"[SUNSHINE] "BEYAZ2"/sorusor komutu ile bilmediðin þeyleri öðrenebilirsin!"
};

main()
{
	SendRconCommand("hostname "SUNUCUADI);
	SendRconCommand("password "SUNUCUSIFRE);
	SendRconCommand("language "SUNUCUDIL);
	SendRconCommand("weburl "SUNUCUWEB);
	printf("[SÝSTEM] Oyun modu '%s' adýyla açýldý.\n\n", SUNUCUADI);
}

forward YasakKontrol(playerid);
public YasakKontrol(playerid)
{
	new sorgu[150];
 	if(cache_num_rows())
  	{
      new mesaj[500], mesajstr[500], yasaklanan[MAX_PLAYER_NAME], yasaklayan[MAX_PLAYER_NAME], sebep[25], bitis, islemtarih;
	    cache_get_value(0, "yasaklanan", yasaklanan, MAX_PLAYER_NAME);
		  cache_get_value(0, "yasaklayan", yasaklayan, MAX_PLAYER_NAME);
	    cache_get_value(0, "sebep", sebep, MAX_PLAYER_NAME);
		  cache_get_value_int(0, "bitis", bitis);
		  cache_get_value_int(0, "islemtarih", islemtarih);
		  if(bitis == 0)
	   	{
			format(mesaj, sizeof(mesaj), "\n"#SUNUCU_RENK2"Süresiz yasaklandýn, yanlýþ olduðunu düþünüyorsanýz '"#BEYAZ2"discord"#SUNUCU_RENK2"' adresinde #probation kanalý üzerinden yöneticilere bildirin.");
			strcat(mesajstr, mesaj);
			format(mesaj, sizeof(mesaj), "\n\n"#SUNUCU_RENK2"Yasaklayan: "#BEYAZ2"%s\n"#SUNUCU_RENK2"Sebep: "#BEYAZ2"%s\n"#SUNUCU_RENK2"Tarih: "#BEYAZ2"%s", yasaklayan, sebep, Tarih(islemtarih));
			strcat(mesajstr, mesaj);
			ShowPlayerDialog(playerid, DIALOG_X, DIALOG_STYLE_MSGBOX, "S-PP", mesajstr, "Kapat", "");
			return Kickle(playerid);
		}
		if(bitis > gettime())
		{
			format(mesaj, sizeof(mesaj), "\n"#SUNUCU_RENK2"Yasaklandýn, yanlýþ olduðunu düþünüyorsanýz '"#BEYAZ2"discord"#SUNUCU_RENK2"' adresinde #probation kanalý üzerinden yöneticilere bildirin.");
			strcat(mesajstr, mesaj);
			format(mesaj, sizeof(mesaj), "\n\n"#SUNUCU_RENK2"Yasaklayan: "#BEYAZ2"%s\n"#SUNUCU_RENK2"Sebep: "#BEYAZ2"%s\n"#SUNUCU_RENK2"Tarih: "#BEYAZ2"%s\n"#SUNUCU_RENK2"Bitiþ Tarihi: "#BEYAZ2"%s", yasaklayan, sebep, Tarih(islemtarih), Tarih(bitis));
			strcat(mesajstr, mesaj);
			ShowPlayerDialog(playerid, DIALOG_X, DIALOG_STYLE_MSGBOX, "S-PP", mesajstr, "Kapat", "");
			return Kickle(playerid);
		}
		else
		{
			mysql_format(CopSQL, sorgu, sizeof(sorgu), "DELETE FROM yasaklar WHERE yasaklanan = '%s'", yasaklanan);
			mysql_tquery(CopSQL, sorgu, "", "");
			mysql_format(CopSQL, sorgu, sizeof(sorgu), "SELECT * FROM hesaplar WHERE isim = '%s'", Oyuncuadi(playerid));
			mysql_tquery(CopSQL, sorgu, "OyuncuVeriYukle", "dd", playerid, g_MysqlRaceCheck[playerid]);
		}
	}
	else
	{
		mysql_format(CopSQL, sorgu, sizeof(sorgu), "SELECT * FROM hesaplar WHERE isim = '%s'", Oyuncuadi(playerid));
		mysql_tquery(CopSQL, sorgu, "OyuncuVeriYukle", "dd", playerid, g_MysqlRaceCheck[playerid]);
	}
	return 1;
}

forward OyuncuVeriYukle(playerid, race_check);
public OyuncuVeriYukle(playerid, race_check)
{
	if(race_check != g_MysqlRaceCheck[playerid]) return Kick(playerid);
	for(new i = 0; i < 50; i++) SendClientMessage(playerid, -1, " ");
	SetPlayerPos(playerid, 1525.2635, -1674.2241, 18.0518);
	SetPlayerVirtualWorld(playerid, 2);
	SetPlayerCameraPos(playerid, 1525.2635, -1674.2241, 18.8518);
	SetPlayerCameraLookAt(playerid, 1526.2628, -1674.2186, 18.8618);
	GetPlayerIp(playerid, Oyuncu[playerid][IP], 16);
	new string[115];
	if(cache_num_rows() > 0)
	{
     	OyuncuYukle(playerid);
		Oyuncu[playerid][CacheID] = cache_save();
		format(string, sizeof string, "%s adlý hesap kayýtlý, lütfen þifrenizi giriniz.", Oyuncu[playerid][OyuncuAdi]);
		ShowPlayerDialog(playerid, DIALOG_GIRIS, DIALOG_STYLE_PASSWORD, "Giriþ", string, "Giriþ", "Çýkýþ");
	}
	else
	{
		format(string, sizeof string, "%s adlý hesap kayýtlý deðil, þifrenizi girerek kayýt olabilirsiniz.", Oyuncuadi(playerid));
		ShowPlayerDialog(playerid, DIALOG_KAYIT, DIALOG_STYLE_PASSWORD, "Kayýt", string, "Kayýt", "Çýkýþ");
	}
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SpawnPlayer(playerid);
	SetPlayerSkin(playerid, Oyuncu[playerid][pKiyafet]);
	return 0;
}

forward OyuncuYeniKayit(playerid);
public OyuncuYeniKayit(playerid)
{
	Oyuncu[playerid][SQLID] = cache_insert_id();
	ShowPlayerDialog(playerid, TANITIM, DIALOG_STYLE_MSGBOX, "TANITIM", "{FF0000}Oyun Modu\n{FFFFFF}Geri sayýmýn bitmesinin ardýndan oyuna katýlan kiþi sayýsýna göre rastgele olacak þekilde polisler ve þüpheliler oluþturulur. Þüpheli aracýn sürücüsüne [ROLEPLAY] - [NON-RP] þeklinde iki seçenek çýkar.\nSeçtiðiniz oyun tarzýna göre oyun sürdürülür. Roleplay seçtiðinizde yine rastgele gelen bölüme göre oluþturulan senaryodan roleplay þeklinde devam ettirilir.\nSenaryolara alt bölümlerde göz atabilirsiniz.\n NON-RP seçtiðiniz taktirde her þeyin serbest olduðunu bilmeniz gerekli. Polislerin tek görevi bütün þüphelileri etkisiz hale getirmektir.\n Bunu þüphelileri vurarak yada kelepçeleyerek yapabilirsiniz. Þüphelilerin görevi ise 10 dakika boyunca polislere yakalanmamaktýr. \nKendinize ve takým arkadaþlarýnýza güveniyorsanýz ister polislerle çatýþabilir, isterseniz arabanýz ile 10 dakika boyunca kaçabilirsiniz.", "Ýleri", "");
	YollaIpucuMesaj(playerid, "Tanýtýmý geçerseniz oyundan atýlýrsýnýz.");
	Oyuncu[playerid][AFK] = true;
  YollaIpucuMesaj(playerid, ""#YARALI"[S-PP] "#BEYAZ2"%s, hoþ geldiniz. [%s]", Oyuncuadi(playerid), ReturnDate());
  TogglePlayerSpectating(playerid, 0);
	Oyuncu[playerid][SkorTimer] = SetTimerEx("OyuncuSkorVer", TIMER_DAKIKA(15), true, "d", playerid);
	Oyuncu[playerid][GirisYapti] = true;
	Oyuncu[playerid][AFK] = false;
	new sayi = random(22);
	sscanf(LobiKonum(sayi), "p<,>fff", Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
	Oyuncu[playerid][Kiyafet] = 29;
	Oyuncu[playerid][pKiyafet] = 301;
	Oyuncu[playerid][sKiyafet] = 111;
	SetSpawnInfo(playerid, 0, Oyuncu[playerid][pKiyafet], Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2], Oyuncu[playerid][Pos][3], 0, 0, 0, 0, 0, 0);
	SpawnPlayer(playerid);
	SetPlayerSkin(playerid, Oyuncu[playerid][pKiyafet]);
	SetPlayerColor(playerid, BEYAZ3);
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid, LOBI_INTERIOR);
	SetCameraBehindPlayer(playerid);
	Baslat();
	return 1;
}

forward AracTamirEt(playerid, aracid);
public AracTamirEt(playerid, aracid)
{
	new Panels, Doors, Lights, Tires, Float: araccan;
	GetVehicleDamageStatus(aracid, Panels, Doors, Lights, Tires);
	GetVehicleHealth(aracid, araccan);
	if(araccan <= 1000.0)
	{
		SetVehicleHealth(aracid, araccan+150.0);
	}
	AracHasar[aracid] = false;
	GetVehicleParamsEx(aracid, engine2, lights2, alarm2, doors2, bonnet2, boot2, objective2);
	SetVehicleParamsEx(aracid, engine2, lights2, alarm2, doors2, VEHICLE_PARAMS_OFF, boot2, objective2);
	UpdateVehicleDamageStatus(aracid, Panels, Doors, Lights, 0);
	TogglePlayerControllable(playerid, 1);
	return 1;
}
/*
forward PingCheck(playerid);
public PingCheck(playerid)
{
    new string[256];
    new ping = GetPlayerPing(playerid);
    new playrname[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playrname, sizeof(playrname));
    if(ping > 500)
    {
        format(string, sizeof(string), "\"%s\" sunucudan atýldý. Sebep: (Yüksek Ping) (Ping: %d  | Maximum: 500)", playrname, ping);
        SendClientMessageToAll(0xFFFF00FF, string);
        Kickle(playerid);
    }
}*/

forward PlayerFunctions();
public PlayerFunctions()
{
    foreach(new i : Player)
		{

			if(Oyuncu[i][Oyunda] == false)
				continue;

			if(Oyuncu[i][Suspect] == false)
				continue;

			if(Oyuncu[i][SuspectSari] == true)
				continue;

			if(IsPlayerSwimming(i))
			{
				SetPVarInt(i, "swimmingCount", GetPVarInt(i, "swimmingCount")-1);
				SetPVarInt(i, "onPlayerSwimming", 1);

				new swimcount[64];
				format(swimcount, sizeof(swimcount), "DENIZDEN_CIKMAZSAN_ATES_ETMIS_SAYILACAKSIN:_%d", GetPVarInt(i, "swimmingCount"));
				PlayerTextDrawSetString(i, swimTexdraw[i], swimcount);
				PlayerTextDrawShow(i, swimTexdraw[i]);

				if(GetPVarInt(i, "swimmingCount") <= 0)
				{
				if(!IsValidDynamic3DTextLabel(Oyuncu[i][ShotFired]))
					Oyuncu[i][ShotFired] = CreateDynamic3DTextLabel("(( BU OYUNCU ATEÞ ETTÝ ))", SARI, 0.0, 0.0, 0.2, 20.0, i);
				SuspectAtes = Oyuncu[i][SuspectSari] = true;
				SetTimerEx("DisableTextdrawMessage", 1000, false, "d", i);
				}
				return 1;
			}
			if(GetPVarInt(i, "onPlayerSwimming") == 1)
			{
				SetTimerEx("DisableTextdrawMessage", 1000, false, "d", i);
				SetPVarInt(i, "onPlayerSwimming", 0);
			}
		}
	return 1;
}

forward DisableTextdrawMessage(playerid);
public DisableTextdrawMessage(playerid)
{
	return PlayerTextDrawHide(playerid, swimTexdraw[playerid]);
}

stock IsPlayerSwimming(playerid)
{
    return (1538 <= GetPlayerAnimationIndex(playerid) <= 1544);
}

forward SendMSG();
public SendMSG()
{
    new randMSG = random(sizeof(RandomMSG));
    SendClientMessageToAll(-1, RandomMSG[randMSG]);
}

forward AracSil(aracid);
public AracSil(aracid)
{
	return DestroyVehicle(aracid);
}

forward BugKontrol(playerid);
public BugKontrol(playerid)
{
	SetPlayerSkin(playerid, Oyuncu[playerid][pKiyafet]);
	TogglePlayerControllable(playerid, 1);
	if(IsValidDynamic3DTextLabel(Oyuncu[playerid][ShotFired]) && Oyuncu[playerid][Oyunda] == false)
	{
		DestroyDynamic3DTextLabel(Oyuncu[playerid][ShotFired]);
		Oyuncu[playerid][ShotFired] = Text3D: INVALID_3DTEXT_ID;
	}
	if(IsValidDynamic3DTextLabel(Oyuncu[playerid][YaraliTag]) && Oyuncu[playerid][Oyunda] == false)
	{
		DestroyDynamic3DTextLabel(Oyuncu[playerid][YaraliTag]);
		Oyuncu[playerid][YaraliTag] = Text3D: INVALID_3DTEXT_ID;
	}
	if(IsValidDynamic3DTextLabel(Oyuncu[playerid][YardimEdiyor]) && Oyuncu[playerid][Oyunda] == false)
	{
		DestroyDynamic3DTextLabel(Oyuncu[playerid][YardimEdiyor]);
		Oyuncu[playerid][YardimEdiyor] = Text3D: INVALID_3DTEXT_ID;
	}
	if(IsPlayerInRangeOfPoint(playerid, 400.0, 2494.1504, -1668.4222, 13.3438))
	{
		new sayi = random(22);
		sscanf(LobiKonum(sayi), "p<,>fff", Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
		SetPlayerPos(playerid, Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
		SetPlayerFacingAngle(playerid, Oyuncu[playerid][Pos][3]);
		SetPlayerScore(playerid, Oyuncu[playerid][Skor]);
		SetCameraBehindPlayer(playerid);
		SetPlayerColor(playerid, BEYAZ3);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, 0);
		SetPlayerSkin(playerid, Oyuncu[playerid][pKiyafet]);
	}
	return 1;
}

forward CBugFreeze(playerid);
public CBugFreeze(playerid)
{
	TogglePlayerControllable(playerid, 1);
	Oyuncu[playerid][Cbug] = false;
	return 1;
}

forward LobiyeDon(playerid);
public LobiyeDon(playerid)
{
	SetPlayerColor(playerid, BEYAZ3);
	new sayi = random(22);
	sscanf(LobiKonum(sayi), "p<,>fff", Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
	SetPlayerPos(playerid, Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
	SetPlayerFacingAngle(playerid, Oyuncu[playerid][Pos][3]);
	SetCameraBehindPlayer(playerid);
	SetPlayerHealth(playerid, 100.0);
	SetPVarInt(playerid, "LastDuelInvite", -1);
	SetPVarInt(playerid, "killCount", 0);
	if(IsValidDynamic3DTextLabel(Oyuncu[playerid][ShotFired]))
	{
		DestroyDynamic3DTextLabel(Oyuncu[playerid][ShotFired]);
		Oyuncu[playerid][ShotFired] = Text3D: INVALID_3DTEXT_ID;
	}

	SetPlayerArmour(playerid, 0.0);
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid, LOBI_INTERIOR);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	ClearAnimations(playerid);
	ResetPlayerWeapons(playerid);
	if(IsValidDynamic3DTextLabel(Oyuncu[playerid][YaraliTag]))
	{
		DestroyDynamic3DTextLabel(Oyuncu[playerid][YaraliTag]);
		Oyuncu[playerid][YaraliTag] = Text3D: INVALID_3DTEXT_ID;
	}
	Oyuncu[playerid][ZirhHak] = Oyuncu[playerid][Oyunda] = Oyuncu[playerid][DM] = Oyuncu[playerid][Suspect] = false;
	Oyuncu[playerid][Polis] = Oyuncu[playerid][aktifduel] = Oyuncu[playerid][SuspectSari] = false;
	Oyuncu[playerid][brutallyWounded] = 0;
	Oyuncu[playerid][SquadIstek] = Oyuncu[playerid][Squad][0] = Oyuncu[playerid][Squad][1] = -1;
	Oyuncu[playerid][Squad][2] = 0;
	Oyuncu[playerid][OyunAracID] = 0;
	SetTimerEx("BugKontrol", 600, false, "d", playerid);
	TextDrawHideForPlayer(playerid, KalanSure[0]);
	TextDrawHideForPlayer(playerid, KalanSure[1]);
	return 1;
}

forward PolisSilah(playerid);
public PolisSilah(playerid)
{
	if(OyunBasladi == true && Oyuncu[playerid][Oyunda] == true)
	{
		Oyuncu[playerid][OyunSilah] = false;
		GivePlayerWeapon(playerid, 24, 75);
		GivePlayerWeapon(playerid, 25, 35);
		GivePlayerWeapon(playerid, 29, 150);
		SetTimerEx("PolisSilahEngelle", 300, false, "d", playerid);
	}
	return 1;
}

forward PolisSilahEngelle(playerid);
public PolisSilahEngelle(playerid)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		SetPlayerArmedWeapon(playerid, 0);
	return 1;
}

forward Flas(aracid);
public Flas(aracid)
{
	if(Flasor[aracid] == 1)
	{
 		new panelsx, doorsx, lightsx, tiresx;
	    if(FlasorDurum[aracid] == 1)
	    {
	        GetVehicleDamageStatus(aracid, panelsx, doorsx, lightsx, tiresx);
	        UpdateVehicleDamageStatus(aracid, panelsx, doorsx, 4, tiresx);
	        FlasorDurum[aracid] = 0;
	    }
	    else
	    {
	        GetVehicleDamageStatus(aracid, panelsx, doorsx, lightsx, tiresx);
	        UpdateVehicleDamageStatus(aracid, panelsx, doorsx, 1, tiresx);
	        FlasorDurum[aracid] = 1;
	    }
	}
	return 1;
}

forward Baslat();
public Baslat()
{
	if(OyuncuSayisi() >= 2 && OyunBasladi == false && OyunSayac == false)
	{
		OyunSayac = true;
		OyunSaniye = OYUN_SANIYE;
		if(EventModu == true)
		{
			OyunTimer = SetTimer("OyunEvent", TIMER_SANIYE(1), true);
			return 1;
		}
		if(EventModu2 == true)
		{
			OyunTimer = SetTimer("OyunEvent2", TIMER_SANIYE(1), true);
			return 1;
		}
		new tur = random(9);// Oyuna harita eklerken burayý yükselt.
		OyunTimer = SetTimerEx("OyunBasliyor", TIMER_SANIYE(1), true, "d", tur);

	}
	return 1;
}

forward OyunKalanSure(playerid);
public OyunKalanSure(playerid)
{
	if(OyunDakikaSaniye <= 0)
	{
		OyunDakikaSaniye = OYUN_DAKIKASANIYE;
		OyunDakika--;
	}
	else
	{
		OyunDakikaSaniye--;
	}

	if(OyunDakika == 4 && OyunDakikaSaniye == 30)
	{
		foreach (new i : Player)
		{
			if(Oyuncu[i][Suspect] == false)
				continue;

			if(Oyuncu[i][SuspectSari] == true)
				continue;

		SuspectMesaj(""#YARALI"SERVER: Oyunun yarýsý sona erdiði için 30 saniye sonra 'BU OYUNCU ATEÞ ETTÝ' tag'ý alacaksýn.");
		}
	}
	if(OyunDakika == 4 && OyunDakikaSaniye == 1)
	{
		foreach (new i : Player)
		{
			if(Oyuncu[i][Suspect] == false)
				continue;

			if(Oyuncu[i][SuspectSari] == true)
				continue;

			if(!IsValidDynamic3DTextLabel(Oyuncu[i][ShotFired]))
				Oyuncu[i][ShotFired] = CreateDynamic3DTextLabel("(( BU OYUNCU ATEÞ ETTÝ ))", SARI, 0.0, 0.0, 0.2, 20.0, i);
			SuspectAtes = Oyuncu[i][SuspectSari] = true;
			SuspectMesaj(""#YARALI"SERVER: Oyunun yarýsý bittiði için 'BU OYUNCU ATEÞ ETTÝ' tag'ý aldýn.");
		}
	}
	OyunKontrol();
	return 1;
}

forward OyuncuSustur(playerid);
public OyuncuSustur(playerid)
{
	Oyuncu[playerid][SusturDakika]--;
	if(Oyuncu[playerid][SusturDakika] <= 0)
	{
		Oyuncu[playerid][SusturDakika] = 0;
		KillTimer(Oyuncu[playerid][SusturTimer]);
		YollaIpucuMesaj(playerid, "Susturma cezan bitti.");
	}
	return 1;
}

forward OyuncuHapis(playerid);
public OyuncuHapis(playerid)
{
	Oyuncu[playerid][HapisDakika]--;
	if(Oyuncu[playerid][HapisDakika] <= 0)
	{
		Oyuncu[playerid][HapisDakika] = 0;
		Oyuncu[playerid][AFK] = false;
		YollaIpucuMesaj(playerid, "Hapis süren bitti.");
		LobiyeDon(playerid);
		KillTimer(Oyuncu[playerid][HapisTimer]);
	}
	return 1;
}


forward OyunModuTimer(playerid);
public OyunModuTimer(playerid)
{
	if(OyunBasladi == true && Oyuncu[playerid][Oyunda] == true && Oyuncu[playerid][OyunModu] == true)
	{
		YollaHerkeseMesaj(RENK_YARALI, "AdmCmd:"#BEYAZ2" %s adlý oyuncu 10 saniye boyunca mod seçimi yapmadýðý için AFK sebebiyle atýldý.", Oyuncuadi(playerid));
		Kickle(playerid);
		foreach(new i : Player)
		{
			if(Oyuncu[i][GirisYapti] == true && Oyuncu[i][Oyunda] == true)
			{
				SetPlayerPos(i, Oyuncu[i][Pos][0], Oyuncu[i][Pos][1], Oyuncu[i][Pos][2]);
				SetPlayerFacingAngle(i, Oyuncu[i][Pos][3]);
				SetCameraBehindPlayer(i);
				SetPlayerColor(i, BEYAZ3);
				SetPlayerVirtualWorld(i, 0);
				SetPlayerInterior(i, LOBI_INTERIOR);
				Oyuncu[i][Oyunda] = Oyuncu[i][Suspect] = Oyuncu[i][SuspectSari] = Oyuncu[i][Polis] = false;
				ResetPlayerWeapons(i);
				TogglePlayerControllable(i, 1);
			}
		}
		for(new j = 1, i = GetVehiclePoolSize(); j <= i; j++)
		{
			DestroyVehicle(j);
		}
		OyunSaniye = OYUN_SANIYE;
		OyunBasladi = OyunSayac = false;
		OyunDakika = OYUN_DAKIKA;
		OyunDakikaSaniye = OYUN_DAKIKASANIYE;
		KillTimer(SuspectSaklaTimer);
		KillTimer(OyunKalanTimer);
		Baslat();

		YollaHerkeseMesaj(RENK_YARALI, "OYUN:"#BEYAZ2" Sistem tarafýndan oyun yeniden baþlatýlýyor.");
	}
	/*if(Oyuncu[playerid][pOyunKalan] > 1)
        {
			foreach(new i : Player)
			{
            if(!IsPlayerConnected(i) || !Oyuncu[i][GirisYapti])continue;

            new string[115];
            Oyuncu[i][pTextdraws][0]--;
            format(string,sizeof(string), "~n~~g~OYUN SURE: ~w~%d", OyunDakika);
            PlayerTextDrawSetString(i, Oyuncu[i][pTextdraws][0], string);

            if(Oyuncu[i][pOyunKalan] == 0)
            {
                format(string,sizeof(string), "~n~~g~OYUN SURE: ~w~0");
                PlayerTextDrawSetString(i, Oyuncu[i][pTextdraws][0], string);
            }
		  }
        }*/
	return 1;
}

TekSayiKontrol(sayi)
{
	return sayi % 2;
}

forward OyunEvent();
public OyunEvent()
{
	if(OyunSaniye <= 10)
	{
		foreach(new i : Player)
    	{
	        if(Oyuncu[i][Oyunda] == false && Oyuncu[i][GirisYapti] == true && Oyuncu[i][AFK] == false && Oyuncu[i][DM] == true)
	        {
	        	YollaIpucuMesaj(i, "Oyun baþlayacaðý için sistem tarafýndan lobiye döndürüldün.");
	        	LobiyeDon(i);
	        }
	    }
	}
	new mesaj[50];
	format(mesaj, sizeof(mesaj), "~w~Oyun baslamasina... %d", OyunSaniye);
	OyunSaniye--;
	GameTextForAll(mesaj, 1000, 4);
	if(OyuncuSayisi() < 2)
	{
		OyunSaniye = OYUN_SANIYE;
		OyunDakika = OYUN_DAKIKA;
		OyunDakikaSaniye = OYUN_DAKIKASANIYE;
		OyunBasladi = OyunSayac = false;
		KillTimer(OyunTimer);
		return 1;
	}

	if(OyunSaniye <= 0)
	{
		OyunKontrolTimer = SetTimer("OyunKontrol", TIMER_SANIYE(7), true);
		OyunBasladi = true;
		OyunModuTip = 0;
		new oyuncusayi = OyuncuSayisi(), suspect[13], yukle = 0;
		SelectRandomPlayers(suspect, 13);
		if(TekSayiKontrol(oyuncusayi))
			oyuncusayi += random(2);

		new deneme = oyuncusayi / 2;
		foreach(new i : Player)
		{
			if(Oyuncu[i][GirisYapti] == true && Oyuncu[i][AFK] == false && Oyuncu[i][Suspect] == false)
			{
				if(deneme == yukle)
				{
					break;
				}
				foreach(new j : Player)
				{
					if(Oyuncu[j][GirisYapti] == true && Oyuncu[j][AFK] == false)
					{
						if(suspect[j] == i && Oyuncu[i][Suspect] == false)
						{
							Oyuncu[i][Suspect] = Oyuncu[i][Oyunda] = true;
							Oyuncu[i][Polis] = false;
							SetPlayerPos(i, -2809.8767, -1539.6384, 139.3850);
							SetPlayerFacingAngle(i, 32.0);
							if(Oyuncu[i][Donator] == true)
								GivePlayerWeapon(i, 35, 1);

							GivePlayerWeapon(i, 24, 500);
							GivePlayerWeapon(i, 31, 500);
							SetPlayerSkin(i, 25);
							SetPlayerInterior(i, 0);
							SetPlayerVirtualWorld(i, 0);
							SetCameraBehindPlayer(i);
							yukle++;
						}
					}
				}
			}
		}
		foreach(new i : Player)
		{
			if(Oyuncu[i][GirisYapti] == true && Oyuncu[i][AFK] == false && Oyuncu[i][Suspect] == false)
			{
				Oyuncu[i][Polis] = Oyuncu[i][Oyunda] = true;
				Oyuncu[i][Suspect] = false;
				SetPlayerPos(i, -2815.9026, -1695.2655, 141.5735);
				SetPlayerFacingAngle(i, 104.0);
				SetPlayerSkin(i, 285);
				SetPlayerInterior(i, 0);
				SetPlayerVirtualWorld(i, 0);
				if(Oyuncu[i][Donator] == true)
					GivePlayerWeapon(i, 34, 10);
				GivePlayerWeapon(i, 24, 500);
				GivePlayerWeapon(i, 31, 500);
				SetCameraBehindPlayer(i);
			}
		}
		SetTimer("OyunRenkleriDuzelt", TIMER_SANIYE(1), false);
		OyunDakika = OYUN_DAKIKA;
		OyunDakikaSaniye = OYUN_DAKIKASANIYE;
		KillTimer(OyunTimer);
		return 1;
	}
	return 1;
}

forward OyunEvent2();
public OyunEvent2()
{
	if(OyunSaniye <= 10)
	{
		foreach(new i : Player)
    	{
	        if(Oyuncu[i][Oyunda] == false && Oyuncu[i][GirisYapti] == true && Oyuncu[i][AFK] == false && Oyuncu[i][DM] == true)
	        {
	        	YollaIpucuMesaj(i, "Oyun birazdan baþlayacaðý için lobiye gönderildin.");
	        	LobiyeDon(i);
	        }
	    }
	}
	new mesaj[50];
	format(mesaj, sizeof(mesaj), "~w~Oyun baslamasina... %d", OyunSaniye);
	OyunSaniye--;
	GameTextForAll(mesaj, 1000, 4);
	if(OyuncuSayisi() < 2)
	{
		OyunSaniye = OYUN_SANIYE;
		OyunDakika = OYUN_DAKIKA;
		OyunDakikaSaniye = OYUN_DAKIKASANIYE;
		OyunBasladi = OyunSayac = false;
		KillTimer(OyunTimer);
		return 1;
	}

	if(OyunSaniye <= 0)
	{
		OyunKontrolTimer = SetTimer("OyunKontrol", TIMER_SANIYE(7), true);
		OyunBasladi = true;
		OyunModuTip = 0;
		new oyuncusayi = OyuncuSayisi(), suspect[13], yukle = 0;
		SelectRandomPlayers(suspect, 12);
		if(TekSayiKontrol(oyuncusayi))
			oyuncusayi += random(2);

		new deneme = oyuncusayi / 2, Float: pos[3];
		foreach(new i : Player)
		{
			if(Oyuncu[i][GirisYapti] == true && Oyuncu[i][AFK] == false && Oyuncu[i][Suspect] == false)
			{
				if(deneme == yukle)
				{
					break;
				}
				foreach(new j : Player)
				{
					if(Oyuncu[j][GirisYapti] == true && Oyuncu[j][AFK] == false)
					{
						if(suspect[j] == i && Oyuncu[i][Suspect] == false)
						{
							Oyuncu[i][Suspect] = Oyuncu[i][Oyunda] = true;
							Oyuncu[i][Polis] = false;
							sscanf(Event2Konum(yukle, 1), "p<,>fff", pos[0], pos[1], pos[2]);
							SetPlayerPos(i, pos[0], pos[1], pos[2]);
							SetPlayerFacingAngle(i, 260.0);
							if(Oyuncu[i][Donator] == true)
								GivePlayerWeapon(i, 35, 1);

							GivePlayerWeapon(i, 24, 500);
							GivePlayerWeapon(i, 30, 500);
							SetPlayerSkin(i, 29);
							SetPlayerInterior(i, 0);
							SetPlayerVirtualWorld(i, 0);
							SetCameraBehindPlayer(i);
							yukle++;
						}
					}
				}
			}
		}
		foreach(new i : Player)
		{
			if(Oyuncu[i][GirisYapti] == true && Oyuncu[i][AFK] == false && Oyuncu[i][Suspect] == false)
			{
				Oyuncu[i][Polis] = Oyuncu[i][Oyunda] = true;
				Oyuncu[i][Suspect] = false;
				sscanf(Event2Konum(yukle, 0), "p<,>fff", pos[0], pos[1], pos[2]);
				SetPlayerPos(i, pos[0], pos[1], pos[2]);
				SetPlayerFacingAngle(i, 266.1480);
				SetPlayerSkin(i, 285);
				SetPlayerInterior(i, 0);
				SetPlayerVirtualWorld(i, 0);
				if(Oyuncu[i][Donator] == true)
					GivePlayerWeapon(i, 34, 10);
				GivePlayerWeapon(i, 24, 500);
				GivePlayerWeapon(i, 31, 500);
				SetCameraBehindPlayer(i);
			}
		}

		BankaOnKapi[0] = CreatePickup(1239, 1, 2303.5789, -68.7443, 26.4844); // giriþ
		BankaOnKapi[1] = CreatePickup(1239, 1, 2316.6118, -70.3218, 26.4844); // çýkýþ
		BankaArkaKapi[0] = CreatePickup(1239, 1, 2305.5483, -16.0880, 26.7496); // giriþ
		BankaArkaKapi[1] = CreatePickup(1239, 1, 2315.7178, 0.3387, 26.7422); // çýkýþ

		BankaOnKapiText[0] = CreateDynamic3DTextLabel("F tuþu ile girebilirsin", -1, 2303.5789, -68.7443, 26.4844, 15.0);
		BankaArkaKapiText[0] = CreateDynamic3DTextLabel("F tuþu ile girebilirsin", -1, 2305.5483, -16.0880, 26.7496, 15.0);
		BankaOnKapiText[1] = CreateDynamic3DTextLabel("F tuþu ile çýkabilirsin", -1, 2316.6118, -70.3218, 26.4844, 15.0);
		BankaArkaKapiText[1] = CreateDynamic3DTextLabel("F tuþu ile çýkabilirsin", -1, 2315.7178, 0.3387, 26.7422, 15.0);

		SetTimer("OyunRenkleriDuzelt", TIMER_SANIYE(1), false);
		OyunDakika = OYUN_DAKIKA;
		OyunDakikaSaniye = OYUN_DAKIKASANIYE;
		KillTimer(OyunTimer);
		return 1;
	}
	return 1;
}

forward AracKontrol();
public AracKontrol()
{
	if(OyunBasladi == false) KillTimer(AracKontrolTimer);
	for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(IsPlayerInAnyVehicle(i) && Oyuncu[i][GirisYapti] == true && Oyuncu[i][Oyunda] == true)
		{
			new Float: can, aracid = GetPlayerVehicleID(i);
			GetVehicleParamsEx(aracid, engine2, lights2, alarm2, doors2, bonnet2, boot2, objective2);
			GetVehicleHealth(aracid, can);
			if(can < 280.0)
			{
				AracHasar[aracid] = true;
				SetVehicleHealth(aracid, 260.0);
				TogglePlayerControllable(i, false);
				GameTextForPlayer(i, "~r~ARAC HASARLI", 2000, 4);
				//RemovePlayerFromVehicle(i); // Araçtan indirir.
				SetVehicleParamsEx(aracid, 0, 0, alarm2, doors2, bonnet2, boot2, objective2);
				TogglePlayerControllable(i, true);
			}
		}
	}
	return 1;
}

forward SuspectSilahVer(suspect);
public SuspectSilahVer(suspect)
{
	if(OyunBasladi == true && Oyuncu[suspect][Oyunda] == true)
	{
		GivePlayerWeapon(suspect, 24, 75);
		GivePlayerWeapon(suspect, 25, 60);
        GivePlayerWeapon(suspect, 30, 280);

		if(GetPlayerState(suspect) == PLAYER_STATE_DRIVER)
			SetPlayerArmedWeapon(suspect, 0);
		if(GetPlayerState(suspect) == PLAYER_STATE_PASSENGER)
		{
		    if(GetPlayerWeapon(suspect) == 24)
				SetPlayerArmedWeapon(suspect, 0);
		}
	}
	return 1;
}

forward SuspectSakla(suspect);
public SuspectSakla(suspect)
{
	if(OyunBasladi == true && Oyuncu[suspect][Oyunda] == true)
	{
		if(Oyuncu[suspect][Suspect] == true)
			SetPlayerColor(suspect, SUSPECT_RENK2);
	}
	return 1;
}

forward SuspectCCTV();
public SuspectCCTV()
{
	new oyunpolissayi = OyunPolisSayi(), oyunsuspectsayi = OyunSuspectSayi();
	if((oyunsuspectsayi <= 0 && oyunpolissayi <= 0) || OyunDakika <= 1)
		return 1;
	if(OyunBasladi == true && oyunsuspectsayi >= 1)
	{
		new mesaj[160], bolge2[30], bolge[4][30], sayi = 0;

		for(new i; i < oyunsuspectsayi; i++)
		{
			if(Oyuncu[i][Suspect] == true)
			{
				if(Oyuncu[i][SuspectSari] == false)
				{
					SetPlayerColor(i, SUSPECT_RENK);
					SetTimerEx("SuspectSakla", TIMER_SANIYE(30), false, "d", i);
				}
				GetPlayer3DZone(i, bolge2, sizeof(bolge2));
				format(bolge[sayi], 30, "%s", bolge2);
				sayi++;
			}
		}

		if(sayi == 0)
			return 1;

		switch(sayi)
		{
			case 1: format(mesaj, sizeof(mesaj), "[CCTV] Aranan þüpheli %s bölgesinde görüldü!", bolge[0]);
			case 2:
			{
				if(strcmp(bolge[0], bolge[1], true) == 0)
					format(mesaj, sizeof(mesaj), "[CCTV] Aranan þüpheliler %s bölgesinde görüldü!", bolge[0]);
				else
					format(mesaj, sizeof(mesaj), "[CCTV] Aranan þüpheliler %s ve %s bölgesinde görüldü!", bolge[0], bolge[1]);
			}
			case 3:
			{
				if(strcmp(bolge[0], bolge[1], true) == 0 && strcmp(bolge[1], bolge[2], true) == 0)
					format(mesaj, sizeof(mesaj), "[CCTV] Aranan þüpheliler %s bölgesinde görüldü!", bolge[0]);
				else
					format(mesaj, sizeof(mesaj), "[CCTV] Aranan þüpheliler %s, %s ve %s bölgesinde görüldü!", bolge[0], bolge[1], bolge[2]);
			}
			case 4:
			{
				if(strcmp(bolge[0], bolge[1], true) == 0 && strcmp(bolge[1], bolge[2], true) == 0 && strcmp(bolge[2], bolge[3], true) == 0)
					format(mesaj, sizeof(mesaj), "[CCTV] Aranan þüpheliler %s bölgesinde görüldü!", bolge[0]);
				else
					format(mesaj, sizeof(mesaj), "[CCTV] Aranan þüpheliler %s, %s, %s ve %s bölgesinde görüldü!", bolge[0], bolge[1], bolge[2], bolge[3]);
			}
		}
		PolisTelsiz(mesaj);
	}
	return 1;
}

forward Float:GetDistancePlayerToVehicle(playerid, vehicleid);
public Float:GetDistancePlayerToVehicle(playerid, vehicleid)
{
	new Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2;
    GetPlayerPos(playerid, x1, y1, z1);
	GetVehiclePos(vehicleid, x2, y2, z2);
    return floatsqroot( ( ( x1 - x2 ) * ( x1 - x2 ) ) + ( ( y1 - y2 ) * ( y1 - y2 ) ) + ( ( z1 - z2 ) * ( z1 - z2 ) ) );
}

forward OyunKontrol();
public OyunKontrol()
{
	if(OyunBasladi == true)
	{
		new oyunpolissayi = OyunPolisSayi(), oyunsuspectsayi = OyunSuspectSayi();
		if(oyunsuspectsayi <= 0 && oyunpolissayi <= 0)
		{
			for(new i = 1; i < MAX_ENGEL; ++i)
			{
				if(Engel[i][Olusturuldu] == true)
				{
					DestroyDynamicObject(Engel[i][ID]);
					DestroyDynamic3DTextLabel(Engel[i][Engel3D]);
					if(IsValidDynamicArea(Engel[i][AreaID]))
						DestroyDynamicArea(Engel[i][AreaID]);
					Engel[i][Engel3D] = Text3D: INVALID_3DTEXT_ID;
					Engel[i][Pos][0] = Engel[i][Pos][1] = Engel[i][Pos][2] = 0.0;
					Engel[i][Duzenleniyor] = Engel[i][Olusturuldu] = false;
					Engel[i][SahipID] = -1;
				}
			}
			for(new j = 1, i = GetVehiclePoolSize(); j <= i; j++)
			{
				Flasor[j] = 0;
				KillTimer(FlasorTimer[j]);
				DestroyVehicle(j);
			}
			for(new i; i < 2; i++)
			{
				DestroyPickup(BankaOnKapi[i]);
				DestroyPickup(BankaArkaKapi[i]);
			}
			OyunSaniye = OYUN_SANIYE;
			OyunBasladi = EventModu = EventModu2 = OyunSayac = false;
			OyunDakika = OYUN_DAKIKA;
			OyunDakikaSaniye = OYUN_DAKIKASANIYE;
			KillTimer(SuspectSaklaTimer);
			KillTimer(OyunKalanTimer);
			KillTimer(OyunKontrolTimer);
			SetTimer("Baslat", TIMER_SANIYE(5), false);
			return 1;
		}
		if(oyunsuspectsayi <= 0)
		{
			for(new i = 1; i < MAX_ENGEL; ++i)
			{
				if(Engel[i][Olusturuldu] == true)
				{
					DestroyDynamicObject(Engel[i][ID]);
					DestroyDynamic3DTextLabel(Engel[i][Engel3D]);
					if(IsValidDynamicArea(Engel[i][AreaID]))
						DestroyDynamicArea(Engel[i][AreaID]);
					Engel[i][Engel3D] = Text3D: INVALID_3DTEXT_ID;
					Engel[i][Pos][0] = Engel[i][Pos][1] = Engel[i][Pos][2] = 0.0;
					Engel[i][Duzenleniyor] = Engel[i][Olusturuldu] = false;
					Engel[i][SahipID] = -1;
				}
			}
			foreach(new i : Player)
			{
				if(GetPlayerState(i) == PLAYER_STATE_SPECTATING)
				{
					TogglePlayerSpectating(i, 0);
					LobiyeDon(i);
				}
				if(Oyuncu[i][GirisYapti] == true && Oyuncu[i][Oyunda] == true)
				{
					if(Oyuncu[i][Polis] == true)
					{
						if(Oyuncu[i][Donator] == true)
							SkorVer(i, 4);
						else
							SkorVer(i, 2);
					}
					SetTimerEx("LobiyeDon", TIMER_SANIYE(1), false, "d", i);
					KillTimer(Oyuncu[i][SuspectTimer2]);
					KillTimer(Oyuncu[i][SuspectTimer3]);
				}
			}
			for(new j = 1, i = GetVehiclePoolSize(); j <= i; j++)
			{
				Flasor[j] = 0;
				KillTimer(FlasorTimer[j]);
				DestroyVehicle(j);
			}
			for(new i; i < 2; i++)
			{
				DestroyPickup(BankaOnKapi[i]);
				DestroyPickup(BankaArkaKapi[i]);
			}
			OyunSaniye = OYUN_SANIYE;
			OyunBasladi = EventModu = EventModu2 = OyunSayac = false;
			OyunDakika = OYUN_DAKIKA;
			OyunDakikaSaniye = OYUN_DAKIKASANIYE;
			KillTimer(SuspectSaklaTimer);
			KillTimer(OyunKalanTimer);
			KillTimer(OyunKontrolTimer);
			SetTimer("Baslat", TIMER_SANIYE(5), false);
			YollaHerkeseMesaj(RENK_YARALI, "OYUN:"#BEYAZ2" Oyunu polisler kazandý.");
			ShowRoundMVP();
			return 1;
		}
		if(oyunpolissayi <= 0)
		{
			for(new i = 1; i < MAX_ENGEL; ++i)
			{
				if(Engel[i][Olusturuldu] == true)
				{
					DestroyDynamicObject(Engel[i][ID]);
					DestroyDynamic3DTextLabel(Engel[i][Engel3D]);
					if(IsValidDynamicArea(Engel[i][AreaID]))
						DestroyDynamicArea(Engel[i][AreaID]);
					Engel[i][Engel3D] = Text3D: INVALID_3DTEXT_ID;
					Engel[i][Pos][0] = Engel[i][Pos][1] = Engel[i][Pos][2] = 0.0;
					Engel[i][Duzenleniyor] = Engel[i][Olusturuldu] = false;
					Engel[i][SahipID] = -1;
				}
			}
			foreach(new i : Player)
			{
				if(GetPlayerState(i) == PLAYER_STATE_SPECTATING)
				{
					TogglePlayerSpectating(i, 0);
					LobiyeDon(i);
				}
				if(Oyuncu[i][GirisYapti] == true && Oyuncu[i][Oyunda] == true)
				{
					if(Oyuncu[i][Suspect] == true)
					{
						if(Oyuncu[i][Donator] == true)
							SkorVer(i, 8);
						else
							SkorVer(i, 5);
						Oyuncu[i][SuspectKazanma]++;
					}
					SetTimerEx("LobiyeDon", TIMER_SANIYE(1), false, "d", i);
					KillTimer(Oyuncu[i][SuspectTimer2]);
					KillTimer(Oyuncu[i][SuspectTimer3]);
				}
			}
			for(new j = 1, i = GetVehiclePoolSize(); j <= i; j++)
			{
				Flasor[j] = 0;
				KillTimer(FlasorTimer[j]);
				DestroyVehicle(j);
			}
			for(new i; i < 2; i++)
			{
				DestroyPickup(BankaOnKapi[i]);
				DestroyPickup(BankaArkaKapi[i]);
			}
			OyunSaniye = OYUN_SANIYE;
			OyunBasladi = EventModu = EventModu2 = OyunSayac = false;
			OyunDakika = OYUN_DAKIKA;
			OyunDakikaSaniye = OYUN_DAKIKASANIYE;
			KillTimer(SuspectSaklaTimer);
			KillTimer(OyunKalanTimer);
			KillTimer(OyunKontrolTimer);
			SetTimer("Baslat", TIMER_SANIYE(5), false);
			YollaHerkeseMesaj(RENK_YARALI, "OYUN:"#BEYAZ2" Oyunu suçlular kazandý.");
			ShowRoundMVP();
			return 1;
		}
		if(OyunDakika <= 0)
		{
			if(OyunDakikaSaniye > 1)
				return 1;

			for(new i = 1; i < MAX_ENGEL; ++i)
			{
				if(Engel[i][Olusturuldu] == true)
				{
					DestroyDynamicObject(Engel[i][ID]);
					DestroyDynamic3DTextLabel(Engel[i][Engel3D]);
					if(IsValidDynamicArea(Engel[i][AreaID]))
						DestroyDynamicArea(Engel[i][AreaID]);
					Engel[i][Engel3D] = Text3D: INVALID_3DTEXT_ID;
					Engel[i][Pos][0] = Engel[i][Pos][1] = Engel[i][Pos][2] = 0.0;
					Engel[i][Duzenleniyor] = Engel[i][Olusturuldu] = false;
					Engel[i][SahipID] = -1;
				}
			}
			foreach(new i : Player)
			{
				if(GetPlayerState(i) == PLAYER_STATE_SPECTATING)
				{
					TogglePlayerSpectating(i, 0);
					LobiyeDon(i);
				}
				if(Oyuncu[i][GirisYapti] == true && Oyuncu[i][Oyunda] == true)
				{
					if(Oyuncu[i][Suspect] == true)
					{
						if(Oyuncu[i][Donator] == true)
							SkorVer(i, 8);
						else
							SkorVer(i, 5);
						Oyuncu[i][SuspectKazanma]++;
					}
					SetTimerEx("LobiyeDon", TIMER_SANIYE(1), false, "d", i);
					KillTimer(Oyuncu[i][SuspectTimer2]);
					KillTimer(Oyuncu[i][SuspectTimer3]);
				}
			}
			for(new j = 1, i = GetVehiclePoolSize(); j <= i; j++)
			{
				DestroyVehicle(j);
			}
			for(new i; i < 2; i++)
			{
				DestroyPickup(BankaOnKapi[i]);
				DestroyPickup(BankaArkaKapi[i]);
			}
			OyunSaniye = OYUN_SANIYE;
			OyunBasladi = OyunSayac = EventModu = EventModu2 = false;
			OyunDakika = OYUN_DAKIKA;
			OyunDakikaSaniye = OYUN_DAKIKASANIYE;
			KillTimer(SuspectSaklaTimer);
			KillTimer(OyunKalanTimer);
			KillTimer(OyunKontrolTimer);
			SetTimer("Baslat", TIMER_SANIYE(5), false);
			YollaHerkeseMesaj(RENK_YARALI, "OYUN:"#BEYAZ2" Oyun süresi doldu, suçlular kazandý.");
			ShowRoundMVP();
			return 1;
		}
	}
	return 1;
}

forward ShowRoundMVP();
public ShowRoundMVP()
{
	new last_kill = -1;
	new last_mvp = -1;

	foreach(new i : Player)
	{
		new player_kill = GetPVarInt(i, "killCount");
		if(player_kill == 0)
			continue;

		if(last_kill < player_kill)
		{
			last_kill = player_kill;
			last_mvp = i;
		}
	}
	if(last_kill == -1)
		return 1;

	if(last_mvp == -1)
		return 1;

	YollaHerkeseMesaj(-1, "Bu round MVP "KOYUKIRMIZI2"%s!", Oyuncuadi(last_mvp));
	SkorVer(last_mvp, 3);
	return 1;
}
forward FreezeCoz(playerid);
public FreezeCoz(playerid)
{
	if(Oyuncu[playerid][Suspect] == false)
		return 1;

	Oyuncu[playerid][Taserlendi] = false;
	Oyuncu[playerid][Beanbaglendi] = false;
	TogglePlayerControllable(playerid, 1);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	ClearAnimations(playerid);
	return 1;
}

forward OyuncuSkorVer(playerid);
public OyuncuSkorVer(playerid)
{
	SkorVer(playerid, (Oyuncu[playerid][Donator] == true ? 7 : 5));
	YollaIpucuMesaj(playerid, "15 dakikadýr oyunda olduðunuz için bir miktar skor kazandýnýz.");
	OyuncuGuncelle(playerid);
	return 1;
}

forward KickleSure(playerid);
public KickleSure(playerid)
{
	Kick(playerid);
	return 1;
}

Kickle(playerid, time = 500)
{
	SetTimerEx("KickleSure", time, false, "d", playerid);
	return 1;
}


ProxDetector(Float: mesafe, playerid, const mesaj[], renk)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    foreach(new i : Player)
    {
        if(IsPlayerInRangeOfPoint(i, mesafe, x, y, z) && Oyuncu[i][GirisYapti] == true)
        {
            SendClientMessage(i, renk, mesaj);
        }
    }
}

ProxDetectorLobi(const mesaj[], renk)
{
    foreach(new i : Player)
    {
        if(Oyuncu[i][Oyunda] == false && Oyuncu[i][GirisYapti] == true)
        {
            SendClientMessage(i, renk, mesaj);
        }
    }
}

ProxDetectorOyun(const mesaj[], renk)
{
    foreach(new i : Player)
    {
        if(Oyuncu[i][Oyunda] == true && Oyuncu[i][GirisYapti] == true)
        {
            SendClientMessage(i, renk, mesaj);
        }
    }
}

EngelYakin(playerid)
{
	for(new engelid = 1; engelid < MAX_ENGEL; engelid++)
	{
	    if(Engel[engelid][Olusturuldu] == true && Engel[engelid][Tip] == 1 && IsPlayerInRangeOfPoint(playerid, 4.0, Engel[engelid][Pos][0], Engel[engelid][Pos][1], Engel[engelid][Pos][2]))
	    {
	        return engelid;
		}
	}
	return -1;
}

OyuncuSayisi()
{
	new oyuncusayi;
	foreach(new i : Player)
	{
		if(Oyuncu[i][GirisYapti] == true && Oyuncu[i][AFK] == false && Oyuncu[i][aktifduel] == false)
			oyuncusayi++;
	}
	return oyuncusayi;
}

SkorVer(playerid, miktar)
{
	new mesaj[30];
	if(miktar <= 0)
		format(mesaj, sizeof(mesaj), "~r~%d", miktar);
	else
		format(mesaj, sizeof(mesaj), "~g~+%d", miktar);
	GameTextForPlayer(playerid, mesaj, 3000, 1);
	Oyuncu[playerid][Skor] += miktar;
	SetPlayerScore(playerid, Oyuncu[playerid][Skor]);
	OyuncuGuncelle(playerid);
}

SkorVer2(playerid, miktar)
{
	new mesaj[30];
	if(miktar <= 0)
		format(mesaj, sizeof(mesaj), "~r~%d", miktar);
	else
		format(mesaj, sizeof(mesaj), "~g~+%d", miktar);
	Oyuncu[playerid][Skor] -= miktar;
	SetPlayerScore(playerid, Oyuncu[playerid][Skor]);
	OyuncuGuncelle(playerid);
}

SkorVerPolis(playerid, miktar)
{
	new mesaj[30];
	if(miktar <= 0)
		format(mesaj, sizeof(mesaj), "~r~%d", miktar);
	else
		format(mesaj, sizeof(mesaj), "~g~+%d", miktar);
	if(Oyuncu[playerid][Polis] == true)
	{
		Oyuncu[playerid][Skor] += miktar;
		SetPlayerScore(playerid, Oyuncu[playerid][Skor]);
		OyuncuGuncelle(playerid);
    }
}

LobiKonum(sayi)
{
	new konum[244];
	switch(sayi)
	{
		case 0: konum = "1722.8618,-1666.8798,20.2290,44.8268";
		case 1: konum = "1724.1985,-1665.5996,20.2293,44.8268";
		case 2: konum = "1725.6135,-1663.8307,20.2323,44.8268";
		case 3: konum = "1727.3168,-1661.8290,20.2379,43.3268";
		case 4: konum = "1728.1951,-1657.4207,20.2370,86.4170";
		case 5: konum = "1727.9712,-1653.1072,20.2313,86.4170";
		case 6: konum = "1726.1989,-1651.1649,20.2331,143.1726";
		case 7: konum = "1722.8373,-1649.9430,20.2289,177.180";
		case 8: konum = "1720.3789,-1649.8616,20.2288,180.8566";
		case 9: konum = "1717.1302,-1650.0482,20.2248,225.6637";
		case 10: konum = "1714.9032,-1652.6912,20.2227,267.9433";
		case 11: konum = "1715.8007,-1655.5814,20.2229,267.9433";
		case 12: konum = "1715.8673,-1658.2468,20.2229,269.0921";
		case 13: konum = "1714.1096,-1663.4501,20.2279,272.6211";
		case 14: konum = "1714.5710,-1670.1101,20.2247,326.0055";
		case 15: konum = "1719.4259,-1670.0106,20.2247,359.2481";
		case 16: konum = "1730.5808,-1659.0981,20.2394,90.5529";
		case 17: konum = "1731.2349,-1651.5454,20.2342,101.5823";
		case 18: konum = "1730.8776,-1644.4570,20.2316,93.3102";
		case 19: konum = "1726.3647,-1643.1769,20.2256,179.7075";
		case 20: konum = "1712.5267,-1640.2103,20.2239,218.4751";
		case 21: konum = "1712.5267,-1640.2103,20.2239,218.4751";
	}
	return konum;
}

DMKonum(sayi)
{
	new konum[244];
	switch(sayi)
	{
		case 0: konum = "212.7434, 142.3439, 1003.0234";
		case 1: konum = "300.8310, 185.2354, 1007.1719";
		case 2: konum = "267.7838, 185.6091, 1008.1719";
		case 3: konum = "245.7049, 185.5751, 1008.1719";
		case 4: konum = "237.9269, 141.2811, 1003.0234";
		case 5: konum = "208.9285, 142.0022, 1003.0300";
		case 6: konum = "194.6322, 158.1613, 1003.0234";
		case 7: konum = "228.5259, 183.1147, 1003.0313";
	}
	return konum;
}

DMKonum2(sayi)
{
	new konum[244];
	switch(sayi)
	{
		case 0: konum = "-794.9257,490.7375,1376.1953,1.1572";
		case 1: konum = "-782.4167,506.5254,1371.7422,136.3496";
		case 2: konum = "-780.7010,493.8676,1376.1953,85.3388";
		case 3: konum = "-778.8784,496.1714,1368.5234,49.1140";
		case 4: konum = "-827.3781,520.2844,1357.1016,146.3106";
		case 5: konum = "-829.3173,493.0644,1358.4150,3.6465";
		case 6: konum = "-799.0112,491.0348,1367.2328,74.1629";
		case 7: konum = "-808.3776,492.7073,1359.8549,48.0481";
	}
	return konum;
}

DMKonum3(sayi)
{
	new konum[244];
	switch(sayi)
	{
		case 0: konum = "934.1144,2143.9878,1011.0234,270.5680";
		case 1: konum = "949.8507,2144.1074,1011.0200,89.9965";
		case 2: konum = "933.6490,2127.6641,1011.0234,264.7948";
		case 3: konum = "950.6963,2124.4993,1011.0234,93.2658";
		case 4: konum = "956.3832,2117.3267,1011.0234,90.6918";
		case 5: konum = "934.6198,2106.0205,1011.0234,315.7127";
		case 6: konum = "964.2917,2108.3411,1011.0303,83.4421";
		case 7: konum = "948.4709,2106.4685,1011.0234,0.1079";
		case 8: konum = "962.0314,2149.8655,1011.0234,87.9390";
		case 9: konum = "948.2260,2175.3762,1011.0234,174.7958";
		case 10: konum = "934.9482,2161.6301,1011.0303,213.8586";
		case 11: konum = "962.6677,2176.8923,1011.0234,90.2359";
	}
	return konum;
}

DMKonum4(sayi)
{
	new konum[244];
	switch(sayi)
	{
		case 0: konum = "-969.6922,1097.1090,1345.0055,179.3121";
		case 1: konum = "-969.1174,1020.6115,1345.0828,0.7116";
		case 2: konum = "-979.3895,1020.2698,1345.0128,0.5881";
		case 3: konum = "-990.8385,1026.7075,1341.8513,42.1391";
		case 4: konum = "-1048.6360,1020.8279,1343.0703,9.1210";
		case 5: konum = "-1035.2781,1098.3702,1343.1444,181.9713";
		case 6: konum = "-988.2490,1097.9713,1342.9928,125.5189";
		case 7: konum = "-1023.5018,1052.8063,1343.0381,270.2669";
		case 8: konum = "-973.4186,1060.9159,1345.6733,90.6612";
		case 9: konum = "-1132.1086,1022.5900,1345.7233,301.3729";
		case 10: konum = "-1131.3966,1093.7478,1345.7865,239.7912";
		case 11: konum = "-1074.2051,1097.0732,1342.7644,247.3740";
		case 12: konum = "-1073.4399,1032.7269,1342.8195,359.9668";
		case 13: konum = "1128.2329,1058.0398,1346.4141,274.1600";
	}
	return konum;
}

Event2Konum(sayi, tip)
{
	new konum[100];
	if(tip == 0) // cop
	{
		switch(sayi)
		{
			case 0: konum = "2303.3035, -78.9138, 26.4844, 2.0591";
			case 1: konum = "2303.3838, -81.3945, 26.4844, 1.3698";
			case 2: konum = "2303.3154, -84.4755, 26.4844, 1.3698";
			case 3: konum = "2316.6682, -60.5459, 26.4844, 181.7470";
			case 4: konum = "2316.6699, -58.3995, 26.4844, 181.7470";
			case 5: konum = "2316.6912, -56.7294, 26.4844, 184.7341";
			case 6: konum = "2303.3188, -57.9531, 26.4844, 178.6947";
			case 7: konum = "2303.2417, -54.3536, 26.4844, 178.6947";
			case 8: konum = "2302.6443, -52.2671, 26.4844, 178.6947";
			case 9: konum = "2325.1628, -77.1955, 26.4844, 90.2946";
			case 10: konum = "2328.5620, -77.1873, 26.4844, 90.2946";
			case 11: konum = "2332.5938, -77.2519, 26.4844, 90.2946";
			case 12: konum = "2282.1011, -48.3582, 27.0036, 270.8364";
			case 13: konum = "2281.7046, -51.0232, 27.0125, 269.4578";
			case 14: konum = "2282.4041, -54.1912, 26.9952, 269.4578";
			case 15: konum = "2335.4165, -50.9767, 26.4844, 180.2037";
			case 16: konum = "2335.0518, -48.5606, 26.4844, 180.2037";
			case 17: konum = "2335.1162, -45.9984, 26.4844, 180.2037";
			case 18: konum = "2272.3162, -74.3656, 31.6016, 272.3455";
			case 19: konum = "2302.0662, -103.6853, 26.4800, 357.8236";
			case 20: konum = "2332.3882, -103.4996, 26.4844, 359.2760";
			case 21: konum = "2334.1345, -23.5901, 26.3313, 178.4959";
			case 22: konum = "2306.1990, -22.4306, 26.4844, 181.9426";
			case 23: konum = "2281.0046, -22.0389, 26.4844, 269.7186";
			case 24: konum = "2280.7004, -34.7719, 26.4844, 269.7186";
		}
	}
	if(tip == 1) // suspect
	{
		switch(sayi)
		{
			case 0: konum = "2307.3877, -10.3876, 26.7422, 260.8682";
			case 1: konum = "2309.7332, -9.9624, 26.7422, 276.0752";
			case 2: konum = "2312.3452, -8.1502, 26.7422, 276.0752";
			case 3: konum = "2314.3645, -5.0189, 26.7422, 276.0752";
			case 4: konum = "2313.3684, -2.0012, 26.7422, 276.0752";
			case 5: konum = "2309.3789, -0.1238, 26.7422, 258.4669";
			case 6: konum = "2309.3079, -3.5107, 26.7422, 226.1945";
			case 7: konum = "2306.7678, -4.6379, 26.7422, 226.1945";
			case 8: konum = "2316.2710, -15.5631, 26.7422, 174.5983";
			case 9: konum = "2316.6213, -6.9123, 26.7422, 224.1791";
			case 10: konum = "2316.3154, -9.9366, 26.7422, 170.7965";
			case 11: konum = "2316.0862, -12.4669, 26.7422, 170.7965";
			case 12: konum = "2315.6069, -15.4171, 26.7422, 170.7965";
			case 13: konum = "2313.6628, -15.8956, 26.7422, 99.1052";
			case 14: konum = "2311.2473, -14.1210, 26.7422, 99.1052";
			case 15: konum = "2309.7004, -16.3241, 26.7496, 99.1052";
			case 16: konum = "2307.0969, -15.1422, 26.7496, 99.1052";
			case 17: konum = "2305.9189, -1.1908, 26.7422, 239.3155";
			case 18: konum = "2315.6865, -1.1800, 26.7422, 184.4607";
			case 19: konum = "2314.5981, -4.9446, 26.7422, 171.4259";
			case 20: konum = "2315.3909, -8.1139, 26.7422, 171.4259";
			case 21: konum = "2315.5073, -11.9049, 26.7422, 171.4259";
			case 22: konum = "2309.5010, -13.9066, 26.7422, 278.5062";
			case 23: konum = "2311.7268, -13.5737, 26.7422, 278.5062";
			case 24: konum = "2313.8679, -13.2533, 26.7422, 278.5062";
		}
	}
	return konum;
}

PolisTelsiz(const mesaj[])
{
    if(mesaj[0] == '\0') return;
	foreach(new i : Player)
	{
        if(Oyuncu[i][Oyunda] == true && Oyuncu[i][Polis] == true)
        {
			SendClientMessage(i, TELSIZ, mesaj);
        }
    }
}

SuspectMesaj(const mesaj[])
{
    if(mesaj[0] == '\0') return;
	foreach(new i : Player)
	{
        if(Oyuncu[i][Oyunda] == true && Oyuncu[i][Suspect] == true)
        {
					SendClientMessage(i, GRI, mesaj);
        }
    }
}

bosYasakID()
{
	new temp[123], Cache: result, lastid, id, returnable = 1, maxid = 1, j;
 	result = mysql_query(CopSQL, "SELECT yasakID FROM yasaklar ORDER BY yasakID ASC");
 	j = cache_num_rows();
 	for(new i = 0; i < j; i++)
 	{
 	 	maxid++;
		cache_get_value_name(i, "yasakID", temp), id = strval(temp);
  		if(id - lastid > 1)
  		{
  	 		returnable = lastid+1;
  	 		cache_delete(result);
   			return returnable;
  		}
  		lastid = id;
 	}
 	cache_delete(result);
 	return maxid;
}

strreplace(string[], const search[], const replacement[], bool:ignorecase = false, pos = 0, limit = -1, maxlength = sizeof(string))
{// No need to do anything if the limit is 0.
    if(limit == 0) return 0;
    new sublen = strlen(search), replen = strlen(replacement), bool:packed = ispacked(string), maxlen = maxlength, len = strlen(string), count = 0;
    // "maxlen" holds the max string length (not to be confused with "maxlength", which holds the max. array size).
    // Since packed strings hold 4 characters per array slot, we multiply "maxlen" by 4.
    if (packed)
        maxlen *= 4;// If the length of the substring is 0, we have nothing to look for..
    if (!sublen)
        return 0;// In this line we both assign the return value from "strfind" to "pos" then check if it's -1.
    while (-1 != (pos = strfind(string, search, ignorecase, pos)))
	{// Delete the string we found
        strdel(string, pos, pos + sublen);
        len -= sublen;// If there's anything to put as replacement, insert it. Make sure there's enough room first.
        if (replen && len + replen < maxlen) {
            strins(string, replacement, pos, maxlength);

            pos += replen;
            len += replen;
        }// Is there a limit of number of replacements, if so, did we break it?
        if (limit != -1 && ++count >= limit)
            break;
    }
    return count;
}

TRcevir(trstring[])
{
    new trstr[100];
    format(trstr, 100, "%s", trstring);
	strreplace(trstr, "ð","g");
	strreplace(trstr, "Ð","G");
	strreplace(trstr, "þ","s");
	strreplace(trstr, "Þ","S");
	strreplace(trstr, "ý","i");
	strreplace(trstr, "I","I");
	strreplace(trstr, "Ý","I");
	strreplace(trstr, "ö","o");
	strreplace(trstr, "Ö","O");
	strreplace(trstr, "ç","c");
	strreplace(trstr, "Ç","C");
	strreplace(trstr, "ü","u");
	strreplace(trstr, "Ü","U");
	return trstr;
}

SelectRandomPlayers(dest[], how_many_players, s_size = sizeof(dest))
{
	new ids[MAX_PLAYERS], count = 0;
	for(new i = 50 - 1; i != -1; i--)
		if(Oyuncu[i][GirisYapti] == true && Oyuncu[i][AFK] == false)
			ids[count++] = i;

	if(how_many_players > s_size)
		how_many_players = s_size;

	if(count < how_many_players)
		how_many_players = count;

	while(how_many_players > 0)
	{
		new rand = random(count);
		if(ids[rand] != INVALID_PLAYER_ID)
		{
			dest[--how_many_players] = ids[rand];
			ids[rand] = INVALID_PLAYER_ID;
		}
	}
}

ReturnUser(const text[])
{
	new strPos, returnID = 0, bool: isnum = true;
	while(text[strPos])
	{
		if(isnum)
		{
			if('0' <= text[strPos] <= '9') returnID = (returnID * 10) + (text[strPos] - '0');
			else isnum = false;
		}
		strPos++;
	}
	if(isnum)
	{
		if(IsPlayerConnected(returnID)) return returnID;
	}
	else
	{
		new sz_playerName[MAX_PLAYER_NAME];

		foreach(new i : Player)
		{
			GetPlayerName(i, sz_playerName, MAX_PLAYER_NAME);
			if(!strcmp(sz_playerName, text, true, strPos)) return i;
		}
	}
	return INVALID_PLAYER_ID;
}

JailGonder(playerid)
{
	new sayi = random(4);
	switch(sayi)
	{
		case 0: SetPlayerPos(playerid, 215.3556, 110.7461, 999.0156);
		case 1: SetPlayerPos(playerid, 219.3807, 110.5989, 999.0156);
		case 2: SetPlayerPos(playerid, 223.5638, 110.5576, 999.0156);
		case 3: SetPlayerPos(playerid, 227.2564, 110.4045, 999.0156);
	}
	Oyuncu[playerid][AFK] = true;
	SetCameraBehindPlayer(playerid);
	SetPlayerInterior(playerid, 10);
	SetPlayerVirtualWorld(playerid, 0);

	new mesaj[900];
	strcat(mesaj, "- Oyunda seni diðer oyunculardan üstün kýlan mod kullanamazsýn.\n");
	strcat(mesaj, "- /ooc chatte hakaret etmemelisin.\n");
	strcat(mesaj, "- Roleplay modunda roleplay kurallarýna uygun davranmalýsýn.\n");
	strcat(mesaj, "- Polis memurlarý, þüpheliler ateþ açmaya baþlayana kadar ateþ açamaz buna tekerlekler dahil.\n");
	strcat(mesaj, "- Bulunduðun aracý roleplay kurallarý içinde sürmeye dikkat etmelisin.\n");
	strcat(mesaj, "- Aracýný sürerken polislere veya þüphelilere ramming yapmamalýsýn.\n");
	strcat(mesaj, "- Þüpheli sudayken kiþiyi kelepçeleyemez, taserleyemez ya da beanbag ile ateþ edemezsin.\n");
	strcat(mesaj, "- Þüpheliler ateþ açmadýðý sürece Drive-BY (araçtan sarkma) yapamazsýn.\n");
	strcat(mesaj, "- Objeleri amacý dýþýnda kullanmak yasaktýr.\n");
	strcat(mesaj, "- Polisler araçlarýný düzgün sürmek zorunda, LINE (tek çizgi) kuralýna dikkat edilmelidir.\n");
	strins(mesaj, ""#BEYAZ2"", 0);
	ShowPlayerDialog(playerid, DIALOG_X, DIALOG_STYLE_MSGBOX, "S-PP - Kurallar", mesaj, "Kapat", "");

}

OyundaDegilMesaj(playerid)
{
	return YollaHataMesaj(playerid, "Hedef oyunda deðil veya hatalý ID.");
}

Float:OyuncuYakinMesafe(playerid, hedefid)
{
	if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(hedefid) && GetPlayerInterior(playerid) == GetPlayerInterior(hedefid))
	{
		new Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2;
	    GetPlayerPos(playerid, x1, y1, z1);
		GetPlayerPos(hedefid, x2, y2, z2);
	    return floatsqroot( ( ( x1 - x2 ) * ( x1 - x2 ) ) + ( ( y1 - y2 ) * ( y1 - y2 ) ) + ( ( z1 - z2 ) * ( z1 - z2 ) ) );
    }
    else return 999999.9999;
}

OyuncuYukle(playerid)
{
	cache_get_value_int(0, "ID", Oyuncu[playerid][SQLID]);
  cache_get_value(0, "isim", Oyuncu[playerid][OyuncuAdi], MAX_PLAYER_NAME);
	cache_get_value(0, "sifre", Oyuncu[playerid][Sifre], 65);
	cache_get_value(0, "sifresakla", Oyuncu[playerid][SSakla], 17);
	cache_get_value_int(0, "skin", Oyuncu[playerid][Kiyafet]);
	cache_get_value_int(0, "pkiyafet", Oyuncu[playerid][pKiyafet]);
	cache_get_value_int(0, "skiyafet", Oyuncu[playerid][sKiyafet]);
	cache_get_value_int(0, "skor", Oyuncu[playerid][Skor]);
	cache_get_value(0, "ipadresi", Oyuncu[playerid][IP], 16);
	cache_get_value_int(0, "yonetici", Oyuncu[playerid][Yonetici]);
	cache_get_value_int(0, "helper", Oyuncu[playerid][Helper]);
	cache_get_value_int(0, "polisarac", Oyuncu[playerid][PolisArac]);
	cache_get_value_int(0, "susturdakika", Oyuncu[playerid][SusturDakika]);
	cache_get_value_int(0, "hapisdakika", Oyuncu[playerid][HapisDakika]);
	cache_get_value_int(0, "suspectkazanma", Oyuncu[playerid][SuspectKazanma]);
	cache_get_value_int(0, "olum", Oyuncu[playerid][Olum]);
	cache_get_value_int(0, "oldurme", Oyuncu[playerid][Oldurme]);
	cache_get_value_int(0, "donator", Oyuncu[playerid][Donator]);
	cache_get_value_int(0, "isimhak", Oyuncu[playerid][IsimHak]);
	return 1;
}

OyuncuGuncelle(playerid)
{
	new sorgu[300];
	mysql_format(CopSQL, sorgu, sizeof(sorgu), "UPDATE `hesaplar` SET `skin` = %d, `pkiyafet` = %d, `skiyafet` = %d, `skor` = %d, `ipadresi` = '%s',`yonetici` = %d WHERE `ID` = %d LIMIT 1", Oyuncu[playerid][Kiyafet], Oyuncu[playerid][pKiyafet], Oyuncu[playerid][sKiyafet], Oyuncu[playerid][Skor], Oyuncu[playerid][IP], Oyuncu[playerid][Yonetici], Oyuncu[playerid][SQLID]);
	mysql_tquery(CopSQL, sorgu);

	mysql_format(CopSQL, sorgu, sizeof(sorgu), "UPDATE `hesaplar` SET `helper` = %i, `polisarac` = '%d', `susturdakika` = '%d', `hapisdakika` = '%d' WHERE `ID` = %d LIMIT 1", Oyuncu[playerid][Helper], Oyuncu[playerid][PolisArac], Oyuncu[playerid][SusturDakika], Oyuncu[playerid][HapisDakika], Oyuncu[playerid][SQLID]);
	mysql_tquery(CopSQL, sorgu);

	mysql_format(CopSQL, sorgu, sizeof(sorgu), "UPDATE `hesaplar` SET `suspectkazanma` = %d, `olum` = %d, `oldurme` = %d, `donator` = %i, `isimhak` = %i WHERE `ID` = %d LIMIT 1", Oyuncu[playerid][SuspectKazanma], Oyuncu[playerid][Olum], Oyuncu[playerid][Oldurme], Oyuncu[playerid][Donator], Oyuncu[playerid][IsimHak], Oyuncu[playerid][SQLID]);
	mysql_tquery(CopSQL, sorgu);

	return 1;
}

YoneticiYetkiAdi(yetki)
{
	new	yetkiadi[124];
	switch(yetki)
	{
	   	case 0: yetkiadi = "";
		case 1: yetkiadi = "Moderatör";
		case 2: yetkiadi = "Sunshine Admin";
		case 3: yetkiadi = "Lead Admin";
		case 4: yetkiadi = "Lead Admin";
		case 5: yetkiadi = "Developer";
		case 6: yetkiadi = "Management";
		case 7: yetkiadi = "Head Of Sunshine";
	}
 	return yetkiadi;
}

PolisRutbe(playerid)
{
	new	yetkiadi[124];
	switch(Oyuncu[playerid][Skor])
	{
	   	case -100..74: yetkiadi = "Recruit Officer";
		case 75..134: yetkiadi = "Police Officer I";
		case 135..164: yetkiadi = "Police Officer II";
		case 165..224: yetkiadi = "Police Officer III";
		case 225..299: yetkiadi = "Police Officer III+1";
		case 300..379: yetkiadi = "Police Detective I";
		case 380..559: yetkiadi = "Police Detective II";
		case 560..659: yetkiadi = "Police Sergeant I";
		case 660..859: yetkiadi = "Police Sergeant II";
		case 860..959: yetkiadi = "Police Lieutenant I";
		case 960..1059: yetkiadi = "Police Lieutenant II";
		case 1060..1159: yetkiadi = "Police Captain I";
		case 1160..1259: yetkiadi = "Police Captain II";
		case 1260..1459: yetkiadi = "Police Captain III";
		case 1460..1599: yetkiadi = "Police Commander";
		case 1600..1849: yetkiadi = "Police Deputy Chief";
		case 1850..2219: yetkiadi = "Police Assistant Chief";
	}
	if(Oyuncu[playerid][Skor] >= 2220) yetkiadi = "Chief of Police";
 	return yetkiadi;
}

GetClosestVehicle(playerid, Float:radius)
{
	new vehid = -1;
    new Float:distance = 999999.9;
	for(new v = 1, i = GetVehiclePoolSize(); v <= i; v++)
	{
		new Float:distance2 = GetDistancePlayerToVehicle(playerid, v);
		if(distance2 < radius && distance2 < distance) { distance = distance2; vehid = v; }
	}
	return vehid;
}

Tarih(timestamp, _form = 3) // date - Tarihi çek
{
    /*~ convert a Timestamp to a Date. ~ 10.07.2009
    date( 1247182451 )  will print >> 09.07.2009-23:34:11 ____ date( 1247182451, 1) will print >> 09/07/2009, 23:34:11
    date( 1247182451, 2) will print >> July 09, 2009, 23:34:11 ____ date( 1247182451, 3) will print >> 9 Jul 2009, 23:34
    */
    new year = 1970, day = 0, month = 0, hour = 3, mins = 0, sec = 0, returnstring[32];
    new days_of_month[12] = {31,28,31,30,31,30,31,31,30,31,30,31};
    new names_of_month[12][10] = {"Ocak","Þubat","Mart","Nisan","Mayýs","Haziran","Temmuz","Aðustos","Eylül","Ekim","Kasým","Aralýk"};
    while(timestamp>31622400)
	{
        timestamp -= 31536000;
        if(((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)) timestamp -= 86400;
        year++;
    }
    if(((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0))
        days_of_month[1] = 29;
    else
        days_of_month[1] = 28;
    while(timestamp>86400)
	{
        timestamp -= 86400, day++;
        if(day==days_of_month[month]) day=0, month++;
    }
    while(timestamp>60)
	{
        timestamp -= 60, mins++;
        if( mins == 60) mins=0, hour++;
    }
    sec=timestamp;
    switch(_form)
	{
        case 1: format(returnstring, 31, "%02d/%02d/%d %02d:%02d:%02d", day+1, month+1, year, hour, mins, sec);
        case 2: format(returnstring, 31, "%s %02d, %d, %02d:%02d:%02d", names_of_month[month],day+1,year, hour, mins, sec);
        case 3: format(returnstring, 31, "%d %s %d - %02d:%02d", day+1,names_of_month[month],year,hour,mins);
        default: format(returnstring, 31, "%02d.%02d.%d-%02d:%02d:%02d", day+1, month+1, year, hour, mins, sec);
    }
    return returnstring;
}

PlaySoundEx(soundid, Float:x, Float:y, Float:z, mesafe)
{
	foreach(new i : Player)
	{
		if(Oyuncu[i][GirisYapti] == false && Oyuncu[i][Oyunda] == false) continue;
		if(!IsPlayerInRangeOfPoint(i, mesafe, x, y, z)) continue;
		PlayerPlaySound(i, soundid, 0, 0, 0);
	}
}

Oyuncuadi(playerid)
{
    new oyuncuisim[MAX_PLAYER_NAME];
    GetPlayerName(playerid, oyuncuisim, MAX_PLAYER_NAME);
    return oyuncuisim;
}

HataMesajDefine(playerid, const mesaj[])
{
	return YollaFormatMesaj(playerid, RENK_YARALI, "HATA:"#BEYAZ2" %s", mesaj);
}

IpucuMesajDefine(playerid, const mesaj[])
{
	return YollaFormatMesaj(playerid, 0xA81B17FF, "%s", mesaj);
}

KullanMesajDefine(playerid, const mesaj[])
{
	return YollaFormatMesaj(playerid, COLOR_GREY, "%s", mesaj);
}

YoneticiMesajDefine(yetki, renk, const mesaj[])
{
    if(mesaj[0] == '\0') return;
	foreach(new i : Player)
	{
        if(Oyuncu[i][Yonetici] >= yetki)
        {
			SendClientMessage(i, renk, mesaj);
        }
    }
}

HelperMesajDefine(renk, const mesaj[])
{
    if(mesaj[0] == '\0') return;
	foreach(new i : Player)
	{
        if(Oyuncu[i][Yonetici] >= 1 || Oyuncu[i][Helper] == true)
        {
			SendClientMessage(i, renk, mesaj);
        }
    }
}

SoruMesajDefine(renk, const mesaj[])
{
    if(mesaj[0] == '\0') return;
	foreach(new i : Player)
	{
        if(Oyuncu[i][Yonetici] >= 1 || Oyuncu[i][Helper] == true)
        {
			SendClientMessage(i, renk, mesaj);
        }
    }
}

public OnGameModeInit()
{
	Fdurum = true;
	OyunBasladi = EventModu = EventModu2 = false;
	OyunSaniye = OYUN_SANIYE;
	OyunDakika = OYUN_DAKIKA;
	OyunDakikaSaniye = OYUN_DAKIKASANIYE;

	new saat, dk, sn;
  gettime(saat, dk, sn);
	SetWorldTime(saat);

	new MySQLOpt: option_id = mysql_init_options();
	mysql_set_option(option_id, AUTO_RECONNECT, true);
	CopSQL = mysql_connect(MYSQL_HOST, MYSQL_HESAP, MYSQL_SIFRE, MYSQL_VERITABANI, option_id);
	if(CopSQL == MYSQL_INVALID_HANDLE || mysql_errno(CopSQL) != 0)
	{
		print("[SÝSTEM] Veritabaný baðlantýsý baþarýsýz, sunucu kapanýyor.");
		SendRconCommand("exit");
		return 1;
	}
	mysql_tquery(CopSQL, "SET NAMES 'latin5'");
	print("[SÝSTEM] Veritabaný baðlantýsý baþarýlý.");
	SetGameModeText(MODADI);

	DisableInteriorEnterExits();
	EnableStuntBonusForAll(0);
	ShowPlayerMarkers(1);
	ShowNameTags(1);
	ManualVehicleEngineAndLights();
	//SetNameTagDrawDistance(10.0);
	SetTimer("SendMSG", 180000, true);
	SetTimer("PlayerFunctions", 1000, true);

	Baslat();

	for(new i; i < sizeof(Kapi); i++)
	{
		CreateDynamicPickup(1239, 1, Kapi[i][gposx], Kapi[i][gposy], Kapi[i][gposz], 0, 0);
		CreateDynamicMapIcon(Kapi[i][gposx], Kapi[i][gposy], Kapi[i][gposz], 56, 0);
	}

  //Kalan Zaman Textdraw
	KalanSure[0] = TextDrawCreate(625.600463, 161.128845, "5_dakika");
	TextDrawLetterSize(KalanSure[0], 0.313199, 1.575111);
	TextDrawAlignment(KalanSure[0], 3);
	TextDrawColor(KalanSure[0], -1);
	TextDrawSetShadow(KalanSure[0], 0);
	TextDrawSetOutline(KalanSure[0], 1);
	TextDrawBackgroundColor(KalanSure[0], 255);
	TextDrawFont(KalanSure[0], 3);
	TextDrawSetProportional(KalanSure[0], 1);
	TextDrawSetShadow(KalanSure[0], 0);

	KalanSure[1] = TextDrawCreate(578.411987, 161.128845, "Kalan:");
	TextDrawLetterSize(KalanSure[1], 0.313199, 1.575111);
	TextDrawAlignment(KalanSure[1], 3);
	TextDrawColor(KalanSure[1], -1378294017);
	TextDrawSetShadow(KalanSure[1], 0);
	TextDrawSetOutline(KalanSure[1], 1);
	TextDrawBackgroundColor(KalanSure[1], 255);
	TextDrawFont(KalanSure[1], 3);
	TextDrawSetProportional(KalanSure[1], 1);
	TextDrawSetShadow(KalanSure[1], 0);

	/*// KM/H
	KMH = TextDrawCreate(584.000000, 375.000000, "KM/H");
  TextDrawBackgroundColor(KMH, 255);
  TextDrawFont(KMH, 2);
  TextDrawLetterSize(KMH, 0.310000, 1.070000);
  TextDrawColor(KMH, -1);
  TextDrawSetOutline(KMH, 1);
  TextDrawSetProportional(KMH, 1);
  TextDrawSetSelectable(KMH, 0);*/

	HaritalariYukle();
	return 1;
}

public OnGameModeExit()
{
	OyunBasladi = EventModu = EventModu2 = false;
	OyunSaniye = OYUN_SANIYE;
	OyunDakika = OYUN_DAKIKA;
	OyunDakikaSaniye = OYUN_DAKIKASANIYE;
	KillTimer(SuspectSaklaTimer);
	KillTimer(OyunKalanTimer);
	for(new j = 1, i = GetVehiclePoolSize(); j <= i; j++)
	{
		DestroyVehicle(j);
	}
	foreach(new i : Player)
	{
		OnPlayerDisconnect(i, 1);
	}

	mysql_close(CopSQL);
	return 1;
}



public OnPlayerFakeConnect(playerid)
{
    if(Oyuncu[playerid][Yonetici] > 4)
    {
	return 0;
	}
	printf("ID %d fake connect hilesi kullanýyor.", playerid);
	YollaHataMesaj(playerid, "Hile tespit edildi, sunucudan kicklendiniz.");
	Kickle(playerid);
	AdminMessage(RENK_YARALI, "AdmCmd: %s, adlý oyuncu hile(fake connect) kullandýðý için kicklendi.", Oyuncuadi(playerid));
	return 1;
}

public OnPlayerJetpackCheat(playerid)
{
    if(Oyuncu[playerid][Yonetici] > 4)
    {
	return 0;
	}
	printf("ID %d is using jetpack cheats!", playerid);
	YollaHataMesaj(playerid, "Hile tespit edildi, sunucudan kicklendiniz.");
	Kickle(playerid);
	AdminMessage(RENK_YARALI, "AdmCmd: %s, adlý oyuncu jetpack hilesi kullandýðý için kicklendi.", Oyuncuadi(playerid));
	return 1;
}

public OnPlayerGunCheat(playerid, weaponid, ammo, hacktype)
{
    if(Oyuncu[playerid][Yonetici] > 4)
    {
	return 0;
	}
	printf("ID %d silah hilesi kullanýyor. (Silah: %d - Mermi: %d - Hile Türü: %d)", playerid, weaponid, ammo, hacktype);
	YollaHataMesaj(playerid, "Hile tespit edildi, sunucudan kicklendiniz.");
	AdminMessage(RENK_YARALI, "AdmCmd: %s(%d) adlý oyuncu silah hilesi kullanýyor olabilir. [Hile Kodu: %d]", Oyuncuadi(playerid), playerid, hacktype);
	Kickle(playerid);
	return 1;
}

public OnPlayerSpeedCheat(playerid, speedtype)
{
    if(Oyuncu[playerid][Yonetici] > 4)
    {
	return 0;
	}
	printf("ID %d speedhack kullanýyor. (Hile Türü: %d)", playerid, speedtype);
	YollaHataMesaj(playerid, "Hile tespit edildi, sunucudan kicklendiniz.");
	AdminMessage(RENK_YARALI, "AdmCmd: %s(%d), adlý oyuncu speedhack kullanýyor olabilir. [Hile Kodu: %d]", Oyuncuadi(playerid), playerid, speedtype);
	Kickle(playerid);
	return 1;
}

public OnPlayerBreakAir(playerid, breaktype)
{
    if(Oyuncu[playerid][Yonetici] > 4)
    {
	return 0;
	}
	printf("ID %d Airbreak/Teleport hilesi kullanýyor. (Hile Türü: %d)", playerid, breaktype);
	YollaHataMesaj(playerid, "Hile tespit edildi, sunucudan kicklendiniz.");
	AdminMessage(RENK_YARALI, "AdmCmd: %s, adlý oyuncu Airbreak/Teleport hilesi kullanýyor olabilir. [Hile Kodu: %d]", Oyuncuadi(playerid), breaktype);
	Kickle(playerid);
	return 1;
}

public OnPlayerSpamCars(playerid, number)
{
    if(Oyuncu[playerid][Yonetici] > 4)
    {
	return 0;
	}
	printf("ID %d used car spammed %d vehicles !", playerid, number);
	YollaHataMesaj(playerid, "Hile tespit edildi, sunucudan kicklendiniz.");
	Kickle(playerid);
	AdminMessage(RENK_YARALI, "AdmCmd: %s, adlý oyuncu hile kullanýyor olabilir.", Oyuncuadi(playerid));
	return 1;
}

public OnPlayerCarTroll(playerid, vehicleid, trolledid, trolltype)
{
    if(Oyuncu[playerid][Yonetici] > 4)
    {
	return 0;
	}
	if(trolledid == INVALID_PLAYER_ID)
		printf("ID %d Car Troll hilesi kullandý.(Araç ID: %d - Troll Tür: %d)", playerid, vehicleid, trolltype);
	else
		printf("ID %d Car Troll hilesi kullanýyor. (Trollenen: ID %d - Araç ID: %d - Hile Kodu: %d)", playerid, trolledid, vehicleid, trolltype);

	YollaHataMesaj(playerid, "Hile tespit edildi, sunucudan kicklendiniz.");
	AdminMessage(RENK_YARALI, "AdmCmd: %s, adlý oyuncu Car Troll hilesi kullandýðý için kicklendi. [ARACID: %d]", Oyuncuadi(playerid), vehicleid);
	Kickle(playerid);
	return 1;
}

public OnPlayerCashCheat(playerid, oldcash, newcash, amount)
{
    if(Oyuncu[playerid][Yonetici] > 4)
    {
	return 0;
	}
	printf("ID %d para hilesi kullanýyor. (Miktar: %d)", playerid, amount);
	YollaHataMesaj(playerid, "Hile tespit edildi, sunucudan kicklendiniz.");
	AdminMessage(RENK_YARALI, "AdmCmd: %s(%d) adlý oyuncu para hilesi kullandýðý için kicklendi.", Oyuncuadi(playerid), playerid);
	Kickle(playerid);
	return 1;
}

public OnPlayerCarSwing(playerid, vehicleid)
{
    if(Oyuncu[playerid][Yonetici] > 4)
    {
	return 0;
	}
	printf("ID %d used car swing cheats vehicle %d !", playerid, vehicleid);
	YollaHataMesaj(playerid, "Hile tespit edildi, sunucudan kicklendiniz.");
	Kickle(playerid);
	return 1;
}

public OnPlayerParticleSpam(playerid, vehicleid)
{
    if(Oyuncu[playerid][Yonetici] > 4)
    {
	return 0;
	}
	printf("ID %d used car particle spam cheats vehicle %d !", playerid, vehicleid);
	YollaHataMesaj(playerid, "Hile tespit edildi, sunucudan kicklendiniz.");
	Kickle(playerid);
	return 1;
}

public OnVehicleModEx(playerid, vehicleid, componentid, illegal)
{
    if(Oyuncu[playerid][Yonetici] > 4)
    {
	return 0;
	}
	if(illegal)
	{
		printf("ID %d araç modifiye hilesi kullanýyor. (Parça ID: %d - Araç ID: %d)", playerid, componentid, vehicleid);
		YollaHataMesaj(playerid, "Hile tespit edildi, sunucudan kicklendiniz.");
		AdminMessage(RENK_YARALI, "AdmCmd: %s(%d) adlý oyuncu modifiye hilesi kullandýðý için kicklendi.", Oyuncuadi(playerid), playerid);
		Kickle(playerid);
	}
	return 1;
}

public OnPlayerSlide(playerid, weaponid, Float:speed)
{
    if(Oyuncu[playerid][Yonetici] > 4)
    {
	return 0;
	}
	printf("ID %d is slide bugging weapon %d !", playerid, weaponid);
	YollaHataMesaj(playerid, "Hile tespit edildi, sunucudan kicklendiniz.");
	Kickle(playerid);
	return 1;
}

public OnPlayerLagout(playerid, lagtype, ping)
{
    if(Oyuncu[playerid][Yonetici] > 4)
    {
	return 0;
	}
	printf("ID %d lag hilesi kullanýyor. (Lag Türü: %d - Ping: %d)", playerid, lagtype, ping);
	return 1;
}

public OnPlayerBugAttempt(playerid, bugcode)
{
    if(Oyuncu[playerid][Yonetici] > 4)
    {
	return 0;
	}
	printf("ID %d bug kullanýyor. (Tür: %d)", playerid, bugcode);
	return 1;
}


public OnPlayerModelSelectionEx(playerid, response, extraid, modelid)
{
   if(!response)return 1;

   if(extraid == KIYAFET)
   {
   if(GetPVarInt(playerid, "kiyafetaliyor") == 1)
      {
      Oyuncu[playerid][Kiyafet] = modelid;
      SetPlayerSkinEx(playerid, modelid);
	  }
   }
   if(extraid == PDKIYAFET)
   {
   if(GetPVarInt(playerid, "kiyafetaliyor") == 1)
      {
      Oyuncu[playerid][pKiyafet] = modelid;
      SetPlayerSkinEx(playerid, modelid);

	  }
   }
   if(extraid == SUSPECTKIYAFET)
   {
   if(GetPVarInt(playerid, "kiyafetaliyor") == 1)
      {
      Oyuncu[playerid][Kiyafet] = modelid;
      SetPlayerSkinEx(playerid, modelid);
			YollaIpucuMesaj(playerid, ""#GRI2"Suçlu kýyafetinizi deðiþtirdiniz.");
	  }
   }
   if(extraid == ARACDEGISTIR)
   {
				// 596, 597, 598, 599, 523, 528, 426, 541, 402, 560,
				if(modelid == 528)
				{
					if(Oyuncu[playerid][Donator] != true || Oyuncu[playerid][Skor] <= 500)
					{
						YollaHataMesaj(playerid, "Donator deðilsiniz yada 500 skorunuz bulunmuyor.");
						return 1;
					}
				}

				if(modelid == 426)
				{
					if(Oyuncu[playerid][Skor] <= 500)
					{
						YollaHataMesaj(playerid, "500 skorunuz bulunmuyor.");
						return 1;
					}
				}

				if(modelid == 541)
				{
					if(Oyuncu[playerid][Donator] != true || Oyuncu[playerid][Skor] <= 3000)
					{
						YollaHataMesaj(playerid, "Donator deðilsiniz yada 3000 skorunuz bulunmuyor.");
						return 1;
					}
				}

				if(modelid == 402)
				{
					if(Oyuncu[playerid][Skor] <= 2000)
					{
						YollaHataMesaj(playerid, "2000 skorunuz bulunmuyor.");
						return 1;
					}
				}

				if(modelid == 560)
				{
					if(Oyuncu[playerid][Donator] != true || Oyuncu[playerid][Skor] <= 1000)
					{
						YollaHataMesaj(playerid, "Donator deðilsiniz yada 1000 skorunuz bulunmuyor.");
						return 1;
					}
				}
      Oyuncu[playerid][PolisArac] = modelid;
			YollaIpucuMesaj(playerid, ""#GRI2"Ekip aracýnýzý %s olarak güncellediniz.", ReturnVehicleModelName(modelid));
   }
   return 1;
}

forward OyuncuCanYenile(playerid);
public OyuncuCanYenile(playerid)
{
	new Float: can;
	GetPlayerHealth(playerid, can);
	SetPlayerHealth(playerid, can + 10.0);
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	/*if(pickupid == MyPickup)
	{

	}
	if(pickupid == MyPickup2)
	{

	}*/
    return 1;
}

public OnPlayerSelectDynamicObject(playerid, objectid, modelid, Float:x, Float:y, Float:z)
{
	if(Oyuncu[playerid][Oyunda] == false)
		return 1;
	if(Engel[objectid][Olusturuldu] == true)
	{
		if(Oyuncu[playerid][EngelSec] == 1)
		{
			if(Engel[objectid][Duzenleniyor] == true)
				return YollaHataMesaj(playerid, "Bu engel baþkasý tarafýndan düzenleniyor.");
			Oyuncu[playerid][DuzenleEngelID] = objectid;
			Oyuncu[playerid][DuzenleEngel] = true;
			Engel[objectid][Duzenleniyor] = true;
			Oyuncu[playerid][EngelSec] = 0;
			EditDynamicObject(playerid, Engel[objectid][ID]);
			return 1;
		}
		if(Oyuncu[playerid][EngelSec] == 2)
		{
			DestroyDynamicObject(Engel[objectid][ID]);
			DestroyDynamic3DTextLabel(Engel[objectid][Engel3D]);
			DestroyDynamicArea(Engel[objectid][AreaID]);
			Engel[objectid][Engel3D] = Text3D: INVALID_3DTEXT_ID;
			Engel[objectid][Pos][0] = Engel[objectid][Pos][1] = Engel[objectid][Pos][2] = 0.0;
			Engel[objectid][Duzenleniyor] = false;
			Engel[objectid][Olusturuldu] = false;
			if(Oyuncu[Engel[objectid][SahipID]][Oyunda] == true && Oyuncu[Engel[objectid][SahipID]][Polis] == true)
			{
				Oyuncu[Engel[objectid][SahipID]][EngelHak]--;
			}
			Engel[objectid][SahipID] = -1;
			Oyuncu[playerid][DuzenleEngelID] = -1;
			Oyuncu[playerid][DuzenleEngel] = false;
			Engel[objectid][Duzenleniyor] = false;
			Oyuncu[playerid][EngelSec] = 0;
			YollaIpucuMesaj(playerid, "Engeli kaldýrdýn. (Engel ID: %d)", objectid);
			CancelEdit(playerid);
			return 1;
		}
	}
	return 1;
}

public OnPlayerEditDynamicObject(playerid, STREAMER_TAG_OBJECT objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if(Oyuncu[playerid][Oyunda] == false)
		return 1;
	if(response == EDIT_RESPONSE_FINAL)
	{
		if(Oyuncu[playerid][DuzenleEngel] == true)
		{
			SetDynamicObjectPos(objectid, x, y, z);
		    new engelid = Oyuncu[playerid][DuzenleEngelID], mesaj[130];
			DestroyDynamic3DTextLabel(Engel[engelid][Engel3D]);
			DestroyDynamicArea(Engel[engelid][AreaID]);
			format(mesaj, sizeof(mesaj), "(Engel ID: %d) - (Oluþturan: %s)", engelid, Oyuncuadi(Engel[engelid][SahipID]));
		    Engel[engelid][Pos][0] = x; Engel[engelid][Pos][1] = y; Engel[engelid][Pos][2] = z;
		    YollaIpucuMesaj(playerid, "Engeli düzenledin. (Engel ID: %d)", engelid, Engel[engelid][Model]);
		    Engel[engelid][Engel3D] = CreateDynamic3DTextLabel(mesaj, RENK_YARALI, Engel[engelid][Pos][0], Engel[engelid][Pos][1], Engel[engelid][Pos][2], 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID);
		    Engel[engelid][AreaID] = CreateDynamicRectangle(Engel[engelid][Pos][0]+2, Engel[engelid][Pos][1]+2, Engel[engelid][Pos][0]-2, Engel[engelid][Pos][1]-2);
		    Oyuncu[playerid][DuzenleEngelID] = -1;
		    Oyuncu[playerid][DuzenleEngel] = false;
		    Engel[engelid][Duzenleniyor] = false;
		}
	}
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if(Oyuncu[playerid][brutallyWounded] == 1)
	{
		new Float: x, FLoat: y, Float: z, Float: a;
		GetPlayerPos(playerid, Float: x, Float: y, Float: z);
		GetPlayerFacingAngle(playerid, a);
		SetPlayerPos(playerid, Float: x, Float: y, Float: z);
		SetPlayerFacingAngle(playerid, a);
		OyuncuYaraliYap(playerid);
	}
	if(AracHasar[vehicleid] == true)
	{
		YollaIpucuMesaj(playerid, "Bu araç hasarlý tamir etmeyi deneyin.");
	}
	if(Oyuncu[playerid][Suspect] == true && (GetVehicleModel(vehicleid) == 497 || GetVehicleModel(vehicleid) == 430))
	{
		new Float: x, FLoat: y, Float: z, Float: a;
		GetPlayerPos(playerid, Float: x, Float: y, Float: z);
		GetPlayerFacingAngle(playerid, a);
		SetPlayerPos(playerid, Float: x, Float: y, Float: z);
		SetPlayerFacingAngle(playerid, a);
	}
	return 1;
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
	new engelid = EngelYakin(playerid);
	if(Engel[engelid][Olusturuldu] == true)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			new Panels, Doors, Lights, Tires;
			GetVehicleDamageStatus(GetPlayerVehicleID(playerid), Panels, Doors, Lights, Tires);
			UpdateVehicleDamageStatus(GetPlayerVehicleID(playerid), Panels, Doors, Lights, 15);
		}
		return 1;
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
	//SetTimerEx("PingCheck", 1000, 1, "i", playerid);
	g_MysqlRaceCheck[playerid]++;
	static const empty_player[Oyuncular];
	Oyuncu[playerid] = empty_player;
	static const empty_player2[Yasaklar];
	Yasakla[playerid] = empty_player2;
	new sorgu[200], ipadresi[16];
	GetPlayerIp(playerid, ipadresi, 16);
	mysql_format(CopSQL, sorgu, sizeof(sorgu), "SELECT * FROM yasaklar WHERE yasaklanan = '%s' OR yasakip = '%s'", Oyuncuadi(playerid), ipadresi);
	mysql_tquery(CopSQL, sorgu, "YasakKontrol", "d", playerid);
	if(Oyuncu[playerid][Yonetici] >=  2)
	{
		Oyuncu[playerid][apm] = true;
	}
	Oyuncu[playerid][Squad][0] = Oyuncu[playerid][Squad][1] = Oyuncu[playerid][SquadIstek] = -1;
	Oyuncu[playerid][Squad][2] = 0;

	RemoveBuildingForPlayer(playerid, 14795, 1388.882813, -20.882799, 1005.203125, 0.250000);
	Load_Textdraws(playerid);
	LoadAnimations(playerid);
	Player_Default(playerid);
	SetPlayerColor(playerid, GRI);
	return 1;
}

forward Player_Default(playerid);
public Player_Default(playerid)
{
	Oyuncu[playerid][Yonetici] = 0;
	TogglePlayerSpectating(playerid, 1);
	return 1;
}

forward Load_Textdraws(playerid);
public Load_Textdraws(playerid)
{
	swimTexdraw[playerid] = CreatePlayerTextDraw(playerid, 97.333351, 291.629669, "SWIM-COUNTDOWN");
	PlayerTextDrawLetterSize(playerid, swimTexdraw[playerid], 0.248666, 1.259851);
	PlayerTextDrawAlignment(playerid, swimTexdraw[playerid], 1);
	PlayerTextDrawColor(playerid, swimTexdraw[playerid], -1);
	PlayerTextDrawSetShadow(playerid, swimTexdraw[playerid], 0);
	PlayerTextDrawSetOutline(playerid, swimTexdraw[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, swimTexdraw[playerid], 255);
	PlayerTextDrawFont(playerid, swimTexdraw[playerid], 2);
	PlayerTextDrawSetProportional(playerid, swimTexdraw[playerid], 1);
	PlayerTextDrawSetShadow(playerid, swimTexdraw[playerid], 0);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(Oyuncu[playerid][Squad][0] != -1)
	{
		new hedefid = Oyuncu[playerid][Squad][0];
		Oyuncu[playerid][Squad][0] = Oyuncu[playerid][Squad][1] = -1;
		Oyuncu[playerid][Squad][2] = 0;
		Oyuncu[hedefid][Squad][0] = Oyuncu[hedefid][Squad][1] = -1;
		Oyuncu[hedefid][Squad][2] = 0;
	}
	new lastduelinvite = GetPVarInt(playerid, "LastDuelInvite");

	if(playerid == GetPVarInt(lastduelinvite, "LastDuelInvite"))
	{
		if(Oyuncu[playerid][aktifduel] == true)
		{
			if(Oyuncu[lastduelinvite][aktifduel] == true)
			{
				LobiyeDon(lastduelinvite);
				YollaIpucuMesaj(lastduelinvite, "Duel attýðýn kiþi oyundan çýkýþ yaptý.");
				SetPVarInt(lastduelinvite, "LastDuelInvite", -1);
			}
			LobiyeDon(playerid);
		}
		SetPVarInt(playerid, "LastDuelInvite", -1);
	}

	if(Oyuncu[playerid][SquadIstek] != -1)
	{
		Oyuncu[Oyuncu[playerid][SquadIstek]][SquadIstek] = -1;
		Oyuncu[playerid][SquadIstek] = -1;
	}
	KillTimer(Oyuncu[playerid][CbugTimer]);
	g_MysqlRaceCheck[playerid]++;
	KillTimer(Oyuncu[playerid][SkorTimer]);
	if(IsValidDynamic3DTextLabel(Oyuncu[playerid][ShotFired]))
	{
		DestroyDynamic3DTextLabel(Oyuncu[playerid][ShotFired]);
		Oyuncu[playerid][ShotFired] = Text3D: INVALID_3DTEXT_ID;
	}
	if(Oyuncu[playerid][GirisYapti] == false) return 0;
	if(cache_is_valid(Oyuncu[playerid][CacheID]))
	{
		cache_delete(Oyuncu[playerid][CacheID]);
		Oyuncu[playerid][CacheID] = MYSQL_INVALID_CACHE;
	}
	if(IsValidDynamic3DTextLabel(Oyuncu[playerid][AdutyLabel]))
 	{
 		Oyuncu[playerid][AdutyLabel] = Text3D: INVALID_3DTEXT_ID;
 		DestroyDynamic3DTextLabel(Oyuncu[playerid][AdutyLabel]);
 	}
	Oyuncu[playerid][GirisYapti] = false;
	if(OyunBasladi == true && Oyuncu[playerid][Oyunda])
	{
		Oyuncu[playerid][Oyunda] = Oyuncu[playerid][Suspect] = Oyuncu[playerid][Polis] = false;
		OyunKontrol();
	}
	if(Oyuncu[playerid][HapisDakika] >= 1) KillTimer(Oyuncu[playerid][HapisTimer]);
	if(Oyuncu[playerid][SusturDakika] >= 1) KillTimer(Oyuncu[playerid][SusturTimer]);
	if(IsValidDynamic3DTextLabel(Oyuncu[playerid][YaraliTag]) && Oyuncu[playerid][Oyunda] == false)
	{
		DestroyDynamic3DTextLabel(Oyuncu[playerid][YaraliTag]);
		Oyuncu[playerid][YaraliTag] = Text3D: INVALID_3DTEXT_ID;
	}
	if(IsValidDynamic3DTextLabel(Oyuncu[playerid][YardimEdiyor]))
	{
		DestroyDynamic3DTextLabel(Oyuncu[playerid][YardimEdiyor]);
		Oyuncu[playerid][YardimEdiyor] = Text3D: INVALID_3DTEXT_ID;
	}
	OyuncuGuncelle(playerid);
	return 1;
}

public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
	if(Oyuncu[playerid][GirisYapti] == false)
	{
		YollaHataMesaj(playerid, "Giriþ yapmadan komut kullanamazsýn.");
		printf("[cmd] [%s] %s giris yapmadan komut kullanmaya calisti.", Oyuncuadi(playerid), cmd);
		Kickle(playerid);
		AdminMessage(RENK_YARALI, "%s(%d) adlý oyuncu giriþ yapmadan komut kullanmaya çalýþtý. (%s)", Oyuncuadi(playerid), playerid, cmd);
		return 0;
	}
	return 1;
}

public OnPlayerText(playerid, text[])
{
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
		return 0;
	if(Oyuncu[playerid][Oyunda] == true && Oyuncu[playerid][SusturDakika] >= 1)
	{
		YollaHataMesaj(playerid, "Susturulduðun için konuþamazsýn, susturmanýn bitmesine %d kaldý.", Oyuncu[playerid][SusturDakika]);
		return 0;
	}
	if(Oyuncu[playerid][Oyunda] == false && Oyuncu[playerid][SusturDakika] >= 1)
	{
		YollaHataMesaj(playerid, "Susturulduðun için konuþamazsýn, susturmanýn bitmesine %d kaldý.", Oyuncu[playerid][SusturDakika]);
		return 0;
	}
	new mesaj[150];
	if(Oyuncu[playerid][Yonetici] >= 1) //Admin Text
	{
		if(Oyuncu[playerid][Oyunda] == false)
		{
			format(mesaj, sizeof(mesaj), ""#YARALI"(%s) "#BEYAZ2"%s(%d): %s", YoneticiYetkiAdi(Oyuncu[playerid][Yonetici]), Oyuncuadi(playerid), playerid, text); //YoneticiYetkiAdi(Oyuncu[playerid][Yonetici]),
			ProxDetectorLobi(mesaj, GetPlayerColor(playerid));
			return 0;
		}
		else
		{
			format(mesaj, sizeof(mesaj), ""#BEYAZ2"%s(%d): %s", Oyuncuadi(playerid), playerid, text);
			ProxDetector(15.0, playerid, mesaj, BEYAZ);
			return 0;
		}
	}
	if(Oyuncu[playerid][Helper] == true) //Helper Text
	{
		if(Oyuncu[playerid][Oyunda] == false)
		{
			format(mesaj, sizeof(mesaj), ""#BEYAZ2"%s(%d):"#BEYAZ2" %s", Oyuncuadi(playerid), playerid, text);
			ProxDetectorLobi(mesaj, GetPlayerColor(playerid));
			return 0;
		}
		else
		{
			format(mesaj, sizeof(mesaj), "%s: %s", Oyuncuadi(playerid), text);
			ProxDetector(15.0, playerid, mesaj, BEYAZ);
			return 0;
		}
	}
	if(Oyuncu[playerid][Donator] == true) // Donator Text
	{
		if(Oyuncu[playerid][Oyunda] == false)
		{
			format(mesaj, sizeof(mesaj), "[Donator] %s(%d):"#BEYAZ2" %s", Oyuncuadi(playerid), playerid, text);
			ProxDetectorLobi(mesaj, GetPlayerColor(playerid));
			return 0;
		}
		else
		{
			format(mesaj, sizeof(mesaj), "%s: %s", Oyuncuadi(playerid), text);
			ProxDetector(15.0, playerid, mesaj, BEYAZ);
			return 0;
		}
	}
	if(Oyuncu[playerid][Oyunda] == false)
	{
		format(mesaj, sizeof(mesaj), ""#YARALI"(Lobi) "#BEYAZ2"%s(%d): %s", Oyuncuadi(playerid), playerid, text);
		ProxDetectorLobi(mesaj, GetPlayerColor(playerid));
		return 0;
	}
	else
	{
		format(mesaj, sizeof(mesaj), ""#BEYAZ2"%s(%d): %s", Oyuncuadi(playerid), playerid, text);
		ProxDetector(15.0, playerid, mesaj, BEYAZ);
		return 0;
	}
}

public OnPlayerSpawn(playerid)
{
	ApplyAnimation(playerid, "COP_AMBIENT", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "DEALER", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "GRAVEYARD", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "INT_HOUSE", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "Attractors", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "MISC", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "FIGHT_E", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "CRIB", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "CRACK", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "PED", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "SWEET", "null", 0.0, 0, 0, 0, 0, 0);
	ApplyAnimation(playerid, "SWAT", "null", 0.0, 0, 0, 0, 0, 0);

	if(Oyuncu[playerid][HapisDakika] >= 1)
	{
		SetPlayerPos(playerid, 215.3556, 110.7461, 999.0156);
	}
	else
	{
		SetPlayerPos(playerid, Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
		SetPlayerFacingAngle(playerid, Oyuncu[playerid][Pos][3]);
		SetCameraBehindPlayer(playerid);
	}
	SetPlayerHealth(playerid, 100.0);
	SetPlayerArmour(playerid, 0.0);

	if(Oyuncu[playerid][aktifduel] == true)
	{
		Oyuncu[playerid][aktifduel] = false;
		ResetPlayerWeapons(playerid);
		LobiyeDon(playerid);
	}
	if(Oyuncu[playerid][Oyunda] == false)
	{
		ClearAnimations(playerid);
		ResetPlayerWeapons(playerid);
		LobiyeDon(playerid);
	}
	if(IsValidDynamic3DTextLabel(Oyuncu[playerid][YaraliTag]) && Oyuncu[playerid][Oyunda] == false)
	{
		DestroyDynamic3DTextLabel(Oyuncu[playerid][YaraliTag]);
		Oyuncu[playerid][YaraliTag] = Text3D: INVALID_3DTEXT_ID;
	}
	if(Oyuncu[playerid][DM] == true)
	{
		GivePlayerWeapon(playerid, 24, 500);
		GivePlayerWeapon(playerid, 25, 500);

    if(Oyuncu[playerid][DMLobi] == 1)
		{
		Oyuncu[playerid][DMLobi] = 1;
		new sayi = random(8);
    sscanf(DMKonum(sayi), "p<,>fff", Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
    SetPlayerPos(playerid, Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
		SetPlayerInterior(playerid, 3);
		SetPlayerVirtualWorld(playerid, 333);
		}

        if(Oyuncu[playerid][DMLobi] == 2)
		{
		Oyuncu[playerid][DMLobi] = 2;
		new sayi = random(8);
    sscanf(DMKonum2(sayi), "p<,>fff", Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
    SetPlayerPos(playerid, Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
		SetPlayerInterior(playerid, 1);
		SetPlayerVirtualWorld(playerid, 333);
		}

		if(Oyuncu[playerid][DMLobi] == 3)
		{
		Oyuncu[playerid][DMLobi] = 3;
		new sayi = random(8);
    sscanf(DMKonum3(sayi), "p<,>fff", Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
    SetPlayerPos(playerid, Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
		SetPlayerInterior(playerid, 1);
		SetPlayerVirtualWorld(playerid, 333);
		}

		if(Oyuncu[playerid][DMLobi] == 4)
		{
		Oyuncu[playerid][DMLobi] = 4;
		new sayi = random(8);
    sscanf(DMKonum4(sayi), "p<,>fff", Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
    SetPlayerPos(playerid, Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
		SetPlayerInterior(playerid, 10);
		SetPlayerVirtualWorld(playerid, 333);
    GivePlayerWeapon(playerid, 31, 500);
    GivePlayerWeapon(playerid, 34, 500);
		}
	}
	if(Oyuncu[playerid][brutallyWounded] == 1)
	{
		Oyuncu[playerid][ZirhHak] = Oyuncu[playerid][Oyunda] = Oyuncu[playerid][Suspect] = Oyuncu[playerid][Polis] = false;
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, LOBI_INTERIOR);
		ResetPlayerWeapons(playerid);
		SetPlayerColor(playerid, BEYAZ3);
		SetTimerEx("BugKontrol", 500, false, "d", playerid);
		new name[MAX_PLAYER_NAME + 1];
		GetPlayerName(playerid, name, sizeof name);
		ResetDamageData(playerid);
		if(IsValidDynamic3DTextLabel(Oyuncu[playerid][YaraliTag]))
		{
			DestroyDynamic3DTextLabel(Oyuncu[playerid][YaraliTag]);
			Oyuncu[playerid][YaraliTag] = Text3D: INVALID_3DTEXT_ID;
		}
		if(IsValidDynamic3DTextLabel(Oyuncu[playerid][YardimEdiyor]))
		{
			DestroyDynamic3DTextLabel(Oyuncu[playerid][YardimEdiyor]);
			Oyuncu[playerid][YardimEdiyor] = Text3D: INVALID_3DTEXT_ID;
		}
	}
	/*if(Oyuncu[playerid][YaraliArac] == true)
	{

	}*/
	if(EventModu == true || EventModu2 == true)
	{
		Oyuncu[playerid][ZirhHak] = Oyuncu[playerid][Oyunda] = Oyuncu[playerid][Suspect] = Oyuncu[playerid][Polis] = false;
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, LOBI_INTERIOR);
		ResetPlayerWeapons(playerid);
		SetPlayerColor(playerid, BEYAZ3);
		SetTimerEx("BugKontrol", 500, false, "d", playerid);
		new name[MAX_PLAYER_NAME + 1];
		GetPlayerName(playerid, name, sizeof name);
		ResetDamageData(playerid);
	}
	if(IsValidDynamic3DTextLabel(Oyuncu[playerid][ShotFired]) && Oyuncu[playerid][Oyunda] == false)
	{
		DestroyDynamic3DTextLabel(Oyuncu[playerid][ShotFired]);
		Oyuncu[playerid][ShotFired] = Text3D: INVALID_3DTEXT_ID;
	}
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	KillTimer(FlasorTimer[vehicleid]);
	SetTimerEx("AracSil", TIMER_SANIYE(4), false, "d", vehicleid);
    return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_DRIVER)
		SetPlayerArmedWeapon(playerid, 0);
	if(newstate == PLAYER_STATE_PASSENGER)
	{
	    if(GetPlayerWeapon(playerid) == 24 || Oyuncu[playerid][Beanbag] == true)
			SetPlayerArmedWeapon(playerid, 0);
	}
 	return 1;
}

public OnPlayerUpdate(playerid)
{
	new animlib[32], animname[32];
	GetAnimationName(GetPlayerAnimationIndex(playerid),animlib,32,animname,32);
	//YollaIpucuMesaj(playerid, "%d, %s, %s", GetPlayerAnimationIndex(playerid), animlib, animname);

	if(Oyuncu[playerid][aktifduel] == false && Oyuncu[playerid][DM] == false && Oyuncu[playerid][Oyunda] == true && Oyuncu[playerid][brutallyWounded] == 1)
	{
		 ApplyAnimation(playerid, "WUZI", "CS_Dead_Guy", 4.1, 0, 1, 1, 1, 0, 1);
	}
	if(Oyuncu[playerid][DM] == false && Oyuncu[playerid][aktifduel] == false && Oyuncu[playerid][Oyunda] == false && Oyuncu[playerid][GirisYapti] == true && Oyuncu[playerid][DM] == false)
	{
		if(strcmp(animname, "FIGHTKICK") == 0)
		{
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			ClearAnimations(playerid);
			TogglePlayerControllable(playerid, 0);
			SetTimerEx("CBugFreeze", 500, false, "d", playerid);
		}
		if(strcmp(animname, "FIGHTA_M") == 0)
		{
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			ClearAnimations(playerid);
			TogglePlayerControllable(playerid, 0);
			SetTimerEx("CBugFreeze", 500, false, "d", playerid);
		}
	}

	if(OyunBasladi == true)
	{
		new string[50];
		TextDrawShowForPlayer(playerid, KalanSure[0]);
		TextDrawShowForPlayer(playerid, KalanSure[1]);

		if(OyunDakikaSaniye < 10)
		{
			format(string, sizeof(string), "0%d:0%d", OyunDakika, OyunDakikaSaniye);
		}
		else
		{
			format(string, sizeof(string), "0%d:%d", OyunDakika, OyunDakikaSaniye);
		}
		TextDrawSetString(KalanSure[0], string);
	}

	if(IsPlayerInAnyVehicle(playerid))
	{
		new weaponid = GetPlayerWeapon(playerid);
		if(GetPlayerVehicleSeat(playerid) == 0)
		{
			if(weaponid == 28)
				SetPlayerArmedWeapon(playerid, 0);
		}
		if(weaponid == 24)
			SetPlayerArmedWeapon(playerid, 0);
	}

	// Minigun vb silah fixleri.
    if(GetPlayerWeapon(playerid) == 39 || GetPlayerWeapon(playerid) == 38 || GetPlayerWeapon(playerid) == 37 || GetPlayerWeapon(playerid) == 35 || GetPlayerWeapon(playerid) == 36)
    {
    ResetPlayerWeapons(playerid);
	  AdminMessage(RENK_YARALI, "AdmCmd: %s adlý oyuncu yasaklý silahý aldý. Sistem tarafýndan silah silindi ve kicklendi.", Oyuncuadi(playerid));
	  Kickle(playerid);
    }

    return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	new Ntusu = KEY_NO, animtusu = KEY_FIRE, egilmetusu = KEY_CROUCH, Ytusu = KEY_YES;
	if(newkeys & animtusu && Oyuncu[playerid][DM] == false && Oyuncu[playerid][aktifduel] == false && Oyuncu[playerid][Oyunda] == false && Oyuncu[playerid][GirisYapti] == true && Oyuncu[playerid][DM] == false)
	{
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		ClearAnimations(playerid);
		TogglePlayerControllable(playerid, 0);
		SetTimerEx("CBugFreeze", 500, false, "d", playerid);
	}
	if((newkeys & animtusu) && !(oldkeys & animtusu))
	{
		if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED)
			return 1;
		if(GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_NONE && Oyuncu[playerid][Anim] == true && Oyuncu[playerid][Taserlendi] == false)
		{
			Oyuncu[playerid][Anim] = false;
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			ClearAnimations(playerid);
		}
	}

	if(oldkeys == PLAYER_STATE_DRIVER && newkeys == PLAYER_STATE_DRIVER)
	{
    	SetPlayerArmedWeapon(playerid, 0);
	}

	if(oldkeys == PLAYER_STATE_ONFOOT && newkeys == PLAYER_STATE_PASSENGER)
    {
        if(GetPlayerWeapon(playerid) == 24)
        {
            SetPlayerArmedWeapon(playerid, 0);
            return 1;
        }
    }
	if((newkeys & Ntusu) && !(oldkeys & Ntusu))
	{
	    if(OyunBasladi == true && Oyuncu[playerid][Polis] == true && Oyuncu[playerid][Oyunda] == true)
	    {
	    	if(Oyuncu[playerid][PolisGPS] == true)
	    	{
	    		YollaIpucuMesaj(playerid, "Desteði kapattýn.");
		    	Oyuncu[playerid][PolisGPS] = false;
		    	SetPlayerColor(playerid, POLIS_RENK2);
		    	return 1;
	    	}
	    	if(Oyuncu[playerid][PolisGPS] == false)
	    	{
	    		new mesaj[150], bolge[30];
	    		GetPlayer3DZone(playerid, bolge, sizeof(bolge));
	    		format(mesaj, sizeof(mesaj), "[CH:911] %s adlý memurun desteðe ihtiyacý var. Bölge: %s", Oyuncuadi(playerid), bolge);
	    		PolisTelsiz(mesaj);
		    	Oyuncu[playerid][PolisGPS] = true;
		    	SetPlayerColor(playerid, POLIS_RENK);
		    	return 1;
	    	}
		}
	}
	if((newkeys & Ytusu) && !(oldkeys & Ytusu))
	{
	    if(OyunBasladi == true && Oyuncu[playerid][Polis] == true && Oyuncu[playerid][Oyunda] == true)
	    {
			if(IsPlayerInAnyVehicle(playerid))
				return 1;
			if(Oyuncu[playerid][OyunSilah] == true)
				return 1;
			if(Oyuncu[playerid][TaserMermiDegis] == true)
				return YollaHataMesaj(playerid, "Kartuþ yükleniyor.");
			new eylem[120];
			if(Oyuncu[playerid][Taser] == true)
			{
				Oyuncu[playerid][Taser] = false;
				SetPlayerAmmo(playerid, 23, 0);
				GivePlayerWeapon(playerid, 24, 60);
				format(eylem, sizeof(eylem), "* %s þok tabancasýný kýlýfýna koyar.", Oyuncuadi(playerid));
				ProxDetector(15.0, playerid, eylem, EMOTE_RENK);
				return 1;
			}
			if(Oyuncu[playerid][Taser] == false)
			{
				Oyuncu[playerid][Taser] = true;
				GivePlayerWeapon(playerid, 23, 10);
				format(eylem, sizeof(eylem), "* %s þok tabancasýný kýlýfýndan çýkarýr.", Oyuncuadi(playerid));
				ProxDetector(15.0, playerid, eylem, EMOTE_RENK);
				return 1;
			}
		}
	}
	if(!Oyuncu[playerid][Cbug] && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
	{
		if(PRESSED(animtusu))
		{
			switch(GetPlayerWeapon(playerid))
			{
				case WEAPON_DEAGLE, WEAPON_SHOTGUN, WEAPON_SNIPER:
				{
					Oyuncu[playerid][CbugSilah] = gettime();
				}
			}
		}
		else if(PRESSED(egilmetusu))
		{
			if((gettime() - Oyuncu[playerid][CbugSilah]) < 1)
			{
				TogglePlayerControllable(playerid, true);
				Oyuncu[playerid][Cbug] = true;
				GameTextForPlayer(playerid, "~r~C-BUG YASAK!", 1000, 4);
				//YollaIpucuMesaj(playerid, " "#YARALI" "[UYARI] C-BUG yapmaya çalýþtýðýn gözüküyor. Yöneticilere bilgi gönderildi.");
				AdminMessage(RENK_YARALI, "AdmCmd: %s(%d) C-BUG yapmaya çalýþýyor.", Oyuncuadi(playerid), playerid);
				SetTimerEx("CBugFreeze", 500, false, "d", playerid);

			}
		}
	}
	if((newkeys & KEY_SECONDARY_ATTACK) && !(oldkeys & KEY_SECONDARY_ATTACK))
	{
		if(EventModu2 == true)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, 2303.5789, -68.7443, 26.4844))
			{
				SetPlayerPos(playerid, 2305.3831, -16.1079, 26.7496);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
			}
			if(IsPlayerInRangeOfPoint(playerid, 2.0, 2305.3831, -16.1079, 26.7496))
			{
				SetPlayerPos(playerid, 2303.5789, -68.7443, 26.4844);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
			}
			if(IsPlayerInRangeOfPoint(playerid, 2.0, 2316.6118, -70.3218, 26.4844))
			{
				SetPlayerPos(playerid, 2315.7178, 0.3387, 26.7422);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
			}
			if(IsPlayerInRangeOfPoint(playerid, 2.0, 2315.7178, 0.3387, 26.7422))
			{
				SetPlayerPos(playerid, 2316.6118, -70.3218, 26.4844);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
			}
		}
	}
	return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{

	if(Oyuncu[playerid][Oyunda] == false && Oyuncu[playerid][DM] == false && Oyuncu[playerid][aktifduel] == false)
	{
		SetPlayerHealth(damagedid, 100);
		SetPlayerArmour(playerid, 0);
		return 0;
	}
	/*if (Oyuncu[playerid][DM] == false && Oyuncu[playerid][pTopallama] == false && Oyuncu[playerid][Oyunda] == true && (bodypart == 7 || bodypart == 8))
    {
		  Oyuncu[playerid][pTopallama] = true;
		  Oyuncu[playerid][TopallamaSure] = 150;
		  YollaIpucuMesaj(playerid, "Ayaðýnýzdan vuruldunuz. 150 saniye boyunca yürüyemezsiniz veya koþamazsýnýz.");
    }*/

    if(Oyuncu[playerid][DM] == true)
		{
			return 0;
		}

		if(Oyuncu[playerid][aktifduel] == true)
		{
			return 0;
		}


    if(damagedid != INVALID_PLAYER_ID)
    {

        switch(weaponid)
        {
            case 1: amount = 10; // Brass knuckles(Muþta)
            case 3: amount = 15; // Night Stick
            case 4: amount = 19; // Knife(Býçak)
            case 5: amount = 15; // Baseball Bat(Beyzbol sopasý)
            case 6: amount = 14; // Shovel(Kürek)
            case 7: amount = 8; // Pool Cue(Bilardo Sopasý)
            case 8: amount = 21; // Katana
            case 10..15: amount = 5; // 10 idli ve 15 idli silah arasý.
            case 22: amount = 20; // 9mm Pistol
            case 23: amount = 20; // Silenced Pistol
            case 24: amount = 32; // Deagle
            case 25: amount = 30; // Shotgun
            case 27: amount = 34; // Combat Shotgun
            case 28: amount = 10; // Uzi
            case 29: amount = 10; // MP5
            case 30: amount = 12; //AK 47
            case 31: amount = 14; // M4
            case 32: amount = 10; //TEC-9
            case 33: amount = 60; // Country Rifle
            case 34: amount = 400; // Sniper Rifle
        }
    }
    new Float: amoun;
    new Float: health, Float: armour;

    GetPlayerHealth(damagedid, health);
    GetPlayerArmour(damagedid, armour);

		if(Oyuncu[playerid][Taser] == true && Oyuncu[playerid][Polis] == true && Oyuncu[damagedid][Polis] == false && Oyuncu[damagedid][Taserlendi] == false && Oyuncu[damagedid][SuspectSari] == false && weaponid == 23)
		{
			if(OyuncuYakinMesafe(playerid, damagedid) >= 13.0)
			{
				YollaHataMesaj(playerid, "Hedefe yeteri kadar yakýn deðilsin.");
				return 0;
			}

			if(IsPlayerInAnyVehicle(damagedid))
				return 1;
			new eylem[130];
			format(eylem, sizeof(eylem), "* Þok tabancasý ile vuruldu. (( %s ))", Oyuncuadi(damagedid));
			ProxDetector(10.0, damagedid, eylem, EMOTE_RENK);
			TogglePlayerControllable(damagedid, 0);
			Oyuncu[damagedid][Taserlendi] = true;
			Oyuncu[playerid][TaserMermiDegis] = true;
			SetTimerEx("TaserVer", TIMER_SANIYE(3), false, "d", playerid);
			ApplyAnimation(damagedid, "CRACK", "crckdeth2", 4.1, 0, 1, 1, 1, 1, 1);
			SetTimerEx("FreezeCoz", TIMER_SANIYE(10), false, "d", damagedid);
			SetPlayerHealth(damagedid, health);
			SetPlayerArmour(damagedid, armour);
			return 1;
		}
	if(Oyuncu[playerid][Taser] == true && Oyuncu[playerid][Polis] == true && Oyuncu[damagedid][Polis] == false && Oyuncu[damagedid][Taserlendi] == false && Oyuncu[damagedid][SuspectSari] == true && weaponid == 23)
	{
		SetPlayerHealth(damagedid, health);
		SetPlayerArmour(damagedid, armour);
		return 1;
	}
	if(Oyuncu[playerid][Beanbag] == true && Oyuncu[playerid][Polis] == true && Oyuncu[damagedid][Polis] == false && Oyuncu[damagedid][Beanbaglendi] == false && Oyuncu[damagedid][SuspectSari] == false && weaponid == 25)
	{
		if(OyuncuYakinMesafe(playerid, damagedid) >= 20.0)
		{
			YollaHataMesaj(playerid, "Hedefe yeteri kadar yakýn deðilsin.");
			return 0;
		}
		if(IsPlayerInAnyVehicle(damagedid))
			return 1;
		new eylem[130];
		format(eylem, sizeof(eylem), "* Plastik mermiler ile vuruldu. (( %s ))", Oyuncuadi(damagedid));
		ProxDetector(12.0, damagedid, eylem, EMOTE_RENK);
		TogglePlayerControllable(damagedid, 0);
		Oyuncu[damagedid][Beanbaglendi] = true;
		ApplyAnimation(damagedid, "CRACK", "crckdeth2", 4.1, 0, 1, 1, 1, 1, 1);
		SetTimerEx("FreezeCoz", TIMER_SANIYE(10), false, "d", damagedid);
		SetPlayerHealth(damagedid, health);
		SetPlayerArmour(damagedid, armour);
		return 1;
	}
	if(Oyuncu[playerid][Beanbag] == true && Oyuncu[playerid][Polis] == true && Oyuncu[damagedid][Polis] == false && Oyuncu[damagedid][Beanbaglendi] == false && Oyuncu[damagedid][SuspectSari] == true && weaponid == 25)
	{
		SetPlayerHealth(damagedid, health);
		SetPlayerArmour(damagedid, armour);
		return 1;
	}

	if(Oyuncu[playerid][Oyunda] == true && Oyuncu[damagedid][Oyunda] == true && Oyuncu[damagedid][Polis] == true && Oyuncu[playerid][Suspect] == true && Oyuncu[playerid][SuspectSari] == false && weaponid != 0)
	{
		Oyuncu[playerid][SuspectSari] = true;
		new mesaj[150], bolge[30];
		GetPlayer3DZone(damagedid, bolge, sizeof(bolge));
		format(mesaj, sizeof(mesaj), "[BODY-ALARM] %s adlý memura ateþ açýldý, tüm birimler yönelsin! [Bölge: %s]", Oyuncuadi(damagedid), bolge);
		PolisTelsiz(mesaj);
		SetPlayerColor(playerid, SARI);
		SetTimerEx("SuspectSakla", TIMER_SANIYE(15), false, "d", playerid);
	}

	if(Oyuncu[playerid][Oyunda] == true && Oyuncu[playerid][Polis] == true && Oyuncu[damagedid][Suspect] == true && Oyuncu[damagedid][SuspectSari] == false)
	{
		YollaHataMesaj(playerid, "Ateþ açmayan þüpheliye hasar veremezsiniz.");
		SetPlayerHealth(damagedid, health);
		SetPlayerArmour(damagedid, armour);
		return 1;
	}

	if(Oyuncu[playerid][Oyunda] == true && Oyuncu[damagedid][Oyunda] == true && Oyuncu[playerid][Polis] == true && Oyuncu[damagedid][Polis] == true && Oyuncu[playerid][Suspect] == false && Oyuncu[damagedid][Suspect] == false)
	{
		YollaHataMesaj(playerid, "Takým arkadaþýna hasar veremezsin.");
		SetPlayerHealth(damagedid, health);
		SetPlayerArmour(damagedid, armour);
		return 1;
	}

	if(Oyuncu[playerid][Oyunda] == true && Oyuncu[damagedid][Oyunda] == true && Oyuncu[playerid][Polis] == false && Oyuncu[damagedid][Polis] == false && Oyuncu[playerid][Suspect] == true && Oyuncu[damagedid][Suspect] == true)
	{
		YollaHataMesaj(playerid, "Takým arkadaþýna hasar veremezsin.");
		SetPlayerArmour(damagedid, armour);
		SetPlayerHealth(damagedid, health);
		return 1;
	}

    switch (Oyuncu[damagedid][brutallyWounded])
    {
        case 0:
        {
            if(armour > 0)
                {
                    amoun = armour - amount;
                    if(amoun <= 0)
                    {
                        SetPlayerHealth(damagedid, health - amount);
                    }
                    else
                    {
                        if(bodypart != 9 && bodypart != 7 && bodypart != 8)
                            SetPlayerArmour(damagedid, armour - amount);
                        else
                            SetPlayerHealth(damagedid, health - amount);
                    }
                }
                else SetPlayerHealth(damagedid, health - amount);

            if(health - amount <= 5)
                {
                    Oyuncu[damagedid][brutallyWounded] = 1;
                    SetPlayerHealth(damagedid, 100);
                    ClearAnimations(damagedid);
                    OyuncuYaraliYap(damagedid);
                    ApplyAnimation(damagedid, "WUZI", "CS_Dead_Guy", 4.1, 0, 1, 1, 1, 0, 1);
										YollaIpucuMesaj(damagedid, ""#YARALI"%s tarafýndan hafif yaralandýn, takým arkadaþýn yardým ederse oyuna devam edebilirsin.", Oyuncuadi(playerid));
                    return 0;
                }
        }
        case 1:
        {
            if(health - amount <= 5)
                {
                    Oyuncu[damagedid][brutallyWounded] = 0;
                    ClearAnimations(damagedid);
                    GameTextForPlayer(damagedid, "~r~OLDUN", 1000, 3);
										SendDeathMessage(playerid, damagedid, weaponid);
										SetPVarInt(playerid, "killCount", GetPVarInt(playerid, "killCount") + 1);
										YollaIpucuMesaj(damagedid, ""#YARALI"%s tarafýndan aðýr yaralandýðýn için öldün.", Oyuncuadi(playerid));
										LobiyeDon(damagedid);
										return 0;
                }
        }
    }
    return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(EventModu == false && EventModu2 == false && Oyuncu[playerid][Oyunda] == true && Oyuncu[playerid][Suspect] == true && Oyuncu[playerid][Polis] == false && weaponid != 0)
	{
		if(!IsValidDynamic3DTextLabel(Oyuncu[playerid][ShotFired]))
			Oyuncu[playerid][ShotFired] = CreateDynamic3DTextLabel("(( BU OYUNCU ATEÞ ETTÝ ))", SARI, 0.0, 0.0, 0.2, 20.0, playerid);
		SuspectAtes = Oyuncu[playerid][SuspectSari] = true;
	}
	if(hitid == INVALID_PLAYER_ID) return 1;
	if(hittype == BULLET_HIT_TYPE_PLAYER && Oyuncu[playerid][Polis] == true && (Oyuncu[playerid][Taser] == true || Oyuncu[playerid][Beanbag] == true) && (Oyuncu[hitid][Taserlendi] == true || Oyuncu[hitid][Beanbaglendi] == true))
		return 0;
	if((hittype == BULLET_HIT_TYPE_VEHICLE && hitid == SuspectArac[0] && SuspectArac[1] && EventModu == false && EventModu2 == false && SuspectAtes == false) || (hittype == BULLET_HIT_TYPE_VEHICLE && hitid == SuspectArac[0] && SuspectArac[1] && EventModu == false && EventModu2 == false && SuspectAtes == false))
	{
		return 0;
	}
	if(hittype == BULLET_HIT_TYPE_VEHICLE && EventModu == false && EventModu2 == false && Oyuncu[playerid][Polis] == true)
	{
		if(hitid != INVALID_PLAYER_ID && Oyuncu[hitid][Polis] == true && Oyuncu[playerid][Suspect] == false) return 0;
	}
	if(hittype == BULLET_HIT_TYPE_PLAYER && Oyuncu[playerid][Oyunda] == true && Oyuncu[playerid][Suspect] == true && weaponid != 0 && SuspectAtes == true && EventModu == false && EventModu2 == false)
	{
		if(Oyuncu[playerid][SuspectSari] == true)
			return 1;

		Oyuncu[playerid][SuspectSari] = true;
	    SetPlayerColor(playerid, SARI);
	    SetTimerEx("SuspectSakla", TIMER_SANIYE(15), false, "d", playerid);
		return 1;
	}
  if(IsPlayerInAnyVehicle(playerid))
  {
        if(GetVehicleDriver(GetPlayerVehicleID(playerid)) == -1)
        {
            Player_Info(playerid, "~r~Aracta surucu yokken drive-by atamazsin.");
            RemovePlayerFromVehicle(playerid);
        }
  }
	if(weaponid == 23 && Oyuncu[playerid][Taser] == true)
	{
		new Float: mpos[3];
		GetPlayerPos(playerid, mpos[0], mpos[1], mpos[2]);
		PlaySoundEx(6003, mpos[0], mpos[1], mpos[2], 35);
		ApplyAnimation(playerid, "COLT45", "colt45_reload", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}

forward TaserVer(playerid);
public TaserVer(playerid)
{
	Oyuncu[playerid][TaserMermiDegis] = false;
	GivePlayerWeapon(playerid, 23, 1);
	return 1;
}

forward OyuncuYaraliYap(playerid);
public OyuncuYaraliYap(playerid)
{
	Oyuncu[playerid][brutallyWounded] = 1;
	GameTextForPlayer(playerid, "~r~YARALANDIN", 4000, 4);
	new string[70];
    format(string, sizeof(string), "(( BU OYUNCU YARALI. ))" );
    Oyuncu[playerid][YaraliTag] = CreateDynamic3DTextLabel(string, RENK_YARALI, 0, 0, 0.5, 30.0, playerid, INVALID_VEHICLE_ID, 1, -1, -1, -1, 100.0);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	if(Oyuncu[playerid][DM] == true)
	{
		if(killerid == INVALID_PLAYER_ID) YollaIpucuMesaj(playerid, "Çeþitli nedenlerden dolayý öldün.");
		else
		{
			SkorVer(killerid, 1);
			YollaIpucuMesaj(playerid, "%s tarafýndan öldürüldün.", Oyuncuadi(killerid));
			print("OnPlayerDeath");
			Oyuncu[killerid][Oldurme]++;
			Oyuncu[playerid][Olum]++;
			SetPlayerHealth(killerid, 100.0);
			YollaIpucuMesaj(killerid, ""#YARALI"[S-PP] "#BEYAZ2"Bir oyuncu öldürdüðünüz için sistem canýnýzý yeniledi.");
			GivePlayerMoney(playerid, 50);


			if(Oyuncu[playerid][DMLobi] == 1)
			{
			Oyuncu[playerid][DMLobi] = 1;
			SetPlayerInterior(playerid, 3);

			new sayi = random(8);
			sscanf(DMKonum(sayi), "p<,>fff", Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
			SetSpawnInfo(playerid, 0, Oyuncu[playerid][Kiyafet], Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2], Oyuncu[playerid][Pos][3], 0, 0, 0, 0, 0, 0);
			}
			if(Oyuncu[playerid][DMLobi] == 2)
			{
			Oyuncu[playerid][DMLobi] = 2;
			SetPlayerInterior(playerid, 1);

			new sayi = random(8);
			sscanf(DMKonum2(sayi), "p<,>fff", Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
			SetSpawnInfo(playerid, 0, Oyuncu[playerid][Kiyafet], Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2], Oyuncu[playerid][Pos][3], 0, 0, 0, 0, 0, 0);

			}
			if(Oyuncu[playerid][DMLobi] == 3)
			{
			Oyuncu[playerid][DMLobi] = 3;
			SetPlayerInterior(playerid, 1);

			new sayi = random(8);
			sscanf(DMKonum3(sayi), "p<,>fff", Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
			SetSpawnInfo(playerid, 0, Oyuncu[playerid][Kiyafet], Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2], Oyuncu[playerid][Pos][3], 0, 0, 0, 0, 0, 0);

			}
			if(Oyuncu[playerid][DMLobi] == 4)
			{
			Oyuncu[playerid][DMLobi] = 4;
			SetPlayerInterior(playerid, 10);

			new sayi = random(8);
			sscanf(DMKonum4(sayi), "p<,>fff", Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
			SetSpawnInfo(playerid, 0, Oyuncu[playerid][Kiyafet], Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2], Oyuncu[playerid][Pos][3], 0, 0, 0, 0, 0, 0);

			}
		}
		return 1;
	}
	if(Oyuncu[playerid][aktifduel] == true)
	{
		if(killerid == INVALID_PLAYER_ID)
			YollaIpucuMesaj(playerid, "Çeþitli nedenlerden dolayý öldün.");
		else
		{
			YollaIpucuMesaj(playerid, "%s tarafýndan öldürüldün.", Oyuncuadi(killerid));
						print("OnPlayerDeath2");
			YollaHerkeseMesaj(-1, ""DUEL2"[DUEL]"DUEL2" %s adlý oyuncu %s adlý oyuncuya karþý olan duelloyu kazandý.", Oyuncuadi(killerid), Oyuncuadi(playerid));
			LobiyeDon(killerid);
			ResetPlayerWeapons(killerid), ResetPlayerWeapons(playerid);
			Oyuncu[killerid][aktifduel] = false;
			Oyuncu[playerid][aktifduel] = false;
		}
		return 1;
	}
	if(Oyuncu[killerid][Oyunda] == true && reason != 0)
		SendDeathMessage(killerid, playerid, reason);
	if(OyunBasladi == true)
		OyunKontrol();
	if(OyunBasladi == true && Oyuncu[playerid][Oyunda] == true)
	{
		LobiyeDon(playerid);
		SetPVarInt(killerid, "killCount", GetPVarInt(killerid, "killCount") + 1);
		return 1;
	}
	new sayi = random(22);
	sscanf(LobiKonum(sayi), "p<,>fff", Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
	SetSpawnInfo(playerid, 0, Oyuncu[playerid][pKiyafet], Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2], Oyuncu[playerid][Pos][3], 0, 0, 0, 0, 0, 0);
	return 1;
}

OyuncuLobiGonder(playerid)
{
	new skin;
	if(Oyuncu[playerid][Polis] == true) skin = Oyuncu[playerid][pKiyafet];
	if(Oyuncu[playerid][Suspect] == true) skin = Oyuncu[playerid][Kiyafet];
	if(EventModu == false && EventModu2 == false && Oyuncu[playerid][brutallyWounded] == 0)
	{
		GetPlayerPos(playerid, Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
		GetPlayerFacingAngle(playerid, Oyuncu[playerid][Pos][3]);
		SetTimerEx("OyuncuYaraliYap", 400, false, "d", playerid);
		if(IsValidDynamic3DTextLabel(Oyuncu[playerid][YaraliTag]))
		{
			DestroyDynamic3DTextLabel(Oyuncu[playerid][YaraliTag]);
			Oyuncu[playerid][YaraliTag] = Text3D: INVALID_3DTEXT_ID;
		}
		SetSpawnInfo(playerid, 0, skin, Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2], Oyuncu[playerid][Pos][3], 0, 0, 0, 0, 0, 0);
	}
	else
	{
		new sayi = random(22);
		sscanf(LobiKonum(sayi), "p<,>fff", Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
		SetSpawnInfo(playerid, 0, skin, Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2], Oyuncu[playerid][Pos][3], 0, 0, 0, 0, 0, 0);
		Oyuncu[playerid][Oyunda] = Oyuncu[playerid][Suspect] = Oyuncu[playerid][Polis] = false;
		if(IsValidDynamic3DTextLabel(Oyuncu[playerid][YaraliTag]))
		{
			DestroyDynamic3DTextLabel(Oyuncu[playerid][YaraliTag]);
			Oyuncu[playerid][YaraliTag] = Text3D: INVALID_3DTEXT_ID;
		}
        SetPlayerVirtualWorld(playerid, 0);
		SetPlayerInterior(playerid, 6);
		OyuncuLobiGonder(playerid);
		if(IsValidDynamic3DTextLabel(Oyuncu[playerid][ShotFired]) && Oyuncu[playerid][Oyunda] == false)
		{
			DestroyDynamic3DTextLabel(Oyuncu[playerid][ShotFired]);
			Oyuncu[playerid][ShotFired] = Text3D: INVALID_3DTEXT_ID;
		}
	}
	TextDrawHideForPlayer(playerid, KalanSure[0]);
	TextDrawHideForPlayer(playerid, KalanSure[1]);
	SpawnPlayer(playerid);
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
	printf("%s: /%s", Oyuncuadi(playerid), cmd);
    if(result == -1)
    	return YollaHataMesaj(playerid, "Geçersiz komut, /yardim komutuna bakýn.");
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch (dialogid)
	{
		case DIALOG_X: return 1;
		case DIALOG_GIRIS:
		{
			if(!response) return Kick(playerid);
			new hashed_pass[65];
			SHA256_PassHash(inputtext, Oyuncu[playerid][SSakla], hashed_pass, 65);
			if(strcmp(hashed_pass, Oyuncu[playerid][Sifre]) == 0)
			{
				YollaIpucuMesaj(playerid, ""#YARALI"[S-PP] "#BEYAZ2"%s, hoþ geldiniz. [%s]", Oyuncuadi(playerid), ReturnDate());
        new cstring[64];
        format(cstring, sizeof(cstring), "~w~Hos geldin ~n~~y~ %s", Oyuncuadi(playerid));
        GameTextForPlayer(playerid, cstring, 1000, 1);
				//YollaHerkeseMesaj(RENK_YARALI, "[S-PP]"#BEYAZ2" %s sunucuya giriþ yaptý. [%s]", Oyuncuadi(playerid), ReturnDate()); eski o nedenle kapattýk
	      AdminMessage(RENK_YARALI, "AdmCmd: %s, sunucuya giriþ yaptý.", Oyuncuadi(playerid));
			  TogglePlayerSpectating(playerid, 0);
				cache_set_active(Oyuncu[playerid][CacheID]);
				cache_delete(Oyuncu[playerid][CacheID]);
				Oyuncu[playerid][CacheID] = MYSQL_INVALID_CACHE;
				Oyuncu[playerid][GirisYapti] = true;
				Oyuncu[playerid][AFK] = false;
				new sayi = random(22);
				sscanf(LobiKonum(sayi), "p<,>fff", Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
				SetSpawnInfo(playerid, 0, Oyuncu[playerid][pKiyafet], Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2], Oyuncu[playerid][Pos][3], 0, 0, 0, 0, 0, 0);
				SpawnPlayer(playerid);
				SetTimerEx("BugKontrol", 500, false, "d", playerid);
				SetPlayerPos(playerid, Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
				SetPlayerFacingAngle(playerid, Oyuncu[playerid][Pos][3]);
				SetPlayerScore(playerid, Oyuncu[playerid][Skor]);
				SetCameraBehindPlayer(playerid);
				SetPlayerColor(playerid, BEYAZ3);
				SetPlayerVirtualWorld(playerid, 0);
				SetPlayerInterior(playerid, LOBI_INTERIOR);
				SetPlayerSkin(playerid, Oyuncu[playerid][pKiyafet]);
				Oyuncu[playerid][SkorTimer] = SetTimerEx("OyuncuSkorVer", TIMER_DAKIKA(15), true, "d", playerid);
				Baslat();
		     	if(Oyuncu[playerid][SusturDakika] >= 1)
		     		Oyuncu[playerid][SusturTimer] = SetTimerEx("OyuncuSustur", TIMER_DAKIKA(1), true, "d", playerid);
		     	if(Oyuncu[playerid][HapisDakika] >= 1)
		     	{
		     		Oyuncu[playerid][HapisTimer] = SetTimerEx("OyuncuHapis", TIMER_DAKIKA(1), true, "d", playerid);
		     		JailGonder(playerid);
		     	}
				LobiyeDon(playerid);
			}
			else
			{
				Oyuncu[playerid][GirisDenemeleri]++;
				if(Oyuncu[playerid][GirisDenemeleri] >= 3)
				{
					ShowPlayerDialog(playerid, DIALOG_X, DIALOG_STYLE_MSGBOX, "Giriþ", "Þifrenizi birçok kez yanlýþ girdiniz bu sebepten atýldýnýz.", "Kapat", "");
					return Kickle(playerid);
				}
				else ShowPlayerDialog(playerid, DIALOG_GIRIS, DIALOG_STYLE_PASSWORD, "Giriþ", "Yanlýþ þifre girdin!\nAþaðýdaki alana lütfen þifrenizi girin:", "Giriþ", "Çýkýþ");
			}
		}
		case DIALOG_KAYIT:
		{
			if(!response) return Kick(playerid);
			if(strlen(inputtext) <= 4) return ShowPlayerDialog(playerid, DIALOG_KAYIT, DIALOG_STYLE_PASSWORD, "Kayýt", "Þifreniz 5 karakterden uzun olmalý.\nLütfen þifrenizi girin:", "Kayýt", "Çýkýþ");
			for(new i = 0; i < 16; i++) Oyuncu[playerid][SSakla][i] = random(94) + 33;
			SHA256_PassHash(inputtext, Oyuncu[playerid][SSakla], Oyuncu[playerid][Sifre], 65);
            Oyuncu[playerid][OyuncuAdi] = Oyuncuadi(playerid);
			new sorgu[250];
			mysql_format(CopSQL, sorgu, sizeof(sorgu), "INSERT INTO `hesaplar` (`isim`, `sifre`, `sifresakla`) VALUES ('%e', '%s', '%e')", Oyuncu[playerid][OyuncuAdi], Oyuncu[playerid][Sifre], Oyuncu[playerid][SSakla]);
			mysql_tquery(CopSQL, sorgu, "OyuncuYeniKayit", "d", playerid);
		}
		case TANITIM:
		{
			if(!response) return Kick(playerid);
			ShowPlayerDialog(playerid, TANITIM2, DIALOG_STYLE_MSGBOX, "TANITIM", "{FF0000}Oyun Modu\n{FFFFFF}Polisler kazandýðýnda bütün polisler +2 skor alýr.\nÞüpheliler kazandýðýnda bütün þüpheliler +4 skor alýr.\nEðer takým arkadaþýnýza zarar veriseniz skorunuz düþer.\nBunun yanýnda donator olduðunuzda skorlarda artýþ görebilirsiniz.\nBizden sana tam 5 skor! Ýyi oyunlar.","Kapat", "");
			SetPlayerScore(playerid, Oyuncu[playerid][Skor] +5);
			Oyuncu[playerid][AFK] = false;
			OyuncuGuncelle(playerid);
		}
		case DIALOG_MP3:
		{
		    if(!response) return 1;
			switch(listitem)
			{
  				case 0:
				{
					PlayAudioStreamForPlayer(playerid, "http://fenomen.listenfenomen.com/fenomen/128/icecast.audio");
				}
				case 1:
				{
					PlayAudioStreamForPlayer(playerid, "http://fenomen.listenfenomen.com/fenomenrap/128/icecast.audio");
				}
				case 2:
				{
					PlayAudioStreamForPlayer(playerid, "http://fenomen.listenfenomen.com/fenomenturk/128/icecast.audio");

				}
				case 3:
				{
					PlayAudioStreamForPlayer(playerid, "http://fenomen.listenfenomen.com/fenomenakustik/128/icecast.audio");

				}
				case 4:
				{
					PlayAudioStreamForPlayer(playerid, "http://fenomenoriental.listenfenomen.com/fenomenpop/128/icecast.audio");

				}
				case 5:
				{
					PlayAudioStreamForPlayer(playerid, "http://powerturkakustik.listenpowerapp.com/powerturkakustik/mpeg/icecast.audio");

				}
				case 6:
				{
					StopAudioStreamForPlayer(playerid);
					YollaIpucuMesaj(playerid, "MP3'ü kapattýn.");
				}
			}

		}

		case DIALOG_DMLOBI:
		{
			if(!response) return 1;
			switch(listitem)
			{
			    case 0:
			    {
						new count = 0;
						foreach(new i : Player)
						{
							if(Oyuncu[i][DMLobi] == 1)
									count++;
						}

						if(count > 10 && !Oyuncu[playerid][Yonetici])
							return YollaHataMesaj(playerid, "LVPD deathmatch lobisi dolu.");

                  new sayi = random(8);
	              sscanf(DMKonum(sayi), "p<,>fff", Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
              	  SetPlayerPos(playerid, Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
	              Oyuncu[playerid][DM] = true;
	              Oyuncu[playerid][DMLobi] = 1;

	              SetPlayerInterior(playerid, 3);
	              SetPlayerVirtualWorld(playerid, 333);
	              SetPlayerHealth(playerid, 100.0);
	              SetPlayerArmour(playerid, 50.0);
	              GivePlayerWeapon(playerid, 24, 500);
	              GivePlayerWeapon(playerid, 25, 500);
	              if(Oyuncu[playerid][DMLobi] == 1)
	              {
				  YollaIpucuMesaj(playerid, ""#YARALI"DmCmd:"#BEYAZ2" %s adlý oyuncu LVPD deathmatch lobisine katýldý.", Oyuncuadi(playerid));
				  }
				}
                case 1:
			    {
						new count = 0;
						foreach(new i : Player)
						{
							if(Oyuncu[i][DMLobi] == 2)
									count++;
						}

						if(count > 10 && !Oyuncu[playerid][Yonetici])
							return YollaHataMesaj(playerid, "Liberty City deathmatch lobisi dolu."); //sýnýr koyma

                  new sayi = random(8);
	              sscanf(DMKonum2(sayi), "p<,>fff", Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
              	  SetPlayerPos(playerid, Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
	              Oyuncu[playerid][DM] = true;
	              Oyuncu[playerid][DMLobi] = 2;
	              SetPlayerInterior(playerid, 1);
				  SetPlayerVirtualWorld(playerid, 333);
	              SetPlayerHealth(playerid, 100.0);
	              SetPlayerArmour(playerid, 50.0);
	              GivePlayerWeapon(playerid, 24, 500);
	              GivePlayerWeapon(playerid, 25, 500);

	              if(Oyuncu[playerid][DMLobi] == 2)
	              {
	              YollaIpucuMesaj(playerid, ""#YARALI"DmCmd:"#BEYAZ2" %s adlý oyuncu Liberty City deathmatch lobisine katýldý.", Oyuncuadi(playerid));
	              }
			  }
                case 2:
			    {
						new count = 0;

						foreach(new i : Player)
						{
							if(Oyuncu[i][DMLobi] == 3)
									count++;
						}

						if(count > 10 && !Oyuncu[playerid][Yonetici])
							return YollaHataMesaj(playerid, "Meat Factory deathmatch lobisi dolu."); //sýnýr koyma

                  new sayi = random(8);
	              sscanf(DMKonum3(sayi), "p<,>fff", Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
              	  SetPlayerPos(playerid, Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
	              Oyuncu[playerid][DM] = true;
	              Oyuncu[playerid][DMLobi] = 3;
	              SetPlayerInterior(playerid, 1);
				  SetPlayerVirtualWorld(playerid, 333);
	              SetPlayerHealth(playerid, 100.0);
	              SetPlayerArmour(playerid, 50.0);
	              GivePlayerWeapon(playerid, 24, 500);
	              GivePlayerWeapon(playerid, 25, 500);

	              if(Oyuncu[playerid][DMLobi] == 3)
	              {
	              YollaIpucuMesaj(playerid, ""#YARALI"DmCmd:"#BEYAZ2" %s adlý oyuncu Meat Factory deathmatch lobisine katýldý.", Oyuncuadi(playerid));
	              }
	             }
                case 3:
			    {

						new count = 0;

						foreach(new i : Player)
						{
							if(Oyuncu[i][DMLobi] == 4)
									count++;
						}

						if(count > 10 && !Oyuncu[playerid][Yonetici])
							return YollaHataMesaj(playerid, "RC Battlefield deathmatch lobisi dolu."); //sýnýr koyma

                  new sayi = random(8);
	              sscanf(DMKonum4(sayi), "p<,>fff", Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
              	  SetPlayerPos(playerid, Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
	              Oyuncu[playerid][DM] = true;
	              Oyuncu[playerid][DMLobi] = 4;
	              SetPlayerInterior(playerid, 10);
				  SetPlayerVirtualWorld(playerid, 333);
	              SetPlayerHealth(playerid, 100.0);
	              SetPlayerArmour(playerid, 100.0);
	              GivePlayerWeapon(playerid, 24, 500);
	              GivePlayerWeapon(playerid, 31, 500);
	              GivePlayerWeapon(playerid, 34, 500);

	              if(Oyuncu[playerid][DMLobi] == 4)
	              {
	              YollaIpucuMesaj(playerid, ""#YARALI"DmCmd:"#BEYAZ2" %s adlý oyuncu RC Battlefield deathmatch lobisine katýldý.", Oyuncuadi(playerid));
	              }
                }
	        }
		}
		case ASILAHAL:
		{
		    if(!response) return 1;
			switch(listitem)
			{
				case 0:
				{
				    new eylem[150];
					if(Oyuncu[playerid][Skor] < 350)
					    return YollaHataMesaj(playerid, "Skorun yeterli deðil.(M4A1 Carbine - 350 Skor)");
					GivePlayerWeapon(playerid, 31, 150);
					format(eylem, sizeof(eylem), "* %s aracýn panelinden M4A1 Carbine model silahýný alýr.", Oyuncuadi(playerid));
					ProxDetector(15.0, playerid, eylem, EMOTE_RENK);
				}

			}

		}
		case DIALOG_ARACDEGISTIR:
		{
			if(!response) return 1;
			switch(listitem)
			{
				case 0: Oyuncu[playerid][PolisArac] = 596;
				case 1: Oyuncu[playerid][PolisArac] = 597;
				case 2:	Oyuncu[playerid][PolisArac] = 598;
				case 3: Oyuncu[playerid][PolisArac] = 599;
				case 4: Oyuncu[playerid][PolisArac] = 523;
				case 5:
				{
					if(Oyuncu[playerid][Donator] == true || Oyuncu[playerid][Skor] >= 500)
					{
						Oyuncu[playerid][PolisArac] = 528;
					}
					else
					{
						YollaHataMesaj(playerid, "Donator deðilsiniz yada 500 skorunuz bulunmuyor.");
						//ShowPlayerDialog(playerid, DIALOG_ARACDEGISTIR, DIALOG_STYLE_LIST, "S-PP - Araç Deðiþtir", "Police Car (LSPD)\nPolice Car (SFPD)\nPolice Car (SASD)\nPolice Ranger\nHPV1000\nFBI Truck\nPremier\nBullet [5000 Skor]\nBuffalo [DONATOR]\nSultan [2000 Skor]", "Deðiþtir", "Kapat");
						return 1;
					}
				}
				case 6: Oyuncu[playerid][PolisArac] = 426;
				case 7:
				{
					if(Oyuncu[playerid][Donator] == false)
					{
						YollaHataMesaj(playerid, "Donator deðilsiniz.");
						//ShowPlayerDialog(playerid, DIALOG_ARACDEGISTIR, DIALOG_STYLE_LIST, "S-PP - Araç Deðiþtir", "Police Car (LSPD)\nPolice Car (SFPD)\nPolice Car (SASD)\nPolice Ranger\nHPV1000\nFBI Truck\nPremier\nBullet [5000 Skor]\nBuffalo [DONATOR]\nSultan [2000 Skor]", "Deðiþtir", "Kapat");
						return 1;
					}
					Oyuncu[playerid][PolisArac] = 541;
				}
				case 8:
				{
					if(Oyuncu[playerid][Donator] == false || Oyuncu[playerid][Skor] >= 5000)
					{
						YollaHataMesaj(playerid, "Donator deðilsiniz.");
						//ShowPlayerDialog(playerid, DIALOG_ARACDEGISTIR, DIALOG_STYLE_LIST, "S-PP - Araç Deðiþtir", "Police Car (LSPD)\nPolice Car (SFPD)\nPolice Car (SASD)\nPolice Ranger\nHPV1000\nFBI Truck\nPremier\nBullet [5000 Skor]\nBuffalo [DONATOR]\nSultan [2000 Skor]", "Deðiþtir", "Kapat");
						return 1;
					}
					Oyuncu[playerid][PolisArac] = 402;
				}
				case 9:
				{
					if(Oyuncu[playerid][Donator] == false || Oyuncu[playerid][Skor] >= 2000)
					{
						Oyuncu[playerid][PolisArac] = 560;
					}
					else
					{
						YollaHataMesaj(playerid, "2000 skorunuz bulunmuyor.");
						//ShowPlayerDialog(playerid, DIALOG_ARACDEGISTIR, DIALOG_STYLE_LIST, "S-PP - Araç Deðiþtir", "Police Car (LSPD)\nPolice Car (SFPD)\nPolice Car (SASD)\nPolice Ranger\nHPV1000\nFBI Truck\nPremier\nBullet [5000 Skor]\nBuffalo [DONATOR]\nSultan [2000 Skor]", "Deðiþtir", "Kapat");
						return 1;
					}
				}
			}
			YollaIpucuMesaj(playerid, "Kiþisel aracýnýz deðiþtirildi.");
		}
		case DIALOG_DISIMDEGISTIR:
		{
			if(!response) return 1;
			ShowPlayerDialog(playerid, DIALOG_DISIMDEGISTIR2, DIALOG_STYLE_INPUT, "S-PP - Ýsim Deðiþtirme", ""#BEYAZ2"Yeni kullanýcý adýnýzý aþaðýdaki boþluða girin.", "Tamam", "Ýptal");
		}
		case DIALOG_DISIMDEGISTIR2:
		{
			if(!response) return 1;
		    if(strlen(inputtext) > MAX_PLAYER_NAME)
		    	return YollaHataMesaj(playerid, "Ýsim aralýðý 1-24 uzunluðunda olmalýdýr.");
		    format(inputtext, MAX_PLAYER_NAME, "%s", TRcevir(inputtext));
	    	if(IsPlayerConnected(ReturnUser(inputtext)))
	    	{
				ShowPlayerDialog(playerid, DIALOG_DISIMDEGISTIR2, DIALOG_STYLE_INPUT, "S-PP - Ýsim Deðiþtirme", ""#BEYAZ2"Yeni kullanýcý adýnýzý aþaðýdaki boþluða girin.", "Tamam", "Ýptal");
				YollaHataMesaj(playerid, "Bu isim kullanýlýyor.");
				return 1;
	    	}
		    new sorgu[150], Cache: sorguj;
			mysql_format(CopSQL, sorgu, sizeof(sorgu), "SELECT * FROM hesaplar WHERE isim = '%s'", inputtext);
			sorguj = mysql_query(CopSQL, sorgu);
			if(cache_num_rows())
			{
				ShowPlayerDialog(playerid, DIALOG_DISIMDEGISTIR2, DIALOG_STYLE_INPUT, "S-PP - Ýsim Deðiþtirme", ""#BEYAZ2"Yeni kullanýcý adýnýzý aþaðýdaki boþluða girin.", "Tamam", "Ýptal");
				YollaHataMesaj(playerid, "Bu isim kullanýlýyor.");
				return 1;
			}
			cache_delete(sorguj);
		    YollaIpucuMesaj(playerid, "Ýsminiz %s olarak deðiþtirildi.", inputtext);
			Oyuncu[playerid][IsimHak] = true;
			SetPlayerName(playerid, inputtext);
			format(Oyuncu[playerid][OyuncuAdi], MAX_PLAYER_NAME, "%s", inputtext);
			mysql_format(CopSQL, sorgu, sizeof(sorgu), "UPDATE `hesaplar` SET `isim` = '%s', `isimhak` = '%i' WHERE `ID` = %d LIMIT 1", inputtext, Oyuncu[playerid][IsimHak], Oyuncu[playerid][SQLID]);
			mysql_tquery(CopSQL, sorgu);
		}
		case DIALOG_BSILAHAL:
		{
			if(!response)
			{
				new aracid = GetClosestVehicle(playerid, 4.0);
				GetVehicleParamsEx(aracid, engine2, lights2, alarm2, doors2, bonnet2, boot2, objective2);
				SetVehicleParamsEx(aracid, engine2, lights2, alarm2, doors2, bonnet2, VEHICLE_PARAMS_OFF, objective2);
				return 1;
			}
			switch(listitem)
			{
				case 0:
				{
					if(Oyuncu[playerid][Skor] < 50)
						return YollaHataMesaj(playerid, "Yeterli skorunuz bulunmuyor.");
					if(Oyuncu[playerid][Silah][0] == true)
						return YollaHataMesaj(playerid, "Bu silaha zaten sahipsin.");
					if(Oyuncu[playerid][Beanbag] == true)
						return YollaHataMesaj(playerid, "Beanbag'e sahipken bu silahý alamazsýn!");
					new eylem[150];
					format(eylem, sizeof(eylem), "* %s bagajý açtý ve Shotgun model silahý çýkarttý.", Oyuncuadi(playerid));
					ProxDetector(15.0, playerid, eylem, EMOTE_RENK);
					GivePlayerWeapon(playerid, 25, 500);
					Oyuncu[playerid][Silah][0] = true;
					new aracid = GetClosestVehicle(playerid, 4.0);
					GetVehicleParamsEx(aracid, engine2, lights2, alarm2, doors2, bonnet2, boot2, objective2);
					SetVehicleParamsEx(aracid, engine2, lights2, alarm2, doors2, bonnet2, VEHICLE_PARAMS_OFF, objective2);
				}
				case 1:
				{
					if(Oyuncu[playerid][Skor] < 140)
						return YollaHataMesaj(playerid, "Yeterli skorunuz bulunmuyor.");
					if(Oyuncu[playerid][Silah][1] == true)
						return YollaHataMesaj(playerid, "Bu silaha zaten sahipsin.");
					new eylem[150];
					format(eylem, sizeof(eylem), "* %s bagajý açtý ve MP5 model silahý çýkarttý.", Oyuncuadi(playerid));
					ProxDetector(15.0, playerid, eylem, EMOTE_RENK);
					GivePlayerWeapon(playerid, 29, 500);
					Oyuncu[playerid][Silah][1] = true;
					new aracid = GetClosestVehicle(playerid, 4.0);
					GetVehicleParamsEx(aracid, engine2, lights2, alarm2, doors2, bonnet2, boot2, objective2);
					SetVehicleParamsEx(aracid, engine2, lights2, alarm2, doors2, bonnet2, VEHICLE_PARAMS_OFF, objective2);
				}
				case 2:
				{
					if(Oyuncu[playerid][Skor] < 210)
						return YollaHataMesaj(playerid, "Yeterli skorunuz bulunmuyor.");
					if(Oyuncu[playerid][Silah][2] == true)
						return YollaHataMesaj(playerid, "Bu silaha zaten sahipsin.");
					new eylem[150];
					format(eylem, sizeof(eylem), "* %s bagajý açtý ve Rifle model silahý çýkarttý.", Oyuncuadi(playerid));
					ProxDetector(15.0, playerid, eylem, EMOTE_RENK);
					GivePlayerWeapon(playerid, 33, 500);
					Oyuncu[playerid][Silah][2] = true;
					new aracid = GetClosestVehicle(playerid, 4.0);
					GetVehicleParamsEx(aracid, engine2, lights2, alarm2, doors2, bonnet2, boot2, objective2);
					SetVehicleParamsEx(aracid, engine2, lights2, alarm2, doors2, bonnet2, VEHICLE_PARAMS_OFF, objective2);
				}
				case 3:
				{
					if(Oyuncu[playerid][Skor] < 360)
						return YollaHataMesaj(playerid, "Yeterli skorunuz bulunmuyor.");
					if(Oyuncu[playerid][Silah][3] == true)
						return YollaHataMesaj(playerid, "Bu silaha zaten sahipsin.");
					new eylem[150];
					format(eylem, sizeof(eylem), "* %s bagajý açtý ve M4 model silahý çýkarttý.", Oyuncuadi(playerid));
					ProxDetector(15.0, playerid, eylem, EMOTE_RENK);
					GivePlayerWeapon(playerid, 31, 500);
					Oyuncu[playerid][Silah][3] = true;
					new aracid = GetClosestVehicle(playerid, 4.0);
					GetVehicleParamsEx(aracid, engine2, lights2, alarm2, doors2, bonnet2, boot2, objective2);
					SetVehicleParamsEx(aracid, engine2, lights2, alarm2, doors2, bonnet2, VEHICLE_PARAMS_OFF, objective2);
				}
				case 4:
				{
					if(Oyuncu[playerid][Donator] == false && Oyuncu[playerid][Skor] < 950)
						return YollaHataMesaj(playerid, "Donator deðilsiniz yada yeterli skorunuz bulunmuyor.");
					if(Oyuncu[playerid][Silah][4] == true)
						return YollaHataMesaj(playerid, "Bu silaha zaten sahipsin.");
					new eylem[150];
					format(eylem, sizeof(eylem), "* %s bagajý açtý ve Sniper Rifle model silahý çýkarttý.", Oyuncuadi(playerid));
					ProxDetector(15.0, playerid, eylem, EMOTE_RENK);
					GivePlayerWeapon(playerid, 34, 500);
					Oyuncu[playerid][Silah][4] = true;
					new aracid = GetClosestVehicle(playerid, 4.0);
					GetVehicleParamsEx(aracid, engine2, lights2, alarm2, doors2, bonnet2, boot2, objective2);
					SetVehicleParamsEx(aracid, engine2, lights2, alarm2, doors2, bonnet2, VEHICLE_PARAMS_OFF, objective2);
				}
				/*case 5:
				{
					if(Oyuncu[playerid][Donator] == false)
						return YollaHataMesaj(playerid, "Donator deðilsin.");
					if(Oyuncu[playerid][Silah][5] == true)
						return YollaHataMesaj(playerid, "Bu silaha zaten sahipsin.");
					new eylem[150];
					format(eylem, sizeof(eylem), "* %s bagajý açtý ve Combat Shotgun model silahý çýkarttý.", Oyuncuadi(playerid));
					ProxDetector(15.0, playerid, eylem, EMOTE_RENK);
					GivePlayerWeapon(playerid, 27, 500);
					Oyuncu[playerid][Silah][5] = true;
					new aracid = GetClosestVehicle(playerid, 4.0);
					GetVehicleParamsEx(aracid, engine2, lights2, alarm2, doors2, bonnet2, boot2, objective2);
					SetVehicleParamsEx(aracid, engine2, lights2, alarm2, doors2, bonnet2, VEHICLE_PARAMS_OFF, objective2);
				}
				case 6:
				{
					if(Oyuncu[playerid][Donator] == false)
						return YollaHataMesaj(playerid, "Donator deðilsin.");
					if(Oyuncu[playerid][Silah][6] == true)
						return YollaHataMesaj(playerid, "Bu silaha zaten sahipsin.");
					new eylem[150];
					format(eylem, sizeof(eylem), "* %s bagajý açtý ve Sawn-Off Shotgun model silahý çýkarttý.", Oyuncuadi(playerid));
					ProxDetector(15.0, playerid, eylem, EMOTE_RENK);
					GivePlayerWeapon(playerid, 26, 500);
					Oyuncu[playerid][Silah][6] = true;
					new aracid = GetClosestVehicle(playerid, 4.0);
					GetVehicleParamsEx(aracid, engine2, lights2, alarm2, doors2, bonnet2, boot2, objective2);
					SetVehicleParamsEx(aracid, engine2, lights2, alarm2, doors2, bonnet2, VEHICLE_PARAMS_OFF, objective2);
				}*/
			}
		}
		case DIALOG_OYUNMODU:
		{
			if(!response)
			{
				Oyuncu[playerid][OyunModu] = false;
				OyunModuTip = 1;
				KillTimer(Oyuncu[playerid][OyunModTimer]);
				YollaHerkeseMesaj(RENK_YARALI, "OYUN:"#BEYAZ2" Oyun modu "#KIRMIZI2"Non-RP"#BEYAZ2" olarak seçildi, oyunu bu moda göre devam ettirin!");
				YollaHerkeseMesaj(RENK_YARALI, "OYUN:"#BEYAZ2" Birazdan silahlarýn teslim edilecek ve araç üzerindeki spawn korumasý kalkacak.");
				foreach(new i : Player)
				{
					if(Oyuncu[i][GirisYapti] == true && Oyuncu[i][Oyunda] == true)
					{
						TogglePlayerControllable(i, 1);
					}
				}
				return 1;
			}
			OyunModuTip = 2;
			Oyuncu[playerid][OyunModu] = false;
			KillTimer(Oyuncu[playerid][OyunModTimer]);
			YollaHerkeseMesaj(RENK_YARALI, "OYUN:"#BEYAZ2" Oyun modu "#YESIL2"Roleplay"#BEYAZ2" olarak seçildi, oyunu bu moda göre devam ettirin!");
			YollaHerkeseMesaj(RENK_YARALI, "OYUN:"#BEYAZ2" Birazdan silahlarýn teslim edilecek ve araç üzerindeki spawn korumasý kalkacak.");
            YollaHerkeseMesaj(RENK_YARALI, "OYUN:"#BEYAZ2" Rol mantýðýna uymayan hareketler sergilemeniz ceza almanýza neden olur.", Oyuncuadi(playerid));
			foreach(new i : Player)
			{
				if(Oyuncu[i][GirisYapti] == true && Oyuncu[i][Oyunda] == true)
				{
					TogglePlayerControllable(i, 1);
				}
			}
		}
		case DIALOG_SQUAD_ONAY:
		{
			if(!response)
			{
				new hedefid = Oyuncu[playerid][SquadIstek];
				Oyuncu[playerid][Squad][0] = Oyuncu[playerid][Squad][1] = Oyuncu[hedefid][Squad][0] = Oyuncu[hedefid][Squad][1] = Oyuncu[hedefid][SquadIstek] = -1;
				Oyuncu[playerid][Squad][2] = Oyuncu[hedefid][Squad][2] = 0;
				YollaIpucuMesaj(hedefid, "%s adlý oyuncu squad isteðinizi reddetti.", Oyuncuadi(playerid));
				YollaIpucuMesaj(playerid, "%s adlý oyuncunun squad isteðini reddettin.", Oyuncuadi(hedefid));
			}
			else
			{
				if(OyunBasladi == true || (0 <= OyunSaniye <= 6))
					return YollaHataMesaj(playerid, "Oyun baþladý yada baþlamak üzere isteði kabul edemezsin.");
				if(Oyuncu[playerid][Oyunda] == true)
					return YollaHataMesaj(playerid, "Oyundayken bu isteðe cevap veremezsin.");
				if(Oyuncu[playerid][Squad] != -1)
					return YollaHataMesaj(playerid, "Zaten squad ayarlamýþsýn iptal etmek için /squadiptal komutunu kullan.");

				new hedefid = Oyuncu[playerid][SquadIstek];
				Oyuncu[hedefid][Squad][0] = playerid;
				Oyuncu[hedefid][Squad][1] = 0;
				Oyuncu[playerid][Squad][0] = hedefid;
				Oyuncu[playerid][Squad][1] = 1;
				Oyuncu[hedefid][Squad][2] = Oyuncu[playerid][Squad][2] = 0;
				YollaIpucuMesaj(hedefid, "%s adlý oyuncu squad isteðini kabul etti.", Oyuncuadi(playerid));
				YollaIpucuMesaj(playerid, "%s adlý oyuncunun squad isteðini kabul ettin.", Oyuncuadi(hedefid));
			}
		}
		default: return 0;
	}
	return 1;
}

CMD:yardimet(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");
	if(Oyuncu[playerid][brutallyWounded] == 1)
		return YollaHataMesaj(playerid, "Yaralý olduðun için yardým edemiyorsun.");
	if(IsPlayerInAnyVehicle(playerid))
		return YollaHataMesaj(playerid, "Araçta bu komutu kullanamazsýn.");

	new hedefid;
	if(sscanf(params, "u", hedefid))
		return YollaKullanMesaj(playerid, "/yardimet [hedef adý/ID]");
	if(playerid == hedefid)
		return YollaHataMesaj(playerid, "Bu komutu kendi üzerinde kullanamazsýn.");
	if(!IsPlayerConnected(hedefid) || Oyuncu[hedefid][GirisYapti] == false)
		return YollaHataMesaj(playerid, "Bu oyuncu oyunda deðil.");
	if(OyuncuYakinMesafe(playerid, hedefid) >= 3.5)
		return YollaHataMesaj(playerid, "Bu oyuncu yanýnda deðil.");
	if(Oyuncu[hedefid][brutallyWounded] == 0)
		return YollaHataMesaj(playerid, "Bu oyuncu yaralý deðil.");

	if((Oyuncu[playerid][Suspect] == true && Oyuncu[hedefid][Suspect] == true) || (Oyuncu[playerid][Polis] == true && Oyuncu[hedefid][Polis] == true))
	{
		Oyuncu[hedefid][brutallyWounded] = 0;
		TogglePlayerControllable(playerid, false);
		SetTimerEx("OyuncuYerdenKaldir", TIMER_SANIYE(5), false, "dd", playerid, hedefid);
		YollaIpucuMesaj(hedefid, "%s adlý oyuncu seni yerden kaldýrýyor.", Oyuncuadi(playerid));
		YollaIpucuMesaj(playerid, "%s adlý oyuncuyu yerden kaldýrýyorsun.", Oyuncuadi(hedefid));
		//DestroyDynamic3DTextLabel(Oyuncu[hedefid][YaraliTag]); // Bug olursa bunu aç.
		new string[70];
        format(string, sizeof(string), "(( Bu oyuncu yaralýya yardým ediyor. ))", playerid);
        Oyuncu[playerid][YardimEdiyor] = CreateDynamic3DTextLabel(string, RENK_YARALI, 0, 0, 0.5, 30.0, playerid, INVALID_VEHICLE_ID, 1, -1, -1, -1, 100.0);
        //DestroyDynamic3DTextLabel(Oyuncu[hedefid][YardimEdiyor]); // Bug olursa bunu aç. (2)
	}
	else YollaHataMesaj(playerid, "Sadece takým arkadaþýna yardým edebilirsin.");
	return 1;
}

forward OyuncuYerdenKaldir(playerid, hedefid);
public OyuncuYerdenKaldir(playerid, hedefid)
{
	TogglePlayerControllable(playerid, true);
	SetPlayerHealth(hedefid, 70.0);
	SetPlayerArmour(hedefid, 15.0);
	if(Oyuncu[playerid][Polis] == true)
	{
	GivePlayerWeapon(hedefid, 24, 75);
	GivePlayerWeapon(hedefid, 25, 35);
	//GivePlayerWeapon(hedefid, 31, 200);
	}
	if(Oyuncu[playerid][Suspect] == true)
	{
	GivePlayerWeapon(hedefid, 24, 75);
	GivePlayerWeapon(hedefid, 25, 35);
	GivePlayerWeapon(hedefid, 30, 200);
	}
	ApplyAnimation(hedefid, "PED", "IDLE_CHAT", 4.1, 0, 0, 0, 0, 1, 0);
	if(IsValidDynamic3DTextLabel(Oyuncu[hedefid][YaraliTag]))
	{
		DestroyDynamic3DTextLabel(Oyuncu[hedefid][YaraliTag]);
		Oyuncu[hedefid][YaraliTag] = Text3D: INVALID_3DTEXT_ID;
	}
	if(IsValidDynamic3DTextLabel(Oyuncu[playerid][YardimEdiyor]))
	{
		DestroyDynamic3DTextLabel(Oyuncu[playerid][YardimEdiyor]);
		Oyuncu[playerid][YardimEdiyor] = Text3D: INVALID_3DTEXT_ID;
	}
	return 1;
}

CMD:gir(playerid)
{
	for(new i; i < sizeof(Kapi); i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.5, Kapi[i][gposx], Kapi[i][gposy], Kapi[i][gposz]))
		{
			SetPlayerPos(playerid, Kapi[i][cposx], Kapi[i][cposy], Kapi[i][cposz]);
			SetPlayerInterior(playerid, Kapi[i][Int]);
			SetPlayerVirtualWorld(playerid, Kapi[i][VW]);
		}
	}
	return 1;
}

CMD:cik(playerid)
{
	for(new i; i < sizeof(Kapi); i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.5, Kapi[i][cposx], Kapi[i][cposy], Kapi[i][cposz]) && GetPlayerVirtualWorld(playerid) == Kapi[i][VW])
		{
			SetPlayerPos(playerid, Kapi[i][gposx], Kapi[i][gposy], Kapi[i][gposz]);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
		}
	}
	return 1;
}

/*CMD:kisayol(playerid, params[])
{
    if(!Oyuncu[playerid][pKisayol])
    {
        Oyuncu[playerid][pKisayol] = 1;
        SendClientMessageEx(playerid, COLOR_WHITE, "Tuþlarý aktif ettin. Aþaðýda listelenen tuþlarý artýk kullanabileceksin.");
        SendClientMessageEx(playerid, COLOR_YELLOW, "Y: Bir evin, iþletmenin veya binanýn içine girmeye ve motoru açýp kapatmaya yarar.");
        SendClientMessageEx(playerid, COLOR_YELLOW, "N: Animasyon durdurmaya, araç kilidi açýp kapatmaya yarar.");
    }
    else
    {
        Oyuncu[playerid][pKisayol] = 0;
        SendClientMessageEx(playerid, COLOR_WHITE, "Tuþlarý deaktif ettin. Tuþlarý kullanamýyosun, aþaðýda komutlar listelendi.");
        SendClientMessageEx(playerid, COLOR_YELLOW, "/gir - /cik: Eve, iþletmeye, binalara girmeye yarar.");
        SendClientMessageEx(playerid, COLOR_YELLOW, "/motor: Aracýn motorunu açýp kapatmaya yarar.");
        SendClientMessageEx(playerid, COLOR_YELLOW, "/kilit: Aracýn kilidini açýp kapatmaya yarar.");
    }
    return 1;
}*/

CMD:hasarlar(playerid, params[])
{
	new id;
	new hedefid;

	if(strlen(params) <= 0) id = playerid;

	if(sscanf(params, "u", id)) return YollaFormatMesaj(playerid, COLOR_GREY, "Kullaným: /hasarlar [id/isim]");
	{
		if(!IsPlayerConnected(id))
		    return YollaFormatMesaj(playerid, -1, "Bu kiþi oyunda deðil.");

		if(!GetDistanceBetweenPlayers(playerid, id, 5.0))
		    return YollaFormatMesaj(playerid, -1, "Bu kiþi yakýnýnýzda deðil.");

        DisplayDamageData(id, hedefid);
	}
	return 1;
}

/*CMD:hasarlar(playerid, params[])
{
    new id;

    if(strlen(params) <= 0) id = playerid;

    else if(sscanf(params, "k<m>", id))
	return YollaKullanMesaj(playerid, "/hasarlar [id/isim]");

    if(!IsPlayerConnected(id) || !Oyuncu[playerid][GirisYapti])
	return YollaKullanMesaj(playerid, "Geçersiz ID.");

    if(!ProxDetectorOyun(8.0, playerid, id))
	return YollaHataMesaj(id, "Bu oyuncuya yakýn deðilsin.");

    new damagesString[1024] = "Ýsim\tSilah\tHasar\tBölgesi\n";

    for(new i; i < MAX_DAMAGES_FOR_PLAYER; i++)
    {
        if(!PlayerDamages[id][i][eOccupied] || PlayerDamages[id][i][eAmount] < 1) continue;
        format(damagesString, sizeof(damagesString), "%s%s\t%s\t%d\t%s\n", damagesString, PlayerDamages[id][i][eIssuer], GetWeaponName(PlayerDamages[id][i][eWeapon]), PlayerDamages[id][i][eAmount], PlayerDamages[id][i][eBodypart]);
    }

    ShowPlayerDialog(playerid, DIALOG_X, DIALOG_STYLE_TABLIST_HEADERS, Oyuncuadi(playerid), damagesString, "Ýleri", "");

    return 1;
}*/

CMD:acmds(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 1)
		return 1;

    YollaFormatMesaj(playerid, COLOR_SUPPORTER, "[Supporters] /sc - /spawn - /uyari - /sorured - /scmds - /sorucevap");
	YollaFormatMesaj(playerid, COLOR_MODERATOR, "[Moderator]  /a - /fixveh - /aflip - /mjail - /baslat - /cc - /kick - /ban - /spawn - /slap");
	YollaFormatMesaj(playerid, COLOR_MODERATOR, "[Moderator]  /uyari - /aspec(off) - /aduty - /sc - /raporkabul - /raporred - /restart - /amute");
	if(Oyuncu[playerid][Yonetici] >= 2)
	{
		YollaFormatMesaj(playerid, COLOR_LIGHTRED, "[Sunshine Admin]  - /ban - /setvw - /setint - /goto - /gethere - /sethp - /freeze");
		YollaFormatMesaj(playerid, COLOR_LIGHTRED, "[Sunshine Admin] /ajail - /unjail - /engelsifirla - /dmkilitle - /cezaver");
	}
	if(Oyuncu[playerid][Yonetici] >= 3)
	{
		YollaFormatMesaj(playerid, COLOR_LIGHTRED, "[Lead Admin] /givegun - /offban - /unban - /makesupporter - /gotopos - /getcar - /gotocar - /setweather - /settime");
		YollaFormatMesaj(playerid, COLOR_LIGHTRED, "[Lead Admin] /setskin - /setname - /pskor - /setscore - /setscoreall - /setarmor - /apm - /freezeall - /oockapat - /muzik");
	}
	if(Oyuncu[playerid][Yonetici] >=4)
	{
	YollaFormatMesaj(playerid, RENK_BRHELP, "[Geliþtirici] /makeadmin - /bakim(sunucuyu bakýma alýr), /gmx(sunucuyu resetler), /serverkilit(sunucuya þifre koyar), /dmsifirla(top5 sýfýrlanýr)");
	}
	/*if(Oyuncu[playerid][Yonetici] >= 5)
	{
		YollaFormatMesaj(playerid, COLOR_LIGHTRED, "[Lead Admin] /offban - /unban - /makesupporter - /gotopos - /getcar - /gotocar - /setweather - /settime");
		YollaFormatMesaj(playerid, COLOR_LIGHTRED, "[Lead Admin] /setskin - /setname - /pskor - /setscore - /setscoreall - /setarmor - /apm - /freezeall - /oockapat - /muzik");
	}*/
	if(Oyuncu[playerid][Yonetici] >= 7)
		YollaFormatMesaj(playerid, COLOR_LIGHTRED, "[Head of Sunshine] /makeadmin2(rcon) - /donatoryap - /event(pasif) - /bakim - /gmx(sunucuyu resetler)");
	return 1;
}

CMD:squad(playerid, params[])
{
	if(OyunBasladi == true || (0 <= OyunSaniye <= 6))
		return YollaHataMesaj(playerid, "Oyun baþladý yada baþlamak üzere bu komutu kullanamazsýn.");
	if(Oyuncu[playerid][Oyunda] == true)
		return YollaHataMesaj(playerid, "Oyundayken bu komutu kullanamazsýn.");
	if(Oyuncu[playerid][SquadIstek] != -1)
		return YollaHataMesaj(playerid, "Zaten squad isteði göndermiþsin iptal etmek için /squadiptal komutunu kullan.");

	new hedefid, mesaj[200];
	if(sscanf(params, "u", hedefid))
		return YollaKullanMesaj(playerid, "/squad [hedef adý/ID]");
	if(playerid == hedefid)
		return YollaHataMesaj(playerid, "Bu komutu kendi üzerinde kullanamazsýn.");
	if(!IsPlayerConnected(hedefid) || Oyuncu[hedefid][GirisYapti] == false)
		return YollaHataMesaj(playerid, "Bu oyuncu oyunda deðil.");
	if(Oyuncu[hedefid][Squad][0] != -1)
		return YollaHataMesaj(playerid, "Bu oyuncunun zaten squadý var.");
	if(Oyuncu[hedefid][SquadIstek] != -1)
		return YollaHataMesaj(playerid, "Bu oyuncuya zaten baþkasý istek yollamýþ.");

	Oyuncu[hedefid][SquadIstek] = playerid;
	Oyuncu[playerid][SquadIstek] = hedefid;
	format(mesaj, sizeof(mesaj), "%s adlý oyuncu size squad isteði gönderdi, kabul etmek için evet butonuna basýn.", Oyuncuadi(playerid));
	ShowPlayerDialog(hedefid, DIALOG_SQUAD_ONAY, DIALOG_STYLE_MSGBOX, "Squad Onay", mesaj, "Evet", "Hayýr");
	YollaIpucuMesaj(playerid, "%s adlý oyuncuya squad isteði gönderdin.", Oyuncuadi(hedefid));
	return 1;
}

CMD:squadiptal(playerid)
{
	if(OyunBasladi == true || (0 <= OyunSaniye <= 6))
		return YollaHataMesaj(playerid, "Oyun baþladý yada baþlamak üzere bu komutu kullanamazsýn.");
	if(Oyuncu[playerid][Oyunda] == true)
		return YollaHataMesaj(playerid, "Oyundayken bu komutu kullanamazsýn.");
	if(Oyuncu[playerid][Squad][0] == -1 && Oyuncu[playerid][SquadIstek] == -1)
		return YollaHataMesaj(playerid, "Zaten squadýn boþ.");

	new hedefid = Oyuncu[playerid][SquadIstek];
	if(Oyuncu[playerid][Squad][0] == hedefid)
	{
		Oyuncu[hedefid][Squad][0] = Oyuncu[hedefid][Squad][1] = Oyuncu[playerid][Squad][0] = Oyuncu[playerid][Squad][1] = -1;
		Oyuncu[hedefid][Squad][1] = Oyuncu[playerid][Squad][1] = 0;
	}
	if(Oyuncu[playerid][SquadIstek] == hedefid)
	{
		Oyuncu[hedefid][SquadIstek] = Oyuncu[playerid][SquadIstek] = -1;
	}
	YollaIpucuMesaj(hedefid, "%s adlý oyuncu squad olmaktan vazgeçti.", Oyuncuadi(playerid));
	YollaIpucuMesaj(playerid, "%s adlý oyuncu ile squad olmaktan vazgeçtin.", Oyuncuadi(hedefid));
	return 1;
}

CMD:baslat(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 1)
		return 1;

	Baslat();
	return 1;
}

CMD:abaslat(playerid)
{
    if (Oyuncu[playerid][GirisYapti] == false) return 0;
	if (Oyuncu[playerid][Yonetici] < 4) return YollaHataMesaj(playerid, "Yetersiz yetki.");
	foreach(new i : Player)
	{
		YollaIpucuMesaj(i, "%s adlý yetkili oyunu hýzlý baþlattý.", Oyuncuadi(playerid));
	}
	OyunSaniye = 1;
	return 1;
}

CMD:a(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 1)
		return 1;
	new mesaj[150];
	if(sscanf(params, "s[150]", mesaj))
		return YollaKullanMesaj(playerid, "/a [mesaj]");

	if(Oyuncu[playerid][SQLID] == 2 || Oyuncu[playerid][SQLID] == 4 || Oyuncu[playerid][SQLID] == 7)
	{
	YollaYoneticiMesaj(1, YONETIM_RENK, "[AChat] (Head Of Sunshine) %s - (ID: %d):"#BEYAZ2" %s", Oyuncuadi(playerid), playerid, mesaj);
	}

	if(Oyuncu[playerid][Yonetici] <= 5)
	{
	YollaYoneticiMesaj(1, YONETIM_RENK, "[AChat] (%s) %s - (ID: %d):"#BEYAZ2" %s", YoneticiYetkiAdi(Oyuncu[playerid][Yonetici]), Oyuncuadi(playerid), playerid, mesaj);
	}
	return 1;
}

CMD:sc(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 1 && Oyuncu[playerid][Helper] == false)
		return 1;

	new mesaj[150];
	if(sscanf(params, "s[150]", mesaj))
		return YollaKullanMesaj(playerid, "/sc [mesaj]");
	YollaHelperMesaj(YONETIM_RENK, "[SC] %s:"#BEYAZ2" %s", Oyuncuadi(playerid), mesaj);
	return 1;
}

CMD:serhantroll31(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 6)
        return 1;

    new vehicleid, derece;

    if (sscanf(params, "dd", vehicleid, derece))
        return YollaKullanMesaj(playerid, "/serhantroll31 [Araç ID] [derece]");

    if (vehicleid < 1 || vehicleid > MAX_VEHICLES || !IsValidVehicle(vehicleid))
        return YollaHataMesaj(playerid, "Geçersiz araç ID'si belirttin.");

    SetVehicleZAngle(vehicleid, derece);
    return 1;
}

CMD:revive(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] <= 1)
		return 1;

	new userid;

	if(sscanf(params, "d", userid))
		return YollaKullanMesaj(playerid, "/revive [Oyuncu ID]");

	if(Oyuncu[userid][brutallyWounded] == 0)
		return YollaHataMesaj(playerid, "Bu oyuncu yaralý deðil.");

	Oyuncu[userid][brutallyWounded] = 0;
	SetPlayerHealth(userid, 100.0);
	if(!IsValidDynamic3DTextLabel(Oyuncu[userid][YaraliTag]))
	{
 	DestroyDynamic3DTextLabel(Oyuncu[userid][YaraliTag]);
  }
	SetPlayerSpecialAction(userid, SPECIAL_ACTION_NONE);
	ClearAnimations(userid);
	TogglePlayerControllable(userid, 1);
	YollaIpucuMesaj(userid, ""#GRI2"Yaralý durumunuz düzeltildi.");
	AdminMessage(RENK_YARALI, "AdmCmd: %s adlý yönetici %s kullanýcýsýný revive komutu ile kaldýrdý.", Oyuncuadi(playerid), Oyuncuadi(userid));
	return 1;
}

CMD:tagfix(playerid, params[])
{

	if(Oyuncu[playerid][Yonetici] <= 1)
		return 1;

	new userid;

	if(sscanf(params, "d", userid))
		return YollaKullanMesaj(playerid, "/tagfix [Oyuncu ID]");

	if(IsValidDynamic3DTextLabel(Oyuncu[userid][YaraliTag]))
	{
		DestroyDynamic3DTextLabel(Oyuncu[userid][YaraliTag]);
		Oyuncu[userid][YaraliTag] = Text3D: INVALID_3DTEXT_ID;
	}

	if(IsValidDynamic3DTextLabel(Oyuncu[userid][YardimEdiyor]))
	{
		DestroyDynamic3DTextLabel(Oyuncu[userid][YardimEdiyor]);
		Oyuncu[userid][YardimEdiyor] = Text3D: INVALID_3DTEXT_ID;
	}
	return 1;
}

CMD:ban(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] <= 1)
		return 1;

	new hedefid, sebep[65], gun, ipadresi[16], sorgu[325], banmesaj[190], banstr[390];
    if(sscanf(params, "uds[65]", hedefid, gun, sebep))
 	{
		YollaKullanMesaj(playerid, "/ban [hedef adý/ID] [gün] [sebep]");
		YollaIpucuMesaj(playerid, "Hedefi süresiz yasaklamak istiyorsanýz gün kýsmýna 0 yazýn.");
		return 1;
	}
	if(strlen(sebep) < 3 || strlen(sebep) > 24)
		return YollaHataMesaj(playerid, "Oyuncuyu yasaklama sebebiniz 3 ve 24 karakter arasýnda olmalýdýr.");
	if(gun < 0 || gun > 365)
		return YollaHataMesaj(playerid, "Oyuncuyu yasaklamak için belirtilen gün 0 ve 365 gün arasýnda olmalýdýr.");
	if(!IsPlayerConnected(hedefid))
		return OyundaDegilMesaj(playerid);

	if(Oyuncu[hedefid][Yonetici] >= 1)
	{
	    if(Oyuncu[playerid][Yonetici] <= 3)	return YollaHataMesaj(playerid, "Bu kiþi yönetici yasaklayamazsýn.");
	}
	GetPlayerIp(hedefid, ipadresi, 16);
	if(gun == 0)
	{
		mysql_format(CopSQL, sorgu, sizeof(sorgu), "INSERT INTO `yasaklar` (`yasakID`, `yasaklanan`, `yasaklayan`, `sebep`, `yasakip`, `bitis`, `islemtarih`, `bitistarih`) VALUES ('%d', '%s', '%s', '%s', '%s', '0', NOW(), 'Yok')", bosYasakID(), Oyuncuadi(hedefid), Oyuncuadi(playerid), sebep, ipadresi);
		mysql_tquery(CopSQL, sorgu);
		format(banmesaj, sizeof(banmesaj), "\n"#SUNUCU_RENK2"Süresiz yasaklandýn, yanlýþ olduðunu düþünüyorsanýz '"#BEYAZ2"discord"#SUNUCU_RENK2"' adresinden yöneticilere bildirin.");
		strcat(banstr, banmesaj);
		format(banmesaj, sizeof(banmesaj), "\n\n"#SUNUCU_RENK2"Yasaklayan: "#BEYAZ2"%s\n"#SUNUCU_RENK2"Sebep: "#BEYAZ2"%s\n"#SUNUCU_RENK2"Tarih: "#BEYAZ2"%s", Oyuncuadi(playerid), sebep, Tarih(gettime()));
		strcat(banstr, banmesaj);
		ShowPlayerDialog(hedefid, DIALOG_X, DIALOG_STYLE_MSGBOX, ""#BEYAZ2"S-PP", banstr, ""#BEYAZ2"Kapat", "");
		YollaHerkeseMesaj(RENK_YARALI, "AdmCmd: %s, %s adlý oyuncuyu sunucudan süresiz yasakladý. (Sebep: %s)", Oyuncuadi(playerid), Oyuncuadi(hedefid), sebep);
		Kickle(hedefid);
	}
	else
	{
		new bitistarih = gettime() + (gun * 86400);
		mysql_format(CopSQL, sorgu, sizeof(sorgu), "INSERT INTO `yasaklar` (`yasakID`, `yasaklanan`, `yasaklayan`, `sebep`, `yasakip`, `bitis`, `islemtarih`, `bitistarih`) VALUES ('%d', '%s', '%s', '%s', '%s', '%d', '%d', NOW())", bosYasakID(), Oyuncuadi(hedefid), Oyuncuadi(playerid), sebep, ipadresi, bitistarih, gettime());
		mysql_tquery(CopSQL, sorgu);
		format(banmesaj, sizeof(banmesaj), "\n"#SUNUCU_RENK2"Yasaklandýn, yanlýþ olduðunu düþünüyorsanýz '"#BEYAZ2"www.spp.com"#SUNUCU_RENK2"' adresinden yöneticilere bildirin.");
		strcat(banstr, banmesaj);
		format(banmesaj, sizeof(banmesaj), "\n\n"#SUNUCU_RENK2"Yasaklayan: "#BEYAZ2"%s\n"#SUNUCU_RENK2"Sebep: "#BEYAZ2"%s\n"#SUNUCU_RENK2"Tarih: "#BEYAZ2"%s\n"#SUNUCU_RENK2"Bitiþ Tarihi: "#BEYAZ2"%s", Oyuncuadi(playerid), sebep, Tarih(gettime()), Tarih(bitistarih));
		strcat(banstr, banmesaj);
		ShowPlayerDialog(hedefid, DIALOG_X, DIALOG_STYLE_MSGBOX, ""#BEYAZ2"S-PP", banstr, ""#BEYAZ2"Kapat", "");
	    YollaHerkeseMesaj(RENK_YARALI, "AdmCmd: %s, %s adlý oyuncuyu %d gün sunucudan yasakladý. (Sebep: %s)", Oyuncuadi(playerid), Oyuncuadi(hedefid), gun, sebep);
	    Kickle(hedefid);

	}
	return 1;
}

CMD:offban(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] <= 2)
		return 1;

	new sebep[65], gun, sorgu[325], isim[24], Cache: sorguj;
    if(sscanf(params, "s[24]ds[65]", isim, gun, sebep))
 	{
		YollaKullanMesaj(playerid, "/offban [isim] [gün] [sebep]");
		YollaIpucuMesaj(playerid, "Hedefi süresiz yasaklamak istiyorsanýz gün kýsmýna 0 yazýn.");
		return 1;
	}
	if(strlen(sebep) < 3 || strlen(sebep) > 24)
		return YollaIpucuMesaj(playerid, "Oyuncuyu yasaklama sebebiniz 3 ve 24 karakter arasýnda olmalýdýr.");
	if(gun < 0 || gun > 365)
		return YollaIpucuMesaj(playerid, "Oyuncuyu yasaklamak için belirtilen gün 0 ve 365 gün arasýnda olmalýdýr.");
	if(strlen(isim) < 5 || strlen(isim) > 24)
		return YollaIpucuMesaj(playerid, "Oyuncu ismi 5 ve 24 karakter arasýnda olmalýdýr.");
	if(IsPlayerConnected(ReturnUser(isim)))
		return YollaIpucuMesaj(playerid, "Oyuncu oyunda, /ban komutunu kullanýn.");

	mysql_format(CopSQL, sorgu, sizeof(sorgu), "SELECT * FROM yasaklar WHERE yasaklanan = '%s'", isim);
	sorguj = mysql_query(CopSQL, sorgu);
	new veriler = cache_num_rows(), ipadresi[30];
	if(veriler)
		return YollaHataMesaj(playerid, "%s adlý oyuncu zaten yasaklý.", isim);
    cache_get_value(0, "ipadresi", ipadresi, 30);
	if(gun == 0)
	{
		mysql_format(CopSQL, sorgu, sizeof(sorgu), "INSERT INTO `yasaklar` (`yasakID`, `yasaklanan`, `yasaklayan`, `sebep`, `yasakip`, `bitis`, `islemtarih`, `bitistarih`) VALUES ('%d', '%s', '%s', '%s', '%s', '0', NOW(), 'Yok')", bosYasakID(), isim, Oyuncuadi(playerid), sebep, ipadresi);
		mysql_tquery(CopSQL, sorgu);
		YollaIpucuMesaj(playerid, "%s adlý oyuncu yasaklandý.", isim);
	}
	else
	{
		new bitistarih = gettime() + (gun * 86400);
		mysql_format(CopSQL, sorgu, sizeof(sorgu), "INSERT INTO `yasaklar` (`yasakID`, `yasaklanan`, `yasaklayan`, `sebep`, `yasakip`, `bitis`, `islemtarih`, `bitistarih`) VALUES ('%d', '%s', '%s', '%s', '%s', '%d', '%d', NOW())", bosYasakID(), isim, Oyuncuadi(playerid), sebep, ipadresi, bitistarih, gettime());
		mysql_tquery(CopSQL, sorgu);
		YollaIpucuMesaj(playerid, "%s adlý oyuncu %d gün yasaklandý.", isim, gun);
	}
	cache_delete(sorguj);
	return 1;
}

CMD:unban(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] <= 2)
		return 1;

	new isim[35], sorgu[125], Cache: sorguj;
    if(sscanf(params, "s[35]", isim))
		return YollaKullanMesaj(playerid, "/unban [isim]");
	if(strlen(isim) < 4 || strlen(isim) > 24)
		return YollaHataMesaj(playerid, "Oyuncu ismi 4 ve 24 karakter arasýnda olmalýdýr.");

	mysql_format(CopSQL, sorgu, sizeof(sorgu), "SELECT * FROM yasaklar WHERE yasaklanan = '%s'", isim);
	sorguj = mysql_query(CopSQL, sorgu);
	new veriler = cache_num_rows();
	if(veriler)
	{
		YollaIpucuMesaj(playerid, "%s adlý oyuncu yasaklamasýný kaldýrdýn.", isim);
		mysql_format(CopSQL, sorgu, sizeof(sorgu), "DELETE FROM yasaklar WHERE yasaklanan = '%s'", isim);
		mysql_tquery(CopSQL, sorgu);
	}
	else YollaHataMesaj(playerid, "%s adlý oyuncu yasaklý deðil.", isim);
	cache_delete(sorguj);
	return 1;
}

CMD:makeadmin(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 5)
		return 1;
	new hedefid, yetki;
    if(sscanf(params, "ui", hedefid, yetki))
    	return YollaKullanMesaj(playerid, "/makeadmin [hedef adý/ID] [seviye]");

    if(!IsPlayerConnected(hedefid))
		return OyundaDegilMesaj(playerid);

	if(yetki < 0 || yetki > 4)
		return YollaHataMesaj(playerid, "Yönetici yetkileri 0 ve 4 arasýnda olmalýdýr.");

	if(yetki == 0)
	{
	    if(Oyuncu[hedefid][Yonetici] == 0)
	        return YollaHataMesaj(playerid, "Hedef yönetici deðil.");

		YollaYoneticiMesaj(1, RENK_YARALI, "AdmCmd: %s, %s kiþisini yöneticilikten çýkardý.", Oyuncuadi(playerid), Oyuncuadi(hedefid));
	}
	new string[135];
	format(string, sizeof(string), "%s, %s kiþisini %d seviyesinde yönetici yaptý.", Oyuncuadi(playerid), Oyuncuadi(hedefid), yetki);
	Oyuncu[hedefid][Yonetici] = yetki;
	YollaYoneticiMesaj(1, RENK_YARALI, "AdmCmd: %s, %s kiþisini %d seviyesinde yönetici yaptý.", Oyuncuadi(playerid), Oyuncuadi(hedefid), yetki);
	return 1;
}

CMD:makeadmin2(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 7 || (IsPlayerAdmin(playerid)) )
		return YollaHataMesaj(playerid, "Rcon login yapýlmadan bu parametre kullanýlamaz.");

	new hedefid, yetki;
    if(sscanf(params, "ui", hedefid, yetki))
    	return YollaKullanMesaj(playerid, "/makeadmin2 [hedef adý/ID] [seviye]");

    if(!IsPlayerConnected(hedefid))
		return OyundaDegilMesaj(playerid);

	if(yetki < 0 || yetki > 7)
		return YollaHataMesaj(playerid, "Yönetici yetkileri 0 ve 7 arasýnda olmalýdýr.");

	if(yetki == 0)
	{
	    if(Oyuncu[hedefid][Yonetici] == 0)
	        return YollaHataMesaj(playerid, "Hedef yönetici deðil.");

		YollaYoneticiMesaj(1, RENK_YARALI, "AdmCmd: %s, %s kiþisini yöneticilikten çýkardý.", Oyuncuadi(playerid), Oyuncuadi(hedefid));
	}
	new string[135];
	format(string, sizeof(string), "%s, %s kiþisini %d seviyesinde yönetici yaptý.", Oyuncuadi(playerid), Oyuncuadi(hedefid), yetki);
	Oyuncu[hedefid][Yonetici] = yetki;
	YollaYoneticiMesaj(1, RENK_YARALI, "AdmCmd: %s, %s kiþisini %d seviyesinde yönetici yaptý.", Oyuncuadi(playerid), Oyuncuadi(hedefid), yetki);
	//YollaIpucuMesaj(playerid, ""#YARALI"AdmCmd: Hesaba 7(yedi) seviye yöneticilik vermek veritabaný iþlemi gerektirmektedir.");
	return 1;
}

CMD:makesupporter(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 3)
		return 1;
	new hedefid;
    if(sscanf(params, "u", hedefid))
    	return YollaKullanMesaj(playerid, "/makesupporter [hedef adý/ID]");
    if(!IsPlayerConnected(hedefid))
		return OyundaDegilMesaj(playerid);
	if(Oyuncu[hedefid][Yonetici] >= 1)
		return YollaHataMesaj(playerid, "Yönetici olan birisini supporter yapamazsýn.");

    if(Oyuncu[hedefid][Helper] == true)
    {
    	Oyuncu[hedefid][Helper] = false;
        return YollaYoneticiMesaj(1, RENK_YARALI, "AdmCmd. %s, %s kiþisinin supporter yetkisini aldý.", Oyuncuadi(playerid), Oyuncuadi(hedefid));
    }
	Oyuncu[hedefid][Helper] = true;
	YollaYoneticiMesaj(1, RENK_YARALI, "AdmCmd: %s, %s kiþisini supporter yaptý.", Oyuncuadi(playerid), Oyuncuadi(hedefid));
	return 1;
}

CMD:setvw(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] <= 1)
		return 1;

	new hedefid, miktar;
    if(sscanf(params, "ud", hedefid, miktar))
    	return YollaKullanMesaj(playerid, "/setvw [hedef adý/ID] [miktar]");
    if(!IsPlayerConnected(hedefid))
		return OyundaDegilMesaj(playerid);

	SetPlayerVirtualWorld(hedefid, miktar);
	YollaIpucuMesaj(hedefid, "%s VW'ni %d yaptý.", Oyuncuadi(playerid), miktar);
	YollaIpucuMesaj(playerid, "%s kiþisinin VW'sini %d yaptýn.", Oyuncuadi(hedefid), miktar);
	return 1;
}

CMD:setint(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] <= 1)
		return 1;

	new hedefid, miktar;
    if(sscanf(params, "ud", hedefid, miktar))
    	return YollaKullanMesaj(playerid, "/setint [hedef adý/ID] [miktar]");
    if(!IsPlayerConnected(hedefid))
		return OyundaDegilMesaj(playerid);

	SetPlayerInterior(hedefid, miktar);
	YollaIpucuMesaj(hedefid, "%s interiorunu %d yaptý.", Oyuncuadi(playerid), miktar);
	YollaIpucuMesaj(playerid, "%s kiþisinin interiorunu %d yaptýn.", Oyuncuadi(hedefid), miktar);
	return 1;
}

CMD:gotopos(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 3)
		return 1;
	new Float: pos[3], int;
	if(sscanf(params, "fffd", pos[0], pos[1], pos[2], int))
		return YollaKullanMesaj(playerid, "/gotopos [X] [Y] [Z] [Interior]");

	YollaIpucuMesaj(playerid, "Girilen koordinatlara teleport oldun. (Interior: %d)", int);
	SetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	SetPlayerInterior(playerid, int);
	return 1;
}

CMD:gotopos2(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 3)
		return 1;
	new Float: pos[3];
	if(sscanf(params, "fffd", pos[0], pos[1], pos[2]))
		return YollaKullanMesaj(playerid, "/gotopos [X] [Y] [Z]");

	YollaIpucuMesaj(playerid, "Girilen koordinatlara teleport oldun.");
	SetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	return 1;
}

CMD:kick(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 1)
		return 1;

	new hedefid, sebep[30], kickmesaj[155], kickstr[255];
    if(sscanf(params, "us[30]", hedefid, sebep))
    	return YollaKullanMesaj(playerid, "/kick [hedef adý/ID] [sebep]");
    if(!IsPlayerConnected(hedefid))
		return OyundaDegilMesaj(playerid);
	if(strlen(sebep) < 3 || strlen(sebep) > 24)
		return YollaHataMesaj(playerid, "Kick sebebi 3 ve en fazla 24 harfden oluþmalýdýr.");

	format(kickmesaj, sizeof(kickmesaj), "\n"#SUNUCU_RENK2"Atýldýnýz, yanlýþ olduðunu düþünüyorsanýz '"#BEYAZ2"discord.gg/guutUUKm3F"#SUNUCU_RENK2"' adresinden yöneticilere bildirin.");
	strcat(kickstr, kickmesaj);
	format(kickmesaj, sizeof(kickmesaj), "\n\n"#SUNUCU_RENK2"Atan yetkili: "#BEYAZ2"%s\n"#SUNUCU_RENK2"Sebep: "#BEYAZ2"%s\n"#SUNUCU_RENK2"Tarih: "#BEYAZ2"%s", Oyuncuadi(playerid), sebep, Tarih(gettime()));
	strcat(kickstr, kickmesaj);
	ShowPlayerDialog(hedefid, DIALOG_X, DIALOG_STYLE_MSGBOX, ""#BEYAZ2"S-PP", kickstr, ""#BEYAZ2"Kapat", "");

	YollaHerkeseMesaj(RENK_YARALI, "AdmCmd: %s adlý oyuncu sunucudan kicklendi. [Sebep: %s]", Oyuncuadi(hedefid), sebep); // Oyuncuadi(playerid),
	Kickle(hedefid);
	return 1;
}

CMD:admins(playerid, params[])
{
    new aktifyonetici = 0;
	//SendClientMessage(playerid, COLOR_GREEN, "Online Yöneticiler:");
	foreach(new i : Player) if(IsPlayerConnected(i) && Oyuncu[i][GirisYapti])
    {
    if(Oyuncu[i][Yonetici] >= 1)
		{
        YollaFormatMesaj(playerid, (Oyuncu[i][aduty]) ? COLOR_LIGHTRED : COLOR_GREY, "(%s) %s [ID: %d - Level: %d]", YoneticiYetkiAdi(Oyuncu[i][Yonetici]), Oyuncuadi(i),  i, Oyuncu[i][Yonetici]);
        aktifyonetici++;
        }
    }
    if(aktifyonetici == 0)
	return YollaHataMesaj(playerid, "Çevrimiçi yönetici yok.");
    return 1;
}

CMD:supporters(playerid, params[])
{
	new aktifsupporter = 0;
	//SendClientMessage(playerid, COLOR_GREEN, "Online Supporterlar:");
	foreach(new i : Player) if(IsPlayerConnected(i) && Oyuncu[i][GirisYapti])
	{
		if(Oyuncu[i][Helper] == true)
		{
			YollaFormatMesaj(playerid, COLOR_SUPPORTER, "(Supporter) %s [ID: %d]", Oyuncuadi(i), playerid);
			aktifsupporter++;
        }
	}
	if(aktifsupporter == 0)
		return YollaHataMesaj(playerid, "Çevrimiçi supporter yok.");
	return 1;
}

CMD:afk(playerid, params[])
{
	if(Oyuncu[playerid][HapisDakika] >= 1)
		return YollaHataMesaj(playerid, "Hapisteyken bu komutu kullanamazsýn.");
	if(Oyuncu[playerid][Oyunda] == true)
		return YollaHataMesaj(playerid, "Aktif bir oyunda bu komutu kullanamazsýn.");

	if(Oyuncu[playerid][AFK] == false)
	{
		YollaFormatMesaj(playerid, RENK_YARALI, "[S-PP]"#BEYAZ2" %s, þuan AFK.", Oyuncuadi(playerid));
		Oyuncu[playerid][AFK] = true;
		return 1;
	}
	if(Oyuncu[playerid][AFK] == true)
	{
		YollaFormatMesaj(playerid, RENK_YARALI, "[S-PP]"#BEYAZ2" %s, AFK'dan ayrýldýn.", Oyuncuadi(playerid));
		Oyuncu[playerid][AFK] = false;
		Baslat();
		return 1;
	}
	return 1;
}

CMD:goto(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] <= 1)
		return 1;
	new hedefid, Float: hedefPos[3];
    if(sscanf(params, "u", hedefid))
    	return YollaKullanMesaj(playerid, "/goto [hedef adý/ID]");
    if(!IsPlayerConnected(hedefid))
		return OyundaDegilMesaj(playerid);

	GetPlayerPos(hedefid, hedefPos[0], hedefPos[1], hedefPos[2]);
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(hedefid));
	SetPlayerInterior(playerid, GetPlayerInterior(hedefid));
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		new arac = GetPlayerVehicleID(playerid);
		SetVehiclePos(arac, hedefPos[0], hedefPos[1]+3, hedefPos[2]);
	}
	else
	{
		SetPlayerPos(playerid, hedefPos[0], hedefPos[1]+2, hedefPos[2]);
	}
	YollaIpucuMesaj(hedefid, "%s adlý yönetici yanýna ýþýnlandý.", Oyuncuadi(playerid));
	YollaIpucuMesaj(playerid, "%s adlý oyuncunun yanýna ýþýnlandýn.", Oyuncuadi(hedefid));
	return 1;
}

CMD:gethere(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] <= 1)
		return 1;

	new hedefid, Float: hedefPos[3];
	if(sscanf(params, "u", hedefid))
		return YollaKullanMesaj(playerid, "/gethere [hedef adý/ID]");
	if(!IsPlayerConnected(hedefid))
		return OyundaDegilMesaj(playerid);

	GetPlayerPos(playerid, hedefPos[0], hedefPos[1], hedefPos[2]);
	SetPlayerInterior(hedefid, GetPlayerInterior(playerid));
	SetPlayerVirtualWorld(hedefid, GetPlayerVirtualWorld(playerid));
	if(GetPlayerState(hedefid) == PLAYER_STATE_DRIVER)
	{
		new arac = GetPlayerVehicleID(hedefid);
		SetVehiclePos(arac, hedefPos[0], hedefPos[1]+3, hedefPos[2]);
	}
	else
	{
		SetPlayerPos(hedefid, hedefPos[0], hedefPos[1]+2, hedefPos[2]);
	}
	YollaIpucuMesaj(hedefid, "%s adlý yönetici seni yanýna çekti.", Oyuncuadi(playerid));
	YollaIpucuMesaj(playerid, "%s adlý oyuncuyu yanýna çektin.", Oyuncuadi(hedefid));
	return 1;
}

CMD:sethp(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] <= 1)
		return 1;

	new hedefid, miktar;
    if(sscanf(params, "ui", hedefid, miktar))
    	return YollaKullanMesaj(playerid, "/sethp [hedef adý/ID] [miktar]");
    if(!IsPlayerConnected(hedefid))
		return OyundaDegilMesaj(playerid);

	SetPlayerHealth(hedefid, miktar);
	YollaIpucuMesaj(hedefid, "%s adlý yönetici canýný %d yaptý.", Oyuncuadi(playerid), miktar);
	YollaIpucuMesaj(playerid, "%s adlý oyuncunun canýný %d yaptýn.", Oyuncuadi(hedefid), miktar);
	return 1;
}

CMD:givegun(playerid, params[])
{
    if(Oyuncu[playerid][Yonetici] <= 3)
		return 1;

    new id, weaponid, ammo;

    if(sscanf(params, "udD(500)", id, weaponid, ammo))
	{
        YollaKullanMesaj(playerid, ""#YARALI"/givegun [id/isim] [silahid] [mermi]");
        YollaKullanMesaj(playerid, ""#YARALI"[KULLANILABÝLÝR SÝLAHLAR]");
        YollaKullanMesaj(playerid, ""#GRI2"Muþta(1), Golf Sopasý(2), Jop(3), Býçak(4), Beyzbol Sopasý(5), Kürek(6), Bilardo Sopasý(7), Katana(8), Testere(9)");
        YollaKullanMesaj(playerid, ""#GRI2"Çiçek(14), Baston(15), Smoke(17), Moltov(18), Colt-45(22), SD Pistol(23), Desert Eagle(24)");
        YollaKullanMesaj(playerid, ""#GRI2"Shotgun(25), UZI(28), MP5(29), AK-47(30), M4(31), TEC-9(32), Rifle(33), Sniper(34)");
        YollaKullanMesaj(playerid, ""#GRI2"Spray(41), Yangýn Tüpü(42), Camera(43), Paraþüt(46)");
        return 1;
    }

    if(!IsPlayerConnected(id) || !Oyuncu[id][GirisYapti])return
        YollaHataMesaj(playerid, "Geçersiz ID.");

    if(Oyuncu[id][HapisDakika])return
        YollaHataMesaj(playerid, "Hapiste olan birisine silah veremezsin.");

    GivePlayerWeapon(id, weaponid, ammo);

    YollaIpucuMesaj(id, ""#GRI2"%s sana %s(%d mermi) verdi.", Oyuncuadi(playerid), SilahAdi(weaponid), ammo);
    AdminMessage(RENK_YARALI, "AdmCmd: %s adlý yönetici %s (%d) silahýný %s kiþisine verdi.", Oyuncuadi(playerid), SilahAdi(weaponid), ammo, Oyuncuadi(id));
    return 1;
}

CMD:spawn(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] >= 1 || Oyuncu[playerid][Helper] == true)
	{
	new hedefid;
    if(sscanf(params, "u", hedefid))
    	return YollaKullanMesaj(playerid, "/spawn [hedef adý/ID]");
    if(!IsPlayerConnected(hedefid))
		return OyundaDegilMesaj(playerid);

	SetPlayerPos(hedefid, Oyuncu[hedefid][Pos][0], Oyuncu[hedefid][Pos][1], Oyuncu[hedefid][Pos][2]);
	SetPlayerFacingAngle(hedefid, Oyuncu[hedefid][Pos][3]);
	SetPlayerVirtualWorld(hedefid, 0);
	SetPlayerInterior(hedefid, LOBI_INTERIOR);
	SetCameraBehindPlayer(hedefid);
	YollaIpucuMesaj(hedefid, "%s adlý yönetici tarafýndan lobiye spawn oldun.", Oyuncuadi(playerid));
	YollaIpucuMesaj(playerid, "%s adlý oyuncuyu lobiye spawnladýn.", Oyuncuadi(hedefid));
	}
	return 1;
}

CMD:setarmor(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] <= 2)
		return 1;

	new hedefid, miktar;
    if(sscanf(params, "ui", hedefid, miktar))
    	return YollaKullanMesaj(playerid, "/setarmor [hedef adý/ID] [miktar]");
    if(!IsPlayerConnected(hedefid))
		return OyundaDegilMesaj(playerid);

	SetPlayerArmour(hedefid, miktar);
	YollaIpucuMesaj(hedefid, "%s adlý yönetici zýrhýný %d yaptý.", Oyuncuadi(playerid), miktar);
	YollaIpucuMesaj(playerid, "%s adlý oyuncunun zýrhýný %d yaptýn.", Oyuncuadi(hedefid), miktar);
	return 1;
}

CMD:tackle(playerid)
{
	if(IsPlayerInAnyVehicle(playerid)) return YollaHataMesaj(playerid, "Araçtayken bu komutu kullanamazsýn.");

	if(Oyuncu[playerid][Tackle] == 0)
	{
		Oyuncu[playerid][Tackle] = 1;
		YollaIpucuMesaj(playerid, "Çelme modu aktif edildi, hedefinize yumruk atmanýz takdirinde eylem tamamlanacak.");
	}
	else
	{
		Oyuncu[playerid][Tackle] = 0;
		YollaIpucuMesaj(playerid, "Çelme modu de-aktif edildi, normal duruma geçtiniz.");
	}

	return true;
}

CMD:slap(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 1)
		return 1;

	new hedefid, Float: hedefPos[3];
    if(sscanf(params, "u", hedefid))
    	return YollaKullanMesaj(playerid, "/slap [hedef adý/ID]");
	if(!IsPlayerConnected(hedefid))
		return OyundaDegilMesaj(playerid);

	GetPlayerPos(hedefid, hedefPos[0], hedefPos[1], hedefPos[2]);
	SetPlayerPos(hedefid, hedefPos[0], hedefPos[1], hedefPos[2]+5);
	YollaIpucuMesaj(hedefid, "%s adlý yönetici seni tokatladý.", Oyuncuadi(playerid));
	YollaIpucuMesaj(playerid, "%s adlý oyuncuyu tokatladýn.", Oyuncuadi(hedefid));
	return 1;
}

CMD:freeze(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] <= 1)
		return 1;
	new hedefid;
	if(sscanf(params, "u", hedefid))
	    return YollaKullanMesaj(playerid, "/freeze [hedef adý/ID]");
	if(!IsPlayerConnected(hedefid))
		return OyundaDegilMesaj(playerid);

	if(Oyuncu[hedefid][FreezeDurumu] == false)
	{
		TogglePlayerControllable(hedefid, 0);
		Oyuncu[hedefid][FreezeDurumu] = true;
		YollaIpucuMesaj(hedefid, "%s adlý yönetici seni freezeledi.", Oyuncuadi(playerid));
		YollaIpucuMesaj(playerid, "%s adlý oyuncuyu freezeledin.", Oyuncuadi(hedefid));
		return 1;
	}
	TogglePlayerControllable(hedefid, 1);
	Oyuncu[hedefid][FreezeDurumu] = false;
	YollaIpucuMesaj(hedefid, "%s adlý yönetici senin freeze'ini kaldýrdý.", Oyuncuadi(playerid));
	YollaIpucuMesaj(playerid, "%s adlý oyuncunun freeze'ini kaldýrdýn.", Oyuncuadi(hedefid));
	return 1;
}

CMD:freezeall(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] <= 2)
		return 1;

	if(HerkesFreeze == false)
	{
		foreach(new i : Player)
		{
			if(Oyuncu[i][GirisYapti] == true && Oyuncu[i][Oyunda] == true)
			{
				TogglePlayerControllable(i, 0);
			}
		}
		HerkesFreeze = true;
		new mesaj[150];
		format(mesaj, sizeof(mesaj), "AdmCmd: %s adlý yönetici herkesi dondurdu.", Oyuncuadi(playerid));
		ProxDetectorOyun(mesaj, RENK_YARALI);
		return 1;
	}
	foreach(new i : Player)
	{
		if(Oyuncu[i][GirisYapti] == true && Oyuncu[i][Oyunda] == true)
		{
			TogglePlayerControllable(i, 1);
		}
	}
	HerkesFreeze = false;
	new mesaj[150];
	format(mesaj, sizeof(mesaj), "AdmCmd: %s adlý yönetici herkesin donmasýný kaldýrdý.", Oyuncuadi(playerid));
	ProxDetectorOyun(mesaj, RENK_YARALI);
	return 1;
}

CMD:getcar(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 3)
		return 1;
	new aracid, Float:ax, Float:ay, Float:az;
	if(sscanf(params, "d", aracid))
		return YollaKullanMesaj(playerid, "/getcar [araç ID]");

	GetPlayerPos(playerid, ax, ay, az);
	SetVehiclePos(aracid, ax+3, ay+1, az+1);

	SetVehicleVirtualWorld(aracid, GetPlayerVirtualWorld(playerid));
	LinkVehicleToInterior(aracid, GetPlayerInterior(playerid));
	YollaIpucuMesaj(playerid, "%d ID'li aracý yanýna çektin.", aracid);
	return 1;
}

CMD:gotocar(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 3)
		return 1;
	new aracid, Float:ax, Float:ay, Float:az;
	if(sscanf(params, "d", aracid))
		return YollaKullanMesaj(playerid, "/gotocar [araç ID]");
	if(!IsValidVehicle(aracid))
		return YollaHataMesaj(playerid, "Araç ID geçersiz.");

	GetVehiclePos(aracid, ax, ay, az);
	if(GetPlayerState(playerid) != 2)
	{
		SetPlayerPos(playerid, ax, ay, az);
	}
	new aracix = GetPlayerVehicleID(playerid);
	SetVehiclePos(aracix, ax+3, ay+1, az+1);
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid, 0);
	YollaIpucuMesaj(playerid, "%d ID'li aracýn yanýna ýþýnlandýn.", aracid);
	return 1;
}

CMD:setskin(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 3)
		return 1;

	new hedefid, secim[20], kiyafet;

	if(sscanf(params, "us[20]d", hedefid, secim, kiyafet))
		return YollaKullanMesaj(playerid, "/setskin [hedef adý/ID] [cop/suspect/normal] [skin ID]");

  	if(!IsPlayerConnected(hedefid))
		return OyundaDegilMesaj(playerid);

	if(!strcmp(secim, "cop"))
	{
		Oyuncu[hedefid][pKiyafet] = kiyafet;
		YollaIpucuMesaj(hedefid, "%s adlý yönetici cop kýyafetini %d yaptý.", Oyuncuadi(playerid), kiyafet);
		YollaIpucuMesaj(playerid, "%s adlý oyuncunun cop kýyafetini %d yaptýn.", Oyuncuadi(hedefid), kiyafet);
	}
	else if(!strcmp(secim, "suspect"))
	{
		Oyuncu[hedefid][Kiyafet] = kiyafet;
		YollaIpucuMesaj(hedefid, "%s adlý yönetici suspect kýyafetini %d yaptý.", Oyuncuadi(playerid), kiyafet);
		YollaIpucuMesaj(playerid, "%s adlý oyuncunun suspect kýyafetini %d yaptýn.", Oyuncuadi(hedefid), kiyafet);
	}
	else if(!strcmp(secim, "normal"))
	{
	    Oyuncu[hedefid][Kiyafet] = kiyafet;
		YollaIpucuMesaj(hedefid, "%s adlý yönetici kýyafetini %d yaptý.", Oyuncuadi(playerid), kiyafet);
		YollaIpucuMesaj(playerid, "%s adlý oyuncunun kýyafetini %d yaptýn.", Oyuncuadi(hedefid), kiyafet);
	}
	else
	{
		YollaKullanMesaj(playerid, "/setskin [hedef adý/ID] [cop / suspect / normal] [skin ID]");
		return 1;
	}
	SetPlayerSkin(hedefid, kiyafet);
	return 1;
}

CMD:dskin(playerid, params[])
{
	if(Oyuncu[playerid][Donator] == false)
		return YollaHataMesaj(playerid, "Donator deðilisiniz.");
	if(Oyuncu[playerid][Oyunda] == true)
		return YollaHataMesaj(playerid, "Lobide deðilsin.");

	new secim[20], kiyafet;
	if(sscanf(params, "s[20]d", secim, kiyafet))
		return YollaKullanMesaj(playerid, "/dskin [cop/suspect] [skin ID]");

	if(!strcmp(secim, "cop"))
	{
		Oyuncu[playerid][pKiyafet] = kiyafet;
		YollaIpucuMesaj(playerid, "Cop kýyafetini deðiþtirdin.");
	}
	else if(!strcmp(secim, "suspect"))
	{
		Oyuncu[playerid][Kiyafet] = kiyafet;
		YollaIpucuMesaj(playerid, "Suspect kýyafetini deðiþtirdin.");
	}
	else
	{
		YollaKullanMesaj(playerid, "/dskin [cop/suspect] [skin ID]");
		return 1;
	}
	SetPlayerSkin(playerid, kiyafet);
	return 1;
}

CMD:setweather(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 3)
		return 1;
	new havaid;
	if(sscanf(params, "d", havaid))
		return YollaKullanMesaj(playerid, "/setweather [havadurumu ID]");

	SetWeather(havaid);
	YollaHerkeseMesaj(RENK_YARALI, "AdmCmd: Hava durumu yöneticiler tarafýndan deðiþtirildi.");
	return 1;
}

CMD:settime(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 2)
		return 1;
	new saat;
	if(sscanf(params, "d", saat))
		return YollaKullanMesaj(playerid, "/settime [saat]");

	SetWorldTime(saat);
	YollaHerkeseMesaj(RENK_YARALI, "AdmCmd: Oyun saati %d olarak yönetici tarafýndan güncellendi.", saat);
	return 1;
}

CMD:restart(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 1)
		return 1;
	if(OyunBasladi == false)
		return YollaHataMesaj(playerid, "Oyun zaten baþlamamýþ.");
	foreach(new i : Player)
	{
		if(Oyuncu[i][GirisYapti] == true && Oyuncu[i][Oyunda] == true)
		{
			LobiyeDon(i);
			Oyuncu[i][Oyunda] = Oyuncu[i][Suspect] = Oyuncu[i][Polis] = false;
			ResetPlayerWeapons(i);
		}
	}
	for(new i = 1; i < MAX_ENGEL; ++i)
	{
		if(Engel[i][Olusturuldu] == true)
		{
			DestroyDynamicObject(Engel[i][ID]);
			DestroyDynamic3DTextLabel(Engel[i][Engel3D]);
			if(IsValidDynamicArea(Engel[i][AreaID]))
				DestroyDynamicArea(Engel[i][AreaID]);
			Engel[i][Engel3D] = Text3D: INVALID_3DTEXT_ID;
			Engel[i][Pos][0] = Engel[i][Pos][1] = Engel[i][Pos][2] = 0.0;
			Engel[i][Duzenleniyor] = Engel[i][Olusturuldu] = false;
			Engel[i][SahipID] = -1;
		}
	}
	for(new j = 1, i = GetVehiclePoolSize(); j <= i; j++)
	{
		Flasor[j] = 0;
		KillTimer(FlasorTimer[j]);
		DestroyVehicle(j);
	}
	OyunSaniye = OYUN_SANIYE;
	OyunBasladi = OyunSayac = false;
	OyunDakika = OYUN_DAKIKA;
	OyunDakikaSaniye = OYUN_DAKIKASANIYE;
	KillTimer(SuspectSaklaTimer);
	KillTimer(OyunKalanTimer);
	Baslat();
	YollaHerkeseMesaj(RENK_YARALI, "AdmCmd: %s tarafýndan oyun yeniden baþlatýlýyor.", Oyuncuadi(playerid));
	return 1;
}

CMD:uyari(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] >= 1 || Oyuncu[playerid][Helper] == true)
	{
	new hedefid, sebep[100], mesaj[900];
	if(sscanf(params, "us[100]", hedefid, sebep))
		return YollaKullanMesaj(playerid, "/uyari [hedef adý/ID] [sebep]");
  	if(!IsPlayerConnected(hedefid))
		return OyundaDegilMesaj(playerid);

	format(mesaj, sizeof(mesaj), ""#BEYAZ2"%s adlý yetkili tarafýndan %s sebebiyle uyarýldýn, daha dikkatli ol!", Oyuncuadi(playerid), sebep);

	strcat(mesaj, "- Oyunda seni diðer oyunculardan üstün kýlan mod kullanamazsýn.\n");
	strcat(mesaj, "- /ooc chatte hakaret etmemelisin.\n");
	strcat(mesaj, "- Roleplay modunda roleplay kurallarýna uygun davranmalýsýn.\n");
	strcat(mesaj, "- Polis memurlarý, þüpheliler ateþ açmaya baþlayana kadar ateþ açamaz buna tekerlekler dahil.\n");
	strcat(mesaj, "- Bulunduðun aracý roleplay kurallarý içinde sürmeye dikkat etmelisin.\n");
	strcat(mesaj, "- Aracýný sürerken polislere veya þüphelilere ramming yapmamalýsýn.\n");
	strcat(mesaj, "- Þüpheli sudayken kiþiyi kelepçeleyemez, taserleyemez ya da beanbag ile ateþ edemezsin.\n");
	strcat(mesaj, "- Þüpheliler ateþ açmadýðý sürece Drive-BY (araçtan sarkma) yapamazsýn.\n");
	strcat(mesaj, "- Objeleri amacý dýþýnda kullanmak yasaktýr.\n");
	strcat(mesaj, "- Polisler araçlarýný düzgün sürmek zorunda, LINE (tek çizgi) kuralýna dikkat edilmelidir.\n");
	strins(mesaj, ""#BEYAZ2"", 0);
	ShowPlayerDialog(hedefid, DIALOG_X, DIALOG_STYLE_MSGBOX, "S-PP - Kurallar", mesaj, "Kapat", "");
	ShowPlayerDialog(hedefid, DIALOG_X, DIALOG_STYLE_MSGBOX, "S-PP", mesaj, "Kapat", "");
	YollaYoneticiMesaj(1, RENK_YARALI, "AdmCmd: %s, %s kiþisini %s sebebiyle uyardý.", Oyuncuadi(playerid), Oyuncuadi(hedefid), sebep);
	}
	return 1;
}

CMD:muzik(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 3)
		return 1;
	new url[150];
	if(sscanf(params, "s[150]", url))
		return YollaKullanMesaj(playerid, "/muzik [url]");

	foreach(new i : Player)
	{
		if(Oyuncu[i][GirisYapti] == true)
		{
			PlayAudioStreamForPlayer(i, url);
		}
	}
	YollaHerkeseMesaj(RENK_YARALI, "AdmCmd: %s tarafýndan müzik deðiþtirildi. /muzikkapat ile kapatabilirsiniz.", Oyuncuadi(playerid));
	return 1;
}

CMD:muzikkapat(playerid, params[])
{
	StopAudioStreamForPlayer(playerid);
	YollaIpucuMesaj(playerid, "Müziði kapattýn, tekrar müzik açýlana kadar duymayacaksýn.");
	return 1;
}

CMD:amute(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 1)
		return 1;
	new hedefid, dakika, sebep[100];
	if(sscanf(params, "udS(-1)[100]", hedefid, dakika, sebep))
		return YollaKullanMesaj(playerid, "/amute [hedef adý/ID] [dakika] [sebep]");
  	if(!IsPlayerConnected(hedefid))
		return OyundaDegilMesaj(playerid);
	/*if(dakika >= 4)
		return YollaHataMesaj(playerid, "Oyuncuyu sadece 1-3 dakika arasý susturabilirsin.");*/

	if(dakika == 0)
	{
		Oyuncu[hedefid][SusturDakika] = dakika;
		KillTimer(Oyuncu[hedefid][SusturTimer]);
		AdminMessage(RENK_YARALI, "AdmCmd: %s, %s adlý oyuncuyu susturmasýný kaldýrdý.", Oyuncuadi(playerid), Oyuncuadi(hedefid));
		return 1;
	}
	if(strval(sebep) == -1)
		return YollaKullanMesaj(playerid, "/amute [hedef adý/ID] [dakika] [sebep]");
	Oyuncu[hedefid][SusturTimer] = SetTimerEx("OyuncuSustur", TIMER_DAKIKA(1), true, "d", hedefid);
	Oyuncu[hedefid][SusturDakika] = dakika;
	YollaHerkeseMesaj(RENK_YARALI, "AdmCmd: %s, %s adlý oyuncuyu %d dakika susturdu. Sebep: %s", Oyuncuadi(playerid), Oyuncuadi(hedefid), dakika, sebep);
	return 1;
}

CMD:smute(playerid, params[])
{
	if(Oyuncu[playerid][Helper] == false)
		return 1;
	new hedefid, dakika, sebep[100];
	if(sscanf(params, "udS(-1)[100]", hedefid, dakika, sebep))
		return YollaKullanMesaj(playerid, "/smute [hedef adý/ID] [dakika] [sebep]");
  	if(!IsPlayerConnected(hedefid))
		return OyundaDegilMesaj(playerid);
	if(dakika >= 120)
		return YollaHataMesaj(playerid, "Oyuncuyu sadece 120 dakika susturabilirsin.");

	if(dakika == 0)
	{
		Oyuncu[hedefid][SusturDakika] = dakika;
		KillTimer(Oyuncu[hedefid][SusturTimer]);
		AdminMessage(RENK_YARALI, "AdmCmd: %s, %s adlý oyuncuyu susturmasýný kaldýrdý.", Oyuncuadi(playerid), Oyuncuadi(hedefid));
		return 1;
	}
	if(strval(sebep) == -1)
		return YollaKullanMesaj(playerid, "/amute [hedef adý/ID] [dakika] [sebep]");
	Oyuncu[hedefid][SusturTimer] = SetTimerEx("OyuncuSustur", TIMER_DAKIKA(1), true, "d", hedefid);
	Oyuncu[hedefid][SusturDakika] = dakika;
	YollaHerkeseMesaj(RENK_YARALI, "AdmCmd: %s, %s adlý oyuncuyu %d dakika susturdu. Sebep: %s", Oyuncuadi(playerid), Oyuncuadi(hedefid), dakika, sebep);
	return 1;
}

CMD:aspec(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 1)
		return 1;
	new hedefid;
	if(sscanf(params, "u", hedefid))
		return YollaKullanMesaj(playerid, "/aspec [hedef adý/ID]");
  	if(!IsPlayerConnected(hedefid))
		return OyundaDegilMesaj(playerid);
	if(playerid == hedefid)
		return YollaHataMesaj(playerid, "Kendini izleyemezsin.");

	GetPlayerPos(playerid, Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
	Oyuncu[playerid][VW] = GetPlayerVirtualWorld(playerid);
	Oyuncu[playerid][Int] = GetPlayerInterior(playerid);
	SetPlayerInterior(playerid, GetPlayerInterior(hedefid));
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(hedefid));
	TogglePlayerSpectating(playerid, 1);
	if(IsPlayerInAnyVehicle(hedefid))
		PlayerSpectateVehicle(playerid, GetPlayerVehicleID(hedefid));
	else PlayerSpectatePlayer(playerid, hedefid);

	YollaIpucuMesaj(playerid, "%s adlý oyuncuyu izliyorsun.", Oyuncuadi(hedefid));
	return 1;
}

CMD:aspecoff(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 1)
		return 1;

	TogglePlayerSpectating(playerid, 0);
	SetPlayerInterior(playerid, Oyuncu[playerid][Int]);
	SetPlayerVirtualWorld(playerid, Oyuncu[playerid][VW]);
	SetPlayerPos(playerid, Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
	YollaIpucuMesaj(playerid, "Ýzlemeden çýktýn.");
	return 1;
}

CMD:setname(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 3)
		return 1;
	new hedefid, isim[MAX_PLAYER_NAME], sorgu[120], Cache: sorguj;
	if(sscanf(params, "us[24]", hedefid, isim))
		return YollaKullanMesaj(playerid, "/setname [hedef adý/ID] [isim]");
  	if(!IsPlayerConnected(hedefid))
		return OyundaDegilMesaj(playerid);
	if(strlen(isim) > MAX_PLAYER_NAME)
		return YollaHataMesaj(playerid, "Ýsim uzunluðu 1-24 arasýnda olmalýdýr.");

	format(isim, MAX_PLAYER_NAME, "%s", TRcevir(isim));
	if(IsPlayerConnected(ReturnUser(isim)))
		return YollaHataMesaj(playerid, "Bu isim kullanýlýyor.");

	mysql_format(CopSQL, sorgu, sizeof(sorgu), "SELECT * FROM hesaplar WHERE isim = '%s'", isim);
	sorguj = mysql_query(CopSQL, sorgu);
	if(cache_num_rows())
		return YollaHataMesaj(playerid, "Bu isim kullanýlýyor.");
	cache_delete(sorguj);
	format(Oyuncu[hedefid][OyuncuAdi], MAX_PLAYER_NAME, "%s", isim);
	YollaYoneticiMesaj(1, RENK_YARALI, "AdmCmd: %s tarafýndan %s adlý oyuncunun ismi %s ile deðiþtirildi.", Oyuncuadi(playerid), Oyuncuadi(hedefid), Oyuncu[hedefid][OyuncuAdi]);
	SetPlayerName(hedefid, Oyuncu[hedefid][OyuncuAdi]);
	mysql_format(CopSQL, sorgu, sizeof(sorgu), "UPDATE `hesaplar` SET `isim` = '%s' WHERE `ID` = %d LIMIT 1", Oyuncu[hedefid][OyuncuAdi], Oyuncu[hedefid][SQLID]);
	mysql_tquery(CopSQL, sorgu);
	return 1;
}

CMD:setscore(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 3)
		return 1;
	new hedefid, miktar;
	if(sscanf(params, "ud", hedefid, miktar))
		return YollaKullanMesaj(playerid, "/setscore [hedef adý/ID] [miktar]");
  	if(!IsPlayerConnected(hedefid))
		return OyundaDegilMesaj(playerid);

	SkorVer(hedefid, miktar);
	YollaYoneticiMesaj(1, RENK_YARALI, "AdmCmd: %s tarafýndan %s adlý oyuncuya %d miktar skor verildi.", Oyuncuadi(playerid), Oyuncuadi(hedefid), miktar);
	return 1;
}

CMD:setscoreall(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 3)
		return 1;
	new miktar;
	if(sscanf(params, "d", miktar))
		return YollaKullanMesaj(playerid, "/setscoreall [miktar]");

	for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	SkorVer(i, miktar);
	YollaHerkeseMesaj(RENK_YARALI, "AdmCmd: %s adlý admin tarafýndan %d miktarýnda skor verildi.", Oyuncuadi(playerid), miktar);
	return 1;
}

CMD:bakim(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 4)
		return 1;
	YollaHerkeseMesaj(RENK_YARALI, "AdmCmd: Sunucu bakým nedeniyle geçiçi olarak hizmete kapatýlmýþtýr.");
	for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(Oyuncu[i][Yonetici] >= 3)
			continue;
		Kickle(i);
		SendRconCommand("password sunshine1616");
	}
	return 1;
}

CMD:donatoryap(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 7)
		return 1;
	new hedefid;
    if(sscanf(params, "u", hedefid))
    	return YollaKullanMesaj(playerid, "/donatoryap [hedef adý/ID]");
    if(!IsPlayerConnected(hedefid))
		return OyundaDegilMesaj(playerid);

    if(Oyuncu[hedefid][Donator] == true)
    {
    	Oyuncu[hedefid][Donator] = false;
    	YollaIpucuMesaj(hedefid, "%s adlý yönetici donatorlüðünü aldý.", Oyuncuadi(playerid));
        return YollaYoneticiMesaj(1, RENK_YARALI, "AdmCmd: %s, %s kiþisinin donatorlüðünü aldý.", Oyuncuadi(playerid), Oyuncuadi(hedefid));
    }
	Oyuncu[hedefid][Donator] = true;
	YollaYoneticiMesaj(1, RENK_YARALI, "AdmCmd: %s, %s kiþisini donator yaptý.", Oyuncuadi(playerid), Oyuncuadi(hedefid));
	return 1;
}

CMD:ajail(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 2)
		return 1;
	new hedefid, dakika, sebep[100];
    if(sscanf(params, "uds[100]", hedefid, dakika, sebep))
    	return YollaKullanMesaj(playerid, "/jail [hedef adý/ID] [dakika] [sebep]");
    if(!IsPlayerConnected(hedefid))
		return OyundaDegilMesaj(playerid);
	if(dakika <= 0)
		return YollaHataMesaj(playerid, "Jail dakikasý 0'dan büyük olmalýdýr.");
	if(Oyuncu[hedefid][HapisDakika] >= 1)
		return YollaHataMesaj(playerid, "Oyuncu zaten hapiste.");

	Oyuncu[hedefid][HapisDakika] = dakika;
	Oyuncu[hedefid][HapisTimer] = SetTimerEx("OyuncuHapis", TIMER_DAKIKA(1), true, "d", hedefid);
	JailGonder(hedefid);
	if(OyunBasladi == true && Oyuncu[hedefid][Oyunda] == true)
	{
		Oyuncu[hedefid][Oyunda] = Oyuncu[hedefid][Suspect] = Oyuncu[hedefid][Polis] = false;
		OyunKontrol();
	}
	SetPlayerColor(hedefid, BEYAZ3);
	ResetPlayerWeapons(hedefid);
	YollaHerkeseMesaj(RENK_YARALI, "AdmCmd: %s adlý oyuncu cezalandýrýldý. [Sebep: %s - Dakika: %d]", Oyuncuadi(hedefid), sebep, dakika);  // Oyuncuadi(playerid),
	return 1;
}

CMD:mjail(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 1)
		return 1;
	new hedefid, dakika, sebep[100];
    if(sscanf(params, "uds[100]", hedefid, dakika, sebep))
    	return YollaKullanMesaj(playerid, "/mjail [hedef adý/ID] [dakika(1-120)] [sebep]");
    if(!IsPlayerConnected(hedefid))
		return OyundaDegilMesaj(playerid);
	if(dakika <= 0)
		return YollaHataMesaj(playerid, "Jail dakikasý 0'dan büyük olmalýdýr.");
    if(dakika >= 120)
        return YollaHataMesaj(playerid, "120 dakikadan fazla atamazsýnýz.");
	if(Oyuncu[hedefid][HapisDakika] >= 1)
		return YollaHataMesaj(playerid, "Oyuncu zaten hapiste.");

	Oyuncu[hedefid][HapisDakika] = dakika;
	Oyuncu[hedefid][HapisTimer] = SetTimerEx("OyuncuHapis", TIMER_DAKIKA(1), true, "d", hedefid);
	JailGonder(hedefid);
	if(OyunBasladi == true && Oyuncu[hedefid][Oyunda] == true)
	{
		Oyuncu[hedefid][Oyunda] = Oyuncu[hedefid][Suspect] = Oyuncu[hedefid][Polis] = false;
		OyunKontrol();
	}
	SetPlayerColor(hedefid, BEYAZ3);
	ResetPlayerWeapons(hedefid);
	YollaHerkeseMesaj(RENK_YARALI, "AdmCmd: %s adlý oyuncu cezalandýrýldý. [Sebep: %s - Dakika: %d]",  Oyuncuadi(hedefid), sebep, dakika);  // Oyuncuadi(playerid),
	return 1;
}

CMD:unjail(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 2)
		return 1;
	new hedefid;
    if(sscanf(params, "u", hedefid))
    	return YollaKullanMesaj(playerid, "/unjail [hedef adý/ID]");
    if(!IsPlayerConnected(hedefid))
		return OyundaDegilMesaj(playerid);
	if(Oyuncu[hedefid][HapisDakika] <= 0)
		return YollaHataMesaj(playerid, "Bu kiþi hapiste deðil.");

	Oyuncu[hedefid][HapisDakika] = 0;
	Oyuncu[hedefid][AFK] = false;
	KillTimer(Oyuncu[hedefid][HapisTimer]);
	LobiyeDon(hedefid);
	YollaYoneticiMesaj(1, RENK_YARALI, "AdmCmd: %s, %s adlý oyuncuyu hapisten çýkardý.", Oyuncuadi(playerid), Oyuncuadi(hedefid));
	return 1;
}

CMD:sorusor(playerid, params[])
{
	new soru[120];
    if(sscanf(params, "s[120]", soru))
    	return YollaKullanMesaj(playerid, "/sorusor [soru]");
    if(Oyuncu[playerid][Soru] == true)
    	return YollaHataMesaj(playerid, "Aktif bir sorunuz var, sorunuzu iptal etmek için /soruiptal yazýn.");
    if(strlen(soru) > 120)
    	return YollaHataMesaj(playerid, "Sorunuz 120 karakterden fazla olamaz.");

    Oyuncu[playerid][Soru] = true;
    Oyuncu[playerid][Sorusu] = soru;
    YollaIpucuMesaj(playerid, "Sorun aktif yönetici ve supporterlara gönderildi.");
    YollaSoruMesaj(RENK_YARALI, "Soru: %s [%s - ID: %d]", soru, Oyuncuadi(playerid), playerid);
	return 1;
}

CMD:sorucevap(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] >= 1 || Oyuncu[playerid][Helper] == true)
	{
		new hedefid, cevap[120];
	    if(sscanf(params, "us[120]", hedefid, cevap))
	    	return YollaKullanMesaj(playerid, "/sorucevap [hedef adý/ID] [cevap]");
	    if(!IsPlayerConnected(hedefid))
			return OyundaDegilMesaj(playerid);
	    if(Oyuncu[hedefid][Soru] == false)
	    	return YollaHataMesaj(playerid, "Bu oyuncunun aktif sorusu yok.");

        if(Oyuncu[playerid][Helper] == true || Oyuncu[playerid][Yonetici] == 1)
	        YollaIpucuMesaj(playerid, "Soru:"#BEYAZ2" %s [%s - ID: %d]", Oyuncu[hedefid][Sorusu], Oyuncuadi(hedefid), hedefid);
	    if(Oyuncu[playerid][Yonetici] >= 1)
	    	YollaIpucuMesaj(playerid, "Cevap:"#BEYAZ2" %s [%s - (%s)"#BEYAZ2"]", cevap, Oyuncuadi(playerid), YoneticiYetkiAdi(Oyuncu[playerid][Yonetici]));
	    if(Oyuncu[playerid][Helper] == true)
	    	YollaIpucuMesaj(playerid, "Cevap:"#BEYAZ2" %s [%s - Supporter"#BEYAZ2"]", cevap, Oyuncuadi(playerid));
	    Oyuncu[hedefid][Soru] = false;
	    format(Oyuncu[hedefid][Sorusu], 100, "-");
	}
	return 1;
}

CMD:sorured(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] >= 1 || Oyuncu[playerid][Helper] == true)
	{
		new hedefid, sebep[120];
	    if(sscanf(params, "us[120]", hedefid, sebep))
	    	return YollaKullanMesaj(playerid, "/sorured [hedef adý/ID] [sebep]");

	    if(Oyuncu[hedefid][Soru] == false)
	    	return YollaHataMesaj(playerid, "Bu oyuncunun aktif sorusu yok.");

	    YollaYoneticiMesaj(1, RENK_YARALI, "AdmCmd: %s adlý yönetici %s adlý oyuncunun sorusunu reddetti. Sebep: %s", Oyuncuadi(playerid), Oyuncuadi(hedefid), sebep);
		YollaIpucuMesaj(hedefid, "Sorunuz %s adlý yetkili tarafýndan red edildi, lütfen kurallarý okuyup tekrar atýn. Sebep: %s", Oyuncuadi(playerid), sebep);
	    Oyuncu[hedefid][Soru] = false;
	    format(Oyuncu[hedefid][Sorusu], 100, "-");
	}
	return 1;
}

CMD:soruiptal(playerid, params[])
{
    if(Oyuncu[playerid][Soru] == false)
    	return YollaHataMesaj(playerid, "Aktif sorun yok.");
    Oyuncu[playerid][Soru] = false;
    format(Oyuncu[playerid][Sorusu], 100, "-");
    YollaIpucuMesaj(playerid, "Göndermiþ olduðunuz soruyu iptal ettiniz.");
	return 1;
}

/*CMD:event(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 3)
		return 1;

	if(EventModu == false)
	{
		YollaHerkeseMesaj(RENK_YARALI, "AdmCmd: Bir sonra ki tur için event modu aktif edildi.");
		EventModu = true;
		return 1;
	}
	if(EventModu == true)
	{
		YollaHerkeseMesaj(RENK_YARALI, "AdmCmd: Bir sonra ki tur için event modu kapatýldý.");
		EventModu = false;
		return 1;
	}
	return 1;
}

CMD:event2(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 3)
		return 1;

	if(EventModu2 == false)
	{
		YollaHerkeseMesaj(RENK_YARALI, "AdmCmd: Bir sonra ki tur için event modu aktif edildi.");
		EventModu = false;
		EventModu2 = true;
		return 1;
	}
	if(EventModu2 == true)
	{
		YollaHerkeseMesaj(RENK_YARALI, "AdmCmd: Bir sonra ki tur için event modu kapatýldý.");
		EventModu2 = false;
		return 1;
	}
	return 1;
}*/

CMD:kurallar(playerid, params[])
{
	new mesaj[900];
	strcat(mesaj, "- Oyunda seni diðer oyunculardan üstün kýlan mod kullanamazsýn.\n");
	strcat(mesaj, "- /ooc chatte hakaret etmemelisin.\n");
	strcat(mesaj, "- Roleplay modunda roleplay kurallarýna uygun davranmalýsýn.\n");
	strcat(mesaj, "- Polis memurlarý, þüpheliler ateþ açmaya baþlayana kadar ateþ açamaz buna tekerlekler dahil.\n");
	strcat(mesaj, "- Bulunduðun aracý roleplay kurallarý içinde sürmeye dikkat etmelisin.\n");
	strcat(mesaj, "- Aracýný sürerken polislere veya þüphelilere ramming yapmamalýsýn.\n");
	strcat(mesaj, "- Þüpheli sudayken kiþiyi kelepçeleyemez, taserleyemez ya da beanbag ile ateþ edemezsin.\n");
	strcat(mesaj, "- Þüpheliler ateþ açmadýðý sürece Drive-BY (araçtan sarkma) yapamazsýn.\n");
	strcat(mesaj, "- Objeleri amacý dýþýnda kullanmak yasaktýr.\n");
	strcat(mesaj, "- Polisler araçlarýný düzgün sürmek zorunda, LINE (tek çizgi) kuralýna dikkat edilmelidir.\n");
	strins(mesaj, ""#BEYAZ2"", 0);
	ShowPlayerDialog(playerid, DIALOG_X, DIALOG_STYLE_MSGBOX, "S-PP - Kurallar", mesaj, "Kapat", "");
	return 1;
}

CMD:skin(playerid, params[])
{
    new secim[20];
	if(sscanf(params, "s[20]d", secim))
		return YollaKullanMesaj(playerid, "/skin [polis/suçlu]");

    if(Oyuncu[playerid][HapisDakika] >= 1)
		return YollaHataMesaj(playerid, "Hapisteyken bu komutu kullanamazsýn.");
	if(Oyuncu[playerid][Oyunda] == true)
		return YollaHataMesaj(playerid, "Lobide deðilsin.");

	if(!strcmp(secim, "polis"))
	{
        ShowModelSelectionMenuEx(playerid, PDSkin, TOTAL_PD_SKIN, "Polis Skinleri", PDKIYAFET, 16.0, 0.0, -55.0);
		YollaIpucuMesaj(playerid, "Cop kýyafetini deðiþtirdin.");
	}
	else if(!strcmp(secim, "suçlu"))
	{
	    ShowModelSelectionMenuEx(playerid, Male, TOTAL_M_SKIN, "Kiyafetler", KIYAFET, 16.0, 0.0, -55.0);
		YollaIpucuMesaj(playerid, "Suspect kýyafetini deðiþtirdin.");
	}

    SetPVarInt(playerid, "kiyafetaliyor", 1);
    return 1;
}

/*CMD:pskin(playerid, params[])
{
    if(Oyuncu[playerid][HapisDakika] >= 1)
		return YollaHataMesaj(playerid, "Hapisteyken bu komutu kullanamazsýn.");
	if(Oyuncu[playerid][Oyunda] == true)
		return YollaHataMesaj(playerid, "Lobide deðilsin.");

    ShowModelSelectionMenuEx(playerid, PDSkin, TOTAL_PD_SKIN, "Polis Skinleri", PDKIYAFET, 16.0, 0.0, -55.0);
    SetPVarInt(playerid, "kiyafetaliyor", 1);
    return 1;

}

CMD:suspectskin(playerid, params[])
{
	if(Oyuncu[playerid][HapisDakika] >= 1)
		return YollaHataMesaj(playerid, "Hapisteyken bu komutu kullanamazsýn.");
	if(Oyuncu[playerid][Oyunda] == true)
		return YollaHataMesaj(playerid, "Lobide deðilsin.");

    ShowModelSelectionMenuEx(playerid, SuspectSkin, TOTAL_SUSPECT_SKIN, "Suspect Skinleri", SUSPECTKIYAFET, 16.0, 0.0, -55.0);
    SetPVarInt(playerid, "kiyafetaliyor", 1);
    return 1;
}*/

CMD:handsup(playerid, params[])
{
	if(Oyuncu[playerid][HapisDakika] >= 1)
		return YollaHataMesaj(playerid, "Hapisteyken bu komutu kullanamazsýn.");
	if(Oyuncu[playerid][Taserlendi] == true)
		return 1;
	if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED)
		return 1;

	Oyuncu[playerid][Anim] = true;
	YollaIpucuMesaj(playerid, "Mouse'ýn sol tuþu ile animasyonu bozabilirsin.");
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_HANDSUP);
	return 1;
}

CMD:aim(playerid, params[])
{
	if(Oyuncu[playerid][HapisDakika] >= 1)
		return YollaHataMesaj(playerid, "Hapisteyken bu komutu kullanamazsýn.");
	if(Oyuncu[playerid][Taserlendi] == true)
		return 1;
	if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED)
		return 1;

	Oyuncu[playerid][Anim] = true;
	YollaIpucuMesaj(playerid, "Mouse'ýn sol tuþu ile animasyonu bozabilirsin.");
	ApplyAnimation(playerid, "ped", "ARRESTgun", 4.0, 0, 1, 1, 1, 1, 1);
	return 1;
}

CMD:sitonchair(playerid, params[])
{
	if(Oyuncu[playerid][HapisDakika] >= 1)
		return YollaHataMesaj(playerid, "Hapisteyken bu komutu kullanamazsýn.");
	if(Oyuncu[playerid][Taserlendi] == true)
		return 1;
	if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED)
		return 1;

	new anim;
    if(sscanf(params, "d", anim))
    	return YollaKullanMesaj(playerid, "/sitonchair [1-7]");

	switch(anim)
	{
		case 1: ApplyAnimation(playerid, "Attractors", "Stepsit_in", 4.0, 0, 0, 0, 1, 0, 1);
		case 2: ApplyAnimation(playerid, "CRIB", "PED_Console_Loop", 4.0, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "INT_HOUSE", "LOU_In", 4.0, 0, 0, 0, 1, 1, 1);
		case 4: ApplyAnimation(playerid, "MISC", "SEAT_LR", 4.0, 1, 0, 0, 0, 0, 1);
		case 5: ApplyAnimation(playerid, "MISC", "Seat_talk_01", 4.0, 1, 0, 0, 0, 0, 1);
		case 6: ApplyAnimation(playerid, "MISC", "Seat_talk_02", 4.0, 1, 0, 0, 0, 0, 1);
		case 7: ApplyAnimation(playerid, "ped", "SEAT_down", 4.0, 0, 0, 0, 1, 1, 1);
		default: YollaKullanMesaj(playerid, "/sitonchair [1-7]");
	}
	Oyuncu[playerid][Anim] = true;
	YollaIpucuMesaj(playerid, "Mouse'ýn sol tuþu ile animasyonu bozabilirsin.");
	return 1;
}

CMD:crossarms(playerid, params[])
{
	if(Oyuncu[playerid][HapisDakika] >= 1)
		return YollaHataMesaj(playerid, "Hapisteyken bu komutu kullanamazsýn.");
	if(Oyuncu[playerid][Taserlendi] == true)
		return 1;
	if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED)
		return 1;


	new anim;
    if(sscanf(params, "d", anim))
    	return YollaKullanMesaj(playerid, "/crossarms [1-5]");

	switch(anim)
	{
		case 1: ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_loop", 4.0, 0, 1, 1, 1, -1, 1);
		case 2: ApplyAnimation(playerid, "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0, 1);
		case 3: ApplyAnimation(playerid, "GRAVEYARD", "mrnM_loop", 4.0, 1, 0, 0, 0, 0, 1);
		case 4: ApplyAnimation(playerid, "GRAVEYARD", "prst_loopa", 4.0, 1, 0, 0, 0, 0, 1);
		case 5: ApplyAnimation(playerid, "DEALER", "DEALER_IDLE_01", 4.0, 1, 0, 0, 0, 0, 1);
		default: YollaKullanMesaj(playerid, "/crossarms [1-5]");
	}
	Oyuncu[playerid][Anim] = true;
	YollaIpucuMesaj(playerid, "Mouse'ýn sol tuþu ile animasyonu bozabilirsin.");
	return 1;
}

CMD:animlist(playerid, params[])
{
	YollaIpucuMesaj(playerid, "/handsup - /aim - /sitonchair - /crossarms");
	return 1;
}

CMD:spec(playerid, params[])
{
	if(OyunBasladi == false)
		return YollaHataMesaj(playerid, "Oyun baþlamadý kimseyi izleyemezsin.");
	if(Oyuncu[playerid][Oyunda] == true)
		return YollaHataMesaj(playerid, "Lobide deðilken birisini izleyemezsiniz.");
	if(Oyuncu[playerid][HapisDakika] >= 1)
		return YollaHataMesaj(playerid, "Hapisteyken bu komutu kullanamazsýn.");
	new hedefid;
	if(sscanf(params, "u", hedefid))
		return YollaKullanMesaj(playerid, "/spec [hedef adý/ID]");
	/*if(Oyuncu[hedefid][Suspect] == true)
		return YollaHataMesaj(playerid, "Þüphelileri izleyemezsiniz, sadece polisleri.");*/
	if(playerid == hedefid)
		return YollaHataMesaj(playerid, "Kendini izleyemezsin.");
    if(!IsPlayerConnected(hedefid))
		return OyundaDegilMesaj(playerid);

	Oyuncu[playerid][VW] = GetPlayerVirtualWorld(playerid);
	Oyuncu[playerid][Int] = GetPlayerInterior(playerid);
	SetPlayerInterior(playerid, GetPlayerInterior(hedefid));
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(hedefid));
	TogglePlayerSpectating(playerid, 1);
	if(IsPlayerInAnyVehicle(hedefid))
		PlayerSpectateVehicle(playerid, GetPlayerVehicleID(hedefid));
	else PlayerSpectatePlayer(playerid, hedefid);

	YollaIpucuMesaj(playerid, "%s adlý oyuncuyu izliyorsun.", Oyuncuadi(hedefid));
	return 1;
}

CMD:specoff(playerid, params[])
{
	if(Oyuncu[playerid][HapisDakika] >= 1)
		return YollaHataMesaj(playerid, "Hapisteyken bu komutu kullanamazsýn.");
	if(OyunBasladi == false)
		return YollaHataMesaj(playerid, "Henüz oyun baþlamadý, bu komutu kullanamazsýn.");
	if(Oyuncu[playerid][Oyunda] == true)
		return YollaHataMesaj(playerid, "Bu komut lobide kullanýlabilir.");
	if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
		return YollaHataMesaj(playerid, "Kimseyi izlemiyorsun.");

	TogglePlayerSpectating(playerid, 0);
	LobiyeDon(playerid);
	YollaIpucuMesaj(playerid, "Ýzlemeden çýktýn.");
	return 1;
}

CMD:kill(playerid, params[])
{
	if(Oyuncu[playerid][HapisDakika] >= 1)
		return YollaHataMesaj(playerid, "Hapisteyken bu komutu kullanamazsýn.");

    if(Oyuncu[playerid][Suspect] == true)
		return YollaHataMesaj(playerid, "Þüpheliyken bu komutu kullanamazsýn.");

	if(Oyuncu[playerid][Oyunda] == false && Oyuncu[playerid][DM] == false && Oyuncu[playerid][aktifduel] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");

	if(Oyuncu[playerid][DM] == true)
	{
		Oyuncu[playerid][DM] = false;
		new sayi = random(22);
		sscanf(LobiKonum(sayi), "p<,>fff", Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
	}
	Oyuncu[playerid][brutallyWounded] = 1;
	SetPlayerHealth(playerid, 0.0);
	OyuncuLobiGonder(playerid);
	return 1;
}

CMD:lobi(playerid, params[])
{
	if(Oyuncu[playerid][HapisDakika] >= 1)
		return YollaHataMesaj(playerid, "Hapisteyken bu komutu kullanamazsýn.");
	if(Oyuncu[playerid][brutallyWounded] == 1)
	{
	YollaIpucuMesaj(playerid, ""#YARALI"Lobiye gönderildin.");
	}
	if(Oyuncu[playerid][DM] == false)
		return YollaHataMesaj(playerid, "DM lobisinde deðilsin.");
	/*if(Oyuncu[playerid][Yonetici] >=4 || Oyuncu[playerid][Oyunda] = true)
		return YollaHataMesaj(playerid, "");*/ // DENENMESÝ GEREKEN KOD

	Oyuncu[playerid][DM] = false;
	new sayi = random(22);
	sscanf(LobiKonum(sayi), "p<,>fff", Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
	SetPlayerPos(playerid, Oyuncu[playerid][Pos][0], Oyuncu[playerid][Pos][1], Oyuncu[playerid][Pos][2]);
	Oyuncu[playerid][ZirhHak] = Oyuncu[playerid][Oyunda] = Oyuncu[playerid][Suspect] = Oyuncu[playerid][Polis] = false;
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid, LOBI_INTERIOR);
	ResetPlayerWeapons(playerid);
	if(Oyuncu[playerid][DMLobi] == 1 || 2 || 3 || 4)
	{
	Oyuncu[playerid][DMLobi] = 0;
	}
	return 1;
}

CMD:discord(playerid, params[])
{
	YollaIpucuMesaj(playerid, "Discord adresimiz > https://discord.gg/guutUUKm3F");
	return 1;
}

CMD:jailtime(playerid, params[])
{
	if(Oyuncu[playerid][HapisDakika] <= 0)
		return YollaHataMesaj(playerid, "Hapiste deðilsin.");
	YollaIpucuMesaj(playerid, "Kalan hapis süresi: %d dakika", Oyuncu[playerid][HapisDakika]);
	return 1;
}

CMD:yardim(playerid, params[])
{
	YollaFormatMesaj(playerid, RENK_BRHELP, "[Genel]"#BEYAZ2" /kurallar, /animlist, /spec, /specoff, /kill, /dm, /discord, /bilgi1, /bilgi2 /topdm");
	YollaFormatMesaj(playerid, RENK_BRHELP, "[Genel]"#BEYAZ2" /jailtime, /timeleft, /rapor, /raporiptal, /sorusor, /soruiptal, /suspectskin, /skoryardim, /pskin");
	YollaFormatMesaj(playerid, RENK_BRHELP, "[Genel]"#BEYAZ2" /supheliler, /track, /afk, /oyun, /hud, /pmkapat /lisans, /hesap, /dyardim");
	YollaFormatMesaj(playerid, RENK_BRHELP, "[Genel]"#BEYAZ2" /gir, /cik, /mp3");
	YollaFormatMesaj(playerid, RENK_BRHELP, "[Roleplay]"#BEYAZ2" /me, /do, /ame, /s (baðýrarak), /l (sessiz), /w (fýsýldama), /aooc, /b (ooc), /pm");
	YollaFormatMesaj(playerid, COLOR_GREY, "[Araç]"#BEYAZ2" /kilit, /camac, /camkapat, /tamir, /bagaj, /polisler, /bsilahal ");
	YollaFormatMesaj(playerid, COLOR_GREY, "[Polis]"#BEYAZ2" /kelepce, /taser (Y'ye bas), /beanbag, /elm, /asilahal, /aracdegistir");
	YollaFormatMesaj(playerid, COLOR_GREY, "[Polis]"#BEYAZ2" [N] tuþu destek ister, /civi, /koni, /engelpos, /engelsil, /r, /m, /m1, /m2, /gov, /op");
	if(Oyuncu[playerid][Donator] == true)
	{
	YollaFormatMesaj(playerid, COLOR_GREY, "[Donator]"#BEYAZ2" /dzirh, /disimdegistir, /dskin");
	}
	if(Oyuncu[playerid][Helper] == true)
	{
	YollaFormatMesaj(playerid, COLOR_SUPPORTER, "Supporter: Supporter komutlarýný görmek için /scmds komutunu kullanýn.");
	}
	if(Oyuncu[playerid][Yonetici] >= 1)
		{
	YollaFormatMesaj(playerid, COLOR_LIGHTRED, "Admin: Yönetici komutlarýný görmek için /acmds komutunu kullanýn.");
	    }


	return 1;
}

CMD:aracdegistir(playerid, params[])
{
	if(Oyuncu[playerid][HapisDakika] >= 1)
		return YollaHataMesaj(playerid, "Hapiste komut kullanamazsýn.");
	if(Oyuncu[playerid][Oyunda] == true)
		return YollaHataMesaj(playerid, "Bu komut lobide kullanýlabilir.");

	//ShowPlayerDialog(playerid, DIALOG_ARACDEGISTIR, DIALOG_STYLE_LIST, "Araç Deðiþtir", "Police Car (LSPD)\nPolice Car (SFPD)\nPolice Car (SASD)\nPolice Ranger\nHPV1000\nFBI Truck\nPremier\nBullet [5000 Skor]\nBuffalo [DONATOR]\nSultan [2000 Skor]", "Deðiþtir", "Kapat");

    ShowModelSelectionMenuEx(playerid, AracDegistir, TOTAL_ARACDEGISTIR, "Arac Listesi", ARACDEGISTIR, 16.0, 0.0, -55.0);
    SetPVarInt(playerid, "aracdegistir", 1);
	return 1;
}

CMD:kontrol(playerid)
{
	if(Oyuncu[playerid][Yonetici] < 2) return 1;
	OyunKontrol();
	return 1;
}

/*CMD:cekilisyap(playerid, params[])
{
    if(Oyuncu[playerid][Yonetici] < 4) return YollaHataMesaj(playerid, "Yetersiz yetki.");

    new cekilis = getRandomPlayer();

    if(!IsPlayerConnected(cekilis) || playerid == cekilis)
        return YollaHataMesaj(playerid, "Çekiliþ baþarýsýz, tekrar deneyin.");

    foreach(new i : Player)
    {
        if(!IsPlayerConnected(i))continue;
        YollaHerkeseMesaj("%s elini torbaya soktu ve karýþtýrýyor. Çekiliþi kazanan: %s", OyuncuAdi(playerid, true), OyuncuAdi(cekilis, true));
    }
    return 1;
}*/

CMD:supheliler(playerid, params[])
{
	if(OyunBasladi == false)
		return YollaHataMesaj(playerid, "Aktif oyun yok.");
	new supheli[4], sayi, mesaj[130];
	foreach(new i : Player)
	{
		if(Oyuncu[i][GirisYapti] == true && Oyuncu[i][Oyunda] == true && Oyuncu[i][Suspect] == true)
		{
			supheli[sayi] = i;
			sayi++;
		}
	}
	if(sayi == 1)
		format(mesaj, sizeof(mesaj), "(Suspect) - %s", Oyuncuadi(supheli[0]));
	if(sayi == 2)
		format(mesaj, sizeof(mesaj), "(Suspect) -%s, (Suspect) - %s", Oyuncuadi(supheli[0]), Oyuncuadi(supheli[1]));
	if(sayi == 3)
		format(mesaj, sizeof(mesaj), "(Suspect) - %s, (Suspect)- %s, (Suspect) - %s", Oyuncuadi(supheli[0]), Oyuncuadi(supheli[1]), Oyuncuadi(supheli[2]));
	if(sayi == 4)
		format(mesaj, sizeof(mesaj), "(Suspect) - %s, (Suspect) - %s,(Suspect) - %s, (Suspect) - %s", Oyuncuadi(supheli[0]), Oyuncuadi(supheli[1]), Oyuncuadi(supheli[2]), Oyuncuadi(supheli[3]));
	strins(mesaj, "{B71C1C}", 0);
	YollaIpucuMesaj(playerid, mesaj);
	return 1;
}

CMD:id(playerid, params[])
{
	if (isnull(params))
	    return YollaKullanMesaj(playerid, "/id [id/isim]");

	if (strlen(params) < 2)
		return YollaHataMesaj(playerid, "En az 2 karakter belirtmelisiniz.");

	new count;

    foreach (new i : Player)
	{
	    if (strfind(Oyuncuadi(i), params, true) != -1)
	    {
	        YollaIpucuMesaj(playerid,""#BEYAZ2"> %s - ID: %d", Oyuncuadi(i), i);
	        count++;
		}
	}
	if (!count)
	    return YollaHataMesaj(playerid, "Bu kriterlerde hiçbir oyuncu bulunamadý: \"%s\".", params);

	return 1;
}

CMD:pm(playerid, params[])
{
	new hedefid, mesaj[150];
	if(sscanf(params, "us[150]", hedefid, mesaj))
		return YollaKullanMesaj(playerid, "/pm [hedef adý/ID] [mesaj]");
    if(!IsPlayerConnected(hedefid))
		return OyundaDegilMesaj(playerid);
	if(playerid == hedefid)
		return YollaHataMesaj(playerid, "Kendine PM atamazsýn.");
	if(Oyuncu[hedefid][PMizin] == true)
		return YollaHataMesaj(playerid, "Kiþi özel mesajýný kapatmýþ.");
	if(Oyuncu[playerid][PMizin] == true)
	    return YollaHataMesaj(playerid, "Özel mesajýn kapalý.");

	YollaFormatMesaj(playerid, 0xB79400FF, "[PM] %s(%d) kiþisine: %s", Oyuncuadi(hedefid), hedefid, mesaj);
	YollaFormatMesaj(hedefid, 0xE5B900FF, "[PM] %s(%d) kiþisinden: %s", Oyuncuadi(playerid), playerid, mesaj);
	if(Oyuncu[playerid][apm] == true && Oyuncu[playerid][Yonetici] >= 2)
	{
	    YollaYoneticiMesaj(1, 0xB79400FF, "[APM] %s'dan %s'ya mesaj: %s", Oyuncuadi(playerid), Oyuncuadi(hedefid), mesaj);
		return 1;
	}

	return 1;
}

CMD:pmkapat(playerid, params[])
{

	if(Oyuncu[playerid][PMizin] == true)
	{
		Oyuncu[playerid][PMizin] = false;
		YollaIpucuMesaj(playerid, "Özel mesajlarýný açtýn artýk özel mesaj alabilirsin.");
		return 1;
	}
	if(Oyuncu[playerid][PMizin] == false)
	{
		Oyuncu[playerid][PMizin] = true;
		YollaIpucuMesaj(playerid, "Özel mesajlarýný kapattýn artýk özel mesaj almayacaksýn.");
		return 1;
	}
	return 1;

}

CMD:apm(playerid, params[])
{

    if(Oyuncu[playerid][Yonetici] < 1)
		return 1;

	if(Oyuncu[playerid][apm] == true)
	{
		Oyuncu[playerid][apm] = false;
		YollaIpucuMesaj(playerid, "Artýk özel mesajlarý okumayacaksýn.");
		return 1;
	}
	if(Oyuncu[playerid][apm] == false)
	{
		Oyuncu[playerid][apm] = true;
		YollaIpucuMesaj(playerid, "Özel mesajlarý okumayý açtýn.");
		return 1;
	}
	return 1;

}

CMD:rapor(playerid, params[])
{
	new hedefid, rapor[120];
    if(sscanf(params, "ds[120]", hedefid, rapor))
    	return YollaKullanMesaj(playerid, "/rapor [hedef adý/ID] [sebep]");
    if(Oyuncu[playerid][Rapor] == true)
    	return YollaHataMesaj(playerid, "Aktif bir raporunuz var, raporunuzu iptal etmek için /raporiptal yazýn.");
    if(strlen(rapor) > 120)
    	return YollaHataMesaj(playerid, "Rapor sebebiniz 120 karakterden fazla olamaz.");

    Oyuncu[playerid][Rapor] = true;
    Oyuncu[playerid][Raporu] = rapor;
    YollaIpucuMesaj(playerid, "Bu kiþi hakkýnda yöneticilere bir rapor yolladýnýz.");
    YollaYoneticiMesaj(1, RENK_YARALI, "AdmCmd: %s(%d) - %s(%d) adlý oyuncuyu raporladý. Sebep: %s", Oyuncuadi(playerid), playerid, Oyuncuadi(hedefid), hedefid, rapor);
	return 1;
}

CMD:raporiptal(playerid, params[])
{
    if(Oyuncu[playerid][Rapor] == false)
    	return YollaHataMesaj(playerid, "Aktif raporun yok.");
    Oyuncu[playerid][Rapor] = false;
    format(Oyuncu[playerid][Raporu], 120, "-");
    YollaIpucuMesaj(playerid, "Göndermiþ olduðunuz raporu iptal ettiniz.");
	return 1;
}

CMD:raporkabul(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] >= 2)
	{
		new hedefid;
	    if(sscanf(params, "u", hedefid))
	    	return YollaKullanMesaj(playerid, "/raporkabul [hedef adý/ID]");
	    if(!IsPlayerConnected(hedefid))
			return OyundaDegilMesaj(playerid);
	    if(Oyuncu[hedefid][Rapor] == false)
	    	return YollaHataMesaj(playerid, "Bu oyuncunun aktif raporu yok.");

	    YollaIpucuMesaj(hedefid, "Raporunuz yönetici tarafýndan kabul edildi. [R-ID: %d]", hedefid);
	    YollaYoneticiMesaj(1, SUNUCU_RENK, "AdmCmd: %s adlý yetkili %d ID'li raporu kabul etti.", Oyuncuadi(playerid), hedefid);
	    Oyuncu[hedefid][Rapor] = false;
	    format(Oyuncu[hedefid][Raporu], 100, "-");
	}
	return 1;
}

CMD:raporred(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] >= 2)
	{
		new hedefid, sebep[150];
	    if(sscanf(params, "us[150]", hedefid, sebep))
	    	return YollaKullanMesaj(playerid, "/raporred [hedef adý/ID] [sebep]");

	    if(Oyuncu[hedefid][Rapor] == false)
	    	return YollaHataMesaj(playerid, "Bu oyuncunun aktif raporu yok.");

	    YollaIpucuMesaj(hedefid, "Raporunuz %s adlý yetkili tarafýndan reddedildi. Sebep: %s", Oyuncuadi(playerid), sebep);
	   	YollaYoneticiMesaj(1, RENK_YARALI, "AdmCmd: %s adlý yetkili, %d ID'li raporu reddetti. Sebep: %s", Oyuncuadi(playerid), hedefid, sebep);
	    Oyuncu[hedefid][Rapor] = false;
	    format(Oyuncu[hedefid][Raporu], 120, "-");
	}
	return 1;
}

CMD:dzirh(playerid, params[])
{
	if(Oyuncu[playerid][Donator] == false)
		return YollaHataMesaj(playerid, "Donator deðilsin.");
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");
	if(Oyuncu[playerid][ZirhHak] == true)
		return YollaHataMesaj(playerid, "Zýrh hakkýnýzý kullanmýþsýnýz.");
	SetPlayerArmour(playerid, 100.0);
	YollaIpucuMesaj(playerid, "Zýrhýnýz fullendi.");
	Oyuncu[playerid][ZirhHak] = true;
	return 1;
}

CMD:disimdegistir(playerid, params[])
{
	if(Oyuncu[playerid][HapisDakika] >= 1)
		return YollaHataMesaj(playerid, "Hapiste komut kullanamazsýn.");
	if(Oyuncu[playerid][Donator] == false)
		return YollaHataMesaj(playerid, "Donator deðilsin.");
	if(Oyuncu[playerid][IsimHak] == true)
		return YollaHataMesaj(playerid, "Ýsim deðiþtirme hakkýnýzý kullandýnýz.");

    ShowPlayerDialog(playerid, DIALOG_DISIMDEGISTIR, DIALOG_STYLE_MSGBOX, "Ýsim Deðiþtirme", ""#BEYAZ2"Bu isim deðiþtirme hakkýný sadece bir defa kullanabileceksiniz.", "Tamam", "Ýptal");
	return 1;
}

CMD:me(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");
	new eylem[150];
    if(sscanf(params, "s[150]", eylem))
    	return YollaKullanMesaj(playerid, "/me [eylem]");

    format(eylem, sizeof(eylem), "* %s %s", Oyuncuadi(playerid), eylem);
    ProxDetector(15.0, playerid, eylem, EMOTE_RENK);
	return 1;
}

CMD:do(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");
	new eylem[150];
    if(sscanf(params, "s[150]", eylem))
    	return YollaKullanMesaj(playerid, "/do [eylem]");

    format(eylem, sizeof(eylem), "* %s (( %s ))", eylem, Oyuncuadi(playerid));
    ProxDetector(15.0, playerid, eylem, EMOTE_RENK);
	return 1;
}

CMD:s(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");
	new mesaj[150];
    if(sscanf(params, "s[150]", mesaj))
    	return YollaKullanMesaj(playerid, "/s [mesaj]");

    format(mesaj, sizeof(mesaj), "%s baðýrarak: %s!", Oyuncuadi(playerid), mesaj);
    ProxDetector(30.0, playerid, mesaj, BEYAZ);
	return 1;
}

CMD:l(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");
	new mesaj[150];
    if(sscanf(params, "s[150]", mesaj))
    	return YollaKullanMesaj(playerid, "/l [mesaj]");

    format(mesaj, sizeof(mesaj), "%s sessizce: %s", Oyuncuadi(playerid), mesaj);
    ProxDetector(10.0, playerid, mesaj, BEYAZ);
	return 1;
}

CMD:r(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");
	if(Oyuncu[playerid][Polis] == false)
		return YollaHataMesaj(playerid, "Polis deðilsin.");

	new mesaj[150];
    if(sscanf(params, "s[150]", mesaj))
    	return YollaKullanMesaj(playerid, "/r [mesaj]");

	format(mesaj, sizeof(mesaj), "[CH:911] (%s) %s: %s", PolisRutbe(playerid), Oyuncuadi(playerid), mesaj);
	PolisTelsiz(mesaj);
	return 1;
}

CMD:elm(playerid, params)
{
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");
	if(Oyuncu[playerid][Polis] == false)
		return YollaHataMesaj(playerid, "Polis deðilsin.");
	if(!IsPlayerInAnyVehicle(playerid))
		return YollaHataMesaj(playerid, "Araçta deðilsin.");
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return YollaHataMesaj(playerid, "Sürücü koltuðunda deðilsin.");

	new aracid = GetPlayerVehicleID(playerid);
	if(Flasor[aracid] == 1)
	{
		Flasor[aracid] = 0;
		KillTimer(FlasorTimer[aracid]);
		GetVehicleParamsEx(aracid, engine2, lights2, alarm2, doors2, bonnet2, boot2, objective2);
		SetVehicleParamsEx(aracid, engine2, VEHICLE_PARAMS_OFF, alarm2, doors2, bonnet2, boot2, objective2);
		YollaIpucuMesaj(playerid, "ELM'yi kapattýnýz!");
		return 1;
	}
	if(Flasor[aracid] == 0)
	{
	    FlasorDurum[aracid] = 1;
		FlasorTimer[playerid] = SetTimerEx("Flas", 200, true, "d", aracid);
		GetVehicleParamsEx(aracid, engine2, lights2, alarm2, doors2, bonnet2, boot2, objective2);
		SetVehicleParamsEx(aracid, engine2, VEHICLE_PARAMS_ON, alarm2, doors2, bonnet2, boot2, objective2);
		YollaIpucuMesaj(playerid, "ELM'yi aktif hale getirdiniz!");
		Flasor[aracid] = 1;
		return 1;
	}
	return 1;
}

CMD:b(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");

	new mesaj[150];
    if(sscanf(params, "s[150]", mesaj))
    	return YollaKullanMesaj(playerid, "/b [mesaj]");

    if(Oyuncu[playerid][Yonetici] >=1)
    {
    format(mesaj, sizeof(mesaj), ""#BEYAZ2"(( [%d] "#YARALI"%s: "#BEYAZ2"%s ))", playerid, Oyuncuadi(playerid), mesaj);
    ProxDetector(15.0, playerid, mesaj, BEYAZ);
    }
    else
    {
    format(mesaj, sizeof(mesaj), "(( [%d]%s: %s ))", playerid, Oyuncuadi(playerid), mesaj);
    ProxDetector(15.0, playerid, mesaj, BEYAZ);
    }
	return 1;
}
// 2 sistemde çok az hatalý ileride açýlýr.
CMD:cw(playerid, params[])
{
    if(isnull(params) || strlen(params) > 256)return
        YollaKullanMesaj(playerid, "/cw [yazý]");

    new vehicleid = GetPlayerVehicleID(playerid);
    new string[256];

    if(!vehicleid)return
        YollaHataMesaj(playerid, "Bir aracýn içerisinde deðilsin.");

    format(string, sizeof(string), "[Araç içi] %s sessizce: %s", Oyuncuadi(playerid), params);
    printf(string);

    foreach(new i : Player)
    {
        if(!IsPlayerConnected(i) || !Oyuncu[i][Oyunda])continue;
        if(GetPlayerVehicleID(i) != vehicleid)continue;

        SendClientMessage(i, RENK_SARI3, string);
    }

    return 1;
}
CMD:cb(playerid, params[])
{
    if(isnull(params) || strlen(params) > 256)return
        YollaKullanMesaj(playerid, "/cb [yazý]");

    new vehicleid = GetPlayerVehicleID(playerid);
    new string[256];

    if(!vehicleid)return
        YollaHataMesaj(playerid, "Bir aracýn içerisinde deðilsin.");

    format(string, sizeof(string), "[OOC] %s: %s", Oyuncuadi(playerid), params);
    printf(string);

    foreach(new i : Player)
    {
        if(!IsPlayerConnected(i) || !Oyuncu[i][Oyunda])continue;
        if(GetPlayerVehicleID(i) != vehicleid)continue;

        SendClientMessage(i, RENK_SARI3, string);
    }

    return 1;
}

CMD:kilit(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");
	if(Oyuncu[playerid][Suspect] == true)
		return YollaHataMesaj(playerid, "Bu aracýn anahtarýna sahip deðilsin!");

	new aracid = GetClosestVehicle(playerid, 4.0), doorsss;
	if(aracid == SuspectArac[0] || aracid == SuspectArac[1])
		return YollaHataMesaj(playerid, "Bu aracý kilitleyemezsin.");

	if(AracKilitSahip[aracid] != playerid)
	{
		if(!IsPlayerInAnyVehicle(playerid))
			return YollaHataMesaj(playerid, "Araçta deðilsin.");
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
			return YollaHataMesaj(playerid, "Sürücü koltuðunda deðilsin.");

		GetVehicleParamsEx(aracid, engine2, lights2, alarm2, doorsss, bonnet2, boot2, objective2);
		if(doorsss == VEHICLE_PARAMS_OFF)
		{
			AracKilitSahip[aracid] = playerid;
			GameTextForPlayer(playerid, "~r~ARAC KILITLENDI!", 2000, 4);
			SetVehicleParamsEx(aracid, engine2, lights2, alarm2, VEHICLE_PARAMS_ON, bonnet2, boot2, objective2);
		}
		if(doorsss == VEHICLE_PARAMS_ON)
		{
			GameTextForPlayer(playerid, "~g~KILIT ACILDI!", 2000, 4);
			SetVehicleParamsEx(aracid, engine2, lights2, alarm2, VEHICLE_PARAMS_OFF, bonnet2, boot2, objective2);
		}
		return 1;
	}
	else if(AracKilitSahip[aracid] == playerid)
	{
		GetVehicleParamsEx(aracid, engine2, lights2, alarm2, doorsss, bonnet2, boot2, objective2);
		if(doorsss == VEHICLE_PARAMS_OFF)
		{
			AracKilitSahip[aracid] = playerid;
			GameTextForPlayer(playerid, "~r~ARAC KILITLENDI!", 2000, 4);
			SetVehicleParamsEx(aracid, engine2, lights2, alarm2, VEHICLE_PARAMS_ON, bonnet2, boot2, objective2);
		}
		if(doorsss == VEHICLE_PARAMS_ON)
		{
			GameTextForPlayer(playerid, "~g~KILIT ACILDI!", 2000, 4);
			SetVehicleParamsEx(aracid, engine2, lights2, alarm2, VEHICLE_PARAMS_OFF, bonnet2, boot2, objective2);
		}
	}
	return 1;
}

CMD:motor(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");
	if(!IsPlayerInAnyVehicle(playerid))
		return YollaHataMesaj(playerid, "Araçta deðilsin.");
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return YollaHataMesaj(playerid, "Sürücü koltuðunda deðilsin.");

	new aracid = GetPlayerVehicleID(playerid);
	if(AracHasar[aracid] == true)
		return YollaHataMesaj(playerid, "Bu aracýn motoru hasarlý!");
	GetVehicleParamsEx(aracid, engine2, lights2, alarm2, doors2, bonnet2, boot2, objective2);
	if(engine2 == VEHICLE_PARAMS_ON)
	{
	    new eylem[150];
		GameTextForPlayer(playerid, "~r~MOTOR DURDURULDU!", 2000, 4);
		SetVehicleParamsEx(aracid, VEHICLE_PARAMS_OFF, lights2, alarm2, doors2, bonnet2, boot2, objective2);
	 	format(eylem, sizeof(eylem), "* %s aracýn motorunu durdurur.", Oyuncuadi(playerid), eylem);
    	ProxDetector(15.0, playerid, eylem, EMOTE_RENK);
	}
	if(engine2 == VEHICLE_PARAMS_OFF)
	{
		new eylem[150];
		GameTextForPlayer(playerid, "~g~MOTOR CALISTIRILDI!", 2000, 4);
		SetVehicleParamsEx(aracid, VEHICLE_PARAMS_ON, lights2, alarm2, doors2, bonnet2, boot2, objective2);
		format(eylem, sizeof(eylem), "* %s aracýn motorunu çalýþtýrýr.", Oyuncuadi(playerid), eylem);
    	ProxDetector(15.0, playerid, eylem, EMOTE_RENK);
	}
	return 1;
}

CMD:bsilahal(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");
	if(Oyuncu[playerid][Polis] == false)
		return YollaHataMesaj(playerid, "Polis deðilsin.");
	if(Oyuncu[playerid][OyunSilah] == true)
		return YollaHataMesaj(playerid, "Henüz silahlar verilmedi!");
	if(IsPlayerInAnyVehicle(playerid))
		return YollaHataMesaj(playerid, "Araçta bu komutu kullanamazsýn.");

	new aracid = GetClosestVehicle(playerid, 5.0);
	if(aracid <= 0)
		return YollaHataMesaj(playerid, "Araç kaputuna yakýn deðilsin.");
	if(aracid == 16)
		return YollaHataMesaj(playerid, "Polis aracýna yakýn deðilsin.");

	GetVehicleParamsEx(aracid, engine2, lights2, alarm2, doors2, bonnet2, boot2, objective2);
	if(boot2 == VEHICLE_PARAMS_OFF)
	{
        ShowPlayerDialog(playerid, DIALOG_BSILAHAL, DIALOG_STYLE_LIST, "Bagaj", "Shotgun [70 SKOR]\nMP5 [140 SKOR]\nRifle [210 SKOR]\nM4 [360 SKOR]\nSniper Rifle [DONATOR + 950 SKOR]", "Seç", "Kapat");
		SetVehicleParamsEx(aracid, engine2, lights2, alarm2, doors2, bonnet2, VEHICLE_PARAMS_ON, objective2);
	}
	if(boot2 == VEHICLE_PARAMS_ON)
	{
		SetVehicleParamsEx(aracid, engine2, lights2, alarm2, doors2, bonnet2, VEHICLE_PARAMS_OFF, objective2);
	}
	return 1;
}

CMD:camac(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");
	if(!IsPlayerInAnyVehicle(playerid))
		return YollaHataMesaj(playerid, "Araçta deðilsin.");
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return YollaHataMesaj(playerid, "Sürücü koltuðunda deðilsin.");

	new eylem[120];
	format(eylem, sizeof(eylem), "* %s, arabanýn bütün camlarýný açar.", Oyuncuadi(playerid));
	ProxDetector(15.0, playerid, eylem, EMOTE_RENK);
	SetVehicleParamsCarWindows(GetPlayerVehicleID(playerid), VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF);
	return 1;
}

CMD:camkapat(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");
	if(!IsPlayerInAnyVehicle(playerid))
		return YollaHataMesaj(playerid, "Araçta deðilsin.");
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		return YollaHataMesaj(playerid, "Sürücü koltuðunda deðilsin.");

	new eylem[120];
	format(eylem, sizeof(eylem), "* %s, arabanýn bütün camlarýný kapatýr.", Oyuncuadi(playerid));
	ProxDetector(15.0, playerid, eylem, EMOTE_RENK);
	SetVehicleParamsCarWindows(GetPlayerVehicleID(playerid), VEHICLE_PARAMS_ON, VEHICLE_PARAMS_ON, VEHICLE_PARAMS_ON, VEHICLE_PARAMS_ON);
	return 1;
}

CMD:m(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");
	if(Oyuncu[playerid][Polis] == false)
		return YollaHataMesaj(playerid, "Polis deðilsin.");
	if(!IsPlayerInAnyVehicle(playerid))
		return YollaHataMesaj(playerid, "Araçta deðilsin.");

	new mesaj[150];
    if(sscanf(params, "s[150]", mesaj))
    	return YollaKullanMesaj(playerid, "/m [mesaj]");

    format(mesaj, sizeof(mesaj), "[MEGAFON] %s: %s", Oyuncuadi(playerid), mesaj);
    ProxDetector(40.0, playerid, mesaj, SARI);
	return 1;
}

CMD:m1(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");
	if(Oyuncu[playerid][Polis] == false)
		return YollaHataMesaj(playerid, "Polis deðilsin.");
	if(!IsPlayerInAnyVehicle(playerid))
		return YollaHataMesaj(playerid, "Araçta deðilsin.");

	new mesaj[150], Float: mpos[3];
	GetPlayerPos(playerid, mpos[0], mpos[1], mpos[2]);
    format(mesaj, sizeof(mesaj), "[MEGAFON] %s: Los Santos Polis Departmaný, olduðun yerde kal!", Oyuncuadi(playerid));
    ProxDetector(40.0, playerid, mesaj, SARI);
    PlaySoundEx(15800, mpos[0], mpos[1], mpos[2], 35);
	return 1;
}

CMD:m2(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");
	if(Oyuncu[playerid][Polis] == false)
		return YollaHataMesaj(playerid, "Polis deðilsin.");
	if(!IsPlayerInAnyVehicle(playerid))
		return YollaHataMesaj(playerid, "Araçta deðilsin.");

	new mesaj[150], Float: mpos[3];
	GetPlayerPos(playerid, mpos[0], mpos[1], mpos[2]);
    format(mesaj, sizeof(mesaj), "[MEGAFON] %s: Teslim ol, etrafýn sarýldý!", Oyuncuadi(playerid));
    ProxDetector(40.0, playerid, mesaj, SARI);
    PlaySoundEx(9605, mpos[0], mpos[1], mpos[2], 35);
	return 1;
}
CMD:o(playerid, params[])return pc_cmd_ooc(playerid,params);
CMD:ooc(playerid, params[])
{
	if(Oyuncu[playerid][HapisDakika] >= 1)
		return YollaHataMesaj(playerid, "Hapiste bu kanalý kullanamazsýnýz.");

	if(Oyuncu[playerid][Oyunda] == true && Oyuncu[playerid][SusturDakika] >= 1)
		return YollaHataMesaj(playerid, "Susturulduðun için konuþamazsýn, susturmanýn bitmesine %d kaldý.", Oyuncu[playerid][SusturDakika]);

	if(Oyuncu[playerid][Oyunda] == false && Oyuncu[playerid][SusturDakika] >= 1)
		return YollaHataMesaj(playerid, "Susturulduðun için konuþamazsýn, susturmanýn bitmesine %d kaldý.", Oyuncu[playerid][SusturDakika]);

	if(Fdurum == false)
		return YollaHataMesaj(playerid, "/ooc kanal bir yetkili tarafýndan devre dýþý býrakýlmýþ.");

	new mesaj[150];
    if(sscanf(params, "s[150]", mesaj))
    	return YollaKullanMesaj(playerid, "/ooc [mesajýnýz]");

    format(mesaj, sizeof(mesaj), "[OOC] "#BEYAZ2"%s(%d): %s", Oyuncuadi(playerid), playerid, mesaj);
    YollaHerkeseMesaj(RENK_YARALI, mesaj);
	return 1;
}

CMD:oockapat(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 3)
		return 1;
	if(Fdurum == true)
	{
		Fdurum = false;
		YollaHerkeseMesaj(RENK_YARALI, "AdmCmd: /ooc kanal yönetici tarafýndan devre dýþý býrakýldý.");
		return 1;
	}
	else if(Fdurum == false)
	{
		Fdurum = true;
		YollaHerkeseMesaj(RENK_YARALI, "AdmCmd: /ooc kanal yönetici tarafýndan aktif hale getirildi.");
		return 1;
	}
	return 1;
}

CMD:w(playerid, params[])
{
	if(Oyuncu[playerid][HapisDakika] >= 1)
		return YollaHataMesaj(playerid, "Hapiste bu kanalý kullanamazsýnýz.");
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");

	new hedefid, mesaj[150];
    if(sscanf(params, "us[150]", hedefid, mesaj))
    	return YollaKullanMesaj(playerid, "/w [hedef adý/ID] [mesaj]");
   	if(!IsPlayerConnected(hedefid))
   		return OyundaDegilMesaj(playerid);
	if(OyuncuYakinMesafe(playerid, hedefid) >= 3.5)
		return YollaHataMesaj(playerid, "Bu oyuncu yanýnda deðil.");
	if(playerid == hedefid)
		return YollaHataMesaj(playerid, "Kendine fýsýldayamazsýn.");

    YollaFormatMesaj(hedefid, SARI, "%s adlý kiþi sana fýsýldadý: %s", Oyuncuadi(playerid), mesaj);
    YollaFormatMesaj(playerid, SARI, "%s adlý kiþiye fýsýldadýn: %s", Oyuncuadi(hedefid), mesaj);
	return 1;
}

CMD:tamir(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");
	if(IsPlayerInAnyVehicle(playerid))
		return YollaHataMesaj(playerid, "Araçta bu komutu kullanamazsýn.");
	if(Oyuncu[playerid][AracTamir] == true)
		return YollaHataMesaj(playerid, "Daha fazla tamir kitiniz bulunmuyor.");

	new aracid = GetClosestVehicle(playerid, 4.0);
	if(aracid <= 0)
		return YollaHataMesaj(playerid, "Araç kaputuna yakýn deðilsin.");

	new Panels, Doors, Lights, Tires, Float: araccan;
	GetVehicleDamageStatus(aracid, Panels, Doors, Lights, Tires);
	GetVehicleHealth(aracid, araccan);
	if(Tires == 0 && araccan >= 851.0)
		return YollaHataMesaj(playerid, "Bu araç hasarlý deðil!");

	SetTimerEx("AracTamirEt", TIMER_SANIYE(13), false, "dd", playerid, aracid);
	Oyuncu[playerid][AracTamir] = true;
	GameTextForPlayer(playerid, "~w~ARACINIZI TAMIR EDIYORSUNUZ..", 13000, 4);
	GetVehicleParamsEx(aracid, engine2, lights2, alarm2, doors2, bonnet2, boot2, objective2);
	SetVehicleParamsEx(aracid, engine2, lights2, alarm2, doors2, VEHICLE_PARAMS_ON, boot2, objective2);
	TogglePlayerControllable(playerid, 0);
	new eylem[120];
	format(eylem, sizeof(eylem), "* %s aracýn kaputunu açar ve tamir etmeye çalýþýr.", Oyuncuadi(playerid));
	ProxDetector(15.0, playerid, eylem, EMOTE_RENK);
	return 1;
}

CMD:koni(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");
	if(Oyuncu[playerid][Polis] == false)
		return YollaHataMesaj(playerid, "Polis deðilsin.");
	if(IsPlayerInAnyVehicle(playerid))
		return YollaHataMesaj(playerid, "Araçta bu komutu kullanamazsýn.");
	if(Oyuncu[playerid][EngelHak] >= 5)
		return YollaHataMesaj(playerid, "Daha fazla engel yerleþtiremezsin.");
    if(Oyuncu[playerid][Skor] < 150)
	    return YollaHataMesaj (playerid, "Skorun yeterli deðil.");
	new engelid, mesaj[140];
	for(new i = 1; i < MAX_ENGEL; ++i)
	{
		if(Engel[i][Olusturuldu] == true)
			continue;
		engelid = i;
		break;
	}
	Oyuncu[playerid][EngelHak]++;
	format(mesaj, sizeof(mesaj), "(Engel ID: %d) - (Oluþturan: %s)", engelid, Oyuncuadi(playerid));
    GetPlayerPos(playerid, Engel[engelid][Pos][0], Engel[engelid][Pos][1], Engel[engelid][Pos][2]);
	Engel[engelid][Olusturuldu] = true;
	Engel[engelid][Duzenleniyor] = false;
    Engel[engelid][Model] = 1238;
    Engel[engelid][SahipID] = playerid;
    Engel[engelid][Tip] = 0;
    Engel[engelid][ID] = CreateDynamicObject(1238, Engel[engelid][Pos][0], Engel[engelid][Pos][1], Engel[engelid][Pos][2]-0.7, 0.0, 0.0, 0.0);
	Engel[engelid][Engel3D] = CreateDynamic3DTextLabel(mesaj, RENK_YARALI, Engel[engelid][Pos][0], Engel[engelid][Pos][1], Engel[engelid][Pos][2], 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID);
	YollaIpucuMesaj(playerid, "Koniyi yerleþtirdiniz.");
	return 1;
}

CMD:civi(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");
	if(Oyuncu[playerid][Polis] == false)
		return YollaHataMesaj(playerid, "Polis deðilsin.");
	if(IsPlayerInAnyVehicle(playerid))
		return YollaHataMesaj(playerid, "Araçta bu komutu kullanamazsýn.");
	if(Oyuncu[playerid][EngelHak] >= 5)
		return YollaHataMesaj(playerid, "Daha fazla engel yerleþtiremezsin.");
	if(Oyuncu[playerid][Skor] < 150)
	    return YollaHataMesaj (playerid, "Skorun yeterli deðil.");
	new engelid, mesaj[140];
	for(new i = 1; i < MAX_ENGEL; ++i)
	{
		if(Engel[i][Olusturuldu] == true)
			continue;
		engelid = i;
		break;
	}
	Oyuncu[playerid][EngelHak]++;
	format(mesaj, sizeof(mesaj), "(Engel ID: %d) - (Oluþturan: %s)", engelid, Oyuncuadi(playerid));
    GetPlayerPos(playerid, Engel[engelid][Pos][0], Engel[engelid][Pos][1], Engel[engelid][Pos][2]);
	Engel[engelid][Olusturuldu] = true;
	Engel[engelid][Duzenleniyor] = false;
    Engel[engelid][Model] = 1238;
    Engel[engelid][SahipID] = playerid;
    Engel[engelid][Tip] = 1;
    Engel[engelid][AreaID] = CreateDynamicRectangle(Engel[engelid][Pos][0]+2, Engel[engelid][Pos][1]+2, Engel[engelid][Pos][0]-2, Engel[engelid][Pos][1]-2);
    Engel[engelid][ID] = CreateDynamicObject(2899, Engel[engelid][Pos][0], Engel[engelid][Pos][1], Engel[engelid][Pos][2]-0.9, 0.0, 0.0, 0.0);
	Engel[engelid][Engel3D] = CreateDynamic3DTextLabel(mesaj, RENK_YARALI, Engel[engelid][Pos][0], Engel[engelid][Pos][1], Engel[engelid][Pos][2], 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID);
	YollaIpucuMesaj(playerid, "Çiviyi yerleþtirdiniz.");
	return 1;
}

CMD:engelpos(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");
	if(Oyuncu[playerid][Polis] == false)
		return YollaHataMesaj(playerid, "Polis deðilsin.");
	if(IsPlayerInAnyVehicle(playerid))
		return YollaHataMesaj(playerid, "Araçta bu komutu kullanamazsýn.");
	if(Oyuncu[playerid][DuzenleEngel] == true)
		return YollaHataMesaj(playerid, "Engel düzenlemeyi bitirin.");

	Oyuncu[playerid][EngelSec] = 1;
	YollaIpucuMesaj(playerid, "Düzenlemek istediðiniz engeli seçin.");
	SelectObject(playerid);
	return 1;
}

CMD:engelsil(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");
	if(Oyuncu[playerid][Polis] == false)
		return YollaHataMesaj(playerid, "Polis deðilsin.");
	if(IsPlayerInAnyVehicle(playerid))
		return YollaHataMesaj(playerid, "Araçta bu komutu kullanamazsýn.");
	if(Oyuncu[playerid][DuzenleEngel] == true)
		return YollaHataMesaj(playerid, "Engel düzenlemeyi bitirin.");

	Oyuncu[playerid][EngelSec] = 2;
	YollaIpucuMesaj(playerid, "Kaldýrmak istediðiniz engeli seçin.");
	SelectObject(playerid);
	return 1;
}

CMD:engelsifirla(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 2)
		return 1;
	for(new i = 1; i < MAX_ENGEL; ++i)
	{
		if(Engel[i][Olusturuldu] == true)
		{
			DestroyDynamicObject(Engel[i][ID]);
			DestroyDynamic3DTextLabel(Engel[i][Engel3D]);
			if(IsValidDynamicArea(Engel[i][AreaID]))
				DestroyDynamicArea(Engel[i][AreaID]);
			Engel[i][Engel3D] = Text3D: INVALID_3DTEXT_ID;
			Engel[i][Pos][0] = Engel[i][Pos][1] = Engel[i][Pos][2] = 0.0;
			Engel[i][Duzenleniyor] = false;
			Engel[i][SahipID] = -1;
			Engel[i][Olusturuldu] = false;
		}
	}
	YollaHerkeseMesaj(RENK_YARALI, "AdmCmd: Bir yönetici tarafýndan oyun içerisinde bulunan bütün engeller silindi.");
	return 1;
}

CMD:siren(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == true)
		return 1;
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");
	if(Oyuncu[playerid][Polis] == false)
		return YollaHataMesaj(playerid, "Polis deðilsin.");
	if(!IsPlayerInAnyVehicle(playerid))
		return YollaHataMesaj(playerid, "Araçta deðilsin.");

	new aracid = GetPlayerVehicleID(playerid);
	if(aracid == 16) return YollaHataMesaj(playerid, "Polis aracýnda deðilsin.");
	if(AracSirenDurumu[aracid] == false)
	{
		AracSirenDurumu[aracid] = true;
	    AracSiren[aracid] = CreateDynamicObject(18646, 10.0, 10.0, 10.0, 0.0, 0.0, 0.0);
		AttachDynamicObjectToVehicle(AracSiren[aracid], aracid, -0.43, 0.0, 0.785, 0.0, 0.1, 0.0);
		YollaIpucuMesaj(playerid, "Aracýnýza siren eklediniz.");
		return 1;
	}
	if(AracSirenDurumu[aracid] == true)
	{
		AracSirenDurumu[aracid] = false;
	  	DestroyDynamicObject(AracSiren[aracid]);
		YollaIpucuMesaj(playerid, "Aracýnýzdan sireni kaldýrdýnýz.");
		return 1;
	}
	return 1;
}

CMD:taser(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");
	if(Oyuncu[playerid][Polis] == false)
		return YollaHataMesaj(playerid, "Polis deðilsin.");
	if(IsPlayerInAnyVehicle(playerid))
		return YollaHataMesaj(playerid, "Araçta bu komutu kullanamazsýn.");
	if(Oyuncu[playerid][OyunSilah] == true)
		return YollaHataMesaj(playerid, "Henüz silahlar verilmedi.");
	if(Oyuncu[playerid][TaserMermiDegis] == true)
		return YollaHataMesaj(playerid, "Kartuþ yükleniyor.");

	new eylem[120];
	if(Oyuncu[playerid][Taser] == true)
	{
		Oyuncu[playerid][Taser] = false;
		SetPlayerAmmo(playerid, 23, 0);
		GivePlayerWeapon(playerid, 24, 300);
		format(eylem, sizeof(eylem), "* %s þok tabancasýný kýlýfýna koyar.", Oyuncuadi(playerid));
		ProxDetector(15.0, playerid, eylem, EMOTE_RENK);
		return 1;
	}
	if(Oyuncu[playerid][Taser] == false)
	{
		Oyuncu[playerid][Taser] = true;
		GivePlayerWeapon(playerid, 23, 1);
		format(eylem, sizeof(eylem), "* %s þok tabancasýný kýlýfýndan çýkarýr.", Oyuncuadi(playerid));
		ProxDetector(15.0, playerid, eylem, EMOTE_RENK);
		return 1;
	}
	return 1;
}

CMD:beanbag(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");
	if(Oyuncu[playerid][Polis] == false)
		return YollaHataMesaj(playerid, "Polis deðilsin.");
	if(!IsPlayerInAnyVehicle(playerid))
		return YollaHataMesaj(playerid, "Araçta deðilsin.");
	if(Oyuncu[playerid][OyunSilah] == true)
		return YollaHataMesaj(playerid, "Henüz silahlar verilmedi.");

	new eylem[120];
	if(Oyuncu[playerid][Beanbag] == true)
	{
		Oyuncu[playerid][Beanbag] = false;
		SetPlayerAmmo(playerid, 25, 0);
		format(eylem, sizeof(eylem), "* %s, elinde bulunan beanbag'i tekrardan orta panele yerleþtirir.", Oyuncuadi(playerid));
		ProxDetector(15.0, playerid, eylem, EMOTE_RENK);
		return 1;
	}
	if(Oyuncu[playerid][Beanbag] == false)
	{
		Oyuncu[playerid][Beanbag] = true;
		GivePlayerWeapon(playerid, 25, 50);
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
			SetPlayerArmedWeapon(playerid, 0);
		format(eylem, sizeof(eylem), "* %s, aracýn orta panelinden beanbag'i kavrar.", Oyuncuadi(playerid));
		ProxDetector(15.0, playerid, eylem, EMOTE_RENK);
		return 1;
	}
	return 1;
}

CMD:kelepce(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");
	if(Oyuncu[playerid][Polis] == false)
		return YollaHataMesaj(playerid, "Polis deðilsin.");
	if(IsPlayerInAnyVehicle(playerid))
		return YollaHataMesaj(playerid, "Araçta bu komutu kullanamazsýn.");

	new hedefid;
    if(sscanf(params, "u", hedefid))
    	return YollaKullanMesaj(playerid, "/kelepce [hedef adý/ID]");

    if(Oyuncu[hedefid][Polis] == true)
    	return 1;

    if(GetPlayerSpecialAction(hedefid) == SPECIAL_ACTION_HANDSUP || Oyuncu[hedefid][Taserlendi] == true || Oyuncu[hedefid][Beanbaglendi] == true)
    {
    	new eylem[150];
    	format(eylem, sizeof(eylem), "* %s, teçhizat kemerinden kelepçesini kavrar ve %s kiþisinin bileklerine geçirir.", Oyuncuadi(playerid), Oyuncuadi(hedefid));
    	TogglePlayerControllable(hedefid, 0);
    	Oyuncu[hedefid][Suspect] = false;
    	SetPlayerSpecialAction(hedefid, SPECIAL_ACTION_CUFFED);
    	ProxDetector(10.0, playerid, eylem, EMOTE_RENK);
    	SetTimer("OyunKontrol", TIMER_SANIYE(5), false);
    	LobiyeDon(hedefid);
    	return 1;
    }
	return 1;
}

CMD:dm(playerid, params[])
{
	if(Oyuncu[playerid][HapisDakika] >= 1)
		return YollaHataMesaj(playerid, "Hapisteyken bu komutu kullanamazsýn.");

	if(Oyuncu[playerid][Oyunda] == true)
		return YollaHataMesaj(playerid, "Oyunda bu komutu kullanamazsýn.");

	if(Oyuncu[playerid][DM] == true)
		return YollaHataMesaj(playerid, "Zaten DM lobisindesin.");

	if(Dmizin == true)
	    return YollaHataMesaj(playerid, "DM lobisi bir yetkili tarafýndan kapatýlmýþ.");

	if(OyunSaniye <= 10 && OyunBasladi == false)
		return YollaIpucuMesaj(playerid, "Oyun birazdan baþlayacak.");

	ShowDM_List(playerid);
	return 1;
}

forward ShowDM_List(playerid);
public ShowDM_List(playerid)
{
	new lvpd = 0, lco = 0, mt = 0, rcb = 0;
	foreach(new i : Player)
	{
		if(Oyuncu[i][DM] == false)
			break;

		if(Oyuncu[i][DMLobi] == 1)
				lvpd++;
	}

	foreach(new i : Player)
	{
		if(Oyuncu[i][DM] == false)
			break;

		if(Oyuncu[i][DMLobi] == 2)
				lco++;
	}

	foreach(new i : Player)
	{
		if(Oyuncu[i][DM] == false)
			break;

		if(Oyuncu[i][DMLobi] == 3)
				mt++;
	}

	foreach(new i : Player)
	{
		if(Oyuncu[i][DM] == false)
			break;

		if(Oyuncu[i][DMLobi] == 4)
				rcb++;
	}

	new lobby_text[256];
	format(lobby_text, sizeof(lobby_text), "Lobiler\tLimit\n" "Las Venturas Police Department\t%d/10\nLiberty City Outside\t%d/10\nMeat Factory\t%d/10\nRC Battlefield\t%d/10", lvpd, lco, mt, rcb);

	ShowPlayerDialog(playerid, DIALOG_DMLOBI, DIALOG_STYLE_TABLIST_HEADERS, "Deathmatch(DM)", lobby_text, "Seç", "Kapat");
	return 1;
}

CMD:oyun(playerid, params[])
{
	if(OyunBasladi == false)
		return YollaHataMesaj(playerid, "Aktif oyun yok.");
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");
	new tip[40];
	if(OyunModuTip == 0)
		format(tip, 40, "Event");
	if(OyunModuTip == 1)
		format(tip, 40, "Non-RP");
	if(OyunModuTip == 2)
		format(tip, 40, "Roleplay");
	YollaIpucuMesaj(playerid, "Oyun modu %s olarak seçilmiþtir.", tip);
	if(OyunModuTip != 0)
		YollaIpucuMesaj(playerid, "%s", OyunSebep);
	return 1;
}

CMD:istatistik(playerid, params[])
{
	YollaIpucuMesaj(playerid, ""#YARALI"Öldürdüðü kiþi sayýsý: %d", Oyuncu[playerid][Oldurme]);
	YollaIpucuMesaj(playerid, ""#YARALI"Öldürülme sayýsý: %d", Oyuncu[playerid][Olum]);
	YollaIpucuMesaj(playerid, ""#YARALI"Suspect kazaným sayýsý: %d", Oyuncu[playerid][SuspectKazanma]);
	return 1;
}

CMD:hesap(playerid, params[])
{
	YollaFormatMesaj(playerid, -1, "{2D962D}HESAP:"#BEYAZ2" Ýsim[%s] ID[%d] Skor[%d]", Oyuncuadi(playerid), playerid, Oyuncu[playerid][Skor]);
	YollaFormatMesaj(playerid, -1, "{2D962D}Ýstatistik:"#BEYAZ2" Þüpheli Kazanma[%d] DM Öldürme[%d] DM Ölüm[%d]", Oyuncu[playerid][SuspectKazanma], Oyuncu[playerid][Oldurme], Oyuncu[playerid][Olum]); //Oyuncu[playerid][Skor]
    if(Oyuncu[playerid][Yonetici] >= 1)
	{
		YollaFormatMesaj(playerid, -1, "{2D962D}Yetki:"#BEYAZ2" %s", YoneticiYetkiAdi(Oyuncu[playerid][Yonetici]));
	}
	if(Oyuncu[playerid][Helper] == true)
	{
		YollaFormatMesaj(playerid, -1, "{2D962D}Supporter:"#SARI2" 1 seviye");
	}
	if(Oyuncu[playerid][Donator] == true)
	{
		YollaFormatMesaj(playerid, -1, "{2D962D}Donator:"#BEYAZ2" Donator yetkiniz bulunmakta. ", Oyuncu[playerid][SuspectKazanma], Oyuncu[playerid][Skor]);
	}
	return 1;
}



CMD:aduty(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] == 0) return 1;

	if(Oyuncu[playerid][aduty] == true)
	{
		Oyuncu[playerid][aduty] = false;
		SetPlayerHealth(playerid, 100.0);
		YollaYoneticiMesaj(1, RENK_YARALI, "AdmCmd: %s admin görevinden çýktý.", Oyuncuadi(playerid));
		return 1;
	}
	if(Oyuncu[playerid][aduty] == false)
	{
		Oyuncu[playerid][aduty] = true;
		SetPlayerHealth(playerid, 999999999999999999.0);
		SetPlayerArmour(playerid, 999999999999999999.0);
		YollaYoneticiMesaj(1, RENK_YARALI, "AdmCmd: %s admin görevinde.", Oyuncuadi(playerid));
		return 1;
	}
	return 1;

}

CMD:aooc(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 1)
		return 1;

	new mesaj[150];
	if(sscanf(params, "s[150]", mesaj))
		return YollaKullanMesaj(playerid, "/aooc [mesaj]");

	YollaHerkeseMesaj(COLOR_LIGHTRED, "(AdmMsg) "#YARALI"%s: "#BEYAZ2"%s", Oyuncuadi(playerid), mesaj); //YoneticiYetkiAdi(Oyuncu[playerid][Yonetici]),
	return 1;
}

CMD:gmx(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 4)
		return 1;

	YollaHerkeseMesaj(RENK_YARALI, "AdmCmd: %s adlý yönetici tarafýndan sunucu yeniden baþlatýlýyor.", Oyuncuadi(playerid));
	SendRconCommand("gmx");

	return 1;
}

CMD:mp3(playerid, params[])
{
	if(Oyuncu[playerid][HapisDakika] >= 1)
		return YollaHataMesaj(playerid, "Hapisteyken bu komutu kullanamazsýn.");
	YollaIpucuMesaj(playerid, "Dinlemek istediðiniz kanalý buradan seçebilirsiniz.");
    ShowPlayerDialog(playerid, DIALOG_MP3, DIALOG_STYLE_LIST, "S-PP - RADYO", "Radyo Fenomen\nFenomen RAP\nFenomen Türk\nFenomen Akustik\nFenomen Pop\nPowertürk FM\nYayýný durdur.", "Seç", "Kapat");

	return 1;
}

CMD:op(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");
	if(Oyuncu[playerid][Polis] == false)
		return YollaHataMesaj(playerid, "Polis deðilsin.");
	if(Oyuncu[playerid][Skor] < 450)
	    return YollaHataMesaj(playerid, "Skorun yeterli deðil.");

	new mesaj[150];
    if(sscanf(params, "s[150]", mesaj))
    	return YollaKullanMesaj(playerid, "/op(erator) [mesaj]");

	format(mesaj, sizeof(mesaj), "[OPERATOR] (%s) %s: %s", PolisRutbe(playerid), Oyuncuadi(playerid), mesaj);
	PolisTelsiz(mesaj);
	return 1;
}

CMD:gov(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");
	if(Oyuncu[playerid][Polis] == false)
		return YollaHataMesaj(playerid, "Polis deðilsin.");
	if(Oyuncu[playerid][Skor] < 700)
	    return YollaHataMesaj(playerid, "Skorun yeterli deðil.");

	new mesaj[150];
    if(sscanf(params, "s[150]", mesaj))
    	return YollaKullanMesaj(playerid, "/gov(erment) [mesaj]");

	format(mesaj, sizeof(mesaj), ""#SARI2"[STATE]"#BEYAZ2" %s: %s", Oyuncuadi(playerid), mesaj);
	PolisTelsiz(mesaj);
	return 1;
}

CMD:dmkilitle(playerid, params[])
{
    if(Oyuncu[playerid][Yonetici] < 2)
		return 1;

	if(Dmizin== true)
	{
		Dmizin = false;
		YollaIpucuMesaj(playerid, "DM lobilerini açtýn.");
		YollaHerkeseMesaj(RENK_YARALI, "AdmCmd: %s adlý yönetici DM lobilerini açtý.", Oyuncuadi(playerid));
		return 1;
	}
	if(Dmizin == false)
	{
		Dmizin = true;
		YollaIpucuMesaj(playerid, "DM lobilerini kilitledin.");
		YollaHerkeseMesaj(RENK_YARALI, "AdmCmd: %s adlý yetkili DM lobilerini kilitledi.", Oyuncuadi(playerid));
		return 1;
	}
	return 1;
}

CMD:lisans(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == false)
	    return YollaHataMesaj(playerid, "Oyunda deðilsin.");
    if(Oyuncu[playerid][Suspect] == false)
	    return YollaHataMesaj(playerid, "Þüpheli deðilsin.");

	new hedefid, eylem[150];
    if(sscanf(params, "u", hedefid))
    	return YollaKullanMesaj(playerid, "/lisans [OyuncuID]");

    if(playerid == hedefid) return YollaHataMesaj(playerid, "Kendine gösteremezsin.");

	format(eylem, sizeof(eylem), "* %s lisans belgesini çýkartýr ve %s'a gösterir.", Oyuncuadi(playerid), Oyuncuadi(hedefid));
	ProxDetector(15.0, playerid, eylem, EMOTE_RENK);
	YollaFormatMesaj(hedefid, -1, "[San Andreas Bakanlýðý Motorlu Taþýtlar Departmaný]");
	YollaFormatMesaj(hedefid, -1, "Ýsim: %s((%d)), Eyalet: Los Santos/San Andreas, Yenilenme Tarihi: "#KIRMIZI2"08.02.2019 "#BEYAZ2"Geçerlilik:"#KIRMIZI2" Pasif.", Oyuncuadi(playerid), playerid);

	return 1;
}

CMD:polisler(playerid, params[])
{
	if(OyunBasladi == false)
		return YollaHataMesaj(playerid, "Aktif oyun yok.");

	new aktifpolis = 0;
	foreach(new i : Player)
	{
		if(Oyuncu[i][Polis] == true)
		{
			YollaIpucuMesaj(playerid, ""#303F9F"(%s) - %s", PolisRutbe(i), Oyuncuadi(i));
			aktifpolis++;
        }
	}
	if(aktifpolis == 0)
		return YollaHataMesaj(playerid, "Çevrimiçi polis yok.");
	return 1;
}

CMD:scmds(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] >= 1 || Oyuncu[playerid][Helper] == true)
	{
	YollaFormatMesaj(playerid, COLOR_SUPPORTER, "[Supporters] /sc - /spawn - /uyari - /sorured - /scmds - /sorucevap");
	}
	return 1;
}

CMD:ame(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");
	new eylem[150];
    if(sscanf(params, "s[150]", eylem))
    	return YollaKullanMesaj(playerid, "/ame [eylem]");

    format(eylem, sizeof(eylem), "* %s %s", Oyuncuadi(playerid), eylem);
    SetPlayerChatBubble(playerid, eylem, EMOTE_RENK, 30.0, 10000);
    YollaFormatMesaj(EMOTE_RENK, playerid, "* %s", eylem);
	return 1;
}

CMD:asilahal(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");
	if(Oyuncu[playerid][Polis] == false)
		return YollaHataMesaj(playerid, "Polis deðilsin.");
	if(Oyuncu[playerid][OyunSilah] == true)
		return YollaHataMesaj(playerid, "Henüz silahlar verilmedi!");
	if(!IsPlayerInAnyVehicle(playerid))
		return YollaHataMesaj(playerid, "Bu komutu araçta kullanabilirsin.");
    ShowPlayerDialog(playerid, ASILAHAL, DIALOG_STYLE_LIST, "Araç Paneli", "M4A1 Carbine", "Al", "Ýptal");

	return 1;
}
CMD:swapseats(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");

	if(!IsPlayerInAnyVehicle(playerid))
		return YollaHataMesaj(playerid, "Araçta deðilsin.");

	new userid;
	if(sscanf(params, "d", userid))
		return YollaIpucuMesaj(playerid, "/swapseats [Oyuncu ID/Ýsmi]");

	if(userid == playerid)
		return YollaHataMesaj(playerid, "Bu komutu kendi üzerinde kullanamazsýn.");

	new pvehid = GetPlayerVehicleID(playerid);

	if(pvehid != GetPlayerVehicleID(userid))
		return YollaHataMesaj(playerid, "Belirtilen oyuncuyla ayný araçta deðilsiniz.");

	SetPVarInt(playerid, "changeseatAsk", userid);
	SetPVarInt(userid, "changeseatAsk", playerid);

	YollaIpucuMesaj(playerid, "{8F8F8F}%s adlý oyuncuya koltuk deðiþtirme isteði gönderildi.", Oyuncuadi(userid));
	YollaIpucuMesaj(userid, "{8F8F8F}%s adlý oyuncu size koltuk deðiþtirme isteði attý. (Kabul etmek için /changeseat y)", Oyuncuadi(playerid));
	return 1;
}

CMD:changeseat(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");

	if(!IsPlayerInAnyVehicle(playerid))
		return YollaHataMesaj(playerid, "Araçta deðilsin.");

	if(GetPVarInt(playerid, "changeseatAsk") == -1)
		return YollaHataMesaj(playerid, "Herhangi bir istek gelmemiþ.");

	new option[12];
	if(sscanf(params, "s[24]", option))
		return YollaIpucuMesaj(playerid, "/changesat [yes/no]");

	new uid = GetPVarInt(playerid, "changeseatAsk");

	if(GetPlayerVehicleID(playerid) != GetPlayerVehicleID(uid))
		return YollaHataMesaj(playerid, "Ýstek atan kiþiyel ayný araçta deðilsiniz.");

	if(!strcmp(params, "yes") || !strcmp(params, "y", true) || !strcmp(params, "evet", true) || !strcmp(params, "e", true))
	{
			new Float:pPos[3];
			GetPlayerPos(playerid, pPos[0], pPos[1], pPos[2]);
			SetPlayerPos(playerid, pPos[0], pPos[1], pPos[2]-3.5);
			SetPlayerPos(uid, pPos[0], pPos[1], pPos[2]-3.5);

			SetTimerEx("ChangeSeat", 200, false, "ddd", playerid, GetPlayerVehicleID(playerid), GetPlayerVehicleSeat(uid));
			SetTimerEx("ChangeSeat", 200, false, "ddd", uid, GetPlayerVehicleID(uid), GetPlayerVehicleSeat(playerid));
			SendClientMessage(playerid, YESIL, "Koltuk deðiþtirildi.");
			SendClientMessage(uid, YESIL, "Koltuk deðiþtirildi.");
			SetPVarInt(uid, "changeseatAsk", -1);
			SetPVarInt(playerid, "changeseatAsk", -1);
	}
	return 1;
}

forward ChangeSeat(id, vehid, seat);
public ChangeSeat(id, vehid, seat)
{
	PutPlayerInVehicle(id, vehid, seat);
	return 1;
}


//Duel sistemi
CMD:duel(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == true)
		return YollaHataMesaj(playerid, "Oyundayken bu komutu kullanamazsýn.");

	new hedefid, map, silahtip;
	if(sscanf(params, "udd", hedefid, map, silahtip))
	{
			YollaKullanMesaj(playerid, "/duel [oyuncu id] [map id] [silahlar]");
			YollaKullanMesaj(playerid, "Maplar: 1: Las Venturas Police Department, 2: Liberty City Outside, 3: Meat Factory 4: RC Battlefield");
			YollaKullanMesaj(playerid, "Olacak Silahlar: 1: Sadece Deagle _ 2: Sadece Shotgun _ 3: Deagle, Shotgun _ 4: Sadece M4 _ 5: M4, Deagle _ 6: Hepsi");
			return 1;
	}

	if(!IsPlayerConnected(hedefid))
		return OyundaDegilMesaj(playerid);

	if(hedefid == playerid)
		return YollaHataMesaj(playerid, "Bu komutu kendi üzerinde kullanamazsýn.");

	if(map < 1 || map > 4)
		return YollaHataMesaj(playerid, "Map seçenekleri 1 ve 4 arasýnda olmalýdýr.");

	if(silahtip < 1 || silahtip > 6)
		return YollaHataMesaj(playerid, "Silah seçenekleri 1 ve 6 arasýnda olmalýdýr.");

	if(Oyuncu[hedefid][Oyunda] == true)
		return YollaHataMesaj(playerid, "Hedef oyuncu þu anda oyunda.");

	SetPVarInt(hedefid, "LastDuelInvite", playerid);
	SetPVarInt(playerid, "LastDuelInvite", hedefid);
	SetPVarInt(playerid, "LastDuelInvite_Map", map);
	SetPVarInt(playerid, "LastDuelInvite_GunOption", silahtip);
	YollaIpucuMesaj(hedefid, ""GRI2"%s adlý oyuncu size duel isteði attý. Kabul etmek için /dkabul komutunu kullanabilirsin.", Oyuncuadi(playerid));
	YollaIpucuMesaj(playerid, ""GRI2"%s adlý oyuncuya duel isteði attýnýz. Kabul etmesini beklemelisin.", Oyuncuadi(hedefid));
	return 1;
}

CMD:dkabul(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == true)
		return YollaHataMesaj(playerid, "Oyundayken bu komutu kullanamazsýn.");

	if(Oyuncu[playerid][DM] == true)
		return YollaHataMesaj(playerid, "Lobide olmadan bu komutu kullanamazsýn.");

	if(Oyuncu[playerid][aktifduel] == true)
		return YollaHataMesaj(playerid, "Lobide olmadan bu komutu kullanamazsýn.");

	new invitedby = GetPVarInt(playerid, "LastDuelInvite");

	if(invitedby == -1)
		return YollaHataMesaj(playerid, "Herhangi bir duel teklifi gelmemiþ.");

	if(GetPVarInt(invitedby, "LastDuelInvite") != playerid)
		return YollaHataMesaj(playerid, "Herhangi bir duel teklifi gelmemiþ.");

	if(Oyuncu[invitedby][Oyunda] == true)
		return YollaHataMesaj(playerid, "Size duel teklifi atan kiþi lobide olmalý.");

	if(Oyuncu[invitedby][DM] == true)
		return YollaHataMesaj(playerid, "Size duel teklifi atan kiþi lobide olmalý.");

	YollaIpucuMesaj(invitedby, ""YESIL2"%s adlý oyuncu sizin duel isteðinizi kabul etti. Duel, 5 saniye sonra baþlayacak.", Oyuncuadi(playerid));
	YollaIpucuMesaj(playerid, ""YESIL2"%s adlý oyuncunun duel isteðini kabul ettiniz. Duel, 5 saniye sonra baþlayacak.", Oyuncuadi(invitedby));
	StartDuel(playerid, invitedby, GetPVarInt(invitedby, "LastDuelInvite_Map"), GetPVarInt(invitedby, "LastDuelInvite_GunOption"));
 	return 1;
}


forward StartDuel(player1, player2, map, gun_option);
public StartDuel(player1, player2, map, gun_option)
{
	ResetPlayerWeapons(player1), ResetPlayerWeapons(player2);

	Oyuncu[player1][aktifduel] = true;
	Oyuncu[player2][aktifduel] = true;

	Oyuncu[player2][DM] = false;
	Oyuncu[player1][DM] = false;

	Oyuncu[player2][Oyunda] = false;
	Oyuncu[player1][Oyunda] = false;

	SetPlayerHealth(player1, 100);
	SetPlayerArmour(player1, 0);

	SetPlayerHealth(player2, 100);
	SetPlayerArmour(player2, 0);

	if(gun_option == 1)
	{
		GivePlayerWeapon(player1, 24, 9999);
		GivePlayerWeapon(player2, 24, 9999);
	}

	if(gun_option == 2)
	{
		GivePlayerWeapon(player1, 25, 9999);
		GivePlayerWeapon(player2, 25, 9999);
	}

	if(gun_option == 3)
	{
		GivePlayerWeapon(player1, 24, 9999);
		GivePlayerWeapon(player2, 24, 9999);
		GivePlayerWeapon(player1, 25, 9999);
		GivePlayerWeapon(player2, 25, 9999);
	}
	if(gun_option == 4)
	{
		GivePlayerWeapon(player1, 31, 9999);
		GivePlayerWeapon(player2, 31, 9999);
	}
	if(gun_option == 5)
	{
		GivePlayerWeapon(player1, 31, 9999);
		GivePlayerWeapon(player2, 31, 9999);
		GivePlayerWeapon(player1, 24, 9999);
		GivePlayerWeapon(player2, 24, 9999);
	}
	if(gun_option == 6)
	{
		GivePlayerWeapon(player1, 31, 9999);
		GivePlayerWeapon(player2, 31, 9999);
		GivePlayerWeapon(player1, 24, 9999);
		GivePlayerWeapon(player2, 24, 9999);
		GivePlayerWeapon(player1, 25, 9999);
		GivePlayerWeapon(player2, 25, 9999);
	}

	if(map == 1)
	{
		new sayi = random(8);
		new sayi2 = random(8);
		sscanf(DMKonum(sayi), "p<,>fff", Oyuncu[player1][Pos][0], Oyuncu[player1][Pos][1], Oyuncu[player1][Pos][2]);
		SetPlayerPos(player1, Oyuncu[player1][Pos][0], Oyuncu[player1][Pos][1], Oyuncu[player1][Pos][2]);

		sscanf(DMKonum(sayi2), "p<,>fff", Oyuncu[player2][Pos][0], Oyuncu[player2][Pos][1], Oyuncu[player2][Pos][2]);
		SetPlayerPos(player2, Oyuncu[player2][Pos][0], Oyuncu[player2][Pos][1], Oyuncu[player2][Pos][2]);

		SetPlayerInterior(player1, 3);
		SetPlayerInterior(player2, 3);
		SetPlayerVirtualWorld(player1, 333+player1);
		SetPlayerVirtualWorld(player2, 333+player1);
	}

	if(map == 2)
	{
		new sayi = random(8);
				new sayi2 = random(8);
		sscanf(DMKonum2(sayi), "p<,>fff", Oyuncu[player1][Pos][0], Oyuncu[player1][Pos][1], Oyuncu[player1][Pos][2]);
		SetPlayerPos(player1, Oyuncu[player1][Pos][0], Oyuncu[player1][Pos][1], Oyuncu[player1][Pos][2]);

		sscanf(DMKonum2(sayi2), "p<,>fff", Oyuncu[player2][Pos][0], Oyuncu[player2][Pos][1], Oyuncu[player2][Pos][2]);
		SetPlayerPos(player2, Oyuncu[player2][Pos][0], Oyuncu[player2][Pos][1], Oyuncu[player2][Pos][2]);

		SetPlayerInterior(player1, 1);
		SetPlayerInterior(player2, 1);
		SetPlayerVirtualWorld(player1, 444+player1);
		SetPlayerVirtualWorld(player2, 444+player1);
	}

	if(map == 3)
	{
		new sayi = random(8);
		new sayi2 = random(8);
		sscanf(DMKonum3(sayi), "p<,>fff", Oyuncu[player1][Pos][0], Oyuncu[player1][Pos][1], Oyuncu[player1][Pos][2]);
		SetPlayerPos(player1, Oyuncu[player1][Pos][0], Oyuncu[player1][Pos][1], Oyuncu[player1][Pos][2]);

		sscanf(DMKonum3(sayi2), "p<,>fff", Oyuncu[player2][Pos][0], Oyuncu[player2][Pos][1], Oyuncu[player2][Pos][2]);
		SetPlayerPos(player2, Oyuncu[player2][Pos][0], Oyuncu[player2][Pos][1], Oyuncu[player2][Pos][2]);

		SetPlayerInterior(player1, 1);
		SetPlayerInterior(player2, 1);
		SetPlayerVirtualWorld(player1, 444+player1);
		SetPlayerVirtualWorld(player2, 444+player1);
	}

	if(map == 4)
	{
		new sayi = random(8);
		new sayi2 = random(8);
		sscanf(DMKonum4(sayi2), "p<,>fff", Oyuncu[player1][Pos][0], Oyuncu[player1][Pos][1], Oyuncu[player1][Pos][2]);
		SetPlayerPos(player1, Oyuncu[player1][Pos][0], Oyuncu[player1][Pos][1], Oyuncu[player1][Pos][2]);

		sscanf(DMKonum4(sayi), "p<,>fff", Oyuncu[player2][Pos][0], Oyuncu[player2][Pos][1], Oyuncu[player2][Pos][2]);
		SetPlayerPos(player2, Oyuncu[player2][Pos][0], Oyuncu[player2][Pos][1], Oyuncu[player2][Pos][2]);

		SetPlayerInterior(player1, 10);
		SetPlayerInterior(player2, 10);
		SetPlayerVirtualWorld(player1, 555+player1);
		SetPlayerVirtualWorld(player2, 555+player1);
	}
	TogglePlayerControllable(player1, 0);
	TogglePlayerControllable(player2, 0);
	SetPVarInt(player1, "dCountdown", 5);
	SetTimerEx("duelCountdown", 1000, false, "dd", player1, player2);
	return 1;
}

forward duelCountdown(player1, player2);
public duelCountdown(player1, player2)
{
	SetPVarInt(player1, "dCountdown", GetPVarInt(player1, "dCountdown")-1);
	new mesaj[100];
	format(mesaj, sizeof(mesaj), "~b~Duel basliyor. (%d)", GetPVarInt(player1, "dCountdown"));
	GameTextForPlayer(player1, mesaj, 1000, 4);
	GameTextForPlayer(player2, mesaj, 1000, 4);
	if(GetPVarInt(player1, "dCountdown") <= 0)
	{
		TogglePlayerControllable(player1, 1);
		TogglePlayerControllable(player2, 1);
		GameTextForPlayer(player1, "~r~Duel basladi!", 1000, 4);
		GameTextForPlayer(player2, "~r~Duel basladi!", 1000, 4);
		return 1;
	}
	SetTimerEx("duelCountdown", 1000, false, "dd", player1, player2);
	return 1;
}

// 			YollaKullanMesaj(playerid, "Maplar: 1: Las Venturas Police Department, 2: Liberty City Outside, 3: Meat Factory 4: RC Battlefield");
//			YollaKullanMesaj(playerid, "Olacak Silahlar: 1: Sadece Deagle _ 2: Sadece Shotgun _ 3: Deagle, Shotgun _ 4: Sadece M4 _ 5: M4, Deagle _ 6: Hepsi");


// martin
CMD:dred(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == true)
		return YollaHataMesaj(playerid, "Oyundayken bu komutu kullanamazsýn.");

	new invitedby = GetPVarInt(playerid, "LastDuelInvite");

	if(invitedby != GetPVarInt(invitedby, "LastDuelInvite"))
		return YollaHataMesaj(playerid, "Bu oyuncu size duel teklifi etmemiþ");


 	return 1;
}

CMD:dyardim(playerid, params[])
{
	YollaIpucuMesaj(playerid, "/duel komutuyla oyuncuya davet gönderebilirsiniz.");
	YollaIpucuMesaj(playerid, "/dkabul komutu ile isteði kabul edebilirsin, /dred ile red edebilirsiniz.");
	//YollaHataMesaj(playerid, "Duel sistemi þuanlýk pasif.");
	return 1;
}

CMD:cezaver(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 2)
	    return 1;

	new hedefid, miktar;
	if(sscanf(params, "ud", hedefid, miktar))
		return YollaKullanMesaj(playerid, "/cezaver [OyuncuID] [Ceza(verilen miktarda skor oyuncudan kesilir)]");
  	if(!IsPlayerConnected(hedefid))
		return OyundaDegilMesaj(playerid);

	if(playerid == hedefid) return YollaHataMesaj(playerid, "Kendine ceza kesemezsin.");
    if(Oyuncu[hedefid][Yonetici] > 3)
        return YollaHataMesaj(playerid, "Bu oyuncuya karþý bu komutu kullanmasýn.");

	YollaIpucuMesaj(hedefid, "%d miktarýnda skorun silindi, kurallarý dikkatlice oku!", miktar);
	SkorVer2(hedefid, miktar);
	YollaIpucuMesaj(playerid, "%s adlý oyuncuya %d miktarýndanda ceza verdin.", Oyuncuadi(hedefid), miktar);
	YollaHerkeseMesaj(RENK_YARALI, "AdmCmd: %s adlý yönetici %s adlý oyuncuya %d miktarýnda ceza kesti.", Oyuncuadi(playerid), Oyuncuadi(hedefid), miktar);
	return 1;
}

CMD:serverkilit(playerid, params[])
{
   if(Oyuncu[playerid][Yonetici] < 4)  return SendClientMessage(playerid, -1, ""#YARALI"HATA: Yönetici deðilsiniz.");
   {
        new str[128];
        if(sscanf(params, "s[128]", str))
				{
					 SendClientMessage(playerid, -1, "{c3c3c3}Kullaným: /serverkilit [þifre]");
					 SendClientMessage(playerid, -1, "Þifreyi kaldýrmak için þifre yerine yok yazmalýsýn.");
				}
				if(strcmp(str, "yok") == 0)
				{
					new pass[64];
	        format(pass,sizeof(pass),"password  0");
	        SendRconCommand(pass);
					return 1;
				}
        format(str, sizeof(str), "{c3c3c3}Sunucu Þifresi: %s", params);
        new pass[64];
        format(pass,sizeof(pass),"password %s",params);
        SendRconCommand(pass);
        format(str, sizeof(str), "AdmCmd: Yönetici sunucuyu kilitledi. (Þifre: %s)", params);
        YollaYoneticiMesaj(1, RENK_YARALI, str);
   }
   return 1;
}

CMD:cc(playerid, params[])
{
   if(Oyuncu[playerid][Yonetici] < 1)
    return 0;

   for(new i = 0; i < 18; i++) SendClientMessageToAll(BEYAZ," ");
   YollaHerkeseMesaj(RENK_YARALI, "AdmCmd: %s adlý yönetici sohbet kanalýný temizledi.", Oyuncuadi(playerid));
   return 1;
}

CMD:bilgi1(playerid, params[])
{
  	YollaFormatMesaj(playerid, TURUNCU, "BÝLGÝ:"#BEYAZ2" Oyun modunu öðrenmek için /kurallar komutuna göz atmayý unutma!");
	YollaFormatMesaj(playerid, TURUNCU, "BÝLGÝ:"#BEYAZ2" Aklýnda kalan bir soru olursa /sorusor komutunu kullanabilirsinin!");
	YollaFormatMesaj(playerid, TURUNCU, "BÝLGÝ:"#BEYAZ2" /discord komutunu kullanarak discord adresemize katýlmayý unutma!");
	return 1;
}

CMD:bilgi2(playerid, params[])
{
  	YollaFormatMesaj(playerid, TURUNCU, "BÝLGÝ:"#BEYAZ2" Þüphelilerin rengi sarý olmadan ateþ açarsan ceza alabilirsin!");
	YollaFormatMesaj(playerid, TURUNCU, "BÝLGÝ:"#BEYAZ2" /mp3 komutuyla oyun esnasýnda radyo kanallarýna ulaþabilirsin.");
	YollaFormatMesaj(playerid, TURUNCU, "BÝLGÝ:"#BEYAZ2" Kafanda olan istek veya önerilerini discord üzerinden bize bildirmeyi unutma!");
	YollaFormatMesaj(playerid, TURUNCU, "BÝLGÝ:"#BEYAZ2" Bize zaman ayýrdýðýn için teþekkür ederiz.");
	if(Oyuncu[playerid][Skor] < 5)
	    return SetPlayerScore(playerid, Oyuncu[playerid][Skor] +5);
	OyuncuGuncelle(playerid);
	return 1;
}

/*CMD:interiorgit(playerid)
{
    new string[2050];
    for(new i; i < sizeof(IsyeriInterior); i++) format(string, sizeof(string), "%s\n%s", string, IsyeriInterior[i][interior_isim]);
    Dialog_Show(playerid, DialogInterioraGit, DIALOG_STYLE_LIST, "{E67226}Interiorlar", string, "Seç", "Ýptal");
    return 1;
}*/

CMD:skoryardim(playerid, params[])
{
  		ShowPlayerDialog(playerid, SKORYARDIM, DIALOG_STYLE_TABLIST_HEADERS, "SKOR YARDIM",
		"SKOR\tRÜTBE\tSÝLAH\n\
		1\tRecruit Officer\tNormal\n\
		75\tPolice Officer\tShotgun\n\
		135\tPolice Officer I\tShotgun\n\
		165\tPolice Officer II\tMP5-Shotgun\n\
		225\tPolice Officer III\tRifle-MP5-Shotgun\n\
		300\tPolice Detective I\tRifle-MP5-Shotgun\n\
		380\tPolice Detective II\tRifle-MP5-Shotgun\n\
		560\tPolice Sergeant I\tM4-Rifle-MP5-Shotgun\n\
		660\tPolice Sergeant II\tBütün Silahlar\n\
		860\tPolice Lieutenant I\tBütün Silahlar\n\
		960\tPolice Lieutenant II\tBütün Silahlar\n\
		1060\tPolice Captain I\tBütün Silahlar\n\
		1160\tPolice Captain II\tBütün Silahlar\n\
		1260\tPolice Captain III\tBütün Silahlar\n\
		1460\tPolice Commander\tBütün Silahlar\n\
		1600\tDeputy Chief\tBütün Silahlar\n\
		1850\tPolice Assistant Chief\tBütün Silahlar\n\
		2200\tChief of Police\tBütün Silahlar",
		"Kapat", "");
		return 1;
}

CMD:kalanzaman(playerid, params[])return pc_cmd_timeleft(playerid,params);
CMD:timeleft(playerid, params[])
{
	if(OyunBasladi == false)
		return YollaHataMesaj(playerid, "Aktif oyun yok.");

	YollaIpucuMesaj(playerid, "Kalan oyun süresi: %d dakika.", OyunDakika);
	return 1;
}

CMD:fixveh(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
	if(Oyuncu[playerid][Yonetici] < 1)
	    return 0;

	if(sscanf(params, "d", vehicleid))
	   	return YollaKullanMesaj(playerid, "/fixveh [araç ID]");

	if(!IsValidVehicle(vehicleid))
	 	return YollaHataMesaj(playerid, "Geçersiz bir araç ID'sý belirttiniz.");

	RepairVehicle(vehicleid);
	YollaIpucuMesaj(playerid, "%d ID'li araç tamir edildi.", vehicleid);
	engine2 = VEHICLE_PARAMS_ON;
	return 1;
}

CMD:aflip(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

	if (Oyuncu[playerid][Yonetici] < 1)
	    return 0;

	if (vehicleid > 0 && isnull(params))
	{
		FlipVehicle(vehicleid);
		YollaIpucuMesaj(playerid, ""#YARALI"Arabaný çevirdin.");
	}
	else
	{
		if (sscanf(params, "d", vehicleid))
	    	return YollaKullanMesaj(playerid, "/flipcar [Vehicle ID](/dl komutu ile id görebilirsiniz.)");

		else if (!IsValidVehicle(vehicleid))
	    	return YollaHataMesaj(playerid, "Geçersiz bir araç ID'sý belirttiniz.");

		FlipVehicle(vehicleid);
		YollaIpucuMesaj(playerid, ""#YARALI"Aracý çevirdin. Araç ID: %d.", vehicleid);
	}
	return 1;
}

CMD:pskor(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 2)
	    return 0;
    if(OyunBasladi == false)
	    return YollaHataMesaj(playerid, "Oyun baþlamamýþ.");
	new skor;
	if(sscanf(params, "d", skor))
	   	return YollaKullanMesaj(playerid, "/pskor [skor]");
    foreach(new i : Player)
	SkorVerPolis(i, skor);
	YollaHerkeseMesaj(RENK_YARALI, "AdmCmd: %s adlý yönetici polislere %d miktarýnda skor verdi.", Oyuncuadi(playerid), skor);
	return 1;
}

CMD:aspawn(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 2) return 0;
    new vehicleid;
    if(sscanf( params, "i", vehicleid )) return YollaKullanMesaj(playerid, "/aspawn <aracid>" );
    DestroyVehicle(vehicleid);
    YollaIpucuMesaj(playerid, "%d ID'li aracý spawnladýn.", vehicleid);
    return 1;
}

CMD:topdm(playerid, params[])
{
	new sorgu[100];
	mysql_format(CopSQL, sorgu, sizeof(sorgu), "SELECT isim, oldurme FROM hesaplar ORDER BY oldurme DESC LIMIT 5");
	mysql_tquery(CopSQL, sorgu, "TopListe", "d", playerid);
	return 1;
}

CMD:dmsifirla(playerid, params[])
{
	if(Oyuncu[playerid][Yonetici] < 4) return 0;
	foreach(new i : Player)
		if(Oyuncu[i][GirisYapti] == true)
			Oyuncu[i][Oldurme] = Oyuncu[i][Olum] = 0;

	mysql_tquery(CopSQL, "UPDATE hesaplar SET oldurme = 0, olum = 0");
	YollaYoneticiMesaj(1, YONETIM_RENK, "AdmCmd: %s adlý yetkili DM istatistiklerini sýfýrladý", Oyuncuadi(playerid));
	return 1;
}

CMD:track(playerid, params[])
{
	if(Oyuncu[playerid][Oyunda] == false)
		return YollaHataMesaj(playerid, "Oyunda deðilsin.");
	if(Oyuncu[playerid][Polis] == false)
		return YollaHataMesaj(playerid, "Polis deðilsin.");
	if(Oyuncu[playerid][HedefKomut] == true)
		return YollaHataMesaj(playerid, "Bu komut maç boyunca bir defa kullanýlabilir.");

	foreach(new i : Player)
		if(Oyuncu[i][GirisYapti] == true && Oyuncu[i][Oyunda] == true && Oyuncu[i][Suspect] == true)
			SetPlayerMarkerForPlayer(playerid, i, SUSPECT_RENK);

	Oyuncu[playerid][HedefKomut] = true;
	SetTimerEx("HedefRenkSakla", TIMER_SANIYE(120), false, "d", playerid);
	YollaIpucuMesaj(playerid, "Suspectler haritada gözükür hale geldi. (120 saniye)");
	return 1;
}

forward HedefRenkSakla(playerid);
public HedefRenkSakla(playerid)
{
	foreach(new i : Player)
		if(Oyuncu[i][GirisYapti] == true && Oyuncu[i][Oyunda] == true && Oyuncu[i][Suspect] == true)
			SetPlayerMarkerForPlayer(playerid, i, SUSPECT_RENK2);
	return 1;
}

forward TopListe(playerid);
public TopListe(playerid)
{
	new veriler = cache_num_rows();
 	if(veriler)
  	{
   		new yukle, isim[MAX_PLAYER_NAME], oldurme, liste[1000];
   		format(liste, sizeof(liste), "Sýralama\tOyuncu Adý\tÖldürme\n");
		while(yukle < veriler)
		{
			cache_get_value(yukle, "isim", isim, MAX_PLAYER_NAME);
			cache_get_value_int(yukle, "oldurme", oldurme);
			format(liste, sizeof(liste), "%s%d\t%s\t%d\n", liste, yukle+1, isim, oldurme);
			yukle++;
	    }
	    ShowPlayerDialog(playerid, DIALOG_X, DIALOG_STYLE_TABLIST_HEADERS, "Top 5 DM", liste, "Kapat", "");
	}
	return 1;
}

OyunAraclariYarat(oyunturu)
{
	switch(oyunturu)
	{
		case 0: // El Corona
		{
			CopArac[0] = AddStaticVehicleEx(596, 1820.062, -2044.193, 13.119, 180.0, 0, 1, -1, 1);
			CopArac[1] = AddStaticVehicleEx(596, 1758.785, -2115.574, 13.065, 270.0, 0, 1, -1, 1);
			CopArac[2] = AddStaticVehicleEx(596, 1708.844, -2197.107, 13.038, 280.0, 0, 1, -1, 1);
			CopArac[3] = AddStaticVehicleEx(596, 1512.068, -2360.651, 13.201, 0.0, 0, 1, -1, 1);
			CopArac[4] = AddStaticVehicleEx(596, 1497.761, -2361.047, 13.203, 0.0, 0, 1, -1, 1);
			CopArac[5] = AddStaticVehicleEx(596, 1959.352, -1987.203, 13.031, 180.0, 0, 1, -1, 1);
			CopArac[6] = AddStaticVehicleEx(596, 2049.927, -2164.705, 13.105, 85.0, 0, 1, -1, 1);
			CopArac[7] = AddStaticVehicleEx(596, 1853.592, -1934.950, 13.021, 280.0, 0, 1, -1, 1);
			CopArac[8] = AddStaticVehicleEx(596, 2135.875, -2210.781, 13.043, 40.0, 0, 1, -1, 1);
			CopArac[9] = AddStaticVehicleEx(596, 1793.948, -1857.551, 13.076, 270.0, 0, 1, -1, 1);
			CopArac[10] = AddStaticVehicleEx(596, 1818.986, -1818.510, 13.072, 180.0, 0, 1, -1, 1);
			CopArac[11] = AddStaticVehicleEx(596, 1958.924, -1834.223, 13.098, 180.0, 0, 1, -1, 1);
			CopArac[12] = AddStaticVehicleEx(596, 2079.129, -1866.278, 13.081, 180.0, 0, 1, -1, 1);
			CopArac[13] = AddStaticVehicleEx(596, 2102.548, -1779.288, 13.040, 270.0, 0, 1, -1, 1);
			CopArac[14] = AddStaticVehicleEx(596, 2120.683, -1782.690, 13.044, 0.0, 0, 1, -1, 1);
			CopArac[15] = AddStaticVehicleEx(596, 1426.976, -1645.409, 13.062, 0.0, 0, 1, -1, 1);
			CopArac[16] = AddStaticVehicleEx(596, 1386.827, -1755.797, 13.087, 0.0, 0, 1, -1, 1);
			CopArac[17] = AddStaticVehicleEx(596, 1386.905, -1811.897, 13.087, 0.0, 0, 1, -1, 1);
			CopArac[18] = AddStaticVehicleEx(596, 1309.308, -1854.972, 13.087, 0.0, 0, 1, -1, 1);
			CopArac[19] = AddStaticVehicleEx(596, 1267.036, -1854.965, 13.087, 0.0, 0, 1, -1, 1);
			CopArac[20] = AddStaticVehicleEx(596, 1216.377, -1854.519, 13.087, 0.0, 0, 1, -1, 1);
			CopArac[21] = AddStaticVehicleEx(596, 1239.465, -1813.193, 13.133, 0.0, 0, 1, -1, 1);
			CopArac[22] = AddStaticVehicleEx(596, 1264.760, -1796.042, 13.118, 0.0, 0, 1, -1, 1);
			SuspectArac[0] = AddStaticVehicleEx(566, 1883.039, -2042.930, 13.173, 180.0, 3, 3, -1);
			SuspectArac[1] = AddStaticVehicleEx(426, 1928.6606, -2069.0781, 13.5469, 3.5943, 3, 3, -1);
			SuspectArac[2] = AddStaticVehicleEx(426, 1932.7593, -2033.5974, 13.5469, 180.6730, 3, 3, -1);
			format(OyunSebep, 150, "Darp suçundan aranan kýrmýzý renkli Tahoma, El Corona bölgesinde görüldü!");
		}
		case 1: // County General
		{
			CopArac[0] = AddStaticVehicleEx(596, 2000.864, -1353.559, 23.651, 180.0, 0, 1, -1, 1);
			CopArac[1] = AddStaticVehicleEx(596, 1982.183, -1362.228, 23.557, 180.0, 0, 1, -1, 1);
			CopArac[2] = AddStaticVehicleEx(596, 1941.361, -1447.769, 13.205, 280.0, 0, 1, -1, 1);
			CopArac[3] = AddStaticVehicleEx(596, 2039.024, -1422.062, 16.789, 0.0, 0, 1, -1, 1);
			CopArac[4] = AddStaticVehicleEx(596, 2025.359, -1407.625, 16.803, 270.0, 0, 1, -1, 1);
			CopArac[5] = AddStaticVehicleEx(596, 2076.291, -1363.743, 23.619, 0.0, 0, 1, -1, 1);
			CopArac[6] = AddStaticVehicleEx(596, 2053.720, -1335.970, 23.611, 85.0, 0, 1, -1, 1);
			CopArac[7] = AddStaticVehicleEx(596, 2127.992, -1474.485, 23.594, 0.0, 0, 1, -1, 1);
			CopArac[8] = AddStaticVehicleEx(596, 1958.472, -1495.119, 3.065, 90.0, 0, 1, -1, 1);
			CopArac[9] = AddStaticVehicleEx(596, 1957.577, -1520.615, 3.063, 270.0, 0, 1, -1, 1);
			CopArac[10] = AddStaticVehicleEx(596, 2340.328, -1511.616, 23.547, 180.0, 0, 1, -1, 1);
			CopArac[11] = AddStaticVehicleEx(596, 2172.500, -1218.207, 23.536, 180.0, 0, 1, -1, 1);
			CopArac[12] = AddStaticVehicleEx(596, 2040.305, -1734.312, 13.254, 180.0, 0, 1, -1, 1);
			CopArac[13] = AddStaticVehicleEx(596, 1892.576, -1609.593, 13.098, 270.0, 0, 1, -1, 1);
			CopArac[14] = AddStaticVehicleEx(596, 1716.659, -1566.519, 13.260, 0.0, 0, 1, -1, 1);
			CopArac[15] = AddStaticVehicleEx(596, 2453.274, -1319.394, 23.540, 0.0, 0, 1, -1, 1);
			CopArac[16] = AddStaticVehicleEx(596, 2453.645, -1371.372, 23.540, 0.0, 0, 1, -1, 1);
			CopArac[17] = AddStaticVehicleEx(596, 2453.226, -1429.028, 23.533, 0.0, 0, 1, -1, 1);
			CopArac[18] = AddStaticVehicleEx(596, 2511.411, -1441.797, 28.065, 0.0, 0, 1, -1, 1);
			CopArac[19] = AddStaticVehicleEx(596, 2396.963, -1729.791, 13.087, 0.0, 0, 1, -1, 1);
			CopArac[20] = AddStaticVehicleEx(596, 2267.272, 1750.513, 13.087, 0.0, 0, 1, -1, 1);
			CopArac[21] = AddStaticVehicleEx(596, 2217.881, -1934.696, 13.042, 0.0, 0, 1, -1, 1);
			CopArac[22] = AddStaticVehicleEx(596, 2215.856, -1977.769, 13.095, 0.0, 0, 1, -1, 1);
			SuspectArac[0] = AddStaticVehicleEx(426, 2000.107, -1447.887, 13.273, 180.0, 3, 3, -1);
			SuspectArac[1] = AddStaticVehicleEx(426, 2110.2502, -1446.1045, 23.8281, 180.3829, 3, 3, -1);
			SuspectArac[2] = AddStaticVehicleEx(529, 2015.2611, -1446.3661, 14.7577, 91.7080, 3, 3, -1);
			format(OyunSebep, 150, "County General hastanesinde soygun durumu mevcut. Kiþilerin dört kapýlý sedanlar ile kaçtýðý hakkýnda söylentiler var, durdurun þunlarý!");
		}
		case 2: // Mulholland'idi fakat Ýdlewood olarak deðiþti.
		{
			CopArac[0] = AddStaticVehicleEx(596, 2067.8308, -1614.6832, 13.3828, 269.2449, 0, 1, -1, 1);
			CopArac[1] = AddStaticVehicleEx(596, 2044.3625, -1646.6487, 13.5469, 178.8082, 0, 1, -1, 1);
			CopArac[2] = AddStaticVehicleEx(596, 2044.2551, -1694.4904, 13.5547, 177.0848, 0, 1, -1, 1);
			CopArac[3] = AddStaticVehicleEx(596, 2004.5259,-1684.4480,13.3828,178.3773, 0, 1, -1, 1);
			CopArac[4] = AddStaticVehicleEx(596, 1979.4590,-1709.9596,15.9688,271.1582, 0, 1, -1, 1);
			CopArac[5] = AddStaticVehicleEx(596, 1938.8170,-1721.8850,13.3828,180.6881, 0, 1, -1, 1);
			CopArac[6] = AddStaticVehicleEx(596, 1923.0891,-1738.3839,13.5469,88.2540, 0, 1, -1, 1);
			CopArac[7] = AddStaticVehicleEx(596, 1911.2643,-1776.1333,13.3828,178.8865, 0, 1, -1, 1);
			CopArac[8] = AddStaticVehicleEx(596, 1898.2638,-1794.2797,13.5469,268.8806, 0, 1, -1, 1);
			CopArac[9] = AddStaticVehicleEx(596, 1973.9463,-1784.5704,13.5537,90.3180, 0, 1, -1, 1);
			CopArac[10] = AddStaticVehicleEx(596, 2068.5815,-1694.7177,13.5469,269.2722, 0, 1, -1, 1);
			CopArac[11] = AddStaticVehicleEx(596, 2102.7856,-1772.4597,13.3931,261.1646, 0, 1, -1, 1);
			CopArac[12] = AddStaticVehicleEx(596, 2186.9607,-1624.7694,14.7181,152.9578, 0, 1, -1, 1);
			CopArac[13] = AddStaticVehicleEx(596, 2182.6292,-1706.5713,13.4086,179.4347, 0, 1, -1, 1);
			CopArac[14] = AddStaticVehicleEx(596, 2236.7231,-1751.3954,13.3906,86.4521, 0, 1, -1, 1);
			CopArac[15] = AddStaticVehicleEx(596, 1948.4094,-1855.8666,13.5469,255.1012, 0, 1, -1, 1);
			CopArac[16] = AddStaticVehicleEx(596, 1824.4257,-1768.4779,13.3828,0.1747, 0, 1, -1, 1);
			CopArac[17] = AddStaticVehicleEx(596, 1836.8394,-1614.7402,13.3828,269.1898, 0, 1, -1, 1);
			CopArac[18] = AddStaticVehicleEx(596, 1927.9969,-1545.5559,13.6407,179.3795, 0, 1, -1, 1);
			CopArac[19] = AddStaticVehicleEx(596, 2089.6968,-1594.1333,13.3354,176.5322, 0, 1, -1, 1);
			CopArac[20] = AddStaticVehicleEx(596, 2162.1628,-1656.6971,15.0859,314.0753, 0, 1, -1, 1);
			CopArac[21] = AddStaticVehicleEx(596, 2067.7124,-1738.9435,13.5469,267.8072, 0, 1, -1, 1);
			CopArac[22] = AddStaticVehicleEx(596, 1976.3248,-1824.8700,13.5469,87.0238, 0, 1, -1, 1);
			SuspectArac[0] = AddStaticVehicleEx(529, 2128.1411,-1802.1980,13.5534,357.7443, 0, 0, -1);
			SuspectArac[1] = AddStaticVehicleEx(529, 2125.9883,-1813.5140,13.5545,359.0368, 0, 0, -1);
			SuspectArac[2] = AddStaticVehicleEx(529, 1927.9987,-1789.2159,13.3828,270.8404, 0, 0, -1);
			format(OyunSebep, 150, "Ýdlewood bölgesinde market soygunu ihbarý þüpheli araç siyah Willard görüldü, durdurun þunlarý.");
		}
		case 3: // Old Venturas
		{
			CopArac[0] = AddStaticVehicleEx(596, 2370.125, 2235.476, 10.393, 90.0, 0, 1, -1, 1);
			CopArac[1] = AddStaticVehicleEx(596, 2326.904, 2230.701, 10.399, 270.0, 0, 1, -1, 1);
			CopArac[2] = AddStaticVehicleEx(596, 2367.982, 2055.382, 10.397, 90.0, 0, 1, -1, 1);
			CopArac[3] = AddStaticVehicleEx(596, 2149.896, 2033.795, 10.388, 0.0, 0, 1, -1, 1);
			CopArac[4] = AddStaticVehicleEx(596, 2424.345, 2251.765, 10.385, 180.0, 0, 1, -1, 1);
			CopArac[5] = AddStaticVehicleEx(596, 2258.472, 2230.639, 10.389, 270.0, 0, 1, -1, 1);
			CopArac[6] = AddStaticVehicleEx(596, 2378.130, 2019.034, 10.532, 90.0, 0, 1, -1, 1);
			CopArac[7] = AddStaticVehicleEx(596, 2185.970, 2004.173, 10.534, 270.0, 0, 1, -1, 1);
			CopArac[8] = AddStaticVehicleEx(596, 2102.706, 2036.354, 10.534, 180.0, 0, 1, -1, 1);
			CopArac[9] = AddStaticVehicleEx(596, 2032.762, 2147.281, 10.541, 0.0, 0, 1, -1, 1);
			CopArac[10] = AddStaticVehicleEx(596, 1891.269, 2116.209, 10.535, 90.0, 0, 1, -1, 1);
			CopArac[11] = AddStaticVehicleEx(596, 1912.863, 2156.399, 10.533, 78.0, 0, 1, -1, 1);
			CopArac[12] = AddStaticVehicleEx(596, 1880.449, 2258.548, 10.533, 180.0, 0, 1, -1, 1);
			CopArac[13] = AddStaticVehicleEx(596, 1987.517, 2467.376, 10.531, 270.0, 0, 1, -1, 1);
			CopArac[14] = AddStaticVehicleEx(596, 2223.065, 2467.810, 10.459, 180.0, 0, 1, -1, 1);
			CopArac[15] = AddStaticVehicleEx(596, 1940.364, 1710.710, 10.376, 90.0, 0, 1, -1, 1);
			CopArac[16] = AddStaticVehicleEx(596, 1890.426, 1710.482, 10.376, 78.0, 0, 1, -1, 1);
			CopArac[17] = AddStaticVehicleEx(596, 1809.128, 1635.590, 6.446, 180.0, 0, 1, -1, 1);
			CopArac[18] = AddStaticVehicleEx(596, 1809.680, 1558.835, 6.439, 270.0, 0, 1, -1, 1);
			CopArac[19] = AddStaticVehicleEx(596, 1810.159, 1502.495, 6.439, 180.0, 0, 1, -1, 1);
			CopArac[20] = AddStaticVehicleEx(596, 1989.314, 1405.921, 8.814, 90.0, 0, 1, -1, 1);
			CopArac[21] = AddStaticVehicleEx(596, 1968.575, 1389.779, 8.814, 78.0, 0, 1, -1, 1);
			CopArac[22] = AddStaticVehicleEx(596, 1949.648, 1360.003, 8.814, 180.0, 0, 1, -1, 1);
			SuspectArac[0] = AddStaticVehicleEx(400, 2346.3940, 2171.6714, 10.6897, 179.8406, 2, 2, -1);
			SuspectArac[1] = AddStaticVehicleEx(400, 2377.0667, 2136.7092, 10.6719, 267.2582,  2, 2, -1);
			SuspectArac[2] = AddStaticVehicleEx(400, 2346.0754, 2115.7622, 10.6808, 179.6481, 2, 2, -1);

			format(OyunSebep, 150, "Ýnsan kaçakçýlýðý suçundan aranan þahýslar mavi renkli Landstalker içerisinde Old Venturas Strip bölgesinde görüldü!");
		}
		case 4: // Santo Flora
		{
			CopArac[0] = AddStaticVehicleEx(596, -2491.801, 723.608, 34.734, 270.0, 0, 1, -1, 1);
			CopArac[1] = AddStaticVehicleEx(596, -2482.321, 705.312, 34.730, 270.0, 0, 1, -1, 1);
			CopArac[2] = AddStaticVehicleEx(596, -2383.217, 641.607, 34.730, 0.0, 0, 1, -1, 1);
			CopArac[3] = AddStaticVehicleEx(596, -2316.380, 673.009, 42.660, 90.0, 0, 1, -1, 1);
			CopArac[4] = AddStaticVehicleEx(596, -2404.955, 804.958, 34.743, 270.0, 0, 1, -1, 1);
			CopArac[5] = AddStaticVehicleEx(596, -2544.858, 659.574, 27.519, 90.0, 0, 1, -1, 1);
			CopArac[6] = AddStaticVehicleEx(596, -2379.554, 831.612, 36.938, 0.0, 0, 1, -1, 1);
			CopArac[7] = AddStaticVehicleEx(596, -2090.868, 717.516, 69.129, 180.0, 0, 1, -1, 1);
			CopArac[8] = AddStaticVehicleEx(596, -2399.348, 703.415, 34.805, 90.0, 0, 1, -1, 1);
			CopArac[9] = AddStaticVehicleEx(596, -2460.650, 794.855, 34.885, 90.0, 0, 1, -1, 1);
			CopArac[10] = AddStaticVehicleEx(596, -2494.729, 782.156, 34.885, 270.0, 0, 1, -1, 1);
			CopArac[11] = AddStaticVehicleEx(596, -2345.654, 505.560, 29.662, 90.0, 0, 1, -1, 1);
			CopArac[12] = AddStaticVehicleEx(596, -2268.979, 534.588, 34.729, 180.0, 0, 1, -1, 1);
			CopArac[13] = AddStaticVehicleEx(596, -1956.330, 584.945, 34.841, 180.0, 0, 1, -1, 1);
			CopArac[14] = AddStaticVehicleEx(596, -1707.022, 697.091, 24.521, 0.0, 0, 1, -1, 1);
			CopArac[15] = AddStaticVehicleEx(596, -2403.412, 905.853, 45.010, 270.0, 0, 1, -1, 1);
			CopArac[16] = AddStaticVehicleEx(596, -2402.605, 957.250, 45.044, 90.0, 0, 1, -1, 1);
			CopArac[17] = AddStaticVehicleEx(596, -2369.694, 967.065, 45.320, 180.0, 0, 1, -1, 1);
			CopArac[18] = AddStaticVehicleEx(596, -2360.341, 969.053, 45.467, 180.0, 0, 1, -1, 1);
			CopArac[19] = AddStaticVehicleEx(596, -2523.780, 693.302, 27.581, 0.0, 0, 1, -1, 1);
			CopArac[20] = AddStaticVehicleEx(596, -2528.712, 803.730, 49.569, 270.0, 0, 1, -1, 1);
			CopArac[21] = AddStaticVehicleEx(596, -2543.910, 806.448, 49.568, 90.0, 0, 1, -1, 1);
			CopArac[22] = AddStaticVehicleEx(596, -2478.448, 805.933, 34.833, 180.0, 0, 1, -1, 1);
			SuspectArac[0] = AddStaticVehicleEx(445, -2417.382, 732.860, 34.804, 270.0, 0, 0, -1);
			SuspectArac[1] = AddStaticVehicleEx(445, -2374.0613, 666.2259, 35.0256, 270.0, 0, 0, -1);
			SuspectArac[2] = AddStaticVehicleEx(445, -2383.4670, 763.5736, 35.0156, 359.4633, 0, 0, -1);
			format(OyunSebep, 150, "Santa Flora bölgesinde silah sesleri yükselmiþ, siyah renkli Admiral þüpheli olabilir!");
		}
		case 5: // Tierra Robada
		{
			CopArac[0] = AddStaticVehicleEx(596,  2279.6101, -6.5438,  27.1166, 176.1848, 0, 1, -1, 1);
			CopArac[1] = AddStaticVehicleEx(596,  2240.2053, -10.5156, 27.0875, 175.5349, 0, 1, -1, 1);
			CopArac[2] = AddStaticVehicleEx(596,  2249.0017, -80.3442, 26.5146, 177.3743, 0, 1, -1, 1);
			CopArac[3] = AddStaticVehicleEx(596,  2308.6121, -75.1257, 26.4844, 87.1973, 0, 1, -1, 1);
			CopArac[4] = AddStaticVehicleEx(596,  2325.4700, -53.3137, 26.4844, 266.9952, 0, 1, -1, 1);
			CopArac[5] = AddStaticVehicleEx(596,  2358.3743, -62.5691, 27.4688, 357.5666, 0, 1, -1, 1);
			CopArac[6] = AddStaticVehicleEx(596,  2390.7271, -15.0375, 26.3322, 177.1721, 0, 1, -1, 1);
			CopArac[7] = AddStaticVehicleEx(596,  2433.4695, -9.1963,  26.4844, 178.2805, 0, 1, -1, 1);
			CopArac[8] = AddStaticVehicleEx(596,  2441.7361, -31.4266, 26.3359, 269.2242, 0, 1, -1, 1);
			CopArac[9] = AddStaticVehicleEx(596,  2479.9778, -23.3809, 27.2906, 355.8094, 0, 1, -1, 1);
			CopArac[10] = AddStaticVehicleEx(596, 2530.8679, 75.3575,  26.3359, 178.2756, 0, 1, -1, 1);
			CopArac[11] = AddStaticVehicleEx(596, 2514.8120, 73.9945,  27.0429, 266.4681, 0, 1, -1, 1);
			CopArac[12] = AddStaticVehicleEx(596, 2514.2341, 69.5400,  27.0489, 272.0037, 0, 1, -1, 1);
	        CopArac[13] = AddStaticVehicleEx(596, 2528.9629, 128.4941, 26.4844, 179.0299, 0, 1, -1, 1);
	        CopArac[14] = AddStaticVehicleEx(596, 2536.5730, 96.4823,  26.3359, 358.2988, 0, 1, -1, 1);
	        CopArac[15] = AddStaticVehicleEx(596, 2280.9087, -50.1277, 27.0242, 177.1498, 0, 1, -1, 1);
	        CopArac[16] = AddStaticVehicleEx(596, 2274.3789, -80.3367, 26.5485, 173.4303, 0, 1, -1, 1);
	        CopArac[17] = AddStaticVehicleEx(596, 2277.9968, -101.7629,26.3374, 268.5396, 0, 1, -1, 1);
	        CopArac[18] = AddStaticVehicleEx(596, 2359.1895, -78.1823, 26.5319, 89.3112, 0, 1, -1, 1);
	        CopArac[19] = AddStaticVehicleEx(596, 2444.1707, -78.9656, 26.4844, 269.8740, 0, 1, -1, 1);
	        CopArac[20] = AddStaticVehicleEx(596, 2156.4556, -23.1149, 10.5850, 0.1380, 0, 1, -1, 1);
	        CopArac[21] = AddStaticVehicleEx(596, 2181.2070,  59.3942, 26.4844, 179.1341, 0, 1, -1, 1);
	        CopArac[22] = AddStaticVehicleEx(596, 2204.3833,  86.1842, 25.3230, 272.4850, 0, 1, -1, 1);
	        SuspectArac[0] = AddStaticVehicleEx(579, 2279.7200, 63.6664, 26.4844, 271.2236, 0, 0, -1);
	        SuspectArac[1] = AddStaticVehicleEx(579, 2406.1780, 38.9195, 26.3373, 270.9859, 0, 0, -1);
	        SuspectArac[2] = AddStaticVehicleEx(579, 2296.8423, 26.0558, 26.3359, 0.2591, 0, 0, -1);
			format(OyunSebep, 150, "Palomino Creek bankasýnda soygun durumu 911 hattýna bildirildi, þüpheliler siyah renkli bir sedan kullanýyor.");
		}
		case 7: //Palomino Creek Bankasý
		{
		CopArac[0] = AddStaticVehicleEx(596,  2279.6101, -6.5438,  27.1166, 176.1848, 0, 1, -1, 1);
		CopArac[1] = AddStaticVehicleEx(596,  2240.2053, -10.5156, 27.0875, 175.5349, 0, 1, -1, 1);
		CopArac[2] = AddStaticVehicleEx(596,  2249.0017, -80.3442, 26.5146, 177.3743, 0, 1, -1, 1);
		CopArac[3] = AddStaticVehicleEx(596,  2308.6121, -75.1257, 26.4844, 87.1973, 0, 1, -1, 1);
		CopArac[4] = AddStaticVehicleEx(596,  2325.4700, -53.3137, 26.4844, 266.9952, 0, 1, -1, 1);
		CopArac[5] = AddStaticVehicleEx(596,  2358.3743, -62.5691, 27.4688, 357.5666, 0, 1, -1, 1);
		CopArac[6] = AddStaticVehicleEx(596,  2390.7271, -15.0375, 26.3322, 177.1721, 0, 1, -1, 1);
		CopArac[7] = AddStaticVehicleEx(596,  2433.4695, -9.1963,  26.4844, 178.2805, 0, 1, -1, 1);
		CopArac[8] = AddStaticVehicleEx(596,  2441.7361, -31.4266, 26.3359, 269.2242, 0, 1, -1, 1);
		CopArac[9] = AddStaticVehicleEx(596,  2479.9778, -23.3809, 27.2906, 355.8094, 0, 1, -1, 1);
		CopArac[10] = AddStaticVehicleEx(596, 2530.8679, 75.3575,  26.3359, 178.2756, 0, 1, -1, 1);
		CopArac[11] = AddStaticVehicleEx(596, 2514.8120, 73.9945,  27.0429, 266.4681, 0, 1, -1, 1);
		CopArac[12] = AddStaticVehicleEx(596, 2514.2341, 69.5400,  27.0489, 272.0037, 0, 1, -1, 1);
        CopArac[13] = AddStaticVehicleEx(596, 2528.9629, 128.4941, 26.4844, 179.0299, 0, 1, -1, 1);
        CopArac[14] = AddStaticVehicleEx(596, 2536.5730, 96.4823,  26.3359, 358.2988, 0, 1, -1, 1);
        CopArac[15] = AddStaticVehicleEx(596, 2280.9087, -50.1277, 27.0242, 177.1498, 0, 1, -1, 1);
        CopArac[16] = AddStaticVehicleEx(596, 2274.3789, -80.3367, 26.5485, 173.4303, 0, 1, -1, 1);
        CopArac[17] = AddStaticVehicleEx(596, 2277.9968, -101.7629,26.3374, 268.5396, 0, 1, -1, 1);
        CopArac[18] = AddStaticVehicleEx(596, 2359.1895, -78.1823, 26.5319, 89.3112, 0, 1, -1, 1);
        CopArac[19] = AddStaticVehicleEx(596, 2444.1707, -78.9656, 26.4844, 269.8740, 0, 1, -1, 1);
        CopArac[20] = AddStaticVehicleEx(596, 2156.4556, -23.1149, 10.5850, 0.1380, 0, 1, -1, 1);
        CopArac[21] = AddStaticVehicleEx(596, 2181.2070,  59.3942, 26.4844, 179.1341, 0, 1, -1, 1);
        CopArac[22] = AddStaticVehicleEx(596, 2204.3833,  86.1842, 25.3230, 272.4850, 0, 1, -1, 1);
        SuspectArac[0] = AddStaticVehicleEx(579, 2279.7200, 63.6664, 26.4844, 271.2236, 0, 0, -1);
        SuspectArac[1] = AddStaticVehicleEx(579, 2406.1780, 38.9195, 26.3373, 270.9859, 0, 0, -1);
        SuspectArac[2] = AddStaticVehicleEx(579, 2296.8423, 26.0558, 26.3359, 0.2591, 0, 0, -1);
		format(OyunSebep, 150, "Palomino Creek bankasýnda soygun durumu 911 hattýna bildirildi, þüpheliler siyah renkli bir sedan kullanýyor.");
		}
        case 8: //Fort Carson Silahlý Þahýslar
		{
		CopArac[0] = AddStaticVehicleEx(596,  -14.0271,1220.8059,19.3527,178.3106, 0, 1, -1, 1);
		CopArac[1] = AddStaticVehicleEx(596,  9.2061,1235.3792,19.3434,87.1808, 0, 1, -1, 1);
		CopArac[2] = AddStaticVehicleEx(596,  -67.0831,1263.6600,11.4132,94.4541, 0, 1, -1, 1);
		CopArac[3] = AddStaticVehicleEx(596,  -132.8549,1241.1399,19.1498,276.0717, 0, 1, -1, 1);
		CopArac[4] = AddStaticVehicleEx(596,  -130.7101,1228.7404,19.7422,180.7392, 0, 1, -1, 1);
		CopArac[5] = AddStaticVehicleEx(596,  -79.6846,1223.2106,19.7422,178.3224, 0, 1, -1, 1);
		CopArac[6] = AddStaticVehicleEx(596,  -101.3959,1222.9312,19.7422,181.2324, 0, 1, -1, 1);
		CopArac[7] = AddStaticVehicleEx(596,  -53.5274,1177.0378,19.4560,178.8489, 0, 1, -1, 1);
		CopArac[8] = AddStaticVehicleEx(596,  -22.4163,1183.0736,19.3624,356.4264, 0, 1, -1, 1);
		CopArac[9] = AddStaticVehicleEx(596,  -36.7934,1183.7260,19.3594,265.2572, 0, 1, -1, 1);
		CopArac[10] = AddStaticVehicleEx(596, 16.2468,1164.1526,19.6090,358.4863, 0, 1, -1, 1);
		CopArac[11] = AddStaticVehicleEx(596, 12.9462,1180.4280,19.4386,87.3897, 0, 1, -1, 1);
		CopArac[12] = AddStaticVehicleEx(596, 44.4749,1214.9529,19.0038,90.4781, 0, 1, -1, 1);
        CopArac[13] = AddStaticVehicleEx(596, 64.6610,1219.5074,18.8282,168.8904, 0, 1, -1, 1);
        CopArac[14] = AddStaticVehicleEx(596, 80.7396,1165.9121,18.6565,359.5713, 0, 1, -1, 1);
        CopArac[15] = AddStaticVehicleEx(596, 45.1524,1176.6180,18.6641,267.6011, 0, 1, -1, 1);
        CopArac[16] = AddStaticVehicleEx(596, 2.0473,1083.7517,19.7493,89.4597, 0, 1, -1, 1);
        CopArac[17] = AddStaticVehicleEx(596, -34.1387,1083.9165,19.8683,358.2280, 0, 1, -1, 1);
        CopArac[18] = AddStaticVehicleEx(596, -165.7538,1086.1486,19.7422,1.2947, 0, 1, -1, 1);
        CopArac[19] = AddStaticVehicleEx(596, -177.0125,1049.4331,19.7422,89.1855, 0, 1, -1, 1);
        CopArac[20] = AddStaticVehicleEx(596, -220.6924,992.2900,19.5613,355.8838, 0, 1, -1, 1);
        CopArac[21] = AddStaticVehicleEx(596, -304.4914,1019.9877,19.5938,268.8605, 0, 1, -1, 1);
        CopArac[22] = AddStaticVehicleEx(596, -340.0682,1162.5061,19.7452,177.6014, 0, 1, -1, 1);
        SuspectArac[0] = AddStaticVehicleEx(426, -110.4892,1115.5204,19.7422,179.5515, 0, 0, -1);
        SuspectArac[1] = AddStaticVehicleEx(426, -147.9471,1177.7947,19.7500,1.4403, 0, 0, -1);
        SuspectArac[2] = AddStaticVehicleEx(426, -225.4460,1186.3779,19.7422,0.5001, 0, 0, -1);
		format(OyunSebep, 150, "Fort Carson kasabasýnda silahlý þahýslar 911 hattýna bildirildi, þüpheliler siyah renkli bir sedan kullanýyor.");
		}
        case 9: //Bayside Dur Ýhtarýna uymayan þüpheliler
		{
		CopArac[0] = AddStaticVehicleEx(596,  -2446.8630,2243.2104,4.7754,178.0777, 0, 1, -1, 1);
		CopArac[1] = AddStaticVehicleEx(596,  -2446.9148,2224.9263,4.8438,356.5110, 0, 1, -1, 1);
		CopArac[2] = AddStaticVehicleEx(596,  -2476.3948,2224.7734,4.8438,357.9935, 0, 1, -1, 1);
		CopArac[3] = AddStaticVehicleEx(596,  -2479.0505,2264.1958,4.8359,87.5235, 0, 1, -1, 1);
		CopArac[4] = AddStaticVehicleEx(596,  -2527.6155,2251.6509,4.9737,333.6650, 0, 1, -1, 1);
		CopArac[5] = AddStaticVehicleEx(596,  -2426.4417,2347.4827,4.9688,192.6304, 0, 1, -1, 1);
		CopArac[6] = AddStaticVehicleEx(596,  -2251.9395,2332.8982,4.8125,88.8046, 0, 1, -1, 1);
		CopArac[7] = AddStaticVehicleEx(596,  -2272.0652,2318.4045,4.8202,269.9914, 0, 1, -1, 1);
		CopArac[8] = AddStaticVehicleEx(596,  -2304.2600,2292.5898,4.9844,0.6905, 0, 1, -1, 1);
		CopArac[9] = AddStaticVehicleEx(596,  -2469.1685,2475.5703,17.2439,269.3371, 0, 1, -1, 1);
		CopArac[10] = AddStaticVehicleEx(596, -2353.2964,2462.8259,4.9934,237.1028, 0, 1, -1, 1);
		CopArac[11] = AddStaticVehicleEx(596, -2258.5300,2384.7634,4.9959,44.6086, 0, 1, -1, 1);
		CopArac[12] = AddStaticVehicleEx(596, -2334.8718,2322.7080,4.9844,355.5497 , 0, 1, -1, 1);
        CopArac[13] = AddStaticVehicleEx(596, -2431.8162,2313.6204,4.9844,269.9306, 0, 1, -1, 1);
        CopArac[14] = AddStaticVehicleEx(596, -2498.5815,2289.4668,4.9844,272.2631, 0, 1, -1, 1);
        CopArac[15] = AddStaticVehicleEx(596, -2543.7727,2250.2920,5.0185,332.1378, 0, 1, -1, 1);
        CopArac[16] = AddStaticVehicleEx(596, -2625.7634,2269.0720,8.1391,177.2832, 0, 1, -1, 1);
        CopArac[17] = AddStaticVehicleEx(596, -2495.0332,2411.0330,16.4330,28.2762, 0, 1, -1, 1);
        CopArac[18] = AddStaticVehicleEx(596, -2748.2991,2344.1941,72.7003,276.8735, 0, 1, -1, 1);
        CopArac[19] = AddStaticVehicleEx(596, -2712.9702,2289.8259,59.5798,24.3086, 0, 1, -1, 1);
        CopArac[20] = AddStaticVehicleEx(596, -2340.4138,2467.2539,4.9918,142.7618, 0, 1, -1, 1);
        CopArac[21] = AddStaticVehicleEx(596, -2609.8806,2425.8159,14.5482,166.5654, 0, 1, -1, 1);
        CopArac[22] = AddStaticVehicleEx(596, -2602.3923,2333.4827,7.9029,86.5314 , 0, 1, -1, 1);
        SuspectArac[0] = AddStaticVehicleEx(579, -2382.8843,2437.5144,9.5525,157.3016, 0, 0, -1);
        SuspectArac[1] = AddStaticVehicleEx(579, -2507.9934,2349.1604,4.9865,183.4469, 0, 0, -1);
        SuspectArac[2] = AddStaticVehicleEx(579, -2552.0688,2315.0916,4.9733,96.5115, 0, 0, -1);
		format(OyunSebep, 150, "Bayside bölgesinde dur ihtarýna uymayan þüpheliler telsizden geçildi, þüpheliler siyah renkli bir sedan kullanýyor.");
		}
	}
	return 1;
}
// Oyun moduna harita ekleme
OyuncuOyunDegerSifirla(playerid)
{
	SetPlayerSkin(playerid, (Oyuncu[playerid][Suspect] == true ? Oyuncu[playerid][Kiyafet] : Oyuncu[playerid][pKiyafet]));
	SetPlayerColor(playerid, BEYAZ3);
	ResetPlayerWeapons(playerid);
	TogglePlayerControllable(playerid, 1);
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid, 0);
	Oyuncu[playerid][brutallyWounded] = 0;
	SetPlayerHealth(playerid, 100.0);
	SetPlayerArmour(playerid, 30.0);
	ResetDamageData(playerid);
	SetPVarInt(playerid, "changeseatAsk", -1);
	SetPVarInt(playerid, "onPlayerSwimming", 0);
	SetPVarInt(playerid, "swimmingCount", 20);
	return 1;
}

OyunPolisSayi()
{
	new sayi;
	foreach(new i : Player)
    {
        if(Oyuncu[i][Oyunda] == true && Oyuncu[i][Polis] == true)
        {
        	sayi++;
        }
    }
	return sayi;
}

OyunSuspectSayi()
{
	new sayi;
	foreach(new i : Player)
    {
        if(Oyuncu[i][Oyunda] == true && Oyuncu[i][Suspect] == true)
        {
        	sayi++;
        }
    }
	return sayi;
}

OyuncuSuspectSquadKontrol(playerid)
{
	if(Oyuncu[playerid][Squad][0] != -1 && IsPlayerConnected(Oyuncu[playerid][Squad][0]))
	{
		Oyuncu[Oyuncu[playerid][Squad][0]][Squad][0] = Oyuncu[Oyuncu[playerid][Squad][0]][Squad][1] = -1;
		Oyuncu[Oyuncu[playerid][Squad][0]][Squad][2] = 0;
		Oyuncu[playerid][Squad][0] = Oyuncu[playerid][Squad][1] = -1;
		Oyuncu[playerid][Squad][2] = 0;
	}
}
// suspect verme
OyuncuSuspectYap(oyuncusayi)
{
	new suspect[12];
	SelectRandomPlayers(suspect, 12);
	Oyuncu[suspect[0]][Oyunda] = Oyuncu[suspect[0]][Suspect] = Oyuncu[suspect[0]][OyunModu] = true;
	Oyuncu[suspect[0]][Polis] = Oyuncu[suspect[0]][DM] = Oyuncu[suspect[0]][AracTamir] = Oyuncu[suspect[0]][SuspectSari] = false;
	Oyuncu[suspect[0]][SuspectTimer3] = SetTimerEx("SuspectSakla", TIMER_SANIYE(40), false, "d", suspect[0]);
	Oyuncu[suspect[0]][SuspectTimer2] = SetTimerEx("SuspectSilahVer", TIMER_SANIYE(25), false, "d", suspect[0]);
	Oyuncu[suspect[0]][OyunModTimer] = SetTimerEx("OyunModuTimer", TIMER_SANIYE(10), false, "d", suspect[0]);
	ShowPlayerDialog(suspect[0], DIALOG_OYUNMODU, DIALOG_STYLE_MSGBOX, "Oyun Modu Seçimi", ""#BEYAZ2"Oyun modunu seçiniz.", ""#YESIL2"Roleplay", ""#KIRMIZI2"Non-RP");
	OyuncuSuspectSquadKontrol(suspect[0]);
	Oyuncu[suspect[0]][OyunAracID] = SuspectArac[0];
	Oyuncu[suspect[0]][OyunAracIDKoltuk] = 0;
	AracHasar[SuspectArac[0] && SuspectArac[1] && SuspectArac[2]] = false;
	AracKilitSahip[SuspectArac[0] && SuspectArac[1] && SuspectArac[2]] = -1;
	SetVehicleParamsEx(SuspectArac[0], VEHICLE_PARAMS_ON, VEHICLE_PARAMS_OFF, alarm2, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, objective2);
	SetVehicleParamsEx(SuspectArac[1], VEHICLE_PARAMS_ON, VEHICLE_PARAMS_OFF, alarm2, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, objective2);
	SetVehicleParamsEx(SuspectArac[2], VEHICLE_PARAMS_ON, VEHICLE_PARAMS_OFF, alarm2, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, objective2);
	if(oyuncusayi >= 4)
	{
		OyuncuSuspectSquadKontrol(suspect[1]);
		Oyuncu[suspect[1]][OyunAracID] = SuspectArac[0];
		Oyuncu[suspect[1]][OyunAracIDKoltuk] = 1;
		Oyuncu[suspect[1]][Oyunda] = Oyuncu[suspect[1]][Suspect] = true;
		Oyuncu[suspect[1]][Polis] = Oyuncu[suspect[1]][DM] = Oyuncu[suspect[1]][AracTamir] = Oyuncu[suspect[1]][SuspectSari] = false;
		Oyuncu[suspect[1]][SuspectTimer3] = SetTimerEx("SuspectSakla", TIMER_SANIYE(40), false, "d", suspect[1]);
		Oyuncu[suspect[1]][SuspectTimer2] = SetTimerEx("SuspectSilahVer", TIMER_SANIYE(25), false, "d", suspect[1]);
	}
	if(oyuncusayi >= 8)
	{
		OyuncuSuspectSquadKontrol(suspect[2]);
		Oyuncu[suspect[2]][OyunAracID] = SuspectArac[0];
		Oyuncu[suspect[2]][OyunAracIDKoltuk] = 2;
		Oyuncu[suspect[2]][Oyunda] = Oyuncu[suspect[2]][Suspect] = true;
		Oyuncu[suspect[2]][Polis] = Oyuncu[suspect[2]][DM] = Oyuncu[suspect[2]][AracTamir] = Oyuncu[suspect[2]][SuspectSari] = false;
		Oyuncu[suspect[2]][SuspectTimer3] = SetTimerEx("SuspectSakla", TIMER_SANIYE(40), false, "d", suspect[2]);
		Oyuncu[suspect[2]][SuspectTimer2] = SetTimerEx("SuspectSilahVer", TIMER_SANIYE(25), false, "d", suspect[2]);
	}
	if(oyuncusayi >= 11)
	{
		OyuncuSuspectSquadKontrol(suspect[3]);
		Oyuncu[suspect[3]][OyunAracID] = SuspectArac[0];
		Oyuncu[suspect[3]][OyunAracIDKoltuk] = 3;
		Oyuncu[suspect[3]][Oyunda] = Oyuncu[suspect[3]][Suspect] = true;
		Oyuncu[suspect[3]][Polis] = Oyuncu[suspect[3]][DM] = Oyuncu[suspect[3]][AracTamir] = Oyuncu[suspect[3]][SuspectSari] = false;
		Oyuncu[suspect[3]][SuspectTimer3] = SetTimerEx("SuspectSakla", TIMER_SANIYE(40), false, "d", suspect[3]);
		Oyuncu[suspect[3]][SuspectTimer2] = SetTimerEx("SuspectSilahVer", TIMER_SANIYE(25), false, "d", suspect[3]);
	}
	if(oyuncusayi >= 14)
	{
		OyuncuSuspectSquadKontrol(suspect[4]);
		Oyuncu[suspect[4]][OyunAracID] = SuspectArac[1];
		Oyuncu[suspect[4]][OyunAracIDKoltuk] = 0;
		Oyuncu[suspect[4]][Oyunda] = Oyuncu[suspect[4]][Suspect] = true;
		Oyuncu[suspect[4]][Polis] = Oyuncu[suspect[4]][DM] = Oyuncu[suspect[4]][AracTamir] = Oyuncu[suspect[4]][SuspectSari] = false;
		Oyuncu[suspect[4]][SuspectTimer3] = SetTimerEx("SuspectSakla", TIMER_SANIYE(60), false, "d", suspect[4]);
		Oyuncu[suspect[4]][SuspectTimer2] = SetTimerEx("SuspectSilahVer", TIMER_SANIYE(25), false, "d", suspect[4]);
	}
	if(oyuncusayi >= 17)
	{
		OyuncuSuspectSquadKontrol(suspect[5]);
		Oyuncu[suspect[5]][OyunAracID] = SuspectArac[1];
		Oyuncu[suspect[5]][OyunAracIDKoltuk] = 1;
		Oyuncu[suspect[5]][Oyunda] = Oyuncu[suspect[5]][Suspect] = true;
		Oyuncu[suspect[5]][Polis] = Oyuncu[suspect[5]][DM] = Oyuncu[suspect[5]][AracTamir] = Oyuncu[suspect[5]][SuspectSari] = false;
		Oyuncu[suspect[5]][SuspectTimer3] = SetTimerEx("SuspectSakla", TIMER_SANIYE(60), false, "d", suspect[5]);
		Oyuncu[suspect[5]][SuspectTimer2] = SetTimerEx("SuspectSilahVer", TIMER_SANIYE(25), false, "d", suspect[5]);
	}
    if(oyuncusayi >= 21)
	{
		OyuncuSuspectSquadKontrol(suspect[6]);
		Oyuncu[suspect[6]][OyunAracID] = SuspectArac[1];
		Oyuncu[suspect[6]][OyunAracIDKoltuk] = 2;
		Oyuncu[suspect[6]][Oyunda] = Oyuncu[suspect[6]][Suspect] = true;
		Oyuncu[suspect[6]][Polis] = Oyuncu[suspect[6]][DM] = Oyuncu[suspect[6]][AracTamir] = Oyuncu[suspect[6]][SuspectSari] = false;
		Oyuncu[suspect[6]][SuspectTimer3] = SetTimerEx("SuspectSakla", TIMER_SANIYE(60), false, "d", suspect[6]);
		Oyuncu[suspect[6]][SuspectTimer2] = SetTimerEx("SuspectSilahVer", TIMER_SANIYE(25), false, "d", suspect[6]);
	}
	if(oyuncusayi >= 25)
	{
		OyuncuSuspectSquadKontrol(suspect[7]);
		Oyuncu[suspect[7]][OyunAracID] = SuspectArac[1];
		Oyuncu[suspect[7]][OyunAracIDKoltuk] = 3;
		Oyuncu[suspect[7]][Oyunda] = Oyuncu[suspect[7]][Suspect] = true;
		Oyuncu[suspect[7]][Polis] = Oyuncu[suspect[7]][DM] = Oyuncu[suspect[7]][AracTamir] = Oyuncu[suspect[7]][SuspectSari] = false;
		Oyuncu[suspect[7]][SuspectTimer3] = SetTimerEx("SuspectSakla", TIMER_SANIYE(40), false, "d", suspect[7]);
		Oyuncu[suspect[7]][SuspectTimer2] = SetTimerEx("SuspectSilahVer", TIMER_SANIYE(25), false, "d", suspect[7]);
	}
	if(oyuncusayi >= 30)
	{
		OyuncuSuspectSquadKontrol(suspect[8]);
		Oyuncu[suspect[8]][OyunAracID] = SuspectArac[2];
		Oyuncu[suspect[8]][OyunAracIDKoltuk] = 0;
		Oyuncu[suspect[8]][Oyunda] = Oyuncu[suspect[8]][Suspect] = true;
		Oyuncu[suspect[8]][Polis] = Oyuncu[suspect[8]][DM] = Oyuncu[suspect[8]][AracTamir] = Oyuncu[suspect[8]][SuspectSari] = false;
		Oyuncu[suspect[8]][SuspectTimer3] = SetTimerEx("SuspectSakla", TIMER_SANIYE(60), false, "d", suspect[8]);
		Oyuncu[suspect[8]][SuspectTimer2] = SetTimerEx("SuspectSilahVer", TIMER_SANIYE(25), false, "d", suspect[8]);
	}
	if(oyuncusayi >= 34)
	{
		OyuncuSuspectSquadKontrol(suspect[9]);
		Oyuncu[suspect[9]][OyunAracID] = SuspectArac[2];
		Oyuncu[suspect[9]][OyunAracIDKoltuk] = 1;
		Oyuncu[suspect[9]][Oyunda] = Oyuncu[suspect[9]][Suspect] = true;
		Oyuncu[suspect[9]][Polis] = Oyuncu[suspect[9]][DM] = Oyuncu[suspect[9]][AracTamir] = Oyuncu[suspect[9]][SuspectSari] = false;
		Oyuncu[suspect[9]][SuspectTimer3] = SetTimerEx("SuspectSakla", TIMER_SANIYE(60), false, "d", suspect[9]);
		Oyuncu[suspect[9]][SuspectTimer2] = SetTimerEx("SuspectSilahVer", TIMER_SANIYE(25), false, "d", suspect[9]);
	}
	if(oyuncusayi >= 38)
	{
		OyuncuSuspectSquadKontrol(suspect[10]);
		Oyuncu[suspect[10]][OyunAracID] = SuspectArac[2];
		Oyuncu[suspect[10]][OyunAracIDKoltuk] = 2;
		Oyuncu[suspect[10]][Oyunda] = Oyuncu[suspect[10]][Suspect] = true;
		Oyuncu[suspect[10]][Polis] = Oyuncu[suspect[10]][DM] = Oyuncu[suspect[10]][AracTamir] = Oyuncu[suspect[10]][SuspectSari] = false;
		Oyuncu[suspect[10]][SuspectTimer3] = SetTimerEx("SuspectSakla", TIMER_SANIYE(60), false, "d", suspect[10]);
		Oyuncu[suspect[10]][SuspectTimer2] = SetTimerEx("SuspectSilahVer", TIMER_SANIYE(25), false, "d", suspect[10]);
	}
	if(oyuncusayi >= 42)
	{
		OyuncuSuspectSquadKontrol(suspect[11]);
		Oyuncu[suspect[11]][OyunAracID] = SuspectArac[2];
		Oyuncu[suspect[11]][OyunAracIDKoltuk] = 3;
		Oyuncu[suspect[11]][Oyunda] = Oyuncu[suspect[11]][Suspect] = true;
		Oyuncu[suspect[11]][Polis] = Oyuncu[suspect[11]][DM] = Oyuncu[suspect[11]][AracTamir] = Oyuncu[suspect[11]][SuspectSari] = false;
		Oyuncu[suspect[11]][SuspectTimer3] = SetTimerEx("SuspectSakla", TIMER_SANIYE(60), false, "d", suspect[11]);
		Oyuncu[suspect[11]][SuspectTimer2] = SetTimerEx("SuspectSilahVer", TIMER_SANIYE(25), false, "d", suspect[11]);
	}
}

OyuncuPolisYap()
{
	new aracid = 0, squad1, squad2, squadsurucu, squadyankoltuk, Float: pos[4], bool: AracSurucu[23];
	foreach(new i : Player)
	{
		if(Oyuncu[i][GirisYapti] == true && Oyuncu[i][AFK] == false && Oyuncu[i][Suspect] == false)
		{
			if(Oyuncu[i][Squad][0] != -1 && IsPlayerConnected(Oyuncu[i][Squad][0]))
			{
				squad1 = Oyuncu[i][Squad][0];
				squad2 = Oyuncu[Oyuncu[i][Squad][0]][Squad][0];
				printf("%s - %s", Oyuncuadi(squad1), Oyuncuadi(squad2));
				if(Oyuncu[squad1][Squad][1] == 0) squadsurucu = squad1;
				if(Oyuncu[squad2][Squad][1] == 0) squadsurucu = squad2;
				if(Oyuncu[squad1][Squad][1] == 1) squadyankoltuk = squad1;
				if(Oyuncu[squad2][Squad][1] == 1) squadyankoltuk = squad2;
				if(Oyuncu[squadsurucu][PolisArac] != 0 && Oyuncu[squadsurucu][PolisArac] >= 400)
				{
					GetVehiclePos(CopArac[aracid], pos[0], pos[1], pos[2]);
					GetVehicleZAngle(CopArac[aracid], pos[3]);
					DestroyVehicle(CopArac[aracid]);
					CopArac[aracid] = AddStaticVehicleEx(Oyuncu[squadsurucu][PolisArac], pos[0], pos[1], pos[2], pos[3], 0, 1, -1, 1);
				}
				AracYaratildi[CopArac[aracid]] = true;
				AracHasar[CopArac[aracid]] = AracSirenDurumu[CopArac[aracid]] = false;
				AracKilitSahip[CopArac[aracid]] = -1;
				SetVehicleParamsEx(CopArac[aracid], VEHICLE_PARAMS_ON, VEHICLE_PARAMS_OFF, alarm2, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, objective2);
				Oyuncu[squadsurucu][OyunAracID] = CopArac[aracid];
				Oyuncu[squadsurucu][OyunAracIDKoltuk] = 0;
				Oyuncu[squadyankoltuk][OyunAracID] = CopArac[aracid];
				Oyuncu[squadyankoltuk][OyunAracIDKoltuk] = 1;
				aracid++;
			}
			else
			{
				if(AracSurucu[aracid] == false)
				{
					if(Oyuncu[i][PolisArac] != 0 && Oyuncu[i][PolisArac] >= 400)
					{
						GetVehiclePos(CopArac[aracid], pos[0], pos[1], pos[2]);
						GetVehicleZAngle(CopArac[aracid], pos[3]);
						DestroyVehicle(CopArac[aracid]);
						CopArac[aracid] = AddStaticVehicleEx(Oyuncu[i][PolisArac], pos[0], pos[1], pos[2], pos[3], 0, 1, -1, 1);
					}
					AracSurucu[aracid] = AracYaratildi[CopArac[aracid]] = true;
					AracHasar[CopArac[aracid]] = AracSirenDurumu[CopArac[aracid]] = false;
					AracKilitSahip[CopArac[aracid]] = -1;
					SetVehicleParamsEx(CopArac[aracid], VEHICLE_PARAMS_ON, VEHICLE_PARAMS_OFF, alarm2, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, objective2);
					Oyuncu[i][OyunAracID] = CopArac[aracid];
					Oyuncu[i][OyunAracIDKoltuk] = 0;
				}
			}
			if(AracSurucu[aracid] == true) aracid++;
			Oyuncu[i][Oyunda] = Oyuncu[i][Polis] = Oyuncu[i][OyunSilah] = true;
			Oyuncu[i][Suspect] = Oyuncu[i][AracTamir] = Oyuncu[i][PolisGPS] = Oyuncu[i][ElmDurum] = Oyuncu[i][DM] = false;
			Oyuncu[i][HedefKomut] = Oyuncu[i][TaserMermiDegis] = Oyuncu[i][SuspectSari] = false;
			Oyuncu[i][EngelHak] = Oyuncu[i][EngelSec] = 0;
			for(new j; j < 7; j++) Oyuncu[i][Silah][j] = false;
			SetTimerEx("PolisSilah", TIMER_SANIYE(25), false, "d", i);
		}
	}
}

forward OyunBasliyor(oyunturu);
public OyunBasliyor(oyunturu)
{
	if(OyunSaniye <= 10)
	{
		foreach(new i : Player)
    	{
	        if(Oyuncu[i][Oyunda] == false && Oyuncu[i][GirisYapti] == true && Oyuncu[i][AFK] == false && Oyuncu[i][DM] == true)
	        {
	        	YollaIpucuMesaj(i, "Oyun baþlayacaðý için lobiye gönderildin.");
	        	LobiyeDon(i);
	        }
	    }
	}
	new mesaj[100];
	format(mesaj, sizeof(mesaj), "~w~Oyun baslamasina... %d", OyunSaniye);
	OyunSaniye--;
	GameTextForAll(mesaj, 1000, 4);
	if(OyuncuSayisi() < 2)
	{
		OyunSaniye = OYUN_SANIYE;
		OyunDakika = OYUN_DAKIKA;
		OyunDakikaSaniye = OYUN_DAKIKASANIYE;
		OyunBasladi = OyunSayac = false;
		KillTimer(OyunTimer);
		return 1;
	}
	if(OyunSaniye <= 0)
	{
		OyunKontrolTimer = SetTimer("OyunKontrol", TIMER_SANIYE(7), true);

		for(new aracid; aracid < 23; aracid++) AracYaratildi[CopArac[aracid]] = false;
		OyunBasladi = true;
		OyunModuTip = 0;
		HerkesFreeze = SuspectAtes = false;
		new oyuncusayi = OyuncuSayisi();
		OyunAraclariYarat(oyunturu);
		OyuncuSuspectYap(oyuncusayi);
		OyuncuPolisYap();
		OyunDakika = OYUN_DAKIKA;
		OyunDakikaSaniye = OYUN_DAKIKASANIYE;
		SetTimer("OyuncuAracCarpisma", TIMER_SANIYE(15), false);
		SuspectSaklaTimer = SetTimer("SuspectCCTV", TIMER_DAKIKA(1), true);
		OyunKalanTimer = SetTimer("OyunKalanSure", TIMER_SANIYE(1), true);
		AracKontrolTimer = SetTimer("AracKontrol", 500, true);
		SetTimer("OyuncuAracYerlestir", 500, false);
		KillTimer(OyunTimer);
		SetTimer("OyunRenkleriDuzelt", TIMER_SANIYE(1), false);
		YollaHerkeseMesaj(TURUNCU, OyunSebep);
		for(new aracid; aracid < 23; aracid++)
			if(IsValidVehicle(CopArac[aracid]) && AracYaratildi[CopArac[aracid]] == false)
				DestroyVehicle(CopArac[aracid]);

		OyunArac[0] = AddStaticVehicleEx(497, -2464.971, 2232.431, 5.002, 0.0, 0, 1, -1, 1);
		OyunArac[1] = AddStaticVehicleEx(430, -2235.382, 2392.731, -0.181, 0.0, 0, 1, -1, 1);
		OyunArac[2] = AddStaticVehicleEx(497, -2227.228, 2325.099, 7.724, 0.0, 0, 1, -1, 1);
		OyunArac[3] = AddStaticVehicleEx(430, -2232.117, 2430.063, -0.224, 0.0, 0, 1, -1, 1);
		OyunArac[4] = AddStaticVehicleEx(497, -1677.762, 707.221, 30.778, 0.0, 0, 1, -1, 1);
		OyunArac[5] = AddStaticVehicleEx(430, 2926.821, -2044.065, -0.345, 0.0, 0, 1, -1, 1);
		OyunArac[6] = AddStaticVehicleEx(497, 2314.149, 2449.964, 10.997, 0.0, 0, 1, -1, 1);
		OyunArac[7] = AddStaticVehicleEx(430, 201.571, -1909.995, -0.168, 0.0, 0, 1, -1, 1);
		OyunArac[8] = AddStaticVehicleEx(497, 1557.386, -1611.595, 13.559, 0.0, 0, 1, -1, 1);
		OyunArac[9] = AddStaticVehicleEx(430, -927.899, 2647.256, 40.387, 0.0, 0, 1, -1, 1);
		OyunArac[10] = AddStaticVehicleEx(430, -927.899, 2647.256, 40.387, 0.0, 0, 1, -1, 1);
		for(new aracid; aracid < 11; aracid++)
		{
			AracHasar[OyunArac[aracid]] = AracSirenDurumu[OyunArac[aracid]] = false;
			AracKilitSahip[OyunArac[aracid]] = -1;
			SetVehicleParamsEx(OyunArac[aracid], VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, alarm2, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, objective2);
		}
		return 1;
	}

	return 1;
}

forward OyuncuAracYerlestir();
public OyuncuAracYerlestir()
{
	foreach(new i : Player)
	{
		if(Oyuncu[i][GirisYapti] == true && Oyuncu[i][Oyunda] == true && Oyuncu[i][OyunAracID] > 0)
		{
			OyuncuOyunDegerSifirla(i);
			DisableRemoteVehicleCollisions(i, 1);
			PutPlayerInVehicle(i, Oyuncu[i][OyunAracID], Oyuncu[i][OyunAracIDKoltuk]);
		}
	}
	return 1;
}

forward OyuncuAracCarpisma();
public OyuncuAracCarpisma()
{
	foreach(new i : Player) if(Oyuncu[i][GirisYapti] == true && Oyuncu[i][Oyunda] == true) DisableRemoteVehicleCollisions(i, 0);
	return 1;
}

forward OyunRenkleriDuzelt();
public OyunRenkleriDuzelt()
{
	foreach(new i : Player)
	{
		if(Oyuncu[i][GirisYapti] == true && Oyuncu[i][Oyunda] == true)
		{
			if(Oyuncu[i][Polis] == true)
				SetPlayerColor(i, POLIS_RENK2);
			if(Oyuncu[i][Suspect] == true)
				SetPlayerColor(i, SUSPECT_RENK);
		}
		else SetPlayerColor(i, BEYAZ3);
	}
	return 1;
}

GetDamageType(weaponid)
{
	new damageType[32] = EOS;

	switch(weaponid)
	{
		case 0 .. 3, 5 .. 7, 10 .. 15: damageType = "Hafif Travma";
		case 4, 8, 9: damageType = "Býçak Yarasý";
		case 22 .. 34: damageType = "Kurþun Yarasý";
		case 18, 35, 36, 37, 16, 39, 40: damageType = "Yanýk/Patlayýcý Yarasý";
		default: damageType = "Bilinmeyen Yaralanma";
	}
	return damageType;
}

forward ResetDamageData(playerid);
public ResetDamageData(playerid)
{
	for(new i = 0; i < MAX_DAMAGES; i++) {
		if(DamageData[i][DamagePlayerID] == playerid) {
			DamageData[i][DamagePlayerID] = INVALID_PLAYER_ID;
			DamageData[i][DamageReason] = EOS;
			DamageData[i][DamageWeapon] = INVALID_WEAPON_ID;
			DamageData[i][DamageAmount] = 0.0;
			DamageData[i][DamageBodyPart] = 0;
		}
	}
	return true;
}

forward SaveDamageData(playerid, weaponid, bodypart, Float:amount);
public SaveDamageData(playerid, weaponid, bodypart, Float:amount)
{
	totalDamages ++;
	new i = totalDamages;

	DamageData[i][DamagePlayerID] = playerid;

	DamageData[i][DamageBodyPart] = bodypart;
	DamageData[i][DamageWeapon] = weaponid;
	DamageData[i][DamageAmount] = amount;
	return true;
}

GetBoneDamaged(bodypart)
{
	new bodypartR[20] = EOS;
	switch(bodypart)
	{
		case BODY_PART_CHEST: bodypartR = "Göðüs";
		case BODY_PART_TORSO: bodypartR = "Gövde";
		case BODY_PART_LEFT_ARM: bodypartR = "Sol Kol";
		case BODY_PART_RIGHT_ARM: bodypartR = "Sol Kol";
		case BODY_PART_LEFT_LEG: bodypartR = "Sol Bacak";
		case BODY_PART_RIGHT_LEG: bodypartR = "Sað Bacak";
		case BODY_PART_HEAD: bodypartR = "Kafa";
	}
	return bodypartR;
}

forward DisplayDamageData(playerid, forplayerid);
public DisplayDamageData(playerid, forplayerid)
{
	new count = 0;
	for(new i = 0; i < MAX_DAMAGES; i++) {
		if(DamageData[i][DamagePlayerID] == playerid) {
			count++;
		}
	}

	if(!count) return SendClientMessage(forplayerid, -1, "Bu kiþi baygýn deðil.");

	new longstr[512] = EOS, weaponname[20] = EOS;
	for(new i = 0; i < MAX_DAMAGES; i++) {
		if(DamageData[i][DamagePlayerID] == playerid)
		{
			GetWeaponName(DamageData[i][DamageWeapon], weaponname, sizeof(weaponname));
			format(longstr, sizeof(longstr), "%s(%s - %s) %s\n", longstr, GetDamageType(DamageData[i][DamageWeapon]), GetBoneDamaged(DamageData[i][DamageBodyPart]), weaponname);
		}
	}

	ShowPlayerDialog(playerid, DIALOG_HASARLAR, DIALOG_STYLE_LIST, "Hasar Bilgileri", longstr, "Tamam", "");
	return true;
}

forward GetDistanceBetweenPlayers(playerid, id, Float:distance);
public GetDistanceBetweenPlayers(playerid, id, Float:distance)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(id) && GetPlayerInterior(playerid) == GetPlayerInterior(id)) {
		if(IsPlayerInRangeOfPoint(id, distance, x, y, z)) {
			return true;
		}
	}
	return false;
}

/*forward TackleModex(playerid); public TackleModex(playerid)
{
	SetPlayerDrunkLevel(playerid, 1000);
	TogglePlayerControllable(playerid, 1);

	ApplyAnimation(playerid, "PED", "KO_skid_front", 4.1, 0, 1, 1, 1, 0);
	Karakter[playerid][TackleMode] = false;
	return 1;
}*/

ReturnDate()
{
    new sendString[90], MonthStr[40], month, day, year;
    new hour, minute, second;

    gettime(hour, minute, second);
    getdate(year, month, day);
    switch(month)
    {
        case 1:  MonthStr = "01";
        case 2:  MonthStr = "02";
        case 3:  MonthStr = "03";
        case 4:  MonthStr = "04";
        case 5:  MonthStr = "05";
        case 6:  MonthStr = "06";
        case 7:  MonthStr = "07";
        case 8:  MonthStr = "08";
        case 9:  MonthStr = "09";
        case 10: MonthStr = "10";
        case 11: MonthStr = "11";
        case 12: MonthStr = "12";
    }

    format(sendString, 90, "%02d/%s/%d, %02d:%02d:%02d", day, MonthStr, year, hour, minute, second);
    return sendString;
}

SetPlayerSkinEx(playerid, skinid)
{
    if(!skinid) skinid = Oyuncu[playerid][Kiyafet];

    if(!Oyuncu[playerid][Kiyafet]) skinid = random(311) + 1;

    Oyuncu[playerid][Kiyafet] = skinid;

    return SetPlayerSkin(playerid, skinid);
}

stock FlipVehicle(vehicleid)
{
	new
	    Float:fAngle;

	GetVehicleZAngle(vehicleid, fAngle);

	SetVehicleZAngle(vehicleid, fAngle);
	SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
}

GetVehicleDriver(vehicleid)
{
    foreach(new i : Player)
    {
        if(!IsPlayerConnected(i) || GetPlayerState(i) != PLAYER_STATE_DRIVER) continue;

        if(GetPlayerVehicleID(i) == vehicleid)
            return i;
   }

    return -1;
}

/*getRandomPlayer()
{
    new count = 0, randomid = INVALID_PLAYER_ID;

    while(randomid == INVALID_PLAYER_ID || !IsPlayerConnected(randomid) || !Oyuncu[randomid][GirisYapti])
    {
        count++;
        randomid = random(MAX_PLAYERS);
        if (count > 200 || IsPlayerConnected(randomid)) break;
    }
    return randomid;
}*/

Player_Info(playerid, text[], bool:forced = false)
{
	if(Oyuncu[playerid][pBoxShowed] == true && !forced)
		return 1;

	PlayerTextDrawHide(playerid, Oyuncu[playerid][pTextdraws][1]);
	PlayerTextDrawSetString(playerid, Oyuncu[playerid][pTextdraws][1], text);
	PlayerTextDrawShow(playerid, Oyuncu[playerid][pTextdraws][1]);

	SetTimerEx("DeleteInfoBox", 2500, false, "d", playerid);
	Oyuncu[playerid][pBoxShowed] = true;

	return 1;
}

DeleteInfoBox(playerid); public DeleteInfoBox(playerid)
{
	PlayerTextDrawHide(playerid, Oyuncu[playerid][pTextdraws][1]);

	Oyuncu[playerid][pBoxShowed] = false;

	return 1;
}

SilahAdi(silahid)
{
    new silahadi[40];
    GetWeaponName(silahid, silahadi, sizeof(silahadi));
    return silahadi;
}

/*public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    if(Oyuncu[playerid][Yonetici] < 1 || PlayerInfo[playerid][Rehineyim]) return 0;

    Oyuncu[playerid][pClickedX] = fX;
    Oyuncu[playerid][pClickedY] = fY;
    MapAndreas_FindZ_For2DCoord(fX, fY, Oyuncu[playerid][pClickedZ]);

    return Oyuncu[playerid][pClickedTick] = GetTickCount();
}*/

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
    new id = clickedplayerid;
    if (!IsPlayerConnected(id)) return 1;
    new dialog[512];
    new Float:kda;
    kda = Oyuncu[id][Oldurme] / Oyuncu[id][Olum];
    format(dialog, sizeof(dialog), "{00FF00}Hesap: {FFFFFF}%s\n{00FF00}Öldürme: {FFFFFF}%d\n{00FF00}Ölme: {FFFFFF}%d\n{00FF00}Þüpheli Kazanma: {FFFFFF}%d\n{00FF00}KD: {FFFFFF}%.1f", Oyuncuadi(id), Oyuncu[id][Oldurme], Oyuncu[id][Olum], Oyuncu[id][SuspectKazanma], kda);
    ShowPlayerDialog(playerid, DIALOG_X, DIALOG_STYLE_MSGBOX, "S-PP", dialog, "Kapat", "");
    return 1;
}

stock AdminMessage(color, const str[], {Float,_}:...)
{
    static
        args,
        start,
        end,
        string[144]
    ;
    #emit LOAD.S.pri 8
    #emit STOR.pri args

    if (args > 8)
    {
        #emit ADDR.pri str
        #emit STOR.pri start

        for (end = start + (args - 8); end > start; end -= 4)
        {
            #emit LREF.pri end
            #emit PUSH.pri
        }
        #emit PUSH.S str
        #emit PUSH.C 144
        #emit PUSH.C string

        #emit LOAD.S.pri 8
        #emit ADD.C 4
        #emit PUSH.pri

        #emit SYSREQ.C format
        #emit LCTRL 5
        #emit SCTRL 4

        foreach (new i : Player)
        {
            if (Oyuncu[i][Yonetici] >= 1 )
			{
                  SendClientMessage(i, color, string);
            }
        }
        return 1;
   }
    return 1;
}

HaritalariYukle()
{
//Objects////////////////////////////////////////////////////////////////////////////////////////////////////////
new tmpobjid;
tmpobjid = CreateDynamicObject(1649, 1404.309448, -27.373491, 999.864013, 270.000000, 270.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 15055, "svlamid", "AH_flroortile3", 0xB4FFFFFF);
tmpobjid = CreateDynamicObject(1649, 1397.645385, -27.373292, 999.864013, 270.000000, 270.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 15055, "svlamid", "AH_flroortile3", 0xB4FFFFFF);
tmpobjid = CreateDynamicObject(19381, 1402.732788, -34.017120, 1007.366088, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1396.169555, -28.200950, 1005.163635, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(1649, 1400.976318, -27.373491, 999.864013, 270.000000, 270.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 15055, "svlamid", "AH_flroortile3", 0xB4FFFFFF);
tmpobjid = CreateDynamicObject(1649, 1407.640502, -27.373491, 999.864013, 270.000000, 270.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 15055, "svlamid", "AH_flroortile3", 0xB4FFFFFF);
tmpobjid = CreateDynamicObject(19377, 1404.488891, -25.240951, 1005.163635, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1394.859130, -25.240951, 1005.163635, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(1649, 1397.645385, -31.813295, 999.864013, 270.000000, 270.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 15055, "svlamid", "AH_flroortile3", 0xB4FFFFFF);
tmpobjid = CreateDynamicObject(1649, 1400.975830, -31.813295, 999.864013, 270.000000, 270.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14758, "sfmansion1", "AH_flroortile6", 0xB4FFFFFF);
tmpobjid = CreateDynamicObject(1649, 1404.306274, -31.813295, 999.864013, 270.000000, 270.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14758, "sfmansion1", "AH_flroortile6", 0xB4FFFFFF);
tmpobjid = CreateDynamicObject(1649, 1407.635742, -31.813295, 999.864013, 270.000000, 270.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 15055, "svlamid", "AH_flroortile3", 0xB4FFFFFF);
tmpobjid = CreateDynamicObject(1649, 1407.635742, -36.253280, 999.864013, 270.000000, 270.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 15055, "svlamid", "AH_flroortile3", 0xB4FFFFFF);
tmpobjid = CreateDynamicObject(1649, 1404.305786, -36.253280, 999.864013, 270.000000, 270.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14758, "sfmansion1", "AH_flroortile6", 0xB4FFFFFF);
tmpobjid = CreateDynamicObject(1649, 1400.975830, -36.253280, 999.864013, 270.000000, 270.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14758, "sfmansion1", "AH_flroortile6", 0xB4FFFFFF);
tmpobjid = CreateDynamicObject(1649, 1397.647094, -36.253280, 999.864013, 270.000000, 270.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 15055, "svlamid", "AH_flroortile3", 0xB4FFFFFF);
tmpobjid = CreateDynamicObject(1649, 1397.651000, -40.696590, 999.864013, 270.000000, 270.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 15055, "svlamid", "AH_flroortile3", 0xB4FFFFFF);
tmpobjid = CreateDynamicObject(1649, 1400.983032, -40.696590, 999.864013, 270.000000, 270.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 15055, "svlamid", "AH_flroortile3", 0xB4FFFFFF);
tmpobjid = CreateDynamicObject(1649, 1404.315063, -40.696590, 999.864013, 270.000000, 270.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 15055, "svlamid", "AH_flroortile3", 0xB4FFFFFF);
tmpobjid = CreateDynamicObject(1649, 1407.646240, -40.696590, 999.864013, 270.000000, 270.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 15055, "svlamid", "AH_flroortile3", 0xB4FFFFFF);
tmpobjid = CreateDynamicObject(19360, 1396.164916, -34.610271, 1004.925048, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1396.169555, -41.020984, 1005.163635, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1409.279907, -41.020984, 1005.163635, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19360, 1409.274902, -34.610271, 1004.925048, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1409.279296, -28.190950, 1005.163635, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19376, 1390.857543, -34.373466, 999.938903, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 18031, "cj_exp", "mp_furn_floor", 0x00000000);
tmpobjid = CreateDynamicObject(19376, 1380.375610, -34.373466, 999.938903, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 18031, "cj_exp", "mp_furn_floor", 0x00000000);
tmpobjid = CreateDynamicObject(18809, 1402.669555, -44.951599, 1031.034545, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
tmpobjid = CreateDynamicObject(19376, 1425.009887, -34.373466, 999.938903, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 18031, "cj_exp", "mp_furn_floor", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1404.478881, -42.620971, 1005.163635, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1400.907104, -42.630970, 1005.163635, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1392.412719, -38.067108, 1006.465515, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "ws_carpark2", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1397.568481, -34.020980, 1011.633422, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 2423, "cj_ff_counters", "CJ_Laminate1", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1407.898071, -34.020980, 1011.633422, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 2423, "cj_ff_counters", "CJ_Laminate1", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1403.168457, -38.750949, 1011.633422, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 2423, "cj_ff_counters", "CJ_Laminate1", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1402.307617, -38.760948, 1011.633422, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 2423, "cj_ff_counters", "CJ_Laminate1", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1402.297607, -29.280946, 1011.633422, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 2423, "cj_ff_counters", "CJ_Laminate1", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1403.167968, -29.270946, 1011.633422, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 2423, "cj_ff_counters", "CJ_Laminate1", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1392.412719, -28.447111, 1006.465515, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "ws_carpark2", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1413.043701, -28.447111, 1006.465515, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "ws_carpark2", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1413.043701, -38.057125, 1006.465515, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_laglasswall2", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1402.554077, -43.477142, 1006.465393, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "ws_carpark2", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1402.554077, -24.557146, 1006.465393, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "ws_carpark2", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1403.973144, -47.327140, 999.985290, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1393.473510, -47.327140, 999.985290, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1391.033691, -41.007144, 999.975280, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1391.033691, -28.207153, 999.985290, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1401.463867, -20.527153, 999.985290, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1411.933349, -20.527153, 999.985290, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1424.922485, -28.197170, 999.985290, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14623, "mafcasmain", "casino_carp", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1414.432983, -40.997192, 999.985290, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(19376, 1414.516845, -34.373466, 999.938903, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 18031, "cj_exp", "mp_furn_floor", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1414.158203, -44.094821, 1005.225097, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1381.658081, -44.094821, 1005.225097, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1391.309326, -25.354824, 1005.225097, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1380.532836, -28.207153, 999.985290, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14623, "mafcasmain", "casino_carp", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1380.543579, -41.007144, 999.985290, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14623, "mafcasmain", "casino_carp", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1381.670654, -25.354824, 1005.225097, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1414.432983, -28.197170, 999.985290, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1424.914184, -40.997192, 999.985290, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14623, "mafcasmain", "casino_carp", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1376.839111, -39.224811, 1005.225097, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1376.839111, -29.594829, 1005.225097, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1381.427124, -25.394859, 1006.954833, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1423.788940, -44.094821, 1005.225097, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1414.139404, -25.354824, 1005.225097, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1423.760498, -25.354824, 1005.225097, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1428.571044, -30.174802, 1005.225097, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1428.571044, -39.804821, 1005.225097, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1413.043701, -39.257106, 1006.435485, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "ws_carpark2", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1413.033691, -38.057117, 1006.455505, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 9514, "711_sfw", "ws_carpark2", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1425.005004, -29.627101, 1006.435485, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_laglasswall2", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1414.524047, -39.257106, 1006.415466, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_laglasswall2", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1390.845703, -39.257106, 1006.435485, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_laglasswall2", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1390.845703, -29.637132, 1006.435485, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_laglasswall2", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1380.356933, -29.637132, 1006.435485, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_laglasswall2", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1380.356933, -39.267131, 1006.435485, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_laglasswall2", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1418.281860, -28.204809, 1005.225097, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1418.281860, -41.004840, 1005.225097, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1386.458007, -28.214809, 1005.225097, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1386.458007, -41.004806, 1005.225097, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(14793, 1402.967163, -28.154233, 1007.144775, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1414.623046, -28.197170, 999.995300, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14623, "mafcasmain", "casino_carp", 0x00000000);
tmpobjid = CreateDynamicObject(644, 1427.372924, -34.577136, 1000.344482, 0.000000, 0.000000, -39.900005, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 4003, "cityhall_tr_lan", "foliage256", 0xFFFFFF66);
tmpobjid = CreateDynamicObject(1897, 1409.225097, -36.259738, 1001.014587, 0.000000, 0.000007, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(1897, 1409.225097, -36.259738, 1002.064514, 0.000000, 0.000007, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(1897, 1409.325195, -36.259738, 1001.014587, 0.000000, 0.000007, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(1897, 1409.325195, -36.259738, 1002.064636, 0.000000, 0.000007, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(1897, 1396.103271, -36.259738, 1001.014587, 0.000000, 0.000014, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(1897, 1396.103271, -36.259738, 1002.064514, 0.000000, 0.000014, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(1897, 1396.203369, -36.259738, 1001.014587, 0.000000, 0.000014, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(1897, 1396.203369, -36.259738, 1002.064636, 0.000000, 0.000014, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(1897, 1396.223388, -32.949741, 1001.014587, 0.000000, 0.000014, 179.999893, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(1897, 1396.223388, -32.949741, 1002.064514, 0.000000, 0.000014, 179.999893, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(1897, 1396.123291, -32.949741, 1001.014587, 0.000000, 0.000014, 179.999893, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(1897, 1396.123291, -32.949741, 1002.064636, 0.000000, 0.000014, 179.999893, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(1897, 1396.123291, -32.949741, 1002.064636, 0.000000, 0.000014, 179.999893, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(1897, 1409.334472, -32.949741, 1001.014587, 0.000000, 0.000007, 179.999847, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(1897, 1409.334472, -32.949741, 1002.064514, 0.000000, 0.000007, 179.999847, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(1897, 1409.234375, -32.949741, 1001.014587, 0.000000, 0.000007, 179.999847, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(1897, 1409.234375, -32.949741, 1002.064636, 0.000000, 0.000007, 179.999847, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(1897, 1409.334106, -34.084712, 1003.250610, -89.999992, -424.263793, 115.736152, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(1897, 1409.334106, -35.134639, 1003.250610, -89.999992, -424.263793, 115.736152, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(1897, 1409.234008, -34.114711, 1003.250610, -89.999992, -424.263793, 115.736152, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(1897, 1409.234008, -35.094760, 1003.250610, -89.999992, -424.263793, 115.736152, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(1897, 1396.228881, -34.124710, 1003.250610, -89.999992, -436.513366, 103.486541, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(1897, 1396.228881, -35.084640, 1003.250610, -89.999992, -436.513366, 103.486541, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(1897, 1396.128784, -34.084712, 1003.250610, -89.999992, -436.513366, 103.486541, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(1897, 1396.128784, -35.084762, 1003.250610, -89.999992, -436.513366, 103.486541, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "ws_runwaytarmac", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1391.287841, -44.094821, 1005.225097, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1381.427124, -44.064933, 1006.954833, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1391.297119, -44.064933, 1006.954833, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
tmpobjid = CreateDynamicObject(18075, 1402.866699, -24.739551, 1006.293823, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14786, "ab_sfgymbeams", "knot_wood128", 0x00000000);
tmpobjid = CreateDynamicObject(18809, 1402.669555, -44.961597, 1028.945190, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 18065, "ab_sfammumain", "shelf_glas", 0xFFCCFFFF);
tmpobjid = CreateDynamicObject(19377, 1396.147216, -40.964931, 1006.954833, 0.000000, 0.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1386.297241, -28.214809, 1005.225097, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1386.287841, -41.004806, 1005.225097, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1386.466552, -40.964931, 1006.954833, 0.000000, 0.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1386.286376, -40.964931, 1006.954833, 0.000000, 0.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1386.286376, -28.214942, 1006.954833, 0.000000, 0.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1386.476562, -28.214942, 1006.954833, 0.000000, 0.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1386.426513, -28.234943, 1006.954833, 0.000000, 0.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1376.846435, -30.264940, 1006.954833, 0.000000, 0.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1376.846435, -39.894962, 1006.954833, 0.000000, 0.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1381.578247, -44.054821, 1011.195129, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1391.267944, -44.054821, 1011.195129, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1391.267944, -25.424825, 1011.195129, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1381.419067, -25.424825, 1011.195129, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1376.848022, -30.214836, 1011.195129, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1396.127563, -28.184843, 1006.965393, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1376.848022, -39.714836, 1011.195129, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1396.147583, -34.364868, 1008.385864, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1386.477050, -40.964843, 1011.195129, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1386.306884, -40.964843, 1011.195129, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1386.276855, -40.964843, 1011.195129, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1391.256591, -25.394859, 1006.954833, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1386.276855, -28.224836, 1011.195129, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1386.487060, -28.244836, 1011.195129, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1386.416992, -28.244836, 1011.195129, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1414.534545, -29.627101, 1006.415466, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_laglasswall2", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1424.993408, -39.257106, 1006.415466, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_laglasswall2", 0x00000000);
tmpobjid = CreateDynamicObject(2184, 1403.783935, -39.854305, 999.864013, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 1, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
tmpobjid = CreateDynamicObject(2184, 1406.133178, -41.593799, 999.864013, 0.000000, 0.000000, 137.599960, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 1, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
tmpobjid = CreateDynamicObject(2184, 1400.871093, -40.164043, 999.864013, 0.000000, 0.000000, -137.199996, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 1, 14652, "ab_trukstpa", "CJ_WOOD6", 0x00000000);
tmpobjid = CreateDynamicObject(631, 1408.669799, -41.977016, 1000.803955, 0.000000, 0.000000, -32.099994, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 17958, "burnsalpha", "plantb256", 0xFFCCFF33);
tmpobjid = CreateDynamicObject(631, 1396.751342, -41.985996, 1000.803955, 0.000000, 0.000000, -32.099994, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 17958, "burnsalpha", "plantb256", 0xFFCCFF33);
tmpobjid = CreateDynamicObject(1722, 1409.109863, -36.651313, 999.864013, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampwhite", 0x00000000);
SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "vgsn_scrollsgn256", 0x00000000);
tmpobjid = CreateDynamicObject(1722, 1409.109863, -37.281314, 999.864013, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampwhite", 0x00000000);
SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "vgsn_scrollsgn256", 0x00000000);
tmpobjid = CreateDynamicObject(1722, 1409.109863, -37.911300, 999.864013, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampwhite", 0x00000000);
SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "vgsn_scrollsgn256", 0x00000000);
tmpobjid = CreateDynamicObject(1722, 1409.109863, -38.531288, 999.864013, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampwhite", 0x00000000);
SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "vgsn_scrollsgn256", 0x00000000);
tmpobjid = CreateDynamicObject(1722, 1409.109863, -39.161273, 999.864013, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampwhite", 0x00000000);
SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "vgsn_scrollsgn256", 0x00000000);
tmpobjid = CreateDynamicObject(1722, 1396.379638, -36.581264, 999.864013, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampwhite", 0x00000000);
SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "vgsn_scrollsgn256", 0x00000000);
tmpobjid = CreateDynamicObject(1722, 1396.379638, -37.211257, 999.864013, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampwhite", 0x00000000);
SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "vgsn_scrollsgn256", 0x00000000);
tmpobjid = CreateDynamicObject(1722, 1396.379638, -37.841243, 999.864013, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampwhite", 0x00000000);
SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "vgsn_scrollsgn256", 0x00000000);
tmpobjid = CreateDynamicObject(1722, 1396.379638, -38.461242, 999.864013, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampwhite", 0x00000000);
SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "vgsn_scrollsgn256", 0x00000000);
tmpobjid = CreateDynamicObject(1722, 1396.379638, -39.091236, 999.864013, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 18996, "mattextures", "sampwhite", 0x00000000);
SetDynamicObjectMaterial(tmpobjid, 1, 19426, "all_walls", "vgsn_scrollsgn256", 0x00000000);
tmpobjid = CreateDynamicObject(638, 1407.083496, -25.834327, 1000.584472, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "stoneclad1", 0x00000000);
tmpobjid = CreateDynamicObject(638, 1398.364379, -25.834327, 1000.584472, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 16136, "des_telescopestuff", "stoneclad1", 0x00000000);
tmpobjid = CreateDynamicObject(19538, 1384.041259, -54.108524, 999.864013, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, -1, "none", "none", 0x00FFFFFF);
tmpobjid = CreateDynamicObject(19377, 1396.107421, -30.264833, 1011.195129, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1396.107421, -39.884849, 1011.195129, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1409.287597, -28.184843, 1006.965393, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1409.287597, -37.784854, 1008.415893, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1409.287597, -41.004837, 1006.965637, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1418.268188, -40.994827, 1006.965637, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1418.288208, -40.994842, 1006.965637, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1428.559326, -39.204826, 1006.965637, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1428.559326, -29.584835, 1006.965637, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1418.269409, -28.214839, 1006.965637, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1418.309448, -28.214839, 1006.965637, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1414.079589, -25.364812, 1006.965637, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1423.699462, -25.364812, 1006.965637, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1414.179565, -44.084785, 1006.965637, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1423.789184, -44.084785, 1006.965637, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14581, "ab_mafiasuitea", "walp45S", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1414.157836, -25.374824, 1011.195129, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1423.758300, -25.374824, 1011.195129, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1414.150024, -44.064823, 1011.195129, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1423.770141, -44.064823, 1011.195129, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1428.541503, -39.284839, 1011.195129, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1428.541503, -29.654846, 1011.195129, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1418.241333, -28.224853, 1011.195129, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1418.331420, -28.224853, 1011.195129, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1418.331420, -40.984893, 1011.195129, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1418.261352, -40.984889, 1011.195129, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1409.321044, -39.174877, 1011.195129, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19377, 1409.321044, -29.604871, 1011.195129, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(631, 1396.748291, -26.681325, 1000.803955, 0.000000, 0.000000, -92.499992, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 17958, "burnsalpha", "plantb256", 0xFFCCFF33);
tmpobjid = CreateDynamicObject(631, 1408.747314, -26.776283, 1000.803955, 0.000000, 0.000000, -48.200031, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 17958, "burnsalpha", "plantb256", 0xFFCCFF33);
tmpobjid = CreateDynamicObject(2266, 1408.690429, -32.152095, 1002.214294, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 1, 3899, "hospital2", "hospitalboard_128a", 0x00000000);
tmpobjid = CreateDynamicObject(1649, 1409.257690, -32.123214, 1002.124206, 360.000000, 90.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xAAFFFFFF);
SetDynamicObjectMaterial(tmpobjid, 1, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1414.623779, -40.997192, 999.995300, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14623, "mafcasmain", "casino_carp", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1390.903564, -41.007144, 999.995300, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14623, "mafcasmain", "casino_carp", 0x00000000);
tmpobjid = CreateDynamicObject(19381, 1390.963623, -28.207153, 999.995300, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14623, "mafcasmain", "casino_carp", 0x00000000);
tmpobjid = CreateDynamicObject(1649, 1409.257690, -37.073215, 1002.124206, 360.000000, 90.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xAAFFFFFF);
SetDynamicObjectMaterial(tmpobjid, 1, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
tmpobjid = CreateDynamicObject(1649, 1409.257690, -37.073215, 1002.124206, 360.000000, 90.000000, 450.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xAAFFFFFF);
SetDynamicObjectMaterial(tmpobjid, 1, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
tmpobjid = CreateDynamicObject(1649, 1409.257690, -32.123214, 1002.124206, 360.000000, 90.000000, 450.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xAAFFFFFF);
SetDynamicObjectMaterial(tmpobjid, 1, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
tmpobjid = CreateDynamicObject(1649, 1396.157714, -32.123214, 1002.124206, 360.000000, 90.000000, 450.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xAAFFFFFF);
SetDynamicObjectMaterial(tmpobjid, 1, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
tmpobjid = CreateDynamicObject(1649, 1396.157714, -37.133262, 1002.124206, 360.000000, 90.000000, 450.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xAAFFFFFF);
SetDynamicObjectMaterial(tmpobjid, 1, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
tmpobjid = CreateDynamicObject(1649, 1396.157714, -37.133262, 1002.124206, 360.000000, 90.000000, 630.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xAAFFFFFF);
SetDynamicObjectMaterial(tmpobjid, 1, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
tmpobjid = CreateDynamicObject(1649, 1396.157714, -32.123214, 1002.124206, 360.000000, 90.000000, 630.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 8496, "lowbuild03_lvs", "vgshopwall03_64", 0xAAFFFFFF);
SetDynamicObjectMaterial(tmpobjid, 1, 8396, "sphinx01", "luxorceiling02_128", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1409.265136, -33.781269, 1002.294494, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 13816, "lahills_safe1", "gry_roof", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1409.265136, -33.781269, 1003.244995, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 13816, "lahills_safe1", "gry_roof", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1409.265136, -35.421241, 1003.244995, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 13816, "lahills_safe1", "gry_roof", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1409.265136, -35.421241, 1002.294494, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 13816, "lahills_safe1", "gry_roof", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1396.145385, -35.451240, 1002.294494, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 13816, "lahills_safe1", "gry_roof", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1396.145385, -35.451240, 1003.504577, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 13816, "lahills_safe1", "gry_roof", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1396.145385, -33.781246, 1003.504577, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 13816, "lahills_safe1", "gry_roof", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1396.145385, -33.781246, 1002.304138, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 13816, "lahills_safe1", "gry_roof", 0x00000000);
tmpobjid = CreateDynamicObject(19172, 1402.670288, -42.516544, 1002.884460, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 19962, "samproadsigns", "streetsign", 0x00000000);
SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "white", 0x00000000);
tmpobjid = CreateDynamicObject(19329, 1402.715820, -42.495586, 1003.164428, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterialText(tmpobjid, 0, "{ffffff} LOS SANTOS", 80, "Ariel", 45, 1, 0x00000000, 0x00000000, 1);
tmpobjid = CreateDynamicObject(19329, 1402.715820, -42.495586, 1002.633911, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterialText(tmpobjid, 0, "{ffffff} Central Hospital", 80, "Ariel", 39, 1, 0x00000000, 0x00000000, 1);
tmpobjid = CreateDynamicObject(19325, 1424.206787, -33.043136, 1002.011718, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 9583, "bigshap_sfw", "boatfunnel1_128", 0xC8FFFFFF);
tmpobjid = CreateDynamicObject(19325, 1412.677734, -33.043136, 1006.151489, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 9583, "bigshap_sfw", "boatfunnel1_128", 0xC8FFFFFF);
tmpobjid = CreateDynamicObject(19325, 1412.677734, -33.043136, 1002.031494, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 9583, "bigshap_sfw", "boatfunnel1_128", 0xC8FFFFFF);
tmpobjid = CreateDynamicObject(19325, 1419.316772, -33.043136, 1006.131469, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 9583, "bigshap_sfw", "boatfunnel1_128", 0xC8FFFFFF);
tmpobjid = CreateDynamicObject(19325, 1425.957519, -33.043136, 1006.131469, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 9583, "bigshap_sfw", "boatfunnel1_128", 0xC8FFFFFF);
tmpobjid = CreateDynamicObject(19325, 1430.847045, -33.043136, 1002.011718, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 9583, "bigshap_sfw", "boatfunnel1_128", 0xC8FFFFFF);
tmpobjid = CreateDynamicObject(19087, 1416.002563, -33.040210, 1002.424987, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1416.002563, -33.040210, 1004.105285, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1416.002563, -33.040210, 1004.085266, 0.000000, 90.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1418.443847, -33.040210, 1004.085266, 0.000000, 90.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1420.894042, -33.040210, 1001.634948, 0.000000, 180.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1420.894042, -33.040210, 999.824401, 0.000000, 180.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19089, 1428.471923, -33.043037, 1007.007507, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19089, 1428.451782, -33.043037, 1013.307434, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19089, 1409.421020, -33.043037, 1013.307434, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19089, 1409.390991, -33.043037, 1007.326965, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19089, 1416.732543, -33.043037, 1006.316589, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19089, 1423.981323, -33.043037, 1006.316589, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19089, 1430.603637, -33.043037, 1006.316589, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19325, 1412.677734, -36.163082, 1002.031494, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 9583, "bigshap_sfw", "boatfunnel1_128", 0xC8FFFFFF);
tmpobjid = CreateDynamicObject(19325, 1424.329345, -36.163082, 1002.031494, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 9583, "bigshap_sfw", "boatfunnel1_128", 0xC8FFFFFF);
tmpobjid = CreateDynamicObject(19325, 1430.958618, -36.163082, 1002.031494, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 9583, "bigshap_sfw", "boatfunnel1_128", 0xC8FFFFFF);
tmpobjid = CreateDynamicObject(19325, 1412.677734, -36.163082, 1006.151672, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 9583, "bigshap_sfw", "boatfunnel1_128", 0xC8FFFFFF);
tmpobjid = CreateDynamicObject(19325, 1419.313964, -36.163082, 1006.151672, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 9583, "bigshap_sfw", "boatfunnel1_128", 0xC8FFFFFF);
tmpobjid = CreateDynamicObject(19325, 1425.954467, -36.163082, 1006.151672, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 9583, "bigshap_sfw", "boatfunnel1_128", 0xC8FFFFFF);
tmpobjid = CreateDynamicObject(19087, 1416.002563, -36.170200, 1004.105285, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1416.002563, -36.170200, 1002.424987, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1421.023437, -36.170200, 1002.424987, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1421.023437, -36.170200, 1004.104797, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1421.033447, -36.170200, 1004.104797, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1418.441894, -36.170200, 1004.104797, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1419.772460, -36.170200, 1004.104797, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19089, 1409.421020, -36.163032, 1013.307434, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19089, 1409.390991, -36.163032, 1007.296997, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19089, 1428.462524, -36.163032, 1007.296997, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19089, 1428.623046, -36.163032, 1006.317260, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19089, 1421.382568, -36.163032, 1006.317260, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19089, 1416.621704, -36.163032, 1006.317260, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19325, 1392.757080, -33.063129, 1002.061462, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 9583, "bigshap_sfw", "boatfunnel1_128", 0xC8FFFFFF);
tmpobjid = CreateDynamicObject(19325, 1380.047607, -33.063129, 1002.061462, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 9583, "bigshap_sfw", "boatfunnel1_128", 0xC8FFFFFF);
tmpobjid = CreateDynamicObject(19325, 1380.036499, -36.143123, 1002.061462, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 9583, "bigshap_sfw", "boatfunnel1_128", 0xC8FFFFFF);
tmpobjid = CreateDynamicObject(19325, 1392.775634, -36.143123, 1002.061462, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 9583, "bigshap_sfw", "boatfunnel1_128", 0xC8FFFFFF);
tmpobjid = CreateDynamicObject(19325, 1392.757080, -33.063129, 1006.181396, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 9583, "bigshap_sfw", "boatfunnel1_128", 0xC8FFFFFF);
tmpobjid = CreateDynamicObject(19325, 1386.118164, -33.063129, 1006.181396, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 9583, "bigshap_sfw", "boatfunnel1_128", 0xC8FFFFFF);
tmpobjid = CreateDynamicObject(19325, 1379.477905, -33.063129, 1006.181396, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 9583, "bigshap_sfw", "boatfunnel1_128", 0xC8FFFFFF);
tmpobjid = CreateDynamicObject(19325, 1392.775634, -36.143123, 1006.181884, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 9583, "bigshap_sfw", "boatfunnel1_128", 0xC8FFFFFF);
tmpobjid = CreateDynamicObject(19325, 1386.136474, -36.143123, 1006.181884, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 9583, "bigshap_sfw", "boatfunnel1_128", 0xC8FFFFFF);
tmpobjid = CreateDynamicObject(19325, 1379.497192, -36.143123, 1006.181884, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 9583, "bigshap_sfw", "boatfunnel1_128", 0xC8FFFFFF);
tmpobjid = CreateDynamicObject(19087, 1389.452270, -33.060207, 1002.424987, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1389.452270, -33.060207, 1004.165405, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1383.371093, -33.060207, 1004.165405, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1383.371093, -33.060207, 1002.484924, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1383.371093, -36.160194, 1002.484924, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1383.371093, -36.160194, 1004.144958, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1385.822021, -33.060207, 1004.135375, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1388.193115, -33.060207, 1004.135375, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1389.464233, -33.060207, 1004.135375, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1389.464233, -36.150199, 1004.135375, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1387.054199, -36.150199, 1004.135375, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1385.833251, -36.150199, 1004.135375, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1389.451293, -36.160194, 1002.484924, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1389.451293, -36.160194, 1004.155395, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19089, 1376.948120, -33.073032, 1007.195983, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19089, 1376.948120, -36.143013, 1007.195983, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19089, 1396.020263, -36.143013, 1013.295166, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19089, 1396.050292, -36.143013, 1007.194702, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19089, 1396.050292, -33.062984, 1007.194702, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19089, 1396.010253, -33.062984, 1013.295410, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19089, 1396.230346, -33.062984, 1006.324584, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19089, 1389.339355, -33.062984, 1006.324584, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19089, 1382.101318, -33.062984, 1006.324584, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19089, 1384.151000, -36.142951, 1006.324584, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19089, 1391.251586, -36.142951, 1006.324584, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(19089, 1396.083007, -36.142951, 1006.324584, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(644, 1378.202392, -34.656024, 1000.344482, 0.000000, 0.000000, -39.900005, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 4003, "cityhall_tr_lan", "planta256", 0xFFFFFF66);
tmpobjid = CreateDynamicObject(19087, 1396.145385, -31.341234, 1002.774475, 0.000000, 90.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 13816, "lahills_safe1", "gry_roof", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1396.145385, -35.451274, 1002.774475, 0.000000, 90.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 13816, "lahills_safe1", "gry_roof", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1396.145385, -35.451274, 1000.244079, 0.000000, 90.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 13816, "lahills_safe1", "gry_roof", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1396.145385, -31.321271, 1000.244079, 0.000000, 90.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 13816, "lahills_safe1", "gry_roof", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1409.244262, -31.321271, 1002.764770, 0.000000, 90.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 13816, "lahills_safe1", "gry_roof", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1409.244262, -35.421295, 1002.764770, 0.000000, 90.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 13816, "lahills_safe1", "gry_roof", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1409.246582, -35.411277, 1000.244079, 0.000000, 90.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 13816, "lahills_safe1", "gry_roof", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1409.246582, -31.321277, 1000.244079, 0.000000, 90.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 13816, "lahills_safe1", "gry_roof", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1396.145385, -35.451274, 1002.634399, 0.000000, 90.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 13816, "lahills_safe1", "gry_roof", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1396.145385, -31.321279, 1002.634399, 0.000000, 90.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 13816, "lahills_safe1", "gry_roof", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1409.254638, -31.321279, 1002.634033, 0.000000, 90.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 13816, "lahills_safe1", "gry_roof", 0x00000000);
tmpobjid = CreateDynamicObject(19087, 1409.254638, -35.411296, 1002.634033, 0.000000, 90.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 13816, "lahills_safe1", "gry_roof", 0x00000000);
tmpobjid = CreateDynamicObject(19360, 1413.622192, -25.410261, 1003.734863, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
tmpobjid = CreateDynamicObject(19360, 1423.142700, -25.410261, 1003.734863, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
tmpobjid = CreateDynamicObject(19360, 1391.141845, -25.410261, 1003.734863, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
tmpobjid = CreateDynamicObject(19360, 1381.522827, -25.410261, 1003.734863, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
tmpobjid = CreateDynamicObject(1797, 1394.264892, -39.992561, 1000.104919, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(1797, 1389.365600, -39.992561, 1000.104919, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(1797, 1384.773193, -39.992561, 1000.104919, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(1797, 1379.723876, -39.992561, 1000.104919, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(1797, 1378.733886, -29.292543, 1000.104919, 0.000000, 0.000000, 1800.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(1797, 1383.464721, -29.292543, 1000.104919, 0.000000, 0.000000, 1800.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(1797, 1388.085693, -29.292543, 1000.104919, 0.000000, 0.000000, 1800.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(1797, 1393.226074, -29.292543, 1000.104919, 0.000000, 0.000000, 1800.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(631, 1395.609497, -36.793190, 1001.031982, 0.000000, 0.000000, -82.600006, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14832, "lee_stripclub", "Strip_plant", 0xFFCCFF33);
tmpobjid = CreateDynamicObject(631, 1395.419311, -32.563217, 1001.031982, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 17958, "burnsalpha", "plantb256", 0xFFCCFF33);
tmpobjid = CreateDynamicObject(631, 1377.729248, -32.563217, 1001.031982, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14832, "lee_stripclub", "Strip_plant", 0xFFCCFF33);
tmpobjid = CreateDynamicObject(631, 1377.729248, -36.743232, 1001.031982, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 17958, "burnsalpha", "plantb256", 0xFFCCFF33);
tmpobjid = CreateDynamicObject(19360, 1391.332031, -44.000278, 1003.734863, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
tmpobjid = CreateDynamicObject(19360, 1381.622192, -44.000278, 1003.734863, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
tmpobjid = CreateDynamicObject(19360, 1413.782348, -43.940338, 1003.734863, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
tmpobjid = CreateDynamicObject(19360, 1423.593139, -43.940338, 1003.734863, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 3979, "civic01_lan", "sl_dwntwnshpfrnt1", 0x00000000);
tmpobjid = CreateDynamicObject(1797, 1412.256469, -39.992561, 1000.104919, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(1797, 1421.017700, -39.992561, 1000.104919, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(1797, 1420.017822, -29.222560, 1000.104919, 0.000000, 0.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(1797, 1411.077880, -29.222560, 1000.104919, 0.000000, 0.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 1, 10765, "airportgnd_sfse", "black64", 0x00000000);
tmpobjid = CreateDynamicObject(631, 1409.883666, -36.949317, 1001.001464, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 4003, "cityhall_tr_lan", "foliage256", 0xFFCCFF33);
tmpobjid = CreateDynamicObject(631, 1409.883666, -32.529312, 1001.001464, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 4003, "cityhall_tr_lan", "foliage256", 0xFFCCFF33);
tmpobjid = CreateDynamicObject(631, 1427.964477, -32.529312, 1001.001464, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 14832, "lee_stripclub", "Strip_plant", 0xFFCCFF33);
tmpobjid = CreateDynamicObject(631, 1427.964477, -36.779304, 1001.001464, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 0, 4003, "cityhall_tr_lan", "planta256", 0xFFCCFF33);
tmpobjid = CreateDynamicObject(948, 1424.987670, -25.878849, 1000.071228, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 2, 4003, "cityhall_tr_lan", "foliage256", 0x00000000);
SetDynamicObjectMaterial(tmpobjid, 3, 3881, "apsecurity_sfxrf", "lostonclad1", 0xFFFFFFFF);
tmpobjid = CreateDynamicObject(948, 1417.799072, -29.308860, 1000.071228, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 2, 4830, "airport2", "bevflower2", 0x00000000);
SetDynamicObjectMaterial(tmpobjid, 3, 3881, "apsecurity_sfxrf", "lostonclad1", 0xFFFFFFFF);
tmpobjid = CreateDynamicObject(948, 1413.447998, -43.448860, 1000.071228, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 2, 4830, "airport2", "kbplanter_plants1", 0x00000000);
SetDynamicObjectMaterial(tmpobjid, 3, 3881, "apsecurity_sfxrf", "lostonclad1", 0xFFFFFFFF);
tmpobjid = CreateDynamicObject(948, 1418.688720, -39.968872, 1000.071228, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
SetDynamicObjectMaterial(tmpobjid, 2, 4992, "airportdetail", "bevflower1", 0x00000000);
SetDynamicObjectMaterial(tmpobjid, 3, 3881, "apsecurity_sfxrf", "lostonclad1", 0xFFFFFFFF);
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
tmpobjid = CreateDynamicObject(19376, 1390.857543, -44.013446, 999.938903, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(19376, 1380.375610, -44.003425, 999.938903, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(19376, 1414.586914, -44.003471, 999.938903, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(19376, 1425.079956, -44.003486, 999.938903, 0.000000, 90.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(14793, 1402.967163, -39.804264, 1007.144775, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(1569, 1401.232299, -25.364088, 999.864013, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(1569, 1404.221923, -25.354087, 999.864013, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2161, 1409.175415, -27.706626, 999.864013, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2161, 1409.175415, -29.036640, 999.864013, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2161, 1409.175415, -29.036640, 1001.203735, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2161, 1396.305419, -28.046623, 999.864013, 0.000000, 0.000000, 450.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2161, 1396.305419, -29.386631, 999.864013, 0.000000, 0.000000, 450.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2167, 1396.307739, -30.502950, 999.873657, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2163, 1396.316894, -28.935007, 1001.214721, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(19807, 1404.318603, -40.470829, 1000.704406, 0.000000, 0.000000, -19.200002, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2686, 1407.021240, -42.504325, 1002.144409, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2164, 1401.938964, -42.508110, 999.864013, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2162, 1403.731933, -42.535083, 999.864013, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2167, 1387.250854, -43.800529, 1000.054870, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2167, 1395.460815, -43.800529, 1000.054870, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2167, 1385.640869, -43.800529, 1000.054870, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2167, 1377.590209, -43.800529, 1000.054870, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2167, 1377.590209, -25.560518, 1000.054870, 0.000000, 0.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2167, 1385.579711, -25.560518, 1000.054870, 0.000000, 0.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2167, 1387.120239, -25.560518, 1000.054870, 0.000000, 0.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2167, 1395.321411, -25.560518, 1000.054870, 0.000000, 0.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(1823, 1391.613281, -26.638280, 1000.081237, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(1823, 1381.883056, -26.638280, 1000.081237, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(1823, 1389.692504, -26.638280, 1000.081237, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(1823, 1380.332641, -26.638280, 1000.081237, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(1823, 1380.282592, -43.818264, 1000.081237, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(1823, 1382.092163, -43.818264, 1000.081237, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(1823, 1389.902832, -43.818264, 1000.081237, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(1823, 1391.683105, -43.818264, 1000.081237, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2162, 1396.027343, -29.851703, 1000.081237, 0.000000, 0.000000, 630.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2161, 1396.054565, -39.429363, 1000.081237, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2161, 1386.154052, -39.429363, 1000.081237, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2161, 1386.154052, -39.429363, 1001.421264, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2163, 1386.227050, -30.034534, 1000.084899, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2167, 1410.010375, -43.800529, 1000.054870, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2167, 1418.969726, -43.800529, 1000.054870, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2167, 1418.969726, -25.773492, 1000.054870, 0.000000, 0.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2167, 1410.008666, -25.673492, 1000.054870, 0.000000, 0.000000, 360.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2166, 1417.675292, -26.133188, 1000.081237, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2166, 1427.845581, -26.133188, 1000.081237, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2166, 1427.845581, -42.333206, 1000.081237, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2166, 1417.614990, -42.333206, 1000.081237, 0.000000, 0.000000, 180.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(1714, 1417.112182, -42.155689, 1000.081237, 0.000000, 0.000000, -32.599998, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(1714, 1427.328369, -42.102752, 1000.081237, 0.000000, 0.000000, -32.599998, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(1714, 1427.271850, -25.893779, 1000.081237, 0.000000, 0.000000, -20.999998, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(1714, 1416.914672, -25.772701, 1000.081237, 0.000000, 0.000000, -2.799996, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2164, 1409.554809, -39.153884, 1000.081237, 0.000000, 0.000000, 810.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2191, 1409.999023, -30.975894, 1000.024841, 0.000000, 0.000000, 90.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2191, 1427.809936, -30.445892, 1000.024841, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2161, 1428.324707, -38.208457, 1000.071228, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2161, 1418.194824, -39.118453, 1000.071228, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2161, 1418.194824, -39.118453, 1001.401184, 0.000000, 0.000000, 270.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(19563, 1390.276367, -26.280147, 1000.581604, 0.000000, 0.000000, -11.399998, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(19563, 1389.990356, -25.926689, 1000.581604, 0.000000, 0.000000, 8.100002, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(19578, 1389.782958, -26.177251, 1000.631774, 0.000000, 0.000000, -75.999992, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(19578, 1389.901611, -26.198293, 1000.611755, 0.000000, 0.000000, -40.199996, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(19564, 1380.847167, -26.058771, 1000.601440, 0.000000, 0.000000, 170.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(19576, 1380.722045, -26.248014, 1000.621520, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(19576, 1380.621948, -26.098011, 1000.621520, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(19576, 1380.661987, -26.458019, 1000.621520, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2831, 1382.515869, -26.176662, 1000.601440, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2832, 1382.587402, -43.437129, 1000.591674, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(19563, 1380.709594, -43.432155, 1000.561645, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(19575, 1380.481689, -43.294483, 1000.641662, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(19575, 1380.621826, -43.104496, 1000.641662, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(19578, 1381.005737, -43.288299, 1000.591552, 0.000000, 0.000000, 116.200004, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(2830, 1390.302490, -43.356319, 1000.571533, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(19564, 1392.163330, -43.368152, 1000.631713, 0.000000, 0.000000, 0.000000, -1, -1, -1, 200.00, 200.00);
tmpobjid = CreateDynamicObject(19564, 1392.461669, -43.251449, 1000.631713, 0.000000, 0.000000, -28.700002, -1, -1, -1, 200.00, 200.00);
}

stock LoadAnimations(playerid)
{
	PreloadAnimLib(playerid,"AIRPORT");
	PreloadAnimLib(playerid,"Attractors");
	PreloadAnimLib(playerid,"BAR");
	PreloadAnimLib(playerid,"BASEBALL");
	PreloadAnimLib(playerid,"BD_FIRE");
	PreloadAnimLib(playerid,"benchpress");
	PreloadAnimLib(playerid,"BF_injection");
	PreloadAnimLib(playerid,"BIKED");
	PreloadAnimLib(playerid,"BIKEH");
	PreloadAnimLib(playerid,"BIKELEAP");
	PreloadAnimLib(playerid,"BIKES");
	PreloadAnimLib(playerid,"BIKEV");
	PreloadAnimLib(playerid,"BIKE_DBZ");
	PreloadAnimLib(playerid,"BMX");
	PreloadAnimLib(playerid,"BOX");
	PreloadAnimLib(playerid,"BSKTBALL");
	PreloadAnimLib(playerid,"BUDDY");
	PreloadAnimLib(playerid,"BUS");
	PreloadAnimLib(playerid,"CAMERA");
	PreloadAnimLib(playerid,"CAR");
	PreloadAnimLib(playerid,"CAR_CHAT");
	PreloadAnimLib(playerid,"CASINO");
	PreloadAnimLib(playerid,"CHAINSAW");
	PreloadAnimLib(playerid,"CHOPPA");
	PreloadAnimLib(playerid,"CLOTHES");
	PreloadAnimLib(playerid,"COACH");
	PreloadAnimLib(playerid,"COLT45");
	PreloadAnimLib(playerid,"COP_DVBYZ");
	PreloadAnimLib(playerid,"CRIB");
	PreloadAnimLib(playerid,"DAM_JUMP");
	PreloadAnimLib(playerid,"DANCING");
	PreloadAnimLib(playerid,"DILDO");
	PreloadAnimLib(playerid,"DODGE");
	PreloadAnimLib(playerid,"DOZER");
	PreloadAnimLib(playerid,"DRIVEBYS");
	PreloadAnimLib(playerid,"FAT");
	PreloadAnimLib(playerid,"FIGHT_B");
	PreloadAnimLib(playerid,"FIGHT_C");
	PreloadAnimLib(playerid,"FIGHT_D");
	PreloadAnimLib(playerid,"FIGHT_E");
	PreloadAnimLib(playerid,"FINALE");
	PreloadAnimLib(playerid,"FINALE2");
	PreloadAnimLib(playerid,"Flowers");
	PreloadAnimLib(playerid,"FOOD");
	PreloadAnimLib(playerid,"Freeweights");
	PreloadAnimLib(playerid,"GANGS");
	PreloadAnimLib(playerid,"GHANDS");
	PreloadAnimLib(playerid,"GHETTO_DB");
	PreloadAnimLib(playerid,"goggles");
	PreloadAnimLib(playerid,"GRAFFITI");
	PreloadAnimLib(playerid,"GRAVEYARD");
	PreloadAnimLib(playerid,"GRENADE");
	PreloadAnimLib(playerid,"GYMNASIUM");
	PreloadAnimLib(playerid,"HAIRCUTS");
	PreloadAnimLib(playerid,"HEIST9");
	PreloadAnimLib(playerid,"INT_HOUSE");
	PreloadAnimLib(playerid,"INT_OFFICE");
	PreloadAnimLib(playerid,"INT_SHOP");
	PreloadAnimLib(playerid,"JST_BUISNESS");
	PreloadAnimLib(playerid,"KART");
	PreloadAnimLib(playerid,"KISSING");
	PreloadAnimLib(playerid,"KNIFE");
	PreloadAnimLib(playerid,"LAPDAN1");
	PreloadAnimLib(playerid,"LAPDAN2");
	PreloadAnimLib(playerid,"LAPDAN3");
	PreloadAnimLib(playerid,"LOWRIDER");
	PreloadAnimLib(playerid,"MD_CHASE");
	PreloadAnimLib(playerid,"MEDIC");
	PreloadAnimLib(playerid,"MD_END");
	PreloadAnimLib(playerid,"MISC");
	PreloadAnimLib(playerid,"MTB");
	PreloadAnimLib(playerid,"MUSCULAR");
	PreloadAnimLib(playerid,"NEVADA");
	PreloadAnimLib(playerid,"ON_LOOKERS");
	PreloadAnimLib(playerid,"OTB");
	PreloadAnimLib(playerid,"PARACHUTE");
	PreloadAnimLib(playerid,"PARK");
	PreloadAnimLib(playerid,"PAULNMAC");
	PreloadAnimLib(playerid,"PED");
	PreloadAnimLib(playerid,"PLAYER_DVBYS");
	PreloadAnimLib(playerid,"PLAYIDLES");
	PreloadAnimLib(playerid,"POLICE");
	PreloadAnimLib(playerid,"POOL");
	PreloadAnimLib(playerid,"POOR");
	PreloadAnimLib(playerid,"PYTHON");
	PreloadAnimLib(playerid,"QUAD");
	PreloadAnimLib(playerid,"QUAD_DBZ");
	PreloadAnimLib(playerid,"RIFLE");
	PreloadAnimLib(playerid,"RIOT");
	PreloadAnimLib(playerid,"ROB_BANK");
	PreloadAnimLib(playerid,"ROCKET");
	PreloadAnimLib(playerid,"RUSTLER");
	PreloadAnimLib(playerid,"RYDER");
	PreloadAnimLib(playerid,"SCRATCHING");
	PreloadAnimLib(playerid,"SHAMAL");
	PreloadAnimLib(playerid,"SHOTGUN");
	PreloadAnimLib(playerid,"SILENCED");
	PreloadAnimLib(playerid,"SKATE");
	PreloadAnimLib(playerid,"SPRAYCAN");
	PreloadAnimLib(playerid,"STRIP");
	PreloadAnimLib(playerid,"SUNBATHE");
	PreloadAnimLib(playerid,"SWAT");
	PreloadAnimLib(playerid,"SWEET");
	PreloadAnimLib(playerid,"SWIM");
	PreloadAnimLib(playerid,"SWORD");
	PreloadAnimLib(playerid,"TANK");
	PreloadAnimLib(playerid,"TATTOOS");
	PreloadAnimLib(playerid,"TEC");
	PreloadAnimLib(playerid,"TRAIN");
	PreloadAnimLib(playerid,"TRUCK");
	PreloadAnimLib(playerid,"UZI");
	PreloadAnimLib(playerid,"VAN");
	PreloadAnimLib(playerid,"VENDING");
	PreloadAnimLib(playerid,"VORTEX");
	PreloadAnimLib(playerid,"WAYFARER");
	PreloadAnimLib(playerid,"WEAPONS");
	PreloadAnimLib(playerid,"WUZI");
	PreloadAnimLib(playerid,"SNM");
	PreloadAnimLib(playerid,"BLOWJOBZ");
	PreloadAnimLib(playerid,"SEX");
	PreloadAnimLib(playerid,"BOMBER");
	PreloadAnimLib(playerid,"RAPPING");
	PreloadAnimLib(playerid,"SHOP");
	PreloadAnimLib(playerid,"BEACH");
	PreloadAnimLib(playerid,"SMOKING");
	PreloadAnimLib(playerid,"FOOD");
	PreloadAnimLib(playerid,"ON_LOOKERS");
	PreloadAnimLib(playerid,"DEALER");
	PreloadAnimLib(playerid,"CRACK");
	PreloadAnimLib(playerid,"CARRY");
	PreloadAnimLib(playerid,"COP_AMBIENT");
	PreloadAnimLib(playerid,"PARK");
	PreloadAnimLib(playerid,"INT_HOUSE");
	PreloadAnimLib(playerid,"FOOD");
	return 1;
}

stock PreloadAnimLib(playerid, animlib[])
{
	return ApplyAnimation(playerid, animlib, "null", 4.0, 0, 0, 0, 0, 0, 1);
}

static stock g_arrVehicleNames[][] = {
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster",
    "Stretch", "Manana", "Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
    "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer",
    "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach",
    "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo", "Seasparrow",
    "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair",
    "Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic",
    "Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton",
    "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper", "Rancher",
    "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "Blista Compact", "Police Maverick",
    "Boxville", "Benson", "Mesa", "RC Goblin", "Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher",
    "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain",
    "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck",
    "Fortune", "Cadrona", "SWAT Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan",
    "Blade", "Streak", "Freight", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder",
    "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite", "Windsor", "Monster", "Monster",
    "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
    "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30",
    "Huntley", "Stafford", "BF-400", "News Van", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
    "Freight Box", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "LSPD Cruiser", "SFPD Cruiser", "LVPD Cruiser",
    "Police Rancher", "Picador", "S.W.A.T", "Alpha", "Phoenix", "Glendale", "Sadler", "Luggage", "Luggage", "Stairs",
    "Boxville", "Tiller", "Utility Trailer"
};

stock ReturnVehicleModelName(model)
{
	new
	    name[32] = "Yok";

    if (model < 400 || model > 611)
	    return name;

	format(name, sizeof(name), g_arrVehicleNames[model - 400]);
	return name;
}


/*forward OnCheatDetected(playerid, ip_address[], type, code);
public OnCheatDetected(playerid, ip_address[], type, code)
{
	switch(code)
	{
			case 0, 1:
			{
				AdminMessage(RENK_YARALI, "AdmCmd: %s(%d) Air-break hilesi kullandýðý için oyundan atýldý.", Oyuncuadi(playerid), playerid);
				Kickle(playerid);
			}
			case 2, 3, 4, 6:
			{
				AdminMessage(RENK_YARALI, "AdmCmd: %s(%d) Teleport hilesi kullandýðý için oyundan atýldý.", Oyuncuadi(playerid), playerid);
				Kickle(playerid);
			}
			case 5: return 1;
			case 7, 8:
			{
				AdminMessage(RENK_YARALI, "AdmCmd: %s(%d) Teleport hilesi kullandýðý için oyundan atýldý.", Oyuncuadi(playerid), playerid);
				Kickle(playerid);
			}
			case 9, 10:
			{
				AdminMessage(RENK_YARALI, "AdmCmd: %s(%d) Speed hilesi kullandýðý için oyundan atýldý.", Oyuncuadi(playerid), playerid);
				Kickle(playerid);
			}
			case 15:
			{
				AdminMessage(RENK_YARALI, "AdmCmd: %s(%d) Silah hilesi kullandýðý için oyundan atýldý.", Oyuncuadi(playerid), playerid);
				Kickle(playerid);
			}
			case 16, 17:
			{
				AdminMessage(RENK_YARALI, "AdmCmd: %s(%d) Mermi hilesi kullandýðý için oyundan atýldý.", Oyuncuadi(playerid), playerid);
				Kickle(playerid);
			}
			case 21:
			{
				AdminMessage(RENK_YARALI, "AdmCmd: %s(%d) Görünmezlik hilesi kullandýðý için oyundan atýldý.", Oyuncuadi(playerid), playerid);
				Kickle(playerid);
			}
			case 43, 44, 45, 46: // 47 - silah
			{
				AdminMessage(RENK_YARALI, "AdmCmd: %s(%d) Crasher-Type hilesi kullandýðý için oyundan atýldý.", Oyuncuadi(playerid), playerid);
				Kickle(playerid);
			}
			case 48:
			{
				AdminMessage(RENK_YARALI, "AdmCmd: %s(%d) Connection-Flood hilesi kullandýðý için oyundan atýldý.", Oyuncuadi(playerid), playerid);
				Kickle(playerid);
			}
			case 51:
			{
				AdminMessage(RENK_YARALI, "AdmCmd: %s(%d) Anti-DOS hilesi kullandýðý için oyundan atýldý.", Oyuncuadi(playerid), playerid);
				Kickle(playerid);
			}
			case 52:
			{
				AdminMessage(RENK_YARALI, "AdmCmd: %s(%d) Anti-NOP hilesi kullandýðý için oyundan atýldý.", Oyuncuadi(playerid), playerid);
				Kickle(playerid);
			}
	}
	return 1;
}
*/
stock IsPlayerFalling(playerid)           //true if player is falling with a closed parachute
{
    new index = GetPlayerAnimationIndex(playerid);
    if(index >= 958 && index <= 979 || index == 1130 || index == 1195 || index == 1132) return 1;
    return 0;
}
