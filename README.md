
# The PHP Repl

## Motivation

I wanted to offer an PHP REPL like what Mr Joel Kemp offers, but less sandboxed, and with a PHP7 runtime. The idea is to use OS-level permissions, and Docker to provide the safety, while allowing greater usage of unsafe PHP commands.

## Sandboxing

Sandboxing should in the future use [Runkit_Sandbox](http://php.net/manual/en/runkit.sandbox.php) but currently uses [PHP-Sandbox](https://github.com/fieryprophet/php-sandbox).

## Getting Started

```shell
$ docker-machine start default # or whatever machine you want
$ bash build.sh
$ bash run.sh
```

