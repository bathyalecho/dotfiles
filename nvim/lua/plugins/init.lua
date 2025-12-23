return {
  -- Colorscheme (load first)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({})
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- File explorer
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

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup()
      vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>')
      vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>')
    end,
  },

  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- Register custom parsers before any install operations
      local parsers = require("nvim-treesitter.parsers")

      parsers.ziggy = {
        install_info = {
          url = "https://github.com/kristoff-it/ziggy",
          includes = { "tree-sitter-ziggy/src" },
          files = { "tree-sitter-ziggy/src/parser.c" },
          branch = "main",
        },
        tier = 4,
      }

      parsers.ziggy_schema = {
        install_info = {
          url = "https://github.com/kristoff-it/ziggy",
          files = { "tree-sitter-ziggy-schema/src/parser.c" },
          branch = "main",
        },
        tier = 4,
      }

      parsers.supermd = {
        install_info = {
          url = "https://github.com/kristoff-it/supermd",
          includes = { "tree-sitter/supermd/src" },
          files = {
            "tree-sitter/supermd/src/parser.c",
            "tree-sitter/supermd/src/scanner.c",
          },
          branch = "main",
        },
        tier = 4,
      }

      parsers.supermd_inline = {
        install_info = {
          url = "https://github.com/kristoff-it/supermd",
          includes = { "tree-sitter/supermd-inline/src" },
          files = {
            "tree-sitter/supermd-inline/src/parser.c",
            "tree-sitter/supermd-inline/src/scanner.c",
          },
          branch = "main",
        },
        tier = 4,
      }

      parsers.superhtml = {
        install_info = {
          url = "https://github.com/kristoff-it/superhtml",
          includes = { "tree-sitter-superhtml/src" },
          files = {
            "tree-sitter-superhtml/src/parser.c",
            "tree-sitter-superhtml/src/scanner.c",
          },
          branch = "main",
        },
        tier = 4,
      }

      -- Set filetype associations
      vim.filetype.add({
        extension = {
          ziggy = "ziggy",
          supermd = "supermd",
          superhtml = "superhtml",
        },
        pattern = {
          [".*%.ziggy%-schema"] = "ziggy_schema",
        },
      })

      -- Install parsers (async, runs in background)
      require("nvim-treesitter").install({
        "julia",
        "rust",
        "go",
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      })

      -- Enable treesitter-based indentation (except for julia)
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          if args.match ~= "julia" then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
