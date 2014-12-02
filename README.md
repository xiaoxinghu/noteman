Noteman
===

You advanced note manager.

Still in development. More features are coming.

## Contents

- [What and why](#what-and-why)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)

## What and why

`noteman` is a convenient CLI for managing your plain text notes. It can search by content, tags, keywords and whatever wired stuff you can think of by extending it. There are plenty of great GUI tools to do this. E.g. [nvAlt](http://brettterpstra.com/projects/nvalt/), [Ulysses](http://www.ulyssesapp.com). The motivation behind this project is to simplify the note management process into a couple of simple command lines, and at the same time, make it possible to be crafted into a power tool if you wanted by the extensiblility it provides.

## Installation

Installing `noteman` is straightforward.

```bash
gem install noteman
```

## Configuration

The first time you run `noteman` by invoking the command `note` will generate the config file with default values. Which looks like this.

``` yaml
---
notes_in: "~/notes"
view_with: Marked 2
capture_to: capture.md
ends_with: md
home: "~/.noteman"
```

The config file is stored in "~/.notemanrc".

## Usage

You can always invoke `note help` to see a list of commands. But here I will describe the basic functions that current version provides.

### Capture notes

Capturing notes is as simple as:

```bash
note new
```

This command will open your default text editor (set in environment variable). Jot down your note, save and quit. The note will be appended onto file defined in the config `capture_to`.

You also can quickly jot down a one line note without opening a text editor. E.g.

```bash
note new buy milk
```

If you want to save an URL link with the text. Use `-l` or `--link` option.
```bash
note new watch this video -l http://www.youtube.com
```
This will create a markdown style link.

To view what you have captured, use this command to open the inbox.

```bash
note inbox
```
This command will open your `capture.md` file with the app configured in the config file. By default it is [Marked 2](http://marked2app.com/).

### Find your notes

Searching for notes is quick and fun.

```bash
note find
```
This command will bring up a search bar, and a result window (don't worry, it's still CLI). Just put down your keywords, there will be a list of results displayed instantly. Navigate through them with arrow keys(up and down). Select one with `Enter` will open the file. Or press `Esc` to quit.

## Get started with the code

```bash
bundle install
```
	
