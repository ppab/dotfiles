vim.api.nvim_create_user_command("Tag", function(opts)
	local input_tags = opts.args
	-- Convert input: testTag1,testTag2 → {"testTag1", "testTag2"}
	local quoted_new_tags = {}
	for tag in string.gmatch(input_tags, "([^,]+)") do
		table.insert(quoted_new_tags, '"' .. vim.trim(tag) .. '"')
	end

	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	for i, line in ipairs(lines) do
		local new_line, n = line:gsub("tags:%s*%[(.-)%]", function(existing)
			existing = vim.trim(existing or "")
			local existing_parts = {}
			if existing ~= "" then
				-- Split existing tags and keep as is (assuming they are already quoted)
				for t in string.gmatch(existing, "[^,]+") do
					table.insert(existing_parts, vim.trim(t))
				end
			end
			-- Append new quoted tags
			vim.list_extend(existing_parts, quoted_new_tags)
			-- Rebuild the array
			return "tags: [" .. table.concat(existing_parts, ", ") .. "]"
		end)

		if n > 0 then
			vim.api.nvim_buf_set_lines(0, i - 1, i, false, { new_line })
		end
	end
end, { nargs = 1 })
