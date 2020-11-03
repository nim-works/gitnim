# [gitnim linux_x64](https://gitnim.com/)
choosenim for choosey nimions

or

_git: is there anything it *can't* do?_

## Installation

Clone repository.
```bash
$ git clone https://github.com/disruptek/gitnim
```

Add `bin` to `$PATH`.
```bash
$ export PATH=`pwd`/gitnim/bin:$PATH
```

Build `gitnim`.
```bash
$ cd gitnim
$ nim c gitnim/gitnim.nim
```

## Usage

List available releases:

```bash
$ git nim
```

Choose a release by branch or tag:

```bash
$ git nim 1.3.5
```
or
```bash
$ git nim devel
```

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
$ git push --delete origin "tag_name"
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
