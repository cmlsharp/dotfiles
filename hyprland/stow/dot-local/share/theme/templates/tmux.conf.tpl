set -g pane-border-style fg={{ surface1 }}
set -g pane-active-border-style fg={{ accent }}

set-option -g status-bg '{{ background }}'
set-option -g status-fg '{{ foreground }}'

set-window-option -g window-status-style fg={{ overlay0 }},bg={{ background }}
set-window-option -g window-status-current-style fg={{ accent }},bg={{ surface0 }},bold

set -g message-style bg={{ background }},fg={{ foreground }}
setw -g mode-style bg={{ background }},fg={{ foreground }}
setw -g clock-mode-colour '{{ accent }}'
