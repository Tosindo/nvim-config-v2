return {
  {
    'pmizio/typescript-tools.nvim',
    dependencies = {
      'artemave/workspace-diagnostics.nvim',
      'nvim-lua/plenary.nvim',
      'neovim/nvim-lspconfig',
      'oleggulevskyy/better-ts-errors.nvim',
    },
    ft = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
    },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      require('better-ts-errors').setup {
        enable_prettify = true,
      }

      local parser = require 'better-ts-errors.parser'
      local codes = require 'better-ts-errors.util.codes'
      local severity = require 'better-ts-errors.util.severity'
      local strings_utils = require 'better-ts-errors.util.strings'

      local format = function(diag)
        local sev = severity.get_severity(diag.severity)
        local code = codes.get_code(diag.code)
        local message = diag.message

        local header = string.format('%s %s\n\n', sev, code)

        local body_lines = strings_utils.break_new_lines(message)
        -- Ensure at least 2 rows for each message
        if #body_lines < 2 then
          table.insert(body_lines, '') -- Add an extra empty line
        end

        local new_body_lines = {}
        local vars = {}
        local added_lines_count = 0
        local prettified_lines = {}

        local line_index = 0
        for _, line in ipairs(body_lines) do
          local temp_vars = parser.get_variable_pos(line, line_index)
          local has_raw_object = false
          local identation_size = strings_utils.get_padding(line)

          for _, temp_var in ipairs(temp_vars) do
            if temp_var.is_raw_object then
              has_raw_object = true

              -- Split the line into two parts
              local part1 = string.sub(line, 1, temp_var.col_start)
              local part2 = string.sub(line, temp_var.col_end + 1)

              -- Calculate start position for prettified lines
              -- Determine the starting row for the prettified lines
              local prettified_start = #new_body_lines

              -- Insert the first part into new_body_lines
              if part1 ~= '' then
                table.insert(new_body_lines, part1)
              end

              -- Insert the prettified lines
              local lines = strings_utils.break_new_lines(temp_var.match)

              for _, l in ipairs(lines) do
                table.insert(new_body_lines, string.rep(' ', identation_size) .. l)
              end

              table.insert(prettified_lines, {
                line_start = prettified_start + 2, -- +2 for the header
                line_end = prettified_start + #lines - 1,
                indentation = identation_size,
              })

              -- Insert the second part into new_body_lines
              if part2 ~= '' and part2 ~= '.' then
                table.insert(new_body_lines, string.rep(' ', identation_size) .. part2)
              end

              added_lines_count = added_lines_count + #lines - 1
            else
              table.insert(vars, temp_var)
            end
          end

          -- If the line does not contain a raw object, add it as is
          if not has_raw_object then
            table.insert(new_body_lines, line)
          end

          line_index = line_index + 1
        end

        body_lines = new_body_lines

        return header .. table.concat(body_lines, '\n')
      end

      require('typescript-tools').setup {
        on_attach = function(client, bufnr)
          -- require('workspace-diagnostics').populate_workspace_diagnostics(client, bufnr)
          vim.keymap.set('n', '<leader>lo', '<cmd>TSToolsOrganizeImports<cr>', { buffer = bufnr, desc = 'Organize Imports' })
          vim.keymap.set('n', '<leader>lO', '<cmd>TSToolsSortImports<cr>', { buffer = bufnr, desc = 'Sort Imports' })
          vim.keymap.set('n', '<leader>lu', '<cmd>TSToolsRemoveUnused<cr>', { buffer = bufnr, desc = 'Removed Unused' })
          vim.keymap.set('n', '<leader>lz', '<cmd>TSToolsGoToSourceDefinition<cr>', { buffer = bufnr, desc = 'Go To Source Definition' })
          vim.keymap.set('n', '<leader>lR', '<cmd>TSToolsRemoveUnusedImports<cr>', { buffer = bufnr, desc = 'Removed Unused Imports' })
          vim.keymap.set('n', '<leader>lF', '<cmd>TSToolsFixAll<cr>', { buffer = bufnr, desc = 'Fix All' })
          vim.keymap.set('n', '<leader>lA', '<cmd>TSToolsAddMissingImports<cr>', { buffer = bufnr, desc = 'Add Missing Imports' })
        end,
        capabilities = capabilities,
        settings = {
          tsserver_file_preferences = {
            includeInlayParameterNameHints = 'all',
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
          expose_as_code_action = 'all',
          complete_function_calls = true,
          tsserver_plugins = {
            '@styled/typescript-styled-plugin',
          },
        },
        handlers = {
          ['textDocument/publishDiagnostics'] = function(_, result, ctx, config)
            if result.diagnostics == nil then
              return
            end

            -- ignore some tsserver diagnostics
            local idx = 1
            while idx <= #result.diagnostics do
              local entry = result.diagnostics[idx]

              entry.message = format(entry)

              -- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
              if entry.code == 80001 then
                -- { message = "File is a CommonJS module; it may be converted to an ES module.", }
                table.remove(result.diagnostics, idx)
              else
                idx = idx + 1
              end
            end

            vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
          end,
        },
      }
    end,
  },
  -- {
  --   'yioneko/nvim-vtsls',
  --   lazy = true,
  --   event = 'BufReadPre',
  --   ft = {
  --     'javascript',
  --     'javascriptreact',
  --     'javascript.jsx',
  --     'typescript',
  --     'typescriptreact',
  --     'typescript.tsx',
  --   },
  -- },
  -- {
  --   'dmmulroy/tsc.nvim',
  --   opts = {},
  -- },
}
