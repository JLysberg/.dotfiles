return {
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      local function buffer_is_modified(buf)
        return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted and vim.bo[buf].modified
      end

      opts.options = opts.options or {}
      opts.options.always_show_bufferline = true
      opts.options.custom_filter = function(buf)
        return buffer_is_modified(buf)
      end

      -- Preserve LazyVim/colorscheme-provided bufferline highlights, then only
      -- pin the row fill and separators to theme groups that survive Omarchy's
      -- transparency + hot-reload path. Without this, BufferLineFill can keep a
      -- stale tinted Normal.bg after switching themes.
      local existing_highlights = opts.highlights
      opts.highlights = function(defaults)
        local highlights = vim.deepcopy(defaults.highlights or {})
        if type(existing_highlights) == "function" then
          local colorscheme_highlights = existing_highlights(defaults)
          if type(colorscheme_highlights) == "table" then
            highlights = vim.tbl_deep_extend("force", highlights, colorscheme_highlights)
          end
        elseif type(existing_highlights) == "table" then
          highlights = vim.tbl_deep_extend("force", highlights, existing_highlights)
        end

        local fill_bg = { highlight = "TabLineFill", attribute = "bg" }
        local normal_bg = { highlight = "Normal", attribute = "bg" }
        local fill = { bg = fill_bg }
        local separator = { fg = fill_bg, bg = normal_bg }

        return vim.tbl_deep_extend("force", highlights, {
          fill = fill,
          offset_separator = fill,
          separator = separator,
          separator_visible = separator,
          separator_selected = separator,
        })
      end
    end,
  },
}
