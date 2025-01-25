# WireGuard + Traefik + Authelia

Docker Compose stack to deploy a WireGuard VPN server ([wg-easy](https://github.com/wg-easy/wg-easy)), [Traefik](https://github.com/traefik/traefik) as a reverse proxy to access the `wg-easy` UI, and [Authelia](https://github.com/authelia/authelia) for authentication.

<p align="center">
    <img src="https://i.ibb.co/xjsHPnb/wireguard-logo-icon-168760.png" alt="WireGuard Logo" width="100"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <img src="https://i.ibb.co/nRDG8QV/1200px-Traefik-logo.png" alt="Traefik Logo" width="80"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <img src="https://i.ibb.co/GTQBtqM/logo-cropped.png" alt="Authelia Logo" width="100"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    <img src="https://i.ibb.co/TmPdT0D/watchtower.png" alt="Watchtower Logo" width="100"/>
</p>

## Deploy

1. Ensure Docker and Docker Compose plugin are installed.
2. Generate password hash for users in Authelia

```bash
docker run --rm authelia/authelia:latest \
authelia crypto hash generate argon2 \
--password 'my-password'
```

3. Update the Authelia users configuration in [./config/users_database.yml](./config/users_database.yml):

```yaml
users:
  your-user-name:
    disabled: false
    displayname: "Your Disaplay Name"
    password: "<generated-password-hash>"
    email: "root@localhost"
```

4. Obtain your DuckDNS token and export the following environmental variables:

```bash
export MY_PROVIDER="duckdns"
export MY_DOMAIN="mydomain.duckdns.org"
export DUCKDNS_TOKEN="MYTOKEN"
export PUID=$(id -u)
export PGID=$(id -g)

docker compose up -d
```

5. Once the stack is up and running, go to your domain (`${MY_DOMAIN}`), log in with your password, and click register as shown below:
<p align="center">
<img src="https://i.ibb.co/P4SMnb9/Screenshot-2024-07-21-at-17-00-46.png" alt="drawing" width="200"/>
</p>

6. After login, click "ADD" and it ask for OTP like below screenshot
<p align="center">
  <img src="https://i.ibb.co/T8fXGLY/1.png" alt="drawing" width="500"/>
</p>

7. Retrieve the first 2FA code at `config/notification.txt`.

   **NOTE:** This `config/notification.txt` is automatically created by Authelia. For example:

    ```bash
    cat config/notification.txt
    Date: 2024-07-21 14:55:11.30894104 +0000 UTC m=+43.154509640
    Recipient: {Test User authelia@authelia.com}
    Subject: Confirm your identity
    Hi Test User,
    
    This email has been sent to you in order to validate your identity. Purpose: Confirm your identity.
    
    If you did not initiate the process, your credentials might have been compromised and you should:
        1. Visit the revocation link.
        2. Reset your password or other login credentials.
        3. Contact an Administrator.
    
    To confirm your identity, please use the following single-use code: TXQAT55T
    
    This email was generated by a user with the IP XXXXXX.
    
    The following link can be used to revoke the code (this is a logged event): XXXX
    ```

8. Finally register the OTP in your favourite OTP App
<p align="center">
  <img src="https://i.ibb.co/rmxgzpk/3.png" alt="drawing" width="500"/>
</p>
