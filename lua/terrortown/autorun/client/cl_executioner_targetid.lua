local targetExe = Material("vgui/ttt/target_icon")

hook.Add("TTTRenderEntityInfo", "ttt2_executioner_target_highlight", function(tData)
  if not EXECUTIONER then return end

  local ent = tData:GetEntity()

  if not ent:IsPlayer() then return end

  local ply = LocalPlayer()

  if ply:GetSubRole() ~= ROLE_EXECUTIONER then return end

  if tData:GetAmountDescriptionLines() > 0 then
    tData:AddDescriptionLine()
  end

  if ply:GetTargetPlayer() == ent then
    tData:AddDescriptionLine(
      LANG.GetParamTranslation("ttt2_executioner_player_target", {multiplier = math.Round(GetConVar("ttt2_executioner_target_multiplier"):GetFloat(), 1)}),
      EXECUTIONER.ltcolor
    )

    tData:AddIcon(
      targetExe,
      EXECUTIONER.ltcolor
    )
  else
    tData:AddDescriptionLine(
      LANG.GetParamTranslation("ttt2_executioner_player_nontarget", {multiplier = math.Round(GetConVar("ttt2_executioner_non_target_multiplier"):GetFloat(), 1)}),
      COLOR_WHITE
    )
  end
end)

hook.Add("Initialize", "ttt2_exe_broke_contract", function()
  STATUS:RegisterStatus("ttt2_exe_broke_contract", {
    hud = targetExe,
    type = "bad"
  })
end)

net.Receive("ttt2_exe_broke_contract", function()
  local client = LocalPlayer()
  if client:GetSubRole() ~= ROLE_EXECUTIONER then return end
  local time = net.ReadInt(32)
  STATUS:AddTimedStatus("ttt2_exe_broke_contract", time, true)
end)
