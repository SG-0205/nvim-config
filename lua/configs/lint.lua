local lint = require "lint"

lint.linters.cppcheck.cmd =
  { "cppcheck", "--check-level=exhaustive", "--enable=all", "--inconclusive", "--quiet", "--template=gcc" }

lint.linters_by_ft = {
  cpp = { "cpplint", "cppcheck" },
}

vim.api.nvim_create_autocmd({ "TextChangedP", "TextChangedI", "TextChanged", "BufEnter" }, {
  callback = function()
    -- try_lint without arguments runs the linters defined in `linters_by_ft`
    -- for the current filetype
    lint.try_lint()
  end,
})
