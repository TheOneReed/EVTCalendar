table_Months = {EVT_JAN, EVT_FEB, EVT_MAR, EVT_APR, EVT_MAY, EVT_JUN, EVT_JUL, EVT_AUG, EVT_SEP, EVT_OCT, EVT_NOV, EVT_DEC};

table_Dotw = {EVT_SUN, EVT_MON, EVT_TUE, EVT_WED, EVT_THU, EVT_FRI, EVT_SAT};

local epochYear = 2016;
local epochMonth = 1; --whichever month your epoch is
local epochDay = 5; --whichever day your epoch is

function isLeapYear(year)
    local naiveLeap = (mod(year, 4) == 0);
    local centuryClause = (mod(year, 100) ~= 0);
    local centuryClauseException = (mod(year, 400) == 0);
    return naiveLeap and (centuryClause or centuryException);
end

function DaysInMonth(year, month)
    if month == 2 and isLeapYear(year) then
        return 29;
    end
    
    local daysPerMonth = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    return daysPerMonth[month]
end

--[[
implementation found online. see https://en.wikipedia.org/wiki/Determination_of_the_day_of_the_week#Implementation-dependent_methods
works for any year above 1752
--]]
function GetDayofWeek(curY, curM, curD)
    local t = {0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4};
    if curM < 3 then
        curY = curY - 1;
    end
    return mod(curY + floor(curY / 4) + floor(curY / 100) + t[curM] + curD, 7) + 1;
end
