# C/C++ BMN

## Running in a container

When dependency installation is enabled BMN assumes that it's running on Ubuntu
and runs `sudo apt-get` to install packages.

The `create-database-in-container.sh` script makes it possible to create
databases in an Ubuntu container. This makes it possible to create databases on
non-Ubuntu OSes and without dependencies being installed globally on the host
OS.

### Prerequisites

- **SSH agent with GitHub access**: The container build clones the `semmle-code`
  repository via SSH. Ensure your SSH agent is running and has a key with access
  to `git@github.com:github/semmle-code.git`:
  ```sh
  eval $(ssh-agent)
  ssh-add ~/.ssh/your_github_key
  ```

### Usage

```sh
./container/create-database-in-container.sh ~/projects/my-cpp-project /tmp/my-database
```

To enable automatic dependency installation (runs `apt-get` inside the container):

```sh
./container/create-database-in-container.sh --install-dependencies ~/projects/my-cpp-project /tmp/my-database
```
