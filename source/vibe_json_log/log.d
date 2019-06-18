module vibe_json_logger.logger;

private import vibe.core.log : Logger, LogLine, LogLevel;

/**
    JSON based logger for logging to regular files or stdout/stderr
*/
final class JSONLogger : Logger
{
    import std.stdio : File;
    import std.format : formattedWrite;

    private
    {
        File m_infoFile;
        File m_diagFile;
        File m_curFile;
    }

    this(File info_file, File diag_file)
    {
        m_infoFile = info_file;
        m_diagFile = diag_file;

        multilineLogger = true;
    }

    this(string filename)
    {
        auto f = File(filename, "ab");
        this(f, f);
    }

    this()
    {
        import std.stdio : stderr, stdout;

        this(stdout, stderr);
    }

    override void beginLine(ref LogLine msg) @safe
    {
        string pref;
        final switch (msg.level)
        {
        case LogLevel.trace:
            pref = "TRACE";
            m_curFile = m_diagFile;
            break;
        case LogLevel.debugV:
            pref = "DEBUG_VERBOSE";
            m_curFile = m_diagFile;
            break;
        case LogLevel.debug_:
            pref = "DEBUG";
            m_curFile = m_diagFile;
            break;
        case LogLevel.diagnostic:
            pref = "DIAGNOSTIC";
            m_curFile = m_diagFile;
            break;
        case LogLevel.info:
            pref = "INFO";
            m_curFile = m_infoFile;
            break;
        case LogLevel.warn:
            pref = "WARN";
            m_curFile = m_diagFile;
            break;
        case LogLevel.error:
            pref = "ERROR";
            m_curFile = m_diagFile;
            break;
        case LogLevel.critical:
            pref = "CRITICAL";
            m_curFile = m_diagFile;
            break;
        case LogLevel.fatal:
            pref = "FATAL";
            m_curFile = m_diagFile;
            break;
        case LogLevel.none:
            assert(false);
        }

        auto dst = m_curFile.lockingTextWriter;

        dst.put('{');
        dst.formattedWrite!(`"timestamp":"%s",`)(msg.time.toISOExtString);

        if (msg.threadName.length)
            dst.formattedWrite!(`"threadName":"%s",`)(msg.threadName);

        dst.formattedWrite!(`"threadID":"%08X",`)(msg.threadID);
        import vibe.core.task : Task;

        dst.put(`"taskID":"`);
        Task.getThis().getDebugID(dst);
        dst.put(`",`);
        dst.formattedWrite!(`"level":"%s",`)(pref);
        dst.formattedWrite!(`"file":"%s",`)(msg.file);
        dst.formattedWrite!(`"line":%d,`)(msg.line);

        dst.put(`"message":"`);
    }

    override void put(scope const(char)[] text) @safe
    {
        import std.array : replace;

        m_curFile.write(text.replace(`"`, `\"`));
    }

    override void endLine() @safe
    {
        m_curFile.writeln(`"}`);
        m_curFile.flush();
    }
}
