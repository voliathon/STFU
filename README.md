# STFU - A Windower Addon for FFXI

STFU is a powerful and streamlined chat filter addon for Final Fantasy XI. It helps you block spam and unwanted messages from RMT sellers and other disruptive players by managing a simple user and pattern blacklist.

This version has been re-engineered for maximum compatibility by using Lua's fundamental I/O libraries, bypassing some of the more complex, environment-sensitive Windower libraries.

## Features

-   **User Blacklist**: Block all incoming messages from specific players.
-   **Pattern Blacklist**: Filter out chat messages in Shout, Yell, and Tell that contain specific keywords, phrases, or regex patterns.
-   **In-Game Commands**: Manage your blacklists on the fly without needing to edit any files or reload the addon.
-   **Simple Text-Based Settings**: All your settings are saved in a human-readable `blacklist.txt` file, making it easy to backup or share your lists.
-   **User-Friendly Setup**: The addon will guide you if any action is needed to set up the settings file.

## Installation

1.  Place the `STFU` folder containing `STFU.lua` inside your Windower `addons` directory.
2.  Launch Final Fantasy XI and log in. Once in the game, load the addon by typing:
    ```
    //lua load stfu
    ```
3.  The first time the addon runs, it will attempt to create a `blacklist.txt` file. If it fails, it will print a message in your chat log with instructions. Most commonly, it will ask you to create a `data` folder inside the `STFU` directory.

### **Important Note on File Permissions**

If your Windower is installed in a protected directory (like `C:\Program Files (x86)\`), Windows may prevent the addon from saving its `blacklist.txt` file, even if the `data` folder exists. If you find that your blacklist is still not saving, you will need to set Windower to "Run this program as an administrator" in your shortcut's compatibility settings.

## Usage

You can manage the addon's settings directly from the FFXI chat log using the `//stfu` command.

### Command List

| Command                       | Description                                         |
| ----------------------------- | --------------------------------------------------- |
| `//stfu adduser <name>`        | Adds a player to the user blacklist.                |
| `//stfu deluser <name>`        | Removes a player from the user blacklist.           |
| `//stfu addword <pattern>`     | Adds a keyword or regex pattern to the blacklist.   |
| `//stfu delword <pattern>`     | Removes a keyword or regex pattern from the blacklist.|
| `//stfu list`                  | Displays your current blacklist.      |

## Customization

All settings are stored in the `STFU/data/blacklist.txt` file. While you can manage the lists with in-game commands, you can also edit this file directly with any text editor to add or remove multiple entries at once.

### `blacklist.txt` Format

The file uses a simple format with section headers. Each entry should be on its own line.
