-- 0 = First person
-- 1 = Third person
currentview = 0

function checkForCheats(player)
  local sv_cheats = GetConVar("sv_cheats")
  local areCheatsEnabled = sv_cheats:GetInt()
  if areCheatsEnabled == 0 then
    player:ChatPrint( "Cheats are not enabled!" )
  end
  return areCheatsEnabled
end

function checkIfAdmin(player)
  local isAdmin = player:IsAdmin()
  if isAdmin == false then
    player:ChatPrint("You do not have admin rights!")
  end
  return isAdmin
end

function commandsPP(ply, text)
  --HOST COMMANDS
  if (text == "//god") then
    if checkIfAdmin(ply) then
      checkForCheats(ply)
      RunConsoleCommand("god")
      ply:ChatPrint("Toggled godmode")
    end
  end
  if string.find(text, "//speed") then
    if checkIfAdmin(ply) then
      local valuefromtext = string.match(text, "%d+")
      RunConsoleCommand("host_timescale", valuefromtext)
    end
  end
  --CLIENT COMMANDS
  --killself
  if (text == "//kill") then
    RunConsoleCommand("kill")
  end
  --switchview
  if (text == "//view") then
    checkForCheats(ply)
    if currentview == 0 then
      RunConsoleCommand("thirdperson")
      currentview = 1
    elseif currentview == 1 then
      RunConsoleCommand("firstperson")
      currentview = 0
    end
  end
end

hook.Add("PlayerSay", "commandsPPListener", commandsPP)
