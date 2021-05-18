util.AddNetworkString("ttt2_exe_broke_contract")

EXECUTIONER_DATA = EXECUTIONER_DATA or {}
EXECUTIONER_DATA.exlude_roles = {}
EXECUTIONER_DATA.priority_roles = {}
EXECUTIONER_DATA.detectives = {}
EXECUTIONER_DATA.post_detective = {}
EXECUTIONER_DATA.pre_detective = {}

--Add a excluded role. This role will both not be a target, but also will not apply the damage modifier nor punishment
function EXECUTIONER_DATA:AddExcludedRole(role)
  if not role then return end

  EXECUTIONER_DATA.exlude_roles[role] = true
end

--Add a priority role. These will be target first, before any other role players
function EXECUTIONER_DATA:AddPriorityRole(role)
  if not role then return end

  EXECUTIONER_DATA.priority_roles[role] = true
end

--Add a post detective role. These will be targeted after all detectives are defeated (ex. Spy)
function EXECUTIONER_DATA:AddPostDetectiveRole(role)
  if not role then return end

  EXECUTIONER_DATA.post_detective[role] = true
end

--Add a pre detective role. These will be targeted after targets but before detectives
function EXECUTIONER_DATA:AddPreDetectiveRole(role)
  if not role then return end

  EXECUTIONER_DATA.pre_detective[role] = true
end

--Add a detective role. These will be added to the pool of detective targets. Roles with the detective base role automatically are included here
function EXECUTIONER_DATA:AddDetectiveRole(role)
  if not role then return end

  EXECUTIONER_DATA.detectives[role] = true
end

hook.Add("PostGamemodeLoaded", "TTT2ExecutionerSetupTable", function()
  --Setup exlcuded roles
  EXECUTIONER_DATA:AddExcludedRole(ROLE_JESTER)
  EXECUTIONER_DATA:AddExcludedRole(ROLE_SWAPPER)
  EXECUTIONER_DATA:AddExcludedRole(ROLE_MEDIC)
  EXECUTIONER_DATA:AddExcludedRole(ROLE_DRUNK)
  
  --Setup priority roles
  EXECUTIONER_DATA:AddPriorityRole(ROLE_HIDDEN)

  --Setup post detective roles
  EXECUTIONER_DATA:AddPostDetectiveRole(ROLE_SPY)

  --Setup pre detective roles
end)

function EXECUTIONER_DATA:GetTargets(ply)
  local targets = {}
  local dets = {}
  local priority = {}
  local post_det = {}
  local pre_det = {}

  if not IsValid(ply) or not ply:IsActive() or not ply:Alive() or (ply.IsGhost and ply:IsGhost()) or ply:GetSubRole() ~= ROLE_EXECUTIONER then
    return targets
  end

  local plys = util.GetAlivePlayers()

  for i = 1, #plys do
    local tgt = plys[i]
    if tgt.IsGhost and pl:IsGhost() then continue end
    if tgt:GetTeam() == ply:GetTeam() then continue end
    local tgt_role = tgt:GetSubRole()
    if EXECUTIONER_DATA.exlude_roles[tgt_role] then continue end
    if EXECUTIONER_DATA.priority_roles[tgt_role] then
      priority[#priority + 1] = tgt
    elseif EXECUTIONER_DATA.post_detective[tgt_role] then
      post_det[#post_det + 1] = tgt
    elseif EXECUTIONER_DATA.pre_detective[tgt_role] then
      pre_det[#pre_det + 1] = tgt
    elseif tgt:GetBaseRole() == ROLE_DETECTIVE or EXECUTIONER_DATA.detectives[tgt_role] then
      dets[#dets + 1] = tgt
    else
      targets[#targets + 1] = tgt
    end
  end

  if #priority > 0 then
    return priority
  elseif #targets > 0 then
    return targets
  elseif #pre_det > 0 then
    return pre_det
  elseif #dets > 0 then
    return dets
  else
    return post_det
  end
end

local function NewTarget(ply)
  local targets = EXECUTIONER_DATA:GetTargets(ply)

  if (#targets > 0) and not ply.brokeContract then
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

local function ExecutionerKilledTarget(ply, attacker, dmgInfo)
  if not IsValid(ply) or not IsValid(attacker) then return end
  if not attacker:IsPlayer() or not attacker:Alive() then return end

  if attacker:GetSubRole() ~= ROLE_EXECUTIONER then return end
  if attacker.IsGhost and attacker:IsGhost() then return end
  if not attacker:GetTargetPlayer() then return end

  local punishment = GetConVar("ttt2_executioner_punishment_time"):GetInt()

  if attacker:GetTargetPlayer() == ply then
    LANG.Msg(attacker, "ttt2_executioner_target_killed", nil, MSG_MSTACK_ROLE)
    events.Trigger(EVENT_EXC_TARGET_KILL, ply, attacker, dmgInfo, true)
    NewTarget(attacker)
  elseif not EXECUTIONER_DATA.exlude_roles[ply:GetSubRole()] then
    if punishment > 0 then
      LANG.Msg(attacker, "ttt2_executioner_target_killed_wrong", {punishtime = punishment}, MSG_MSTACK_ROLE)
      events.Trigger(EVENT_EXC_TARGET_KILL, ply, attacker, dmgInfo, false)
      attacker:SetTargetPlayer(nil)
      attacker.brokeContract = true
      print("[TTT2 EXECUTIONER] " .. attacker:Nick() .. "'s Punishment Time: " .. punishment)
      net.Start("ttt2_exe_broke_contract")
      net.WriteInt(punishment, 32)
      net.Send(attacker)
      timer.Simple(punishment, function()
        if not attacker or not IsValid(attacker) or not attacker:IsPlayer() then return end
        attacker.brokeContract = nil
        NewTarget(attacker)
      end)
    else
      NewTarget(attacker)
    end
  end
end
hook.Add("DoPlayerDeath", "ExecutionerKilledTarget", ExecutionerKilledTarget)

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
      if pl:GetSubRole() == ROLE_EXECUTIONER and pl:GetTargetPlayer() == ply and pl:GetTeam() == ply then
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
    if pl:GetSubRole() == ROLE_EXECUTIONER and pl:GetTargetPlayer() == ply and pl:GetTeam() == ply then
      NewTarget(pl)
    end
  end
end
hook.Add("TTT2UpdateTeam", "ExecutionerTargetTeamChange", ExecutionerTargetTeamChange)

local function ExecutionerGotSelected()
  timer.Simple(0.5, function()
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
  local atk_tgt = attacker:GetTargetPlayer()
  if not IsValid(atk_tgt) or not atk_tgt:Alive() or atk_tgt:IsSpec() then
    NewTarget(attacker)
  end
  atk_tgt = attacker:GetTargetPlayer()
  if (not IsValid(atk_tgt) or not atk_tgt:Alive() or atk_tgt:IsSpec()) and not attacker.brokeContract then return end

  if ply == attacker:GetTargetPlayer() then
    dmginfo:ScaleDamage(dmg_mult)
  elseif ply:AccountID() ~= attacker:AccountID() and not EXECUTIONER_DATA.exlude_roles[ply:GetSubRole()] then
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
