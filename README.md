# Lock
Find sequention of states from initial to target with excluded for bike lock

## Installation

Clone this github repository:

```console
$ git clone git@github.com:AlexLOvch/lock.git
```

And then execute:
```console
$ bundle install
```

## Usage
Run unlock.rb with key -h to see help:
```console
$ ruby unlock.rb -h
```
You'll see help:
```console
Usage: unlock.rb [options]

Specific options:
    -f, --from FROM_COMBINATION      From combination. Mandatory. Example: -f 0,0,0
    -t, --to TO_COMBINATION          To combination. Mandatory. Example: -to 1,2,3
    -e, --excludes EXCLUDES_ARRAY    List of excluded combinations. Optional. Example: -e '[[1,2,1],[4,6,1]]'

Common options:
    -h, --help                       Show this message
```
Example of using:
```console
$ ruby unlock.rb -f 0,0,0 -t 1,1,1 -e '[[0,0,1], [1,0,0]]'
[[0, 0, 0], [0, 1, 0], [1, 1, 0], [1, 1, 1]]
```

To run specs type:
```console
$ rspec
```
