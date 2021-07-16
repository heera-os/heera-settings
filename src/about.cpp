#include "about.h"

#ifdef Q_OS_LINUX
#include <sys/sysinfo.h>
#elif defined(Q_OS_FREEBSD)
#include <sys/types.h>
#include <sys/sysctl.h>
#endif

#include <QDebug>

About::About(QObject *parent)
    : QObject(parent)
{
}

QString About::osName()
{
    return QSysInfo::prettyProductName();
}

QString About::kernelVersion()
{
    return QSysInfo::kernelVersion();
}

QString About::hostname()
{
    return QSysInfo::machineHostName();
}

QString About::userName()
{
    QByteArray userName = qgetenv("USER");

    if (userName.isEmpty())
        userName = qgetenv("USERNAME");

    return QString::fromUtf8(userName);
}

QString About::memorySize()
{
    QString ram;
    const qlonglong totalRam = calculateTotalRam();

    if (totalRam > 0) {
        ram = KFormat().formatByteSize(totalRam, 0);
    }
    return ram;
}

qlonglong About::calculateTotalRam() const
{
    qlonglong ret = -1;
#ifdef Q_OS_LINUX
    struct sysinfo info;
    if (sysinfo(&info) == 0)
        // manpage "sizes are given as multiples of mem_unit bytes"
        ret = qlonglong(info.totalram) * info.mem_unit;
#elif defined(Q_OS_FREEBSD)
    /* Stuff for sysctl */
    size_t len;

    unsigned long memory;
    len = sizeof(memory);
    sysctlbyname("hw.physmem", &memory, &len, NULL, 0);

    ret = memory;
#endif
    return ret;
}

QString About::cpuInfo()
{
    QString modelName = "unknown";
    QString siblings = "0";

    QFile file("/proc/cpuinfo");
    if (file.open(QIODevice::ReadOnly)) {
        QTextStream in(&file);
        for (QString line = in.readLine(); !line.isNull(); line = in.readLine()) {
            QStringList data = line.split(":");

            if (data[0] == "model name\t") {
                modelName = data[1].simplified();
            }
            if (data[0] == "siblings\t") {
                siblings = data[1].simplified();
            }
        }
        file.close();
    }

    modelName = modelName.replace("(R)", "®").replace("(TM)", "™");

    return QString("%1 × %2").arg(siblings, modelName);
}
