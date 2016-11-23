table_Months = {EVT_JAN, EVT_FEB, EVT_MAR, EVT_APR, EVT_MAY, EVT_JUN, EVT_JUL, EVT_AUG, EVT_SEP, EVT_OCT, EVT_NOV, EVT_DEC};

table_Dotw = {EVT_SUN, EVT_MON, EVT_TUE, EVT_WED, EVT_THU, EVT_FRI, EVT_SAT};

local epochYear = 2016;
local epochMonth = 1; --whichever month your epoch is
local epochDay = 5; --whichever day your epoch is

function currentDay()
    return date("%d") + 0
end

function currentMonth()
    return date("%m") + 0
end

function currentYear()
    return date("%Y") + 0
end

function isLeapYear(year)
    local naiveLeap = (mod(year, 4) == 0);
    local centuryClause = (mod(year, 100) ~= 0);
    local centuryClauseException = (mod(year, 400) == 0);
    return naiveLeap and (centuryClause or centuryException);
end

function DaysInMonth(year, month)
    if ((month == 2) and isLeapYear(year)) then
        return 29;
    end
    
    local daysPerMonth = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    return daysPerMonth[month]
end

--[[
implementation found online. see https://en.wikipedia.org/wiki/Determination_of_the_day_of_the_week#Implementation-dependent_methods
works for any year above 1752
--]]
function GetDayofWeek(year, month, day)
    local t = {0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4};
    if month < 3 then
        year = year - 1;
    end
    return mod(year + floor(year/4) - floor(year/100) + floor(year/400) + t[month] + day, 7) + 1;
end



-----------------Communications Functions------------------

function EVTIncMessage(msgStr, fromWho)
	if fromWho == UnitName("player") then
		DEFAULT_CHAT_FRAME:AddMessage("From Self", 1, 0.1, 1);
	end

	local s1, s2, s3, s4 = strSplit(msgStr, "¿");
	
	if (((s3 == 1) and player_Info["officer"]) or (s3 == 0)) and (s1 == UnitName("player") or s1 == "All ") then
		DEFAULT_CHAT_FRAME:AddMessage(s1, 1, 0.1, 1);
		DEFAULT_CHAT_FRAME:AddMessage(s2, 1, 0.1, 1);
		DEFAULT_CHAT_FRAME:AddMessage(s3, 1, 0.1, 1);
		DEFAULT_CHAT_FRAME:AddMessage(s4, 1, 0.1, 1);
		StringToTable(s4);
	else 
		DEFAULT_CHAT_FRAME:AddMessage("Not for you!", 1, 0.1, 1);
	end
end


------- Helper Functions----------
function TableIndexExists(t, i)
	for index,value in pairs(t) do 
		if (index == i) then
			return true;
		end
	end
	return false;
end

function TableFindDupe(t, i)
	local n = table.getn(t);
	for x = 1, n do 
		getName = t[x][1];
		if ( getName == i) then
			return true;
		end
	end
	return false;
end

function strSplit(msgStr, c)
	local table_str = {};
	local capture = string.format("(.-)%s", c);
	
	for v in string.gfind(msgStr, capture) do
		table.insert(table_str, v);
	end
	
	return unpack(table_str);
end

function TableToString(t, lock)
	strTable = string.format("%s¡%s¡%s¡%s¡%s¡%s¡%s¡%s¡%s¡%s¡%s¡%s¡", t[1], t[2], t[3], t[4], t[5], t[6], t[7], t[8], t[9], t[10], lock, createDate);
	return strTable;
end

function StringToTable(str)
	local s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12 = strSplit(str, "¡");
	local t = CalendarData;
	if TableIndexExists(t, s12) == false then
		t[s12] = {};
	end
	if TableFindDupe(t[s12], s1) == false then
		table.insert( t[s12], {s1, s2, tonumber(s3), tonumber(s4), tonumber(s5), tonumber(s6), tonumber(s7), tonumber(s8), tonumber(s9), s10, tonumber(s11)});
		EVT_UpdateCalendar();
	else
		DEFAULT_CHAT_FRAME:AddMessage("Duplicate Exists!", 1, 0.1, 1);
	end
end

function checkIllegal(str)
	str = string.gsub(str, "¿", "?");
	str = string.gsub(str, "¡", "!");
	return str;
end







