Dotfiles: files that start with dots!
=====================================

It used to be the case that I changed systems so seldom that I would remember to
copy my dotfiles over, or I could _relatively_ easily rebuild them. Or there was
enough version drift that they stopped being useful on the next machine I went
to. I've had three new Macs in two and a half years and I shell into brand new
Linux boxes on the daily (THANKS AWS) so okay here we go I give up here are my
dotfiles.

```bash

curl https://raw.githubusercontent.com/jasonbot/dotfiles/master/install.sh | bash

```

On Windows, don't do this, do this!

```powershell

Set-ExecutionPolicy Bypass
& ([scriptblock]::Create((irm "https://raw.githubusercontent.com/jasonbot/bootstrap-windows-development-machine/refs/heads/main/bootstrap.ps1")))

```
