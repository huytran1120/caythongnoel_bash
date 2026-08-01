# caythongnoel_bash

ASCII Christmas tree animation in Bash — made for fun and terminal vibes.

## Preview

<img src="https://github.com/huytran1120/caythongnoel_bash/blob/3ed28434b9dfae314c30d0e222fc28fa6689128b/Screenshot%202022-12-21%20224221.png" width="320" alt="Christmas tree terminal preview" />

## Features

- Animated Christmas tree in terminal
- Blinking ornaments with random colors
- Falling snow effect
- Rotating festive messages
- Works with Docker

## Project files

- Script: [`caythong.sh`](./caythong.sh)
- Container setup: [`Dockerfile`](./Dockerfile)

## Run locally

### Linux/macOS

```bash
bash caythong.sh
```

### Windows (PowerShell + Git Bash)

If `bash caythong.sh` shows a WSL `/bin/bash` error, run with Git Bash directly:

```powershell
& "C:\Program Files\Git\bin\bash.exe" "C:/Users/huytc/OneDrive/Documents/GitHub/caythongnoel_bash/caythong.sh"
```

Press `Ctrl + C` to stop.

## Run with Docker

```powershell
docker build -t caythong-vibe .
docker run --rm -it caythong-vibe
```

## License

This project is released under the MIT License. See [`LICENSE`](./LICENSE).
