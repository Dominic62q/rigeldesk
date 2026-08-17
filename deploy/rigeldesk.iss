; Builds the Windows installer from Flutter's completed release bundle.
; Run from the repository root:
;   & 'C:\Program Files (x86)\Inno Setup 6\ISCC.exe' .\deploy\rigeldesk.iss

#define AppVersion "1.4.9"
#define ReleaseDir "..\flutter\build\windows\x64\runner\Release"

[Setup]
AppId={{A6FB9F88-4DB4-44A9-9A87-E8E8B4877AC9}
AppName=RigelDesk
AppVersion={#AppVersion}
AppPublisher=Rigelis Inc.
AppPublisherURL=https://rigelisinc.com
AppSupportURL=https://rigelisinc.com
AppUpdatesURL=https://rigelisinc.com
DefaultDirName={autopf}\Rigelis\RigelDesk
DefaultGroupName=RigelDesk
UninstallDisplayIcon={app}\RigelDesk.exe
OutputDir=..\dist
OutputBaseFilename=RigelDesk-Setup
SetupIconFile=..\flutter\windows\runner\resources\app_icon.ico
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=admin

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop shortcut"; GroupDescription: "Additional shortcuts:"; Flags: unchecked

[Files]
Source: "{#ReleaseDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\RigelDesk"; Filename: "{app}\RigelDesk.exe"; WorkingDir: "{app}"
Name: "{autodesktop}\RigelDesk"; Filename: "{app}\RigelDesk.exe"; WorkingDir: "{app}"; Tasks: desktopicon

[Run]
Filename: "{app}\RigelDesk.exe"; Description: "Launch RigelDesk"; Flags: nowait postinstall skipifsilent
