local function get_env_or_nil(var_name)
    local value = os.getenv(var_name)
    return value ~= "" and value or nil
end

local nix_env = {
  gcc_bin_path = os.getenv("NEOVIM_GCC_BIN_PATH"),
  sqlite_clib_path = os.getenv("NEOVIM_SQLITE_CLIB_PATH"),
  mason_wrapper = os.getenv("MASON_NVIM_WRAPPER")
}


function nix_env.setup()
    if nix_env.gcc_bin_path then
        vim.g.gcc_bin_path = nix_env.gcc_bin_path
    end

    if nix_env.sqlite_clib_path then
        vim.g.sqlite_clib_path = nix_env.sqlite_clib_path
    end
end


function nix_env.wrap_mason_binary(cmd)
    if nix_env.mason_wrapper ~= "" then
        return { nix_env.mason_wrapper, cmd }
    else
        return { cmd }
    end
end

return nix_env
