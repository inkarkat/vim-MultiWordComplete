MULTI WORD COMPLETE
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

The built-in insert mode completion completes single words, and one can copy
the words following the previous expansion one-by-one. (But that is cumbersome
and doesn't scale when there are many alternatives.)
This plugin offers completion of sequences of words, i.e. everything separated
by whitespace, non-keyword characters or the start / end of line, based on the
typed first letter of each word. With this, one can quickly complete entire
phrases; for example, "imc" completes to "insert mode completion", and "/ulb"
completes to "/usr/local/bin".

### SEE ALSO

- CamelCaseComplete.vim ([vimscript #3915](http://www.vim.org/scripts/script.php?script_id=3915)) provides a similar completion, but
  the anchor characters must be the start fragments of CamelCaseWords or
  underscore\_words.
- Check out the CompleteHelper.vim plugin page ([vimscript #3914](http://www.vim.org/scripts/script.php?script_id=3914)) for a full
  list of insert mode completions powered by it.

USAGE
------------------------------------------------------------------------------

    In insert mode, type all initial letters of the requested phrase, and invoke
    the multi-word completion via CTRL-X w.
    You can then search forward and backward via CTRL-N / CTRL-P, as usual.

    CTRL-X w                Find matches for multiple words which begin with the
                            typed letters in front of the cursor. The 'ignorecase'
                            and 'smartcase' settings apply. If no matches were
                            found that way, a case-insensitive search is tried as
                            a fallback. (So, unless you care about a minimum
                            number of matches and search speed, you can be sloppy
                            with the case of the typed letters.)
                            The sequence of words can span multiple lines;
                            newlines are removed in the completion results.

                            Non-alphabetic keyword characters (e.g. numbers, "_"
                            in the default 'iskeyword' setting) can be inserted
                            into the completion base to force inclusion of these,
                            e.g. both "mf" and "mf_b" complete to "my foo_bar",
                            but the latter excludes "my foobar" and "my foo_quux".
                            An alphabetic anchor following a non-alphabetic anchor
                            must match immediately after the non-alphabetic
                            letter, not in the next word. Thus, mentally parse the
                            base "mf_b" as "m", "f", "_b".
                            In addition, non-alphabetic keyword characters match
                            at a start of a word, too. For example, "f2s" matches
                            both "foobar 2000 system" ("2" matching like an
                            alphabetic character) and "foo2sam" ("2" matching
                            according to the special rule for non-alphabetic
                            characters).

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-MultiWordComplete
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim MultiWordComplete*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.0 or higher.
- Requires the ingo-library.vim plugin ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)), version 1.037 or
  higher.
- Requires the CompleteHelper.vim plugin ([vimscript #3914](http://www.vim.org/scripts/script.php?script_id=3914)), version 1.40 or
  higher.

CONFIGURATION
------------------------------------------------------------------------------

For a permanent configuration, put the following commands into your vimrc:

By default, the 'complete' option controls which buffers will be scanned for
completion candidates. You can override that either for the entire plugin, or
only for particular buffers; see CompleteHelper\_complete for supported
values.

    let g:MultiWordComplete_complete = '.,w,b,u'

To disable the removal of the (mostly useless) completion base when aborting
with &lt;Esc&gt; while there are no matches:

    let g:MultiWordComplete_FindStartMark = ''

If you want to use a different mapping, map your keys to the
&lt;Plug&gt;(MultiWordComplete) mapping target _before_ sourcing the script (e.g.
in your vimrc):

    imap <C-x>w <Plug>(MultiWordComplete)<Plug>(MultiWordPostComplete)

IDEAS
------------------------------------------------------------------------------

- Allow '.' wildcard for a single and '\*' for multiple words.
- When whitespace before base, include trailing non-keywords in matches, else
  when non-keywords before base, stop at last keyword character in matches?

### CONTRIBUTING

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-MultiWordComplete/issues or email (address
below).

HISTORY
------------------------------------------------------------------------------

##### 1.02    RELEASEME
-

__You need to update to ingo-library ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)) version 1.037!__

##### 1.01    17-Mar-2019
- Make repeat across lines work.
- FIX: Avoid "E121: Undefined variable: s:isNoMatches" when triggering the
  completion for the first time without a valid base.
- Remove default g:MultiWordComplete\_complete configuration and default to
  'complete' option value instead.
- Remove superfluous duplicate :imap for default mapping.

__You need to update to CompleteHelper.vim ([vimscript #3914](http://www.vim.org/scripts/script.php?script_id=3914)) version 1.40!__

##### 1.00    19-Dec-2013
- First published version.

##### 0.01    26-Feb-2010
- Started development.

------------------------------------------------------------------------------
Copyright: (C) 2010-2019 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat &lt;ingo@karkat.de&gt;
