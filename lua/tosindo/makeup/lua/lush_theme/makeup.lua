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

local palette = {
  fg_contrast = hsl(0, 0, 100),
  fg = hsl(32, 30, 100),
  fg2 = hsl(32, 30, 90),
  fg3 = hsl(32, 30, 79),
  fg4 = hsl(32, 30, 66),
  fg5 = hsl(32, 30, 59),
  fg6 = hsl(32, 30, 52),
  bg_contrast = hsl(0, 0, 0),
  bg = hsl(32, 12, 8),
  bg2 = hsl(32, 24, 11),
  bg3 = hsl(32, 32, 13),
  bg4 = hsl(32, 44, 16),
  bg5 = hsl(32, 56, 19),
  bg6 = hsl(32, 67, 29),
  secondary = {
    fg = hsl(218, 92, 90),
    fg2 = hsl(218, 81, 92),
    fg3 = hsl(218, 78, 96),
    fg4 = hsl(218, 78, 98),
    fg5 = hsl(218, 78, 100),
    fg6 = hsl(218, 78, 100),
    bg = hsl(218, 100, 20),
    bg2 = hsl(218, 100, 30),
    bg3 = hsl(218, 100, 40),
    bg4 = hsl(218, 100, 50),
    bg5 = hsl(218, 100, 60),
    bg6 = hsl(218, 100, 70),
  },
  tertiary = {
    fg = hsl(261, 92, 84),
    fg2 = hsl(261, 81, 92),
    fg3 = hsl(261, 78, 96),
    fg4 = hsl(261, 78, 98),
    fg5 = hsl(261, 78, 100),
    fg6 = hsl(261, 78, 100),
    bg = hsl(261, 92, 20),
    bg2 = hsl(261, 92, 30),
    bg3 = hsl(261, 92, 40),
    bg4 = hsl(261, 92, 50),
    bg5 = hsl(261, 92, 60),
    bg6 = hsl(261, 92, 70),
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
    fg2 = hsl(45, 100, 70),
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
  teal = {
    fg = hsl(180, 100, 80),
    bg = hsl(180, 100, 20),
  },

  comment = hsl(0, 0, 40),

  menu = {
    bg = hsl(37, 100, 4),
    fg = hsl(37, 100, 90),
    scrollbar = {
      bg = hsl(37, 100, 10),
      thumb = hsl(37, 100, 20),
    },
  },

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
      bg = palette.bg3,
    }, -- Screen-line at the cursor, when 'cursorline' is set. Low-priority if foreground (ctermfg OR guifg) is not set.
    Directory {
      fg = palette.secondary.fg2,
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
      fg = palette.secondary.fg,
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
      fg = palette.secondary.fg,
      bg = palette.bg3,
      bold = true,
    }, -- Title of floating windows.
    NormalNC {
      fg = palette.fg4,
    }, -- normal text in non-current windows
    Pmenu {
      fg = palette.menu.fg,
      bg = palette.menu.bg,
    }, -- Popup menu: Normal item.
    PmenuSel {
      fg = palette.fg_contrast,
      bg = palette.menu.bg.lighten(10),
    }, -- Popup menu: Selected item.
    PmenuKind {
      fg = palette.menu.fg.darken(10),
      bg = palette.menu.bg.saturation(30),
    }, -- Popup menu: Normal item "kind"
    PmenuKindSel {
      fg = palette.fg_contrast,
      bg = palette.menu.bg.saturation(30).lighten(10),
    }, -- Popup menu: Selected item "kind"
    PmenuExtra {
      fg = palette.menu.fg.darken(30),
      bg = palette.menu.bg.lighten(10),
    }, -- Popup menu: Normal item "extra text"
    PmenuExtraSel {
      fg = palette.menu.fg.darken(30),
      bg = palette.menu.bg.lighten(5),
    }, -- Popup menu: Selected item "extra text"
    PmenuSbar {
      fg = palette.menu.scrollbar.bg.lighten(20),
      bg = palette.menu.scrollbar.bg,
    }, -- Popup menu: Scrollbar.
    PmenuThumb {
      fg = palette.menu.scrollbar.thumb.lighten(20),
      bg = palette.menu.scrollbar.thumb,
      bold = true,
    }, -- Popup menu: Thumb of the scrollbar.
    Question {
      fg = palette.secondary.fg2,
    }, -- |hit-enter| prompt and yes/no questions
    QuickFixLine {
      fg = palette.teal.fg,
    }, -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
    Search {
      fg = palette.yellow.fg2,
      bg = palette.yellow.bg2,
    }, -- Last search pattern highlighting (see 'hlsearch'). Also used for similar items that need to stand out.
    SpecialKey {
      fg = palette.bg6,
    }, -- Unprintable characters: text displayed differently from what it really is. But not 'listchars' whitespace. |hl-Whitespace|
    SpellBad {
      undercurl = true,
      sp = palette.red.fg,
    }, -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
    SpellCap {
      undercurl = true,
      sp = palette.yellow.fg2,
    }, -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
    SpellLocal {
      undercurl = true,
      sp = palette.green.fg,
    }, -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
    SpellRare {
      undercurl = true,
      sp = palette.secondary.fg,
    }, -- Word that is recognized by the spellchecker as one that is hardly ever used. |spell| Combined with the highlighting used otherwise.
    StatusLine {
      bg = palette.fg3,
      fg = palette.bg3,
    }, -- Status line of current window
    StatusLineNC {
      bg = palette.bg5,
      fg = palette.fg4,
    }, -- Status lines of not-current windows. Note: If this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
    TabLine {
      bg = palette.bg5,
      fg = palette.fg4,
    }, -- Tab pages line, not active tab page label
    TabLineFill {
      bg = palette.bg5,
      fg = palette.fg4,
    }, -- Tab pages line, where there are no labels
    TabLineSel {
      fg = palette.bg6,
    }, -- Tab pages line, active tab page label
    Title {
      fg = palette.fg,
      bold = true,
    }, -- Titles for output from ":set all", ":autocmd" etc.
    Visual {
      bg = palette.bg6,
      fg = palette.fg6,
    }, -- Visual mode selection
    VisualNOS {
      bg = palette.bg6,
      fg = palette.fg6,
    }, -- Visual mode selection when vim is "Not Owning the Selection".
    WarningMsg {
      fg = palette.yellow.fg2,
    }, -- Warning messages
    Whitespace {
      fg = palette.bg6,
    }, -- "nbsp", "space", "tab" and "trail" in 'listchars'
    Winseparator {
      bg = palette.bg,
      fg = palette.fg2,
    }, -- Separator between window splits. Inherts from |hl-VertSplit| by default, which it will replace eventually.
    WildMenu {
      bg = palette.bg4,
      fg = palette.fg,
    }, -- Current match in 'wildmenu' completion
    WinBar {
      bg = palette.bg5,
      fg = palette.fg4,
    }, -- Window bar of current window
    WinBarNC {
      bg = palette.bg5,
      fg = palette.fg4,
    }, -- Window bar of not-current windows

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

    Constant {
      fg = palette.secondary.bg6,
    }, -- (*) Any constant
    String {
      fg = palette.green.fg,
    }, --   A string constant: "this is a string"
    Character {
      fg = palette.green.fg.darken(20),
    }, --   A character constant: 'c', '\n'
    Number {
      fg = palette.fg6.saturation(80),
    }, --   A number constant: 234, 0xff
    Boolean {
      fg = palette.cyan.fg,
    }, --   A boolean constant: TRUE, false
    Float {
      fg = palette.fg6.saturation(80),
    }, --   A floating point constant: 2.3e10
    Identifier {
      fg = palette.secondary.fg,
    },

    Function {
      fg = palette.tertiary.bg6,
    }, --   Function name (also: methods for classes)

    Statement {
      fg = palette.secondary.fg3,
    }, -- (*) Any statement
    Conditional {
      fg = palette.secondary.fg3,
    }, --   if, then, else, endif, switch, etc.
    Repeat {
      fg = palette.secondary.fg3,
    }, --   for, do, while, etc.
    Label {
      fg = palette.secondary.fg3,
    }, --   case, default, etc.
    Operator {
      fg = palette.secondary.fg3,
    }, --   "sizeof", "+", "*", etc.
    Keyword {
      fg = palette.secondary.fg3.saturation(20).darken(30),
    }, --   any other keyword
    Exception {
      fg = palette.secondary.fg3,
    }, --   try, catch, throw

    PreProc {
      fg = palette.tertiary.fg2,
    }, -- (*) Generic Preprocessor
    Include {
      fg = palette.tertiary.fg2,
    }, --   Preprocessor #include
    Define {
      fg = palette.tertiary.fg2,
    }, --   Preprocessor #define
    Macro {
      fg = palette.tertiary.fg2,
    }, --   Same as Define
    PreCondit {
      fg = palette.tertiary.fg2,
    }, --   Preprocessor #if, #else, #endif, etc.

    Type {
      fg = palette.tertiary.fg,
    }, -- (*) int, long, char, etc.
    StorageClass {
      fg = palette.tertiary.fg,
    }, --   static, register, volatile, etc.
    Structure {
      fg = palette.tertiary.fg,
    }, --   struct, union, enum, etc.
    Typedef {
      fg = palette.tertiary.fg,
    }, --   A typedef

    Special {
      fg = palette.teal.fg,
    }, -- (*) Any special symbol
    SpecialChar {
      fg = palette.teal.fg,
    }, --   Special character in a constant
    Tag {
      fg = palette.teal.fg,
    }, --   You can use CTRL-] on this
    Delimiter {
      fg = palette.fg.lighten(20),
    }, --   Character that needs attention
    SpecialComment {
      fg = palette.teal.fg,
    }, --   Special things inside a comment (e.g. '\n')
    Debug {
      fg = palette.teal.fg,
    }, --   Debugging statements

    Underlined { gui = 'underline' }, -- Text that stands out, HTML links
    Ignore {}, -- Left blank, hidden |hl-Ignore| (NOTE: May be invisible here in template)
    Error {
      bg = palette.red.bg,
    }, -- Any erroneous construct
    Todo {
      bg = palette.purple.bg,
    }, -- Anything that needs extra attention; mostly the keywords TODO FIXME and XXX

    -- These groups are for the native LSP client and diagnostic system. Some
    -- other LSP clients may use these groups, or use their own. Consult your
    -- LSP client's documentation.

    -- See :h lsp-highlight, some groups may not be listed, submit a PR fix to lush-template!
    --
    LspReferenceText {
      bg = palette.bg6,
      fg = palette.fg2,
    }, -- Used for highlighting "text" references
    LspReferenceRead {
      bg = palette.bg6,
      fg = palette.fg2,
    }, -- Used for highlighting "read" references
    LspReferenceWrite {
      bg = palette.bg6,
      fg = palette.fg2,
    }, -- Used for highlighting "write" references
    LspCodeLens {
      fg = palette.fg5,
    }, -- Used to color the virtual text of the codelens. See |nvim_buf_set_extmark()|.
    LspCodeLensSeparator {
      fg = palette.fg6,
    }, -- Used to color the seperator between two or more code lens.
    LspSignatureActiveParameter {
      bg = palette.bg5,
      fg = palette.fg,
    }, -- Used to highlight the active parameter in the signature help. See |vim.lsp.handlers.signature_help()|.

    -- See :h diagnostic-highlights, some groups may not be listed, submit a PR fix to lush-template!
    --
    DiagnosticError {
      fg = palette.red.fg,
    }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
    DiagnosticWarn {
      fg = palette.yellow.fg2,
    }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
    DiagnosticInfo {
      fg = palette.secondary.fg,
    }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
    DiagnosticHint {
      fg = palette.tertiary.fg,
    }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
    DiagnosticOk {
      fg = palette.green.fg,
    }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
    DiagnosticVirtualTextError {
      fg = palette.red.fg,
    }, -- Used for "Error" diagnostic virtual text.
    DiagnosticVirtualTextWarn {
      fg = palette.yellow.fg2,
    }, -- Used for "Warn" diagnostic virtual text.
    DiagnosticVirtualTextInfo {
      fg = palette.secondary.fg,
    }, -- Used for "Info" diagnostic virtual text.
    DiagnosticVirtualTextHint {
      fg = palette.tertiary.fg,
    }, -- Used for "Hint" diagnostic virtual text.
    DiagnosticVirtualTextOk {
      fg = palette.green.fg,
    }, -- Used for "Ok" diagnostic virtual text.
    DiagnosticUnderlineError {
      underline = true,
      sp = palette.red.fg,
    }, -- Used to underline "Error" diagnostics.
    DiagnosticUnderlineWarn {
      underline = true,
      sp = palette.yellow.fg2,
    }, -- Used to underline "Warn" diagnostics.
    DiagnosticUnderlineInfo {
      underline = true,
      sp = palette.secondary.fg,
    }, -- Used to underline "Info" diagnostics.
    DiagnosticUnderlineHint {
      underline = true,
      sp = palette.tertiary.fg,
    }, -- Used to underline "Hint" diagnostics.
    DiagnosticUnderlineOk {
      underline = true,
      sp = palette.green.fg,
    }, -- Used to underline "Ok" diagnostics.
    DiagnosticFloatingError {
      fg = palette.red.fg,
    }, -- Used to color "Error" diagnostic messages in diagnostics float. See |vim.diagnostic.open_float()|
    DiagnosticFloatingWarn {
      fg = palette.yellow.fg2,
    }, -- Used to color "Warn" diagnostic messages in diagnostics float.
    DiagnosticFloatingInfo {
      fg = palette.secondary.fg,
    }, -- Used to color "Info" diagnostic messages in diagnostics float.
    DiagnosticFloatingHint {
      fg = palette.tertiary.fg,
    }, -- Used to color "Hint" diagnostic messages in diagnostics float.
    DiagnosticFloatingOk {
      fg = palette.green.fg,
    }, -- Used to color "Ok" diagnostic messages in diagnostics float.
    DiagnosticSignError {
      fg = palette.red.fg,
    }, -- Used for "Error" signs in sign column.
    DiagnosticSignWarn {
      fg = palette.yellow.fg2,
    }, -- Used for "Warn" signs in sign column.
    DiagnosticSignInfo {
      fg = palette.secondary.fg,
    }, -- Used for "Info" signs in sign column.
    DiagnosticSignHint {
      fg = palette.tertiary.fg,
    }, -- Used for "Hint" signs in sign column.
    DiagnosticSignOk {
      fg = palette.green.fg,
    }, -- Used for "Ok" signs in sign column.
    DiagnosticDeprecated {
      strikethrough = true,
      underdashed = true,
      sp = palette.fg6,
    },

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

    sym '@text.literal' {
      fg = palette.green.fg,
    }, -- Comment
    sym '@text.reference' {
      fg = palette.secondary.fg,
    }, -- Identifier
    sym '@text.title' {
      fg = palette.green.fg.darken(20),
    }, -- Title
    sym '@text.uri' {
      fg = palette.secondary.fg,
      underline = true,
    }, -- Underlined
    sym '@text.underline' {
      underline = true,
    }, -- Underlined
    sym '@text.todo' {
      bg = palette.purple.bg,
    }, -- Todo
    sym '@comment' {
      fg = palette.comment,
    }, -- Comment
    sym '@punctuation' {
      fg = palette.fg.lighten(20),
    }, -- Delimiter
    sym '@constant' {
      fg = palette.secondary.bg6,
    }, -- Constant
    sym '@constant.builtin' {
      fg = palette.teal.fg,
    }, -- Special
    sym '@constant.macro' {
      fg = palette.tertiary.bg6,
    }, -- Define
    sym '@define' {
      fg = palette.tertiary.bg6.lighten(20),
    }, -- Define
    sym '@macro' {
      fg = palette.tertiary.bg6.lighten(20),
    }, -- Macro
    sym '@string' {
      fg = palette.green.fg,
    }, -- String
    sym '@string.escape' {
      fg = palette.green.fg.darken(20),
    }, -- SpecialChar
    sym '@string.special' {
      fg = palette.green.fg.darken(20),
    }, -- SpecialChar
    sym '@character' {
      fg = palette.green.fg.darken(30),
    }, -- Character
    sym '@character.special' {
      fg = palette.green.fg.darken(30),
    }, -- SpecialChar
    sym '@number' {
      fg = palette.fg6.saturation(80),
    }, -- Number
    sym '@boolean' {
      fg = palette.cyan.fg,
    }, -- Boolean
    sym '@float' {
      fg = palette.fg6.saturation(80),
    }, -- Float
    sym '@function' {
      fg = palette.tertiary.bg6,
    }, -- Function
    sym '@function.builtin' {
      fg = palette.teal.fg,
    }, -- Special
    sym '@function.macro' {
      fg = palette.tertiary.bg6.lighten(20),
    }, -- Macro
    sym '@parameter' {
      fg = palette.secondary.fg,
    }, -- Identifier
    sym '@method' {
      fg = palette.tertiary.bg6,
    }, -- Function
    sym '@field' {
      fg = palette.tertiary.bg6.lighten(30),
    }, -- Identifier
    sym '@property' {
      fg = palette.fg5.saturation(20),
    }, -- Identifier
    sym '@constructor' {
      fg = palette.tertiary.bg6,
    }, -- Special
    sym '@conditional' {
      fg = palette.secondary.fg4,
    }, -- Conditional
    sym '@repeat' {
      fg = palette.secondary.fg4,
    }, -- Repeat
    sym '@label' {
      fg = palette.secondary.fg2,
    }, -- Label
    sym '@operator' {
      fg = palette.secondary.fg2,
    }, -- Operator
    sym '@keyword' {
      fg = palette.secondary.fg3.saturation(20).darken(30),
    }, -- Keyword
    sym '@exception' {
      fg = palette.secondary.fg2,
    }, -- Exception
    sym '@variable' {
      fg = palette.fg3.saturation(50),
    }, -- Identifier
    sym '@type' {
      fg = palette.tertiary.fg,
    }, -- Type
    sym '@type.definition' {
      fg = palette.tertiary.fg,
    }, -- Typedef
    sym '@storageclass' {
      fg = palette.tertiary.fg,
    }, -- StorageClass
    sym '@structure' {
      fg = palette.tertiary.fg,
    }, -- Structure
    sym '@namespace' {
      fg = palette.tertiary.fg,
    }, -- Identifier
    sym '@include' {
      fg = palette.tertiary.fg2,
    }, -- Include
    sym '@preproc' {
      fg = palette.tertiary.fg2,
    }, -- PreProc
    sym '@debug' {
      fg = palette.teal.fg,
    }, -- Debug
    sym '@tag' {
      fg = palette.fg5.saturation(80),
    }, -- Tag
    sym '@tag.builtin' {
      fg = palette.fg4.saturation(80),
    }, -- Tag
    sym '@tag.attribute' {
      fg = palette.fg5.saturation(30),
    },
    sym '@keyword.return' {
      fg = palette.tertiary.fg.darken(15),
    },
    sym '@keyword.import' {
      fg = palette.tertiary.fg.darken(15),
    },
    sym '@lsp.type.class' {
      fg = palette.fg5.saturation(80),
    },

    -- custom stuff
    StatusLineAccent { fg = palette.secondary.fg, bg = palette.secondary.bg2 },
    StatusLineInsertAccent { fg = palette.green.fg, bg = palette.green.bg },
    StatusLineVisualAccent { fg = palette.magenta.fg, bg = palette.magenta.bg },
    StatusLineReplaceAccent { fg = palette.red.fg, bg = palette.red.bg },
    StatusLineCmdLineAccent { fg = palette.teal.fg, bg = palette.teal.bg },
    StatusLineTerminalAccent { fg = palette.tertiary.fg, bg = palette.tertiary.bg },
  }
end)

-- Return our parsed theme for extension or use elsewhere.
return theme

-- vi:nowrap
