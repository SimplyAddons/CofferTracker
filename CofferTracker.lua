local CofferTrackerAddon = CreateFrame("Frame")
CofferTrackerAddon:RegisterEvent("ADDON_LOADED")
CofferTrackerAddon:RegisterEvent("PLAYER_LOGOUT")
CofferTrackerAddon:RegisterEvent("CURRENCY_DISPLAY_UPDATE")

-- Default settings
local defaults = {
    openedChests = {},
    visibility = {}
}

local cofferkeyID = 3028  -- ID for the restored coffer key
local playerName = UnitName("player")

-- Initalize settings
local function InitializeSettings()
    if not CofferTracker.openedChests then
        CofferTracker.openedChests = {}
    end
    if not CofferTracker.visibility then
        CofferTracker.visibility = {}
    end
end

-- Main event handler
CofferTrackerAddon:SetScript("OnEvent", function(self, event, id, quantity, quantityChange, ...)
    -- Load counts
    if event == "ADDON_LOADED" and id == "CofferTracker" then
        if not CofferTracker then
            CofferTracker = defaults
        end

        InitializeSettings()

        self:UpdateText()
        self:UpdateVisibility()

    -- Save settings on logout
    elseif event == "PLAYER_LOGOUT" then
        CofferTracker = CofferTracker

    -- Automatically track looted restored coffer keys
    elseif event == "CURRENCY_DISPLAY_UPDATE" then
        if id == cofferkeyID then
            self:IncrementCofferCount()
            print("You have looted a restored coffer key! Total keys looted: " .. CofferTracker.openedChests[playerName])
        end
    end
end)

-- Update key counts
function CofferTrackerAddon:SetCoffers(num)
    CofferTracker.openedChests[playerName] = tonumber(num)
    print("You have set the number of looted keys to " .. num .. " for " .. playerName .. ".")
    self:UpdateText()
end

-- Increments key count
function CofferTrackerAddon:IncrementCofferCount()
    local currentCount = CofferTracker.openedChests[playerName] or 0
    CofferTracker.openedChests[playerName] = currentCount + 1
    self:UpdateText()
end

-- Reset the key counts for all characters
function CofferTrackerAddon:Reset()
    CofferTracker.openedChests = {}  -- Clear the openedChests table
    CofferTracker.visibility = {}    -- Clear the visibility table
    print("Key counts and visibility have been reset for all characters. Coffer Tracker is now visible for all characters by default.")
    self:UpdateText()
    self:UpdateVisibility()
end

-- Toggle visibility for the current character
function CofferTrackerAddon:ToggleVisibility()
    local currentVisibility = CofferTracker.visibility[playerName]
    if currentVisibility == nil then
        currentVisibility = true -- Default to visible if not set
    end

    -- Toggle visibility
    CofferTracker.visibility[playerName] = not currentVisibility

    -- Print message based on visibility state
    if CofferTracker.visibility[playerName] then
        print("Coffer Tracker is now visible for " .. playerName .. ".")
    else
        print("Coffer Tracker is now hidden for " .. playerName .. ".")
    end

    self:UpdateVisibility()
end

-- Update the on-screen count text
function CofferTrackerAddon:UpdateText()
    local num = CofferTracker.openedChests[playerName] or 0
    if num == 1 then
        self.text:SetText("You have looted 1 key")
    else
        self.text:SetText("You have looted " .. num .. " keys")
    end
end

--Update the visibility of the frame
function CofferTrackerAddon:UpdateVisibility()
    local visible = CofferTracker.visibility[playerName]
    if visible == nil or visible == true then
        self.frame:Show()
    else
        self.frame:Hide()
    end
end

-- Movable frame to display the text
CofferTrackerAddon.frame = CreateFrame("Frame", "CofferTrackerFrame", UIParent, "BackdropTemplate")
CofferTrackerAddon.frame:SetPoint("CENTER", 0, 0)
CofferTrackerAddon.frame:SetSize(180, 40)
CofferTrackerAddon.frame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background" -- Only background, no edgeFile
})
CofferTrackerAddon.frame:SetMovable(true)
CofferTrackerAddon.frame:EnableMouse(true)
CofferTrackerAddon.frame:RegisterForDrag("LeftButton")
CofferTrackerAddon.frame:SetScript("OnDragStart", function(self) self:StartMoving() end)
CofferTrackerAddon.frame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

-- Tooltip
CofferTrackerAddon.frame:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOM")
    GameTooltip:SetText("Coffer Tracker", 0.7, 0.3, 0.9, 1, true)
    GameTooltip:AddLine("Counts will automatically update when you loot a new Restored Coffer Key.\n\n", nil, nil, nil, true)
    GameTooltip:AddLine("Type `/coffer` to toggle visibility of this info box.\n\n", nil, nil, nil, true)
    GameTooltip:AddLine("Type `/coffer <num>` to manually set the number of keys you have looted on your current character.\n\n", nil, nil, nil, true)
    GameTooltip:AddLine("Type `/coffer reset` to reset the count for all characters. (You should do this once, on every weekly reset).", nil, nil, nil, true)
    GameTooltip:Show()
end)
CofferTrackerAddon.frame:SetScript("OnLeave", function(self)
    GameTooltip:Hide()
end)

-- Render the frame text
CofferTrackerAddon.text = CofferTrackerAddon.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
CofferTrackerAddon.text:SetPoint("CENTER", CofferTrackerAddon.frame, "CENTER", 0, 0)
CofferTrackerAddon.text:SetText("You have looted 0 keys")

-- Slash commands
SLASH_COFFER1 = "/coffer"
SlashCmdList["COFFER"] = function(msg)
    local num = tonumber(msg)
    if num then
        CofferTrackerAddon:SetCoffers(num)
    elseif msg == "reset" then
        CofferTrackerAddon:Reset()
    else
        CofferTrackerAddon:ToggleVisibility()
    end
end
