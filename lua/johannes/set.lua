vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false

if vim.loop.os_uname().sysname == 'Linux' then
        vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
else -- assume Windows
        vim.opt.undodir = os.getenv("UserProfile") .. "/.vim/undodir"
end
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.o.winborder = 'double'

if vim.loop.os_uname().sysname == 'Windows' then
        vim.o.shell        = "powershell"
        vim.o.shellcmdflag =
        "-NoLogo -NonInteractive -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[''Out-File:Encoding'']=''utf8'';$PSStyle.OutputRendering=''plaintext'';Remove-Alias -Force -ErrorAction SilentlyContinue tee;"
        vim.o.shellredir   = "2>&1 | %%{ '$_' } | Out-File %s; exit $LastExitCode"
        vim.o.shellpipe    = "2>&1 | %%{ '$_' } | tee %s; exit $LastExitCode"
        vim.o.shellquote   = ""
        vim.o.shellxquote  = ""
end
-- TODO: may need some Linux equivalent unless nvim launches zsh by default
