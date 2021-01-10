CharsToTrack = {"Rincey", "Aesina", "Erwyna", "Banthi"};
DangerDist = 50;
AddonEnabled = true;

function VadrinTrackOnLoad(self)
	SlashCmdList["VadrinTrack"] = SetAddonStatus;
	SLASH_VadrinTrack1 = "/VadrinTrack";
	SLASH_VadrinTrack2 = "/vadrintrack";
	print("|cffff2233VadrinTrack loaded.");
end

local e=0;
local prevway=0;
local gr,gg,gb = unpack(TomTom.db.profile.arrow.goodcolor);
local mr,mg,mb = unpack(TomTom.db.profile.arrow.middlecolor);
local br,bg,bb = unpack(TomTom.db.profile.arrow.badcolor);
local ID = "";
local nowtracking = "";
	
function VadrinTrackOnUpdate(self, elapsed)
	e = e + elapsed;
	for i,v in ipairs(CharsToTrack) do
		ID = GetID(CharsToTrack[i]);
		if (ID~="") then
			nowtracking = CharsToTrack[i];
			break;
		end
	end
	if (AddonEnabled and IsAddOnLoaded('TomTom') and (ID~="") and (e>=0.3)) then
		e=0;
		if(prevway~=0) then TomTom:RemoveWaypoint(prevway) end
		local posX, posY = GetPlayerMapPosition(ID);
		local m, f, x, y = TomTom:GetCurrentPlayerPosition();
		if((m~=null) and (f~=null) and (posX~=null) and (posY~=null))then
			prevway = TomTom:AddMFWaypoint(m, f, posX, posY, {title = nowtracking,});
			local dist1,x1,y1 = TomTom:GetDistanceToWaypoint(prevway);
			local r,g,b = ColorGradient(math.abs((DangerDist - dist1) / DangerDist), br, bg, bb, mr, mg, mb, gr, gg, gb);
			if(dist1>DangerDist) then r=1;g=0;b=0; end
			TomTom:HijackCrazyArrow(function(self, elapsed)
			if ((TomTom:GetDirectionToWaypoint(prevway)~=null) and (GetPlayerFacing()~=null)) then TomTom:SetCrazyArrowDirection(TomTom:GetDirectionToWaypoint(prevway)-GetPlayerFacing()) end
			TomTom:SetCrazyArrowColor(r, g, b)
			TomTom:SetCrazyArrowTitle(nowtracking, math.ceil(dist1).." Yards", "")end)
		else
			if TomTom:CrazyArrowIsHijacked() then
			TomTom:ReleaseCrazyArrow();
			end
			if(prevway~=0) then TomTom:RemoveWaypoint(prevway) end		
		end
	end
	if (ID=="") then
		if TomTom:CrazyArrowIsHijacked() then
		TomTom:ReleaseCrazyArrow();
		end
		if(prevway~=0) then TomTom:RemoveWaypoint(prevway) end
	end
end

function GetID(name)
	for var1=1,5,1 do
		if (name==GetUnitName("party"..var1)) then return "party"..var1; end
	end
	for var2=1,40,1 do
		if (name==GetUnitName("raid"..var2)) then return "raid"..var2; end
	end
	return "";
end

function ColorGradient(perc, ...)
	local num = select("#", ...)
	local hexes = type(select(1, ...)) == "string"

	if perc == 1 then
		return select(num-2, ...), select(num-1, ...), select(num, ...)
	end

	num = num / 3

	local segment, relperc = math.modf(perc*(num-1))
	local r1, g1, b1, r2, g2, b2
	r1, g1, b1 = select((segment*3)+1, ...), select((segment*3)+2, ...), select((segment*3)+3, ...)
	r2, g2, b2 = select((segment*3)+4, ...), select((segment*3)+5, ...), select((segment*3)+6, ...)

	if not r2 or not g2 or not b2 then
		return r1, g1, b1
	else
		return r1 + (r2-r1)*relperc,
		g1 + (g2-g1)*relperc,
		b1 + (b2-b1)*relperc
	end
end

function SetAddonStatus(msg)
	if (msg=="off" or msg=="Off" or msg=="OFF") then
		AddonEnabled = false;
		print("|cffff2233VadrinTrack is turned OFF.");
	elseif (msg=="on" or msg=="On" or msg=="ON") then
		AddonEnabled = true;
		print("|cffff2233VadrinTrack is turned ON.");
	else
		print("|cffff2233Invalid Input.");
	end
end