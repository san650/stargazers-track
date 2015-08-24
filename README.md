# Stargazers tracking

Store stagarzers data for a given project every twelve hours.

## Installation

Clone the project to a local folder

```sh
$ git clone https://github.com/san650/stargazers-track
```

## Usage

Open a terminal and run

```
$ cd stargazers-track/
$ ./track.sh san650 stargazers-track
```

Where the first parameter is the name of the user owning the project and the
second parameter is the name of the project.

After the script is run (by `at` command) an email is sent to the user (UNIX
mail).

## Prerequisites

This project depends on the following utilities

* `curl`
* `at`

Please be sure that both utilities are available on the system and that `at`
daemon is up and running (and that your user has permissions to use it).

## License

stargazers-track is licensed under the MIT license.

See [LICENSE](./LICENSE) for the full license text.
