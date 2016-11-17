table_Months = {
    [1] = EVT_JAN;
    [2] = EVT_FEB;
    [3] = EVT_MAR;
    [4] = EVT_APR;
    [5] = EVT_MAY;
    [6] = EVT_JUN;
    [7] = EVT_JUL;
    [8] = EVT_AUG;
    [9] = EVT_SEP;
    [10] = EVT_OCT;
    [11] = EVT_NOV;
    [12] = EVT_DEC;
};

table_Dotw = {
    [1] = EVT_SUN;
    [2] = EVT_MON;
    [3] = EVT_TUE;
    [4] = EVT_WED;
    [5] = EVT_THU;
    [6] = EVT_FRI;
    [7] = EVT_SAT;
};

month = nil;
day = nil;
year = nil;
dotw = nil;

local epochYear = 2016;
local epochMonth = 1; --whichever month your epoch is
local epochDay = 5; --whichever day your epoch is

function isLeapYear(year)
    local naiveLeap = (mod(year, 4) == 0);
    local centuryClause = (mod(year, 100) ~= 0);
    local centuryException = (mod(year, 400) == 0);
    local smartLeap = naiveLeap and (centuryClause or centuryException);
    return smartLeap;
end

function DaysInYear(year)
    if isLeapYear(year) then
        return 366;
    end
    return 365;
end

function DaysInMonth(year, month)
    local daysPerMonth = {
        [1] = 31;
        [2] = 28;
        [3] = 31;
        [4] = 30;
        [5] = 31;
        [6] = 30;
        [7] = 31;
        [8] = 31;
        [9] = 30;
        [10] = 31;
        [11] = 30;
        [12] = 31;
        ["leap"] = 29;
    };
    
    local isFeb = (month == 2);
    if (isFeb and isLeapYear(year)) then
        return daysPerMonth["leap"]
    end
    return daysPerMonth[month]
end

function DaysFromEpoch(toYear, toMonth, toDay)
    local count = 0;
	if epochYear <= toYear then
		for i = epochYear, (toYear - 1), 1 do
			count = count + DaysInYear(i);
		end
		for i = 1, (toMonth - 1) do
			count = count + DaysInMonth(toYear, i);
		end
		count = count + toDay;
	else
		for i = (epochYear - 1), toYear, -1 do
			count = count + DaysInYear(i);
		end
		for i = 1, (toMonth - 1) do
			count = count - DaysInMonth(toYear, i);
		end
		count = count - toDay;
	end
    return count;
end

function GetDayofWeek(curY, curM, curD)
	local dayInWeek;
	if epochYear <= curY then
		dayInWeek = mod((DaysFromEpoch(curY, curM, curD)), 7) + epochDay;
		if (dayInWeek > 7) then
			dayInWeek = dayInWeek - 7;
		end
	else
		dayInWeek = epochDay - mod((DaysFromEpoch(curY, curM, curD)), 7)
		if (dayInWeek < 1) then
			dayInWeek = dayInWeek + 7;
		end
	end
	return dayInWeek;
end
