
local framePrefix = 'yDruidFrame'
_G['BINDING_HEADER_YDRUID'] = 'yDuird'

local spells = {
    Aquatic         = 1066,
    Flight          = 33943,
    SwiftFlight     = 40120,
    Travel          = 783,
    Bear            = 5487,
    Cat             = 768,
    Tree            = 33891,
    Moonkin         = 62795,
}
for form, id in next, spells do
    local name = GetSpellInfo(id)

    spells[form] = {
        id = id,
        name = name,
    }
end

local smartFrame = CreateFrame('Button', framePrefix .. 'Smart', UIParent, 'SecureActionButtonTemplate')
smartFrame:SetScript('OnEvent', function(self, event)
    if(event == 'PLAYER_REGEN_ENABLED') then
        self:UnregisterEvent'PLAYER_REGEN_ENABLED'
    end
    if(InCombatLockdown()) then
        return self:RegisterEvent'PLAYER_REGEN_ENABLED'
    end

    local flySpell
    do
        if(IsSpellKnown(spells.SwiftFlight.id)) then
            flySpell = spells.SwiftFlight.name
        elseif(IsSpellKnown(spells.Flightid)) then
            flySpell = spells.Flight.name
        end
    end

    local macrotext = '/stopmacro [combat,flying]' ..
    '\n/cast [swimming]!' .. spells.Aquatic.name ..
    ';[combat]!' .. spells.Travel.name ..
    (flySpell and ';[flyable,nocombat]!' .. flySpell or '') ..
    '\n/stopmacro [combat][mounted][flyable]' .. [[
    /cancelform]] .. (SlashCmdList['NORU_MOUNT'] and '\n/noru' or '')  .. [[
    /cast ]] .. spells.Travel.name

    self:SetAttribute('type', 'macro')
    self:SetAttribute('macrotext', macrotext)
end)
smartFrame:RegisterEvent'SPELLS_CHANGED'
smartFrame:RegisterEvent'PLAYER_LOGIN'
_G['BINDING_NAME_CLICK ' .. framePrefix .. 'Smart:LeftButton'] = 'Smart'

local frames = {
    'Bear',
    'Cat',
    'Aquatic',
    'Tree',
    'Moonkin',
    'Travel',
}
for _, name in next, frames do
    local frameName = framePrefix .. name
    local f = CreateFrame('Button', frameName, UIParent, 'SecureActionButtonTemplate')
    f:SetAttribute('type', 'macro')

    local macrotext = '/cast !' .. spells[name].name
    local bindingName = 'BINDING_NAME_CLICK ' .. frameName .. ':LeftButton'

    f:SetAttribute('macrotext', macrotext)
    _G[bindingName] = spells[name].name
end

local mot = CreateFrame('Button', framePrefix .. 'MoonkinOrTree', UIParent, 'SecureActionButtonTemplate')
mot:SetAttribute('type', 'macro')
mot:SetScript('OnEvent', function(self, event)
    if(event == 'PLAYER_REGEN_ENABLED') then
        self:UnregisterEvent'PLAYER_REGEN_ENABLED'
    end
    if(InCombatLockdown()) then
        return self:RegisterEvent'PLAYER_REGEN_ENABLED'
    end

    local spell
    if(IsSpellKnown(spells.Moonkin.id)) then
        spell = GetSpellInfo(spells.Moonkin.id)
    elseif(IsSpellKnown(spells.Tree.id)) then
        spell = GetSpellInfo(spells.Tree.id)
    end

    self:SetAttribute('macrotext', spell and '/cast !' .. spell)
end)
mot:RegisterEvent'PLAYER_LOGIN'
mot:RegisterEvent'SPELLS_CHANGED'
_G['BINDING_NAME_CLICK ' .. framePrefix .. 'MoonkinOrTree:LeftButton'] = ('%s/%s'):format(spells.Moonkin.name, spells.Tree.name)

local umount = CreateFrame('Button', framePrefix .. 'UMOUNT', UIParent, 'SecureActionButtonTemplate')
umount:SetAttribute('type', 'macro')
umount:SetAttribute('macrotext', [[
/dismount
/cancelform
]])

_G['BINDING_NAME_CLICK ' .. framePrefix .. 'UMOUNT:LeftButton'] = 'umount'


