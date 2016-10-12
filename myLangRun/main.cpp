#include <QApplication>
#include <QQuickView>
#include "robotfile.h"
int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQuickView viewer;
    qmlRegisterSingletonType<RobotFile>("File", 1, 0, "File", &RobotFile::qmlSingleton);
    viewer.setSource(QUrl(QStringLiteral("qrc:/main.qml")));
    viewer.setTitle(QObject::tr("~Ballade2: LangRun University~"));
    viewer.show();

    return app.exec();
}
