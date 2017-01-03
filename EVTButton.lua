local EVTButtonPosition = 0;
local EVTButtonX = 0;
local EVTButtonY = 0;
EVTButtonPulsing = false;
local EVTButtonLocked = true;

--checks if you have a pending invite, if not, opens calendar frame
function EVTButton_OnClick()
	if EVTButtonPulsing then
		EVT_ShowNextInvite();
	else
		EVT_Toggle();
	end
end

--makes initial minimap button position
function EVTButton_Init()
	EVTButtonLocked = CalendarOptions["buttonLocked"];
	if EVTButtonLocked then
		EVTButtonPosition = 134.66365694988;
		EVTButton_UpdatePosition();
	else
		EVTButtonX = 1472;
		EVTButtonY = 835;	
		EVTButton_UpdatePosition();
	end
	EVTButtonFrame:Show();
	EVTButtonDay:SetText(tostring(date("%d")));
end

--set button back to inital values (attached to minimap)
function EVTButton_Reset()
	CalendarOptions["buttonLocked"] = true;
	EVTButton_Init();
end

--releases buttom from control of minimap to be moved anywhere on the screen.
function EVTButton_Unlock()
	DEFAULT_CHAT_FRAME:AddMessage("[EVTCalendar] Frames unlocked.", 0.8, 0.8, 0.1);
	CalendarOptions["buttonLocked"] = false;
	EVTButtonFrame:ClearAllPoints()
	EVTButtonLocked = false;
	EVTButton_SetCenter();
end

--anchors buttom to current position on screen
function EVTButton_Lock()
	DEFAULT_CHAT_FRAME:AddMessage("[EVTCalendar] Frames locked.", 0.8, 0.8, 0.1);
	CalendarOptions["buttonLocked"] = true;
	EVTButtonLocked = true;
end

--checks if button is locked before allow dragging
function EVTButton_StartMoving()
	if EVTButtonLocked == false then
		EVTButtonFrame:StartMoving();
	end
end

--get new position while button is being moving/dragged, or sets to minimap
function EVTButton_UpdatePosition()
	if EVTButtonLocked then
		EVTButtonFrame:SetPoint(
			"TOPLEFT",
			"Minimap",
			"TOPLEFT",
			54 - (82 * cos(EVTButtonPosition)),
			(82 * sin(EVTButtonPosition)) - 55
		);
	else
		EVTButtonFrame:SetPoint(
		"TOPLEFT",
		"UIParent",
		"BOTTOMLEFT",
		EVTButtonX,
		EVTButtonY);
	end
end

--move button to center of the screen
function EVTButton_SetCenter()
	EVTButtonFrame:SetPoint(
		"CENTER",
		"UIParent",
		"CENTER",
		0,
		0);
end

--displays tooltip for clock feature
function EVTButton_OnEnter()
	local plus = "";
	local srvHour, srvMinute, locHour, locMinute, locOffset, srvOffset, locAmpm, srvAmpm = EVT_GetCurrentTime(); --see function for definitions
	if srvOffset > 0 then
		plus = "+"
	end
	if locOffset > 0 then
		plus = "+"
	end
	if not CalendarOptions["milFormat"] then
		srvMinute = (srvMinute..srvAmpm);
		locMinute = (locMinute..locAmpm);
	end
	srvTime = string.format("%s:%s Server", srvHour, srvMinute, plus, srvOffset);
	locTime = string.format("%s:%s Local", locHour, locMinute, plus, locOffset);
	curtime = (locTime .. "\n" .. srvTime);
    GameTooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT");
    GameTooltip:SetText(curtime);
    GameTooltip:Show();
end 

--flash button if pending invite
function EVTButton_StartPulse()
		PlaySoundFile("Sound\\interface\\iTellMessage.wav");
		SetButtonPulse(EVTButton, 100, 1);
		EVTButtonPulsing = true;
end

--clear pulse
function EVTButton_PulseOff()
		ButtonPulse_StopPulse(EVTButton);
		EVTButtonPulsing = false;
	end