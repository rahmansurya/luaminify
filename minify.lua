-- PRIV8-Tersesat 
-- lua minify.lua minify rock.lua -> rock_mini.lua
-- lua minify.lua unminify rock.lua -> rock_unmini.lua

local action = arg[1]
local filename = arg[2]

if not action or not filename then
    print("Usage:")
    print("  lua minify.lua minify <file.lua>")
    print("  lua minify.lua unminify <file.lua>")
    return
end


local function readFile(path)
    local file = io.open(path, "r")
    if not file then return nil end
    local content = file:read("*all")
    file:close()
    return content
end


local function writeFile(path, content)
    local file = io.open(path, "w")
    if not file then return false end
    file:write(content)
    file:close()
    return true
end

-- ==========================================
-- MINIFY
-- ==========================================
local function minify(code)
    code = code:gsub("%-%-[^\n]*", "")
    code = code:gsub("[\r\n]+", " ")
    code = code:gsub("\t", " ")
    code = code:gsub("%s+", " ")
    local symbols = {"%(", "%)", "{", "}", "%[", "%]", "=", "%+", "%-", "%*", "/", ",", ";"}
    for _, sym in ipairs(symbols) do
        code = code:gsub("%s*" .. sym .. "%s*", sym:gsub("%%", ""))
    end
    return code:match("^%s*(.-)%s*$")
end

-- ==========================================
-- UNMINIFY
-- ==========================================
local function unminify(code)
    local indent = 0
    local tab = "    "

    local function getIndentStr(n) return string.rep(tab, n) end
       
    code = code:gsub("([^%s%=%<>%!%*%/])([%=%+%-%*%/%%<>!]=?)([^%s%=%<>%!%*%/])", "%1 %2 %3")
    code = code:gsub("%,", ", ")
    code = code:gsub("%.%.", " .. ")
        
    local replacements = {
        {";", ";\n"},
        {" do ", " do\n"},
        {" then ", " then\n"},
        {" else ", "\nelse\n"},
        {" elseif ", "\nelseif "},
        {" end ", "\nend\n"},
        {" repeat ", "\nrepeat\n"},
        {" until ", "\nuntil "},
        {" function", "\nfunction"},
        {"{", "{\n"},
        {"}", "\n}"}
    }
    
    for _, r in ipairs(replacements) do
        code = code:gsub(r[1], r[2])
    end
    
    local lines = {}
    for line in code:gmatch("[^\r\n]+") do
        local cleanLine = line:match("^%s*(.-)%s*$")
        
        if cleanLine ~= "" then
            if cleanLine:match("^end") or cleanLine:match("^until") or cleanLine:match("^else") or cleanLine:match("^elseif") or cleanLine:match("^}") then
                indent = math.max(0, indent - 1)
            end
                        
            table.insert(lines, getIndentStr(indent) .. cleanLine)
                        
            if cleanLine:match("then$") or cleanLine:match("do$") or cleanLine:match("repeat$") or cleanLine:match("function.*") or cleanLine:match("else$") or cleanLine:match("{$") then
                indent = indent + 1
            end
        end
    end
    
    return table.concat(lines, "\n")
end

-- COMMAND
local inputCode = readFile(filename)
if not inputCode then
    print("❌ Error: File '" .. filename .. "' tidak ditemukan!")
    return
end

local outputName = ""
local finalResult = ""

if action == "minify" then
    outputName = filename:gsub("%.lua$", "") .. "_mini.lua"
    finalResult = minify(inputCode)
    print("⚡ Minifying...")
elseif action == "unminify" then
    outputName = filename:gsub("%.lua$", "") .. "_unmini.lua"
    finalResult = unminify(inputCode)
    print("🛠️ Unminifying...")
else
    print("❌ Error: Action harus 'minify' atau 'unminify'")
    return
end

if writeFile(outputName, finalResult) then
    print("✅ Berhasil! Output disimpan di: " .. outputName)
else
    print("❌ Gagal menulis file output.")
end