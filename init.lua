local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      vim.o.background = "light"
      vim.cmd("colorscheme gruvbox")
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup()
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
          },
        },
        renderers = {
          directory = {
            { "indent" },
            { "icon" },
            { "current_filter" },
            {
              "container",
              content = {
                { "name", zindex = 10 },
                { "symlink_target", zindex = 10, highlight = "NeoTreeSymbolicLinkTarget" },
                { "clipboard", zindex = 10 },
                { "diagnostics", errors_only = true, zindex = 20, align = "right", hide_when_expanded = true },
                { "git_status", zindex = 10, align = "right", hide_when_expanded = true },
              },
            },
          },
          file = {
            { "indent" },
            { "icon" },
            {
              "container",
              content = {
                { "name", zindex = 10 },
                { "symlink_target", zindex = 10, highlight = "NeoTreeSymbolicLinkTarget" },
                { "clipboard", zindex = 10 },
                { "bufnr", zindex = 10 },
                { "modified", zindex = 20, align = "right" },
                { "diagnostics", zindex = 20, align = "right" },
                { "git_status", zindex = 10, align = "right" },
              },
            },
          },
        },
      })
    end,
  },
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup()
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup()
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
    },
    config = function()
      require("telescope").setup()
      require("telescope").load_extension("file_browser")
    end,
  },
  {
    "2kabhishek/seeker.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    cmd = { "Seeker" },
    opts = {
      picker_provider = "telescope",
    },
  },
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        "NEOVIM",
      }

      dashboard.section.buttons.val = {
        dashboard.button("e", "  Toggle Neo-tree (file tree)", ":Neotree toggle<CR>"),
        dashboard.button("-", "  Open Oil (edit directory as buffer)", ":Oil<CR>"),
        dashboard.button("<leader>ff", "  Find files (Telescope)", ":Telescope find_files<CR>"),
        dashboard.button("<leader>fb", "  Browse files/folders (Telescope)", ":Telescope file_browser<CR>"),
        dashboard.button("<leader>sa", "  Seek files (Seeker)", ":Seeker files<CR>"),
        dashboard.button("<leader>sf", "  Seek git files (Seeker)", ":Seeker git_files<CR>"),
        dashboard.button("<leader>sg", "  Seek grep / content search (Seeker)", ":Seeker grep<CR>"),
        dashboard.button("<leader>sw", "  Seek grep word under cursor (Seeker)", ":Seeker grep_word<CR>"),
        dashboard.button("<leader>pp", "  Switch project directory (cd-project)", ":CdProject<CR>"),
        dashboard.button("<leader>pa", "  Add current dir as project (cd-project)", ":CdProjectAdd<CR>"),
        dashboard.button("<leader>pb", "  Switch to previous project (cd-project)", ":CdProjectBack<CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }

      alpha.setup(dashboard.opts)
    end,
  },
  {
    "LintaoAmons/cd-project.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    cmd = {
      "CdProject",
      "CdProjectAdd",
      "CdProjectBack",
      "CdProjectManualAdd",
      "CdProjectSearchAndAdd",
      "CdProjectDelete",
      "CdProjectPrune",
      "CdProjectScan",
    },
    config = function()
      -- Your ~/.gitignore ignores everything ("*"), and fd respects .gitignore
      -- by default, which silently empties CdProjectSearchAndAdd's results
      -- since it searches from $HOME. --no-ignore-vcs skips .gitignore rules
      -- without touching your dotfiles' ignore setup.
      local ok, cd_utils = pcall(require, "cd-project.utils")
      if ok then
        cd_utils.check_for_find_cmd = function()
          if vim.fn.executable("fd") == 1 then
            return "fd --type d --hidden --no-ignore-vcs --max-depth 5"
              .. " -E Library -E .local -E .cache -E node_modules -E .venv -E venv"
              .. " -E .git -E __pycache__ -E target -E dist -E build"
              .. " -E .npm -E .nvm -E .cargo -E .rustup -E .Trash . ~"
          elseif vim.fn.executable("find") == 1 then
            return { "find", ".", "-type", "d", "-not", "-path", "*/.git*" }
          end
        end
      end

      require("cd-project").setup({
        projects_picker = "telescope",
      })
    end,
  },
})



vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.termguicolors = true

vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
vim.keymap.set("n", "-", ":Oil<CR>", { desc = "Open parent directory in Oil" })
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files (fuzzy)" })
vim.keymap.set("n", "<leader>fb", ":Telescope file_browser<CR>", { desc = "Browse files/folders (fuzzy)" })
vim.keymap.set("n", "<leader>sa", ":Seeker files<CR>", { desc = "Seek files" })
vim.keymap.set("n", "<leader>sf", ":Seeker git_files<CR>", { desc = "Seek git files" })
vim.keymap.set("n", "<leader>sg", ":Seeker grep<CR>", { desc = "Seek grep" })
vim.keymap.set("n", "<leader>sw", ":Seeker grep_word<CR>", { desc = "Seek grep word under cursor" })
vim.keymap.set("n", "<leader>pp", ":CdProject<CR>", { desc = "Switch project directory" })
vim.keymap.set("n", "<leader>pa", ":CdProjectAdd<CR>", { desc = "Add current directory as project" })
vim.keymap.set("n", "<leader>pb", ":CdProjectBack<CR>", { desc = "Switch to previous project" })
vim.keymap.set("n", "<leader>ps", ":CdProjectSearchAndAdd<CR>", { desc = "Search $HOME and add a project" })
