--
-- Built with,
--
--        ,gggg,
--       d8" "8I                         ,dPYb,
--       88  ,dP                         IP'`Yb
--    8888888P"                          I8  8I
--       88                              I8  8'
--       88        gg      gg    ,g,     I8 dPgg,
--  ,aa,_88        I8      8I   ,8'8,    I8dP" "8I
-- dP" "88P        I8,    ,8I  ,8'  Yb   I8P    I8
-- Yb,_,d88b,,_   ,d8b,  ,d8b,,8'_   8) ,d8     I8,
--  "Y8P"  "Y888888P'"Y88P"`Y8P' "YY8P8P88P     `Y8
--

-- This is a starter colorscheme for use with Lush,
-- for usage guides, see :h lush or :LushRunTutorial

--
-- Note: Because this is a lua file, vim will append it to the runtime,
--       which means you can require(...) it in other lua code (this is useful),
--       but you should also take care not to conflict with other libraries.
--
--       (This is a lua quirk, as it has somewhat poor support for namespacing.)
--
--       Basically, name your file,
--
--       "super_theme/lua/lush_theme/super_theme_dark.lua",
--
--       not,
--
--       "super_theme/lua/dark.lua".
--
--       With that caveat out of the way...
--

-- Enable lush.ify on this file, run:
--
--  `:Lushify`
--
--  or
--
--  `:lua require('lush').ify()`

local lush = require 'lush'
local hsl = lush.hsl

-- inspired on the palette from tokyonight
-- to make sure I have a wide range of colors
local palette = {
  fg_contrast = hsl(0, 0, 100),
  fg = hsl(0, 0, 93),
  fg2 = hsl(0, 0, 86),
  fg3 = hsl(0, 0, 73),
  fg4 = hsl(0, 0, 66),
  fg5 = hsl(0, 0, 59),
  bg_contrast = hsl(0, 0, 0),
  bg = hsl(0, 0, 12),
  bg2 = hsl(0, 0, 15),
  bg3 = hsl(0, 0, 17),
  bg4 = hsl(0, 0, 20),
  bg5 = hsl(0, 0, 23),
  bg6 = hsl(0, 0, 33),
  blue = {
    fg = hsl(236, 100, 90),
    fg2 = hsl(236, 81, 92),
    fg3 = hsl(236, 78, 96),
    fg4 = hsl(236, 78, 98),
    fg5 = hsl(236, 78, 100),
    fg6 = hsl(236, 78, 100),
    bg = hsl(236, 100, 20),
    bg2 = hsl(236, 100, 30),
    bg3 = hsl(236, 100, 40),
    bg4 = hsl(236, 100, 50),
    bg5 = hsl(236, 100, 60),
    bg6 = hsl(236, 100, 70),
  },
  red = {
    fg = hsl(0, 100, 80),
    fg2 = hsl(0, 100, 85),
    fg3 = hsl(0, 100, 90),
    bg = hsl(0, 100, 20),
  },
  green = {
    fg = hsl(113, 64, 82),
    bg = hsl(113, 64, 20),
  },
  yellow = {
    fg = hsl(45, 100, 10),
    fg2 = hsl(45, 100, 90),
    bg = hsl(45, 100, 55),
    bg2 = hsl(45, 100, 30),
  },
  cyan = {
    fg = hsl(180, 100, 80),
    bg = hsl(180, 100, 20),
  },
  magenta = {
    fg = hsl(300, 100, 80),
    fg2 = hsl(300, 100, 85),
    bg = hsl(300, 100, 20),
  },
  purple = {
    fg = hsl(270, 100, 80),
    bg = hsl(270, 100, 20),
  },
  orange = {
    fg = hsl(30, 100, 80),
    fg2 = hsl(30, 100, 85),
    bg = hsl(30, 100, 20),
    bg2 = hsl(30, 100, 30),
  },
  teal = {
    fg = hsl(180, 100, 80),
    bg = hsl(180, 100, 20),
  },
  comment = hsl(0, 0, 40),

  git = {
    added = {
      fg = hsl(113, 64, 62),
      bg = hsl(113, 64, 20),
    },
    changed = {
      fg = hsl(45, 100, 50),
      bg = hsl(45, 100, 20),
    },
    removed = {
      fg = hsl(0, 100, 50),
      bg = hsl(0, 100, 20),
    },
    text = {
      fg = hsl(180, 100, 50),
      bg = hsl(180, 100, 20),
    },
  },
}

-- LSP/Linters mistakenly show `undefined global` errors in the spec, they may
-- support an annotation like the following. Consult your server documentation.
---@diagnostic disable: undefined-global
local theme = lush(function(injected_functions)
  local sym = injected_functions.sym
  return {
    -- The following are the Neovim (as of 0.8.0-dev+100-g371dfb174) highlight
    -- groups, mostly used for styling UI elements.
    -- Comment them out and add your own properties to override the defaults.
    -- An empty definition `{}` will clear all styling, leaving elements looking
    -- like the 'Normal' group.
    -- To be able to link to a group, it must already be defined, so you may have
    -- to reorder items as you go.
    --
    -- See :h highlight-groups
    --
    ColorColumn {
      fg = palette.fg3,
      bg = palette.bg4,
    }, -- used for the columns set with 'colorcolumn'
    Conceal {
      fg = palette.bg4,
    }, -- Placeholder characters substituted for concealed text (see 'conceallevel')
    Cursor {
      bg = palette.bg,
      fg = palette.fg,
    }, -- Character under the cursor
    CurSearch {
      fg = palette.yellow.fg,
      bg = palette.yellow.bg,
    }, -- Highlighting a search pattern under the cursor (see 'hlsearch')
    lCursor {
      fg = palette.bg,
      bg = palette.fg,
    }, -- Character under the cursor when |language-mapping| is used (see 'guicursor')
    CursorIM {
      fg = palette.fg,
      bg = palette.bg,
    }, -- Like Cursor, but used when in IME mode |CursorIM|
    CursorColumn {
      fg = palette.fg5,
      bg = palette.bg5,
    }, -- Screen-column at the cursor, when 'cursorcolumn' is set.
    CursorLine {
      fg = palette.fg5,
      bg = palette.bg5,
    }, -- Screen-line at the cursor, when 'cursorline' is set. Low-priority if foreground (ctermfg OR guifg) is not set.
    Directory {
      fg = palette.blue.fg2,
    }, -- Directory names (and other special names in listings)
    DiffAdd {
      fg = palette.git.added.fg,
      bg = palette.git.added.bg,
    }, -- Diff mode: Added line |diff.txt|
    DiffChange {
      fg = palette.git.changed.fg,
      bg = palette.git.changed.bg,
    }, -- Diff mode: Changed line |diff.txt|
    DiffDelete {
      fg = palette.git.removed.fg,
      bg = palette.git.removed.bg,
    }, -- Diff mode: Deleted line |diff.txt|
    DiffText {
      fg = palette.git.text.fg,
      bg = palette.git.text.bg,
    }, -- Diff mode: Changed text within a changed line |diff.txt|
    EndOfBuffer {
      fg = palette.bg5,
    }, -- Filler lines (~) after the end of the buffer. By default, this is highlighted like |hl-NonText|.
    TermCursor {
      fg = palette.fg,
      bg = palette.bg5,
    }, -- Cursor in a focused terminal
    TermCursorNC {
      fg = palette.fg5,
    }, -- Cursor in an unfocused terminal
    ErrorMsg {
      fg = palette.red.fg,
    }, -- Error messages on the command line
    VertSplit {
      fg = palette.fg,
    }, -- Column separating vertically split windows
    Folded {
      fg = palette.fg5,
      bg = palette.bg5,
    }, -- Line used for closed folds
    FoldColumn {
      fg = palette.bg6,
    }, -- 'foldcolumn'
    SignColumn {
      fg = palette.bg6,
    }, -- Column where |signs| are displayed
    IncSearch {
      fg = palette.yellow.fg,
      bg = palette.yellow.bg,
    }, -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
    Substitute {
      fg = palette.yellow.fg2,
      bg = palette.yellow.bg2,
    }, -- |:substitute| replacement text highlighting
    LineNr {
      fg = palette.fg5,
    }, -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
    LineNrAbove {
      fg = palette.fg5,
    }, -- Line number for when the 'relativenumber' option is set, above the cursor line
    LineNrBelow {
      fg = palette.fg5,
    }, -- Line number for when the 'relativenumber' option is set, below the cursor line
    CursorLineNr {
      fg = palette.fg3,
    }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
    CursorLineFold {
      fg = palette.fg5,
    }, -- Like FoldColumn when 'cursorline' is set for the cursor line
    CursorLineSign {
      fg = palette.fg5,
    }, -- Like SignColumn when 'cursorline' is set for the cursor line
    MatchParen {
      fg = palette.fg5,
      bg = palette.bg5,
    }, -- Character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
    ModeMsg {
      fg = palette.green.fg,
    }, -- 'showmode' message (e.g., "-- INSERT -- ")
    MsgArea {
      fg = palette.fg5,
    }, -- Area for messages and cmdline
    MsgSeparator {
      fg = palette.fg5,
      bg = palette.bg6,
    }, -- Separator for scrolled messages, `msgsep` flag of 'display'
    MoreMsg {
      fg = palette.orange.fg,
    }, -- |more-prompt|
    NonText {
      fg = palette.bg6,
    }, -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
    Normal {
      fg = palette.fg,
      bg = palette.bg,
    }, -- Normal text
    NormalFloat {
      fg = palette.fg2,
      bg = palette.bg3,
    }, -- Normal text in floating windows.
    FloatBorder {
      fg = palette.fg5,
      bg = palette.bg3,
    }, -- Border of floating windows.
    FloatTitle {
      fg = palette.blue.fg,
      bg = palette.bg3,
      bold = true,
    }, -- Title of floating windows.
    NormalNC {
      fg = palette.fg4,
    }, -- normal text in non-current windows
    Pmenu {
      fg = palette.fg3,
      bg = palette.bg5,
    }, -- Popup menu: Normal item.
    PmenuSel {
      fg = palette.fg_contrast,
      bg = palette.bg6,
    }, -- Popup menu: Selected item.
    PmenuKind {
      fg = palette.fg3,
      bg = palette.bg5,
    }, -- Popup menu: Normal item "kind"
    PmenuKindSel {
      fg = palette.fg_contrast,
      bg = palette.bg6,
    }, -- Popup menu: Selected item "kind"
    PmenuExtra {
      fg = palette.fg4,
      bg = palette.bg5,
    }, -- Popup menu: Normal item "extra text"
    PmenuExtraSel {
      fg = palette.fg_contrast,
      bg = palette.bg6,
    }, -- Popup menu: Selected item "extra text"
    PmenuSbar {
      fg = palette.fg5,
      bg = palette.bg5,
    }, -- Popup menu: Scrollbar.
    PmenuThumb {
      fg = palette.fg5,
      bg = palette.bg6,
      bold = true,
    }, -- Popup menu: Thumb of the scrollbar.
    Question {
      fg = palette.orange.fg2,
    }, -- |hit-enter| prompt and yes/no questions
    QuickFixLine {
      fg = palette.teal.fg,
    }, -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
    Search {
      fg = palette.yellow.fg2,
      bg = palette.yellow.bg2,
    }, -- Last search pattern highlighting (see 'hlsearch'). Also used for similar items that need to stand out.
    -- SpecialKey     { }, -- Unprintable characters: text displayed differently from what it really is. But not 'listchars' whitespace. |hl-Whitespace|
    -- SpellBad       { }, -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
    -- SpellCap       { }, -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
    -- SpellLocal     { }, -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
    -- SpellRare      { }, -- Word that is recognized by the spellchecker as one that is hardly ever used. |spell| Combined with the highlighting used otherwise.
    -- StatusLine     { }, -- Status line of current window
    -- StatusLineNC   { }, -- Status lines of not-current windows. Note: If this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
    -- TabLine        { }, -- Tab pages line, not active tab page label
    -- TabLineFill    { }, -- Tab pages line, where there are no labels
    -- TabLineSel     { }, -- Tab pages line, active tab page label
    -- Title          { }, -- Titles for output from ":set all", ":autocmd" etc.
    -- Visual         { }, -- Visual mode selection
    -- VisualNOS      { }, -- Visual mode selection when vim is "Not Owning the Selection".
    -- WarningMsg     { }, -- Warning messages
    -- Whitespace     { }, -- "nbsp", "space", "tab" and "trail" in 'listchars'
    -- Winseparator   { }, -- Separator between window splits. Inherts from |hl-VertSplit| by default, which it will replace eventually.
    -- WildMenu       { }, -- Current match in 'wildmenu' completion
    -- WinBar         { }, -- Window bar of current window
    -- WinBarNC       { }, -- Window bar of not-current windows

    -- Common vim syntax groups used for all kinds of code and markup.
    -- Commented-out groups should chain up to their preferred (*) group
    -- by default.
    --
    -- See :h group-name
    --
    -- Uncomment and edit if you want more specific syntax highlighting.

    Comment {
      fg = palette.comment,
    }, -- Any comment

    -- Constant       { }, -- (*) Any constant
    String {
      fg = palette.green.fg,
    }, --   A string constant: "this is a string"
    -- Character      { }, --   A character constant: 'c', '\n'
    -- Number         { }, --   A number constant: 234, 0xff
    -- Boolean        { }, --   A boolean constant: TRUE, false
    -- Float          { }, --   A floating point constant: 2.3e10

    Identifier {
      fg = palette.blue.fg,
    }, -- (*) Any variable name
    -- Function       { }, --   Function name (also: methods for classes)

    -- Statement      { }, -- (*) Any statement
    -- Conditional    { }, --   if, then, else, endif, switch, etc.
    -- Repeat         { }, --   for, do, while, etc.
    -- Label          { }, --   case, default, etc.
    -- Operator       { }, --   "sizeof", "+", "*", etc.
    -- Keyword        { }, --   any other keyword
    -- Exception      { }, --   try, catch, throw

    -- PreProc        { }, -- (*) Generic Preprocessor
    -- Include        { }, --   Preprocessor #include
    -- Define         { }, --   Preprocessor #define
    -- Macro          { }, --   Same as Define
    -- PreCondit      { }, --   Preprocessor #if, #else, #endif, etc.

    -- Type           { }, -- (*) int, long, char, etc.
    -- StorageClass   { }, --   static, register, volatile, etc.
    -- Structure      { }, --   struct, union, enum, etc.
    -- Typedef        { }, --   A typedef

    -- Special        { }, -- (*) Any special symbol
    -- SpecialChar    { }, --   Special character in a constant
    -- Tag            { }, --   You can use CTRL-] on this
    -- Delimiter      { }, --   Character that needs attention
    -- SpecialComment { }, --   Special things inside a comment (e.g. '\n')
    -- Debug          { }, --   Debugging statements

    -- Underlined     { gui = "underline" }, -- Text that stands out, HTML links
    -- Ignore         { }, -- Left blank, hidden |hl-Ignore| (NOTE: May be invisible here in template)
    -- Error          { }, -- Any erroneous construct
    -- Todo           { }, -- Anything that needs extra attention; mostly the keywords TODO FIXME and XXX

    -- These groups are for the native LSP client and diagnostic system. Some
    -- other LSP clients may use these groups, or use their own. Consult your
    -- LSP client's documentation.

    -- See :h lsp-highlight, some groups may not be listed, submit a PR fix to lush-template!
    --
    -- LspReferenceText            { } , -- Used for highlighting "text" references
    -- LspReferenceRead            { } , -- Used for highlighting "read" references
    -- LspReferenceWrite           { } , -- Used for highlighting "write" references
    -- LspCodeLens                 { } , -- Used to color the virtual text of the codelens. See |nvim_buf_set_extmark()|.
    -- LspCodeLensSeparator        { } , -- Used to color the seperator between two or more code lens.
    -- LspSignatureActiveParameter { } , -- Used to highlight the active parameter in the signature help. See |vim.lsp.handlers.signature_help()|.

    -- See :h diagnostic-highlights, some groups may not be listed, submit a PR fix to lush-template!
    --
    -- DiagnosticError            { } , -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
    -- DiagnosticWarn             { } , -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
    -- DiagnosticInfo             { } , -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
    -- DiagnosticHint             { } , -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
    -- DiagnosticOk               { } , -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
    -- DiagnosticVirtualTextError { } , -- Used for "Error" diagnostic virtual text.
    -- DiagnosticVirtualTextWarn  { } , -- Used for "Warn" diagnostic virtual text.
    -- DiagnosticVirtualTextInfo  { } , -- Used for "Info" diagnostic virtual text.
    -- DiagnosticVirtualTextHint  { } , -- Used for "Hint" diagnostic virtual text.
    -- DiagnosticVirtualTextOk    { } , -- Used for "Ok" diagnostic virtual text.
    -- DiagnosticUnderlineError   { } , -- Used to underline "Error" diagnostics.
    -- DiagnosticUnderlineWarn    { } , -- Used to underline "Warn" diagnostics.
    -- DiagnosticUnderlineInfo    { } , -- Used to underline "Info" diagnostics.
    -- DiagnosticUnderlineHint    { } , -- Used to underline "Hint" diagnostics.
    -- DiagnosticUnderlineOk      { } , -- Used to underline "Ok" diagnostics.
    -- DiagnosticFloatingError    { } , -- Used to color "Error" diagnostic messages in diagnostics float. See |vim.diagnostic.open_float()|
    -- DiagnosticFloatingWarn     { } , -- Used to color "Warn" diagnostic messages in diagnostics float.
    -- DiagnosticFloatingInfo     { } , -- Used to color "Info" diagnostic messages in diagnostics float.
    -- DiagnosticFloatingHint     { } , -- Used to color "Hint" diagnostic messages in diagnostics float.
    -- DiagnosticFloatingOk       { } , -- Used to color "Ok" diagnostic messages in diagnostics float.
    -- DiagnosticSignError        { } , -- Used for "Error" signs in sign column.
    -- DiagnosticSignWarn         { } , -- Used for "Warn" signs in sign column.
    -- DiagnosticSignInfo         { } , -- Used for "Info" signs in sign column.
    -- DiagnosticSignHint         { } , -- Used for "Hint" signs in sign column.
    -- DiagnosticSignOk           { } , -- Used for "Ok" signs in sign column.

    -- Tree-Sitter syntax groups.
    --
    -- See :h treesitter-highlight-groups, some groups may not be listed,
    -- submit a PR fix to lush-template!
    --
    -- Tree-Sitter groups are defined with an "@" symbol, which must be
    -- specially handled to be valid lua code, we do this via the special
    -- sym function. The following are all valid ways to call the sym function,
    -- for more details see https://www.lua.org/pil/5.html
    --
    -- sym("@text.literal")
    -- sym('@text.literal')
    -- sym"@text.literal"
    -- sym'@text.literal'
    --
    -- For more information see https://github.com/rktjmp/lush.nvim/issues/109

    -- sym"@text.literal"      { }, -- Comment
    -- sym"@text.reference"    { }, -- Identifier
    -- sym"@text.title"        { }, -- Title
    -- sym"@text.uri"          { }, -- Underlined
    -- sym"@text.underline"    { }, -- Underlined
    -- sym"@text.todo"         { }, -- Todo
    -- sym"@comment"           { }, -- Comment
    -- sym"@punctuation"       { }, -- Delimiter
    -- sym"@constant"          { }, -- Constant
    -- sym"@constant.builtin"  { }, -- Special
    -- sym"@constant.macro"    { }, -- Define
    -- sym"@define"            { }, -- Define
    -- sym"@macro"             { }, -- Macro
    sym '@string' {
      fg = palette.green.fg,
    }, -- String
    -- sym"@string.escape"     { }, -- SpecialChar
    -- sym"@string.special"    { }, -- SpecialChar
    -- sym"@character"         { }, -- Character
    -- sym"@character.special" { }, -- SpecialChar
    -- sym"@number"            { }, -- Number
    -- sym"@boolean"           { }, -- Boolean
    -- sym"@float"             { }, -- Float
    -- sym"@function"          { }, -- Function
    -- sym"@function.builtin"  { }, -- Special
    -- sym"@function.macro"    { }, -- Macro
    -- sym"@parameter"         { }, -- Identifier
    -- sym"@method"            { }, -- Function
    -- sym"@field"             { }, -- Identifier
    sym '@property' {
      fg = palette.blue.fg,
    }, -- Identifier
    -- sym"@constructor"       { }, -- Special
    -- sym"@conditional"       { }, -- Conditional
    -- sym"@repeat"            { }, -- Repeat
    -- sym"@label"             { }, -- Label
    -- sym"@operator"          { }, -- Operator
    -- sym"@keyword"           { }, -- Keyword
    -- sym"@exception"         { }, -- Exception
    -- sym"@variable"          { }, -- Identifier
    -- sym"@type"              { }, -- Type
    -- sym"@type.definition"   { }, -- Typedef
    -- sym"@storageclass"      { }, -- StorageClass
    -- sym"@structure"         { }, -- Structure
    -- sym"@namespace"         { }, -- Identifier
    -- sym"@include"           { }, -- Include
    -- sym"@preproc"           { }, -- PreProc
    -- sym"@debug"             { }, -- Debug
    -- sym"@tag"               { }, -- Tag
  }
end)

-- Return our parsed theme for extension or use elsewhere.
return theme

-- vi:nowrap
