# Delegate
![Static Badge](https://img.shields.io/badge/windows_powershell-5.1-steelblue?style=plastic&color=dodgerblue)
![Static Badge](https://img.shields.io/badge/powershell-7.4.5-steelblue?style=plastic&color=mediumorchid)

Rewritten in C#/WPF as [Piles](https://github.com/ircjwin/Piles)

## Description
**NOTE:** This application is deprecated. I will likely rebuild using C# and WPF as a fresh project

This application allows a user to write, update, save, and delete categorized task lists.

Key features include:
1. Adding new tabs by clicking the **+** tab
2. Renaming tabs by double-clicking the tab
3. Deleting a tab by clicking the tab's **X** button
4. Checking all tasks with the <img src="/ui/img/CheckIcon.png" width="20" height="20"> button
5. Unchecking all tasks with the <img src="/ui/img/UncheckIcon.png" width="20" height="20"> button
6. Deleting checked tasks with the <img src="/ui/img/TrashIcon.png" width="20" height="20"> button
7. Opening agenda on startup by checking the option in *Settings*
## Instructions
**NOTE:** On initial execution, *Save.json* and *Settings.json* will be created in the root directory.
### Recommended
Create a desktop shortcut and put this command as the file location:
```
powrshell.exe -WindowStyle Hidden -File "<RootDirectory>\Driver.ps1"
```
### Other
Open the root directory in a PowerShell session and run this command:
```
.\Driver.ps1
```
## Known Issues
1. If the number of TabPages exceeds the width of the TabControl, the TabControl shrinks and becomes obstructed.
## License
Copyright &copy; 2024 Chris "C.J." Irwin<br>
This project is [GNU GPLv3](LICENSE) licensed.
