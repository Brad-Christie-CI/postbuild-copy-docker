#escape=`
FROM microsoft/windowsservercore
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# To keep this simple, we're just copying a website to the server's configured web
# root.
# Picture this as a full-fledged Sitecore instance with a \Website and \Data root.
# The below method can be used to pull in a vlaid license file when the container
# is started (by having the .\Start.ps1 script copy it to the appropriate location)

RUN Install-WindowsFeature Web-Server -IncludeManagementTools ; `
    Invoke-WebRequest "https://dotnetbinaries.blob.core.windows.net/servicemonitor/2.0.1.3/ServiceMonitor.exe" -OutFile "C:\ServiceMonitor.exe" -UseBasicParsing ; `
    Remove-Item C:\inetpub\wwwroot\* -Recurse -Force

VOLUME C:\wwwroot

EXPOSE 80

COPY ./Start.ps1 /
ENTRYPOINT .\Start.ps1