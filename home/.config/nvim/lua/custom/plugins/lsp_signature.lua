return {
  {
    "ray-x/lsp_signature.nvim",
    -- event = 'BufEnter',
    opts = {
      bind = true,
      doc_lines = 10,
      max_height = 12,
      max_width = 110,
      floating_window = false,
      hint_enable = false,
      hint_prefix = {
        above = "↙ ", -- when the hint is on the line above the current line
        current = "← ", -- when the hint is on the same line
        below = "↖ ", -- when the hint is on the line below the current line
      },
      handler_opts = {
        border = "rounded",
      },
      padding = "",
      toggle_key = "<C-p>",
      toggle_key_flip_floatwin_setting = true,
      -- select_signature_key = '<C-n>',
    },
    config = function(_, opts)
      require("lsp_signature").setup(opts)
    end,
  },
}
