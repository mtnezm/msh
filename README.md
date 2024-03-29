# Description

This is a shameless fork and refactorized version of [Oh-My-Bash](https://github.com/ohmybash/oh-my-bash) with some extra power pills.

# Use cases

You may find this tool interesting when:

- You want to use aliases for multiple package managers (apt, pacman, yum, dnf...) on machines using different distros while keeping common custom stuff loaded on each one
- You want to access a group of servers but not all the time nor from every machine by default (think of separate production and non-production environments that must be managed from the same machine)
- You run multiple accounts for the same online service (i.e. GitHub)

All those different identities, options and possibilities can be separately defined inside what we call "profiles".

# Installation

1. Clone this repository:

   ```
   git clone https://github.com/mtnezm/msh.git
   ```

2. Make the installation script executable:

   ```
   chmod +x msh/tools/install.bash
   ```

3. Run the installer:

   ```
   msh/tools/install.bash
   ```

4. Start using MSH by issuing:

   ```
   source ~/.bashrc
   ```

This will:

- Move the project's root directory (stored in the `${MSH}` variable, located inside the `.mshrc` file) to `${HOME}/.msh` by default
- Replace the existing `~/.bashrc` file with the `templates/bashrc` one
- Replace the previous `${HOME}/.ssh` directory with a new empty one (it will be used as placeholder for multiple SSH profiles management)

Note that the replacements made will not delete original file/dirs found, but instead will keep them by renaming each one to `/path/to/<file-or-dir.old>`.

# Features

## Multiple profiles

To enable a new profile, just:

1. Copy the `tools/templates/profile` directory to a new `modules/profiles/<PROFILE_NAME>/` directory, or directly edit the 'default' one that comes included
2. Store specific stuff there (SSH configuration files, VPN connection details, Systemd service templates... whatever you might need)
3. Add its name to the 'profiles' array located in `.mshrc` file
4. Run `reload` to start using it

Also, keep in mind that:

- To load multiple SSH config files into the `${HOME}/.ssh/config` file make sure you store each one in the following path: `modules/profiles/<PROFILE_NAME>/ssh/config`
- To disable a profile, just comment it out or remove it from the array located in the `.mshrc` file and run `reload` to apply changes

## Cli

Available options provided by the `msh` command are:

- `edit`: Modify any MSH component using the very same command. Run `msh edit -h` for further details
- `reload`: Apply changes after enabling/disabling/editing a component or profile without having to close and re-open the terminal
- `show`: List the different elements managed by MSH

## Aliases, completions and plugins

- Those, along with profiles, are what we call 'components' in this project
- You can add as many new components as you want. The only thing to keep in mind is to save your new stuff with a file extension according to the component type (i.e. for a new aliases file, just save it to the `main/aliases` directory and name it `new_aliases.alias`)

## Themes

- Additional themes can be found, written, downloaded and placed to the `main/themes` directory
- The default shell theme can be changed by modifying the `${MSH_THEME}` variable, located inside the `.mshrc` file

# Schema

Current repository structure is as follows:

- `lib/`: Additional configuration files, such as the ones responsible for enabling the multi-profile feature and the default shell behavior
- `modules/`: This is where contents for separate profiles and key elements of the tool (aliases, completions, plugins and themes by default) are stored. Additional custom stuff should be placed here
- `tools/`: Utilities related to the project, such as MSH installation and removal scripts and templates for new profiles

# Dependencies

Nothing that Bash (>= 4.0) does not bring by default, as far as I know.

# Uninstallation

If you want to stop using MSH, just run:

```
${MSH}/tools/uninstall.bash
```

And then re-open your terminal.

This will:

- Delete `${HOME}/.bashrc` and `${HOME}/.ssh` that were deployed at MSH installation time
- Restore backed up stuff that was renamed at MSH installation time (`${HOME}/.bashrc.old` and `${HOME}/.ssh.old`)
- Remove the whole `${MSH}` directory and its contents
