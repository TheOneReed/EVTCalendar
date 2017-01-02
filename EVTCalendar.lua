----------------------------------------------------------------
-- EVTCalendar
-- Author: Reed
--
--
----------------------------------------------------------------
EVT_VERSION = "1.2";


---Initialize tables
player_Info = {};
invite_Queue = {};
CalendarOptions = {
	["buttonLocked"] = true,
	["milFormat"] = false,
	["frameDrag"] = false,
	["acceptEvents"] = false,
	["confirmEvents"] = false
	};
	
selectedButton = nil;

local table_Days = {};
local table_DayStr = {};
local table_DayVal = {};
local table_DayTex = {};
local table_DayPos = {};


---Initialize variables
local displayMonth;
local displayYear;
local displayDay;
local displayPos;
local eventClicked;

local initialized = false;
local varsLoaded = false;

-- Asset Location
local Img = {
    ["DayActive"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTDayFrameActive",
    ["DayInactive"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTDayFrameInactive",
    ["DayToday"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTDayFrameToday",
    ["DaySelected"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTDayFrameSelected",
    ["DayHighlight"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTDayFrameHighlight",
    ["IcoCthun"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTIcoCthun",
    ["IcoOssirian"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTIcoOssirian",
    ["IcoOnyxia"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTIcoOnyxia",
    ["IcoNefarian"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTIcoNefarian",
    ["IcoHakkar"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTIcoHakkar",
    ["IcoRagnaros"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTIcoRagnaros",
    ["IcoKelthuzad"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTIcoKelthuzad",
    ["IcoInstance"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTIcoInstance",
    ["IcoMeeting"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTIcoMeeting",
    ["IcoQuest"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTIcoQuest",
    ["IcoOther"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTIcoOther",
    ["IcoPvP"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTIcoPvP",
    ["SWinterveil"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTSWinterveil",
    ["SWinterveilInactive"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTSWinterveilInactive",
    ["Winterveil"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTWinterveil",
    ["IWinterveil"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTIWinterveil",
    ["EWinterveil"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTEWinterveil",
    ["EWinterveilInactive"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTEWinterveilInactive",
    ["SNobleGarden"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTSNobleGarden",
    ["SNobleGardenInactive"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTSNobleGardenInactive",
    ["NobleGarden"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTNobleGarden",
    ["INobleGarden"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTINobleGarden",
    ["ENobleGarden"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTENobleGarden",
    ["ENobleGardenInactive"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTENobleGardenInactive",
    ["SLoveIsInTheAir"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTSLoveIsInTheAir",
    ["SLoveIsInTheAirInactive"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTSLoveIsInTheAirInactive",
    ["ILoveIsInTheAir"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTILoveIsInTheAir",
    ["LoveIsInTheAir"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTLoveIsInTheAir",
    ["ELoveIsInTheAir"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTELoveIsInTheAir",
    ["ELoveIsInTheAirInactive"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTELoveIsInTheAirInactive",
    ["SHallowsEnd"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTSHallowsEnd",
    ["SHallowsEndInactive"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTSHallowsEndInactive",
    ["HallowsEnd"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTHallowsEnd",
    ["IHallowsEnd"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTIHallowsEnd",
    ["EHallowsEnd"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTEHallowsEnd",
    ["EHallowsEndInactive"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTEHallowsEndInactive",
    ["SLunarFestival"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTSLunarFestival",
    ["SLunarFestivalInactive"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTSLunarFestivalInactive",
    ["LunarFestival"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTLunarFestival",
    ["ILunarFestival"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTILunarFestival",
    ["ELunarFestival"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTELunarFestival",
    ["ELunarFestivalInactive"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTELunarFestivalInactive",
    ["SChildrensWeek"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTSChildrensWeek",
    ["SChildrensWeekInactive"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTSChildrensWeekInactive",
    ["ChildrensWeek"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTChildrensWeek",
    ["IChildrensWeek"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTIChildrensWeek",
    ["EChildrensWeek"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTEChildrensWeek",
    ["EChildrensWeekInactive"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTEChildrensWeekInactive",
    ["SMidSummer"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTSMidSummer",
    ["SMidSummerInactive"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTSMidSummerInactive",
    ["MidSummer"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTMidSummer",
    ["IMidSummer"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTIMidSummer",
    ["EMidSummer"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTEMidSummer",
    ["EMidSummerInactive"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTEMidSummerInactive",
    ["SHarvestFestival"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTSHarvestFestival",
    ["SHarvestFestivalInactive"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTSHarvestFestivalInactive",
    ["HarvestFestival"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTHarvestFestival",
    ["IHarvestFestival"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTIHarvestFestival",
    ["EHarvestFestival"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTEHarvestFestival",
    ["EHarvestFestivalInactive"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTEHarvestFestivalInactive",
    ["SElwynn"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTSElwynn",
    ["SElwynnInactive"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTSElwynnInactive",
    ["DarkmoonFaire"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTDarkmoonFaire",
    ["IDarkmoonFaire"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTIDarkmoonFaire",
    ["EElwynn"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTEElwynn",
    ["EElwynnInactive"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTEElwynnInactive",
    ["SMulgore"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTSMulgore",
    ["SMulgoreInactive"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTSMulgoreInactive",
    ["EMulgore"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTEMulgore",
    ["EMulgoreInactive"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTEMulgoreInactive",
    ["Fishing"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTFishing",
    ["IFishing"] = "Interface\\AddOns\\EVTCalendar\\Images\\EVTIFishing"
	}

-- Calendar Data Table

function EVT_ResetDisplayDate()
    displayDay = currentDay();
    displayMonth = currentMonth();
    displayYear = currentYear();
	displayPos = nil;
end

function EVT_OnLoad()
    this:RegisterEvent("ADDON_LOADED");
    this:RegisterEvent("VARIABLES_LOADED");
    this:RegisterEvent("CHAT_MSG_ADDON"); 
	tinsert(UISpecialFrames, "EVTFrame");
    
    SLASH_EVT1 = EVT_SLASH;
    SlashCmdList["EVT"] = function(msg)
		EVT_SlashCommand(msg);
	end
end

function EVT_SlashCommand(msg)

	if(msg == EVT_ABOUT) then
		DEFAULT_CHAT_FRAME:AddMessage("-----"..EVT_CALENDAR..": "..EVT_ABOUT.."-----", 0.8, 0.8, 0.1);
		DEFAULT_CHAT_FRAME:AddMessage("Version: "..EVT_VERSION, 0.8, 0.8, 0.1);
		DEFAULT_CHAT_FRAME:AddMessage("Created by: TheOneReed", 0.8, 0.8, 0.1);
		DEFAULT_CHAT_FRAME:AddMessage("Website: https://github.com/TheOneReed/EVTCalendar", 0.8, 0.8, 0.1);
	elseif(msg == EVT_HELP) then
		DEFAULT_CHAT_FRAME:AddMessage("-----"..EVT_CALENDAR..": "..EVT_HELP.."-----", 0.8, 0.8, 0.1);
		DEFAULT_CHAT_FRAME:AddMessage("about : Displays addon info.", 0.8, 0.8, 0.1);
		DEFAULT_CHAT_FRAME:AddMessage("help : Displays this menu.", 0.8, 0.8, 0.1);
		DEFAULT_CHAT_FRAME:AddMessage("unlock : Enables frame dragging.", 0.8, 0.8, 0.1);
		DEFAULT_CHAT_FRAME:AddMessage("lock : Disables frame dragging.", 0.8, 0.8, 0.1);
		DEFAULT_CHAT_FRAME:AddMessage("reset : Returns frames back to default position.", 0.8, 0.8, 0.1);
	elseif(msg == "unlock") then
		CalendarOptions["frameDrag"] = true;
		EVTButton_Unlock();
	elseif(msg == "lock") then
		CalendarOptions["frameDrag"] = false;
		EVTButton_Lock();
	elseif(msg == "reset") then
		EVTFrameOptionsReset_OnClick()
	elseif(msg == "test") then
		CalendarOptions["milFormat"] = not CalendarOptions["milFormat"];
	else
		if EVTButtonPulsing then
			EVT_ShowNextInvite();
		else
			EVT_Toggle();
		end
	end
end

function EVT_OnEvent()
	if (event == "ADDON_LOADED") then
		if (strlower(arg1) == "evtcalendar") then
			varsLoaded = true;
			EVT_Initialize();
		end
	elseif (event == "VARIABLES_LOADED") then
		if (not varsLoaded) then
			varsLoaded = true;
			EVT_Initialize();
		end
	elseif (event == "CHAT_MSG_ADDON") then
		if (strlower(arg1) == "evtcalendar") then
			EVTIncMessage(arg2, arg4, arg3);
		end		
	end
end

function EVT_Initialize()
    displayMonth = date("%m") + 0;
    displayDay = date("%d") + 0;
    displayYear = date("%Y") + 0;
	if (CalendarData == nil) then
		CalendarData = {};
	end	
	if (CalendarOptions == nil) then
		CalendarOptions = {
			["buttonLocked"] = true,
			["milFormat"] = true
			};
	end	
	getPlayerInfo();
	if player_Info["guild"] ~= false then
		local msgStr = string.format("%s¿%s¿%s¿%s¿", "", 0, "VersionCheck", EVT_VERSION);
		SendAddonMessage("EVTCalendar", msgStr, "GUILD");
	end
	EVTButton_Init();
    EVT_BuildCalendar();
    initialized = true;
	DEFAULT_CHAT_FRAME:AddMessage(EVT_CALENDAR.." loaded. Type '/evt help' for commands.", 0.1, 1, 0.1);
end
	
function EVT_Toggle()
    EVTButtonDay:SetText(date("%d"));
    if (EVTFrame:IsVisible()) then
        HideUIPanel(EVTFrame);
        PlaySoundFile("Sound\\interface\\uCharacterSheetClose.wav");
    else
		if EVTFrameCreatePopup:IsVisible() or EVTFrameInvitePopup:IsVisible() or EVTFrameOptions:IsVisible() or EVTFrameManage:IsVisible() then
			ShowUIPanel(EVTFrameOverlay);
		end
        EVT_ResetDisplayDate();
        EVT_UpdateCalendar();
        EVT_DayClick(table_Days[table_DayPos[displayDay]]:GetName(), false);
        ShowUIPanel(EVTFrame);
        PlaySoundFile("Sound\\interface\\uCharacterSheetOpen.wav");
    end
end

function EVT_GetCurrentTime()
	local locOffset, svrOffset;
    local locAmpm = "AM";
    local srvAmpm = "AM";
    local srvHour, srvMinute = GetGameTime();
	local gmtHour = tonumber(date("!%H")); 
	local gmtMinute = tonumber(date("!%M")); 
	local locHour = tonumber(date("%H")); 
	local locMinute = tonumber(date("%M")); 
	
	locOffset = (locHour) - (gmtHour);
	srvOffset = (srvHour) - (gmtHour);
	if srvOffset > 12 then
		srvOffset = srvOffset - 24;
	elseif srvOffset < -12 then
		srvOffset = srvOffset + 24;
	end
	if locOffset > 12 then
		locOffset = locOffset - 24;
	elseif locOffset < -12 then
		locOffset = locOffset + 24;
	end
	
	if (srvMinute < 10) then
		srvMinute = string.format("%02s", srvMinute);
	end
	if (locMinute < 10) then
		locMinute = string.format("%02s", srvMinute);
	end
	if CalendarOptions["milFormat"] then
		if srvHour < 10 then
			srvHour = "0" .. srvHour
		end
		if locHour < 10 then
			locHour = "0" .. locHour
		end
	else
		if (srvHour >= 12) then
			if srvHour > 12 then
			srvHour = srvHour - 12;
			end
			srvAmpm = "PM";
		elseif srvHour < 1 then
			srvHour = 12;
		end
		if (locHour >= 12) then
			if locHour > 12 then
			locHour = locHour - 12;
			end
			locAmpm = "PM";
		elseif locHour < 1 then
			locHour = 12;
		end
	end

	return srvHour, srvMinute, locHour, locMinute, locOffset, srvOffset, locAmpm, srvAmpm;
end

function EVT_IncMonth()
    displayMonth = displayMonth - 1;
    if (displayMonth < 1) then
        displayMonth = 12
        displayYear = displayYear - 1;
    end
    EVTMonthDisplay:SetText(table_Months[tostring(displayMonth)]);
    EVT_UpdateCalendar();
end

function EVT_DecMonth()
    displayMonth = displayMonth + 1;
    if (displayMonth > 12) then
        displayMonth = 1
        displayYear = displayYear + 1;
    end
    EVTMonthDisplay:SetText(table_Months[tostring(displayMonth)]);
    EVT_UpdateCalendar();
end

function EVT_UpdateCalendar()
    EVTMonthDisplay:SetText(table_Months[displayMonth]);

    local startDay = GetDayofWeek(displayYear, displayMonth, 1);

    local z = 1;
    
    for step = 1, 42, 1 do
        local s = table_DayStr[step];
        local b = table_Days[step];
		local t = table_DayTex[step];
        local preMonth = displayMonth - 1;
        if (preMonth < 1) then
            preMonth = 12
        end
        if (step < startDay) then
            local preNum = DaysInMonth(displayYear, preMonth) - startDay + (step + 1);
            s:SetText(preNum);
            table_DayVal[step] = nil;
            disableButtonBefore(b, step);
			t:SetTexture("");
        elseif (step >= (DaysInMonth(displayYear, displayMonth) + startDay)) then
            local newDays = (step - (DaysInMonth(displayYear, displayMonth) + startDay - 1));
            s:SetText(newDays);
            table_DayPos[(DaysInMonth(displayYear, displayMonth) + startDay) + newDays] = nil;
            disableButtonAfter(b, step);
			t:SetTexture("");
        else
            s:SetText(z);
            table_DayPos[z] = step;
            table_DayVal[step] = z;
			b:SetHighlightTexture(Img["DayHighlight"]);
            if z == currentDay() and displayMonth == currentMonth() and displayYear == currentYear() then
                b:SetHighlightTexture(Img["DayToday"]);
				b:LockHighlight();
                if (initialized == false) then
                    EVT_UpdateDayPanel();
                end
			end
			if(displayMonth == 1) then
				if(table_DayVal[tonumber(step)] == 10) then
					b:SetNormalTexture(Img["SMulgore"]);
					b:SetPushedTexture(Img["SMulgoreInactive"]);
				elseif(table_DayVal[tonumber(step)] == 17) then
					b:SetNormalTexture(Img["EMulgore"]);
					b:SetPushedTexture(Img["EMulgoreInactive"]);
				elseif(table_DayVal[tonumber(step)] > 10 and table_DayVal[tonumber(step)] < 17) then
					b:SetNormalTexture(Img["DarkmoonFaire"]);
					b:SetPushedTexture(Img["IDarkmoonFaire"]);
				else
					b:SetNormalTexture(Img["DayActive"]);
					b:SetPushedTexture(Img["DayInactive"]);
				end
			elseif (displayMonth == 2) then
				if(table_DayVal[tonumber(step)] == 8) then
					b:SetNormalTexture(Img["SLoveIsInTheAir"]);
					b:SetPushedTexture(Img["SLoveIsInTheAirInactive"]);
				elseif (table_DayVal[tonumber(step)] > 8 and table_DayVal[tonumber(step)] < 12) then
					b:SetNormalTexture(Img["LoveIsInTheAir"]);
					b:SetPushedTexture(Img["ILoveIsInTheAir"]);
				elseif (table_DayVal[tonumber(step)] == 12) then
					b:SetNormalTexture(Img["ELoveIsInTheAir"]);
					b:SetPushedTexture(Img["ELoveIsInTheAirInactive"]);
				elseif (table_DayVal[tonumber(step)] == 10) then
					b:SetNormalTexture(Img["SLunarFestival"]);
					b:SetPushedTexture(Img["SLunarFestivalInactive"]);
				elseif (table_DayVal[tonumber(step)] > 10) then
					b:SetNormalTexture(Img["LunarFestival"]);
					b:SetPushedTexture(Img["ILunarFestival"]);
				elseif(table_DayVal[tonumber(step)] == 10) then
					b:SetNormalTexture(Img["SElwynn"]);
					b:SetPushedTexture(Img["SElwynnInactive"]);
				elseif(table_DayVal[tonumber(step)] == 17) then
					b:SetNormalTexture(Img["EElwynn"]);
					b:SetPushedTexture(Img["EElwynnInactive"]);
				elseif(table_DayVal[tonumber(step)] > 10 and table_DayVal[tonumber(step)] < 17) then
					b:SetNormalTexture(Img["DarkmoonFaire"]);
					b:SetPushedTexture(Img["IDarkmoonFaire"]);
				else
					b:SetNormalTexture(Img["DayActive"]);
					b:SetPushedTexture(Img["DayInactive"]);
				end
			elseif (displayMonth == 3) then
				if(table_DayVal[tonumber(step)] == 1) then
					b:SetNormalTexture(Img["ELunarFestival"]);
					b:SetPushedTexture(Img["ELunarFestivalInactive"]);
				elseif(table_DayVal[tonumber(step)] == 10) then
					b:SetNormalTexture(Img["SMulgore"]);
					b:SetPushedTexture(Img["SMulgoreInactive"]);
				elseif(table_DayVal[tonumber(step)] == 17) then
					b:SetNormalTexture(Img["EMulgore"]);
					b:SetPushedTexture(Img["EMulgoreInactive"]);
				elseif(table_DayVal[tonumber(step)] > 10 and table_DayVal[tonumber(step)] < 17) then
					b:SetNormalTexture(Img["DarkmoonFaire"]);
					b:SetPushedTexture(Img["IDarkmoonFaire"]);
				else
					b:SetNormalTexture(Img["DayActive"]);
					b:SetPushedTexture(Img["DayInactive"]);
				end
			elseif(displayMonth == 4) then
				if (table_DayVal[tonumber(step)] == 3) then
					b:SetNormalTexture(Img["SNobleGarden"]);
					b:SetPushedTexture(Img["SNobleGardenInactive"]);
				elseif (table_DayVal[tonumber(step)] > 3 and table_DayVal[tonumber(step)] < 8) then
					b:SetNormalTexture(Img["NobleGarden"]);
					b:SetPushedTexture(Img["INobleGarden"]);
				elseif (table_DayVal[tonumber(step)] == 8) then
					b:SetNormalTexture(Img["ENobleGarden"]);
					b:SetPushedTexture(Img["ENobleGardenInactive"]);
				elseif (table_DayVal[tonumber(step)] == 28) then
					b:SetNormalTexture(Img["SChildrensWeek"]);
					b:SetPushedTexture(Img["SChildrensWeekInactive"]);
				elseif (table_DayVal[tonumber(step)] > 28) then
					b:SetNormalTexture(Img["ChildrensWeek"]);
					b:SetPushedTexture(Img["IChildrensWeek"]);
				elseif(table_DayVal[tonumber(step)] == 10) then
					b:SetNormalTexture(Img["SElwynn"]);
					b:SetPushedTexture(Img["SElwynnInactive"]);
				elseif(table_DayVal[tonumber(step)] == 17) then
					b:SetNormalTexture(Img["EElwynn"]);
					b:SetPushedTexture(Img["EElwynnInactive"]);
				elseif(table_DayVal[tonumber(step)] > 10 and table_DayVal[tonumber(step)] < 17) then
					b:SetNormalTexture(Img["DarkmoonFaire"]);
					b:SetPushedTexture(Img["IDarkmoonFaire"]);
				else
					b:SetNormalTexture(Img["DayActive"]);
					b:SetPushedTexture(Img["DayInactive"]);
				end
			elseif(displayMonth == 5) then
				if(table_DayVal[tonumber(step)] == 6) then
					b:SetNormalTexture(Img["EChildrensWeek"]);
					b:SetPushedTexture(Img["EChildrensWeekInactive"]);
				elseif(table_DayVal[tonumber(step)] < 6) then
					b:SetNormalTexture(Img["ChildrensWeek"]);
					b:SetPushedTexture(Img["IChildrensWeek"]);
				elseif(table_DayVal[tonumber(step)] == 10) then
					b:SetNormalTexture(Img["SMulgore"]);
					b:SetPushedTexture(Img["SMulgoreInactive"]);
				elseif(table_DayVal[tonumber(step)] == 17) then
					b:SetNormalTexture(Img["EMulgore"]);
					b:SetPushedTexture(Img["EMulgoreInactive"]);
				elseif(table_DayVal[tonumber(step)] > 10 and table_DayVal[tonumber(step)] < 17) then
					b:SetNormalTexture(Img["DarkmoonFaire"]);
					b:SetPushedTexture(Img["IDarkmoonFaire"]);
				else
					b:SetNormalTexture(Img["DayActive"]);
					b:SetPushedTexture(Img["DayInactive"]);
				end
			elseif(displayMonth == 6) then
				if(table_DayVal[tonumber(step)] == 17) then
					b:SetNormalTexture(Img["SMidSummer"]);
					b:SetPushedTexture(Img["SMidSummerInactive"]);
				elseif(table_DayVal[tonumber(step)] > 17) then
					b:SetNormalTexture(Img["MidSummer"]);
					b:SetPushedTexture(Img["IMidSummer"]);
				elseif(table_DayVal[tonumber(step)] == 10) then
					b:SetNormalTexture(Img["SElwynn"]);
					b:SetPushedTexture(Img["SElwynnInactive"]);
				elseif(table_DayVal[tonumber(step)] == 17) then
					b:SetNormalTexture(Img["EElwynn"]);
					b:SetPushedTexture(Img["EElwynnInactive"]);
				elseif(table_DayVal[tonumber(step)] > 10 and table_DayVal[tonumber(step)] < 17) then
					b:SetNormalTexture(Img["DarkmoonFaire"]);
					b:SetPushedTexture(Img["IDarkmoonFaire"]);
				else
					b:SetNormalTexture(Img["DayActive"]);
					b:SetPushedTexture(Img["DayInactive"]);
				end
			elseif(displayMonth == 7) then
				if(table_DayVal[tonumber(step)] == 1) then
					b:SetNormalTexture(Img["EMidSummer"]);
					b:SetPushedTexture(Img["EMidSummerInactive"]);
				elseif(table_DayVal[tonumber(step)] == 10) then
					b:SetNormalTexture(Img["SMulgore"]);
					b:SetPushedTexture(Img["SMulgoreInactive"]);
				elseif(table_DayVal[tonumber(step)] == 17) then
					b:SetNormalTexture(Img["EMulgore"]);
					b:SetPushedTexture(Img["EMulgoreInactive"]);
				elseif(table_DayVal[tonumber(step)] > 10 and table_DayVal[tonumber(step)] < 17) then
					b:SetNormalTexture(Img["DarkmoonFaire"]);
					b:SetPushedTexture(Img["IDarkmoonFaire"]);
				else
					b:SetNormalTexture(Img["DayActive"]);
					b:SetPushedTexture(Img["DayInactive"]);
				end
			elseif(displayMonth == 8) then
				if(table_DayVal[tonumber(step)] == 10) then
					b:SetNormalTexture(Img["SElwynn"]);
					b:SetPushedTexture(Img["SElwynnInactive"]);
				elseif(table_DayVal[tonumber(step)] == 17) then
					b:SetNormalTexture(Img["EElwynn"]);
					b:SetPushedTexture(Img["EElwynnInactive"]);
				elseif(table_DayVal[tonumber(step)] > 10 and table_DayVal[tonumber(step)] < 17) then
					b:SetNormalTexture(Img["DarkmoonFaire"]);
					b:SetPushedTexture(Img["IDarkmoonFaire"]);
				else
					b:SetNormalTexture(Img["DayActive"]);
					b:SetPushedTexture(Img["DayInactive"]);
				end
			elseif(displayMonth == 9) then
				if(table_DayVal[tonumber(step)] == 10) then
					b:SetNormalTexture(Img["SMulgore"]);
					b:SetPushedTexture(Img["SMulgoreInactive"]);
				elseif(table_DayVal[tonumber(step)] == 17) then
					b:SetNormalTexture(Img["EMulgore"]);
					b:SetPushedTexture(Img["EMulgoreInactive"]);
				elseif(table_DayVal[tonumber(step)] > 10 and table_DayVal[tonumber(step)] < 17) then
					b:SetNormalTexture(Img["DarkmoonFaire"]);
					b:SetPushedTexture(Img["IDarkmoonFaire"]);
				else
					b:SetNormalTexture(Img["DayActive"]);
					b:SetPushedTexture(Img["DayInactive"]);
				end
			elseif (displayMonth == 10) then
				if(table_DayVal[tonumber(step)] == 17) then
					b:SetNormalTexture(Img["SHallowsEnd"]);
					b:SetPushedTexture(Img["SHallowsEndInactive"]);
				elseif(table_DayVal[tonumber(step)] == 31) then
					b:SetNormalTexture(Img["EHallowsEnd"]);
					b:SetPushedTexture(Img["EHallowsEndInactive"]);
				elseif(table_DayVal[tonumber(step)] > 17 and table_DayVal[tonumber(step)] < 31) then
					b:SetNormalTexture(Img["HallowsEnd"]);
					b:SetPushedTexture(Img["IHallowsEnd"]);
				elseif(table_DayVal[tonumber(step)] == 3) then
					b:SetNormalTexture(Img["SHarvestFestival"]);
					b:SetPushedTexture(Img["SHarvestFestivalInactive"]);
				elseif(table_DayVal[tonumber(step)] > 3 and table_DayVal[tonumber(step)] < 10) then
					b:SetNormalTexture(Img["HarvestFestival"]);
					b:SetPushedTexture(Img["IHarvestFestival"]);
				elseif(table_DayVal[tonumber(step)] == 10) then
					b:SetNormalTexture(Img["EHarvestFestival"]);
					b:SetPushedTexture(Img["EHarvestFestivalInactive"]);
				elseif(table_DayVal[tonumber(step)] == 10) then
					b:SetNormalTexture(Img["SElwynn"]);
					b:SetPushedTexture(Img["SElwynnInactive"]);
				elseif(table_DayVal[tonumber(step)] == 17) then
					b:SetNormalTexture(Img["EElwynn"]);
					b:SetPushedTexture(Img["EElwynnInactive"]);
				elseif(table_DayVal[tonumber(step)] > 10 and table_DayVal[tonumber(step)] < 17) then
					b:SetNormalTexture(Img["DarkmoonFaire"]);
					b:SetPushedTexture(Img["IDarkmoonFaire"]);
				else
					b:SetNormalTexture(Img["DayActive"]);
					b:SetPushedTexture(Img["DayInactive"]);
				end
			elseif(displayMonth == 11) then
				if(table_DayVal[tonumber(step)] == 10) then
					b:SetNormalTexture(Img["SMulgore"]);
					b:SetPushedTexture(Img["SMulgoreInactive"]);
				elseif(table_DayVal[tonumber(step)] == 17) then
					b:SetNormalTexture(Img["EMulgore"]);
					b:SetPushedTexture(Img["EMulgoreInactive"]);
				elseif(table_DayVal[tonumber(step)] > 10 and table_DayVal[tonumber(step)] < 17) then
					b:SetNormalTexture(Img["DarkmoonFaire"]);
					b:SetPushedTexture(Img["IDarkmoonFaire"]);
				else
					b:SetNormalTexture(Img["DayActive"]);
					b:SetPushedTexture(Img["DayInactive"]);
				end
			elseif (displayMonth == 12) then
				if (table_DayVal[tonumber(step)] > 12 and table_DayVal[tonumber(step)] < 31) then
					b:SetNormalTexture(Img["Winterveil"]);
					b:SetPushedTexture(Img["IWinterveil"]);
				elseif (table_DayVal[tonumber(step)] == 31) then
					b:SetNormalTexture(Img["EWinterveil"]);
					b:SetPushedTexture(Img["EWinterveilInactive"]);
				elseif (table_DayVal[tonumber(step)] == 12) then
					b:SetNormalTexture(Img["SWinterveil"]);
					b:SetPushedTexture(Img["SWinterveilInactive"]);
				elseif(table_DayVal[tonumber(step)] == 10) then
					b:SetNormalTexture(Img["SElwynn"]);
					b:SetPushedTexture(Img["SElwynnInactive"]);
				elseif(table_DayVal[tonumber(step)] == 17) then
					b:SetNormalTexture(Img["EElwynn"]);
					b:SetPushedTexture(Img["EElwynnInactive"]);
				elseif(table_DayVal[tonumber(step)] > 10 and table_DayVal[tonumber(step)] < 17) then
					b:SetNormalTexture(Img["DarkmoonFaire"]);
					b:SetPushedTexture(Img["IDarkmoonFaire"]);
				else
					b:SetNormalTexture(Img["DayActive"]);
					b:SetPushedTexture(Img["DayInactive"]);
				end
			else
				b:SetNormalTexture(Img["DayActive"]);
				b:SetPushedTexture(Img["DayInactive"]);
			end
            if (displayPos == step) then
                local name = b:GetName();
                EVT_DayClick(name, false);
            end
            b:SetScript("OnClick", function()
                local name = this:GetName();
                EVT_DayClick(name, true);
                PlaySoundFile("Sound\\interface\\iUiInterfaceButtonA.wav");
            end);
			
			t:SetTexture(getDayOverlayTex(z));
			
            z = z + 1;
        end
    end
end

function EVT_BuildCalendar()
    local x = 1;
    local y = 1;
    
    
    for step = 1, 42, 1 do
        if (x > 7) then
            x = 1;
            y = y + 1;
        end
        
        xoffset = (x * (77)) - 30;
        yoffset = (y * (-77)) + 23;
        
        x = x + 1;
        
        local name;
        name = string.format("%s%s", "Day", step);
        local b = CreateFrame("Button", name, EVTFrame, "UIPanelButtonTemplate");
        b:SetHeight(78);
        b:SetWidth(78);
        b:SetPoint("TOP", EVTFrame, "TOPLEFT", xoffset, yoffset);
        table_Days[step] = b;
 
		name = string.format("%s%s", name, "Tex");
		local t = b:CreateTexture("name", "OVERLAY");
		t:SetAllPoints();
		t:SetAlpha(0.5);
        table_DayTex[step] = t;		
        
        name = string.format("%s%s%s", "Day", step, "str");
        local s = b:CreateFontString(name, "OVERLAY", "GameFontNormal")
        s:SetHeight(20);
        s:SetWidth(20);
        s:SetPoint("TOP", b, "TOP", -25, -5);
        s:SetText(step);
        table_DayStr[step] = s;
    end
    EVT_UpdateCalendar();
end


function EVT_DayClick(name, pressed)
    local dayNum = tonumber(strsub(name, 4));
    
    if (displayPos ~= nil) then
        local b2 = table_Days[tonumber(displayPos)];
		if displayDay == currentDay() and displayMonth == currentMonth() and displayYear == currentYear() then
			b2:SetHighlightTexture(Img["DayToday"]);
			b2:LockHighlight();
		else
			b2:SetHighlightTexture(Img["DayHighlight"]);
			b2:UnlockHighlight();
		end
		if (table_DayVal[tonumber(displayPos)] ~= nil) then
			
		else
			if (displayPos >= 21) then
				for x = displayPos, 20, -1 do
					if (table_DayVal[x] ~= nil) then
						dayNum = x;
						break;
					end
				end
			else
				for x = displayPos, 21, 1 do
					if (table_DayVal[x] ~= nil) then
						dayNum = x;
						break;
					end
				end
			end
		end
	end
    local b = table_Days[dayNum];
    displayDay = table_DayVal[dayNum];
    displayPos = dayNum;
	if displayDay == currentDay() and displayMonth == currentMonth() and displayYear == currentYear() then
		b:SetHighlightTexture(Img["DayToday"]);
	else 
		b:SetHighlightTexture(Img["DaySelected"]);
	end
	b:LockHighlight();

    EVT_UpdateDayPanel();
end

function disableButtonAfter(Button, ButtonPos)
	for x = 1, table_DayStr[ButtonPos]:GetText(), 1 do
		if (displayMonth + 1 == 13) then
			if(x == 10) then
				Button:SetNormalTexture(Img["SMulgoreInactive"]);
				Button:SetPushedTexture(Img["SMulgoreInactive"]);
			elseif(x == 17) then
				Button:SetNormalTexture(Img["EMulgoreInactive"]);
				Button:SetPushedTexture(Img["EMulgoreInactive"]);
			elseif(x > 10 and x < 17) then
				Button:SetNormalTexture(Img["IDarkmoonFaire"]);
				Button:SetPushedTexture(Img["IDarkmoonFaire"]);
			else
				Button:SetNormalTexture(Img["DayInactive"]);
				Button:SetPushedTexture(Img["DayInactive"]);
			end
		elseif (displayMonth + 1 == 2) then
			if (x == 8) then
				Button:SetNormalTexture(Img["SLoveIsInTheAirInactive"]);
				Button:SetPushedTexture(Img["SLoveIsInTheAirInactive"]);
			elseif (x == 12) then
				Button:SetNormalTexture(Img["ELoveIsInTheAirInactive"]);
				Button:SetPushedTexture(Img["ELoveIsInTheAirInactive"]);
			elseif (x > 8 and x < 12) then
				Button:SetNormalTexture(Img["ILoveIsInTheAir"]);
				Button:SetPushedTexture(Img["ILoveIsInTheAir"]);
			elseif (x == 10) then
				Button:SetNormalTexture(Img["SLunarFestivalInactive"]);
				Button:SetPushedTexture(Img["SLunarFestivalInactive"]);
			elseif (x > 10) then
				Button:SetNormalTexture(Img["ILunarFestival"]);
				Button:SetPushedTexture(Img["ILunarFestival"]);
			elseif(x == 10) then
				Button:SetNormalTexture(Img["SElwynnInactive"]);
				Button:SetPushedTexture(Img["SElwynnInactive"]);
			elseif(x == 17) then
				Button:SetNormalTexture(Img["EElwynnInactive"]);
				Button:SetPushedTexture(Img["EElwynnInactive"]);
			elseif(x > 10 and x < 17) then
				Button:SetNormalTexture(Img["IDarkmoonFaire"]);
				Button:SetPushedTexture(Img["IDarkmoonFaire"]);
			else
				Button:SetNormalTexture(Img["DayInactive"]);
				Button:SetPushedTexture(Img["DayInactive"]);
			end
		elseif (displayMonth + 1 == 3) then
			if (x == 1) then
				Button:SetNormalTexture(Img["ELunarFestivalInactive"]);
				Button:SetPushedTexture(Img["ELunarFestivalInactive"]);
			elseif(x == 10) then
				Button:SetNormalTexture(Img["SMulgoreInactive"]);
				Button:SetPushedTexture(Img["SMulgoreInactive"]);
			elseif(x == 17) then
				Button:SetNormalTexture(Img["EMulgoreInactive"]);
				Button:SetPushedTexture(Img["EMulgoreInactive"]);
			elseif(x > 10 and x < 17) then
				Button:SetNormalTexture(Img["IDarkmoonFaire"]);
				Button:SetPushedTexture(Img["IDarkmoonFaire"]);
			else
				Button:SetNormalTexture(Img["DayInactive"]);
				Button:SetPushedTexture(Img["DayInactive"]);
			end
		elseif (displayMonth + 1 == 4) then
			if (x > 3 and x < 8) then
				Button:SetNormalTexture(Img["INobleGarden"]);
				Button:SetPushedTexture(Img["INobleGarden"]);
			elseif (x == 3) then
				Button:SetNormalTexture(Img["SNobleGardenInactive"]);
				Button:SetPushedTexture(Img["SNobleGardenInactive"]);
			elseif (x == 8) then
				Button:SetNormalTexture(Img["ENobleGardenInactive"]);
				Button:SetPushedTexture(Img["ENobleGardenInactive"]);
			elseif (x == 28) then
				Button:SetNormalTexture(Img["SChildrensWeekInactive"]);
				Button:SetPushedTexture(Img["SChildrensWeekInactive"]);
			elseif (x > 28) then
				Button:SetNormalTexture(Img["IChildrensWeek"]);
				Button:SetPushedTexture(Img["IChildrensWeek"]);
			elseif(x == 10) then
				Button:SetNormalTexture(Img["SElwynnInactive"]);
				Button:SetPushedTexture(Img["SElwynnInactive"]);
			elseif(x == 17) then
				Button:SetNormalTexture(Img["EElwynnInactive"]);
				Button:SetPushedTexture(Img["EElwynnInactive"]);
			elseif(x > 10 and x < 17) then
				Button:SetNormalTexture(Img["IDarkmoonFaire"]);
				Button:SetPushedTexture(Img["IDarkmoonFaire"]);
			else
				Button:SetNormalTexture(Img["DayInactive"]);
				Button:SetPushedTexture(Img["DayInactive"]);
			end
		elseif (displayMonth + 1 == 5) then
			if(x == 6) then
				Button:SetNormalTexture(Img["EChildrensWeekInactive"]);
				Button:SetPushedTexture(Img["EChildrensWeekInactive"]);
			elseif(x < 6) then
				Button:SetNormalTexture(Img["IChildrensWeek"]);
				Button:SetPushedTexture(Img["IChildrensWeek"]);
			elseif(x == 10) then
				Button:SetNormalTexture(Img["SMulgoreInactive"]);
				Button:SetPushedTexture(Img["SMulgoreInactive"]);
			elseif(x == 17) then
				Button:SetNormalTexture(Img["EMulgoreInactive"]);
				Button:SetPushedTexture(Img["EMulgoreInactive"]);
			elseif(x > 10 and x < 17) then
				Button:SetNormalTexture(Img["IDarkmoonFaire"]);
				Button:SetPushedTexture(Img["IDarkmoonFaire"]);
			else
				Button:SetNormalTexture(Img["DayInactive"]);
				Button:SetPushedTexture(Img["DayInactive"]);
			end
		elseif(displayMonth + 1 == 6) then
			if(x == 17) then
				Button:SetNormalTexture(Img["SMidSummerInactive"]);
				Button:SetPushedTexture(Img["SMidSummerInactive"]);
			elseif(x > 17) then
				Button:SetNormalTexture(Img["IMidSummer"]);
				Button:SetPushedTexture(Img["IMidSummer"]);
			elseif(x == 10) then
				Button:SetNormalTexture(Img["SElwynnInactive"]);
				Button:SetPushedTexture(Img["SElwynnInactive"]);
			elseif(x == 17) then
				Button:SetNormalTexture(Img["EElwynnInactive"]);
				Button:SetPushedTexture(Img["EElwynnInactive"]);
			elseif(x > 10 and x < 17) then
				Button:SetNormalTexture(Img["IDarkmoonFaire"]);
				Button:SetPushedTexture(Img["IDarkmoonFaire"]);
			else
				Button:SetNormalTexture(Img["DayInactive"]);
				Button:SetPushedTexture(Img["DayInactive"]);
			end
		elseif(displayMonth + 1 == 7) then
			if(x == 1) then
				Button:SetNormalTexture(Img["EMidSummerInactive"]);
				Button:SetPushedTexture(Img["EMidSummerInactive"]);
			elseif(x == 10) then
				Button:SetNormalTexture(Img["SMulgoreInactive"]);
				Button:SetPushedTexture(Img["SMulgoreInactive"]);
			elseif(x == 17) then
				Button:SetNormalTexture(Img["EMulgoreInactive"]);
				Button:SetPushedTexture(Img["EMulgoreInactive"]);
			elseif(x > 10 and x < 17) then
				Button:SetNormalTexture(Img["IDarkmoonFaire"]);
				Button:SetPushedTexture(Img["IDarkmoonFaire"]);
			else
				Button:SetNormalTexture(Img["DayInactive"]);
				Button:SetPushedTexture(Img["DayInactive"]);
			end
		elseif(displayMonth + 1 == 8) then
			if(x == 10) then
				Button:SetNormalTexture(Img["SElwynnInactive"]);
				Button:SetPushedTexture(Img["SElwynnInactive"]);
			elseif(x == 17) then
				Button:SetNormalTexture(Img["EElwynnInactive"]);
				Button:SetPushedTexture(Img["EElwynnInactive"]);
			elseif(x > 10 and x < 17) then
				Button:SetNormalTexture(Img["IDarkmoonFaire"]);
				Button:SetPushedTexture(Img["IDarkmoonFaire"]);
			else
				Button:SetNormalTexture(Img["DayInactive"]);
				Button:SetPushedTexture(Img["DayInactive"]);
			end
		elseif(displayMonth + 1 == 9) then
			if(x == 10) then
				Button:SetNormalTexture(Img["SMulgoreInactive"]);
				Button:SetPushedTexture(Img["SMulgoreInactive"]);
			elseif(x == 17) then
				Button:SetNormalTexture(Img["EMulgoreInactive"]);
				Button:SetPushedTexture(Img["EMulgoreInactive"]);
			elseif(x > 10 and x < 17) then
				Button:SetNormalTexture(Img["IDarkmoonFaire"]);
				Button:SetPushedTexture(Img["IDarkmoonFaire"]);
			else
				Button:SetNormalTexture(Img["DayInactive"]);
				Button:SetPushedTexture(Img["DayInactive"]);
			end
		elseif (displayMonth + 1 == 10) then
			if(x == 17) then
				Button:SetNormalTexture(Img["SHallowsEndInactive"]);
				Button:SetPushedTexture(Img["SHallowsEndInactive"]);
			elseif(x == 31) then
				Button:SetNormalTexture(Img["EHallowsEndInactive"]);
				Button:SetPushedTexture(Img["EHallowsEndInactive"]);
			elseif(x > 17 and x <= 30) then
				Button:SetNormalTexture(Img["IHallowsEnd"]);
				Button:SetPushedTexture(Img["IHallowsEnd"]);
			elseif(x == 3) then
				Button:SetNormalTexture(Img["SHarvestFestivalInactive"]);
				Button:SetPushedTexture(Img["SHarvestFestivalInactive"]);
			elseif(x > 3 and x < 10) then
				Button:SetNormalTexture(Img["IHarvestFestival"]);
				Button:SetPushedTexture(Img["IHarvestFestival"]);
			elseif(x == 10) then
				Button:SetNormalTexture(Img["EHarvestFestivalInactive"]);
				Button:SetPushedTexture(Img["EHarvestFestivalInactive"]);
			elseif(x == 10) then
				Button:SetNormalTexture(Img["SElwynnInactive"]);
				Button:SetPushedTexture(Img["SElwynnInactive"]);
			elseif(x == 17) then
				Button:SetNormalTexture(Img["EElwynnInactive"]);
				Button:SetPushedTexture(Img["EElwynnInactive"]);
			elseif(x > 10 and x < 17) then
				Button:SetNormalTexture(Img["IDarkmoonFaire"]);
				Button:SetPushedTexture(Img["IDarkmoonFaire"]);
			else
				Button:SetNormalTexture(Img["DayInactive"]);
				Button:SetPushedTexture(Img["DayInactive"]);
			end
		elseif(displayMonth + 1 == 11) then
			if(x == 10) then
				Button:SetNormalTexture(Img["SMulgoreInactive"]);
				Button:SetPushedTexture(Img["SMulgoreInactive"]);
			elseif(x == 17) then
				Button:SetNormalTexture(Img["EMulgoreInactive"]);
				Button:SetPushedTexture(Img["EMulgoreInactive"]);
			elseif(x > 10 and x < 17) then
				Button:SetNormalTexture(Img["IDarkmoonFaire"]);
				Button:SetPushedTexture(Img["IDarkmoonFaire"]);
			else
				Button:SetNormalTexture(Img["DayInactive"]);
				Button:SetPushedTexture(Img["DayInactive"]);
			end
		elseif (displayMonth + 1 == 12) then
			if (x > 12 and x < 31) then
				Button:SetNormalTexture(Img["IWinterveil"]);
				Button:SetPushedTexture(Img["IWinterveil"]);
			elseif (x == 31) then
				Button:SetNormalTexture(Img["EWinterveilInactive"]);
				Button:SetPushedTexture(Img["EWinterveilInactive"]);
			elseif (x == 12) then
				Button:SetNormalTexture(Img["SWinterveilInactive"]);
				Button:SetPushedTexture(Img["SWinterveilInactive"]);
			elseif(x == 10) then
				Button:SetNormalTexture(Img["SElwynnInactive"]);
				Button:SetPushedTexture(Img["SElwynnInactive"]);
			elseif(x == 17) then
				Button:SetNormalTexture(Img["EElwynnInactive"]);
				Button:SetPushedTexture(Img["EElwynnInactive"]);
			elseif(x > 10 and x < 17) then
				Button:SetNormalTexture(Img["IDarkmoonFaire"]);
				Button:SetPushedTexture(Img["IDarkmoonFaire"]);
			else
				Button:SetNormalTexture(Img["DayInactive"]);
				Button:SetPushedTexture(Img["DayInactive"]);
			end
		else
			Button:SetNormalTexture(Img["DayInactive"]);
			Button:SetPushedTexture(Img["DayInactive"]);
		end
		Button:SetHighlightTexture("");
		Button:SetScript("Onclick", function()
			end);
		if (displayPos == ButtonPos) then
			name = Button:GetName();
			EVT_DayClick(name, false);
		end
	end
end

function disableButtonBefore(Button, ButtonPos)
	for x = 1, table_DayStr[ButtonPos]:GetText(), 1 do
		if (displayMonth - 1 == 0) then
			if (x > 12 and x < 31) then
				Button:SetNormalTexture(Img["IWinterveil"]);
				Button:SetPushedTexture(Img["IWinterveil"]);
			elseif (x == 31) then
				Button:SetNormalTexture(Img["EWinterveilInactive"]);
				Button:SetPushedTexture(Img["EWinterveilInactive"]);
			elseif (x == 12) then
				Button:SetNormalTexture(Img["SWinterveilInactive"]);
				Button:SetPushedTexture(Img["SWinterveilInactive"]);
			elseif(x == 10) then
				Button:SetNormalTexture(Img["SElwynnInactive"]);
				Button:SetPushedTexture(Img["SElwynnInactive"]);
			elseif(x == 17) then
				Button:SetNormalTexture(Img["EElwynnInactive"]);
				Button:SetPushedTexture(Img["EElwynnInactive"]);
			elseif(x > 10 and x < 17) then
				Button:SetNormalTexture(Img["IDarkmoonFaire"]);
				Button:SetPushedTexture(Img["IDarkmoonFaire"]);
			else
				Button:SetNormalTexture(Img["DayInactive"]);
				Button:SetPushedTexture(Img["DayInactive"]);
			end
		elseif(displayMonth - 1 == 1) then
			if(x == 10) then
				Button:SetNormalTexture(Img["SMulgoreInactive"]);
				Button:SetPushedTexture(Img["SMulgoreInactive"]);
			elseif(x == 17) then
				Button:SetNormalTexture(Img["EMulgoreInactive"]);
				Button:SetPushedTexture(Img["EMulgoreInactive"]);
			elseif(x > 10 and x < 17) then
				Button:SetNormalTexture(Img["IDarkmoonFaire"]);
				Button:SetPushedTexture(Img["IDarkmoonFaire"]);
			else
				Button:SetNormalTexture(Img["DayInactive"]);
				Button:SetPushedTexture(Img["DayInactive"]);
			end
		elseif (displayMonth - 1 == 2) then
			if (x == 8) then
				Button:SetNormalTexture(Img["SLoveIsInTheAirInactive"]);
				Button:SetPushedTexture(Img["SLoveIsInTheAirInactive"]);
			elseif (x == 12) then
				Button:SetNormalTexture(Img["ELoveIsInTheAirInactive"]);
				Button:SetPushedTexture(Img["ELoveIsInTheAirInactive"]);
			elseif (x > 8 and x < 12) then
				Button:SetNormalTexture(Img["ILoveIsInTheAir"]);
				Button:SetPushedTexture(Img["ILoveIsInTheAir"]);
			elseif (x == 10) then
				Button:SetNormalTexture(Img["SLunarFestivalInactive"]);
				Button:SetPushedTexture(Img["SLunarFestivalInactive"]);
			elseif (x > 10) then
				Button:SetNormalTexture(Img["ILunarFestival"]);
				Button:SetPushedTexture(Img["ILunarFestival"]);
			elseif(x == 10) then
				Button:SetNormalTexture(Img["SElwynnInactive"]);
				Button:SetPushedTexture(Img["SElwynnInactive"]);
			elseif(x == 17) then
				Button:SetNormalTexture(Img["EElwynnInactive"]);
				Button:SetPushedTexture(Img["EElwynnInactive"]);
			elseif(x > 10 and x < 17) then
				Button:SetNormalTexture(Img["IDarkmoonFaire"]);
				Button:SetPushedTexture(Img["IDarkmoonFaire"]);
			else
				Button:SetNormalTexture(Img["DayInactive"]);
				Button:SetPushedTexture(Img["DayInactive"]);
			end
		elseif (displayMonth - 1 == 3) then
			if (x == 1) then
				Button:SetNormalTexture(Img["ELunarFestivalInactive"]);
				Button:SetPushedTexture(Img["ELunarFestivalInactive"]);
			elseif(x == 10) then
				Button:SetNormalTexture(Img["SMulgoreInactive"]);
				Button:SetPushedTexture(Img["SMulgoreInactive"]);
			elseif(x == 17) then
				Button:SetNormalTexture(Img["EMulgoreInactive"]);
				Button:SetPushedTexture(Img["EMulgoreInactive"]);
			elseif(x > 10 and x < 17) then
				Button:SetNormalTexture(Img["IDarkmoonFaire"]);
				Button:SetPushedTexture(Img["IDarkmoonFaire"]);
			else
				Button:SetNormalTexture(Img["DayInactive"]);
				Button:SetPushedTexture(Img["DayInactive"]);
			end
		elseif (displayMonth - 1 == 4) then
			if (x > 3 and x < 8) then
				Button:SetNormalTexture(Img["INobleGarden"]);
				Button:SetPushedTexture(Img["INobleGarden"]);
			elseif (x == 3) then
				Button:SetNormalTexture(Img["SNobleGardenInactive"]);
				Button:SetPushedTexture(Img["SNobleGardenInactive"]);
			elseif (x == 8) then
				Button:SetNormalTexture(Img["ENobleGardenInactive"]);
				Button:SetPushedTexture(Img["ENobleGardenInactive"]);
			elseif (x == 28) then
				Button:SetNormalTexture(Img["SChildrensWeekInactive"]);
				Button:SetPushedTexture(Img["SChildrensWeekInactive"]);
			elseif (x > 28) then
				Button:SetNormalTexture(Img["IChildrensWeek"]);
				Button:SetPushedTexture(Img["IChildrensWeek"]);
			elseif(x == 10) then
				Button:SetNormalTexture(Img["SElwynnInactive"]);
				Button:SetPushedTexture(Img["SElwynnInactive"]);
			elseif(x == 17) then
				Button:SetNormalTexture(Img["EElwynnInactive"]);
				Button:SetPushedTexture(Img["EElwynnInactive"]);
			elseif(x > 10 and x < 17) then
				Button:SetNormalTexture(Img["IDarkmoonFaire"]);
				Button:SetPushedTexture(Img["IDarkmoonFaire"]);
			else
				Button:SetNormalTexture(Img["DayInactive"]);
				Button:SetPushedTexture(Img["DayInactive"]);
		end
		elseif (displayMonth - 1 == 5) then
			if(x == 6) then
				Button:SetNormalTexture(Img["EChildrensWeekInactive"]);
				Button:SetPushedTexture(Img["EChildrensWeekInactive"]);
			elseif(x < 6) then
				Button:SetNormalTexture(Img["IChildrensWeek"]);
				Button:SetPushedTexture(Img["IChildrensWeek"]);
			elseif(x == 10) then
				Button:SetNormalTexture(Img["SMulgoreInactive"]);
				Button:SetPushedTexture(Img["SMulgoreInactive"]);
			elseif(x == 17) then
				Button:SetNormalTexture(Img["EMulgoreInactive"]);
				Button:SetPushedTexture(Img["EMulgoreInactive"]);
			elseif(x > 10 and x < 17) then
				Button:SetNormalTexture(Img["IDarkmoonFaire"]);
				Button:SetPushedTexture(Img["IDarkmoonFaire"]);
			else
				Button:SetNormalTexture(Img["DayInactive"]);
				Button:SetPushedTexture(Img["DayInactive"]);
			end
		elseif(displayMonth - 1 == 6) then
			if(x == 17) then
				Button:SetNormalTexture(Img["SMidSummerInactive"]);
				Button:SetPushedTexture(Img["SMidSummerInactive"]);
			elseif(x > 17) then
				Button:SetNormalTexture(Img["IMidSummer"]);
				Button:SetPushedTexture(Img["IMidSummer"]);
			elseif(x == 10) then
				Button:SetNormalTexture(Img["SElwynnInactive"]);
				Button:SetPushedTexture(Img["SElwynnInactive"]);
			elseif(x == 17) then
				Button:SetNormalTexture(Img["EElwynnInactive"]);
				Button:SetPushedTexture(Img["EElwynnInactive"]);
			elseif(x > 10 and x < 17) then
				Button:SetNormalTexture(Img["IDarkmoonFaire"]);
				Button:SetPushedTexture(Img["IDarkmoonFaire"]);
			else
				Button:SetNormalTexture(Img["DayInactive"]);
				Button:SetPushedTexture(Img["DayInactive"]);
			end
		elseif(displayMonth - 1 == 7) then
			if(x == 1) then
				Button:SetNormalTexture(Img["EMidSummerInactive"]);
				Button:SetPushedTexture(Img["EMidSummerInactive"]);
			elseif(x == 10) then
				Button:SetNormalTexture(Img["SMulgoreInactive"]);
				Button:SetPushedTexture(Img["SMulgoreInactive"]);
			elseif(x == 17) then
				Button:SetNormalTexture(Img["EMulgoreInactive"]);
				Button:SetPushedTexture(Img["EMulgoreInactive"]);
			elseif(x > 10 and x < 17) then
				Button:SetNormalTexture(Img["IDarkmoonFaire"]);
				Button:SetPushedTexture(Img["IDarkmoonFaire"]);
			else
				Button:SetNormalTexture(Img["DayInactive"]);
				Button:SetPushedTexture(Img["DayInactive"]);
			end
		elseif(displayMonth - 1 == 8) then
			if(x == 10) then
				Button:SetNormalTexture(Img["SElwynnInactive"]);
				Button:SetPushedTexture(Img["SElwynnInactive"]);
			elseif(x == 17) then
				Button:SetNormalTexture(Img["EElwynnInactive"]);
				Button:SetPushedTexture(Img["EElwynnInactive"]);
			elseif(x > 10 and x < 17) then
				Button:SetNormalTexture(Img["IDarkmoonFaire"]);
				Button:SetPushedTexture(Img["IDarkmoonFaire"]);
			else
				Button:SetNormalTexture(Img["DayInactive"]);
				Button:SetPushedTexture(Img["DayInactive"]);
			end
		elseif(displayMonth - 1 == 9) then
			if(x == 10) then
				Button:SetNormalTexture(Img["SMulgoreInactive"]);
				Button:SetPushedTexture(Img["SMulgoreInactive"]);
			elseif(x == 17) then
				Button:SetNormalTexture(Img["EMulgoreInactive"]);
				Button:SetPushedTexture(Img["EMulgoreInactive"]);
			elseif(x > 10 and x < 17) then
				Button:SetNormalTexture(Img["IDarkmoonFaire"]);
				Button:SetPushedTexture(Img["IDarkmoonFaire"]);
			else
				Button:SetNormalTexture(Img["DayInactive"]);
				Button:SetPushedTexture(Img["DayInactive"]);
			end
		elseif (displayMonth - 1 == 10) then
			if(x == 17) then
				Button:SetNormalTexture(Img["SHallowsEndInactive"]);
				Button:SetPushedTexture(Img["SHallowsEndInactive"]);
			elseif(x == 31) then
				Button:SetNormalTexture(Img["EHallowsEndInactive"]);
				Button:SetPushedTexture(Img["EHallowsEndInactive"]);
			elseif(x > 17 and x < 31) then
				Button:SetNormalTexture(Img["IHallowsEnd"]);
				Button:SetPushedTexture(Img["IHallowsEnd"]);
			elseif(x == 3) then
				Button:SetNormalTexture(Img["SHarvestFestivalInactive"]);
				Button:SetPushedTexture(Img["SHarvestFestivalInactive"]);
			elseif(x > 3 and x < 10) then
				Button:SetNormalTexture(Img["IHarvestFestival"]);
				Button:SetPushedTexture(Img["IHarvestFestival"]);
			elseif(x == 10) then
				Button:SetNormalTexture(Img["EHarvestFestivalInactive"]);
				Button:SetPushedTexture(Img["EHarvestFestivalInactive"]);
			elseif(x == 10) then
				Button:SetNormalTexture(Img["SElwynnInactive"]);
				Button:SetPushedTexture(Img["SElwynnInactive"]);
			elseif(x == 17) then
				Button:SetNormalTexture(Img["EElwynnInactive"]);
				Button:SetPushedTexture(Img["EElwynnInactive"]);
			elseif(x > 10 and x < 17) then
				Button:SetNormalTexture(Img["IDarkmoonFaire"]);
				Button:SetPushedTexture(Img["IDarkmoonFaire"]);
			else
				Button:SetNormalTexture(Img["DayInactive"]);
				Button:SetPushedTexture(Img["DayInactive"]);
			end
		elseif(displayMonth - 1 == 11) then
			if(x == 10) then
				Button:SetNormalTexture(Img["SMulgoreInactive"]);
				Button:SetPushedTexture(Img["SMulgoreInactive"]);
			elseif(x == 17) then
				Button:SetNormalTexture(Img["EMulgoreInactive"]);
				Button:SetPushedTexture(Img["EMulgoreInactive"]);
			elseif(x > 10 and x < 17) then
				Button:SetNormalTexture(Img["IDarkmoonFaire"]);
				Button:SetPushedTexture(Img["IDarkmoonFaire"]);
			else
				Button:SetNormalTexture(Img["DayInactive"]);
				Button:SetPushedTexture(Img["DayInactive"]);
			end
		else
			Button:SetNormalTexture(Img["DayInactive"]);
			Button:SetPushedTexture(Img["DayInactive"]);
		end
	end
	Button:SetHighlightTexture("");
    Button:SetScript("OnClick", function()
        end);
    if (displayPos == ButtonPos) then
        name = Button:GetName();
        EVT_DayClick(name, false);
    end
end

function EVT_UpdateDayPanel()
    local dow = table_Dotw[GetDayofWeek(displayYear, displayMonth, displayDay)];
    dayString = string.format("%s, %s %s, %s", dow, table_Months[displayMonth], displayDay, displayYear);
    EVTDate:SetText(dayString);
	EVTFrameConfirmedList:Hide();
    EVT_UpdateScrollBar();
end

function EVT_UpdateScrollBar()
    local y;
    local yoffset;
    local t;
	local tSize;
	local strText;
	EVTFrameConfirmedList:Hide();	
	EVT_EventClearSelection();
	HideUIPanel(EVTFrameDetailsList);
	EVTFrameModifyButton:Disable();
	EVTFrameDeleteButton:Disable(); 	
	if TableIndexExists(CalendarData, displayDate()) then
		t = CalendarData[displayDate()];
	else
		t = {};
	end
	tSize = table.getn(t);
	FauxScrollFrame_Update(EventListScrollFrame, tSize, 5, 20);
    for y = 1, 5, 1 do
        yoffset = y + FauxScrollFrame_GetOffset(EventListScrollFrame);
        if (yoffset <= tSize) then
			local t2 = t[yoffset];
            if (t2 == nil) then
                getglobal("EventButton" .. y):Hide();
            else
				btnText = string.format("%s    %s", getTimeStr(t2[3]), t2[1]);
                getglobal("EventButton" .. y .. "Info"):SetText(btnText);
				if t2[9] == 1 then
					getglobal("EventButton" .. y .. "Info"):SetTextColor(1, 0.1, 0.1);
				else
					getglobal("EventButton" .. y .. "Info"):SetTextColor(1, 1, 1);
				end
                getglobal("EventButton" .. y):Show();
				if y == 1 and (yoffset - y) == 0 then
					EVT_EventButton_OnClick(getglobal("EventButton" .. y));
				end
            end
        else
            getglobal("EventButton" .. y):Hide();
        end
    end
end

function EVT_UpdateConfirmedScrollBar()
    local y;
    local yoffset;
    local t;
	local tSize;
	local color;
	if TableIndexExists(CalendarData[displayDate()][getButtonPosOffset()], 12) then
		t = CalendarData[displayDate()][getButtonPosOffset()][12];
	else
		CalendarData[displayDate()][getButtonPosOffset()][12] = {}
		t = CalendarData[displayDate()][getButtonPosOffset()][12];
	end
	tSize = table.getn(t);
	FauxScrollFrame_Update(ConfirmedScrollFrame, tSize, 5, 20);
    for y = 1, 5, 1 do
        yoffset = y + FauxScrollFrame_GetOffset(ConfirmedScrollFrame);
        if (yoffset <= tSize) then
			local t2 = t[yoffset];
            if (t2 == nil) then
                getglobal("ConfirmedText" .. y):Hide();
                getglobal("ConfirmedText" .. y .. "Class"):Hide();
            else
				strText = t2[1];
				classText = t2[2];
				color = RAID_CLASS_COLORS[string.upper(classText)]
                getglobal("ConfirmedText" .. y):SetText(strText);
				getglobal("ConfirmedText" .. y):SetTextColor(color.r, color.g, color.b);
                getglobal("ConfirmedText" .. y .."Class"):SetText(classText);
				getglobal("ConfirmedText" .. y .."Class"):SetTextColor(color.r, color.g, color.b);
                getglobal("ConfirmedText" .. y):Show();
            end
        else
            getglobal("ConfirmedText" .. y):Hide();
            getglobal("ConfirmedText" .. y .. "Class"):Hide();
        end
    end
end

function EVT_EventButton_OnClick(button)
	EVT_EventClearSelection();
	button:LockHighlight();
	selectedButton = button;
	EVTFrameModifyButton:Enable();
	EVTFrameDeleteButton:Enable();
	EVTDetailsStatus:Hide();
	EVTDetailsStatusLabel:Hide();
	EVTFrameConfirmedList:Hide();
	EVT_UpdateDetailList();
	EVT_UpdateConfirmedScrollBar()
end

function EVT_EventConfirmButton_OnClick()
	local evtDate = displayDate();
	local evtName = CalendarData[displayDate()][getButtonPosOffset()][1];
	local crtName = CalendarData[displayDate()][getButtonPosOffset()][2];
	local evtClass = UnitClass("player");
	local subStr = string.format("%s¡%s¡%s¡", evtDate, evtName, evtClass);
	local msgStr = string.format("%s¿%s¿%s¿%s¿", crtName, 0, "ConfirmEvent", subStr);
	SendAddonMessage("EVTCalendar", msgStr, "GUILD");
	EVTFrameConfirmButton:Disable();
end
	
function EVT_UpdateDetailList()
	local pos = getButtonPosOffset();
	local t = CalendarData[displayDate()][pos];
	local subType = t[7];
	local mando = t[9];
	EVTDetailsName:SetText(t[1]);
	EVTDetailsCreated:SetText(t[2]);
	EVTDetailsTime:SetText(string.format("%s    -    %s", getTimeStr(t[3]), getTimeStr(t[5])));
	if (subType == 1 or subType == 2 or subType == 3) then
		EVTDetailsType:SetText(string.format("%s    -    %s", evtTypes[subType], evtSubMenu[t[7]][t[8]]));
	else
		EVTDetailsType:SetText(evtTypes[subType]);
	end
	if (mando == 1) then
		EVTDetailsMando:SetText("Yes");
		EVTDetailsMando:SetTextColor(1, 0.1, 0.1);
	else
		EVTDetailsMando:SetText("No");
		EVTDetailsMando:SetTextColor(1, 1, 1);
	end
	if t[10] == "" then
		EVTDetailsNotes:SetText("None");
	else
		EVTDetailsNotes:SetText(t[10]);
	end
	if t[2] ~= UnitName("player") then
		EVTFrameModifyButton:Disable();
		EVTDetailsStatus:Show();
		EVTDetailsStatusLabel:Show();
		if t[13] == 0 then
			EVTDetailsStatus:SetText("Unconfirmed");
			EVTDetailsStatus:SetTextColor(0.8, 0.1, 0.1);
			EVTFrameConfirmButton:Enable();
		elseif t[13] == 1 then
			EVTDetailsStatus:SetText("Applied");
			EVTDetailsStatus:SetTextColor(0.8, 0.8, 0.1);
			EVTFrameConfirmButton:Disable();
		elseif t[13] == 2 then
			EVTDetailsStatus:SetText("On Standby");
			EVTDetailsStatus:SetTextColor(0.5, 1, 0.1);
			EVTFrameConfirmButton:Disable();
		elseif t[13] == 3 then
			EVTDetailsStatus:SetText("Confirmed");
			EVTDetailsStatus:SetTextColor(0.1, 1, 0.1);
			EVTFrameConfirmButton:Disable();
		end
	else
		EVTFrameConfirmedList:Show();
		EVTFrameConfirmButton:Disable();
	end
	if ((t[11] == 2) and player_Info["officer"] == false) or (t[11] == 3 and t[1] ~= player_Info["name"]) then
		EVTFrameInviteButton:Disable();
	else
		EVTFrameInviteButton:Enable();
	end
	ShowUIPanel(EVTFrameDetailsList);	
end	
	
function EVT_FrameDeleteButton_OnClick()
	local pos = getButtonPosOffset();
	table.remove(CalendarData[displayDate()], pos);
	EVT_UpdateCalendar();
end

function EVT_EventClearSelection()
	if selectedButton ~= nil then
		selectedButton:UnlockHighlight();
		selectedButton = nil;
	end
end

function EVTFrameCreateButton_Toggle()
	EVTClearFrame()
    if (EVTFrameCreatePopup:IsVisible()) then
		HideUIPanel(EVTFrameOverlay);
        HideUIPanel(EVTFrame);
	else
		EVTFrameCreatePopupTitle:SetText("Create Event");
		createDate = displayDate();
		ShowUIPanel(EVTFrameOverlay);
		ShowUIPanel(EVTFrameCreatePopup);
		UIDropDownMenu_Initialize(EVTFrameFromTime, EVTFrameFromTime_Initialize);
		UIDropDownMenu_SetSelectedValue(EVTFrameFromTime, 1);
		UIDropDownMenu_Initialize(EVTFrameAMPM1, EVTFrameAMPM1_Initialize);
		UIDropDownMenu_SetSelectedValue(EVTFrameAMPM1, 1);
		UIDropDownMenu_Initialize(EVTFrameToTime, EVTFrameToTime_Initialize);
		UIDropDownMenu_SetSelectedValue(EVTFrameToTime, 1);
		UIDropDownMenu_Initialize(EVTFrameAMPM2, EVTFrameAMPM2_Initialize);
		UIDropDownMenu_SetSelectedValue(EVTFrameAMPM2, 1);
		UIDropDownMenu_Initialize(EVTFrameType, EVTFrameType_Initialize);
		UIDropDownMenu_SetSelectedValue(EVTFrameType, 7);
		UIDropDownMenu_Initialize(EVTFrameSubType, EVTFrameSubType_Initialize);
		UIDropDownMenu_SetSelectedValue(EVTFrameSubType, 0);
		EVTCheckComplete();
		HideUIPanel(EVTFrameSubType);
	end
end

function EVTFrameInviteButton_Toggle()
    if (EVTFrameInvitePopup:IsVisible()) then
		HideUIPanel(EVTFrameOverlay);
        HideUIPanel(EVTFrame);
	else
		ShowUIPanel(EVTFrameOverlay);
		ShowUIPanel(EVTFrameInvitePopup);
		createDate = displayDate();
		createEvt = getButtonPosOffset();
	end
end

function EVTFrameModifyButton_Toggle()
	EVTClearFrame()
    if (EVTFrameCreatePopup:IsVisible()) then
		HideUIPanel(EVTFrameOverlay);
        HideUIPanel(EVTFrameCreatePopup);
	else
		EVTFrameCreatePopupTitle:SetText("Modify Event");
		createDate = displayDate();
		createEvt = getButtonPosOffset();
		ShowUIPanel(EVTFrameOverlay);
		ShowUIPanel(EVTFrameCreatePopup);
		
		local t = CalendarData[createDate][createEvt];
		EVTFrameNameEditBox:SetText(t[1]);
		EVTFrameCreatorEditBox:SetText(t[2]);
		if isSubtype(t[7]) then
			ShowUIPanel(EVTFrameSubType);
		end
		local fromTime, toTime; 
		local fromAM = 1;
		local toAM = 1;
		if not CalendarOptions["milFormat"] then
			if t[3] >= 12 then
				if t[3] > 12 then
					fromTime = t[3] - 12;
				end
				fromAM = 2;
			else
				fromTime = t[3];
			end
			if t[5] >= 12 then
				if t[5] > 12 then
					toTime = t[5] - 12;
				end
				toAM = 2;
				toTime = toTime + 1;
			else
				toTime = t[5];
			end
		else
			fromTime = t[3];
		end
		fromTime = fromTime + 1;
		UIDropDownMenu_Initialize(EVTFrameFromTime, EVTFrameFromTime_Initialize);
		UIDropDownMenu_SetSelectedValue(EVTFrameFromTime, fromTime);
		UIDropDownMenu_Initialize(EVTFrameAMPM1, EVTFrameAMPM1_Initialize);
		UIDropDownMenu_SetSelectedValue(EVTFrameAMPM1, fromAM);
		UIDropDownMenu_Initialize(EVTFrameToTime, EVTFrameToTime_Initialize);
		UIDropDownMenu_SetSelectedValue(EVTFrameToTime, toTime);
		UIDropDownMenu_Initialize(EVTFrameAMPM2, EVTFrameAMPM2_Initialize);
		UIDropDownMenu_SetSelectedValue(EVTFrameAMPM2, toAM);
		UIDropDownMenu_Initialize(EVTFrameType, EVTFrameType_Initialize);
		UIDropDownMenu_SetSelectedValue(EVTFrameType, t[7]);
		UIDropDownMenu_Initialize(EVTFrameSubType, EVTFrameSubType_Initialize);
		UIDropDownMenu_SetSelectedValue(EVTFrameSubType, t[8]);
		EVTFrameMando:SetChecked(t[9]);
		EVTFrameNoteEditBox:SetText(t[10]);
		EVTCheckComplete();
	end
end

function EVTFrameOptions_OnClick()
	EVTFrameOptionsLock:SetChecked(CalendarOptions["frameDrag"]);
	EVTFrameOptionsEvents:SetChecked(CalendarOptions["acceptEvents"]);	
	EVTFrameOptionsConfirm:SetChecked(CalendarOptions["confirmEvents"]);
	EVTFrameOptions24h:SetChecked(CalendarOptions["milFormat"]);	
	ShowUIPanel(EVTFrameOptions);
end

function EVTFrameManageButton_OnClick()
	ShowUIPanel(EVTFrameOverlay);
	ShowUIPanel(EVTFrameManage);
end

--- Helper Functions ---
function displayDate()
	return string.format("%s%s%s", displayYear, displayMonth, displayDay);
end

function convertDate(str)
	local nDay = tonumber(string.sub(str, 7, 8));
	local nMon = tonumber(string.sub(str, 5, 6));
	local nYear = tonumber(string.sub(str, 1, 4));

	local newDate = string.format("%s %s, %s", table_Months[nMon], nDay, nYear);
	
	return newDate;
end

function getButtonPosOffset()
	local offset = selectedButton:GetID() + FauxScrollFrame_GetOffset(EventListScrollFrame);
	return offset;
end

function getPlayerInfo()
	t = player_Info;

	t["name"] = UnitName("player");

	guildName,guildRank,guildIndex = GetGuildInfo("player")
	guildIndex = guildIndex;
	if guildName ~= nil then
		t["guild"] = guildName;
		t["officer"] = isOfficer(guildIndex);
	else
		t["guild"] = false;
		t["officer"] = false;
	end
end

function isOfficer(index)
	if index == 0 then
		return true;
	end
	GuildControlSetRank(index);
	local _,_,s3, s4 = GuildControlGetRankFlags();
	if s3 == 1 and s4 == 1 then
		return true;
	else
		return false;
	end
end

function getDayOverlayTex(val)
	local calData = string.format("%s%s%s",displayYear, displayMonth, val);
	local tex;
	if TableIndexExists(CalendarData, calData) then
		local t = CalendarData[calData];
		if t[1] ~= nil then
			if t[1][7] == 1 then
				return Img["IcoInstance"];
			end
			if t[1][7] == 2 then
				if t[1][8] == 1 then
					return Img["IcoNefarian"];
				end
				if t[1][8] == 2 then
					return Img["IcoRagnaros"];
				end
				if t[1][8] == 3 then
					return Img["IcoKelthuzad"];
				end
				if t[1][8] == 4 then
					return Img["IcoOnyxia"];
				end
				if t[1][8] == 5 then
					return Img["IcoOssirian"];
				end
				if t[1][8] == 6 then
					return Img["IcoCthun"];
				end
				if t[1][8] == 7 then
					return Img["IcoHakkar"];
				end
			end
			if t[1][7] == 3 then
				return Img["IcoPvP"];
			end
			if t[1][7] == 4 then
				return Img["IcoQuest"];
			end
			if t[1][7] == 5 then
				return Img["IcoMeeting"];
			end
			if t[1][7] == 6 then
				return Img["IcoOther"];
			end
			if t[1][7] == 7 then
				return Img["IcoOther"];
			end
		end
	end
	return "";
end