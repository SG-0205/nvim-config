require("lspconfig").clangd.setup {
  settings = {
    clangd = {
      cmd = { "clangd", "--query-driver=/usr/bin/clang++,/usr/bin/g++" },
      InlayHints = {
        Designators = true,
        Enabled = true,
        ParameterNames = true,
        DeducedTypes = true,
      },
      fallbackFlags = { "-std=c++20" },
    },
  },
}
