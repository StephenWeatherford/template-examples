#!/usr/bin/env bash
pwsh -noprofile -nologo -command "$0/../Update-QuickStartFromBicep.ps1 $@ ; if (\$error.Count) { exit 1}"
