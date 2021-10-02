# [gitnim linux_x64](https://gitnim.com/)

[![tests](https://github.com/disruptek/gitnim/workflows/CI/badge.svg?branch=master)](https://github.com/disruptek/gitnim/actions?query=workflow%3ACI)
![stable](https://img.shields.io/badge/nim-1.0.11-informational?style=flat&logo=nim)
![status](https://img.shields.io/badge/nim-1.2.13-informational?style=flat&logo=nim)
![latest](https://img.shields.io/badge/nim-1.4.8-informational?style=flat&logo=nim)
![devel](https://img.shields.io/badge/nim-1.5.1-informational?style=flat&logo=nim)
[![License](https://img.shields.io/badge/license-MIT-brightgreen)](#license)
[![Matrix](https://img.shields.io/badge/chat-on%20matrix-brightgreen)](https://matrix.to/#/#disruptek:matrix.org)

choosenim for choosey nimions

## What Is It?

The aim of this tool is two-fold:

- Provide an easy way to install the Nim compiler and tools.
- Manage multiple Nim installations and allow them to be selected on-demand.

Basically, it gits nim for you.

## Okay, But I Heard It Was Different.  And, Like, Scary?

Yes, it's different.  But not in a scary way; it's open and simple.

This program adds a git subcommand for Nim `git nim` and installs itself
next to your Nim compiler so that if your compiler is in your `PATH`, so is
**gitnim**.

## It Installs Itself?  Wait, Maybe It's Already Installed...

No, nimpleton, it's not already installed. 🤦

When you compile the source code, `gitnim.nim`, the output is a binary adjacent
to your `nim` compiler and named `git-nim`.

This binary is detected by `git` such that `git nim` is a command you can run
on the command-line and it will do a thing.

## Yeah, Okay, a `git` Subcommand.  But What Does It Do?

The `git nim` subcommand allows you to choose from precompiled Nim releases and
download or install them by managing your Nim installation as any other git
repository.

## So?  Why Should I Care?  I Already Have Nim Installed.

Yeah, well, you can keep using your current Nim installation. 🤷

The aim of this tool is two-fold:

- Provide an easy way to install the Nim compiler and tools.
- Manage multiple Nim installations and allow them to be selected on-demand.

If you don't need either of these features, then **gitnim** is not for you.

## So It's a Git Repo with Branches Matching Nim Versions?  Is That All?

This Nim repository also links to the distribution from
https://github.com/disruptek/dist, which is a hand-curated monorepo holding the
most useful Nim modules from the ecosystem.

## Okay, So What Makes That a Feature I Should Care About?

When run, **gitnim** displays or switches branches in the Nim repository and
updates the **dist** submodules to ensure you always have easy access to the
latest features and fixes _as matched to your active compiler_.

## Y'know, That Actually Makes A Lot Of Sense.

Yeah, I know.  You're welcome.

## Installation

### Clone the Repository

We use git for distribution; what else?

```bash
$ git clone https://github.com/disruptek/gitnim /somewhere
```

### Add `bin` to `$PATH`

A critical step; humor me on this one. The location of the compiler is used to
infer the installation directory for **gitnim** itself.

```bash
$ export PATH=/somewhere/bin:$PATH
```

### Build **gitnim**

You now have a statically-linked Nim binary for your Linux-x64 system, so
you can immediately compile **gitnim**.

This will automatically install the **gitnim** binary next to the compiler
binary according to your `PATH`, enabling the `git nim` subcommand.

```bash
$ cd /somewhere
$ nim c gitnim/gitnim.nim
```

## Usage

### List Available Releases

With no additional arguments, `git nim` will check the network for updates and
present the available Nim releases for selection.

The current distribution will be updated from the network, if necessary.

```bash
$ git nim
```
![git nim](https://github.com/disruptek/gitnim/raw/master/docs/gitnim.svg "git nim")

### Choose a Release by Version

When a version is provided, `git nim` will switch to that version immediately
without querying the network, provided the version exists locally.

The distribution will be updated without querying the network, if possible.

```bash
$ git nim 1.4.3
```
![git nim 1.4.3](https://github.com/disruptek/gitnim/raw/master/docs/gitnim143.svg "git nim 1.4.3")

### Choose a Release by Tag

When a tag is provided, `git nim` will switch to the tagged version immediately
without querying the network, provided the tagged reference exists locally.

The distribution will be updated without querying the network, if possible.

```bash
$ git nim devel
```
![git nim devel](https://github.com/disruptek/gitnim/raw/master/docs/gitnimdevel.svg "git nim devel")

```bash
$ git nim stable
```
![git nim stable](https://github.com/disruptek/gitnim/raw/master/docs/gitnimstable.svg "git nim stable")

## Advanced Usage

### Creating Your Own Nim Distribution
```bash
$ git checkout -b "my favorite nims"
```

### Publishing Your Nim Distribution
```bash
$ git remote rename origin upstream
$ git remote add origin "git@github.com:your_name/gitnim.git"
$ git push --set-upstream origin "your branch name"
```

### Adding a Custom Release Tag
```bash
$ git tag -a "tag_name" -m "your description"
```

### Sharing Your Tags With Others
```bash
$ git push --tags
```

### Revoking Your Tags With Others
```bash
$ git push --delete origin tag_name
```

### Adding a Friend's Tags
```bash
$ git remote add jeff https://github.com/jeff/gitnim
```

### Using a Friend's Tag
```bash
$ git nim jeff/1.3.3
```

## Contributing

[https://github.com/disruptek/gitnim](https://github.com/disruptek/gitnim)

## License
MIT
