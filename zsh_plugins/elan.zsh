#compdef elan

autoload -U is-at-least

_elan() {
    typeset -A opt_args
    typeset -a _arguments_options
    local ret=1

    if is-at-least 5.2; then
        _arguments_options=(-s -S -C)
    else
        _arguments_options=(-s -C)
    fi

    local context curcontext="$curcontext" state line
    _arguments "${_arguments_options[@]}" \
'-v[Enable verbose output]' \
'--verbose[Enable verbose output]' \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
":: :_elan_commands" \
"*::: :->elan" \
&& ret=0
    case $state in
    (elan)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:elan-command-$line[1]:"
        case $line[1] in
            (show)
_arguments "${_arguments_options[@]}" \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
&& ret=0
;;
(install)
_arguments "${_arguments_options[@]}" \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
':toolchain -- Toolchain name, such as 'stable', 'beta', 'nightly', or '4.3.0'. For more information see `elan help toolchain`:_files' \
&& ret=0
;;
(uninstall)
_arguments "${_arguments_options[@]}" \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
':toolchain -- Toolchain name, such as 'stable', 'beta', 'nightly', or '4.3.0'. For more information see `elan help toolchain`:_files' \
&& ret=0
;;
(default)
_arguments "${_arguments_options[@]}" \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
':toolchain -- Toolchain name, such as 'stable', 'beta', 'nightly', or '4.3.0'. For more information see `elan help toolchain`:_files' \
&& ret=0
;;
(toolchain)
_arguments "${_arguments_options[@]}" \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
":: :_elan__toolchain_commands" \
"*::: :->toolchain" \
&& ret=0
case $state in
    (toolchain)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:elan-toolchain-command-$line[1]:"
        case $line[1] in
            (list)
_arguments "${_arguments_options[@]}" \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
&& ret=0
;;
(install)
_arguments "${_arguments_options[@]}" \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
':toolchain -- Toolchain name, such as 'stable', 'beta', 'nightly', or '4.3.0'. For more information see `elan help toolchain`:_files' \
&& ret=0
;;
(remove)
_arguments "${_arguments_options[@]}" \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
':toolchain -- Toolchain name, such as 'stable', 'beta', 'nightly', or '4.3.0'. For more information see `elan help toolchain`:_files' \
&& ret=0
;;
(uninstall)
_arguments "${_arguments_options[@]}" \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
':toolchain -- Toolchain name, such as 'stable', 'beta', 'nightly', or '4.3.0'. For more information see `elan help toolchain`:_files' \
&& ret=0
;;
(link)
_arguments "${_arguments_options[@]}" \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
':toolchain -- Toolchain name, such as 'stable', 'beta', 'nightly', or '4.3.0'. For more information see `elan help toolchain`:_files' \
':path:_files' \
&& ret=0
;;
(gc)
_arguments "${_arguments_options[@]}" \
'--delete[Delete collected toolchains instead of only reporting them]' \
'--json[Format output as JSON]' \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
&& ret=0
;;
        esac
    ;;
esac
;;
(override)
_arguments "${_arguments_options[@]}" \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
":: :_elan__override_commands" \
"*::: :->override" \
&& ret=0
case $state in
    (override)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:elan-override-command-$line[1]:"
        case $line[1] in
            (list)
_arguments "${_arguments_options[@]}" \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
&& ret=0
;;
(add)
_arguments "${_arguments_options[@]}" \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
':toolchain -- Toolchain name, such as 'stable', 'beta', 'nightly', or '4.3.0'. For more information see `elan help toolchain`:_files' \
&& ret=0
;;
(set)
_arguments "${_arguments_options[@]}" \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
':toolchain -- Toolchain name, such as 'stable', 'beta', 'nightly', or '4.3.0'. For more information see `elan help toolchain`:_files' \
&& ret=0
;;
(remove)
_arguments "${_arguments_options[@]}" \
'--path=[Path to the directory]' \
'--nonexistent[Remove override toolchain for all nonexistent directories]' \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
&& ret=0
;;
(unset)
_arguments "${_arguments_options[@]}" \
'--path=[Path to the directory]' \
'--nonexistent[Remove override toolchain for all nonexistent directories]' \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
&& ret=0
;;
        esac
    ;;
esac
;;
(run)
_arguments "${_arguments_options[@]}" \
'--install[Install the requested toolchain if needed]' \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
':toolchain -- Toolchain name, such as 'stable', 'beta', 'nightly', or '4.3.0'. For more information see `elan help toolchain`:_files' \
':command:_files' \
&& ret=0
;;
(which)
_arguments "${_arguments_options[@]}" \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
':command:_files' \
&& ret=0
;;
(dump-state)
_arguments "${_arguments_options[@]}" \
'--no-net[Make network operations for resolving channels fail immediately]' \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
&& ret=0
;;
(self)
_arguments "${_arguments_options[@]}" \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
":: :_elan__self_commands" \
"*::: :->self" \
&& ret=0
case $state in
    (self)
        words=($line[1] "${words[@]}")
        (( CURRENT += 1 ))
        curcontext="${curcontext%:*:*}:elan-self-command-$line[1]:"
        case $line[1] in
            (update)
_arguments "${_arguments_options[@]}" \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
&& ret=0
;;
(uninstall)
_arguments "${_arguments_options[@]}" \
'-y[]' \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
&& ret=0
;;
        esac
    ;;
esac
;;
(completions)
_arguments "${_arguments_options[@]}" \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
'::shell:(zsh bash fish powershell elvish)' \
&& ret=0
;;
(help)
_arguments "${_arguments_options[@]}" \
'-h[Prints help information]' \
'--help[Prints help information]' \
'-V[Prints version information]' \
'--version[Prints version information]' \
&& ret=0
;;
        esac
    ;;
esac
}

(( $+functions[_elan_commands] )) ||
_elan_commands() {
    local commands; commands=(
        "show:Show the active and installed toolchains" \
"install:Install Lean toolchain" \
"uninstall:Uninstall Lean toolchains" \
"default:Set the default toolchain" \
"toolchain:Modify or query the installed toolchains" \
"override:Modify directory toolchain overrides" \
"run:Run a command with an environment configured for a given toolchain" \
"which:Display which binary will be run for a given command" \
"dump-state:" \
"self:Modify the elan installation" \
"completions:Generate completion scripts for your shell" \
"help:Prints this message or the help of the given subcommand(s)" \
    )
    _describe -t commands 'elan commands' commands "$@"
}
(( $+functions[_elan__add_commands] )) ||
_elan__add_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'elan add commands' commands "$@"
}
(( $+functions[_elan__override__add_commands] )) ||
_elan__override__add_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'elan override add commands' commands "$@"
}
(( $+functions[_elan__completions_commands] )) ||
_elan__completions_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'elan completions commands' commands "$@"
}
(( $+functions[_elan__default_commands] )) ||
_elan__default_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'elan default commands' commands "$@"
}
(( $+functions[_elan__dump-state_commands] )) ||
_elan__dump-state_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'elan dump-state commands' commands "$@"
}
(( $+functions[_elan__toolchain__gc_commands] )) ||
_elan__toolchain__gc_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'elan toolchain gc commands' commands "$@"
}
(( $+functions[_elan__help_commands] )) ||
_elan__help_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'elan help commands' commands "$@"
}
(( $+functions[_elan__override__help_commands] )) ||
_elan__override__help_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'elan override help commands' commands "$@"
}
(( $+functions[_elan__self__help_commands] )) ||
_elan__self__help_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'elan self help commands' commands "$@"
}
(( $+functions[_elan__toolchain__help_commands] )) ||
_elan__toolchain__help_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'elan toolchain help commands' commands "$@"
}
(( $+functions[_elan__install_commands] )) ||
_elan__install_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'elan install commands' commands "$@"
}
(( $+functions[_elan__toolchain__install_commands] )) ||
_elan__toolchain__install_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'elan toolchain install commands' commands "$@"
}
(( $+functions[_elan__toolchain__link_commands] )) ||
_elan__toolchain__link_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'elan toolchain link commands' commands "$@"
}
(( $+functions[_elan__override__list_commands] )) ||
_elan__override__list_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'elan override list commands' commands "$@"
}
(( $+functions[_elan__toolchain__list_commands] )) ||
_elan__toolchain__list_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'elan toolchain list commands' commands "$@"
}
(( $+functions[_elan__override_commands] )) ||
_elan__override_commands() {
    local commands; commands=(
        "list:List directory toolchain overrides" \
"set:Set the override toolchain for a directory" \
"unset:Remove the override toolchain for a directory" \
"help:Prints this message or the help of the given subcommand(s)" \
    )
    _describe -t commands 'elan override commands' commands "$@"
}
(( $+functions[_elan__override__remove_commands] )) ||
_elan__override__remove_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'elan override remove commands' commands "$@"
}
(( $+functions[_elan__remove_commands] )) ||
_elan__remove_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'elan remove commands' commands "$@"
}
(( $+functions[_elan__toolchain__remove_commands] )) ||
_elan__toolchain__remove_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'elan toolchain remove commands' commands "$@"
}
(( $+functions[_elan__run_commands] )) ||
_elan__run_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'elan run commands' commands "$@"
}
(( $+functions[_elan__self_commands] )) ||
_elan__self_commands() {
    local commands; commands=(
        "update:Download and install updates to elan" \
"uninstall:Uninstall elan." \
"help:Prints this message or the help of the given subcommand(s)" \
    )
    _describe -t commands 'elan self commands' commands "$@"
}
(( $+functions[_elan__override__set_commands] )) ||
_elan__override__set_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'elan override set commands' commands "$@"
}
(( $+functions[_elan__show_commands] )) ||
_elan__show_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'elan show commands' commands "$@"
}
(( $+functions[_elan__toolchain_commands] )) ||
_elan__toolchain_commands() {
    local commands; commands=(
        "list:List installed toolchains" \
"install:Install a given toolchain" \
"uninstall:Uninstall a toolchain" \
"link:Create a custom toolchain by symlinking to a directory" \
"gc:Garbage-collect toolchains not used by any known project" \
"help:Prints this message or the help of the given subcommand(s)" \
    )
    _describe -t commands 'elan toolchain commands' commands "$@"
}
(( $+functions[_elan__self__uninstall_commands] )) ||
_elan__self__uninstall_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'elan self uninstall commands' commands "$@"
}
(( $+functions[_elan__toolchain__uninstall_commands] )) ||
_elan__toolchain__uninstall_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'elan toolchain uninstall commands' commands "$@"
}
(( $+functions[_elan__uninstall_commands] )) ||
_elan__uninstall_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'elan uninstall commands' commands "$@"
}
(( $+functions[_elan__override__unset_commands] )) ||
_elan__override__unset_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'elan override unset commands' commands "$@"
}
(( $+functions[_elan__self__update_commands] )) ||
_elan__self__update_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'elan self update commands' commands "$@"
}
(( $+functions[_elan__which_commands] )) ||
_elan__which_commands() {
    local commands; commands=(
        
    )
    _describe -t commands 'elan which commands' commands "$@"
}

_elan "$@"