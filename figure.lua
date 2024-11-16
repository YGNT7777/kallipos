--Pandoc Lua function adds caption and formats an image according to the standard markdown format
--It reads the image caption and location from a yaml file located in the figures folder
--It expects to find an (over)loaded Pandoc image tag with figure class and filename
function Image(img)
    local stringify = pandoc.utils.stringify
    if img.classes:find('figure', 1) then
        local fn = img.src
        -- Attempt to open the YAML file
        local f = io.open("figures/" .. fn, 'r')
        if not f then
            io.stderr:write("Error: Could not open file: figures/" .. fn .. "\n")
            return nil -- Skip processing this image
        end -- Close the 'if not f' block

        -- Read and parse the YAML content
        local content = f:read('*a')
        f:close()
        local doc = pandoc.read(content)

        -- Extract metadata
        local src = doc.meta and stringify(doc.meta.image_url) or "src has not been set"
        local caption = doc.meta and stringify(doc.meta.caption) or "Caption missing"

        -- Ensure src has the correct prefix
        if not src:match("^%.%.") then
            src = ".." .. src
        end

        -- Generate figure ID based on the filename
        local figid = fn:match("^(.*)%..+$") or fn

        -- Return the formatted Pandoc Image element
        return pandoc.Image(caption, src, nil, "fig:" .. figid)
    end -- Close the 'if img.classes' block
end

