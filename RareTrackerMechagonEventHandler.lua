local _, data = ...

local RTM = data.RTM;

-- ####################################################################
-- ##                         Event Handlers                         ##
-- ####################################################################

-- Listen to a given set of events and handle them accordingly.
function RTM:OnEvent(event, ...)
	if event == "PLAYER_TARGET_CHANGED" then
		RTM:OnTargetChanged(...)
	elseif event == "UNIT_HEALTH" then
		RTM:OnUnitHealth(...)
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		RTM:OnCombatLogEvent(...)
	elseif event == "ZONE_CHANGED_NEW_AREA" or event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED" then
		RTM:OnZoneTransition()
	elseif event == "CHAT_MSG_CHANNEL" then
		RTM:OnChatMsgChannel(...)
	elseif event == "CHAT_MSG_ADDON" then
		RTM:OnChatMsgAddon(...)
	elseif event == "CHAT_MSG_CHANNEL_LEAVE" then
		RTM:OnChatMsgChannelLeave(...)
	end
end

function RTM:ChangeShard(new_zone_uid, old_zone_uid)
	-- Notify the users in your old shard that you have moved on to another shard.
	RTM:RegisterDeparture(old_zone_uid)
	
	-- Reset all the data we have, since it has all become useless.
	RTM.is_alive = {}
	RTM.current_health = {}
	RTM.last_recorded_death = {}
	RTM.recorded_entity_death_ids = {}
	
	-- Announce your arrival in the new shard.
	RTM:RegisterArrival(new_zone_uid)
end

function RTM:CheckForShardChange(zone_uid)
	if RTM.current_shard_id ~= zone_uid and zone_uid ~= nil then
		print("Changing from shard", RTM.current_shard_id, "to", zone_uid..".")
		
		if RTM.current_shard_id == nil then
			-- Register yourRTM for the given shard.
			RTM:RegisterArrival(zone_uid)
		else
			-- Move from one shard to another.
			RTM:ChangeShard(RTM.current_shard_id, zone_uid)
		end
		
		RTM.current_shard_id = zone_uid
	end
end

function RTM:OnTargetChanged(...)
	if UnitGUID("target") ~= nil then
		-- Get information about the target.
		local guid, name = UnitGUID("target"), UnitName("target")
		local unittype, zero, server_id, instance_id, zone_uid, npc_id, spawn_uid = strsplit("-", guid);
		npc_id = tonumber(npc_id)
		
		RTM:CheckForShardChange(zone_uid)
		
		if RTM.rare_ids_set[npc_id] then
			-- Find the health of the entity.
			local health = UnitHealth("target")
			
			if health > 0 then
				local percentage = RTM:GetTargetHealthPercentage()
				
				RTM.is_alive[npc_id] = true
				RTM.current_health[npc_id] = percentage
				RTM:UpdateStatus(npc_id)
				
				RTM:RegisterEntityHealth(RTM.current_shard_id, npc_id, percentage)
			else 
				if RTM.recorded_entity_death_ids[spawn_uid] == nil then
					RTM.recorded_entity_death_ids[spawn_uid] = true
					RTM:RegisterEntityDeath(RTM.current_shard_id, npc_id)
				end
			end
		end
	end
end

function RTM:OnUnitHealth(unit)
	-- If the unit is not the target, skip.
	if unit ~= "target" then 
		return 
	end
	
	if UnitGUID("target") ~= nil then
		-- Get information about the target.
		local guid, name = UnitGUID("target"), UnitName("target")
		local unittype, zero, server_id, instance_id, zone_uid, npc_id, spawn_uid = strsplit("-", guid);
		npc_id = tonumber(npc_id)
		
		RTM:CheckForShardChange(zone_uid)
		
		if RTM.rare_ids_set[npc_id] then
			-- Update the current health of the entity.
			local percentage = RTM:GetTargetHealthPercentage()
			
			RTM.is_alive[npc_id] = true
			RTM.current_health[npc_id] = percentage
			RTM:UpdateStatus(npc_id)
			
			RTM:RegisterEntityHealth(RTM.current_shard_id, npc_id, percentage)
		end
	end
end

function RTM:OnCombatLogEvent(...)
	-- The event itRTM does not have a payload (8.0 change). Use CombatLogGetCurrentEventInfo() instead.
	local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()
	local unittype, zero, server_id, instance_id, zone_uid, npc_id, spawn_uid = strsplit("-", destGUID);
	npc_id = tonumber(npc_id)
		
	if subevent == "UNIT_DIED" then
		if RTM.rare_ids_set[npc_id] then
		
			RTM:CheckForShardChange(zone_uid)

			if RTM.recorded_entity_death_ids[spawn_uid] == nil then
				RTM.recorded_entity_death_ids[spawn_uid] = true
				RTM:RegisterEntityDeath(RTM.current_shard_id, npc_id)
			end
		end
	end
end	

RTM.last_zone_id = nil

function RTM:OnZoneTransition()
	-- The zone the player is in.
	local zone_id = C_Map.GetBestMapForUnit("player")
	--print("Entering zone", zone_id)
	
	-- 
	
		
	if (zone_id == 1462 or zone_id == 37) and not (RTM.last_zone_id == 1462 or RTM.last_zone_id == 37) then
		-- Enable the Mechagon rares.
		print("Enabling addon", zone_id)
		RTM:StartInterface()
	elseif (RTM.last_zone_id == 1462 or RTM.last_zone_id == 37) and not (zone_id == 1462 or zone_id == 37) then
		-- Disable the addon.
		print("Disabling addon", zone_id)
		
		-- If we do not have a shard ID, we are not subscribed to one of the channels.
		if RTM.current_shard_id ~= nil then
			RTM:RegisterDeparture(RTM.current_shard_id)
		end
		
		RTM:CloseInterface()
	end
	
	RTM.last_zone_id = zone_id
end	

function RTM:OnChatMsgChannel(...)
	local text, playerName, languageName, channelName, playerName2, specialFlags, zoneChannelID, channelIndex, channelBaseName, unused, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidIcons = ...
	
	--print(text)
end	

function RTM:OnChatMsgAddon(...)
	local addon_prefix, message, channel, sender = ...
	
	if addon_prefix == "RTM" then
		local header, payload = strsplit(":", message)
		local prefix, shard_id = strsplit("-", header)

		RTM:OnChatMessageReceived(sender, prefix, shard_id, payload)
	end
end	

function RTM:OnChatMsgChannelLeave(...)
	--local text, playerName, languageName, channelName, playerName2, specialFlags, zoneChannelID, channelIndex, channelBaseName, unused, lineID, guid, bnSenderID, isMobile, isSubtitle, hideSenderInLetterbox, supressRaidIcons = ...
	
	local player, channel = select(2, ...), select(9, ...)
	
	if channel == "RTM" then
		print("Player", player, "has left the channel")
		RTM:AcknowledgeDeparture(player)
	end
end	

RTM.last_display_update = 0

function RTM:OnUpdate()
	if (RTM.last_display_update + 0.25 < time()) then
		for i=1, #RTM.rare_ids do
			local npc_id = RTM.rare_ids[i]
			
			RTM:UpdateStatus(npc_id)
		end
		
		RTM.last_display_update = time();
	end
end	

function RTM:RegisterEvents()
	RTM:RegisterEvent("PLAYER_TARGET_CHANGED")
	RTM:RegisterEvent("UNIT_HEALTH")
	RTM:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	RTM:RegisterEvent("CHAT_MSG_CHANNEL")
	RTM:RegisterEvent("CHAT_MSG_ADDON")
	RTM:RegisterEvent("CHAT_MSG_CHANNEL_LEAVE")
end

function RTM:UnregisterEvents()
	RTM:UnregisterEvent("PLAYER_TARGET_CHANGED")
	RTM:UnregisterEvent("UNIT_HEALTH")
	RTM:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	RTM:UnregisterEvent("CHAT_MSG_CHANNEL")
	RTM:UnregisterEvent("CHAT_MSG_ADDON")
	RTM:UnregisterEvent("CHAT_MSG_CHANNEL_LEAVE")
end

RTM.updateHandler = CreateFrame("Frame", "RTM.updateHandler", RTM)
RTM.updateHandler:SetScript("OnUpdate", RTM.OnUpdate)

-- Register the event handling of the frame.
RTM:SetScript("OnEvent", RTM.OnEvent)
RTM:RegisterEvent("ZONE_CHANGED_NEW_AREA")
RTM:RegisterEvent("ZONE_CHANGED")
RTM:RegisterEvent("PLAYER_ENTERING_WORLD")