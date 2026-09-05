# User Administration - Linux

## Creating a User

```bash
sudo useradd -m -s /bin/bash alice
sudo passwd alice
```

What the flags do:
- `-m` — create a home directory (`/home/alice`)
- `-s /bin/bash` — set the login shell
- `passwd alice` — set the account's password (you'll be prompted twice)

## Common Extras

```bash
# Add a comment / full name
sudo useradd -m -c "Alice Smith" alice

# Give the user sudo/admin rights (Fedora uses the 'wheel' group)
sudo usermod -aG wheel alice

# Add to extra groups at creation time
sudo useradd -m -G wheel,docker alice
```

## Verify It Worked

```bash
id alice            # shows UID, GID, groups
getent passwd alice
```

## Notes

- On Fedora, members of the `wheel` group get sudo access by default — that's the standard way to make an admin user.
- There's also an interactive tool, `sudo adduser` (on Fedora it's just a symlink to `useradd`, so it behaves the same, not like Debian's interactive version).
- If you're on a desktop (GNOME), you can also do this via **Settings > System > Users > Add User**.

## Modifying a User

```bash
# Change username
sudo usermod -l newname oldname

# Change home directory (and move files)
sudo usermod -d /home/newname -m alice

# Lock an account (disable login without deleting)
sudo usermod -L alice

# Unlock an account
sudo usermod -U alice

# Change the login shell
sudo usermod -s /usr/sbin/nologin alice

# Set account expiration date
sudo usermod -e 2026-12-31 alice
```

## Deleting a User

```bash
# Remove user but keep their home directory
sudo userdel alice

# Remove user AND their home directory + mail spool
sudo userdel -r alice
```

## Managing Groups

```bash
# Create a new group
sudo groupadd developers

# Add a user to a group (append, don't replace)
sudo usermod -aG developers alice

# Remove a user from a group
sudo gpasswd -d alice developers

# List all groups a user belongs to
groups alice

# List all groups on the system
getent group
```

## Creating a Service Account (No Login)

```bash
# System account with no home dir and no login shell
sudo useradd -r -s /usr/sbin/nologin myservice
```

- `-r` — create a system account (UID below 1000, no aging info)
- `/usr/sbin/nologin` — prevents interactive login

## Useful Files

| File | Purpose |
|---|---|
| `/etc/passwd` | User account info (name, UID, GID, home, shell) |
| `/etc/shadow` | Encrypted passwords and aging info |
| `/etc/group` | Group definitions and memberships |
| `/etc/login.defs` | Defaults for UID/GID ranges, password aging |
| `/etc/skel/` | Skeleton files copied into new home directories |

## Password Management

```bash
# Force user to change password on next login
sudo passwd -e alice

# Set password aging (max 90 days, warn 7 days before)
sudo chage -M 90 -W 7 alice

# View password aging info
sudo chage -l alice
```

## Enabling SSH (Fedora)

```bash
# Install the SSH server (usually already installed)
sudo dnf install openssh-server

# Start and enable on boot in one command
sudo systemctl enable --now sshd

# Verify it's running
sudo systemctl status sshd

# Open the firewall port
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --reload
```

Connect from another machine:

```bash
ssh alice@<server-ip>
```
