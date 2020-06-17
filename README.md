# [gitnim linux_x64](https://gitnim.com/)
choosenim for choosey nimions

## Installation

Make a clone of this repository.

```bash
git clone https://github.com/disruptek/gitnim
```

Add `bin` to your `$PATH`.

```bash
export PATH=`pwd`/gitnim/bin:$PATH
```

Build `gitnim`.

```bash
cd gitnim/gitnim
nim c gitnim.nim
```

## Usage

List available releases:

```bash
git nim
```

Choose a release:

```bash
git nim 1.3.5
```

## Advanced Usage

### Using a Different Distribution
```bash
export GITNIM_URL=https://github.com/other/distro
```

### Creating Your Own Nim Distribution
```bash
git checkout -b "my distro"
```

### Publishing Your Nim Distribution
```bash
git remote rename origin upstream
git remote add origin "my git remote"
git push --set-upstream "my git remote" "my branch"
```

### Adding a Custom Release Tag
```bash
git tag -a "some alias"
```

### Sharing Your Tags With Others
```bash
git push --tags
```

### Adding a Friend's Tags
```bash
git remote add jeff https://github.com/jeff/gitnim
```

### Using a Friend's Tag
```bash
git nim jeff/1.3.3
```

## Contributing

[https://github.com/disruptek/gitnim](https://github.com/disruptek/gitnim)

## License
MIT
