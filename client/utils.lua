function table.map(tbl, f)
    local t = {}
    for k, v in pairs(tbl) do
        t[k] = f(v)
    end
    return t
end
