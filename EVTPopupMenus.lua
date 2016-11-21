----------------------------------------------------------------
-- EVTCalendar
-- Author: Reed
--
--
----------------------------------------------------------------

createDate = "";

function EVTFrameAcceptBtn_OnClick()
	local mando;
	if (TableIndexExists(CalendarData, createDate) == false) then
		CalendarData[createDate] = {};
	end
	if EVTFrameMando:GetChecked() == nil then
		mando = 0;
	else
		mando = 1;
	end
	if (EVTFrameCreatePopupTitle:GetText() == "Create Event") then
		table.insert(CalendarData[createDate],{
			[1] = EVTFrameNameEditBox:GetText(),
			[2] = EVTFrameCreatorEditBox:GetText(),
			[3] = UIDropDownMenu_GetSelectedValue(EVTFrameFromTime),
			[4] = UIDropDownMenu_GetSelectedValue(EVTFrameAMPM1),
			[5] = UIDropDownMenu_GetSelectedValue(EVTFrameToTime),
			[6] = UIDropDownMenu_GetSelectedValue(EVTFrameAMPM2),
			[7] = UIDropDownMenu_GetSelectedValue(EVTFrameType),
			[8] = UIDropDownMenu_GetSelectedValue(EVTFrameSubType),
			[9] = mando,
			[10] = EVTFrameNoteEditBox:GetText()
			});
		else
			CalendarData[createDate][getButtonPosOffset()] = {
				[1] = EVTFrameNameEditBox:GetText(),
				[2] = EVTFrameCreatorEditBox:GetText(),
				[3] = UIDropDownMenu_GetSelectedValue(EVTFrameFromTime),
				[4] = UIDropDownMenu_GetSelectedValue(EVTFrameAMPM1),
				[5] = UIDropDownMenu_GetSelectedValue(EVTFrameToTime),
				[6] = UIDropDownMenu_GetSelectedValue(EVTFrameAMPM2),
				[7] = UIDropDownMenu_GetSelectedValue(EVTFrameType),
				[8] = UIDropDownMenu_GetSelectedValue(EVTFrameSubType),
				[9] = mando,
				[10] = EVTFrameNoteEditBox:GetText()
			};
		end
		
		EVT_UpdateScrollBar();
		EVTClearFrame();
		HideUIPanel(EVTFrameOverlay);
		EVT_UpdateCalendar();
end

function EVTFrameCreatePopup_OnLoad()
	EVTFrameCreatorEditBox:SetText(UnitName("player"));
	EVTFrameCreatorEditBox:EnableKeyboard(false);
	EVTFrameCreatorEditBox:EnableMouse(false);
end

function EVTFrameFromTime_OnLoad()
    UIDropDownMenu_Initialize(this, EVTFrameFromTime_Initialize);
    UIDropDownMenu_SetWidth(75, EVTFrameFromTime);
    UIDropDownMenu_SetSelectedValue(this, 1);
end

function EVTFrameFromTime_Initialize()
    local info;
    local int = 0;
    local str;
    for i = 1, 12, 1 do
		str = getTimeStr(i);
		info = buildButton(str, i, EVTFrameFromTime_OnClick)  
        UIDropDownMenu_AddButton(info);
    end
end

function EVTFrameFromTime_OnClick()
    UIDropDownMenu_SetSelectedValue(EVTFrameFromTime, this.value);
	EVTCheckComplete();
end

function EVTFrameToTime_OnLoad()
    UIDropDownMenu_Initialize(this, EVTFrameToTime_Initialize);
    UIDropDownMenu_SetWidth(75, EVTFrameToTime);
    UIDropDownMenu_SetSelectedValue(this, 1);
end

function EVTFrameToTime_Initialize()
    local info;
    local str;
    for i = 1, 12, 1 do
		str = getTimeStr(i);
		info = buildButton(str, i, EVTFrameToTime_OnClick)  
        UIDropDownMenu_AddButton(info);
    end
end

function EVTFrameToTime_OnClick()
    UIDropDownMenu_SetSelectedValue(EVTFrameToTime, this.value);
	EVTCheckComplete();
end

function EVTFrameAMPM1_OnLoad()
    UIDropDownMenu_Initialize(this, EVTFrameAMPM1_Initialize);
    UIDropDownMenu_SetWidth(45, EVTFrameAMPM1);
    UIDropDownMenu_SetSelectedValue(this, 1);
end

function EVTFrameAMPM1_Initialize()
    local info;
	info = buildButton("AM", 1, EVTFrameAMPM1_OnClick)    
    UIDropDownMenu_AddButton(info);
	info = buildButton("PM", 2, EVTFrameAMPM1_OnClick) 
    UIDropDownMenu_AddButton(info);
end

function EVTFrameAMPM1_OnClick()
    UIDropDownMenu_SetSelectedValue(EVTFrameAMPM1, this.value);
	EVTCheckComplete();
end

function EVTFrameAMPM2_OnLoad()
    UIDropDownMenu_Initialize(this, EVTFrameAMPM2_Initialize);
    UIDropDownMenu_SetWidth(45, EVTFrameAMPM2);
    UIDropDownMenu_SetSelectedValue(this, 1);
end

function EVTFrameAMPM2_Initialize()
    local info;
	info = buildButton("AM", 1, EVTFrameAMPM2_OnClick)    
    UIDropDownMenu_AddButton(info);
	info = buildButton("PM", 2, EVTFrameAMPM2_OnClick) 
    UIDropDownMenu_AddButton(info);
end

function EVTFrameAMPM2_OnClick()
    UIDropDownMenu_SetSelectedValue(EVTFrameAMPM2, this.value);
	EVTCheckComplete();
end

function EVTFrameType_OnClick()
    UIDropDownMenu_SetSelectedValue(EVTFrameType, this.value);
end

function EVTFrameType_OnLoad()
    UIDropDownMenu_Initialize(this, EVTFrameType_Initialize);
    UIDropDownMenu_SetWidth(75, EVTFrameType);
    UIDropDownMenu_SetSelectedValue(this, 7);
	UIDropDownMenu_JustifyText("LEFT", this);
end

function EVTFrameType_Initialize()
    local info;

    for i = 1, 7, 1 do
		info = buildButton(evtTypes[i], i, EVTFrameType_OnClick)
		UIDropDownMenu_AddButton(info);
	end
end

function EVTFrameType_OnClick()
    UIDropDownMenu_SetSelectedValue(EVTFrameType, this.value);
	EVTFrameSubType_Toggle();
	EVTCheckComplete();
end

function EVTFrameSubType_OnLoad()
    UIDropDownMenu_Initialize(this, EVTFrameSubType_Initialize);
    UIDropDownMenu_SetWidth(130, EVTFrameSubType);
    UIDropDownMenu_SetSelectedValue(this, 1);
	UIDropDownMenu_JustifyText("LEFT", this);
end

function EVTFrameSubType_Initialize()
    local info;
	local n = 0;
	local subType = UIDropDownMenu_GetSelectedValue(EVTFrameType);
	UIDropDownMenu_SetSelectedValue(EVTFrameSubType, 0);
	if isSubtype(subType) then
		n = table.getn(evtSubMenu[subType]);
	end
	for i = 1, n, 1 do
		if isSubtype(subType) then
			UIDropDownMenu_SetSelectedValue(EVTFrameSubType, 0);
			info = buildButton(evtSubMenu[subType][i], i, EVTFrameSubType_OnClick)
			UIDropDownMenu_AddButton(info);
		end
	end
end

function EVTFrameSubType_Toggle()
	local subType = UIDropDownMenu_GetSelectedValue(EVTFrameType);

	if isSubtype(subType) then
		ShowUIPanel(EVTFrameSubType);
	else 
		HideUIPanel(EVTFrameSubType);
	end
	EVTFrameSubType_Initialize();
	UIDropDownMenu_SetText(nil, EVTFrameSubType);
	UIDropDownMenu_SetSelectedValue(EVTFrameSubType, 0);
end

function EVTFrameSubType_OnClick()
    UIDropDownMenu_SetSelectedValue(EVTFrameSubType, this.value);
	EVTCheckComplete();
end

function EVTCheckComplete()
	if ((EVTFrameNameEditBox:GetText() ~= "") and compareInputTime() and (isSubtype(UIDropDownMenu_GetSelectedValue(EVTFrameType)) == (UIDropDownMenu_GetSelectedValue(EVTFrameSubType) ~= 0))) then
		EVTFrameCreatePopupAccept:Enable()
	else
		EVTFrameCreatePopupAccept:Disable()
	end
end

function EVTClearFrame()
	EVTFrameCreatorEditBox:SetText("");
	EVTFrameNameEditBox:SetText("");
	EVTFrameNoteEditBox:SetText("");
	HideUIPanel(EVTFrameSubType);
end

--------- Invite Popup --------------
function EVTFrameInviteMenu_OnLoad()
    UIDropDownMenu_Initialize(this, EVTFrameInviteMenu_Initialize);
    UIDropDownMenu_SetWidth(125, EVTFrameInviteMenu);
    UIDropDownMenu_SetSelectedValue(this, 0);
	UIDropDownMenu_JustifyText("LEFT", EVTFrameInviteMenu);
end

function EVTFrameInviteMenu_Initialize()
    local info;

    for i = 1, 4, 1 do
		info = buildButton(evtInvites[i], i, EVTFrameInviteMenu_OnClick)
		UIDropDownMenu_AddButton(info);
	end
end

function EVTFrameInviteMenu_OnClick()
    UIDropDownMenu_SetSelectedValue(EVTFrameInviteMenu, this.value);
end

function EVTFrameInviteLockMenu_OnLoad()
    UIDropDownMenu_Initialize(this, EVTFrameInviteLockMenu_Initialize);
    UIDropDownMenu_SetWidth(125, EVTFrameInviteLockMenu);
    UIDropDownMenu_SetSelectedValue(this, 0);
	UIDropDownMenu_JustifyText("LEFT", EVTFrameInviteLockMenu);
end

function EVTFrameInviteLockMenu_Initialize()
    local info;

    for i = 1, 4, 1 do
		info = buildButton(evtInviteLock[i], i, EVTFrameInviteLockMenu_OnClick)
		UIDropDownMenu_AddButton(info);
	end
end

function EVTFrameInviteLockMenu_OnClick()
    UIDropDownMenu_SetSelectedValue(EVTFrameInviteLockMenu, this.value);
end


--- Helper Functions ---
function compareInputTime()
	local bTime = UIDropDownMenu_GetSelectedValue(EVTFrameFromTime);
	local aTime = UIDropDownMenu_GetSelectedValue(EVTFrameToTime);
	local bAMPM = UIDropDownMenu_GetSelectedValue(EVTFrameAMPM1);
	local aAMPM = UIDropDownMenu_GetSelectedValue(EVTFrameAMPM2);
	
	if (aTime + (12 * (aAMPM - 1))) > (bTime + (12 * (bAMPM - 1))) then
		return true;
	else
		return false;
	end
end

function isSubtype(subType)
	if subType == 1 or subType == 2 or subType == 3 then
		return true;
	end
	return false;
end

function buildButton(btText, btValue, btFunc)
	local info;
    info = {};
    info.text = btText;
    info.value = btValue;
    info.func = btFunc;
    info.checked = nil;
	return info;
end

function getTimeStr(i, ampm)
	str = string.format("%s:%s", i, "00");
	if ampm ~= nil then
		if ampm == 1 then
			str = string.format("%s%s", str, "am");
		elseif ampm == 2 then
			str = string.format("%s%s", str, "pm");
		end
	end
	return str;
end