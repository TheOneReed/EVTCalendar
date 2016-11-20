----------------------------------------------------------------
-- EVTCalendar
-- Author: Reed
--
--
----------------------------------------------------------------
---Initialize tables
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
local selectedButton;
local initialized = false;
local varsLoaded = false;

-- Asset Location
local ImgDayActive = "Interface\\AddOns\\EVTCalendar\\Images\\EVTDayFrameActive";
local ImgDayInactive = "Interface\\AddOns\\EVTCalendar\\Images\\EVTDayFrameInactive";
local ImgDayToday = "Interface\\AddOns\\EVTCalendar\\Images\\EVTDayFrameToday";
local ImgDaySelected = "Interface\\AddOns\\EVTCalendar\\Images\\EVTDayFrameSelected";
local ImgDayHightlight = "Interface\\AddOns\\EVTCalendar\\Images\\EVTDayFrameHighlight";
local ImgIcoRagnaros = "Interface\\AddOns\\EVTCalendar\\Images\\EVTIcoRagnaros";


-- Calendar Data Table

function EVT_ResetDisplayDate()
    displayDay = currentDay();
    displayMonth = currentMonth();
    displayYear = currentYear();
end

function EVT_OnLoad()
    this:RegisterEvent("ADDON_LOADED");
    this:RegisterEvent("VARIABLES_LOADED");
    
    tinsert(UISpecialFrames, "EVTFrame");
    
    SLASH_EVT1 = EVT_SLASH;
    SlashCmdList["EVT"] = function(msg)
        if msg == "delete" then
			CalendarData[displayDate()] = {};
        elseif msg == "test" then
			DEFAULT_CHAT_FRAME:AddMessage(tostring(EVTFrameMando:GetChecked()), 0.1, 0.1, 1);
		end
	end
end

function EVT_SlashCommand(msg)

--	if(msg ~= "") then
--		DEFAULT_CHAT_FRAME:AddMessage("No such command.", 0.1, 0.1, 1);
--	else
--		EVT_Toggle();
--	end
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
			DEFAULT_CHAT_FRAME:AddMessage(arg2, 0.1, 0.1, 1);
		end		
	end
end

function EVT_Initialize()
    displayMonth = date("%m") + 0;
    displayDay = date("%d") + 0;
    displayYear = date("%Y") + 0;
    EVT_BuildCalendar();
	if (CalendarData == nil) then
		CalendarData = {};
	end	
    initialized = true;
end
	
	function EVT_Toggle()
    EVTButtonDay:SetText(date("%d"));
    if (EVTFrame:IsVisible()) then
        HideUIPanel(EVTFrame);
        PlaySoundFile("Sound\\interface\\uCharacterSheetClose.wav");
    else
        EVT_ResetDisplayDate();
        
        EVT_UpdateCalendar();
        EVT_DayClick(table_Days[table_DayPos[displayDay]]:GetName(), false);
        ShowUIPanel(EVTFrame);
        PlaySoundFile("Sound\\interface\\uCharacterSheetOpen.wav");
    end
end

function EVT_GetCurrentTime()
    ampm = "AM";
    hour, minute = GetGameTime();
    
    if (hour > 12) then
        hour = hour - 12;
        ampm = "PM";
    end
    if (minute < 10) then
        minute = string.format("%02s", minute);
    end
    
    curtime = string.format("%s:%s%s", hour, minute, ampm);
    return curtime;
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
            disableButton(b, step);
        elseif (step >= (DaysInMonth(displayYear, displayMonth) + startDay)) then
            local newDays = (step - (DaysInMonth(displayYear, displayMonth) + startDay - 1));
            s:SetText(newDays);
            table_DayPos[(DaysInMonth(displayYear, displayMonth) + startDay) + newDays] = nil;
            disableButton(b, step);
        else
            s:SetText(z);
            table_DayPos[z] = step;
            table_DayVal[step] = z;
            if z == currentDay() and displayMonth == currentMonth() and displayYear == currentYear() then
                b:SetNormalTexture(ImgDayToday);
                if (initialized == false) then
                    EVT_UpdateDayPanel();
                end
            else
                b:SetNormalTexture(ImgDayActive);
            end
            if (displayPos == step) then
                local name = b:GetName();
                EVT_DayClick(name, false);
            end
            b:SetPushedTexture(ImgDayInactive);
            b:SetHighlightTexture(ImgDayHightlight);
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
            b2:SetNormalTexture(ImgDayToday);
        else
            if (table_DayVal[tonumber(displayPos)] ~= nil) then
                b2:SetNormalTexture(ImgDayActive);
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
    end
    local b = table_Days[dayNum];
    b:SetNormalTexture(ImgDaySelected);
    displayDay = table_DayVal[dayNum];
    displayPos = dayNum;
    EVT_UpdateDayPanel();
end

function EVT_UpdateDayPanel()
    local dow = table_Dotw[GetDayofWeek(displayYear, displayMonth, displayDay)];
    --    DEFAULT_CHAT_FRAME:AddMessage(tostring(dow) .. tostring(displayYear) .. tostring(displayMonth) .. tostring(displayDay), 0.1, 0.1, 1);
    dayString = string.format("%s, %s %s, %s", dow, table_Months[displayMonth], displayDay, displayYear);
    EVTDate:SetText(dayString);
    EVT_UpdateScrollBar();
end

function EVT_UpdateScrollBar()
    local y;
    local yoffset;
    local t;
	local tSize;
	local btnText;
	
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
				btnText = string.format("%s    %s", getTimeStr(t2[3], t2[4]), t2[1]);
                getglobal("EventButton" .. y .. "Info"):SetText(btnText);
				if t2[9] == 1 then
					getglobal("EventButton" .. y .. "Info"):SetTextColor(1, 0.1, 0.1);
				else
					getglobal("EventButton" .. y .. "Info"):SetTextColor(1, 1, 1);
				end
                getglobal("EventButton" .. y):Show();
            end
        else
            getglobal("EventButton" .. y):Hide();
        end
    end
end

function EVT_EventButton_OnClick(button)
	EVT_EventClearSelection();
	button:LockHighlight();
	selectedButton = button;
	EVTFrameModifyButton:Enable();
	EVTFrameDeleteButton:Enable();
	EVT_UpdateDetailList()
end

function EVT_UpdateDetailList()
	local pos = selectedButton:GetID() + FauxScrollFrame_GetOffset(EventListScrollFrame);
	local t = CalendarData[displayDate()][pos];
	local subType = t[7];
	local mando = t[9];
	EVTDetailsName:SetText(t[1]);
	EVTDetailsCreated:SetText(t[2]);
	EVTDetailsTime:SetText(string.format("%s    -    %s", getTimeStr(t[3], t[4]), getTimeStr(t[5], t[6])));
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
	end
	ShowUIPanel(EVTFrameDetailsList);	
end	
	
function EVT_FrameDeleteButton_OnClick()
	local pos = selectedButton:GetID() + FauxScrollFrame_GetOffset(EventListScrollFrame);
	DEFAULT_CHAT_FRAME:AddMessage(pos, 0.1, 0.1, 1);
	table.remove(CalendarData[displayDate()], pos);
	EVT_UpdateScrollBar();
end

function EVT_EventClearSelection()
	if selectedButton ~= nil then
		selectedButton:UnlockHighlight();
		selectedButton = nil;
	end
end

function EVTFrameCreateButton_Toggle()
    if (EVTFrameCreatePopup:IsVisible()) then
		HideUIPanel(EVTFrameOverlay);
        HideUIPanel(EVTFrame);
		EVTClearFrame()
	else
		createDate = displayDate();
		ShowUIPanel(EVTFrameOverlay);
		ShowUIPanel(EVTFrameCreatePopup);
	end
end

--- Helper Functions ---
function displayDate()
	return string.format("%s%s%s", displayMonth, displayDay, displayYear);
end

function disableButton(Button, ButtonPos)
    table_DayVal[ButtonPos] = nil;
    Button:SetNormalTexture(ImgDayInactive);
    Button:SetPushedTexture(ImgDayInactive);
    Button:SetHighlightTexture("");
    Button:SetScript("Onclick", function()
        end);
    if (displayPos == ButtonPos) then
        name = Button:GetName();
        EVT_DayClick(name, false);
    end
end

function getDayOverlayTex(val)
	local calData = string.format("%s%s%s", displayMonth, val, displayYear);
	local tex;
	if TableIndexExists(CalendarData, calData) then
		DEFAULT_CHAT_FRAME:AddMessage("Pass.", 0.1, 0.1, 1);
		local t = CalendarData[calData];
		if t[1] ~= nil then
			DEFAULT_CHAT_FRAME:AddMessage("Pass 2.", 0.1, 0.1, 1);
			return ImgIcoRagnaros;
		end
	end
	return "";
end