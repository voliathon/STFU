_addon.name = 'STFU'
_addon.version = '20.0'
_addon.author = 'Voliathon (Bahamut) '
_addon.commands = {'stfu'}

local packets = require('packets')

-- Define the path for our plain text blacklist file.
local blacklist_path = windower.addon_path .. 'data/blacklist.txt'
local config = {}

-- Function to save settings to a simple .txt file.
local function save_settings()
    local lines_to_write = {}
    
    table.insert(lines_to_write, '[USERS]')
    for user, _ in pairs(config.blacklisted_users) do
        table.insert(lines_to_write, user)
    end
    
    table.insert(lines_to_write, '[PATTERNS]')
    for _, pattern in ipairs(config.blacklisted_patterns) do
        table.insert(lines_to_write, pattern)
    end
    
    local content = table.concat(lines_to_write, '\n')

    -- Use io.open to write the plain text file.
    local file, err = io.open(blacklist_path, 'w')
    if file then
        file:write(content)
        file:close()
    else
        windower.add_to_chat(207, '-----------------------------------------------------------')
        windower.add_to_chat(207, 'STFU Action Required: Could not save blacklist.')
        windower.add_to_chat(207, 'Please create a folder named "data" inside your')
        windower.add_to_chat(207, 'Windower4/addons/STFU/ folder and reload the addon.')
        windower.add_to_chat(207, '-----------------------------------------------------------')
    end
end

-- Function to load settings from the .txt file.
local function load_settings()
    config = { blacklisted_users = {}, blacklisted_patterns = {} }
    
    local file = io.open(blacklist_path, 'r')
    if not file then
        windower.add_to_chat(158, 'STFU: blacklist.txt not found, creating a new empty one.')
        save_settings()
        return
    end

    local current_section = nil
    for line in file:lines() do
        line = line:match("^%s*(.-)%s*$")
        
        if line == '[USERS]' then
            current_section = 'users'
        elseif line == '[PATTERNS]' then
            current_section = 'patterns'
        elseif line ~= '' and current_section then
            if current_section == 'users' then
                -- Ensure names loaded from the file are also in the correct format
                local formatted_name = line:sub(1, 1):upper() .. line:sub(2):lower()
                config.blacklisted_users[formatted_name] = true
            elseif current_section == 'patterns' then
                table.insert(config.blacklisted_patterns, line)
            end
        end
    end
    file:close()
end

load_settings()

windower.register_event('incoming chunk', function(id, data)
    if id == 0x017 then -- Incoming chat
        local chat = packets.parse('incoming', data)
        local sender = chat['Sender Name']

        if sender and config.blacklisted_users[sender] then
            return true
        end

        if (chat['Mode'] == 3 or chat['Mode'] == 1 or chat['Mode'] == 26) then
            local message = windower.convert_auto_trans(chat['Message']):lower()
            for _, pattern in ipairs(config.blacklisted_patterns) do
                if message:match(pattern) then
                    return true
                end
            end
        end
    end
end)

windower.register_event('addon command', function(...)
    local args = T{...}
    local command = args[1] and args[1]:lower()

    if command == 'adduser' and args[2] then
        -- NEW: Automatically format the name to "Capitalized" case.
        local raw_name = args[2]
        local formatted_name = raw_name:sub(1, 1):upper() .. raw_name:sub(2):lower()
        
        config.blacklisted_users[formatted_name] = true
        save_settings()
        windower.add_to_chat(158, 'STFU: User "'..formatted_name..'" added and saved.')
    elseif command == 'deluser' and args[2] then
        -- NEW: Also format the name on deletion to ensure it's found.
        local raw_name = args[2]
        local formatted_name = raw_name:sub(1, 1):upper() .. raw_name:sub(2):lower()

        config.blacklisted_users[formatted_name] = nil
        save_settings()
        windower.add_to_chat(158, 'STFU: User "'..formatted_name..'" removed and saved.')
    elseif command == 'addword' and args[2] then
        local pattern_parts = {}
        for i = 2, #args do
            table.insert(pattern_parts, args[i])
        end
        local full_pattern = table.concat(pattern_parts, ' '):lower()
        
        table.insert(config.blacklisted_patterns, full_pattern)
        save_settings()
        windower.add_to_chat(158, 'STFU: Pattern "'..full_pattern..'" added and saved.')
    elseif command == 'delword' and args[2] then
        local pattern_parts = {}
        for i = 2, #args do
            table.insert(pattern_parts, args[i])
        end
        local pattern_to_remove = table.concat(pattern_parts, ' '):lower()

        for i, pattern in ipairs(config.blacklisted_patterns) do
            if pattern == pattern_to_remove then table.remove(config.blacklisted_patterns, i); break end
        end
        save_settings()
        windower.add_to_chat(158, 'STFU: Pattern "'..pattern_to_remove..'" removed and saved.')
    elseif command == 'list' then
        windower.add_to_chat(158, '--- STFU Blacklisted Users ---')
        for user, _ in pairs(config.blacklisted_users) do windower.add_to_chat(158, user) end
        windower.add_to_chat(158, '--- STFU Blacklisted Patterns ---')
        for _, pattern in ipairs(config.blacklisted_patterns) do windower.add_to_chat(158, pattern) end
    else
        windower.add_to_chat(158, '--- STFU Help ---')
        windower.add_to_chat(158, '//stfu adduser <name>')
        windower.add_to_chat(158, '//stfu deluser <name>')
        windower.add_to_chat(158, '//stfu addword <pattern>')
        windower.add_to_chat(158, '//stfu delword <pattern>')
        windower.add_to_chat(158, '//stfu list')
    end
end)