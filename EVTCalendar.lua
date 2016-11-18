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
local table_DayPos = {};
local table_EventDis = {}

---Initialize variables
local displayMonth;
local displayYear;
local displayDay;
local displayPos;
local initialized = false;
local allowEdit = true;

-- Asset Location
local ImgDayActive = "Interface\\AddOns\\EVTCalendar\\Images\\EVTDayFrameActive";
local ImgDayInactive = "Interface\\AddOns\\EVTCalendar\\Images\\EVTDayFrameInactive";
local ImgDayToday = "Interface\\AddOns\\EVTCalendar\\Images\\EVTDayFrameToday";
local ImgDaySelected = "Interface\\AddOns\\EVTCalendar\\Images\\EVTDayFrameSelected";
local ImgDayHightlight = "Interface\\AddOns\\EVTCalendar\\Images\\EVTDayFrameHighlight";

function EVT_OnLoad()
    this:RegisterEvent("ADDON_LOADED");
    this:RegisterEvent("VARIABLES_LOADED");
    
    tinsert(UISpecialFrames, "EVTFrame");
    
    displayMonth = date("%m") + 0;
    displayDay = date("%d") + 0;
    displayYear = date("%Y") + 0;
    EVT_BuildCalendar();
    
    SLASH_EVT1 = EVT_SLASH;
    SlashCmdList["EVT"] = function(msg)
        if msg == "test" then
            displayYear = 2444;
            EVT_UpdateCalendar(displayMonth, displayYear)
        elseif msg == "leap" then
            isLeapYear(displayYear)
        else
            EVT_SlashCommand(msg);
        end
    end
    
    initialized = true;

end

function EVT_SlashCommand(msg)

--	if(msg ~= "") then
--		DEFAULT_CHAT_FRAME:AddMessage("No such command.", 0.1, 0.1, 1);
--	else
--		EVT_Toggle();
--	end
end

function EVT_Toggle()
    EVTButtonDay:SetText(day)
    if (EVTFrame:IsVisible()) then
        HideUIPanel(EVTFrame);
        PlaySoundFile("Sound\\interface\\uCharacterSheetClose.wav");
    else
        displayMonth = date("%m") + 0;
        displayDay = date("%d") + 0;
        displayYear = date("%Y") + 0;
        
        EVT_UpdateCalendar(displayMonth, displayYear);
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
    EVT_UpdateCalendar(displayMonth, displayYear);
end

function EVT_DecMonth()
    displayMonth = displayMonth + 1;
    if (displayMonth > 12) then
        displayMonth = 1
        displayYear = displayYear + 1;
    end
    EVTMonthDisplay:SetText(table_Months[tostring(displayMonth)]);
    EVT_UpdateCalendar(displayMonth, displayYear);
end

function EVT_UpdateCalendar(disMonth, disYear)
    local startDay = GetDayofWeek(disYear, disMonth, 1);
    local z = 1;
    
    for step = 1, 42, 1 do
        local s = table_DayStr[step];
        local b = table_Days[step];
        local preMonth = disMonth - 1;
        local dispMonth = disMonth;
        if (preMonth < 1) then
            preMonth = 12
        end
        if (step < startDay) then
            preNum = DaysInMonth(disYear, preMonth) - startDay + (step + 1);
            s:SetText(preNum);
            table_DayVal[step] = nil;
            DisableButton(b, step);
        elseif (step >= (DaysInMonth(disYear, disMonth) + startDay)) then
            newDays = (step - (DaysInMonth(disYear, disMonth) + startDay - 1));
            s:SetText(newDays);
            table_DayPos[(DaysInMonth(disYear, disMonth) + startDay) + newDays] = nil;
            DisableButton(b, step);
        else
            s:SetText(z);
            table_DayPos[z] = step;
            table_DayVal[step] = z;
            if ((z == day) and (disMonth == month) and (disYear == year)) then
                b:SetNormalTexture(ImgDayToday);
                if (initialized == false) then
                    EVT_UpdateDayPanel();
                end
            else
                b:SetNormalTexture(ImgDayActive);
            end
            if (displayPos == step) then
                name = b:GetName();
                EVT_DayClick(name, false);
            end
            b:SetPushedTexture(ImgDayInactive);
            b:SetHighlightTexture(ImgDayHightlight);
            b:SetScript("OnClick", function()
                name = this:GetName();
                EVT_DayClick(name, true);
                PlaySoundFile("Sound\\interface\\iUiInterfaceButtonA.wav");
            end);
            z = z + 1;
        end
    end
    EVTMonthDisplay:SetText(table_Months[disMonth]);
end

function DisableButton(Button, ButtonPos)
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

function EVT_BuildCalendar()
    local x = 1;
    local y = 1;
    
    
    for step = 1, 42, 1 do
        
        name = string.format("%s%s", "Day", step);
        namestr = string.format("%s%s%s", "Day", step, "str");
        
        if (x > 7) then
            x = 1;
            y = y + 1;
        end
        
        xoffset = (x * (77)) - 30;
        yoffset = (y * (-77)) + 23;
        
        x = x + 1;
        
        local b = CreateFrame("Button", name, EVTFrame, "UIPanelButtonTemplate");
        b:SetHeight(78);
        b:SetWidth(78);
        b:SetPoint("TOP", EVTFrame, "TOPLEFT", xoffset, yoffset);
        table_Days[step] = b;
        local s = b:CreateFontString(namestr, "ARTWORK", "GameFontNormal")
        s:SetHeight(20);
        s:SetWidth(20);
        s:SetPoint("TOP", b, "TOP", -25, -5);
        s:SetText(step);
        table_DayStr[step] = s;
    end
    EVT_UpdateCalendar(displayMonth, displayYear);
end


function EVT_DayClick(name, pressed)
    local dayNum = tonumber(strsub(name, 4));
    
    if (displayPos ~= nil) then
        local b2 = table_Days[tonumber(displayPos)];
        if ((displayDay == day) and (displayMonth == month) and (displayYear == year)) then
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
    DEFAULT_CHAT_FRAME:AddMessage(tostring(dow) .. tostring(displayYear) .. tostring(displayMonth) .. tostring(displayDay), 0.1, 0.1, 1);
    dayString = string.format("%s, %s %s, %s", dow, table_Months[displayMonth], displayDay, displayYear);
    EVTDate:SetText(dayString);
    EVT_UpdateScrollBar();
end

function EVT_UpdateScrollBar()
    local y;
    local yoffset;
    local tableSize = table.getn(table_EventDis);
    
    FauxScrollFrame_Update(EventListScrollFrame, tableSize, 5, 20);
    
    for y = 1, 5, 1 do
        yoffset = y + FauxScrollFrame_GetOffset(EventListScrollFrame);
        if (yoffset <= tableSize) then
            if (table_EventDis[yoffset] == nil) then
                getglobal("EventButton" .. y):Hide();
            else
                getglobal("EventButton" .. y .. "Info"):SetText(tostring(table_EventDis[yoffset]));
                getglobal("EventButton" .. y):Show();
            end
        else
            getglobal("EventButton" .. y):Hide();
        end
    end
end

function EVTFrameFromTime_OnLoad()
    UIDropDownMenu_Initialize(this, EVTFrameFromTime_Initialize);
    UIDropDownMenu_SetWidth(75, EVTFrameFromTime);
    UIDropDownMenu_SetSelectedValue(this, "From0:30");
end

function EVTFrameFromTime_Initialize()
    local info;
    local int = 0;
    local str;
    for i = 1, 24, 1 do
        if mod(i, 2) == 0 then
            int = int + 1;
            str = string.format("%s:%s", int, "00");
        else
            str = string.format("%s:%s", int, "30");
        end
        checked = nil;
        info = {};
        info.text = tostring(str);
        info.value = "From" .. str;
        info.func = EVTFrameFromTime_OnClick;
        info.checked = checked;
        UIDropDownMenu_AddButton(info);
    end
end

function EVTFrameFromTime_OnClick()
    UIDropDownMenu_SetSelectedValue(EVTFrameFromTime, this.value);
end

function EVTFrameToTime_OnLoad()
    UIDropDownMenu_Initialize(this, EVTFrameToTime_Initialize);
    UIDropDownMenu_SetWidth(75, EVTFrameToTime);
    UIDropDownMenu_SetSelectedValue(this, "To0:30");
end

function EVTFrameToTime_Initialize()
    local info;
    local int = 0;
    local str;
    for i = 1, 24, 1 do
        if mod(i, 2) == 0 then
            int = int + 1;
            str = string.format("%s:%s", int, "00");
        else
            str = string.format("%s:%s", int, "30");
        end
        checked = nil;
        info = {};
        info.text = str;
        info.value = "To" .. str;
        info.func = EVTFrameToTime_OnClick;
        info.checked = checked;
        UIDropDownMenu_AddButton(info);
    end
end

function EVTFrameToTime_OnClick()
    UIDropDownMenu_SetSelectedValue(EVTFrameToTime, this.value);
end

function EVTFrameAMPM1_OnLoad()
    UIDropDownMenu_Initialize(this, EVTFrameAMPM1_Initialize);
    UIDropDownMenu_SetWidth(45, EVTFrameAMPM1);
    UIDropDownMenu_SetSelectedValue(this, "1AM");
end

function EVTFrameAMPM1_Initialize()
    local info;
    
    checked = nil;
    info = {};
    info.text = "AM";
    info.value = "1" .. "AM";
    info.func = EVTFrameAMPM1_OnClick;
    info.checked = checked;
    UIDropDownMenu_AddButton(info);
    info = {};
    info.text = "PM";
    info.value = "1" .. "PM";
    info.func = EVTFrameAMPM1_OnClick;
    info.checked = checked;
    UIDropDownMenu_AddButton(info);
end

function EVTFrameAMPM1_OnClick()
    UIDropDownMenu_SetSelectedValue(EVTFrameAMPM1, this.value);
end

function EVTFrameAMPM2_OnLoad()
    UIDropDownMenu_Initialize(this, EVTFrameAMPM2_Initialize);
    UIDropDownMenu_SetWidth(45, EVTFrameAMPM2);
    UIDropDownMenu_SetSelectedValue(this, "2AM");
end

function EVTFrameAMPM2_Initialize()
    local info;
    
    checked = nil;
    info = {};
    info.text = "AM";
    info.value = "2" .. "AM";
    info.func = EVTFrameAMPM2_OnClick;
    info.checked = checked;
    UIDropDownMenu_AddButton(info);
    info = {};
    info.text = "PM";
    info.value = "2" .. "PM";
    info.func = EVTFrameAMPM2_OnClick;
    info.checked = checked;
    UIDropDownMenu_AddButton(info);
end

function EVTFrameAMPM2_OnClick()
    UIDropDownMenu_SetSelectedValue(EVTFrameAMPM2, this.value);
end
