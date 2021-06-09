#!/usr/bin/env bash
pwsh -noprofile -nologo -command "$0/../Start-ConvertSample.ps1 $@ ; if (\$error.Count) { exit 1}"
