local EVTButtonPosition = nil;
local EVTButtonPulsing = false;

function EVTButton_OnClick()
	if EVTButtonPulsing then
		EVT_ShowNextInvite();
	else
		EVT_Toggle();
	end
end

function EVTButton_Init()
    EVTButtonPosition = 134.66365694988;
	EVTButton_UpdatePosition();
	EVTButtonFrame:Show();
	EVTButtonDay:SetText(tostring(date("%d")));
end

function EVTButton_UpdatePosition()
	EVTButtonFrame:SetPoint(
		"TOPLEFT",
		"Minimap",
		"TOPLEFT",
		54 - (82 * cos(EVTButtonPosition)),
		(82 * sin(EVTButtonPosition)) - 55
	);
end

function EVTButton_BeingDragged()
    local xpos,ypos = GetCursorPosition() 
    local xmin,ymin = Minimap:GetLeft(), Minimap:GetBottom() 

    xpos = xmin-xpos/UIParent:GetScale()+70 
    ypos = ypos/UIParent:GetScale()-ymin-70 

    EVTButton_SetPosition(math.deg(math.atan2(ypos,xpos)));
end

function EVTButton_SetPosition(v)
    if(v < 0) then
        v = v + 360;
    end

    EVTButtonPosition = v;
    EVTButton_UpdatePosition();
end

function EVTButton_OnEnter()
	curtime = EVT_GetCurrentTime()
	
    GameTooltip:SetOwner(this, "ANCHOR_BOTTOMLEFT");
    GameTooltip:SetText(curtime);
    GameTooltip:Show();
end 

function EVTButton_TogglePulse()
	if EVTButtonPulsing == false then
		PlaySoundFile("Sound\\interface\\iTellMessage.wav");
		SetButtonPulse(EVTButton, 100, 1);
		EVTButtonPulsing = true;
	else
		EVTButton_PulseOff();
	end
end

function EVTButton_PulseOff()
		ButtonPulse_StopPulse(EVTButton);
		EVTButtonPulsing = false;
	end