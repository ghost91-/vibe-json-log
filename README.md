# vibe-json-log

A JSON based logger for [vibe-core].

## Usage

To use the logger in your [vibe-core] based project, simply register it as a
logger:

```D
import vibe.core.log : registerLogger;
import vibe-json-logger.logger : JSONLogger;

registerLogger(cast(shared) new JSONLogger());
```

The no argument constructor creates a `JSONLogger` that logs to `stdout` and
`stderr` depending on the loglevel. You can log to specific files using the
other overloads:

```D
import vibe-json-logger.logger : JSONLogger;
import std.stdio : File;

new JSONLogger(File("path/to/infoFile.log", "ab"), File("path/to/errorFile.log", "ab"));

new JSONLogger("path/to/logFile.log");

```

## Format

The format of the log messages is described in [log-message.schema.json]. Here
is an example of how a log message could look like:

```json
{
    "timestamp": "2019-06-17T23:47:42.6605845Z",
    "threadName": "main",
    "threadID": "A6A7AF69",
    "taskID": "Aud+-fin",
    "level": "TRACE",
    "file": "../../.dub/packages/vibe-core-1.6.2/vibe-core/source/vibe/core/sync.d",
    "line": 1047,
    "message": "emit shared done"
}
```

## Acknowledgement

This project is heavily based on the `FileLoger` which is distributed as part of
[vibe-core]. You can find the corresponding license [here][vibe-core-license].

[vibe-core]: https://github.com/vibe-d/vibe-core
[log-message.schema.json]: log-message.schema.json
[vibe-core-license]: https://github.com/vibe-d/vibe-core/blob/master/LICENSE.txt
