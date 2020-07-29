# Local SSL Certificates

```
Never, ever expose code-server directly to the internet without some form of authentication and encryption as someone can completely takeover your machine with the terminal.
```

This repository contain code-server running behind a nginx reverse-proxy configured to use SSL. In this directory, you can put your SSL certs.
You can generate an SSL certificate using any method yoy like. Playground has been tested with **Self Signed Certificate**.

**Recommended reading: https://security.stackexchange.com/a/8112.**

## Generating SSL Certificates

You can use [mkcert](https://github.com/FiloSottile/mkcert), which is a simple by design tool that hides all the arcane knowledge required to generate valid TLS certificates.

- First step is to download and install mkcert fo your platform.
    - It supports macOS, Linux, and Windows, and Firefox, Chrome and Java.
- After running ```mkcert -install```, you would see output similar to;
```
$ mkcert -install
Using the local CA at "/Users/filippo/Library/Application Support/mkcert" ✨
The local CA is now installed in the system trust store! ⚡️
```
- Now, to create a certificate run the following command;
```
$ mkcert [<list-of-names>]
Example:
$ mkcert example.com 192.168.99.100 localhost
```
- This will generate the required certificates for you.
- Update the certificate names in nginx/conf file, and we are good to go.