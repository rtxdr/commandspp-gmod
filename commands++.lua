-- 0 = First person
-- 1 = Third person
currentview = 0

commandstring = {
  "//hp",
  "//armor",
  "//ammo",
  "//kill",
  "//view",
  "//speed"
}


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

util.PrecacheSound( "ambient/alarms/warningbell1.wav" )

concommand.Add( "cmdpp_broadcastchat", function( ply, cmd, args, str )
  Entity(1):EmitSound("ambient/alarms/warningbell1.wav" )
  PrintMessage(HUD_PRINTTALK, str)
end )

concommand.Add( "cmdpp_broadcast", function( ply, cmd, args, str )
  Entity(1):EmitSound("ambient/alarms/warningbell1.wav" )
  PrintMessage(HUD_PRINTCENTER, str)
end )

function commandsPP(ply, text)
  text = text:lower()
  local function starts_with(str, start)
     return str:sub(1, #start) == start
  end

  --ADMIN COMMANDS
  if string.find(text, "//armor") then
    local valuefromtext = string.match(text,"%d+")
    ply:SetArmor(valuefromtext)
    ply:ChatPrint( "Set self ".. valuefromtext .." armor points." )
    Entity(1):EmitSound("HL1/fvox/blip.wav")
  end

  if string.find(text, "//hp") then
    local valuefromtext = string.match(text, "%d+")
    ply:SetHealth(valuefromtext)
    ply:ChatPrint( "Set self ".. valuefromtext .." health points." )
    Entity(1):EmitSound("HL1/fvox/blip.wav")
  end

  if string.find(text, "//speed") then
    local valuefromtext = tonumber(string.match(text, "%d+"))
    if valuefromtext < 1 then
      Entity(1):EmitSound("HL1/fvox/buzz.wav")
      ply:ChatPrint("Incorrect usage, please use a number bigger than 0.")
    else
      local processedDWS = 250 * (valuefromtext / 100)
      local processedDRS = 500 * (valuefromtext / 100)

      ply:SetWalkSpeed( processedDWS )
      ply:SetRunSpeed( processedDRS )

      ply:ChatPrint( "Set self ".. valuefromtext .."% speed." )
      Entity(1):EmitSound("HL1/fvox/blip.wav")
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
    Entity(1):EmitSound("HL1/fvox/blip.wav")
    if currentview == 0 then
      RunConsoleCommand("thirdperson")
      currentview = 1
    elseif currentview == 1 then
      RunConsoleCommand("firstperson")
      currentview = 0
    end
  end
  if (text == "//ammo") then
    local weapontype = ply:GetActiveWeapon()
    local ammotype1 = weapontype:GetPrimaryAmmoType()
    local ammotype2 = weapontype:GetSecondaryAmmoType()
    ply:GiveAmmo(9999, ammotype1)
    ply:GiveAmmo(9999, ammotype2)
    ply:ChatPrint( "Given self ammo." )
    Entity(1):EmitSound("HL1/fvox/blip.wav")
  end

  if starts_with(text, "//") then
    return ""
  end
end

hook.Add("PlayerSay", "commandsPPListener", commandsPP)
