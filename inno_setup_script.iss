[Setup]
AppName=IMF Browser
AppVersion=0.1.0
DefaultDirName={autopf}\IMFBrowser
DefaultGroupName=IMF Browser
OutputDir=.
OutputBaseFilename=IMFBrowserSetup
Compression=lzma
SolidCompression=yes

[Files]
Source: "browser\src-tauri\target\release\imf-browser.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "browser\config\domain_registry.json"; DestDir: "{app}\config"; Flags: ignoreversion
Source: "browser\config\domains.txt"; DestDir: "{app}\config"; Flags: ignoreversion

[Icons]
Name: "{group}\IMF Browser"; Filename: "{app}\imf-browser.exe"
Name: "{commondesktop}\IMF Browser"; Filename: "{app}\imf-browser.exe"

[Registry]
; Register IMF: protocol
Root: HKCR; Subkey: "IMF"; ValueType: string; ValueName: ""; ValueData: "URL:IMF Protocol"; Flags: uninsdeletekey
Root: HKCR; Subkey: "IMF"; ValueType: string; ValueName: "URL Protocol"; ValueData: ""; Flags: uninsdeletekey
Root: HKCR; Subkey: "IMF\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\imf-browser.exe"" ""%1"""; Flags: uninsdeletekey

[Run]
Filename: "{app}\imf-browser.exe"; Description: "Launch IMF Browser"; Flags: nowait postinstall skipifdirname exists
