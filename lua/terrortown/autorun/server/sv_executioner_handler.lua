util.AddNetworkString("ttt2_exe_broke_contract")

local function GetTargets(ply)
  local targets = {}
  local dets = {}
  local others = {}

  if not IsValid(ply) or not ply:IsActive() or not ply:Alive() or (ply.IsGhost and ply:IsGhost()) or ply:GetSubRole() ~= ROLE_EXECUTIONER then
    return targets
  end

  local plys = util.GetAlivePlayers()

  for i = 1, #plys do
    local pl = plys[i]
    if pl:IsInTeam(ply) then continue end
    if pl.IsGhost and pl:IsGhost() then continue end
    if JESTER and pl:GetSubRole() == ROLE_JESTER then continue end
    if MEDIC and pl:GetSubRole() == ROLE_MEDIC then continue end
    if pl:GetBaseRole() == ROLE_DETECTIVE then
      dets[#dets + 1] = pl
    elseif SPY and pl:GetSubRole() == ROLE_SPY then
      others[#others + 1] = pl
    else
      targets[#targets + 1] = pl
    end
  end

  if #targets < 1 then
    if #dets < 1 then
      dets = others
    end
    targets = dets
  end
  return targets
end

local function NewTarget(ply)
  local targets = GetTargets(ply)

  if #targets > 0 and not ply.brokeContract then
    local target_ply = targets[math.random(#targets)]
    target_ply.huntedBy = ply:SteamID()
    ply:SetTargetPlayer(target_ply)
  else
    ply:SetTargetPlayer(nil)
  end
end

local function ExecutionerTargetDied(ply, _, attacker)
  if not IsValid(ply) then return end
  if IsValid(attacker) and attacker:IsPlayer() and attacker:GetSubRole() == ROLE_EXECUTIONER then return end
  local plys = util.GetAlivePlayers()
  for i = 1, #plys do
    local pl = plys[i]
    if pl:GetSubRole() == ROLE_EXECUTIONER and pl:GetTargetPlayer() == ply then
      NewTarget(pl)
    end
  end
end
hook.Add("TTT2PostPlayerDeath", "ExecutionerTargetDied", ExecutionerTargetDied)

local function ExecutionerKilledTarget(ply, _, attacker)
  if not IsValid(ply) or not IsValid(attacker) then return end
  if not attacker:IsPlayer() or not attacker:Alive() then return end

  if attacker:GetSubRole() ~= ROLE_EXECUTIONER then return end
  if attacker.IsGhost and attacker:IsGhost() then return end
  if not attacker:GetTargetPlayer() then return end

  local punishment = GetConVar("ttt2_executioner_punishment_time"):GetInt()

  if attacker:GetTargetPlayer() == ply then
    LANG.Msg(attacker, "ttt2_executioner_target_killed", nil, MSG_MSTACK_ROLE)
    NewTarget(attacker)
  else
    if punishment > 0 then
      LANG.Msg(attacker, "ttt2_executioner_target_killed_wrong", {punishtime = punishment}, MSG_MSTACK_ROLE)
      attacker:SetTargetPlayer(nil)
      attacker.brokeContract = true
      print("[TTT2 EXECUTIONER] " .. attacker:Nick() .. "'s Punishment Time: " .. punishment)
      net.Start("ttt2_exe_broke_contract")
      net.WriteInt(punishment, 32)
      net.Send(attacker)
      timer.Simple(punishment, function()
        attacker.brokeContract = nil
        NewTarget(attacker)
      end)
    else
      NewTarget(attacker)
    end
  end
end
hook.Add("TTT2PostPlayerDeath", "ExecutionerKilledTarget", ExecutionerKilledTarget)

local function ExecutionerTargetSpawned(ply)
  if GetRoundState() ~= ROUND_ACTIVE then return end
  if ply:GetSubRole() ~= ROLE_EXECUTIONER then return end
  local plys = util.GetAlivePlayers()
  for i = 1, #plys do
    local pl = plys[i]
    local target = pl:GetTargetPlayer()

    if pl == target or not IsValid(target) or target:Alive() or target:IsActive() then return end
    NewTarget(ply)
  end
  local target = ply:GetTargetPlayer()
  if not IsValid(target) or not target:Alive() or not target:IsActive() then
    NewTarget(ply)
  end
end
hook.Add("PlayerSpawn", "ExecutionerTargetSpawned", ExecutionerTargetSpawned)

local function ExecutionerTargetDisconnected(ply)
  local plys = player.GetAll()
  for i = 1, #plys do
    local pl = plys[i]
    if pl:GetSubRole() == ROLE_EXECUTIONER and pl:GetTargetPlayer() == ply then
      NewTarget(pl)
    end
  end
end
hook.Add("PlayerDisconnected", "ExecutionerTargetDisconnected", ExecutionerTargetDisconnected)

local function ExecutionerTargetRoleChanged(ply, old, new)
  if new == ROLE_EXECUTIONER then
    ply.brokeContract = nil
    NewTarget(ply)
  elseif old == ROLE_EXECUTIONER then
    ply:SetTargetPlayer(nil)
  end

  if GetRoundState() == ROUND_ACTIVE then
    local plys = player.GetAll()
    for i = 1, #plys do
      local pl = plys[i]
      if pl:GetSubRole() == ROLE_EXECUTIONER and pl:GetTargetPlayer() == ply and pl:IsInTeam(ply) then
        NewTarget(pl)
      end
    end
  end
end
hook.Add("TTT2UpdateSubrole", "ExecutionerTargetRoleChanged", ExecutionerTargetRoleChanged)

local function ExecutionerTargetBaseRoleChange(ply, old, new)
  if new ~= ROLE_DETECTIVE then return end

  local plys = player.GetAll()
  for i = 1, #plys do
    local pl = plys[i]
    if pl:GetSubRole() == ROLE_EXECUTIONER and pl:GetTargetPlayer() == ply then
      NewTarget(pl)
    end
  end
end
hook.Add("TTT2UpdateBaserole", "ExecutionerTargetBaseRoleChange", ExecutionerTargetBaseRoleChange)

local function ExecutionerTargetTeamChange(ply, old, new)
  if ply:GetSubRole() == ROLE_EXECUTIONER and ply:GetTargetPlayer() and ply:GetTargetPlayer():GetTeam() == new then
    NewTarget(ply)
    return
  end

  local plys = player.GetAll()
  for i = 1, #plys do
    local pl = plys[i]
    if pl:GetSubRole() == ROLE_EXECUTIONER and pl:GetTargetPlayer() == ply and pl:IsInTeam(ply) then
      NewTarget(pl)
    end
  end
end
hook.Add("TTT2UpdateTeam", "ExecutionerTargetTeamChange", ExecutionerTargetTeamChange)

local function ExecutionerGotSelected()
  timer.Simple(0.1, function()
    local plys = player.GetAll()
    for i = 1, #plys do
      local ply = plys[i]
      if ply:GetSubRole() == ROLE_EXECUTIONER then
        ply.brokeContract = nil
        NewTarget(ply)
      end
    end
  end)
end
hook.Add("TTTBeginRound", "ExecutionerGotSelected", ExecutionerGotSelected)

local function ExecutionerDealDamage(ply, dmginfo)
  if not ply or not IsValid(ply) or not ply:IsPlayer() then return end

  local attacker = dmginfo:GetAttacker()
  if not attacker or not IsValid(attacker) or not attacker:IsPlayer() then return end
  if attacker:GetSubRole() ~= ROLE_EXECUTIONER then return end

  local dmg_mult = GetConVar("ttt2_executioner_target_multiplier"):GetFloat()
  local dmg_div = GetConVar("ttt2_executioner_non_target_multiplier"):GetFloat()

  if ply == attacker:GetTargetPlayer() then
    dmginfo:ScaleDamage(dmg_mult)
  elseif ply ~= attacker:GetTargetPlayer() and ply:AccountID() ~= attacker:AccountID() then
    dmginfo:ScaleDamage(dmg_div)
  end
end
hook.Add("EntityTakeDamage", "ExecutionerDealDamage", ExecutionerDealDamage)

local function ResetExecutioner()
  local plys = player.GetAll()
  for i = 1, #plys do
    plys[i].brokeContract = nil
  end
end
hook.Add("TTTBeginRound", "ResetExecutioner", ResetExecutioner)
hook.Add("TTTPrepRound", "ResetExecutioner", ResetExecutioner)
hook.Add("TTTEndRound", "ResetExecutioner", ResetExecutioner)
