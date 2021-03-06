# MCDReforged docker image

**English** | [简体中文](https://github.com/Cattttttttt/mcdr-docker/blob/master/docs/README-zh.md)

**This image is not using automatic test yet, always backup your world**

**If you're using Docker Desktop on Windows 11, disable 'Use the WSL 2 based engine' in Docker Desktop settings to use Hyper-V as backend, or your world might be corrupted. [This issue](https://github.com/itzg/docker-minecraft-server/issues/1102)**

**Only support MCDReforged 2.x**

Docker image for [MCDReforged](https://github.com/Fallen-Breath/MCDReforged).

Based on [itzg/docker-minecraft-server](https://github.com/itzg/docker-minecraft-server).

`$ docker pull notevenaneko/mcdr-docker:latest`

## Docker run

`$ docker run -it -e EULA=TRUE notevenaneko/mcdr-docker:latest`

**MUST** use with `-i` and `-t` because MCDReforged will read EOF and exit if stdin is closed, or modify config.yml in the next section.

## Docker Compose

```yaml
version: "3.8"
services:
  mcdr:
    image: notevenaneko/mcdr-docker:latest
    environment:
      - EULA=TRUE
    ports:
      - 25565:25565
    stdin_open: true
    tty: true
```

`stdin_open` and `tty` **MUST** be `true`, or set `disable_console_thread` to `true` in config.yml of MCDReforged.

## Modify Minecraft config

See https://github.com/itzg/docker-minecraft-server.

## Attach volumes

You can attach your volume to `/data` and `/mcdr`.

`/data` is the Minecraft main directory provided by [itzg/docker-minecraft-server](https://github.com/itzg/docker-minecraft-server), see https://github.com/itzg/docker-minecraft-server#data-directory.

`/mcdr` is the directory of MCDReforged, see https://mcdreforged.readthedocs.io/zh_CN/latest/quick_start.html#start-up.

```yaml
version: "3.8"
services:
  mcdr:
    image: notevenaneko/mcdr-docker:latest
    environment:
      - EULA=TRUE
    ports:
      - 25565:25565
    volumes:
      - /path/to/your/server.property:/data/server.property
      - /path/to/your/world:/data/world
      - /path/to/your/mcdr/config.yml:/mcdr/config.yml
      - /path/to/your/mcdr/plugins:/mcdr/plugins
    stdin_open: true
    tty: true
```

or simply mount two directory

```yaml
version: "3.8"
services:
  mcdr:
    image: notevenaneko/mcdr-docker:latest
    environment:
      - EULA=TRUE
    ports:
      - 25565:25565
    volumes:
      - /path/to/your/mc:/data
      - /path/to/your/mcdr:/mcdr
    stdin_open: true
    tty: true
```

## Boot from source code

Set environment variable `BOOT_FROM_SOURCE` to non-empty string.

```yaml
version: "3.8"
services:
  mcdr:
    image: notevenaneko/mcdr-docker:latest
    environment:
      - EULA=TRUE
      - BOOT_FROM_SOURCE=TRUE
    ports:
      - 25565:25565
    stdin_open: true
    tty: true
```

## Use different version of MCDReforged

Set environment variable `MCDR_VERSION` to valid version number, 2.0 or above is supported.

```yaml
version: "3.8"
services:
  mcdr:
    image: notevenaneko/mcdr-docker
    environment:
      - EULA=TRUE
      - MCDR_VERSION=2.3.2 # Use MCDReforged v2.3.2
    ports:
      - 25565:25565
    stdin_open: true
    tty: true
```

## Using different UID/GID

Change environment variable `UID` and `GID` to change user, or use `--user 1000:1000` to boot with user 'minecraft'

```yaml
version: "3.8"
services:
  mcdr:
    image: notevenaneko/mcdr-docker:latest
    environment:
      - EULA=TRUE
      - PID=0 # run main server using root
      - GID=0
    ports:
      - 25565:25565
    stdin_open: true
    tty: true
```

## Mapping `TYPE` to `handler`

- `FABRIC` or `VANILLA`: `vanilla_handler`
- `FORGE`: `forge_handler`
- `BUKKIT` or `SPIGOT`: `bukkit14_handler` when game version is 1.14 and above, `bukkit_handler` otherwise
- `PAPER` or `MOHIST`: `bukkit_handler`
- `CATSERVER`: `cat_server_handler`
- other: `vanilla_handler`

## Disadvantages

- No automatic test, manual test is required before release
- Some environment variable in [itzg/docker-minecraft-server](https://github.com/itzg/docker-minecraft-server) may not have the same effect.
- Some implementations is not graceful enough.
