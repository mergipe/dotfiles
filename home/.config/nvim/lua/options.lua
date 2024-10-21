-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- view options
vim.opt.number = true -- print the line number in front of each line
vim.opt.showmode = false -- don't show the mode, since it's already in the status line
vim.opt.signcolumn = 'auto:1-3' -- keep signcolumn on by default
vim.opt.cursorline = true -- highlight the screen line of the cursor
vim.opt.ruler = true -- show cursor line and column in the status line
vim.opt.colorcolumn = '110' -- columns to highlight

-- editing options
vim.opt.undofile = true -- save undo information in a file
vim.opt.inccommand = 'split' -- preview substitutions live, as you type!
vim.opt.scrolloff = 0 -- minimal number of screen lines to keep above and below the cursor.
vim.opt.timeoutlen = 300 -- decrease mapped sequence wait time; displays which-key popup sooner
-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' } --
-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Decrease update time
vim.opt.updatetime = 250 -- after this many milliseconds flush swap file

-- automatically read a file that has changed on disk
vim.opt.autoread = true

-- indenting options
vim.opt.expandtab = true -- use spaces when <Tab> is inserted
vim.opt.shiftwidth = 4 -- number of spaces to use for (auto)indent step
vim.opt.softtabstop = 4 -- number of spaces that <Tab> uses while editing
vim.opt.breakindent = true -- wrapped line repeats indent

-- search options
vim.opt.wrapscan = true -- searches wrap around the end of the file
vim.opt.hlsearch = true -- highlight matches with last search pattern
vim.opt.incsearch = true -- highlight match while typing search pattern
vim.opt.ignorecase = true -- ignore case in search patterns
vim.opt.smartcase = true -- no ignore case when pattern has uppercase

-- vim: ts=2 sts=2 sw=2 et
