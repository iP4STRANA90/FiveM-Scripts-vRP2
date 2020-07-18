
local Crypto = class("Crypto", vRP.Extension)

function checkIfInTable(table, check, sub)
  if type(check) == "string" or type(check) == "number"  then
    if sub then
      local many = 0
      for k,v in pairs(table) do
        for k,v2 in pairs(v) do
          if v2 == check then
            many = many + 1
          end
        end
      end
      return many
    else
      for k,v in pairs(table) do
        if v == check then
          return 1
        end
      end
      return 0
    end
  elseif type(check) == "table" then
    local many = 0
    for k,v1 in pairs(table) do
      if sub then
        for k,v2 in pairs(v1) do
          for k,v3 in pairs(check) do
            if v2 == v3 then
              many = many + 1
            end
          end
        end
      else
        for k,v2 in pairs(v1) do
          if v1 == v2 then
            many = many + 1
          end
        end
      end
    end
    return many
  end
end

local selling_points = {
  {x = -454.81781005859, y = -273.72631835938, z = 35.914577484131, h = 116.32739257813},
  {x = 322.07275390625, y = -674.1357421875, z = 29.478694915771, h = 248.32922363281},
  {x = 278.11947631836, y = -824.02758789063, z = 29.300416946411, h = 250.59887695313},
  {x = -84.901802062988, y = -703.54095458984, z = 34.600769042969, h = 177.43017578125},
  {x = -143.16648864746, y = -828.78393554688, z = 31.270334243774, h = 68.031768798828},
  {x = -122.22464752197, y = -893.06414794922, z = 29.328296661377, h = 68.170997619629},
  {x = 807.10797119141, y = -809.80487060547, z = 26.202770233154, h = 90.102325439453},
  {x = 448.8498840332, y = -657.16076660156, z = 28.465385437012, h = 167.3503112793},
  {x = 454.7350769043, y = -1117.8718261719, z = 29.265827178955, h = 138.47233581543},
  {x = 194.89694213867, y = -1165.5721435547, z = 29.30525970459, h = 275.81240844727},
  {x = 303.44552612305, y = -1335.1477050781, z = 31.928665161133, h = 113.62205505371},
  {x = 83.150451660156, y = -1387.5484619141, z = 29.427446365356, h = 269.55355834961},
  {x = -125.78142547607, y = -1199.7551269531, z = 27.384843826294, h = 270.79510498047},
  {x = -329.12875366211, y = -1383.4759521484, z = 32.201168060303, h = 103.71611785889},
  {x = -292.94644165039, y = -921.46807861328, z = 31.210586547852, h = 333.99310302734 },
  {x = -199.87382507324, y = -858.18011474609, z = 29.508247375488, h = 268.62908935547},
  {x = -215.59887695313, y = -620.96643066406, z = 33.763809204102, h = 75.604377746582},
  -- {},
  -- {},
  -- {},
  -- {},
  -- {},
  -- {},
  -- {},
  -- {},
  -- {},
  -- {},
  -- {},
  -- {},
  -- {},
  -- {},
  -- {},
  -- {},
  -- {},
  -- {},
  -- {},
  -- {},
  -- {},
}

local current_peds = {}
function createpedatloc(x,y,z,h)
  if checkIfInTable(current_peds, {x,y,z,h}, true) > 1 then
    return false
  end
  if not HasModelLoaded(GetHashKey( "u_m_m_promourn_01" )) then
    RequestModel(GetHashKey( "u_m_m_promourn_01" ))
    Wait( 200 )
  end
  local Coords = GetEntityCoords( GetPlayerPed( -1 ) )
  local Ped = CreatePed( 6, GetHashKey( "u_m_m_promourn_01" ), x,y,z -1 , h, false, true )
  FreezeEntityPosition(Ped, true)
  SetEntityInvincible(Ped, true)
  SetBlockingOfNonTemporaryEvents(Ped, true)
  TaskStartScenarioInPlace(Ped, "WORLD_HUMAN_LEANING", 0)
  table.insert(current_peds, {x = x, y = y, z = z, h = h})
end

function generatePoints()
  poor_chicken_blue = {}
  local time = GetGameTimer()
  print("trying to generate selling points")
  for i=1,math.random(2,6) do
    repeat
      Citizen.Wait(500)
      local poor_chicken_green = selling_points[math.random(1,#selling_points)]
      local x,y,z = poor_chicken_green.x, poor_chicken_green.y, poor_chicken_green.z
      if not ( checkIfInTable(poor_chicken_blue, json.encode(poor_chicken_green), true) > 0) then
        table.insert(poor_chicken_blue, {json.encode(poor_chicken_green)})
      end
    until( #poor_chicken_blue > 3 )
  end
  print("generated "..#poor_chicken_blue.." selling points, time taken: "..GetGameTimer() - time.."ms")
  return poor_chicken_blue
end

function Crypto:__construct()
  vRP.Extension.__construct(self)

  Citizen.CreateThread(function()
    Citizen.Wait(10000)
    local instructionals = exports['di_crypto']
    AddTextEntry("SELL_DRUGS", "Open Crypto Menu")
    local generic_potatoe_rod = generatePoints()
    while true do
      Citizen.Wait(1)
      local player_ped = GetPlayerPed(-1)
      local px,py,pz = table.unpack(GetEntityCoords(player_ped))
      for k,v in pairs(generic_potatoe_rod) do
        local v = json.decode(v[1])
        createpedatloc(v.x,v.y,v.z,v.h)
        if GetDistanceBetweenCoords(px, py, pz, v.x, v.y, v.z, true) < 10 then
          DrawMarker(27, v.x, v.y, v.z - 0.97, 0, 0, 0, 0, 0, 0, 1.001, 1.001, 1.001, 255, 0, 255, 100, 0, 0, 0, 1)
          if GetDistanceBetweenCoords(px, py, pz, v.x, v.y, v.z, true) < 2 then
            instructionals:SetInstructionalButton("SELL_DRUGS", 51, true)
            if IsControlJustPressed(0, 51) then
              self.remote._openCryptoSellMenu("illegal")
            end
          else
            instructionals:SetInstructionalButton("SELL_DRUGS", 51, false)
          end
        end
      end
    end
  end)
  Citizen.CreateThread(function()
    while true do
      Citizen.Wait(10000)
      for k,v in pairs(current_peds) do
        local x,y,z = v.x,v.y,v.z
        -- FreezeEntityPosition(v, false)
        -- SetEntityCoords(v, x+0.0001, y+0.0001, z  +0.0001, 1,0,0,1)
        -- FreezeEntityPosition(v, true)
      end
    end
  end)
end

-- local peds_points = {}
-- RegisterCommand("display_sell_points", function()
--   if not (#peds_points > 0) then
--     for k,v in pairs(current_peds) do
--       local x,y,z = v.x,v.y,v.z
--       local blipo = AddBlipForCoord(x,y,z)
--       SetBlipSprite(blipo, 527)
--       SetBlipColour(blipo, 1)
--       BeginTextCommandSetBlipName("STRING")
--       AddTextComponentString("[Hidden] Drugs sell location")
--       EndTextCommandSetBlipName(blipo)
--       SetBlipAsShortRange(blipo, true)
--       table.insert(peds_points, blipo)
--       print("diplaying "..#ped_points.." crypto ped locations")
--     end
--   else
--     for k,v in pairs(peds_points) do
--       print(k,v)
--       peds_points = {}
--       RemoveBlip(v)
--     end
--   end
-- end, false)
--
-- local ppeds_points = {}
-- RegisterCommand("display_all_possible_points", function()
--   if not (#ppeds_points > 0) then
--     for k,v in pairs(selling_points) do
--       local x,y,z = v.x,v.y,v.z
--       local blipo = AddBlipForCoord(x,y,z)
--       SetBlipSprite(blipo, 527)
--       SetBlipColour(blipo, 1)
--       BeginTextCommandSetBlipName("STRING")
--       AddTextComponentString("[Hidden] Drugs sell location")
--       EndTextCommandSetBlipName(blipo)
--       SetBlipAsShortRange(blipo, true)
--       table.insert(ppeds_points, blipo)
--       print("diplaying "..#ppeds_points.." crypto ped locations")
--     end
--   else
--     for k,v in pairs(ppeds_points) do
--       print(k,v)
--       peds_points = {}
--       RemoveBlip(v)
--     end
--   end
-- end, false)




vRP:registerExtension(Crypto)
