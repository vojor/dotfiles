return {
    -- Code completion
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            {
                "garymjr/nvim-snippets",
                opts = {
                    friendly_snippets = true,
                    global_snippets = { "all", "global" },
                    extended_filetypes = {
                        typescript = { "javascript" },
                        typescriptreact = { "javascript" },
                        javascriptreact = { "javascript" },
                    },
                    search_paths = { vim.fn.stdpath("config") .. "/snippets" },
                },
                dependencies = { "rafamadriz/friendly-snippets" },
            },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-cmdline" },
            { url = "https://codeberg.org/FelipeLema/cmp-async-path" },
            { "lukas-reineke/cmp-rg" },
            { "f3fora/cmp-spell" },
            { "SergioRibera/cmp-dotenv" },
        },
        opts = function()
            local defaults = require("cmp.config.default")()
            local cmp = require("cmp")
            local auto_select = true
            vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
            local has_words_before = function()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end
            local feedkey = function(key, mode)
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
            end

            return {
                auto_brackets = {},
                completion = {
                    completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
                },
                preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
                snippet = {
                    expand = function(args)
                        vim.snippet.expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "snippets" },
                    { name = "async_path" },
                    { name = "buffer" },
                    { name = "rg", keyword_length = 3 },
                    { name = "spell" },
                    { name = "dotenv" },
                    { name = "lazydev", group_index = 0 },
                }),
                formatting = {
                    format = function(entry, vim_item)
                        vim_item.kind = string.format("%s %s", GionConfig.icons.kinds[vim_item.kind], vim_item.kind)
                        vim_item.menu = ({
                            async_path = "[Path]",
                            buffer = "[Buffer]",
                            cmdline = "[Cmdline]",
                            snippets = "[Snippets]",
                            nvim_lsp = "[LSP]",
                            rg = "[Rg]",
                            spell = "[Spell]",
                            dotenv = "[Dotenv]",
                            lazydev = "[Lazydev]",
                        })[entry.source.name]
                        return vim_item
                    end,
                },
                experimental = {
                    ghost_text = {
                        hl_group = "CmpGhostText",
                    },
                },
                sorting = defaults.sorting,

                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<S-CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }),
                    ["<C-CR>"] = function(fallback)
                        cmp.abort()
                        fallback()
                    end,
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if vim.snippet.active({ direction = 1 }) then
                            feedkey("<cmd>lua vim.snippet.jump(1)<CR>", "")
                        elseif cmp.visible() then
                            cmp.select_next_item()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function()
                        if vim.snippet.active({ direction = -1 }) then
                            feedkey("<cmd>lua vim.snippet.jump(-1)<CR>", "")
                        elseif cmp.visible() then
                            cmp.select_prev_item()
                        end
                    end, { "i", "s" }),
                }),
            }
        end,
        config = function(_, opts)
            local cmp = require("cmp")
            for _, source in ipairs(opts.sources) do
                source.group_index = source.group_index or 1
            end
            cmp.setup(opts)

            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "async_path" },
                }, {
                    { name = "cmdline" },
                }),
                matching = { disallow_symbol_nonprefix_matching = false },
            })

            cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
        end,
    },
}
