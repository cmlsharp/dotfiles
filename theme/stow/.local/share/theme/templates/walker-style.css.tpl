@define-color selected-text {{ accent }};
@define-color text {{ foreground }};
@define-color base {{ background }};
@define-color border {{ accent }};
@define-color foreground {{ foreground }};
@define-color background {{ background }};

* {
    all: unset;
}

* {
    font-family: "JetBrainsMono Nerd Font";
    font-size: 14px;
    color: @text;
}

scrollbar {
    opacity: 0;
}

.normal-icons {
    -gtk-icon-size: 16px;
}

.large-icons {
    -gtk-icon-size: 32px;
}

.box-wrapper {
    background: alpha(@base, 0.95);
    padding: 20px;
    border: 2px solid @border;
}

.search-container {
    background: @base;
    padding: 10px;
}

.input placeholder {
    opacity: 0.5;
}

.input:focus,
.input:active {
    box-shadow: none;
    outline: none;
}

child:selected .item-box * {
    color: @selected-text;
}

.item-box {
    padding-left: 14px;
}

.item-text-box {
    all: unset;
    padding: 14px 0;
}

.item-subtext {
    font-size: 0px;
    min-height: 0px;
    margin: 0px;
    padding: 0px;
}

.item-image {
    margin-right: 14px;
    -gtk-icon-transform: scale(0.9);
}

.current {
    font-style: italic;
}

.keybinds {
    background: @background;
    padding: 10px;
    margin-top: 10px;
    font-size: 10px;
    opacity: 0.5;
}
