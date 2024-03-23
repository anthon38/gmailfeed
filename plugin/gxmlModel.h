/****************************************************************************
 *  Copyright (c) 2015 Anthony Vital <anthony.vital@gmail.com>              *
 *                                                                          *
 *  This file is part of Gmail Feed.                                        *
 *                                                                          *
 *  Gmail Feed is free software: you can redistribute it and/or modify      *
 *  it under the terms of the GNU General Public License as published by    *
 *  the Free Software Foundation, either version 3 of the License, or       *
 *  (at your option) any later version.                                     *
 *                                                                          *
 *  Gmail Feed is distributed in the hope that it will be useful,           *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of          *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
 *  GNU General Public License for more details.                            *
 *                                                                          *
 *  You should have received a copy of the GNU General Public License       *
 *  along with Gmail Feed.  If not, see <http://www.gnu.org/licenses/>.     *
 ****************************************************************************/

#ifndef GXMLMODEL_H
#define GXMLMODEL_H

#include <QAbstractListModel>
#include <QFutureWatcher>

typedef QList<QMap<QString, QString>> Data;
struct GMailData {
    Data data;
    int fullCount;
    bool isValid = false;
};

class GxmlModel : public QAbstractListModel
{
    Q_OBJECT

public:
    Q_PROPERTY(QString xml READ xml WRITE setXml NOTIFY xmlChanged)
    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(int fullcount READ fullcount NOTIFY fullcountChanged)
    Q_PROPERTY(int status READ status NOTIFY statusChanged)

    enum Status {
        Null,
        Ready,
        Loading,
        Error
    };
    Q_ENUMS(Status)

    enum GxmlRoles {
        AuthorRole = Qt::UserRole,
        TitleRole = Qt::UserRole + 1,
        LinkRole = Qt::UserRole + 2,
        IdRole = Qt::UserRole + 3
    };
    
    explicit GxmlModel(QObject *parent = 0);
    ~GxmlModel();

    QString xml() const {return m_xml;}
    int count() const {return m_data.size();}
    int fullcount() const {return m_fullcount;}
    int status() const {return m_status;}
    QHash<int, QByteArray> roleNames() const override;
    int rowCount(const QModelIndex & parent = QModelIndex()) const override;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const override;

    Q_INVOKABLE QString errorString() const {return m_errorString;}

Q_SIGNALS:
    void xmlChanged();
    void countChanged();
    void fullcountChanged();
    void statusChanged();
    void newMessage(QString author, QString title);
    void newMessages(int count);

private Q_SLOTS:
    void setXml(QString xml);
    void xmlParsed();

private:
    GMailData parseXml(QString xml);

    QString m_xml;
    int m_status;
    Data m_data;
    int m_fullcount;
    QString m_errorString;
    QFutureWatcher<GMailData> m_watcher;
};

#endif
