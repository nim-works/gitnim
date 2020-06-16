# gitnim
choosenim for choosey nimions

## Installation

Make a shallow clone of this repository.

```bash
git clone --depth 1 https://github.com/disruptek/git-nim
```

Add `bin` to your `$PATH`.

```bash
export PATH=`pwd`/gitnim/bin:$PATH
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

<details>
<summary>Advanced Usage</summary>
### Creating Your Own Nim Distribution

```bash
git checkout -b "myDistro"
```

### 
### Publishing Your Nim Distribution

```bash
git push --set-upstream "my github remote" "my branch"
```

### Adding a Custom Release Alias

```bash
git tag -a "some alias"
```
</details>

## Contributing

If you're reading this, you're pretty close to the source. Send a PR with a
great new feature!

## License
MIT
