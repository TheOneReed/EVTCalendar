----------------------------------------------------------------
-- EVTCalendar
-- Author: Reed
--
--
----------------------------------------------------------------

managedEvent = nil;
managedTable = {};

EVT_MOVING_MEMBER = nil;
EVT_TARGET_SLOT = nil;
EVT_TARGET_GROUP = nil;
EVT_SUBGROUP_LISTS = {};
EVT_PULLOUT_BUTTON_HEIGHT = 33;
EVT_MOVING_PULLOUT = nil;
EVT_NUM_GROUPS = 9;


function EVTFrameManageDone_OnClick()
	HideUIPanel(EVTFrameOverlay);
	HideUIPanel(EVTFrameManage);
end

--- Faux Raid Frame
function EVT_UpdateAttendingScrollBar()
    local y;
    local yoffset;
    local t;
	local tSize;
	if TableIndexExists(CalendarData[displayDate()][getButtonPosOffset()], 12) then
		t = CalendarData[displayDate()][getButtonPosOffset()][12];
	else
		CalendarData[displayDate()][getButtonPosOffset()][12] = {}
		t = CalendarData[displayDate()][getButtonPosOffset()][12];
	end
	tSize = table.getn(t);
	FauxScrollFrame_Update(EVTManageAttendingScrollFrame, tSize, 5, 20);
    for y = 1, 5, 1 do
        yoffset = y + FauxScrollFrame_GetOffset(EVTManageAttendingScrollFrame);
        if (yoffset <= tSize) then
			local t2 = t[yoffset];
        else
--            getglobal("ConfirmedText" .. y):Hide();
        end
    end
end

function EVTSetManagedTable()
	local t;
	if TableIndexExists(CalendarData[displayDate()][getButtonPosOffset()], 12) then
		t = CalendarData[displayDate()][getButtonPosOffset()][12];
	else
		CalendarData[displayDate()][getButtonPosOffset()][12] = {}
		t = CalendarData[displayDate()][getButtonPosOffset()][12];
	end
	managedTable = EVT_CopyTable(t);
	EVTManageGroupFrame_Update();
end

function EVTManageGroupFrame_Update()
	-- Reset group index counters;
	for i = 1, EVT_NUM_GROUPS do
		getglobal("EVTManageGroup"..i).nextIndex = 1;
	end

	EVTManageGroup_ResetSlotButtons();
	
	-- Fill out buttons
	local numAttending = table.getn(managedTable);
	local raidGroup, color;
	local buttonName, buttonLevel, buttonClass, buttonRank;
	local name, subgroup, role, class, online;
	for i = 1, 55 do
		button = getglobal("EVTManageGroupButton"..i);
		if ( i <= numAttending ) then
			name = managedTable[i][1]
			class = managedTable[i][2]
			role = managedTable[i][3]
			subgroup = managedTable[i][4]
			raidGroup = getglobal("EVTManageGroup"..subgroup);
			-- To prevent errors when the server hiccups
			if true then --REMOVE?
				buttonName = getglobal("EVTManageGroupButton"..i.."Name");
				buttonClass = getglobal("EVTManageGroupButton"..i.."Class");
				buttonLevel = getglobal("EVTManageGroupButton"..i.."Level");
				buttonRank = getglobal("EVTManageGroupButton"..i.."Rank");
				button.id = i;
				
				button.name = name;
				button.unit = "raid"..i;
				
				if ( not name ) then
					name = UNKNOWN;
				end
				
				-- Fill in subgroup list

				buttonName:SetText(name);
				if ( class ) then
					buttonClass:SetText(class);
				else
					buttonClass:SetText("");
				end
				
				if ( role ) then
					buttonLevel:SetText(role);
				else
					buttonLevel:SetText("");
				end
				
				color = RAID_CLASS_COLORS[string.upper(class)];
				if ( color ) then
					buttonName:SetTextColor(color.r, color.g, color.b);
					buttonClass:SetTextColor(color.r, color.g, color.b);
					buttonLevel:SetTextColor(color.r, color.g, color.b);
				end

				-- Anchor button to slot
				if ( EVT_MOVING_MEMBER ~= button  ) then
					button:SetPoint("TOPLEFT", "EVTManageGroup"..subgroup.."Slot"..raidGroup.nextIndex, "TOPLEFT", 0, 0);
				end
				
				-- Save slot for future use
				button.slot = "EVTManageGroup"..subgroup.."Slot"..raidGroup.nextIndex;
				-- Save the button's subgroup too
				button.subgroup = subgroup;
				-- Tell the slot what button is in it
				getglobal("EVTManageGroup"..subgroup.."Slot"..raidGroup.nextIndex).button = button:GetName();
				raidGroup.nextIndex = raidGroup.nextIndex + 1;
				button:SetID(i);
				button:Show();
			end
		else
			button:Hide();
		end
	end
end

function EVTManageGroupFrame_OnUpdate(elapsed)
	if ( EVT_MOVING_MEMBER ) then
		local button, slot;
		EVT_TARGET_SLOT = nil;
		EVT_TARGET_GROUP = nil;
		for i = 1, EVT_NUM_GROUPS do
			if i < 9 then 
				for j = 1, 5 do
					slot = getglobal("EVTManageGroup"..i.."Slot"..j);
					if ( MouseIsOver(slot) ) then
						slot:LockHighlight();
						EVT_TARGET_SLOT = slot;
						EVT_TARGET_GROUP = i;
					else
						slot:UnlockHighlight();
					end
				end
			else 
				for j = 1, 15 do
					slot = getglobal("EVTManageGroup"..i.."Slot"..j);
					if ( MouseIsOver(slot) ) then
						slot:LockHighlight();
						EVT_TARGET_SLOT = slot;
						EVT_TARGET_GROUP = i;
					else
						slot:UnlockHighlight();
					end
				end
			end
		end
	end
end

function EVTManageGroupButton_OnDragStart()
	local cursorX, cursorY = GetCursorPosition();
	local scale = UIParent:GetEffectiveScale();
	this:ClearAllPoints();
	this:SetPoint("CENTER", nil, "BOTTOMLEFT", cursorX/scale, cursorY/scale);
	this:StartMoving();
	EVT_MOVING_MEMBER = this;
end

function EVTManageGroupButton_OnDragStop(raidButton)
	if ( not raidButton ) then
		raidButton = this;
	end
	local name = EVT_MOVING_MEMBER.name
	raidButton:StopMovingOrSizing();
	EVT_MOVING_MEMBER = nil;
	if ( EVT_TARGET_SLOT and EVT_TARGET_SLOT:GetParent():GetID() ~= raidButton.subgroup ) then
		if (EVT_TARGET_SLOT.button) then
			local button = getglobal(EVT_TARGET_SLOT.button);
			managedTable[EVT_GetPlayerIndex(name)][4] = EVT_TARGET_GROUP;
			managedTable[EVT_GetPlayerIndex(button.name)][4] = raidButton.subgroup;
			EVTManageGroupFrame_Update();
			--button:SetPoint("TOPLEFT", this, "TOPLEFT", 0, 0);
			--SwapRaidSubgroup(raidButton:GetID(), button:GetID());
		else
			local slot = EVT_TARGET_SLOT:GetParent():GetName().."Slot"..EVT_TARGET_SLOT:GetParent().nextIndex;
			raidButton:SetPoint("TOPLEFT", slot, "TOPLEFT", 0, 0);
			managedTable[EVT_GetPlayerIndex(name)][4] = EVT_TARGET_GROUP;
			EVT_TARGET_SLOT:UnlockHighlight();
			EVTManageGroupFrame_Update();
		end
	else
		if ( EVT_TARGET_SLOT ) then
			EVT_TARGET_SLOT:UnlockHighlight();
		end
		raidButton:SetPoint("TOPLEFT", raidButton.slot, "TOPLEFT", 0, 0);
	end
end

function EVTManageGroupButton_OnClick(button)
	if ( button == "LeftButton" ) then
		local unit = "raid"..this.id;
		if ( SpellIsTargeting() ) then
			SpellTargetUnit(unit);
		elseif ( CursorHasItem() ) then
			DropItemOnUnit(unit);
		else
			TargetUnit(unit);
		end
	else
		HideDropDownMenu(1);
		if ( this.id and this.name ) then
			FriendsDropDown.initialize = RaidFrameDropDown_Initialize;
			FriendsDropDown.displayMode = "MENU";
			ToggleDropDownMenu(1, nil, FriendsDropDown, "cursor");
		end
	end
end

function EVT_GetPlayerIndex(name)
	for x = 1, table.getn(managedTable) do
		if managedTable[x][1] == name then
			return x;
		end
	end
	return false;
end

function EVTManageGroup_ResetSlotButtons()
	for i=1, 9 do
		for j=1, 5 do
			getglobal("EVTManageGroup"..i.."Slot"..j).button = nil;
		end
	end
end

