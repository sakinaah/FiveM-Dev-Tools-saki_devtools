---------------------------------------------------- dev cam ---------------------------------------------------------------------

local devCamActive = false
local devCam = nil
local devCamSpeed = 1.5
local speedBoost = false

RegisterCommand("devcam", function()
    devCamActive = not devCamActive

    local ped = PlayerPedId()

    if devCamActive then
        local coords = GetEntityCoords(ped)
        devCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(devCam, coords.x, coords.y, coords.z + 1.5)
        SetCamRot(devCam, 0.0, 0.0, GetEntityHeading(ped))
        RenderScriptCams(true, true, 0, true, true)
        FreezeEntityPosition(ped, true)
        SetEntityVisible(ped, false)
        SetEntityInvincible(ped, true)
        SetEntityCollision(ped, false, false)
        print("DevCam ON")
    else
        RenderScriptCams(false, true, 0, true, true)
        DestroyCam(devCam, false)
        devCam = nil
        local ped = PlayerPedId()
        FreezeEntityPosition(ped, false)
        SetEntityVisible(ped, true)
        SetEntityInvincible(ped, godMode) 
        SetEntityCollision(ped, true, true)
        print("DevCam OFF")
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        if devCamActive and devCam ~= nil then
            -- Control speed with SHIFT
            speedBoost = IsControlPressed(0, 21) -- Shift
            local speed = speedBoost and (devCamSpeed * 3.0) or devCamSpeed

            -- Get current cam rotation
            local rot = GetCamRot(devCam, 2)
            local pos = GetCamCoord(devCam)

            -- Get direction vector
            local forward = RotationToDirection(rot)

            -- Move cam
            local x, y, z = pos.x, pos.y, pos.z
            if IsControlPressed(0, 32) then -- W
                x = x + forward.x * speed
                y = y + forward.y * speed
                z = z + forward.z * speed
            end
            if IsControlPressed(0, 33) then -- S
                x = x - forward.x * speed
                y = y - forward.y * speed
                z = z - forward.z * speed
            end
            if IsControlPressed(0, 35) then -- A
                x = x + forward.y * speed
                y = y - forward.x * speed
            end
            if IsControlPressed(0, 34) then -- D
                x = x - forward.y * speed
                y = y + forward.x * speed
            end
            if IsControlPressed(0, 44) then -- Q
                z = z - speed
            end
            if IsControlPressed(0, 20) then -- Z
                z = z + speed
            end

            -- Update cam coords
            SetCamCoord(devCam, x, y, z)

            -- Mouse look
            local rightX = GetDisabledControlNormal(0, 1)
            local rightY = GetDisabledControlNormal(0, 2)
            local newRotX = rot.x + rightY * -10.0
            local newRotZ = rot.z + rightX * -10.0
            SetCamRot(devCam, newRotX, 0.0, newRotZ)
        end
    end
end)

function RotationToDirection(rotation)
    local z = math.rad(rotation.z)
    local x = math.rad(rotation.x)
    local num = math.abs(math.cos(x))
    return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end

---------------------------------------------------- xyz ---------------------------------------------------------------------

local showCoords = false

RegisterCommand("xyz", function()
    showCoords = not showCoords
    print("XYZ display: " .. tostring(showCoords))
end)

CreateThread(function()
    while true do
        Wait(0)
        if showCoords then
            local coords = GetEntityCoords(PlayerPedId())
            local heading = GetEntityHeading(PlayerPedId())
            local text = string.format("X: %.2f  Y: %.2f  Z: %.2f  H: %.2f", coords.x, coords.y, coords.z, heading)
            DrawStyledTextCenter(text)
        end
    end
end)

function DrawStyledTextCenter(text)
    SetTextFont(4)
    SetTextScale(0.5, 0.5)
    SetTextCentre(true)

    SetTextColour(72, 191, 191, 255)

    SetTextDropShadow(2, 72, 191, 191, 200)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.5, 0.70)
end
------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------- reduce ai ---------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------

CreateThread(function()
    while true do
        Wait(0)

        SetVehicleDensityMultiplierThisFrame(0.1)
        SetRandomVehicleDensityMultiplierThisFrame(0.1)
        SetParkedVehicleDensityMultiplierThisFrame(0.1)
        SetPedDensityMultiplierThisFrame(0.1)
        SetScenarioPedDensityMultiplierThisFrame(0.1, 0.1)

    end
end)
