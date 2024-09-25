return {
  {
    'ahmedkhalf/project.nvim',
    config = function()
      require('project_nvim').setup {
        patterns = { '.git', 'CMakeLists.txt', '.clang-format', 'compile_flags.txt', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json' },
      }
      require('nvim-tree').setup {
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = true,
        },
      }
    end,
  },
}
