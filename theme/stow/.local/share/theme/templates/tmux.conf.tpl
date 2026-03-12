set -g pane-border-style fg={{ surface1 }}
set -g pane-active-border-style fg={{ accent }}

set-option -g status-bg '{{ mantle }}'
set-option -g status-fg '{{ foreground }}'

set-window-option -g window-status-style fg={{ overlay0 }},bg={{ mantle }}
set-window-option -g window-status-current-style fg={{ accent }},bg={{ surface0 }},bold

set -g message-style bg={{ surface0 }},fg={{ foreground }}
setw -g mode-style bg={{ surface2 }},fg={{ foreground }}
setw -g clock-mode-colour '{{ accent }}'
