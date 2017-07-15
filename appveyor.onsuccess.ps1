
Invoke-Expression "git config --global credential.helper store"
Add-Content "$env:USERPROFILE\.git-credentials" "https://$($env:access_token):x-oauth-basic@github.com`n"  
Invoke-Expression "git tag v$($env:APPVEYOR_BUILD_VERSION) $($env:APPVEYOR_REPO_COMMIT)"
Invoke-Expression "git push origin v$($env:APPVEYOR_BUILD_VERSION)"