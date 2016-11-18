----------------------------------------------------------------
-- EVTCalendar
-- Author: Reed
--
--
----------------------------------------------------------------

function EVTFrameFromTime_OnLoad()
    UIDropDownMenu_Initialize(this, EVTFrameFromTime_Initialize);
    UIDropDownMenu_SetWidth(75, EVTFrameFromTime);
    UIDropDownMenu_SetSelectedValue(this, 1);
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
			if (int == 0) then
				str = string.format("%s:%s", int + 12, "30");
			else
				str = string.format("%s:%s", int, "30");
			end
        end
		info = buildButton(str, i, EVTFrameFromTime_OnClick)  
        UIDropDownMenu_AddButton(info);
    end
end

function EVTFrameFromTime_OnClick()
    UIDropDownMenu_SetSelectedValue(EVTFrameFromTime, this.value);
end

function EVTFrameToTime_OnLoad()
    UIDropDownMenu_Initialize(this, EVTFrameToTime_Initialize);
    UIDropDownMenu_SetWidth(75, EVTFrameToTime);
    UIDropDownMenu_SetSelectedValue(this, 1);
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
			if (int == 0) then
				str = string.format("%s:%s", int + 12, "30");
			else
				str = string.format("%s:%s", int, "30");
			end
        end
		info = buildButton(str, i, EVTFrameToTime_OnClick)  
        UIDropDownMenu_AddButton(info);
    end
end

function EVTFrameToTime_OnClick()
    UIDropDownMenu_SetSelectedValue(EVTFrameToTime, this.value);
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

function EVTFrameType_OnClick()
    UIDropDownMenu_SetSelectedValue(EVTFrameType, this.value);
end

function EVTFrameType_OnLoad()
    UIDropDownMenu_Initialize(this, EVTFrameType_Initialize);
    UIDropDownMenu_SetWidth(75, EVTFrameType);
    UIDropDownMenu_SetSelectedValue(this, 0);

end

function EVTFrameType_Initialize()
    local info;
	local evtTypes = {"Dungeon", "Raid", "PvP", "Quests", "Meeting", "Event", "Other" };

    for i = 1, 7, 1 do
		info = buildButton(evtTypes[i], i, EVTFrameType_OnClick)
		UIDropDownMenu_AddButton(info);
	end
end

function EVTFrameType_OnClick()
    UIDropDownMenu_SetSelectedValue(EVTFrameType, this.value);
	EVTFrameSubType_Toggle();
end

function EVTFrameSubType_OnLoad()
    UIDropDownMenu_Initialize(this, EVTFrameSubType_Initialize);
    UIDropDownMenu_SetWidth(125, EVTFrameSubType);
    UIDropDownMenu_SetSelectedValue(this, 0);
end

function EVTFrameSubType_Initialize()
    local info;
	local n = 0;
	local subType= UIDropDownMenu_GetSelectedValue(EVTFrameType);
	local evtSubMenu = {
		{"Blackfathom Depths", "Blackrock Depths", "Blackrock Spire", "The Deadmines", "Dire Maul", "Gnomeregan", "Maraudon", "Ragefire Chasm", "Razorfen Downs", "Razorfen Kraul", "Scarlet Monastery", "Scholomance", "Shadowfang Keep", "The Stockades", "Stratholome", "The Sunken Temple", "Uldaman", "Wailing Caverns", "Zul'Farak" },
		{"Ahn'Qiraj (20)", "Ahn'Qiraj (40)", "Blackwing Lair", "Molten Core", "Naxxramas", "Onxyia's Lair", "Zul'Gurub"},
		{"Warsong Gultch", "Arathi Basin", "Alterac Valley", "World"}
		};
	UIDropDownMenu_SetSelectedValue(EVTFrameSubType, 0);
	if subType == 1 or subType == 2 or subType == 3 then
		n = table.getn(evtSubMenu[subType]);
	end
	for i = 1, n, 1 do
		if subType == 1 or subType == 2 or subType == 3 then
			UIDropDownMenu_SetSelectedValue(EVTFrameSubType, 0);
			info = buildButton(evtSubMenu[subType][i], i, EVTFrameSubType_OnClick)
			UIDropDownMenu_AddButton(info);
		end
	end
end

function EVTFrameSubType_Toggle()
	subType = UIDropDownMenu_GetSelectedValue(EVTFrameType);
	if subType == 1 or subType == 2 or subType == 3 then
		ShowUIPanel(EVTFrameSubType);
		UIDropDownMenu_SetSelectedValue(EVTFrameSubType, 0);
		UIDropDownMenu_SetText(nil, EVTFrameSubType)
	else 
		HideUIPanel(EVTFrameSubType);
	end
end

function EVTFrameSubType_OnClick()
    UIDropDownMenu_SetSelectedValue(EVTFrameSubType, this.value);
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
