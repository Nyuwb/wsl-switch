# v.0.7.2

- fixed: Error when trying to switch one service by @Nyuwb [#8](https://github.com/Nyuwb/wsl-switch/pull/8)

# v0.7.1

- Added a new verification in WSL on the instance hostname
- Optimized the code for the "all" parameter
- Fixed **help** output

# v0.7.0

- Added a "all" parameter to switch all configured services at once
- Fixed an unintended new line when switching services

# v0.6.1

- Fixed loading of config.json in the builded app

# v0.6.0

- Adding an app builder through GitHub Actions (CI)
- Adding status command, to show the status of each services
- Fixing command regex to work with all possible combinations

# v0.5

- Fixing scoop install by @Nyuwb in [#6](https://github.com/Nyuwb/wsl-switch/pull/6)
- Adding support for more than two instances by @Nyuwb in [#5](https://github.com/Nyuwb/wsl-switch/pull/5)

# v0.3

- Adding Scoop support
- Complete rewrite of the code
- Working with entities and controllers
- Removing installation as it now useless
- Removing Powershell-YAML dependency
- Adding more commands (help, version, etc.)
