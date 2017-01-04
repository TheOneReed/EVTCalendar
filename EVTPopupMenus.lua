----------------------------------------------------------------
-- EVTCalendar
-- Author: Reed
--
--
----------------------------------------------------------------

createDate = "";
createEvt = 0;

--inputs player event inputs into saved variable database
function EVTFrameAcceptBtn_OnClick()
	local mando;
	local preFrom = UIDropDownMenu_GetSelectedValue(EVTFrameFromTime) - 1;
	local preTo = UIDropDownMenu_GetSelectedValue(EVTFrameToTime);
	local amFrom = UIDropDownMenu_GetSelectedValue(EVTFrameAMPM1);
	local amTo = UIDropDownMenu_GetSelectedValue(EVTFrameAMPM2);
	if (TableIndexExists(CalendarData, createDate) == false) then
		CalendarData[createDate] = {};
	end
	if EVTFrameMando:GetChecked() == nil then
		mando = 0;
	else
		mando = 1;
	end
	if not CalendarOptions["milFormat"] then
		if amFrom == 2 then
			preFrom = preFrom + 12;
		end
		if amTo == 2 then
			preTo = preTo + 11;
		elseif amTo == 1 then
			amTo = amTo - 1;
		end
	end
		
	if (EVTFrameCreatePopupTitle:GetText() == "Create Event") then
		table.insert(CalendarData[createDate],{
			[1] = checkIllegal(EVTFrameNameEditBox:GetText()), --Event Name
			[2] = checkIllegal(EVTFrameCreatorEditBox:GetText()), -- Creator's Name
			[3] = preFrom, -- Start Time
			[4] = "UNUSED", --DEPRECIATED: OLD AMPM FROM SLOT, SAVE FOR FUTURE GROWTH?
			[5] = preTo, -- End Time
			[6] = "UNUSED", --DEPRECIATED: OLD AMPM TO SLOT, SAVE FOR FUTURE GROWTH?
			[7] = UIDropDownMenu_GetSelectedValue(EVTFrameType), --event type
			[8] = UIDropDownMenu_GetSelectedValue(EVTFrameSubType), -- event subtype
			[9] = mando, --mandatory flag
			[10] = checkIllegal(EVTFrameNoteEditBox:GetText()), --note box
			[11] = 1, --locked flag, 1 = can invite, 0 = cannot invite
			[12] = { --confirmed table of players
				[1] = { --first player is creator
					[1] = UnitName("player"),
					[2] = UnitClass("player"),
					[3] = "DPS", 
					[4] = 9
					}
				}
			});
		else -- if window is mondify not create
			CalendarData[createDate][createEvt] = {
				[1] = checkIllegal(EVTFrameNameEditBox:GetText()),
				[2] = checkIllegal(EVTFrameCreatorEditBox:GetText()),
				[3] = preFrom,
				[4] = "UNUSED",
				[5] = preTo,
				[6] = "UNUSED",
				[7] = UIDropDownMenu_GetSelectedValue(EVTFrameType),
				[8] = UIDropDownMenu_GetSelectedValue(EVTFrameSubType),
				[9] = mando,
				[10] = checkIllegal(EVTFrameNoteEditBox:GetText()),
				[11] = 1
			};
		end
		
		EVT_UpdateScrollBar();
		EVTClearFrame();
		HideUIPanel(EVTFrameOverlay);
		EVT_UpdateCalendar();
end

-------Almost everything under here is the same three functions over and over for dropdown menu functionality, refer to blizzard api

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
	local maxTime;
	if CalendarOptions["milFormat"] then
		maxTime = 24;
		HideUIPanel(EVTFrameAMPM1);
	else
		maxTime = 12;
		ShowUIPanel(EVTFrameAMPM1);
	end
    for i = 1, maxTime, 1 do
		local btnTime;
		if not CalendarOptions["milFormat"] and (i - 1) == 0 then
			btnTime = 12;
		else
			btnTime = i - 1;
		end
		str = getTimeStr((btnTime), true);
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
	local maxTime;
	if CalendarOptions["milFormat"] then
		maxTime = 24;
		HideUIPanel(EVTFrameAMPM2);
	else
		maxTime = 13;
		ShowUIPanel(EVTFrameAMPM2);
	end
    for i = 1, maxTime, 1 do
		str = getTimeStr((i), true);
		if not CalendarOptions["milFormat"] and (i) == 13 then
				str = "11:59";
		elseif not CalendarOptions["milFormat"] then
			j = i;
			if i - 1 == 0 then
				local j = 13
			end
			str = getTimeStr((j - 1), true);	
		end
		if i == 24 then
			str = "23:59";
		end
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

function EVTCheckComplete() -- verifies if inputs are legal, end time cannot be before start time, and has a proper name
	if ((EVTFrameNameEditBox:GetText() ~= "") and compareInputTime() and (isSubtype(UIDropDownMenu_GetSelectedValue(EVTFrameType)) == (UIDropDownMenu_GetSelectedValue(EVTFrameSubType) ~= 0))) then
		EVTFrameCreatePopupAccept:Enable()
	else
		EVTFrameCreatePopupAccept:Disable()
	end
end

function EVTClearFrame() --reset frames
	EVTFrameCreatorEditBox:SetText("");
	EVTFrameNameEditBox:SetText("");
	EVTFrameNoteEditBox:SetText("");
	HideUIPanel(EVTFrameSubType);
end

--------- Invite Popup --------------
function EVTFrameInvitePopupAccept_OnClick()
	local tChan = {"PARTY", "RAID", "GUILD", "GUILD"}; --table of who to send invites too
	local toOff = 0;	-- send to officers flag 1 for true, 0 false
	local toWho = checkIllegal(EVTFrameInviteNameEditBox:GetText()); -- who is it going to
	local toChannel = tChan[UIDropDownMenu_GetSelectedValue(EVTFrameInviteMenu)]; -- selection from table of who to send to
	local lockedTo = 0; -- can recepients invite others?
	if CalendarData[createDate][createEvt][11] == 1 then
		lockedTo = UIDropDownMenu_GetSelectedValue(EVTFrameInviteLockMenu);
	else
		lockedTo = CalendarData[createDate][createEvt][11];
	end
	if toWho == "" then
		toWho = "All ";
	end
	if UIDropDownMenu_GetSelectedValue(EVTFrameInviteMenu) == 4 then
		toOff = 1;
	end
	
	local tableStr = TableToString(CalendarData[createDate][createEvt], lockedTo);
	local msgStr = string.format("%s¿%s¿%s¿%s¿", toWho, tostring(toOff), "Invite", tableStr); --build invite message

	SendAddonMessage("EVTCalendar", msgStr, toChannel); -- send invite message
	EVTClearInviteFrame();
end

--more dropdown menu stuff

function EVTFrameInviteMenu_OnLoad()
    UIDropDownMenu_Initialize(this, EVTFrameInviteMenu_Initialize);
    UIDropDownMenu_SetWidth(125, EVTFrameInviteMenu);
    UIDropDownMenu_SetSelectedValue(this, 3);
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
    UIDropDownMenu_SetSelectedValue(this, 1);
	UIDropDownMenu_JustifyText("LEFT", EVTFrameInviteLockMenu);
end

function EVTFrameInviteLockMenu_Initialize()
    local info;

    for i = 1, 3, 1 do
		info = buildButton(evtInviteLock[i], i, EVTFrameInviteLockMenu_OnClick)
		UIDropDownMenu_AddButton(info);
	end
end

function EVTFrameInviteLockMenu_OnClick()
    UIDropDownMenu_SetSelectedValue(EVTFrameInviteLockMenu, this.value);
end

--reset frame
function EVTClearInviteFrame()
	EVTFrameInviteNameEditBox:SetText("");
end

--cycles through invite queue table for events
function EVT_ShowNextInvite()
	local str = "";
	if TableIndexExists(invite_Queue, 1) then
		ShowUIPanel(EVTFrameInviteQueue);
		str = string.format("%s %s", invite_Queue[1][1], EVT_INVITE_QUEUE);
		EVTFrameInviteQString:SetText(str);
		EVT_UpdateQueueDetail(invite_Queue[1][2]);
		PlaySoundFile("Sound\\interface\\uEscapeScreenOpen.wav");
	else
		HideUIPanel(EVTFrameInviteQueue);
		EVTButton_PulseOff();
		PlaySoundFile("Sound\\interface\\uEscapeScreenClose.wav");
	end
	
end

--populate invite queue window with current event details
function EVT_UpdateQueueDetail(str)
	print(str)
	local s1, s2, s3, s4, s5, s6, s7, s8, s9, _, _, s12 = strSplit(str, "¡");
	local subType = tonumber(s7);
	local mando = tonumber(s9);
	local dateStr = convertDate(s12);
	
	EVTQueueDetailsName:SetText(s1);
	EVTFrameInviteDString:SetText(dateStr);
	EVTQueueDetailsTime:SetText(string.format("%s    -    %s", getTimeStr(tonumber(s3)), getTimeStr(tonumber(s5))));
	if (subType == 1 or subType == 2 or subType == 3) then
		EVTQueueDetailsType:SetText(string.format("%s    -    %s", evtTypes[subType], evtSubMenu[tonumber(s7)][tonumber(s8)]));
	else
		EVTQueueDetailsType:SetText(evtTypes[subType]);
	end
	if (mando == 1) then
		EVTQueueDetailsMando:SetText("Yes");
		EVTQueueDetailsMando:SetTextColor(1, 0.1, 0.1);
	else
		EVTQueueDetailsMando:SetText("No");
		EVTQueueDetailsMando:SetTextColor(1, 1, 1);
	end
end	

--add invite to events database
function EVTFrameInviteQueueAccept_OnClick()
	StringToTable(invite_Queue[1][2]);
	table.remove(invite_Queue, 1);
	EVT_ShowNextInvite();
end

--reject invite
function EVTFrameInviteQueueDecline_OnClick()
	table.remove(invite_Queue, 1);
	EVT_ShowNextInvite();
end

--------- Options Popup --------------

function EVTFrameOptionsAccept_OnClick() --confirm new settings
	CalendarOptions["frameDrag"] = checkBool(EVTFrameOptionsLock:GetChecked());
	CalendarOptions["confirmEvents"] = checkBool(EVTFrameOptionsConfirm:GetChecked());
	CalendarOptions["acceptEvents"] = checkBool(EVTFrameOptionsEvents:GetChecked());
	CalendarOptions["milFormat"] = checkBool(EVTFrameOptions24h:GetChecked());
	EVT_UpdateCalendar();
	HideUIPanel(EVTFrameOptions);
end

function EVTFrameOptionsReset_OnClick() --resets all frames to default positions
	DEFAULT_CHAT_FRAME:AddMessage("[EVTCalendar] All window locations reset to default.", 0.8, 0.8, 0.1);
	EVTButton_Reset();
	EVTFrame:ClearAllPoints()
	EVTFrame:SetPoint(
		"TOPLEFT",
		"UIParent",
		"TOPLEFT",
		355,
		-106
		);
	EVTFrameOptions:ClearAllPoints()
	EVTFrameOptions:SetPoint(
		"CENTER",
		"UIParent",
		"CENTER",
		0,
		0
		);
	EVTFrameInvitePopup:ClearAllPoints()
	EVTFrameInvitePopup:SetPoint(
		"CENTER",
		"UIParent",
		"CENTER",
		0,
		0
		);
	EVTFrameInviteQueue:ClearAllPoints()
	EVTFrameInviteQueue:SetPoint(
		"CENTER",
		"UIParent",
		"CENTER",
		0,
		0
		);
	EVTFrameCreatePopup:ClearAllPoints()
	EVTFrameCreatePopup:SetPoint(
		"CENTER",
		"UIParent",
		"CENTER",
		0,
		0
		);
	EVTFrameManage:ClearAllPoints()
	EVTFrameManage:SetPoint(
		"CENTER",
		"UIParent",
		"CENTER",
		0,
		0
		);
end



--- Helper Functions ---
function checkBool(num) --if num is anything return true, nil is false
	if num == nil then
		return false;
	else
		return true;
	end
end

function compareInputTime() --checks if dropdown menu start time is before end time, returns boolean
	local bTime = UIDropDownMenu_GetSelectedValue(EVTFrameFromTime) - 1;
	local aTime;
	if not CalendarOptions["milFormat"] then
		aTime = UIDropDownMenu_GetSelectedValue(EVTFrameToTime) - 1;
	else
		aTime = UIDropDownMenu_GetSelectedValue(EVTFrameToTime);
	end
	local bAMPM = UIDropDownMenu_GetSelectedValue(EVTFrameAMPM1);
	local aAMPM = UIDropDownMenu_GetSelectedValue(EVTFrameAMPM2);
	
	if (aTime + (12 * (aAMPM - 1))) > (bTime + (12 * (bAMPM - 1))) then
		return true;
	else
		return false;
	end
end

--if selected type contains subtypes
function isSubtype(subType)
	if subType == 1 or subType == 2 or subType == 3 then
		return true;
	end
	return false;
end

--build a button info and returns it to function that called
function buildButton(btText, btValue, btFunc)
	local info;
    info = {};
    info.text = btText;
    info.value = btValue;
    info.func = btFunc;
    info.checked = nil;
	return info;
end

--convert time into readable string format
function getTimeStr(i, bool)
	if CalendarOptions["milFormat"] then
		if i < 10 then
			i = ("0"..i)
		end
		if i == 24 then 
			str = "23:59"
		else
			str = string.format("%s:%s", i, "00");
		end
	else 
		ampm = "am";
		if i == 12 then
			ampm = "pm";
		end
		if i > 12 then
			if i == 24 then
				str = "11:59pm"
				return str;				
			else
				i = i - 12;
				ampm = "pm";
			end
		end
		if i == 0 then
			i = 12;
		end
		if bool == true then
			str = string.format("%s:%s", i, "00");
		else
			str = string.format("%s:%s%s", i, "00", ampm);
		end
	end
	return str;
end