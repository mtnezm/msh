### **DESCRIPTION**

This is a shameless fork and refactorized version of [Oh-My-Bash](https://github.com/ohmybash/oh-my-bash) with some extra power pills.

### **USE CASES**

You may find this tool interesting when:

- You want to use aliases for multiple package managers (apt, pacman, yum, dnf...) on machines using different distros while keeping common custom stuff loaded on each one
- You want to access a group of servers but not all the time nor from every machine by default (think of separate production and non-production environments that must be managed from the same machine)
- You run multiple accounts for the same online service (i.e. GitHub)

All those different identities, options and possibilities can be separately defined inside what we call "profiles".

### **MULTIPLE PROFILES**

To enable a new profile, just:

1. Copy the `tools/templates/example-profile` directory to a new `include/profiles/<PROFILE_NAME>/` directory, or directly edit the 'default' one that comes included
2. Store specific stuff there (SSH configuration files, VPN connection details, Systemd service templates... whatever you might need)
3. Add its name to the 'profiles' array located in `core/components.msh` file
4. Run `msh reload` to start using it

Also, keep in mind that:

- To load multiple SSH config files into the `${HOME}/.ssh/config` file make sure you store each one in the following path: `include/profiles/<PROFILE_NAME>/ssh/config`
- To disable a profile, just comment it out or remove it from the array located in the `core/components.msh` file and run `msh reload` to apply changes

### **INSTALLATION**

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

- Move the project's root directory (stored in the `${MSH}` variable, located inside the `core/vars.msh` file) to `${HOME}/.msh` by default
- Replace the existing `~/.bashrc` file with the `templates/bashrc` one
- Replace the previous `${HOME}/.ssh` directory with a new empty one (it will be used as placeholder for multiple SSH profiles management)

Note that the replacements made will not delete original file/dirs found, but instead will keep them by renaming each one to `/path/to/<file-or-dir.old>`.

### **MAKE THINGS HANDY**

Some options provided by the `msh` command (available after installing MSH) are:

- `edit`: Modify any MSH component using the very same command. Run `msh edit -h` for further details
- `reload`: Apply changes after enabling/disabling/editing a component or profile without having to close and re-open the terminal
- `show`: List the different elements managed by MSH

### **SCHEMA**

Current repository structure is as follows:

- `core/`: Contains the basic files that make things work, such as variable definitions and resources to be (and how are they) loaded
- `include/`: This is where contents for separate profiles is stored. Additional and custom stuff should be placed here
- `lib/`: Additional configuration files, such as the ones responsible for enabling the multi-profile feature and the default shell behavior
- `main/`: Key elements of the tool (aliases, completions, plugins and themes)
- `tools/`: Utilities related to the project, such as MSH installation and removal scripts and templates for new profiles

### **ALIASES, COMPLETIONS AND PLUGINS**

- Those, along with profiles, are what we call 'components' in this project
- You can add as many new components as you want. The only thing to keep in mind is to save your new stuff with a file extension according to the component type (i.e. for a new aliases file, just save it to the `main/aliases` directory and name it `new_aliases.alias`)

### **THEMES**

- Additional themes can be found, written, downloaded and placed to the `main/themes` directory
- The default shell theme can be changed by modifying the `${MSH_THEME}` variable, located inside the `core/vars.msh` file

### **DEPENDENCIES**

Nothing that Bash (>= 4.0) does not bring by default, as far as I know.

### **UNINSTALL**

If you want to stop using MSH:

1. Run:

   ```
   ${MSH}/tools/uninstall.bash
   ```

2. Re-open your terminal

This will:

- Delete `${HOME}/.bashrc` and `${HOME}/.ssh` that were deployed at MSH installation time
- Restore backed up stuff that was renamed at MSH installation time (`${HOME}/.bashrc.old` and `${HOME}/.ssh.old`)
- Remove the whole `${MSH}` directory and its contents

### **LICENSE**

MSH is released under the MIT license.
