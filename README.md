# curl-http3

![actions](https://img.shields.io/github/workflow/status/gofort/curl-http3/ci)
![size](https://img.shields.io/docker/image-size/gofort/curl-http3/latest)

Curl Docker container compiled with HTTP/3 (h3/quic) support based on [this instruction](https://github.com/curl/curl/blob/master/docs/HTTP3.md).

## To Use
The Docker entrypoint is "curl", so simply pass any args to the docker command as you would curl. For example:
```
docker run -it gofort/curl-http3 --http3 https://www.google.com
```
Note that HTTP/3 occurs over UDP, so ensure your firewall is correctly setup.
