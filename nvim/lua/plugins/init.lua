return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        on_attach = function(bufnr)
          local api = require("nvim-tree.api")
          api.config.mappings.default_on_attach(bufnr)

          vim.keymap.set('n', '<leader>t', function()
            local node = api.tree.get_node_under_cursor()
            local path = node.type == "directory" and node.absolute_path or vim.fn.fnamemodify(node.absolute_path, ":h")
            vim.cmd("split | lcd " .. vim.fn.fnameescape(path) .. " | terminal")
          end, { buffer = bufnr, desc = "Open terminal in directory" })
        end,
      })
      vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>')
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup()
      vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>')
      vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>')
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "python", "javascript", "typescript", "rust", "go", "bash", "json", "yaml", "markdown", "html", "css" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}
