return {
  "saghen/blink.cmp",
  event = "InsertEnter",
  version = "1.*",
  dependencies = {
    "rafamadriz/friendly-snippets",
    { "Kaiser-Yang/blink-cmp-avante", version = false },
  },
  opts = {
    keymap = { preset = "default" },
    appearance = { use_nvim_cmp_as_default = true, nerd_font_variant = "mono" },
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "avante" },
      providers = {
        avante = {
          module = "blink-cmp-avante",
          name = "Avante",
          opts = {},
        },
      },
    },
    completion = { documentation = { auto_show = true } },
    signature = { enabled = true },
  },
}
