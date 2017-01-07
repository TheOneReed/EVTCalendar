----------------------------------------------------------------
-- EVTCalendar
-- Author: Reed
--
--
----------------------------------------------------------------

managedEvent = nil;
managedTable = {};

local EVT_CRITERIA = 5;
local EVT_CRITREVERSE = false;
local EVT_CRITLAST = 3;
local EVT_MOVING_MEMBER = nil;
local EVT_TARGET_SLOT = nil;
local EVT_TARGET_GROUP = nil;
local EVT_SUBGROUP_LISTS = {};
local EVT_PULLOUT_BUTTON_HEIGHT = 33;
local EVT_MOVING_PULLOUT = nil;
local EVT_NUM_GROUPS = 9;
local EVT_SUBGROUP_9 = {};
local EVT_SUBGROUP_9_BUTTONS = {};
local EVT_HAS_GUILD_INFO = false;

function EVTFrameManageDone_OnClick()
	managedTable = EVT_TableSort(managedTable, 5, false);
	for k in pairs (CalendarData[displayDate()][getButtonPosOffset()][12]) do
		CalendarData[displayDate()][getButtonPosOffset()][12][k] = nil
	end
	CalendarData[displayDate()][getButtonPosOffset()][12] = EVT_CopyTable(managedTable);
	HideUIPanel(EVTFrameOverlay);
	HideUIPanel(EVTFrameManage);
end

function EVTFrameManageInvite_OnClick()
	for x = 1, table.getn(managedTable) do
		if managedTable[x][4] ~= "9" then
			InviteByName(managedTable[x][1]);
		end
	end
end

--- Faux Raid Scroll Frame
function EVT_UpdateAttendingScrollBar()
    local y;
    local yoffset;
    local t = EVT_SUBGROUP_9;
	local b = EVT_SUBGROUP_9_BUTTONS;
	local tSize = table.getn(t);
	local bSize = table.getn(b);
	FauxScrollFrame_Update(EVTManageAttendingScrollFrame, tSize, 15, 120);
    for y = 1, 15, 1 do
        yoffset = y + FauxScrollFrame_GetOffset(EVTManageAttendingScrollFrame);
        if (yoffset <= tSize) then
			local t2 = t[yoffset];
			local b2 = b[y];
			local name = t2[1]
			local class = t2[2]
			local role;
			if EVT_CRITERIA == 3 or EVT_CRITERIA == 5 or EVT_CRITERIA == 6 then
				role = t2[EVT_CRITERIA]
				EVT_CRITLAST = EVT_CRITERIA;
			else
				role = t2[EVT_CRITLAST]
			end
			local subgroup = t2[4]
			local buttonName = getglobal(b2:GetName().."Name");
			local buttonClass = getglobal(b2:GetName().."Class");
			local buttonLevel = getglobal(b2:GetName().."Level");
			local buttonRank = getglobal(b2:GetName().."Rank");
			
			b2.name = name;
			if ( not name ) then
				name = UNKNOWN;
			end
			buttonName:SetText(name);
			if ( class ) then
				buttonClass:SetText(class);
				color = RAID_CLASS_COLORS[string.upper(class)];
			else
				buttonClass:SetText("");
				color = RAID_CLASS_COLORS[string.upper("warrior")];
			end
			if ( role ) then
				buttonLevel:SetText(role);
			else
				buttonLevel:SetText("");
			end
			if ( color ) then
				buttonName:SetTextColor(color.r, color.g, color.b);
				buttonClass:SetTextColor(color.r, color.g, color.b);
				buttonLevel:SetTextColor(color.r, color.g, color.b);
			end
        end
    end
end

function EVTSetManagedTable()
	local t;
	for k in pairs (managedTable) do
		managedTable[k] = nil
	end
	if TableIndexExists(CalendarData[displayDate()][getButtonPosOffset()], 12) then
		t = CalendarData[displayDate()][getButtonPosOffset()][12];
	else
		CalendarData[displayDate()][getButtonPosOffset()][12] = {}
		t = CalendarData[displayDate()][getButtonPosOffset()][12];
	end
	managedTable = EVT_CopyTable(t);
	GuildRoster();
	if EVT_HAS_GUILD_INFO then
		EVTGetGuildRankInfo();
	end
	EVTManageGroupFrame_Update();
end

function EVTGetGuildRankInfo()
	if (player_Info["guild"] ~= false) and (EVTFrameManage:IsVisible() == 1) then
		local guildNum = GetNumGuildMembers();
		for x = 1, table.getn(managedTable) do
			name = managedTable[x][1];
			managedTable[x][6] = 10;
			for y = 1, guildNum do
				local gName, _, rankIndex = GetGuildRosterInfo(y);
				if name == gName then
					managedTable[x][6] = rankIndex;
					break;
				end
			end
		end
	end
	EVT_HAS_GUILD_INFO = true;
end

function EVTManageGroupFrame_Update()
	-- Reset group index counters;
	for i = 1, EVT_NUM_GROUPS do
		getglobal("EVTManageGroup"..i).nextIndex = 1;
	end
	for i = 1, table.getn(EVT_SUBGROUP_9) do
		table.remove(EVT_SUBGROUP_9, 1);
	end
	for i = 1, table.getn(EVT_SUBGROUP_9_BUTTONS) do
		table.remove(EVT_SUBGROUP_9_BUTTONS, 1);
	end
	EVTManageGroup_ResetSlotButtons();
	
	-- Fill out buttons
	local numAttending = table.getn(managedTable);
	local raidGroup, color, buttonIter;
	local buttonName, buttonLevel, buttonClass, buttonRank;
	local name, subgroup, role, class, online;
	if numAttending < 55 then
		buttonIter = 55;
	else	
		buttonIter = numAttending;
	end

	for i = 1, buttonIter do
		button = getglobal("EVTManageGroupButton"..i);
		if ( i <= numAttending ) then
			name = managedTable[i][1]
			class = managedTable[i][2]
			if EVT_CRITERIA == 5 or EVT_CRITERIA == 6 then
				role = managedTable[i][EVT_CRITERIA]
				EVT_CRITLAST = EVT_CRITERIA;
			else
				role = managedTable[i][EVT_CRITLAST]
			end
			subgroup = managedTable[i][4]
			if subgroup == "9" then
				table.insert(EVT_SUBGROUP_9, managedTable[i]);
			end
			raidGroup = getglobal("EVTManageGroup"..subgroup);
			-- To prevent errors when the server hiccups
			if not (subgroup == "9" and raidGroup.nextIndex > 15) then
				if subgroup == "9" then
					table.insert(EVT_SUBGROUP_9_BUTTONS, button);
				end
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
					color = RAID_CLASS_COLORS[string.upper(class)];
				else
					buttonClass:SetText("");
					color = RAID_CLASS_COLORS[string.upper("warrior")];
				end
				
				if ( role ) then
					buttonLevel:SetText(role);
				else
					buttonLevel:SetText("");
				end
				
				if ( color ) then
					buttonName:SetTextColor(color.r, color.g, color.b);
					buttonClass:SetTextColor(color.r, color.g, color.b);
					buttonLevel:SetTextColor(color.r, color.g, color.b);
				end

				-- Anchor button to slot
				if ( EVT_MOVING_MEMBER ~= button  ) then
					button:SetPoint("TOPLEFT", "EVTManageGroup"..subgroup.."Slot"..raidGroup.nextIndex, "TOPLEFT", 0, 0);
				end
				button:SetFrameLevel(5);
				-- Save slot for future use
				button.slot = "EVTManageGroup"..subgroup.."Slot"..raidGroup.nextIndex;
				-- Save the button's subgroup too
				button.subgroup = subgroup;
				-- Tell the slot what button is in it
				getglobal("EVTManageGroup"..subgroup.."Slot"..raidGroup.nextIndex).button = button:GetName();
				raidGroup.nextIndex = raidGroup.nextIndex + 1;
				button:SetID(i);
				button:Show();
			else
				button:Hide();
			end	
		else
			button:Hide();
		end
	end
	EVTCountRaidData();
	EVT_UpdateAttendingScrollBar();
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

function EVTCountRaidData()
	local paladins = 0;
	local warriors = 0;
	local warlocks = 0;
	local mages = 0;
	local shamans = 0;
	local rogues = 0;
	local hunters = 0;
	local druids = 0;
	local priests = 0;
	local tanks = 0;
	local healers = 0;
	local dps = 0;
	for x = 1, table.getn(managedTable) do
		if managedTable[x][4] ~= "9" then
			if managedTable[x][2] == "Paladin" then
				paladins = paladins + 1;
			elseif managedTable[x][2] == "Warrior" then
				warriors = warriors + 1;
			elseif managedTable[x][2] == "Warlock" then
				warlocks = warlocks + 1;
			elseif managedTable[x][2] == "Mage" then
				mages = mages + 1;
			elseif managedTable[x][2] == "Shaman" then
				shamans = shamans + 1;
			elseif managedTable[x][2] == "Rogue" then
				rogues = rogues + 1;
			elseif managedTable[x][2] == "Hunter" then
				hunters = hunters + 1;
			elseif managedTable[x][2] == "Druid" then
				druids = druids + 1;
			elseif managedTable[x][2] == "Priest" then
				priests = priests + 1;
			end
			if managedTable[x][3] == "DPS" then
				dps = dps + 1;
			elseif managedTable[x][3] == "Tank" then
				tanks = tanks + 1;
			elseif managedTable[x][3] == "Heal" then
				healers = healers + 1;
			elseif managedTable[x][3] == "Self" then
				if CalendarOptions["selectedRole"] == 1 then
					dps = dps + 1;
				elseif CalendarOptions["selectedRole"] == 3 then
					tanks = tanks + 1;
				elseif CalendarOptions["selectedRole"] == 2 then
					healers = healers + 1;
				end
			end
		end
	end
	EVTRaidCompTankN:SetText(tanks);
	EVTRaidCompDPSN:SetText(dps);
	EVTRaidCompHealN:SetText(healers);
	EVTRaidCompPaladinN:SetText(paladins);
	EVTRaidCompWarriorN:SetText(warriors);
	EVTRaidCompWarlockN:SetText(warlocks);
	EVTRaidCompMageN:SetText(mages);
	EVTRaidCompShamanN:SetText(shamans);
	EVTRaidCompRogueN:SetText(rogues);
	EVTRaidCompHunterN:SetText(hunters);
	EVTRaidCompDruidN:SetText(druids);
	EVTRaidCompPriestN:SetText(priests);
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
			managedTable[EVT_GetPlayerIndex(name)][4] = tostring(EVT_TARGET_GROUP);
			managedTable[EVT_GetPlayerIndex(button.name)][4] = tostring(raidButton.subgroup);
			EVTManageGroupFrame_Update();
			--button:SetPoint("TOPLEFT", this, "TOPLEFT", 0, 0);
			--SwapRaidSubgroup(raidButton:GetID(), button:GetID());
		else
			managedTable[EVT_GetPlayerIndex(name)][4] = tostring(EVT_TARGET_GROUP);
			EVT_TARGET_SLOT:UnlockHighlight();
			EVTManageGroupFrame_Update();
		end
	else
		if ( EVT_TARGET_SLOT ) then
			EVT_TARGET_SLOT:UnlockHighlight();
			managedTable[EVT_GetPlayerIndex(name)][4] = EVT_TARGET_GROUP;
			EVTManageGroupFrame_Update();
		else
			managedTable[EVT_GetPlayerIndex(name)][4] = "9";
			EVTManageGroupFrame_Update();
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

function EVT_SortManaged(criteria)
	if criteria == 6 and EVT_HAS_GUILD_INFO == false then
		criteria = 5;
	end
	managedTable = EVT_TableSort(managedTable, 5, false);
	if criteria == EVT_CRITERIA then
		EVT_CRITREVERSE = not EVT_CRITREVERSE;
	else
		EVT_CRITERIA = criteria;
		EVT_CRITREVERSE = false;
	end
	managedTable = EVT_TableSort(managedTable, EVT_CRITERIA, EVT_CRITREVERSE);
	EVTManageGroupFrame_Update();
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
	for i = 1, 9 do
		if i < 9 then
			for j = 1, 5 do
				getglobal("EVTManageGroup"..i.."Slot"..j).button = nil;
			end
		else
			for j = 1, 15 do
				getglobal("EVTManageGroup"..i.."Slot"..j).button = nil;
			end
		end		
	end
end

