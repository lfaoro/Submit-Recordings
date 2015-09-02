# Submit Recordings

[![release](https://img.shields.io/badge/release-v1.0-brightgreen.svg)](https://github.com/GFISoftware/Submit-Recordings/releases)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/lfaoro/Cast/blob/master/LICENSE.md)
[![platform](https://img.shields.io/badge/platform-Windows-blue.svg)](http://www.microsoft.com/en-us/windows)
[![twitter](https://img.shields.io/badge/twitter-%40leonarth-blue.svg)](https://twitter.com/leonarth)

Submit Recordings is a tool created to improve the process of uploading the recordings of Remote Sessions performed by GFI Technical Support Agents.

## Features available in v1.0
- [x] Auto-configured based on your TeamViewer settings
- [x] Uploads data automatically
- [x] Case number validation
- [x] Creates correct folder structure based on case number logic
- [x] Incremental uploads
- [x] Email notifications on successful upload
- [x] Backup functionality
- [x] Seamless and automatic updates
- [x] Internal PowerShell compatibility check

## Features roadmap for v2.0

- [ ] Automatic detection and upload of new Sessions
- [ ] Automatic case notes update
- [ ] Automatic case number detection based on the Salesforce page the Agent is currently vieweing

## Requirements
- Windows OS
- PowerShell v3+

## Installation
- Download the *Submit Recordings.zip* from the [latest GitHub release](https://github.com/GFISoftware/Submit-Recordings/releases)
- Unzip *Submit Recordings.zip*
- Run the *Submit Recordings.lnk* file

> NOTE: The first time you run *Submit-Recordings* instead of the case number insert the parameter *BACKUP*

*e.g.: 
`Please enter your case number i.e. GFI-XXXX-XXXX: backup`*

This will backup all your previous remote session recordings in the *Sessions-Backup* folder.

> See the [instructive video](https://raw.githubusercontent.com/GFISoftware/Submit-Recordings/master/Submit%20Recordings.mp4) 
created by [Melvin Caruana](https://github.com/m-caruana)

## Communication
- If you **need help**, [send me a tweet](<https://twitter.com/leonarth>)
- If you'd like to **ask a general question**, [send me a tweet](<https://twitter.com/leonarth>)
- If you **have a feature request**, [open an issue](<https://github.com/GFISoftware/Submit-Recordings/issues>)
- If you **found a bug**, [open an issue](<https://github.com/GFISoftware/Submit-Recordings/issues>)
- If you'd **like to contribute**, look for #TODO statements in the source files and send a Pull Request.

## Security Disclosure
If you believe you have identified a security vulnerability with Submit Recordings, you should report it as soon as possible via email to leonardo.faoro@gfi.com. Please do not post it to a public issue tracker.

## Credits
> Submit-Recordings has been developed with the help, support and ideas of the GFI Malta Technical Support Team

## License
Submit Recordings is released under the [MIT License](<LICENSE>)
