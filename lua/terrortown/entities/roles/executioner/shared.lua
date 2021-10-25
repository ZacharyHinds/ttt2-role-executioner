if SERVER then
  AddCSLuaFile()

  resource.AddFile("materials/vgui/ttt/dynamic/roles/icon_exc.vmt")

  -- if there is TTTC installed: sync classes
  util.AddNetworkString("TTT2ExecutionerSyncClasses")
end

CreateConVar("ttt2_executioner_target_multiplier", 2, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})
CreateConVar("ttt2_executioner_non_target_multiplier", 0.5, {FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED})

function ROLE:PreInitialize()
  self.color = Color(163, 15, 28, 255)

  self.abbr = "exc" -- abbreviation
  self.surviveBonus = 0.5 -- bonus multiplier for every survive while another player was killed
  self.scoreKillsMultiplier = 5 -- multiplier for kill of player of another team
  self.scoreTeamKillsMultiplier = -16 -- multiplier for teamkill
  self.preventFindCredits = false
  self.preventKillCredits = false
  self.preventTraitorAloneCredits = false

  self.defaultEquipment = SPECIAL_EQUIPMENT -- here you can set up your own default equipment
  self.defaultTeam = TEAM_TRAITOR

  self.conVarData = {
    pct = 0.17, -- necessary: percentage of getting this role selected (per player)
    maximum = 1, -- maximum amount of roles in a round
    minPlayers = 6, -- minimum amount of players until this role is able to get selected
    credits = 0, -- the starting credits of a specific role
    togglable = true, -- option to toggle a role for a client if possible (F1 menu)
    random = 50,
    traitorButton = 1, -- can use traitor buttons
    shopFallback = SHOP_FALLBACK_TRAITOR
  }
end

-- now link this subrole with its baserole
function ROLE:Initialize()
  roles.SetBaseRole(self, ROLE_TRAITOR)
end

-- local h_TTT2CheckCreditAward = "TTT2HitmanSpecialCreditReward"
local ex_TTTCPostReceiveCustomClasses = "TTT2ExecutionerCanSeeClasses"

if SERVER then
  -- TODO improve networking. If TTTC is disabled, this doesn't need to be handled
  local function SendClassesToExecutioner(executioner)
    if not TTTC then return end

    for _, ply in ipairs(player.GetAll()) do
      if ply ~= executioner then
        net.Start("TTT2ExecutionerSyncClasses")
        net.WriteEntity(ply)
        net.WriteUInt(ply:GetCustomClass() or 0, CLASS_BITS)
        net.Send(executioner)
      end
    end
  end

  -- hook.Add("TTT2CheckCreditAward", h_TTT2CheckCreditAward, function(victim, attacker)
  -- 	if IsValid(attacker) and attacker:IsPlayer() and attacker:IsActive() and attacker:GetSubRole() == ROLE_HITMAN then
  -- 		return false -- prevent awards
  -- 	end
  -- end)

  hook.Add("TTT2UpdateSubrole", ex_TTTCPostReceiveCustomClasses, function(executioner, oldRole, role)
    if not TTTC then return end

    if executioner:IsActive() and role == ROLE_EXECUTIONER then
      SendClassesToExecutioner(executioner)
    end
  end)

  hook.Add("TTTCPostReceiveCustomClasses", ex_TTTCPostReceiveCustomClasses, function()
    if not TTTC then return end

    for _, executioner in ipairs(player.GetAll()) do
      if executioner:IsActive() and executioner:GetSubRole() == ROLE_EXECUTIONER then
        SendClassesToExecutioner(executioner)
      end
    end
  end)
end

if CLIENT then
  net.Receive("TTT2ExecutionerSyncClasses", function(len)
    local target = net.ReadEntity()
    local class = net.ReadUInt(CLASS_BITS)

    if class == 0 then
      class = nil
    end

    target:SetClass(class)
  end)

  function ROLE:AddToSettingsMenu(parent)
    local form = vgui.CreateTTT2Form(parent, "header_roles_additional")

    form:MakeSlider({
      serverConvar = "ttt2_executioner_punishment_time",
      label = "label_executioner_punishment_time",
      min = 0,
      max = 240,
      decimal = 0
    })

    form:MakeSlider({
      serverConvar = "ttt2_executioner_target_multiplier",
      label = "label_executioner_target_multiplier",
      min = 1,
      max = 10,
      decimal = 1
    })

    form:MakeSlider({
      serverConvar = "ttt2_executioner_non_target_multiplier",
      label = "label_executioner_non_target_multiplier",
      min = 0,
      max = 1,
      decimal = 1
    })
  end
  
  hook.Add("TTT2FinishedLoading", "exe_devicon", function() -- addon developer emblem for me ^_^
    AddTTT2AddonDev("76561198049910438")
  end)
end
