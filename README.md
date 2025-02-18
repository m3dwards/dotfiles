Max's dev machine defaults

Install using GNU Stow:

stow fish -t ~/

nvim is installed as a submodule

To update submodules
cd nvim/.config/nvim && git reset --hard && cd ../../../
git submodule update --remote
