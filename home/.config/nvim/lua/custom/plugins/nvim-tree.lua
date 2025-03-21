-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            local function my_on_attach(bufnr)
                local api = require("nvim-tree.api")
                local function opts(desc)
                    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                end
                api.config.mappings.default_on_attach(bufnr)
                vim.keymap.del("n", "<C-e>", { buffer = bufnr })
                vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
            end
            require("nvim-tree").setup({
                on_attach = my_on_attach,
            })
            local api = require("nvim-tree.api")
            vim.keymap.set("n", "<C-\\>", api.tree.toggle, { desc = "NvimTreeToggle" })
        end,
    },
}
