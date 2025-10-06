return {

  {
    "0x00-ketsu/autosave.nvim",
    events = { "InsertLeave" },
    conditions = {
      exists = true,
      modifiable = true,
      filename_is_not = {},
      filetype_is_not = {},
    },
    write_all_buffers = false,
    debounce_delay = 135,
  },
}
