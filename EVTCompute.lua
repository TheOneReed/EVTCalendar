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

daysPerMonth = {
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
	["Leap"] = 29;
	};


month = nil;
day = nil;
year = nil;
dotw = nil;
	
local startDotw = 6;
local startDay = 1;
local startMonth = 1;
local startYear = "2016";

function DaysBeforeMonth(month, year)
	local count = 0;
	for month = (month - 1), 1, -1 do
		if ((month == 2) and isLeapYear(year)) then
			y = "Leap";
		else
			y = month;
		end
		count = count + daysPerMonth[y];
	end
	return count;
end

function DaysAfterMonth(month, year)
	local count = 0;
	for month = (month + 1), 12, 1 do
		if ((month == 2) and isLeapYear(year)) then
			y = "Leap";
		else
			y = month;
		end
		count = count + daysPerMonth[y];
	end
	return count;
end

function DaysInYear(year)
    if isLeapYear(year) then
        return 366;
    else
		return 365;
	end
end

function isLeapYear(year)
    local naiveLeap = (mod(year, 4) == 0);
    local centuryClause = (mod(year, 100) ~= 0);
    local centuryException = (mod(year, 400) == 0);
    local smartLeap = naiveLeap and (centuryClause or centuryException);
    return smartLeap;
end

function GetDayofWeek(curY, curM, curD)
	local dayCount = curD - 1;
	local tempYear = curY;
	local tempMonth = curM;
	local dotwOffset = startDotw;

	local yearsToGo = tempYear - startYear;

	if yearsToGo >= 0 then
		dayCount = dayCount + DaysBeforeMonth(tempMonth, tempYear);
		for x = yearsToGo, 1, -1 do
			dayCount = dayCount + DaysInYear(tempYear - 1);
			tempYear = tempYear - 1;
		end
--		dayCount = dayCount - 1;
		dayOffset = mod(dayCount, 7);
		for x = 1, dayOffset, 1 do
			dotwOffset = dotwOffset + 1;
			if (dotwOffset > 7) then
				dotwOffset = 1;
			end
		end
	else
		dayCount = daysPerMonth[tempMonth] - dayCount;
		dayCount = dayCount + DaysAfterMonth(tempMonth, tempYear); 
		for x = yearsToGo, -2, 1 do
			tempYear = tempYear + 1;
			dayCount = dayCount + DaysInYear(tempYear);
		end
--		dayCount = dayCount - 1;
		dayOffset = mod(dayCount, 7);
		for x = 1, dayOffset, 1 do
			dotwOffset = dotwOffset - 1;
			if (dotwOffset < 1) then
				dotwOffset = 7;
			end
		end
    end	
	return dotwOffset;
end

--[[
epochYear = 2016;
epochMonth = 1; --whichever month your epoch is
epochDay = 1; --whichever day your epoch is

function DaysInYear(year)
    if isLeapYear(year) then
        return 366;
    end
    return 365;
end

function DaysInMonth(year, month)
    local isFeb = (month == 2);
    if (isFeb and isLeapYear(year)) then
        return daysPerMonth["Leap"]
    end
    return daysPerMonth[month]
end

function DaysFromEpoch(year, month, day)
    local count = 0;
    for i = epochYear, (year - 1) do
        count = count + DaysInYear(i);
    end
    for i = 1, (month - 1) do
        count = count + DaysInMonth(year, i );
    end
    count = count + day;
	return count;
end

function GetDayofWeek(curY, curM, curD)
    return mod((DaysFromEpoch(curY, curM, curD) + epochDay), 7);
end--]]
