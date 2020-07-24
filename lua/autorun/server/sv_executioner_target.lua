-- select Targets
brokeContract = false

local function GetTargets(ply)
	local targets = {}
	local detes = {}
	local spies = {}

	if not IsValid(ply) or not ply:IsActive() or not ply:Alive() or ply.IsGhost and ply:IsGhost() or ply:GetSubRole() ~= ROLE_EXECUTIONER then
		return targets
	end

	for _, pl in ipairs(player.GetAll()) do
		if pl:Alive() and pl:IsActive() and not pl:IsInTeam(ply) and (not pl.IsGhost or not pl:IsGhost()) and (not JESTER or not pl:IsRole(ROLE_JESTER) or pl:GetSubRole() == ROLE_SPY or ply:GetTeam() == pl:GetTeam()) then
			if pl:IsRole(ROLE_DETECTIVE) or pl:GetSubRole() == ROLE_SPY then
				detes[#detes + 1] = pl
			else
				targets[#targets + 1] = pl
			end
		end
	end

	if #targets < 1 then
		if #detes < 1 then
			detes = spies
		end
		targets = detes
	end

	return targets
end

local function SelectNewTarget(ply)
	local targets = GetTargets(ply)

	if #targets > 0 and not brokeContract then
		ply:SetTargetPlayer(targets[math.random(1, #targets)])
	else
		ply:SetTargetPlayer(nil)
	end
	local tgt = ply:GetTargetPlayer()
	if tgt then
		print(ply:Nick().."'s target is '"..tgt:Nick())
	else
		print("No Target")
	end
end

local function ExecutionerTargetChanged(ply, _, attacker)
	ply.targetAttacker = nil

	if GetRoundState() == ROUND_ACTIVE and IsValid(attacker) and attacker:IsPlayer() and (not attacker.IsGhost or not attacker:IsGhost()) then
		ply.targetAttacker = attacker
	end
end
hook.Add("TTT2PostPlayerDeath", "ExecutionerTargetChanged", ExecutionerTargetChanged)

local function ExecutionerTargetDied(ply, _, attacker)
	if not attacker then attacker = ply.targetAttacker end
	local punishment_delay = GetConVar("ttt2_executioner_punishment_time"):GetInt()

	if IsValid(attacker) and attacker:GetSubRole() == ROLE_EXECUTIONER and (not attacker.IsGhost or not attacker:IsGhost()) and attacker:GetTargetPlayer() then
		if attacker:GetTargetPlayer() == ply then -- if attacker's target is the dead player
			LANG.Msg(attacker, "ttt2_executioner_target_killed", nil, MSG_MSTACK_ROLE)
			SelectNewTarget(attacker)
			-- end
		else
			if GetConVar("ttt2_executioner_punishment_time"):GetInt() > 0 then
				LANG.Msg(attacker, "ttt2_executioner_target_killed_wrong", {punishtime = punishment_delay}, MSG_MSTACK_ROLE)
				ply:SetTargetPlayer(nil)
				brokeContract = true
				SelectNewTarget(attacker)
				hook.Run("TTT2PunishExecutioner", attacker)
			else
				SelectNewTarget(attacker)
			end
			ply:SetTargetPlayer(nil)
			brokeContract = true
			SelectNewTarget(attacker)
			hook.Run("TTT2PunishExecutioner", attacker)

		end
	end
	for _, pl in ipairs(player.GetAll()) do
		local target = pl:GetTargetPlayer()

		if (not IsValid(attacker) or pl ~= attacker) and (not pl.IsGhost or not pl:IsGhost()) and target == ply and pl:GetSubRole() == ROLE_EXECUTIONER and not brokeContract then
			LANG.Msg(pl, "ttt2_executioner_target_died", nil, MSG_MSTACK_PLAIN)
			SelectNewTarget(pl)
			--SelectNewTarget(pl)
		end
	end
end
hook.Add("TTT2PostPlayerDeath", "ExecutionerTargetDied", ExecutionerTargetDied)

local function ExecutionerTargetSpawned(ply)
	if GetRoundState() == ROUND_ACTIVE then
		for _, v in ipairs(player.GetAll()) do
			local target = v:GetTargetPlayer()

			if ply ~= v and v:IsActive() and v:Alive() and v:GetSubRole() == ROLE_EXECUTIONER and (not IsValid(target) or not target:Alive() or not target:IsActive()) then
				SelectNewTarget(v)
			end
		end

		local target = ply:GetTargetPlayer()

		if ply:GetSubRole() == ROLE_EXECUTIONER and (not IsValid(target) or not target:Alive() or not target:IsActive()) then
			SelectNewTarget(ply)
		end
	end
end
hook.Add("PlayerSpawn", "ExecutionerTargetSpawned", ExecutionerTargetSpawned)

local function ExecutionerTargetDisconnected(ply)
	for _, v in ipairs(player.GetAll()) do
		if v:GetSubRole() == ROLE_EXECUTIONER and v:GetTargetPlayer() == ply then
			SelectNewTarget(v)
		end
	end
end
hook.Add("PlayerDisconnected", "ExecutionerTargetDisconnected", ExecutionerTargetDisconnected)

local function ExecutionerTargetRoleChanged(ply, old, new)
	if new == ROLE_EXECUTIONER then
		brokeContract = false
		SelectNewTarget(ply)
	elseif old == ROLE_EXECUTIONER then
		ply:SetTargetPlayer(nil)
	end

	if GetRoundState() == ROUND_ACTIVE then
		for _, v in ipairs(player.GetAll()) do
			if v:GetSubRole() == ROLE_EXECUTIONER and v:GetTargetPlayer() == ply and v:IsInTeam(ply) then
				SelectNewTarget(v)
			end
		end
	end
end
hook.Add("TTT2UpdateSubrole", "ExecutionerTargetRoleChanged", ExecutionerTargetRoleChanged)

local function ExecutionerGotSelected()
	for _, ply in ipairs(player.GetAll()) do
		if ply:GetSubRole() == ROLE_EXECUTIONER then
			brokeContract = false
			SelectNewTarget(ply)
		end
	end
end
hook.Add("TTTBeginRound", "ExecutionerGotSelected", ExecutionerGotSelected)

local function ExecutionerTargetHit(ply, dmginfo)
	if not ply:IsPlayer() then return end

	if not ply or not IsValid(ply) or not ply:IsPlayer() then return end

	local attacker = dmginfo:GetAttacker()

	if not attacker or not IsValid(attacker) or not attacker:IsPlayer() or attacker:GetSubRole() ~= ROLE_EXECUTIONER then return end

	local damage_multiplier = GetConVar("ttt2_executioner_target_multiplier"):GetFloat()
	local damage_divisor = GetConVar("ttt2_executioner_non_target_multiplier"):GetFloat()

	if ply == attacker:GetTargetPlayer() and attacker:GetSubRole() == ROLE_EXECUTIONER then
		dmginfo:ScaleDamage(damage_multiplier)
	elseif ply ~= attacker:GetTargetPlayer() and attacker:GetSubRole() == ROLE_EXECUTIONER and ply:AccountID() ~= attacker:AccountID() then
		dmginfo:ScaleDamage(damage_divisor)
	end
end
hook.Add("EntityTakeDamage", "TTT2ExecutionerDamageScaling", ExecutionerTargetHit)

function PrintTarget(ply)
	for _, ply in ipairs(player.GetAll()) do
		if ply:GetSubRole() == ROLE_EXECUTIONER then
			print(ply:GetTargetPlayer())
		end
	end
end

-- hook.Add("EntityTakeDamage", "TTT2ExcDamageScale", function ( ply, dmginfo )
-- 	if not ply:IsPlayer() then return end
--
-- 	if not ply or not IsValid(ply) or not ply:IsPlayer() then return end
--
-- 	local attacker = dmginfo:GetAttacker()
--
-- 	if not attacker or not IsValid(attacker) or not attacker:IsPlayer() or not attacker:GetSubRole() == ROLE_EXECUTIONER then return end
--
-- 	if ply == attacker:GetTargetPlayer() then
-- 		dmginfo:ScaleDamage(2)
-- 	elseif ply ~= attacker:GetTargetPlayer() then
-- 		dmginfo:ScaleDamage(0.5)
-- 	end
-- end )

function RepairContract(ply)
	brokeContract = false
	SelectNewTarget(ply)
end

function ExecutionerPunishment(ply)
	timer.Create("ExecutionerPunishment", GetConVar("ttt2_executioner_punishment_time"):GetInt(), 0, function()
		if brokeContract then
			RepairContract(ply)
		end
	end)
end

hook.Add("TTT2PunishExecutioner", "Punishment", ExecutionerPunishment)

concommand.Add("ttt2_print_exc_target", PrintTarget)
