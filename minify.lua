-- [[ LUA MINIFIER & BEAUTIFIER TOOL 2026 ]] --
-- Usage: 
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

-- Fungsi Membaca File
local function readFile(path)
    local file = io.open(path, "r")
    if not file then return nil end
    local content = file:read("*all")
    file:close()
    return content
end

-- Fungsi Menulis File
local function writeFile(path, content)
    local file = io.open(path, "w")
    if not file then return false end
    file:write(content)
    file:close()
    return true
end

-- ==========================================
-- LOGIKA MINIFY (Mengecilkan Kode)
-- ==========================================
local function minify(code)
    -- Hapus komentar baris tunggal (--)
    code = code:gsub("%-%-[^\n]*", "")
    -- Ganti baris baru dengan spasi
    code = code:gsub("[\r\n]+", " ")
    -- Ganti tab dengan spasi
    code = code:gsub("\t", " ")
    -- Hapus spasi berlebih
    code = code:gsub("%s+", " ")
    -- Hapus spasi di sekitar simbol operator
    local symbols = {"%(", "%)", "{", "}", "%[", "%]", "=", "%+", "%-", "%*", "/", ",", ";"}
    for _, sym in ipairs(symbols) do
        code = code:gsub("%s*" .. sym .. "%s*", sym:gsub("%%", ""))
    end
    return code:match("^%s*(.-)%s*$")
end

-- ==========================================
-- LOGIKA UNMINIFY (Merapikan Kode)
-- ==========================================
local function unminify(code)
    local indent = 0
    local output = ""
    local tab = "    " -- 4 Spasi

    -- Keyword yang menambah/mengurangi jorokan (indentasi)
    local function getIndentStr(n) return string.rep(tab, n) end
    
    -- Rapikan simbol dan keyword dasar
    code = code:gsub(";", ";\n")
    code = code:gsub(" do ", " do\n")
    code = code:gsub(" then ", " then\n")
    code = code:gsub(" else ", "\nelse\n")
    code = code:gsub(" elseif ", "\nelseif ")
    code = code:gsub(" end ", "\nend\n")
    code = code:gsub(" function", "\nfunction")

    local lines = {}
    for line in code:gmatch("[^\r\n]+") do
        local cleanLine = line:match("^%s*(.-)%s*$")
        if cleanLine ~= "" then
            -- Cek apakah baris ini mengurangi indentasi
            if cleanLine:match("^end") or cleanLine:match("^until") or cleanLine:match("^else") or cleanLine:match("^elseif") then
                indent = math.max(0, indent - 1)
            end
            
            table.insert(lines, getIndentStr(indent) .. cleanLine)
            
            -- Cek apakah baris ini menambah indentasi untuk baris berikutnya
            if cleanLine:match("then$") or cleanLine:match("do$") or cleanLine:match("repeat$") or cleanLine:match("function.*%)$") or cleanLine:match("else$") then
                indent = indent + 1
            end
        end
    end
    
    return table.concat(lines, "\n")
end

-- ==========================================
-- EKSEKUSI COMMAND
-- ==========================================
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