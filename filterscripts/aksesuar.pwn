
//==============================================================================
#include <a_samp>
#include <sscanf2>
#include <dini>
#include <zcmd>
//==============================================================================
#define DIALOG_ATTACH_INDEX             13500
#define DIALOG_ATTACH_INDEX_SELECTION   DIALOG_ATTACH_INDEX+1
#define DIALOG_ATTACH_EDITREPLACE       DIALOG_ATTACH_INDEX+2
#define DIALOG_ATTACH_MODEL_SELECTION   DIALOG_ATTACH_INDEX+3
#define DIALOG_ATTACH_BONE_SELECTION    DIALOG_ATTACH_INDEX+4
#define DIALOG_ATTACH_OBJECT_SELECTION  DIALOG_ATTACH_INDEX+5
#define DIALOG_ATTACH_OBJECT2_SELECTION DIALOG_ATTACH_INDEX+6
//==============================================================================
#define MAX_OSLOTS                      5
#define     BEYAZ3              	"{FFFFFF}"
//==============================================================================
#define         COL_WHITE       "{FFFFFF}"
#define         COL_BLACK       "{0E0101}"
#define         COL_GREY        "{C3C3C3}"
#define         COL_GREEN       "{6EF83C}"
#define         COL_RED         "{F81414}"
#define         COL_YELLOW      "{F3FF02}"
#define         COL_ORANGE      "{FFAF00}"
#define         COL_LIME        "{B7FF00}"
#define         COL_CYAN        "{00FFEE}"
#define         COL_BLUE        "{0049FF}"
#define         COL_MAGENTA     "{F300FF}"
#define         COL_VIOLET      "{B700FF}"
#define         COL_PINK        "{FF00EA}"
#define         COL_MARONE      "{A90202}"
//==============================================================================
//-----[ mSelection ]-----
// settings static lists
#define mS_TOTAL_ITEMS          1000 // Max amount of items from all lists
#define mS_TOTAL_LISTS                  20 // Max amount of lists
#define mS_TOTAL_ROT_ZOOM               100 // Max amount of items using extra information like zoom or rotations

// settings dynamic per player lists
#define mS_CUSTOM_MAX_ITEMS             2000
new gCustomList[MAX_PLAYERS][mS_CUSTOM_MAX_ITEMS];

#define mS_INVALID_LISTID               mS_TOTAL_LISTS
#define mS_CUSTOM_LISTID                (mS_TOTAL_LISTS+1)

#define mS_NEXT_TEXT   "Ileri"
#define mS_PREV_TEXT   "Geri"
#define mS_CANCEL_TEXT   "Iptal"

#define mS_SELECTION_ITEMS              21
#define mS_ITEMS_PER_LINE               7
#define mS_DIALOG_BASE_X        75.0
#define mS_DIALOG_BASE_Y        130.0
#define mS_DIALOG_WIDTH         550.0
#define mS_DIALOG_HEIGHT        180.0
#define mS_SPRITE_DIM_X         60.0
#define mS_SPRITE_DIM_Y         70.0
//----------------------
//==============================================================================
new AttachmentObjectsList[] = {
18632,
18633,
18634,
18635,
18636,
18637,
18638,
18639,
18640,
18975,
19136,
19274,
18641,
18642,
18643,
18644,
18645,
18865,
18866,
18867,
18868,
18869,
18870,
18871,
18872,
18873,
18874,
18875,
18890,
18891,
18892,
18893,
18894,
18895,
18896,
18897,
18898,
18899,
18900,
18901,
18902,
18903,
18904,
18905,
18906,
18907,
18908,
18909,
18910,
18911,
18912,
18913,
18914,
18915,
18916,
18917,
18918,
18919,
18920,
18921,
18922,
18923,
18924,
18925,
18926,
18927,
18928,
18929,
18930,
18931,
18932,
18933,
18934,
18935,
18936,
18937,
18938,
18939,
18940,
18941,
18942,
18943,
18944,
18945,
18946,
18947,
18948,
18949,
18950,
18951,
18952,
18953,
18954,
18955,
18956,
18957,
18958,
18959,
18960,
18961,
18962,
18963,
18964,
18965,
18966,
18967,
18968,
18969,
18970,
18971,
18972,
18973,
18974,
18976,
18977,
18978,
18979,
19006,
19007,
19008,
19009,
19010,
19011,
19012,
19013,
19014,
19015,
19016,
19017,
19018,
19019,
19020,
19021,
19022,
19023,
19024,
19025,
19026,
19027,
19028,
19029,
19030,
19031,
19032,
19033,
19034,
19035,
19036,
19037,
19038,
19039,
19040,
19041,
19042,
19043,
19044,
19045,
19046,
19047,
19048,
19049,
19050,
19051,
19052,
19053,
19085,
19086,
19090,
19091,
19092,
19093,
19094,
19095,
19096,
19097,
19098,
19099,
19100,
19101,
19102,
19103,
19104,
19105,
19106,
19107,
19108,
19109,
19110,
19111,
19112,
19113,
19114,
19115,
19116,
19117,
19118,
19119,
19120,
19137,
19138,
19139,
19140,
19141,
19142,
19160,
19161,
19162,
19163,
19317,
19318,
19319,
19330,
19331,
19346,
19347,
19348,
19349,
19350,
19351,
19352,
19487,
19488,
19513,
19515,
331,
333,
334,
335,
336,
337,
338,
339,
341,
321,
322,
323,
324
};
//==============================================================================
new AttachmentBones[][24] = {
{"Omuz"},
{"Kafa"},
{"Sol Üst Kol"},
{"Sað Üst Kol"},
{"Sol El"},
{"Sað El"},
{"Sol Uyluk"},
{"Sað Uyluk"},
{"Sol Ayak"},
{"Sað Ayak"},
{"Sað Baldýr"},
{"Sol Baldýr"},
{"Sol Kolüstü"},
{"Sað Kolüstü"},
{"Sol Köprücük Kemiði"},
{"Sað Köprücük Kemiði"},
{"Diz"},
{"Çene"}
};
//==============================================================================
//-----[ mSelection ]-----
new PlayerText:gCurrentPageTextDrawId[MAX_PLAYERS];
new PlayerText:gHeaderTextDrawId[MAX_PLAYERS];
new PlayerText:gBackgroundTextDrawId[MAX_PLAYERS];
new PlayerText:gNextButtonTextDrawId[MAX_PLAYERS];
new PlayerText:gPrevButtonTextDrawId[MAX_PLAYERS];
new PlayerText:gCancelButtonTextDrawId[MAX_PLAYERS];
new PlayerText:gSelectionItems[MAX_PLAYERS][mS_SELECTION_ITEMS];
new gSelectionItemsTag[MAX_PLAYERS][mS_SELECTION_ITEMS];
new gItemAt[MAX_PLAYERS];

#define mS_LIST_START                   0
#define mS_LIST_END                             1
new gLists[mS_TOTAL_LISTS][2]; // list information start/end index

#define mS_ITEM_MODEL                   0
#define mS_ITEM_ROT_ZOOM_ID     1
new gItemList[mS_TOTAL_ITEMS][2];

new Float:gRotZoom[mS_TOTAL_ROT_ZOOM][4]; // Array for saving rotation and zoom info
new gItemAmount = 0; // Amount of items used
new gListAmount = 0; // Amount of lists used
new gRotZoomAmount = 0; // Amount of Rotation/Zoom informations used
//----------------------
//==============================================================================
//-----[ mSelection ]-----
/*Functions to be used
LoadModelSelectionMenu(f_name[])
HideModelSelectionMenu(playerid)
ShowModelSelectionMenu(playerid, ListID, header_text[], dialogBGcolor = 0x4A5A6BBB, previewBGcolor = 0x88888899 , tdSelectionColor = 0xFFFF00AA)
ShowModelSelectionMenuEx(playerid, items_array[], item_amount, header_text[], extraid, Float:Xrot = 0.0, Float:Yrot = 0.0, Float:Zrot = 0.0, Float:mZoom = 1.0, dialogBGcolor = 0x4A5A6BBB, previewBGcolor = 0x88888899 , tdSelectionColor = 0xFFFF00AA)
*/
// Callbacks
forward OnPlayerModelSelection(playerid, response, listid, modelid2);
forward OnPlayerModelSelectionEx(playerid, response, extraid, modelid2);
//----------------------
//==============================================================================
CMD:aksesuar(playerid,params[])
{
        new string[128];
        new dialog[500];
        for(new x;x<MAX_OSLOTS;x++)
        {
        if(IsPlayerAttachedObjectSlotUsed(playerid, x))
                {       format(string, sizeof(string), ""COL_WHITE"Slot:%d :: "COL_GREEN"Kullanýlýyor\n", x);    }
                else format(string, sizeof(string), ""COL_WHITE"Slot:%d\n", x);
                strcat(dialog,string);
        }
        ShowPlayerDialog(playerid, DIALOG_ATTACH_INDEX_SELECTION, DIALOG_STYLE_LIST,"Oyuncu Aksesuarlarý: (Slot Seç)", dialog, "Seç", "Ýptal");
        return 1;
}
//==============================================================================
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_ATTACH_INDEX_SELECTION:
        {
            if(response)
            {
                if(IsPlayerAttachedObjectSlotUsed(playerid, listitem))
                {
                    ShowPlayerDialog(playerid, DIALOG_ATTACH_EDITREPLACE, DIALOG_STYLE_MSGBOX, \
                    "Oyuncu Aksesuarlarý", ""COL_WHITE"Ýstersen objeyi düzenleyebilir veya silebilirsin.", "Düzenle", "Sil");
                }
                else
                {
                                        ShowPlayerDialog(playerid,DIALOG_ATTACH_OBJECT_SELECTION,DIALOG_STYLE_LIST,"Oyuncu Akesuarlarý",""COL_GREY"Aksesuarlar\n"COL_WHITE""COL_GREY"Özel Akseuar","Ýleri(>>)","Geri<<)");
                        }
                SetPVarInt(playerid, "AttachmentIndexSel", listitem);
            }
            return 1;
        }
        case DIALOG_ATTACH_OBJECT_SELECTION:
        {
            if(!response)
            {
                cmd_aksesuar(playerid,"");
            }
            if(response)
            {
                if(listitem==0) ShowModelSelectionMenuEx(playerid, AttachmentObjectsList, 228+38, "Aksesuarlar", DIALOG_ATTACH_MODEL_SELECTION, 0.0, 0.0, 0.0, 1.0, 0x00000099, 0x000000EE, 0xACCBF1FF);
                if(listitem==1) ShowPlayerDialog(playerid,DIALOG_ATTACH_OBJECT2_SELECTION,DIALOG_STYLE_INPUT,"Oyuncu Akesuarlarý: (Obje ID'si girin.)",""COL_WHITE"Aksesuar ID'sini girin, Aksesuar ID'lerini buradan bulabilirsiniz ''http://wiki.sa-mp.com''.","Ayarla","Geri(<<)");
                        }
                }
        case DIALOG_ATTACH_OBJECT2_SELECTION:
        {
            if(!response)
            {   ShowPlayerDialog(playerid,DIALOG_ATTACH_OBJECT_SELECTION,DIALOG_STYLE_LIST,"Aksesuarlar",": "COL_GREY"Aksesuarlar\n"COL_WHITE": "COL_GREY"Özel Aksesuar","Ýleri(>>)","Geri(<<)");    }
                        if(response)
                        {
                                if(!strlen(inputtext))return SendClientMessage(playerid,-1,": You can't leave the coloumn blank."),ShowPlayerDialog(playerid,DIALOG_ATTACH_OBJECT2_SELECTION,DIALOG_STYLE_INPUT,"Oyuncu Akesuarlarý: (Obje ID'si girin.)",""COL_WHITE"Aksesuar ID'sini girin, Aksesuar ID'lerini buradan bulabilirsiniz ''http://wiki.sa-mp.com''.","Edit","Back(<<)");
                                if(!IsNumeric(inputtext)) return SendClientMessage(playerid, 0x008000FF, "[BÝLGÝ]"#BEYAZ3" Sadece aksesuar ID'si girebilirsin, isimlere izin verilmez."),ShowPlayerDialog(playerid,DIALOG_ATTACH_OBJECT2_SELECTION,DIALOG_STYLE_INPUT,"Oyuncu Akesuarlarý: (Obje ID'si girin.)",""COL_WHITE"Aksesuar ID'sini girin, Aksesuar ID'lerini buradan bulabilirsiniz ''http://wiki.sa-mp.com''.","Edit","Back(<<)");
                                new obj;
                            if(!sscanf(inputtext, "i", obj))
                                {
                                        if(GetPVarInt(playerid, "AttachmentUsed") == 1) EditAttachedObject(playerid, obj);
                                    else
                                    {
                                            SetPVarInt(playerid, "AttachmentModelSel", obj);
                                            new string[256+1];
                                            new dialog[500];
                                            for(new x;x<sizeof(AttachmentBones);x++)
                                            {
                                                format(string, sizeof(string), "Kemik:%s\n", AttachmentBones[x]);
                                                strcat(dialog,string);
                                            }
                                                ShowPlayerDialog(playerid, DIALOG_ATTACH_BONE_SELECTION, DIALOG_STYLE_LIST, \
                                                "{FF0000}Aksesuar - Kemik Seçin", dialog, "Seç", "Ýptal");
                                    }
                                }
                        }
        }
        case DIALOG_ATTACH_EDITREPLACE:
        {
            if(response) EditAttachedObject(playerid, GetPVarInt(playerid, "AttachmentIndexSel"));
            else
                        {
                            RemovePlayerAttachedObject(playerid, GetPVarInt(playerid, "AttachmentIndexSel"));
                new file[256];
                            new name[24];
                            new x=GetPVarInt(playerid, "AttachmentIndexSel");
                            new f1[15],f2[15],f3[15],f4[15],f5[15],f6[15],f7[15],f8[15],f9[15],f10[15],f11[15];
                            GetPlayerName(playerid,name,24);
                            format(file,sizeof(file),"Player Objects/%s.ini",name);
                            if(!dini_Exists(file)) return 1;
                            format(f1,15,"O_Model_%d",x);
                            format(f2,15,"O_Bone_%d",x);
                                format(f3,15,"O_OffX_%d",x);
                            format(f4,15,"O_OffY_%d",x);
                            format(f5,15,"O_OffZ_%d",x);
                            format(f6,15,"O_RotX_%d",x);
                            format(f7,15,"O_RotY_%d",x);
                            format(f8,15,"O_RotZ_%d",x);
                            format(f9,15,"O_ScaleX_%d",x);
                            format(f10,15,"O_ScaleY_%d",x);
                            format(f11,15,"O_ScaleZ_%d",x);
                            dini_Unset(file,f1);
                            dini_Unset(file,f2);
                            dini_Unset(file,f3);
                            dini_Unset(file,f4);
                            dini_Unset(file,f5);
                            dini_Unset(file,f6);
                            dini_Unset(file,f7);
                            dini_Unset(file,f8);
                            dini_Unset(file,f9);
                            dini_Unset(file,f10);
                            dini_Unset(file,f11);
                                DeletePVar(playerid, "AttachmentIndexSel");
            }
                        return 1;
        }
        case DIALOG_ATTACH_BONE_SELECTION:
        {
            if(response)
            {
                SetPlayerAttachedObject(playerid, GetPVarInt(playerid, "AttachmentIndexSel"), GetPVarInt(playerid, "AttachmentModelSel"), listitem+1);
                EditAttachedObject(playerid, GetPVarInt(playerid, "AttachmentIndexSel"));
                SendClientMessage(playerid, 0x008000FF, "[BÝLGÝ]"#BEYAZ3" SPACE tuþuna basýlý tutarak kamerayý hareket ettirebilirsiniz.");
            }
            DeletePVar(playerid, "AttachmentIndexSel");
            DeletePVar(playerid, "AttachmentModelSel");
            return 1;
        }
    }
    return 0;
}
//==============================================================================
public OnPlayerEditAttachedObject( playerid, response, index, modelid, boneid,
                                   Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ,
                                   Float:fRotX, Float:fRotY, Float:fRotZ,
                                   Float:fScaleX, Float:fScaleY, Float:fScaleZ )
{
    /*new debug_string[256+1];
        format(debug_string,256,"SetPlayerAttachedObject(playerid,%d,%d,%d,%f,%f,%f,%f,%f,%f,%f,%f,%f)",
        index,modelid,boneid,fOffsetX,fOffsetY,fOffsetZ,fRotX,fRotY,fRotZ,fScaleX,fScaleY,fScaleZ);*/

    SetPlayerAttachedObject(playerid,index,modelid,boneid,fOffsetX,fOffsetY,fOffsetZ,fRotX,fRotY,fRotZ,fScaleX,fScaleY,fScaleZ);
    SendClientMessage(playerid, 0x008000FF, "[BÝLGÝ]"#BEYAZ3" Aksesuarý baþarýyla taktýn/düzenledin.");

    new file[256];
    new name[24];
    new f1[15],f2[15],f3[15],f4[15],f5[15],f6[15],f7[15],f8[15],f9[15],f10[15],f11[15];
    GetPlayerName(playerid,name,24);
    format(file,sizeof(file),"Player Objects/%s.ini",name);
    if(!dini_Exists(file)) return 1;
    format(f1,15,"O_Model_%d",index);
    format(f2,15,"O_Bone_%d",index);
        format(f3,15,"O_OffX_%d",index);
    format(f4,15,"O_OffY_%d",index);
    format(f5,15,"O_OffZ_%d",index);
    format(f6,15,"O_RotX_%d",index);
    format(f7,15,"O_RotY_%d",index);
    format(f8,15,"O_RotZ_%d",index);
    format(f9,15,"O_ScaleX_%d",index);
    format(f10,15,"O_ScaleY_%d",index);
    format(f11,15,"O_ScaleZ_%d",index);
    dini_IntSet(file,f1,modelid);
    dini_IntSet(file,f2,boneid);
    dini_FloatSet(file,f3,fOffsetX);
    dini_FloatSet(file,f4,fOffsetY);
    dini_FloatSet(file,f5,fOffsetZ);
    dini_FloatSet(file,f6,fRotX);
    dini_FloatSet(file,f7,fRotY);
    dini_FloatSet(file,f8,fRotZ);
    dini_FloatSet(file,f9,fScaleX);
    dini_FloatSet(file,f10,fScaleY);
    dini_FloatSet(file,f11,fScaleZ);
    return 1;
}
//==============================================================================
public OnPlayerConnect(playerid)
{
    //-----[ mSelection ]-----
        // Init all of the textdraw related globals
    gHeaderTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
    gBackgroundTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
    gCurrentPageTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
    gNextButtonTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
    gPrevButtonTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
    gCancelButtonTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;

    for(new x=0; x < mS_SELECTION_ITEMS; x++) {
        gSelectionItems[playerid][x] = PlayerText:INVALID_TEXT_DRAW;
        }

        gItemAt[playerid] = 0;
        //----------------------

    new file[256];
    new name[24];
    new f1[15],f2[15],f3[15],f4[15],f5[15],f6[15],f7[15],f8[15],f9[15],f10[15],f11[15];
    GetPlayerName(playerid,name,24);
    format(file,sizeof(file),"Player Objects/%s.ini",name);
        if(!dini_Exists(file))
        {
            dini_Create(file);
                for(new x;x<MAX_OSLOTS;x++)
                {
                    if(IsPlayerAttachedObjectSlotUsed(playerid, x))
                    {
                            format(f1,15,"O_Model_%d",x);
                            format(f2,15,"O_Bone_%d",x);
                                format(f3,15,"O_OffX_%d",x);
                            format(f4,15,"O_OffY_%d",x);
                            format(f5,15,"O_OffZ_%d",x);
                            format(f6,15,"O_RotX_%d",x);
                            format(f7,15,"O_RotY_%d",x);
                            format(f8,15,"O_RotZ_%d",x);
                            format(f9,15,"O_ScaleX_%d",x);
                            format(f10,15,"O_ScaleY_%d",x);
                            format(f11,15,"O_ScaleZ_%d",x);
                            dini_IntSet(file,f1,0);
                            dini_IntSet(file,f2,0);
                            dini_FloatSet(file,f3,0.0);
                            dini_FloatSet(file,f4,0.0);
                            dini_FloatSet(file,f5,0.0);
                            dini_FloatSet(file,f6,0.0);
                            dini_FloatSet(file,f7,0.0);
                            dini_FloatSet(file,f8,0.0);
                            dini_FloatSet(file,f9,0.0);
                            dini_FloatSet(file,f10,0.0);
                            dini_FloatSet(file,f11,0.0);
                        }
                }
        }
}
//==============================================================================
public OnPlayerSpawn(playerid)
{
    new file[256];
    new name[24];
    new f1[15],f2[15],f3[15],f4[15],f5[15],f6[15],f7[15],f8[15],f9[15],f10[15],f11[15];
    GetPlayerName(playerid,name,24);
    format(file,sizeof(file),"Player Objects/%s.ini",name);
    if(!dini_Exists(file)) return 1;
    for(new x;x<MAX_OSLOTS;x++)
        {
            format(f1,15,"O_Model_%d",x);
                format(f2,15,"O_Bone_%d",x);
                format(f3,15,"O_OffX_%d",x);
                format(f4,15,"O_OffY_%d",x);
                format(f5,15,"O_OffZ_%d",x);
                format(f6,15,"O_RotX_%d",x);
                format(f7,15,"O_RotY_%d",x);
                format(f8,15,"O_RotZ_%d",x);
                format(f9,15,"O_ScaleX_%d",x);
                format(f10,15,"O_ScaleY_%d",x);
                format(f11,15,"O_ScaleZ_%d",x);
            if(dini_Int(file,f1)!=0)
            {
                SetPlayerAttachedObject(playerid,x,dini_Int(file,f1),dini_Int(file,f2),dini_Float(file,f3),dini_Float(file,f4),dini_Float(file,f5),dini_Float(file,f6),dini_Float(file,f7),dini_Float(file,f8),dini_Float(file,f9),dini_Float(file,f10),dini_Float(file,f11));
                }
        }
        return 1;
}
//==============================================================================
public OnPlayerModelSelectionEx(playerid, response, extraid, modelid2)
{
        if(extraid==DIALOG_ATTACH_MODEL_SELECTION)
        {
            if(!response)
        {   ShowPlayerDialog(playerid,DIALOG_ATTACH_OBJECT_SELECTION,DIALOG_STYLE_LIST,"Oyuncu Aksesuarlarý",""COL_GREY"Aksesuarlar\n"COL_WHITE":"COL_GREY"Özel Aksesuar","Next(>>)","Back(<<)");    }
            if(response)
            {
                    if(GetPVarInt(playerid, "AttachmentUsed") == 1) EditAttachedObject(playerid, modelid2);
                    else
                    {
                            SetPVarInt(playerid, "AttachmentModelSel", modelid2);
                new string[256+1];
                                new dialog[500];
                                for(new x;x<sizeof(AttachmentBones);x++)
                        {
                                        format(string, sizeof(string), "Kemik:%s\n", AttachmentBones[x]);
                                        strcat(dialog,string);
                                }
                                ShowPlayerDialog(playerid, DIALOG_ATTACH_BONE_SELECTION, DIALOG_STYLE_LIST, \
                                "{FF0000}Aksesuar - Kemik Seçin", dialog, "Seç", "Ýptal");
                    }//else DeletePVar(playerid, "AttachmentIndexSel");
                }
        }
        return 1;
}
//==============================================================================
stock IsNumeric(string[])
{
        for (new i = 0, j = strlen(string); i < j; i++)
        {
                if (string[i] > '9' || string[i] < '0') return 0;
        }
        return 1;
}
//==============================================================================
//-----[ mSelection ]-----
stock SetPlayerPosEx(playerid,Float:x,Float:y,Float:z)
{
    TogglePlayerControllable(playerid,false);
        SetPlayerPos(playerid,x,y,z);
        KillTimer(spawntimer[playerid]);
        spawntimer[playerid] = SetTimerEx("Unfreeze",2000,0,"i",playerid);
}
stock mS_GetNumberOfPages(ListID)
{
        new ItemAmount = mS_GetAmountOfListItems(ListID);
        if((ItemAmount >= mS_SELECTION_ITEMS) && (ItemAmount % mS_SELECTION_ITEMS) == 0)
        {
                return (ItemAmount / mS_SELECTION_ITEMS);
        }
        else return (ItemAmount / mS_SELECTION_ITEMS) + 1;
}
stock mS_GetNumberOfPagesEx(playerid)
{
        new ItemAmount = mS_GetAmountOfListItemsEx(playerid);
        if((ItemAmount >= mS_SELECTION_ITEMS) && (ItemAmount % mS_SELECTION_ITEMS) == 0)
        {
                return (ItemAmount / mS_SELECTION_ITEMS);
        }
        else return (ItemAmount / mS_SELECTION_ITEMS) + 1;
}
stock mS_GetAmountOfListItems(ListID)
{
        return (gLists[ListID][mS_LIST_END] - gLists[ListID][mS_LIST_START])+1;
}
stock mS_GetAmountOfListItemsEx(playerid)
{
        return GetPVarInt(playerid, "mS_custom_item_amount");
}
stock mS_GetPlayerCurrentListID(playerid)
{
        if(GetPVarInt(playerid, "mS_list_active") == 1) return GetPVarInt(playerid, "mS_list_id");
        else return mS_INVALID_LISTID;
}
stock PlayerText:mS_CreateCurrentPageTextDraw(playerid, Float:Xpos, Float:Ypos)
{
        new PlayerText:txtInit;
        txtInit = CreatePlayerTextDraw(playerid, Xpos, Ypos, "0/0");
        PlayerTextDrawUseBox(playerid, txtInit, 0);
        PlayerTextDrawLetterSize(playerid, txtInit, 0.4, 1.1);
        PlayerTextDrawFont(playerid, txtInit, 1);
        PlayerTextDrawSetShadow(playerid, txtInit, 0);
    PlayerTextDrawSetOutline(playerid, txtInit, 1);
    PlayerTextDrawColor(playerid, txtInit, 0xACCBF1FF);
    PlayerTextDrawShow(playerid, txtInit);
    return txtInit;
}
stock PlayerText:mS_CreatePlayerDialogButton(playerid, Float:Xpos, Float:Ypos, Float:Width, Float:Height, button_text[])
{
        new PlayerText:txtInit;
        txtInit = CreatePlayerTextDraw(playerid, Xpos, Ypos, button_text);
        PlayerTextDrawUseBox(playerid, txtInit, 1);
        PlayerTextDrawBoxColor(playerid, txtInit, 0x000000FF);
        PlayerTextDrawBackgroundColor(playerid, txtInit, 0x000000FF);
        PlayerTextDrawLetterSize(playerid, txtInit, 0.4, 1.1);
        PlayerTextDrawFont(playerid, txtInit, 1);
        PlayerTextDrawSetShadow(playerid, txtInit, 0); // no shadow
    PlayerTextDrawSetOutline(playerid, txtInit, 0);
    PlayerTextDrawColor(playerid, txtInit, 0x4A5A6BFF);
    PlayerTextDrawSetSelectable(playerid, txtInit, 1);
    PlayerTextDrawAlignment(playerid, txtInit, 2);
    PlayerTextDrawTextSize(playerid, txtInit, Height, Width); // The width and height are reversed for centering.. something the game does <g>
    PlayerTextDrawShow(playerid, txtInit);
    return txtInit;
}
stock PlayerText:mS_CreatePlayerHeaderTextDraw(playerid, Float:Xpos, Float:Ypos, header_text[])
{
        new PlayerText:txtInit;
        txtInit = CreatePlayerTextDraw(playerid, Xpos, Ypos, header_text);
        PlayerTextDrawUseBox(playerid, txtInit, 0);
        PlayerTextDrawLetterSize(playerid, txtInit, 1.25, 3.0);
        PlayerTextDrawFont(playerid, txtInit, 0);
        PlayerTextDrawSetShadow(playerid, txtInit, 0);
    PlayerTextDrawSetOutline(playerid, txtInit, 1);
    PlayerTextDrawColor(playerid, txtInit, 0xACCBF1FF);
    PlayerTextDrawShow(playerid, txtInit);
    return txtInit;
}
stock PlayerText:mS_CreatePlayerBGTextDraw(playerid, Float:Xpos, Float:Ypos, Float:Width, Float:Height, bgcolor)
{
        new PlayerText:txtBackground = CreatePlayerTextDraw(playerid, Xpos, Ypos,"                                            ~n~"); // enough space for everyone
    PlayerTextDrawUseBox(playerid, txtBackground, 1);
    PlayerTextDrawBoxColor(playerid, txtBackground, bgcolor);
        PlayerTextDrawLetterSize(playerid, txtBackground, 5.0, 5.0);
        PlayerTextDrawFont(playerid, txtBackground, 0);
        PlayerTextDrawSetShadow(playerid, txtBackground, 0);
    PlayerTextDrawSetOutline(playerid, txtBackground, 0);
    PlayerTextDrawColor(playerid, txtBackground,0x000000FF);
    PlayerTextDrawTextSize(playerid, txtBackground, Width, Height);
        PlayerTextDrawBackgroundColor(playerid, txtBackground, bgcolor);
    PlayerTextDrawShow(playerid, txtBackground);
    return txtBackground;
}
stock PlayerText:mS_CreateMPTextDraw(playerid, modelindex, Float:Xpos, Float:Ypos, Float:Xrot, Float:Yrot, Float:Zrot, Float:mZoom, Float:width, Float:height, bgcolor)
{
    new PlayerText:txtPlayerSprite = CreatePlayerTextDraw(playerid, Xpos, Ypos, ""); // it has to be set with SetText later
    PlayerTextDrawFont(playerid, txtPlayerSprite, TEXT_DRAW_FONT_MODEL_PREVIEW);
    PlayerTextDrawColor(playerid, txtPlayerSprite, 0xFFFFFFFF);
    PlayerTextDrawBackgroundColor(playerid, txtPlayerSprite, bgcolor);
    PlayerTextDrawTextSize(playerid, txtPlayerSprite, width, height); // Text size is the Width:Height
    PlayerTextDrawSetPreviewModel(playerid, txtPlayerSprite, modelindex);
    PlayerTextDrawSetPreviewRot(playerid,txtPlayerSprite, Xrot, Yrot, Zrot, mZoom);
    PlayerTextDrawSetSelectable(playerid, txtPlayerSprite, 1);
    PlayerTextDrawShow(playerid,txtPlayerSprite);
    return txtPlayerSprite;
}
stock mS_DestroyPlayerMPs(playerid)
{
        new x=0;
        while(x != mS_SELECTION_ITEMS) {
            if(gSelectionItems[playerid][x] != PlayerText:INVALID_TEXT_DRAW) {
                        PlayerTextDrawDestroy(playerid, gSelectionItems[playerid][x]);
                        gSelectionItems[playerid][x] = PlayerText:INVALID_TEXT_DRAW;
                }
                x++;
        }
}
stock mS_ShowPlayerMPs(playerid)
{
        new bgcolor = GetPVarInt(playerid, "mS_previewBGcolor");
    new x=0;
        new Float:BaseX = mS_DIALOG_BASE_X;
        new Float:BaseY = mS_DIALOG_BASE_Y - (mS_SPRITE_DIM_Y * 0.33); // down a bit
        new linetracker = 0;

        new mS_listID = mS_GetPlayerCurrentListID(playerid);
        if(mS_listID == mS_CUSTOM_LISTID)
        {
                new itemat = (GetPVarInt(playerid, "mS_list_page") * mS_SELECTION_ITEMS);
                new Float:rotzoom[4];
                rotzoom[0] = GetPVarFloat(playerid, "mS_custom_Xrot");
                rotzoom[1] = GetPVarFloat(playerid, "mS_custom_Yrot");
                rotzoom[2] = GetPVarFloat(playerid, "mS_custom_Zrot");
                rotzoom[3] = GetPVarFloat(playerid, "mS_custom_Zoom");
                new itemamount = mS_GetAmountOfListItemsEx(playerid);
                // Destroy any previous ones created
                mS_DestroyPlayerMPs(playerid);

                while(x != mS_SELECTION_ITEMS && itemat < (itemamount)) {
                        if(linetracker == 0) {
                                BaseX = mS_DIALOG_BASE_X + 25.0; // in a bit from the box
                                BaseY += mS_SPRITE_DIM_Y + 1.0; // move on the Y for the next line
                        }
                        gSelectionItems[playerid][x] = mS_CreateMPTextDraw(playerid, gCustomList[playerid][itemat], BaseX, BaseY, rotzoom[0], rotzoom[1], rotzoom[2], rotzoom[3], mS_SPRITE_DIM_X, mS_SPRITE_DIM_Y, bgcolor);
                        gSelectionItemsTag[playerid][x] = gCustomList[playerid][itemat];
                        BaseX += mS_SPRITE_DIM_X + 1.0; // move on the X for the next sprite
                        linetracker++;
                        if(linetracker == mS_ITEMS_PER_LINE) linetracker = 0;
                        itemat++;
                        x++;
                }
        }
        else
        {
                new itemat = (gLists[mS_listID][mS_LIST_START] + (GetPVarInt(playerid, "mS_list_page") * mS_SELECTION_ITEMS));

                // Destroy any previous ones created
                mS_DestroyPlayerMPs(playerid);

                while(x != mS_SELECTION_ITEMS && itemat < (gLists[mS_listID][mS_LIST_END]+1)) {
                        if(linetracker == 0) {
                                BaseX = mS_DIALOG_BASE_X + 25.0; // in a bit from the box
                                BaseY += mS_SPRITE_DIM_Y + 1.0; // move on the Y for the next line
                        }
                        new rzID = gItemList[itemat][mS_ITEM_ROT_ZOOM_ID]; // avoid long line
                        if(rzID > -1) gSelectionItems[playerid][x] = mS_CreateMPTextDraw(playerid, gItemList[itemat][mS_ITEM_MODEL], BaseX, BaseY, gRotZoom[rzID][0], gRotZoom[rzID][1], gRotZoom[rzID][2], gRotZoom[rzID][3], mS_SPRITE_DIM_X, mS_SPRITE_DIM_Y, bgcolor);
                        else gSelectionItems[playerid][x] = mS_CreateMPTextDraw(playerid, gItemList[itemat][mS_ITEM_MODEL], BaseX, BaseY, 0.0, 0.0, 0.0, 1.0, mS_SPRITE_DIM_X, mS_SPRITE_DIM_Y, bgcolor);
                        gSelectionItemsTag[playerid][x] = gItemList[itemat][mS_ITEM_MODEL];
                        BaseX += mS_SPRITE_DIM_X + 1.0; // move on the X for the next sprite
                        linetracker++;
                        if(linetracker == mS_ITEMS_PER_LINE) linetracker = 0;
                        itemat++;
                        x++;
                }
        }
}
stock mS_UpdatePageTextDraw(playerid)
{
        new PageText[64+1];
        new listID = mS_GetPlayerCurrentListID(playerid);
        if(listID == mS_CUSTOM_LISTID)
        {
                format(PageText, 64, "%d/%d", GetPVarInt(playerid,"mS_list_page") + 1, mS_GetNumberOfPagesEx(playerid));
                PlayerTextDrawSetString(playerid, gCurrentPageTextDrawId[playerid], PageText);
        }
        else
        {
                format(PageText, 64, "%d/%d", GetPVarInt(playerid,"mS_list_page") + 1, mS_GetNumberOfPages(listID));
                PlayerTextDrawSetString(playerid, gCurrentPageTextDrawId[playerid], PageText);
        }
}
stock ShowModelSelectionMenu(playerid, ListID, header_text[], dialogBGcolor = 0x4A5A6BBB, previewBGcolor = 0x88888899 , tdSelectionColor = 0xFFFF00AA)
{
        if(!(0 <= ListID < mS_TOTAL_LISTS && gLists[ListID][mS_LIST_START] != gLists[ListID][mS_LIST_END])) return 0;
        mS_DestroySelectionMenu(playerid);
        SetPVarInt(playerid, "mS_list_page", 0);
        SetPVarInt(playerid, "mS_list_id", ListID);
        SetPVarInt(playerid, "mS_list_active", 1);
        SetPVarInt(playerid, "mS_list_time", GetTickCount());

    gBackgroundTextDrawId[playerid] = mS_CreatePlayerBGTextDraw(playerid, mS_DIALOG_BASE_X, mS_DIALOG_BASE_Y + 20.0, mS_DIALOG_WIDTH, mS_DIALOG_HEIGHT, dialogBGcolor);
    gHeaderTextDrawId[playerid] = mS_CreatePlayerHeaderTextDraw(playerid, mS_DIALOG_BASE_X, mS_DIALOG_BASE_Y, header_text);
    gCurrentPageTextDrawId[playerid] = mS_CreateCurrentPageTextDraw(playerid, mS_DIALOG_WIDTH - 30.0, mS_DIALOG_BASE_Y + 15.0);
    gNextButtonTextDrawId[playerid] = mS_CreatePlayerDialogButton(playerid, mS_DIALOG_WIDTH - 30.0, mS_DIALOG_BASE_Y+mS_DIALOG_HEIGHT+100.0, 50.0, 16.0, mS_NEXT_TEXT);
    gPrevButtonTextDrawId[playerid] = mS_CreatePlayerDialogButton(playerid, mS_DIALOG_WIDTH - 90.0, mS_DIALOG_BASE_Y+mS_DIALOG_HEIGHT+100.0, 50.0, 16.0, mS_PREV_TEXT);
    //gCancelButtonTextDrawId[playerid] = mS_CreatePlayerDialogButton(playerid, mS_DIALOG_WIDTH - 150.0, mS_DIALOG_BASE_Y+mS_DIALOG_HEIGHT+100.0, 50.0, 16.0, mS_CANCEL_TEXT);

        SetPVarInt(playerid, "mS_previewBGcolor", previewBGcolor);
    mS_ShowPlayerMPs(playerid);
    mS_UpdatePageTextDraw(playerid);

        SelectTextDraw(playerid, tdSelectionColor);
        return 1;
}
stock ShowModelSelectionMenuEx(playerid, items_array[], item_amount, header_text[], extraid, Float:Xrot = 0.0, Float:Yrot = 0.0, Float:Zrot = 0.0, Float:mZoom = 1.0, dialogBGcolor = 0x4A5A6BBB, previewBGcolor = 0x88888899 , tdSelectionColor = 0xFFFF00AA)
{
        mS_DestroySelectionMenu(playerid);
        if(item_amount > mS_CUSTOM_MAX_ITEMS)
        {
                item_amount = mS_CUSTOM_MAX_ITEMS;
                print("-mSelection- WARNING: Too many items given to \"ShowModelSelectionMenuEx\", increase \"mS_CUSTOM_MAX_ITEMS\" to fix this");
        }
        if(item_amount > 0)
        {
                for(new i=0;i<item_amount;i++)
                {
                        gCustomList[playerid][i] = items_array[i];
                }
                SetPVarInt(playerid, "mS_list_page", 0);
                SetPVarInt(playerid, "mS_list_id", mS_CUSTOM_LISTID);
                SetPVarInt(playerid, "mS_list_active", 1);
                SetPVarInt(playerid, "mS_list_time", GetTickCount());

                SetPVarInt(playerid, "mS_custom_item_amount", item_amount);
                SetPVarFloat(playerid, "mS_custom_Xrot", Xrot);
                SetPVarFloat(playerid, "mS_custom_Yrot", Yrot);
                SetPVarFloat(playerid, "mS_custom_Zrot", Zrot);
                SetPVarFloat(playerid, "mS_custom_Zoom", mZoom);
                SetPVarInt(playerid, "mS_custom_extraid", extraid);


                gBackgroundTextDrawId[playerid] = mS_CreatePlayerBGTextDraw(playerid, mS_DIALOG_BASE_X, mS_DIALOG_BASE_Y + 20.0, mS_DIALOG_WIDTH, mS_DIALOG_HEIGHT, dialogBGcolor);
                gHeaderTextDrawId[playerid] = mS_CreatePlayerHeaderTextDraw(playerid, mS_DIALOG_BASE_X, mS_DIALOG_BASE_Y, header_text);
                gCurrentPageTextDrawId[playerid] = mS_CreateCurrentPageTextDraw(playerid, mS_DIALOG_WIDTH - 30.0, mS_DIALOG_BASE_Y + 15.0);
                gNextButtonTextDrawId[playerid] = mS_CreatePlayerDialogButton(playerid, mS_DIALOG_WIDTH - 30.0, mS_DIALOG_BASE_Y+mS_DIALOG_HEIGHT+100.0, 50.0, 16.0, mS_NEXT_TEXT);
                gPrevButtonTextDrawId[playerid] = mS_CreatePlayerDialogButton(playerid, mS_DIALOG_WIDTH - 90.0, mS_DIALOG_BASE_Y+mS_DIALOG_HEIGHT+100.0, 50.0, 16.0, mS_PREV_TEXT);
                gCancelButtonTextDrawId[playerid] = mS_CreatePlayerDialogButton(playerid, mS_DIALOG_WIDTH - 150.0, mS_DIALOG_BASE_Y+mS_DIALOG_HEIGHT+100.0, 50.0, 16.0, mS_CANCEL_TEXT);

                SetPVarInt(playerid, "mS_previewBGcolor", previewBGcolor);
                mS_ShowPlayerMPs(playerid);
                mS_UpdatePageTextDraw(playerid);

                SelectTextDraw(playerid, tdSelectionColor);
                return 1;
        }
        return 0;
}
stock HideModelSelectionMenu(playerid)
{
        mS_DestroySelectionMenu(playerid);
        SetPVarInt(playerid, "mS_ignore_next_esc", 1);
        CancelSelectTextDraw(playerid);
        return 1;
}
stock mS_DestroySelectionMenu(playerid)
{
        if(GetPVarInt(playerid, "mS_list_active") == 1)
        {
                if(mS_GetPlayerCurrentListID(playerid) == mS_CUSTOM_LISTID)
                {
                        DeletePVar(playerid, "mS_custom_Xrot");
                        DeletePVar(playerid, "mS_custom_Yrot");
                        DeletePVar(playerid, "mS_custom_Zrot");
                        DeletePVar(playerid, "mS_custom_Zoom");
                        DeletePVar(playerid, "mS_custom_extraid");
                        DeletePVar(playerid, "mS_custom_item_amount");
                }
                DeletePVar(playerid, "mS_list_time");
                SetPVarInt(playerid, "mS_list_active", 0);
                mS_DestroyPlayerMPs(playerid);

                PlayerTextDrawDestroy(playerid, gHeaderTextDrawId[playerid]);
                PlayerTextDrawDestroy(playerid, gBackgroundTextDrawId[playerid]);
                PlayerTextDrawDestroy(playerid, gCurrentPageTextDrawId[playerid]);
                PlayerTextDrawDestroy(playerid, gNextButtonTextDrawId[playerid]);
                PlayerTextDrawDestroy(playerid, gPrevButtonTextDrawId[playerid]);
                PlayerTextDrawDestroy(playerid, gCancelButtonTextDrawId[playerid]);

                gHeaderTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
                gBackgroundTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
                gCurrentPageTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
                gNextButtonTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
                gPrevButtonTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
                gCancelButtonTextDrawId[playerid] = PlayerText:INVALID_TEXT_DRAW;
        }
}
// Even though only Player* textdraws are used in this script,
// OnPlayerClickTextDraw is still required to handle ESC
public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
        if(GetPVarInt(playerid, "mS_ignore_next_esc") == 1) {
                SetPVarInt(playerid, "mS_ignore_next_esc", 0);
                return CallLocalFunction("MP_OPCTD", "ii", playerid, _:clickedid);
        }
        if(GetPVarInt(playerid, "mS_list_active") == 0) return CallLocalFunction("MP_OPCTD", "ii", playerid, _:clickedid);

        // Handle: They cancelled (with ESC)
        if(clickedid == Text:INVALID_TEXT_DRAW) {
                new listid = mS_GetPlayerCurrentListID(playerid);
                if(listid == mS_CUSTOM_LISTID)
                {
                        new extraid = GetPVarInt(playerid, "mS_custom_extraid");
                        mS_DestroySelectionMenu(playerid);
                        CallLocalFunction("OnPlayerModelSelectionEx", "dddd", playerid, 0, extraid, -1);
                        PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
                }
                else
                {
                        mS_DestroySelectionMenu(playerid);
                        CallLocalFunction("OnPlayerModelSelection", "dddd", playerid, 0, listid, -1);
                        PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
                }
        return 1;
        }

        return CallLocalFunction("MP_OPCTD", "ii", playerid, _:clickedid);
}
#if defined _ALS_OnPlayerClickTextDraw
        #undef OnPlayerClickTextDraw
#else
        #define _ALS_OnPlayerClickTextDraw
#endif
#define OnPlayerClickTextDraw MP_OPCTD
forward MP_OPCTD(playerid, Text:clickedid);
public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
        if(GetPVarInt(playerid, "mS_list_active") == 0 || (GetTickCount()-GetPVarInt(playerid, "mS_list_time")) < 200 /* Disable instant selection */) return CallLocalFunction("MP_OPCPTD", "ii", playerid, _:playertextid);

        new curpage = GetPVarInt(playerid, "mS_list_page");

        // Handle: cancel button
        if(playertextid == gCancelButtonTextDrawId[playerid]) {
                new listID = mS_GetPlayerCurrentListID(playerid);
                if(listID == mS_CUSTOM_LISTID)
                {
                        new extraid = GetPVarInt(playerid, "mS_custom_extraid");
                        HideModelSelectionMenu(playerid);
                        CallLocalFunction("OnPlayerModelSelectionEx", "dddd", playerid, 0, extraid, -1);
                        PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
                }
                else
                {
                        HideModelSelectionMenu(playerid);
                        CallLocalFunction("OnPlayerModelSelection", "dddd", playerid, 0, listID, -1);
                        PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
                }
                return 1;
        }

        // Handle: next button
        if(playertextid == gNextButtonTextDrawId[playerid]) {
                new listID = mS_GetPlayerCurrentListID(playerid);
                if(listID == mS_CUSTOM_LISTID)
                {
                        if(curpage < (mS_GetNumberOfPagesEx(playerid) - 1)) {
                                SetPVarInt(playerid, "mS_list_page", curpage + 1);
                                mS_ShowPlayerMPs(playerid);
                                mS_UpdatePageTextDraw(playerid);
                                PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
                        } else {
                                PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
                        }
                }
                else
                {
                        if(curpage < (mS_GetNumberOfPages(listID) - 1)) {
                                SetPVarInt(playerid, "mS_list_page", curpage + 1);
                                mS_ShowPlayerMPs(playerid);
                                mS_UpdatePageTextDraw(playerid);
                                PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
                        } else {
                                PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
                        }
                }
                return 1;
        }

        // Handle: previous button
        if(playertextid == gPrevButtonTextDrawId[playerid]) {
            if(curpage > 0) {
                SetPVarInt(playerid, "mS_list_page", curpage - 1);
                mS_ShowPlayerMPs(playerid);
                mS_UpdatePageTextDraw(playerid);
                PlayerPlaySound(playerid, 1084, 0.0, 0.0, 0.0);
                } else {
                    PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
                }
                return 1;
        }

        // Search in the array of textdraws used for the items
        new x=0;
        while(x != mS_SELECTION_ITEMS) {
            if(playertextid == gSelectionItems[playerid][x]) {
                        new listID = mS_GetPlayerCurrentListID(playerid);
                        if(listID == mS_CUSTOM_LISTID)
                        {
                                PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
                                new item_id = gSelectionItemsTag[playerid][x];
                                new extraid = GetPVarInt(playerid, "mS_custom_extraid");
                                HideModelSelectionMenu(playerid);
                                CallLocalFunction("OnPlayerModelSelectionEx", "dddd", playerid, 1, extraid, item_id);
                                return 1;
                        }
                        else
                        {
                                PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
                                new item_id = gSelectionItemsTag[playerid][x];
                                HideModelSelectionMenu(playerid);
                                CallLocalFunction("OnPlayerModelSelection", "dddd", playerid, 1, listID, item_id);
                                return 1;
                        }
                }
                x++;
        }

        return CallLocalFunction("MP_OPCPTD", "ii", playerid, _:playertextid);
}
#if defined _ALS_OnPlayerClickPlayerTD
        #undef OnPlayerClickPlayerTextDraw
#else
        #define _ALS_OnPlayerClickPlayerTD
#endif
#define OnPlayerClickPlayerTextDraw MP_OPCPTD
forward MP_OPCPTD(playerid, PlayerText:playertextid);
stock LoadModelSelectionMenu(f_name[])
{
        new File:f, str[75];
        format(str, sizeof(str), "%s", f_name);
        f = fopen(str, io_read);
        if( !f ) {
                printf("-mSelection- WARNING: Failed to load list: \"%s\"", f_name);
                return mS_INVALID_LISTID;
        }

        if(gListAmount >= mS_TOTAL_LISTS)
        {
                printf("-mSelection- WARNING: Reached maximum amount of lists, increase \"mS_TOTAL_LISTS\"", f_name);
                return mS_INVALID_LISTID;
        }
        new tmp_ItemAmount = gItemAmount; // copy value if loading fails


        new line2[128], idxx;
        while(fread(f,line2,sizeof(line2),false))
        {
                if(tmp_ItemAmount >= mS_TOTAL_ITEMS)
                {
                        printf("-mSelection- WARNING: Reached maximum amount of items, increase \"mS_TOTAL_ITEMS\"", f_name);
                        break;
                }
                idxx = 0;
                if(!line2[0]) continue;
                new mID = strval( mS_strtok(line2,idxx) );
                if(0 <= mID < 20000)
                {
                        gItemList[tmp_ItemAmount][mS_ITEM_MODEL] = mID;

                        new tmp_mS_strtok[20];
                        new Float:mRotation[3], Float:mZoom = 1.0;
                        new bool:useRotation = false;

                        tmp_mS_strtok = mS_strtok(line2,idxx);
                        if(tmp_mS_strtok[0]) {
                                useRotation = true;
                                mRotation[0] = floatstr(tmp_mS_strtok);
                        }
                        tmp_mS_strtok = mS_strtok(line2,idxx);
                        if(tmp_mS_strtok[0]) {
                                useRotation = true;
                                mRotation[1] = floatstr(tmp_mS_strtok);
                        }
                        tmp_mS_strtok = mS_strtok(line2,idxx);
                        if(tmp_mS_strtok[0]) {
                                useRotation = true;
                                mRotation[2] = floatstr(tmp_mS_strtok);
                        }
                        tmp_mS_strtok = mS_strtok(line2,idxx);
                        if(tmp_mS_strtok[0]) {
                                useRotation = true;
                                mZoom = floatstr(tmp_mS_strtok);
                        }
                        if(useRotation)
                        {
                                new bool:foundRotZoom = false;
                                for(new i=0; i < gRotZoomAmount; i++)
                                {
                                        if(gRotZoom[i][0] == mRotation[0] && gRotZoom[i][1] == mRotation[1] && gRotZoom[i][2] == mRotation[2] && gRotZoom[i][3] == mZoom)
                                        {
                                                foundRotZoom = true;
                                                gItemList[tmp_ItemAmount][mS_ITEM_ROT_ZOOM_ID] = i;
                                                break;
                                        }
                                }
                                if(gRotZoomAmount < mS_TOTAL_ROT_ZOOM)
                                {
                                        if(!foundRotZoom)
                                        {
                                                gRotZoom[gRotZoomAmount][0] = mRotation[0];
                                                gRotZoom[gRotZoomAmount][1] = mRotation[1];
                                                gRotZoom[gRotZoomAmount][2] = mRotation[2];
                                                gRotZoom[gRotZoomAmount][3] = mZoom;
                                                gItemList[tmp_ItemAmount][mS_ITEM_ROT_ZOOM_ID] = gRotZoomAmount;
                                                gRotZoomAmount++;
                                        }
                                }
                                else print("-mSelection- WARNING: Not able to save rotation/zoom information. Reached maximum rotation/zoom information count. Increase '#define mS_TOTAL_ROT_ZOOM' to fix the issue");
                        }
                        else gItemList[tmp_ItemAmount][mS_ITEM_ROT_ZOOM_ID] = -1;
                        tmp_ItemAmount++;
                }
        }
        if(tmp_ItemAmount > gItemAmount) // any models loaded ?
        {
                gLists[gListAmount][mS_LIST_START] = gItemAmount;
                gItemAmount = tmp_ItemAmount; // copy back
                gLists[gListAmount][mS_LIST_END] = (gItemAmount-1);

                gListAmount++;
                return (gListAmount-1);
        }
        printf("-mSelection- WARNING: No Items found in file: %s", f_name);
        return mS_INVALID_LISTID;
}
stock mS_strtok(const string[], &index)
{
        new length = strlen(string);
        while ((index < length) && (string[index] <= ' '))
        {
                index++;
        }

        new offset = index;
        new result[20];
        while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
        {
                result[index - offset] = string[index];
                index++;
        }
        result[index - offset] = EOS;
        return result;
}
//----------------------
