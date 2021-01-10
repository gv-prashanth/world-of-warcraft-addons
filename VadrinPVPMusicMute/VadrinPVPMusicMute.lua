local frame = CreateFrame("FRAME", "VadrinPVPMusicMuteFrame");
frame:RegisterEvent("ZONE_CHANGED_NEW_AREA");
local Player_in_bg_arena=false;
local function eventHandler(self, event, ...)
	for i = 1, GetMaxBattlefieldID() do
		if (GetBattlefieldStatus(i) == "active") then
			Player_in_bg_arena=true;
			break;
		else
			Player_in_bg_arena=false;
		end
	end
	local Music_Old = GetCVar("Sound_EnableMusic");
	if(Player_in_bg_arena and (Music_Old == "1")) then
		print("|cffC9A61B Muting Game Music");
		SetCVar("Sound_EnableMusic",0);
	end
	if((not Player_in_bg_arena) and (Music_Old == "0")) then
		print("|cffC9A61B Unmuting Game Music");
		SetCVar("Sound_EnableMusic",1);
	end
end
frame:SetScript("OnEvent", eventHandler);