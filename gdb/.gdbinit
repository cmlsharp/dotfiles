set print pretty on
set print object on
set print vtbl on

set history save on
set history filename ~/.gdb_history

set disassembly-flavor intel

tui enable

set tui border-kind acs
set tui border-mode normal
set tui active-border-mode bold

define n
   refresh
   next
end
