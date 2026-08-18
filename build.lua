local Order = { "src/Utils.lua", "src/Icons.lua", "src/Library.lua" }

local Parts = {}
for _, Path in ipairs(Order) do
    assert(isfolder and isfile and readfile and writefile, "executor fs required to build")
    assert(isfile(Path), "missing " .. Path)
    table.insert(Parts, readfile(Path))
end

local Out = table.concat(Parts, "\n")
writefile("Lol Lib.lua", Out)
print("Built Lol Lib.lua (" .. #Out .. " bytes) from src/")
