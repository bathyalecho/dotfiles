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

  -- LSP (using native Neovim 0.11+ API)
  {
    "hrsh7th/cmp-nvim-lsp",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Python (pyright)
      vim.lsp.config("pyright", {
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
            },
          },
        },
      })

      -- HTML
      vim.lsp.config("html", {
        capabilities = capabilities,
      })

      -- CSS
      vim.lsp.config("cssls", {
        capabilities = capabilities,
      })

      -- JavaScript/TypeScript
      vim.lsp.config("ts_ls", {
        capabilities = capabilities,
      })

      -- Enable all configured LSP servers
      vim.lsp.enable({ "pyright", "html", "cssls", "ts_ls" })

      -- LSP keymaps
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover docs" })
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
      vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
    end,
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
      })
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
	"sql",
	"c++",
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
